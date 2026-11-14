#!/usr/bin/env python3
"""极端值压测：把参数推到量程边界，检查 NaN / 爆值 / 越界。

做法：临时改**已部署**的 CSD（~/Library/CabbageAudio/<NAME>/）里的 defaultValue，
逐组跑 aurender，然后按 sha1 精确还原。跑完必须还原，否则下次打开插件就变默认值了。

判定：
  · aurender 打印 "!! 有 NaN / 爆值"  → 失败
  · 日志 "samples out of range" > 0    → 失败
  · 四路 RMS 出现 inf/nan              → 失败
  · RMS 全都 < 1e-5（被推到完全静音）   → 警告（可能是参数语义问题）
"""
import hashlib
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOOLS = ROOT / "tools"
RUNTIME = Path.home() / "Library/CabbageAudio"

PLUGINS = {
    "Q3ST": "Cab3-Quad-Stasis",
    "Q3OB": "Cab3-Quad-Orbita",
    "Q3LV": "Cab3-Quad-Levy",
    "Q3LM": "Cab3-Quad-Loom",
    "Q3ZP": "Cab3-Quad-Zephyr",
    "Q3SG": "Cab3-Quad-Singularity",
    "Q3SW": "Cab3-Quad-SwarmGrain",
    "Q3BD": "Cab3-Quad-Boids",
    "Q3LJ": "Cab3-Quad-Lissajous",
}

# 通用边界 + 各插件专有边界
COMMON = [
    ("全最湿 + 最大房间", {"minWet": 1, "maxWet": 1, "roomSize": 100, "cutoff": 1000}),
    ("全干 + 最小房间", {"minWet": 0, "maxWet": 0, "roomSize": 10, "cutoff": 16000}),
    ("增益拉满", {"masterGain": 8}),
]
EXTRA = {
    "Q3OB": [("最快轨道", {"speed": 20}), ("最大半径", {"radius": 0.5}),
             ("Shape=0 退化线段", {"Shape": 0})],
    "Q3LV": [("最快跳跃", {"rate": 20, "alpha": 0.3, "scale": 1}),
             ("最长滑行", {"inertia": 0.4, "chaos": 0.08})],
    "Q3LM": [("10×10 + 最大 warp", {"rows": 10, "cols": 10, "warp": 20, "speed": 10}),
             ("最小网格", {"rows": 1, "cols": 1, "glide": 0.001})],
    "Q3ZP": [("最短 fall", {"fallTime": 0.1}), ("最长 fall", {"fallTime": 600}),
             ("最大漂移", {"drift": 0.5, "dfreq": 10, "jitter": 0.2})],
    "Q3SG": [("最短 fall", {"fallTime": 0.1}), ("最长 fall", {"fallTime": 600}),
             ("最大重力 + 最大输入", {"gravityCurve": 5, "inputGain": 4, "dopplerFactor": 100})],
    "Q3SW": [("最大密度 + 最大颗粒", {"Dens": 500, "GSize": 1, "DlyMax": 5}),
             ("截止上下限夹死", {"rangeMin": 20, "rangeMax": 20}),
             ("最大场半径", {"radius": 0.5, "step": 0.5})],
    "Q3BD": [("反馈拉满", {"feedback": 0.95}), ("最长延迟", {"delay_base": 2000}),
             ("音高全推", {"m1": 50, "m2": 50, "m3": 50, "m4": 50, "m5": 50, "m6": 50, "m7": 50}),
             ("衰减最小", {"Flock_Decay": 0})],
    "Q3ST": [("雷达极限角", {"x": 0.001, "y": 0.999})],
    "Q3LJ": [("最快 + 最大比", {"rate": 20, "ratio": 8, "chaos": 0.05}),
             ("音频轴 L/M", {"xsrc": 1, "ysrc": 3, "inGain": 4}),
             ("零速", {"rate": 0, "scale": 0})],
    "Q3LM2": [],
}
LEVEL = {"Q3SW": "level", "Q3BD": "vol"}


def sha(p):
    return hashlib.sha1(p.read_bytes()).hexdigest()


def parse(out):
    rms, nan, bad = [], False, False
    m = re.search(r"正中[^\n]*\n((?:\s*(?:FL|FR|RL|RR)\s*=\s*[0-9.]+\n){1,4})", out)
    if m:
        rms = [float(x) for x in re.findall(r"=\s*([0-9.]+)", m.group(1))]
    if "!! 有 NaN / 爆值" in out:
        nan = True
    if re.search(r"samples out of range:\s*[1-9]", out):
        bad = True
    return rms, nan, bad


def set_defaults(csd_text, vals):
    cfg_m = re.search(r"(<Cabbage>\n)(.*?)(</Cabbage>)", csd_text, re.S)
    cfg = json.loads(cfg_m.group(2))
    for w in cfg["widgets"]:
        if not w.get("channels"):
            continue
        ch = w["channels"][0]
        if ch["id"] in vals:
            ch["range"]["defaultValue"] = vals[ch["id"]]
    body = json.dumps(cfg, indent=4, ensure_ascii=False)
    return csd_text[:cfg_m.start(2)] + body + csd_text[cfg_m.end(2):]


def main(only=None):
    fails = 0
    for pid, name in PLUGINS.items():
        if only and pid not in only:
            continue
        csd = RUNTIME / name / f"{name}.csd"
        if not csd.exists():
            print(f"✗ {pid} 未部署: {csd}")
            fails += 1
            continue
        orig = csd.read_bytes()
        orig_hash = sha(csd)
        cases = list(COMMON)
        for label, vals in EXTRA.get(pid, []):
            cases.append((label, vals))
        # 增益通道名不同的插件，把 common 的 masterGain 换成自己的
        if pid in LEVEL:
            cases = [(l, {("level" if k == "masterGain" else k): v for k, v in vv.items()})
                     for l, vv in cases]

        print(f"── {pid} {name}")
        for label, vals in cases:
            try:
                csd.write_text(set_defaults(orig.decode("utf-8"), vals), encoding="utf-8")
                out = subprocess.run([TOOLS / "aurender", pid, "4"],
                                     capture_output=True, text=True).stdout
                rms, nan, bad = parse(out)
                ok = not nan and not bad and all(x == x and x != float("inf") for x in rms)
                peak = max(rms) if rms else 0.0
                flag = "✓" if ok else "✗"
                if not ok:
                    fails += 1
                note = ""
                if ok and peak > 1.0:
                    note = f"  ← 峰值 {peak:.2f} > 1.0（有削顶风险）"
                if ok and peak < 1e-5:
                    note = "  ← 几乎全静音"
                print(f"   {flag} {label:<22} RMS "
                      f"{'/'.join(f'{x:.4f}' for x in rms) if rms else '—'}"
                      f"{'  NaN!' if nan else ''}{'  越界!' if bad else ''}{note}")
            finally:
                csd.write_bytes(orig)
        assert sha(csd) == orig_hash, f"✗ {name} CSD 未正确还原！"
        print(f"   · CSD 已还原 (sha1 {orig_hash[:8]})")

    print(f"\n{'全部通过' if not fails else f'{fails} 组存在问题'}")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:] or None))
