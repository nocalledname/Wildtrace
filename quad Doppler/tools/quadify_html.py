#!/usr/bin/env python3
"""把 stereo wildtrace 的 Cabbage3 index.html 改成四声道版。

只做四件机械的事：
  1. <title> / 顶栏 tag
  2. 2 只电平表 -> 4 只（左 FL/RL，右 FR/RR）
  3. 追加 .mside / .bar 高度覆盖的 CSS
  4. 标尺 id 数组 / 电平 case / 初值调用（由调用方给出的精确片段替换）

每一步都断言命中，命中不到直接抛错 —— 绝不静默生成半成品。
"""
import json
import re
import sys
from pathlib import Path

CFG = {
    # ---- Family A：.stage 是 flex 行，metercol 静态排布 ----
    "orbita": dict(
        family="A", tag="Quad Doppler",
        mside_css="display: flex; flex-direction: column; justify-content: space-between; height: 182px; flex: none;",
        bar_h=72,
    ),
    "levy": dict(
        family="A", tag="Quad Doppler",
        mside_css="display: flex; flex-direction: column; justify-content: space-between; height: 176px; flex: none;",
        bar_h=70,
    ),
    "lissajous": dict(
        family="A", tag="Quad Doppler",
        mside_css="display: flex; flex-direction: column; justify-content: space-between; height: 200px; flex: none;",
        bar_h=78,
    ),
    # ---- Family B：metercol 绝对定位 ----
    "loom": dict(
        family="B", tag="Quad Doppler",
        mside_top=104, mside_h=326, mside_left=14, mside_right=14, bar_h=None,
    ),
    "zephyr": dict(
        family="B", tag="Quad Doppler",
        mside_top=104, mside_h=326, mside_left=14, mside_right=14, bar_h=None,
    ),
    "singularity": dict(
        family="B", tag="Quad Doppler",
        mside_top=46, mside_h=388, mside_left=5, mside_right=5, bar_h=172,
    ),
    "swarmgrain": dict(
        family="B", tag="Quad Doppler",
        mside_top=108, mside_h=262, mside_left=470, mside_right=18, bar_h=None,
    ),
    "boids": dict(
        family="B", tag="Quad Doppler",
        mside_top=74, mside_h=590, mside_left=486, mside_right=18, bar_h=None,
    ),
}

LABELS = {"L": "FL", "R": "FR"}
SIDES = {"l": ("FL", "RL"), "r": ("FR", "RR")}


def one(pattern, repl, text, what, flags=0):
    new, n = re.subn(pattern, repl, text, count=1, flags=flags)
    if n != 1:
        raise SystemExit(f"  ✗ 未命中：{what}")
    return new


def meter_body(idp, mirror, pad):
    cls = "meterbody mirror" if mirror else "meterbody"
    p = " " * pad
    return f"""{p}    <div class="{cls}">
{p}        <div class="bar"><i id="mtr{idp}"></i><b id="cap{idp}"></b></div>
{p}        <div class="dbscale" id="scale{idp}"></div>
{p}    </div>"""


