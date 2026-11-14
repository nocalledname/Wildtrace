#!/usr/bin/env python3
"""把四声道 index.html 的电平表 JS 接到 4 个通道上。

配合 quadify_html.py 使用（那个改 markup/CSS，这个改 JS）。
每步都断言命中，避免出现「只改了 markup、JS 还在读 outL」的半成品。
"""
import re
import sys
from pathlib import Path

# key, 目录, 新标题, METER_H（None = 保持）
CFG = {
    "levy":        ("Quad-Levy Cabbage3",        "Cab3-Quad-Levy",        70),
    "loom":        ("Quad-Loom Cabbage3",        "Cab3-Quad-Loom",        None),
    "zephyr":      ("Quad-Zephyr Cabbage3",      "Cab3-Quad-Zephyr",      None),
    "singularity": ("Quad-Singularity Cabbage3", "Cab3-Quad-Singularity", 172),
    "swarmgrain":  ("Quad-SwarmGrain Cabbage3",  "Cab3-Quad-SwarmGrain",  None),
    "boids":       ("Quad-Boids Cabbage3",       "Cab3-Quad-Boids",       None),
    "lissajous":   ("Quad-Lissajous Cabbage3",   "Cab3-Quad-Lissajous",   78),
}

GLOW = """function updateGlow() {
    const lv = Math.max(lvlFL, lvlFR, lvlRL, lvlRR);
    document.documentElement.style.setProperty('--lvl', lv.toFixed(3));
}"""


def cases(glow):
    out = []
    for ch, var, g in (("FL", "lvlFL", False), ("FR", "lvlFR", False),
                       ("RL", "lvlRL", True), ("RR", "lvlRR", True)):
        body = f"""        case 'out{ch}':
            {var} = setMeter('mtr{ch}', 'cap{ch}', v);
"""
        if glow:
            body += "            updateGlow();\n"
        body += "            break;"
        out.append(body)
    return "\n".join(out)


def main(key):
    folder, title, meter_h = CFG[key]
    p = Path("/Users/yhk/Documents/csound/wildtrace/quad Doppler") / folder / "index.html"
    s = p.read_text(encoding="utf-8")

    def need(pat, repl, what, flags=0, count=1):
        nonlocal s
        s2, n = re.subn(pat, repl, s, count=count, flags=flags)
        assert n == count, f"✗ {key}: {what} 命中 {n} 次（期望 {count}）"
        s = s2

    need(r"<title>[^<]*</title>", f"<title>{title}</title>", "title")
    if meter_h:
        need(r"const METER_H = \d+", f"const METER_H = {meter_h}", "METER_H")

    if "['scaleL', 'scaleR']" in s:      # quadify_html.py 通常已经替换过
        need(r"\['scaleL', 'scaleR'\]", "['scaleFL', 'scaleFR', 'scaleRL', 'scaleRR']", "标尺数组")
    if "let lvlL = 0, lvlR = 0;" in s:
        need(r"let lvlL = 0, lvlR = 0;",
             "let lvlFL = 0, lvlFR = 0, lvlRL = 0, lvlRR = 0;", "电平变量")

    glow = "function updateGlow(l, r) {" in s
    if glow:
        need(r"function updateGlow\(l, r\) \{.*?\n\}", GLOW, "updateGlow", re.S)

    need(r"[ \t]*case 'outL':.*?break;", cases(glow), "outL case", re.S)
    need(r"[ \t]*case 'outR':.*?break;", "", "outR case（已并入 outFL..RR）", re.S)

    need(r"[ \t]*setMeter\('mtrL', 'capL', 0\);\n",
         "setMeter('mtrFL', 'capFL', 0);\nsetMeter('mtrFR', 'capFR', 0);\n"
         "setMeter('mtrRL', 'capRL', 0);\nsetMeter('mtrRR', 'capRR', 0);\n", "初值 1/4")
    need(r"[ \t]*setMeter\('mtrR', 'capR', 0\);\n", "", "初值 2/4")
    if glow and "updateGlow(0, 0);" in s:
        need(r"updateGlow\(0, 0\);", "updateGlow();", "初值 glow")

    p.write_text(s, encoding="utf-8")
    print(f"✓ {folder}")


if __name__ == "__main__":
    for k in sys.argv[1:]:
        main(k)
