#!/usr/bin/env python3
"""前端静态自检：
  1. JS 里 $('x') / getElementById('x') / '#x' 引用的元素必须真的存在
  2. 电平表相关 id 必须成套（mtrFL/capFL/scaleFL ...）
  3. .canvas 宽高 / METER_H 必须与 CSD 的 form.size 比例一致

不做浏览器渲染，只抓「改了 id 忘了改引用」这类必错项。
"""
import re
import sys
from pathlib import Path

# 电平表通道数按页面实际有的 mtrXXX 推断：
#   quad（四声道）→ FL/FR/RL/RR
#   depth（立体声）→ L/R
METER_RE = re.compile(r'\bid="mtr([A-Za-z]+)"')


def check(idx: Path, csd: Path):
    html = idx.read_text(encoding="utf-8")
    ids = set(re.findall(r'\bid="([^"]+)"', html))
    js = html.split("<script", 1)[-1]
    # 有些元素是 JS 动态创建的（Boids 的湿声双滑块），id 只出现在脚本里
    ids |= set(re.findall(r"""\.id\s*=\s*['"]([A-Za-z0-9_]+)['"]""", js))
    ids |= set(re.findall(r"""id:\s*['"]([A-Za-z0-9_]+)['"]""", js))
    refs = set(re.findall(r"\$\('([A-Za-z0-9_]+)'\)", js)) | \
           set(re.findall(r"getElementById\('([A-Za-z0-9_]+)'\)", js))
    missing = sorted(r for r in refs if r not in ids)

    # 每个 mtrX 都必须有配套的 capX / scaleX
    chans = sorted(set(METER_RE.findall(html)), key=len, reverse=True)
    bad_meter = [pre + c for c in chans for pre in ("cap", "scale") if pre + c not in ids]
    if not chans:
        bad_meter.append("（页面里没有 mtr*，电平表 id 一个都没建）")
    dup = [i for i in re.findall(r'\bid="([^"]+)"', html)
           if re.findall(r'\bid="([^"]+)"', html).count(i) > 1]

    ok = not missing and not bad_meter
    print(("✓ " if ok else "✗ ") + str(idx.parent.name))
    if missing:
        print("   JS 引用但 HTML 没有:", ", ".join(missing))
    if bad_meter:
        print("   电平表 id 缺失:", ", ".join(bad_meter))
    else:
        print(f"   ✓ 电平表 {len(chans)} 路（{', '.join(chans)}）成套")
    if dup:
        print("   ⚠ 重复 id:", ", ".join(sorted(set(dup))))

    # 尺寸比例：form.size / canvas 两个方向必须同比例
    try:
        src = csd.read_text(encoding="utf-8")
        fw = int(re.search(r'"size":\s*\{[^}]*"width":\s*(\d+)', src).group(1))
        fh = int(re.search(r'"size":\s*\{[^}]*"height":\s*(\d+)', src).group(1))
        cw = int(re.search(r"\.canvas\s*\{[^}]*?width:\s*(\d+)px", html, re.S).group(1))
        ch = int(re.search(r"\.canvas\s*\{[^}]*?height:\s*(\d+)px", html, re.S).group(1))
        kx, ky = fw / cw, fh / ch
        same = abs(kx - ky) / max(kx, ky) < 0.005
        print(f"   {'✓' if same else '✗'} form.size {fw}×{fh} / canvas {cw}×{ch}"
              f" = BASE {kx:.4f} / {ky:.4f}")
        ok = ok and same
    except Exception as e:  # noqa: BLE001
        print("   ! 尺寸检查跳过:", e)

    # METER_H 与 CSS .bar 高度一致
    try:
        mh = int(re.search(r"const METER_H = (\d+)", js).group(1))
        bh = int(re.findall(r"\.bar \{[^}]*?height:\s*(\d+)px", html, re.S)[-1])
        print(f"   {'✓' if mh == bh else '✗'} METER_H {mh} / .bar {bh}")
        ok = ok and mh == bh
    except Exception as e:  # noqa: BLE001
        print("   ! METER_H 检查跳过:", e)
    return 0 if ok else 1


if __name__ == "__main__":
    fails = 0
    for d in sys.argv[1:]:
        p = Path(d)
        csd = next(p.glob("*.csd"))
        fails += check(p / "index.html", csd)
    sys.exit(1 if fails else 0)
