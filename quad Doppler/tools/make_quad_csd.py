#!/usr/bin/env python3
"""把 stereo C3 的 CSD 机械部分改成四声道版。

只改「跟 DSP 无关」的部分，保留原文件排版，方便和立体声版逐行 diff：
  1. pluginId / caption
  2. 删掉 channelConfig（四声道靠 nchnls 回退，写多总线会崩）
  3. outL/outR 两个隐藏推子 -> outFL/outFR/outRL/outRR 四个
  4. nchnls = 2 -> 4 + nchnls_i = 2，并加全局总线声明
  5. DepthStereoRender UDO -> QuadRender UDO

instr 1 的尾部和 instr 2 仍要人工改（每台的混响/增益接法不同）。
"""
import re
import sys
from pathlib import Path

QUAD_UDO = """; --- 全局总线：干声四声道 + 湿声发送 | global buses: dry quad + wet send ---
gaFL, gaFR, gaRL, gaRR init 0
gaWetL, gaWetR init 0

; [UDO] 四声道多普勒渲染 | quad doppler render
; 中心径向距离驱动 a-rate 延迟（多普勒），X/Y 等功率声像分配到四角，距离插值控制混响发送
opcode QuadRender, aaaaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin

    aX limit aX, 0.001, 0.999

    ; 径向距离（以 (0.5, 0.5) 为圆心）驱动延迟量：远离中心 → 延迟变大 → 音高下降
    aDist = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2))
    aRoomSize interp kRoomSize
    aDelayTime = 0.01 + (aDist * (aRoomSize * 0.002))
    aDelayTime limit aDelayTime, 0.001, 0.5
    aDlyL vdelay3 aInL, aDelayTime * 1000, 500
    aDlyR vdelay3 aInR, aDelayTime * 1000, 500

    ; Y 取反：标准 Y=1 表示前方，转成数学角 0 后 cos(0)=1，声能集中在前置通道
    aY_inverted = 1 - aY
    aY_val limit aY_inverted, 0.001, 0.999

    aL = cos(aX * 1.570796)
    aR = sin(aX * 1.570796)
    aF = cos(aY_val * 1.570796)
    aB = sin(aY_val * 1.570796)

    aMono = (aDlyL + aDlyR) * 0.5

    ; 干声四声道（Doppler + 等功率声像）
    aFL = aMono * aL * aF
    aFR = aMono * aR * aF
    aRL = aMono * aL * aB
    aRR = aMono * aR * aB

    ; 湿声发送：min/max 区间按归一化径向距离插值
    aNormDist = aDist / 0.7071
    aNormDist limit aNormDist, 0, 1
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aNormDist * (aMaxWet - aMinWet))
    aWetL = aMono * aWetSend
    aWetR = aMono * aWetSend

    ; 湿声软限幅防爆音
    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)

    xout aFL, aFR, aRL, aRR, aWetL, aWetR
endop
"""

OUT_BLOCK = """        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": { "left": -120, "top": -120, "width": 13, "height": 170 },
            "channels": [
                { "id": "%s", "range": { "min": 0, "max": 1, "defaultValue": 0, "skew": 1, "increment": 0.001 } }
            ]
        }"""


def widget_span(text, chan_id):
    """返回包含该通道的 widget 对象 [start, end)。"""
    key = f'"id": "{chan_id}"'
    i = text.find(key)
    if i < 0:
        raise SystemExit(f"找不到通道 {chan_id}")
    # widget 的开括号：id 之前最后一个「整行只有 {」的位置（通道对象是行内的，不会命中）
    # 注意：不能只搜 text[:i]，截断后 $ 会落在 "{ " 后面造成误匹配
    starts = [m.start(1) for m in re.finditer(r"(?m)^([ \t]*)\{[ \t]*$", text)
              if m.start(1) < i]
    if not starts:
        raise SystemExit(f"找不到 {chan_id} 的 widget 起始行")
    start = starts[-1]
    depth, j = 0, start
    while j < len(text):
        if text[j] == "{":
            depth += 1
        elif text[j] == "}":
            depth -= 1
            if depth == 0:
                return start, j + 1
        j += 1
    raise SystemExit("括号不平衡")


def main(src, dst, pid, caption):
    s = Path(src).read_text(encoding="utf-8")

    s, n = re.subn(r'("pluginId":\s*")[^"]*(")', lambda m: m.group(1) + pid + m.group(2), s, count=1)
    assert n == 1, "pluginId 未替换"
    s, n = re.subn(r'("caption":\s*")[^"]*(")', lambda m: m.group(1) + caption + m.group(2), s, count=1)
    assert n == 1, "caption 未替换"

    s, n = re.subn(r'\n\s*"channelConfig":\s*\[[^\]]*\]\s*,', "", s, count=1)
    assert n == 1, "channelConfig 未删除"

    for old in ("outR",):
        a, b = widget_span(s, old)
        # 连同前面的逗号/空行一起去掉
        head = s.rfind(",", 0, a)
        s = s[:head] + s[b:]
    a, b = widget_span(s, "outL")
    s = s[:a] + ",\n".join(OUT_BLOCK % c for c in
                           ("outFL", "outFR", "outRL", "outRR")) + s[b:]

    s, n = re.subn(r"\nnchnls\s*=\s*2\b", "\nnchnls = 4\nnchnls_i = 2", s, count=1)
    assert n == 1, "nchnls 未替换"

    # UDO：从 opcode 行（连同紧贴其上的注释行）到 endop
    m0 = re.search(r"(?m)^(?:;[^\n]*\n)*^opcode DepthStereoRender", s)
    assert m0, "找不到 DepthStereoRender opcode"
    m1 = re.compile(r"(?m)^endop\n").search(s, m0.end())
    assert m1, "找不到 UDO 的 endop"
    # 全局总线要插在 0dbfs 之后，不放在 UDO 位置
    s = s[:m0.start()].rstrip("\n") + "\n" + s[m1.end():]
    s, n = re.subn(r"(0dbfs\s*=\s*[0-9.]+\n)", lambda mm: mm.group(1) + "\n" + QUAD_UDO, s, count=1)
    assert n == 1, "0dbfs 未找到"

    Path(dst).write_text(s, encoding="utf-8")
    print(f"✓ {dst}")


if __name__ == "__main__":
    main(*sys.argv[1:5])