def convert_markup(html, cfg, key):
    """把 2 组电平表换成 4 组。"""
    if cfg["family"] == "A":
        # 两组：<div class="metercol"> ... </div>，按出现顺序 = 左、右
        blocks = list(re.finditer(
            r'[ ]*<div class="metercol"[^>]*>\s*<span[^>]*>[LR]</span>\s*<div class="meterbody[^"]*">.*?\n    </div>',
            html, re.S))
        if len(blocks) != 2:
            raise SystemExit(f"  ✗ {key}: 预期 2 个 metercol，实际 {len(blocks)}")
        for m, side in zip(reversed(blocks), ("r", "l")):
            ids = SIDES[side]
            mirror = " mirror" if side == "r" else ""
            body = "\n".join(
                f"""        <div class="metercol">
            <span>{lab}</span>
{meter_body(i, mirror, 8)}
        </div>""" for lab, i in zip(("FL", "RL") if side == "l" else ("FR", "RR"), ids))
            new = f"""    <div class="mside {'left' if side == 'l' else 'right'}">
{body}
    </div>"""
            html = html[:m.start()] + new + html[m.end():]
        return html

    # Family B：<div class="metercol l"> 与 r
    for side in ("l", "r"):
        pat = (r'[ ]*<div class="metercol ' + side +
               r'">\s*<(?:span|div)(?: class="(?:mlab|lb)")?>[LR]</(?:span|div)>\s*'
               r'<div class="meterbody[^"]*">.*?\n    </div>')
        m = re.search(pat, html, re.S)
        if not m:
            raise SystemExit(f"  ✗ {key}: 未找到 {side} 侧 metercol")
        labs = ("FL", "RL") if side == "l" else ("FR", "RR")
        ids = SIDES[side]
        mirror = " mirror" if side == "r" else ""
        # 沿用原文件的标签元素写法（span / div.lb）
        span_tag = "div" if '<div class="lb"' in m.group(0) else "span"
        span_cls = ' class="lb"' if span_tag == "div" else ""
        body = "\n".join(
            f"""        <div class="metercol">
            <{span_tag}{span_cls}>{lab}</{span_tag}>
{meter_body(i, mirror, 8)}
        </div>""" for lab, i in zip(labs, ids))
        new = f"""    <div class="mside {'l' if side == 'l' else 'r'}">
{body}
    </div>"""
        html = html[:m.start()] + new + html[m.end():]
    return html


def add_css(html, cfg, key):
    if cfg["family"] == "A":
        css = f"""
    /* ===== 四声道电平表：左 FL/RL、右 FR/RR（左柱内、刻度外；右表镜像） ===== */
    .mside {{ {cfg['mside_css']} }}
    .mside .metercol {{ position: static; }}
"""
    else:
        css = f"""
    /* ===== 四声道电平表：左 FL/RL、右 FR/RR（贴场景两侧，上下分置） ===== */
    .mside {{
        position: absolute;
        top: {cfg['mside_top']}px;
        height: {cfg['mside_h']}px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        z-index: 4;
        pointer-events: none;
    }}
    .mside.l {{ left: {cfg['mside_left']}px; align-items: flex-start; }}
    .mside.r {{ right: {cfg['mside_right']}px; align-items: flex-end; }}
    .mside .metercol {{ position: static; top: auto; }}
"""
    if cfg.get("bar_h"):
        css += f"""    .bar {{ height: {cfg['bar_h']}px; }}
    .dbscale {{ height: {cfg['bar_h']}px; }}
"""
    return one(r"\n</style>", css + "</style>", html, "插入 CSS")


def main(project, key):
    cfg = CFG[key]
    idx = Path("/Users/yhk/Documents/csound/wildtrace/quad Doppler") / project / "index.html"
    html = idx.read_text(encoding="utf-8")

    name = re.search(r"<title>([^<]*)</title>", html).group(1)
    print(f"  · 源 title = {name}")

    html = convert_markup(html, cfg, key)
    html = add_css(html, cfg, key)

    # 顶栏 tag：把 Depth Render 之类的副标题换成 Quad Doppler
    html, n = re.subn(r'(<span class="tag">)[^<]*(</span>)', r"\1" + cfg["tag"] + r"\2", html, count=1)
    if n != 1:
        # Boids / SwarmGrain 等用 hdr 结构，tag 是 div
        html, n = re.subn(r'(<div class="sub">)[^<]*(</div>)', r"\1" + cfg["tag"] + r"\2", html, count=1)
    if n != 1:
        html, n = re.subn(r'(<div class="tag"[^>]*>)[^<]*(</div>)', r"\1" + cfg["tag"] + r"\2", html, count=1)
    if n != 1:
        raise SystemExit(f"  ✗ {key}: 未找到副标题节点")

    # 标尺 id 数组 2 -> 4
    pat = "['scaleL', 'scaleR']"
    if pat in html:
        html = html.replace(pat, "['scaleFL', 'scaleFR', 'scaleRL', 'scaleRR']")
    elif "['scaleL','scaleR']" in html:
        html = html.replace("['scaleL','scaleR']", "['scaleFL','scaleFR','scaleRL','scaleRR']")
    else:
        raise SystemExit(f"  ✗ {key}: 未找到标尺 id 数组")

    idx.write_text(html, encoding="utf-8")
    print(f"  ✓ {key}: markup / CSS / tag 完成")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
