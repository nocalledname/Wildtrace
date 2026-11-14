#!/usr/bin/env python3
"""把头部图标统一成「算法制图」版（野痕系列）。

同时覆盖两套目录：
    quad Doppler/Quad-<X> Cabbage3/      （四声道）
    stereo wildtrace/<X> Cabbage3/       （立体声 / depth）

- 每个图标是 16×16 网格上的一句话，画的是该插件自己的算法结构
- 统一制图语言：1.0~1.2px 等宽线、圆头收口、只有一颗大实心点代表当前声源
- 颜色取各前端自己的强调色，内联写死（不依赖 CSS 变量，避免被标题色吃掉）
- 图标尺寸统一 13×13，内联 style 覆盖各文件原本 11/12/13px 的差异

用法：
    python3 tools/apply_icons.py              # 只改 quad 8 台
    python3 tools/apply_icons.py --stereo      # 只改 depth 9 台
    python3 tools/apply_icons.py --all         # 两套都改
    python3 tools/apply_icons.py --dry-run     # 只看会改什么
"""
import math
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent          # quad Doppler
STEREO = ROOT.parent / "stereo wildtrace"

W = 'style="width:13px;height:13px;flex:none;display:block"'


def svg(inner: str) -> str:
    return (f'<svg class="mark" viewBox="0 0 16 16" fill="none" aria-hidden="true" {W}>\n'
            f'{inner}</svg>')


def dot(c, x=8, y=8, r=1.7):
    return f'  <circle cx="{x}" cy="{y}" r="{r}" fill="{c}"/>\n'


# ---------------- 各台图标 ----------------
def icon_stasis(c):
    """等距场：一圈距离环 + 静止的源"""
    return svg(f'  <circle cx="8" cy="8" r="5.9" stroke="{c}" stroke-width="1"/>\n'
               + dot(c))


def icon_orbita(c):
    """轨道：闭合椭圆 + 在轨的点"""
    return svg(f'  <ellipse cx="8" cy="8" rx="6.1" ry="3.9" stroke="{c}" stroke-width="1" '
               f'transform="rotate(-30 8 8)"/>\n'
               + dot(c, 12.4, 5.0))


def icon_levy(c):
    """长尾跃迁：步长递增，末段是长跳"""
    return svg(f'  <path d="M2.8 12.9 4.3 11.6 3.9 10.2 6.9 9.6 6.2 7.4 13.3 2.9" '
               f'stroke="{c}" stroke-width="1" stroke-linejoin="round" '
               f'stroke-linecap="round"/>\n'
               + dot(c, 13.3, 2.9))


def icon_loom(c):
    """蛇形穿梭：两端带水平钩的 S（钩 = 走梭折返）"""
    return svg(f'  <path d="M12.9 3.3H9.4C6.4 3.3 6.2 7.7 8.6 8C11 8.3 10.8 12.7 7.8 12.7H3.1" '
               f'stroke="{c}" stroke-width="1" stroke-linecap="round"/>\n'
               + dot(c, 3.1, 12.7))


def icon_singularity(c):
    """对数螺旋：半径指数增长，开放、不挤在中心"""
    d, t = '', 0.0
    while t <= 2.55:
        r = 1.2 * math.exp(0.60 * t)
        if r > 7.1:
            break
        a = t * 2.05 - math.pi * 0.5
        d += ('L' if d else 'M') + f'{8 + r * math.cos(a):.2f} {8 + r * math.sin(a):.2f}'
        t += 0.06
    return svg(f'  <path d="{d}" stroke="{c}" stroke-width="1" stroke-linecap="round" '
               f'stroke-linejoin="round"/>\n'
               + dot(c, 8, 8, 1.35))


def icon_zephyr(c):
    """流线场：两条流线 + 声源落在它们之间的通道里（点压在线上会糊）"""
    return svg(f'  <path d="M1.6 10.9C4.4 5.6 9.4 2.9 14.4 4.4" stroke="{c}" '
               f'stroke-width="1" stroke-linecap="round"/>\n'
               f'  <path d="M4.4 13.6C6.9 11.2 9.9 10.1 13.2 10.2" stroke="{c}" '
               f'stroke-width="1" stroke-linecap="round" opacity=".42"/>\n'
               + dot(c, 8.1, 8.0, 1.6))


def icon_swarmgrain(c):
    """高斯散布：中心密、边缘疏，点径递减"""
    pts = [(8, 8, 1.7), (5.2, 6.6, 1.15), (10.7, 9.6, 1.15), (8.1, 11.6, .95),
           (10.9, 4.6, .95), (3.6, 11.2, .8), (12.6, 8.2, .8)]
    return svg(''.join(dot(c, x, y, r) for x, y, r in pts))


