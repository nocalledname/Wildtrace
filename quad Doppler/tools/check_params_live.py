#!/usr/bin/env python3
"""活体参数核对：问已安装的 AU 要参数表，与 HTML 的 PARAM_IDX / P 表逐项比对。

只读源码查不出「宿主里拧 cutoff 却动了 roomSize」这类问题 —— 必须问二进制。
数据来源：auprobe 启动时会打印 Cabbage 注册每个参数的序号、min/max/default。
"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOOLS = ROOT / "tools"

PLUGINS = [
    ("Q3ST", "Quad-Stasis Cabbage3"),
    ("Q3OB", "Quad-Orbita Cabbage3"),
    ("Q3LV", "Quad-Levy Cabbage3"),
    ("Q3LM", "Quad-Loom Cabbage3"),
    ("Q3ZP", "Quad-Zephyr Cabbage3"),
    ("Q3SG", "Quad-Singularity Cabbage3"),
    ("Q3SW", "Quad-SwarmGrain Cabbage3"),
    ("Q3BD", "Quad-Boids Cabbage3"),
    ("Q3LJ", "Quad-Lissajous Cabbage3"),
]

ADD = re.compile(r"Added parameter for channel '([^']+)'.*parameterIndex (\d+)")
CREAT = re.compile(r"Creating parameter '([^']+)'.*min=([-\d.e+]+), max=([-\d.e+]+), "
                   r"default=([-\d.e+]+)")
NUM = re.compile(r"Created numeric channel for non-automatable widget '([^']+)'")


def audit(pid, folder):
    proj = ROOT / folder
    html = (proj / "index.html").read_text(encoding="utf-8")
    csd = next(proj.glob("*.csd"))
    cfg = json.loads(re.search(r"<Cabbage>(.*?)</Cabbage>",
                               csd.read_text(encoding="utf-8"), re.S).group(1))
    widgets = [w for w in cfg["widgets"] if w.get("channels")]
    csd_auto = [w["channels"][0]["id"] for w in widgets if w.get("automatable")]
    csd_range = {w["channels"][0]["id"]: w["channels"][0]["range"] for w in widgets
                 if w.get("automatable")}
    csd_hidden = [w["channels"][0]["id"] for w in widgets if not w.get("automatable")]

    out = subprocess.run([TOOLS / "auprobe", pid, "4"],
                         capture_output=True, text=True).stdout
    if "caps[0]" not in out:
        return [f"无法加载（auprobe 无输出或插件未装）"]

    live = sorted(((int(i), ch) for ch, i in ADD.findall(out)))
    live_ch = [ch for _, ch in live]
    live_range = {ch: (float(a), float(b), float(c)) for ch, a, b, c in CREAT.findall(out)}
    live_hidden = set(NUM.findall(out))

    issues = []
    if live_ch != csd_auto:
        issues.append(f"参数顺序与 CSD 不符\n      live={live_ch}\n      csd ={csd_auto}")

    idx = re.findall(r"'([^']+)'", re.search(r"const PARAM_IDX = \[(.*?)\];", html, re.S).group(1))
    if idx != live_ch and idx != [w["channels"][0]["id"] for w in widgets]:
        issues.append(f"PARAM_IDX 与实际注册顺序不符\n      idx ={idx}\n      live={live_ch}")

    for ch, (mn, mx, df) in live_range.items():
        r = csd_range.get(ch)
        if not r:
            continue
        for label, a, b in (("min", mn, r["min"]), ("max", mx, r["max"]),
                            ("default", df, r.get("defaultValue"))):
            if b is not None and abs(a - float(b)) > 1e-6:
                issues.append(f"{ch}.{label} 宿主={a} CSD={b}")

    missing_hidden = [c for c in csd_hidden if c not in live_hidden]
    if missing_hidden:
        issues.append(f"隐藏通道没注册: {', '.join(missing_hidden)}")

    return issues


def main():
    bad = 0
    for pid, folder in PLUGINS:
        issues = audit(pid, folder)
        if issues:
            bad += 1
            print(f"✗ {pid} {folder}")
            for i in issues:
                print(f"   {i}")
        else:
            print(f"✓ {pid} {folder}")
    print(f"\n{len(PLUGINS) - bad}/{len(PLUGINS)} 参数契约一致")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
