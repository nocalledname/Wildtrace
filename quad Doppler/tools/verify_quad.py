#!/usr/bin/env python3
"""导出后验证：对每台插件跑 auprobe + aurender，确认「四声道真的通了」。

用法：
    python3 tools/verify_quad.py            # 验全部 8 台
    python3 tools/verify_quad.py Q3OB Q3LV  # 只验指定 ID

判定标准（缺一条就算失败）：
  1. auprobe 报 `caps[0]: in 4, out 4` 且 `SET OUT 4 ch` 成功
     （输入也是 4：CSD 只写 nchnls = 4，Csound 让 nchnls_i = 4；
       2 in / 4 out 会让 VST3 在 Live 里初始化失败）
  2. aurender 渲染时四路 RMS 全部 > 0（不是只有前两路出声）
  3. 渲染日志没有 COMPILE ERROR / CSD file not found / Excess channels ignored
"""
import re
import subprocess
import sys
from pathlib import Path

TOOLS = Path(__file__).resolve().parent

PLUGINS = [
    ("Q3ST", "Cab3-Quad-Stasis"),
    ("Q3OB", "Cab3-Quad-Orbita"),
    ("Q3LV", "Cab3-Quad-Levy"),
    ("Q3LM", "Cab3-Quad-Loom"),
    ("Q3ZP", "Cab3-Quad-Zephyr"),
    ("Q3SG", "Cab3-Quad-Singularity"),
    ("Q3SW", "Cab3-Quad-SwarmGrain"),
    ("Q3BD", "Cab3-Quad-Boids"),
    ("Q3LJ", "Cab3-Quad-Lissajous"),
]

BAD = re.compile(r"COMPILE ERROR|CSD file not found|Excess channels ignored", re.I)


def probe(pid):
    out = subprocess.run([TOOLS / "auprobe", pid, "4"],
                         capture_output=True, text=True).stdout
    caps = re.search(r"caps\[0\]: in (\d+), out (\d+)", out)
    ok_set = "SET OUT 4 ch -> 0 OK" in out
    ok_read = "readback: 4 ch" in out
    return (caps.group(1, 2) if caps else None), ok_set, ok_read, out


def render(pid):
    out = subprocess.run([TOOLS / "aurender", pid, "4"],
                         capture_output=True, text=True).stdout
    # aurender 为每个位置打印 "FL = 0.1234" 四行；取「正中」那组当代表，
    # 同时把所有位置的峰值汇总，避免某个位置恰好静音就误判。
    amps = []
    m = re.search(r"正中[^\n]*\n((?:\s*(?:FL|FR|RL|RR)\s*=\s*[0-9.]+\n){1,4})", out)
    if m:
        amps = [float(x) for x in re.findall(r"=\s*([0-9.]+)", m.group(1))]
    if not amps:
        peaks = [0.0] * 4
        for idx, ch in enumerate(("FL", "FR", "RL", "RR")):
            vals = [float(v) for v in re.findall(rf"\b{ch}\s*=\s*([0-9.]+)", out)]
            peaks[idx] = max(vals) if vals else 0.0
        amps = peaks
    return amps, out


def main(ids):
    rows = []
    fails = 0
    for pid, name in PLUGINS:
        if ids and pid not in ids:
            continue
        caps, ok_set, ok_read, pout = probe(pid)
        amps, rout = render(pid)
        bad = BAD.search(rout)

        ch_ok = caps == ("4", "4") and ok_set and ok_read
        amp_ok = len(amps) == 4 and all(a > 0.0005 for a in amps)
        err_ok = bad is None
        ok = ch_ok and amp_ok and err_ok
        fails += 0 if ok else 1

        amp_s = "/".join(f"{a:.4f}" for a in amps) if amps else "—"
        flags = "".join([
            "C" if ch_ok else "c",
            "A" if amp_ok else "a",
            "E" if err_ok else "e",
        ])
        rows.append((("✓" if ok else "✗"), pid, name, amp_s, flags,
                     bad.group(0) if bad else ""))
        print(f"{rows[-1][0]} {pid}  {name:<24} RMS {amp_s:<30} [{flags}]"
              + (f"  ← {bad.group(0)}" if bad else ""))
    print(f"\n{len(rows) - fails}/{len(rows)} 通过"
          f"   （C=能力表 4 出 A=四路有信号 E=无报错）")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