def icon_boids(c):
    """准星鸟：直接取 Boids pad 里头鸟的真实几何（翼形 + 机身线），0° 头朝上。

    pad 里是局部坐标（翼展 2、体长 0.88，机头朝 -Y），这里用 scale(7.2) 装进 16 网格。
    注意 g 上有 scale，子路径的 stroke-width 会被放大 7.2 倍，所以要反算：
        0.167 × 7.2 ≈ 1.2 viewBox 单位  → 13px 下 ≈ 1px
        0.125 × 7.2 =  0.9 viewBox 单位（机身线，半透明）
    """
    wing = ('M-1 0.600 C-0.600 0.140 -0.200 0.070 0 -0.040 '
            'C0.200 0.070 0.600 0.140 1 0.600')
    body = 'M0 -0.42 L0 0.46'
    return svg(f'  <g transform="translate(8 8) scale(7.2)" stroke="{c}" '
               f'stroke-linecap="round" stroke-linejoin="round">\n'
               f'    <path d="{wing}" stroke-width="0.167"/>\n'
               f'    <path d="{body}" stroke-width="0.125" opacity=".55"/>\n'
               f'  </g>\n')


def icon_lissajous(c):
    """李萨如：x = sin(t), y = sin(2t) 的 8 字形（就是它的振荡方程本身）"""
    pts = []
    for i in range(49):
        t = i / 48 * 2 * math.pi
        pts.append((8 + 5.6 * math.sin(t), 8 + 3.7 * math.sin(2 * t)))
    d = 'M' + ' L'.join(f'{x:.2f} {y:.2f}' for x, y in pts)
    return svg(f'  <path d="{d}" stroke="{c}" stroke-width="1" stroke-linejoin="round" '
               f'stroke-linecap="round"/>\n'
               + dot(c, 8, 8, 1.35))


# ---------------- 目录 → (颜色, 图标) ----------------
# 颜色一律取各前端自己的强调色，不新造色
QUAD = {
    "Quad-Stasis Cabbage3":      ("#ffffff", icon_stasis),
    "Quad-Orbita Cabbage3":      ("#ff6b3d", icon_orbita),
    "Quad-Levy Cabbage3":        ("#ff113e", icon_levy),
    "Quad-Loom Cabbage3":        ("#ffc24b", icon_loom),
    "Quad-Singularity Cabbage3": ("#ffc95c", icon_singularity),   # 旋钮弧的 --gold
    "Quad-Zephyr Cabbage3":      ("#c846a0", icon_zephyr),
    "Quad-SwarmGrain Cabbage3":  ("#ff2037", icon_swarmgrain),
    "Quad-Boids Cabbage3":       ("#ff3b40", icon_boids),
    "Quad-Lissajous Cabbage3":   ("#a678ff", icon_lissajous),      # --uv
}

STEREO_SET = {
    "Stasis Cabbage3":      ("#ffffff", icon_stasis),
    "Orbita Cabbage3":      ("#ff6b3d", icon_orbita),
    "levy Cabbage3":        ("#ff113e", icon_levy),
    "loom Cabbage3":        ("#ffc24b", icon_loom),
    "Singularity Cabbage3": ("#ffc95c", icon_singularity),
    "zephyr Cabbage3":      ("#c846a0", icon_zephyr),
    "SwarmGrain Cabbage3":  ("#ff2037", icon_swarmgrain),
    "Boids Cabbage3":       ("#ff3b40", icon_boids),
    "Lissajous Cabbage3":   ("#a678ff", icon_lissajous),          # --uv
}

# 历史写法有三种，按顺序尝试
SVG_MARK = re.compile(r'<svg[^>]*class="mark"[^>]*>.*?</svg>', re.S)
SVG_PLAIN = re.compile(r'<svg viewBox="0 0 12 12">.*?</svg>', re.S)
DOT_DIV = re.compile(r'<div class="dot"></div>')


def patch(path: Path, color: str, maker, dry: bool):
    html = path.read_text(encoding='utf-8')
    new = maker(color)
    for pattern, how in ((SVG_MARK, 'svg.mark'), (SVG_PLAIN, '无 class'), (DOT_DIV, 'div.dot')):
        m = pattern.search(html)
        if not m:
            continue
        if m.group(0) == new:
            return f'· {path.parent.name:<26} {how:<9} 已是最新'
        if not dry:
            path.write_text(pattern.sub(lambda _: new, html, count=1), encoding='utf-8')
        return f'✓ {path.parent.name:<26} {how:<9} {color}'
    return f'✗ {path.parent.name:<26} 没找到图标节点'


def run(base: Path, table: dict, dry: bool):
    for d, (color, maker) in table.items():
        p = base / d / "index.html"
        if not p.exists():
            print(f'✗ {d:<26} 缺 index.html')
            continue
        print(patch(p, color, maker, dry))


def main(argv):
    dry = '--dry-run' in argv
    do_quad = '--stereo' not in argv
    do_stereo = '--stereo' in argv or '--all' in argv
    if do_quad:
        print("── quad（四声道）")
        run(ROOT, QUAD, dry)
    if do_stereo:
        print("── depth（立体声）")
        run(STEREO, STEREO_SET, dry)


if __name__ == "__main__":
    main(sys.argv[1:])
