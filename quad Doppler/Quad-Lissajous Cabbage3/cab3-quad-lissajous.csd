; Quad-Lissajous — Cabbage 3 版（cab3-quad-lissajous）
; 李萨如 XY 轨迹 → 四声道等功率声像 + 多普勒 + 共享混响
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与立体声版（Cab3-Depth-Lissajous）的差别只有输出级：
;   DepthStereoRender（X 声像 + Y 深度）→ QuadRender（X/Y 等功率分配到 FL/FR/RL/RR）
;   干湿送进全局总线，由 instr 2 统一 reverbsc + 四路电平表
;
; ★★ 这一台的四声道 UDO 与其它 8 台不同，别照抄：
;   李萨如的 x/y 可以由**输入音频**驱动（xsrc / ysrc = 1/2/3），是音频速率的。
;   其余 8 台的 x/y 都是 k 率（拖拽/自动化/内部运动），可以拿径向距离直接调 vdelay3。
;   这里必须先把距离降到 k 率再平滑 10 ms，否则就是音频速率延迟调制 ——
;   听感是啸叫 + 混叠，不是多普勒。深度版当初踩过同一个坑。
;
; ★ 只写 nchnls = 4，不写 nchnls_i、不写 channelConfig（模板 §9.0）：
;   写了 nchnls_i = 2 会变成 2 in / 4 out，Ableton Live 加载 VST3 时直接
;   报 "No valid output bus could be found"。省略它 Csound 令 nchnls_i = nchnls = 4，
;   DSP 里 inch 1, 2 仍然只读前两路。

<Cabbage>
{
    "pluginId": "Q3LJ",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Quad-Lissajous",
            "size": {
                "width": 355,
                "height": 639
            },
            "guiMode": "queue"
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Rate"
            },
            "channels": [
                {
                    "id": "rate",
                    "range": {
                        "min": 0.02,
                        "max": 4,
                        "defaultValue": 0.4,
                        "skew": 1,
                        "increment": 0.01
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Ratio"
            },
            "channels": [
                {
                    "id": "ratio",
                    "range": {
                        "min": 1,
                        "max": 8,
                        "defaultValue": 2,
                        "skew": 1,
                        "increment": 0.125
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Phase"
            },
            "channels": [
                {
                    "id": "phase",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 90,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Scale"
            },
            "channels": [
                {
                    "id": "scale",
                    "range": {
                        "min": 0.05,
                        "max": 1,
                        "defaultValue": 0.8,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Chaos"
            },
            "channels": [
                {
                    "id": "chaos",
                    "range": {
                        "min": 0,
                        "max": 0.1,
                        "defaultValue": 0.004,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Glide"
            },
            "channels": [
                {
                    "id": "glide",
                    "range": {
                        "min": 0.001,
                        "max": 0.4,
                        "defaultValue": 0.02,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "In Gain"
            },
            "channels": [
                {
                    "id": "inGain",
                    "range": {
                        "min": 0.1,
                        "max": 16,
                        "defaultValue": 2,
                        "skew": 1,
                        "increment": 0.01
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "X Source"
            },
            "channels": [
                {
                    "id": "xsrc",
                    "range": {
                        "min": 0,
                        "max": 3,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Y Source"
            },
            "channels": [
                {
                    "id": "ysrc",
                    "range": {
                        "min": 0,
                        "max": 3,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Wave"
            },
            "channels": [
                {
                    "id": "wave",
                    "range": {
                        "min": 0,
                        "max": 3,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 120,
                "height": 20
            },
            "label": {
                "text": "Wet Min"
            },
            "channels": [
                {
                    "id": "minWet",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.1,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 120,
                "height": 20
            },
            "label": {
                "text": "Wet Max"
            },
            "channels": [
                {
                    "id": "maxWet",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.35,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Room"
            },
            "channels": [
                {
                    "id": "roomSize",
                    "range": {
                        "min": 10,
                        "max": 100,
                        "defaultValue": 50,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Damping"
            },
            "channels": [
                {
                    "id": "cutoff",
                    "range": {
                        "min": 1000,
                        "max": 16000,
                        "defaultValue": 16000,
                        "skew": 0.5,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -160,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Master Gain"
            },
            "channels": [
                {
                    "id": "masterGain",
                    "range": {
                        "min": 0,
                        "max": 8,
                        "defaultValue": 2,
                        "skew": 1,
                        "increment": 0.01
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 20
            },
            "channels": [
                {
                    "id": "lis_p",
                    "range": {
                        "min": 0,
                        "max": 8,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.0001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 20
            },
            "channels": [
                {
                    "id": "lis_x",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.0001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 20
            },
            "channels": [
                {
                    "id": "lis_y",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.0001
                    }
                }
            ]
        },
        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 13,
                "height": 170
            },
            "channels": [
                {
                    "id": "outFL",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 13,
                "height": 170
            },
            "channels": [
                {
                    "id": "outFR",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 13,
                "height": 170
            },
            "channels": [
                {
                    "id": "outRL",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 13,
                "height": 170
            },
            "channels": [
                {
                    "id": "outRR",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        }
    ]
}
</Cabbage>

<CsoundSynthesizer>
<CsInstruments>

ksmps = 64
nchnls = 4
0dbfs = 1

; =========================================================
; 软膝限幅器：|x| <= 0.85 时完全线性（零谐波），
; 超过后按 C1 连续地压到 0.98 上限。
; 不用 tanh 的原因：tanh 从 0.5 起就开始明显弯曲，
; 干声稍微热一点就产生 -26 dB 的谐波 —— 那正是「滋滋」。
; =========================================================
opcode SoftClip, a, a
    aIn xin
    kThr  = 0.85
    kCeil = 0.98
    kSpan = kCeil - kThr
    aAx   = abs(aIn)
    aU    = limit(aAx - kThr, 0, 100)
    aShp  = kThr + kSpan * (1 - exp(-aU / kSpan))
    aOver = limit((aAx - kThr) * 200, 0, 1)
    aClip = (aIn / (aAx + 1e-20)) * aShp
    aOut  = aIn + (aClip - aIn) * aOver
    xout aOut
endop

; --- 全局总线：干声四声道 + 湿声发送 | global buses: dry quad + wet send ---
gaFL, gaFR, gaRL, gaRR init 0
gaWetL, gaWetR init 0

; [UDO] 四声道多普勒渲染 | quad doppler render
; 中心径向距离驱动延迟（多普勒），X/Y 等功率声像分配到四角，距离插值控制混响发送
;
; ★ 与其它 8 台的四声道版不一样：这里 x/y 可以是**音频速率**（Lissajous 的轴可以由
;   输入音频驱动，见 xsrc / ysrc）。如果拿原始径向距离直接调 vdelay3，就成了音频速率
;   延迟调制 —— 听感是啸叫 + 混叠，不是多普勒。所以延迟/发送这类「慢变量」一律走
;   10 ms 平滑后的慢速距离，与深度版的 DepthStereoRender 完全同构。
opcode QuadRender, aaaaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin

    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999

    ; 径向距离（以 (0.5, 0.5) 为圆心）：远离中心 → 延迟变大 → 音高下降
    aDistRaw = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2))

    ; ★ 慢速距离：音频速率输入时，原始距离会以音频速率抖动 vdelay3 的延迟量
    kDistFast downsamp aDistRaw
    aDist interp portk(kDistFast, 0.01)

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

    ; 归一化径向距离（0 = 盘心，1 = 盘边）
    aNormDist = aDist / 0.7071
    aNormDist limit aNormDist, 0, 1

    ; 距离模型：与 Depth / HRTF / Ambi 的 DepthStereoRender 同一套曲线。
    ; 远了要既变暗也变轻，否则远离中心的声源和中心一样亮、一样响 ——
    ; 四声道下听感就是「远端声源糊在脸上」。
    aDepthInv = 1 - aNormDist
    aCutoff   = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)
    aFiltL    tone aDlyL, aCutoff
    aFiltR    tone aDlyR, aCutoff

    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp     = exp(-aNormDist * aDecayFactor)

    aMono = (aFiltL + aFiltR) * 0.5

    ; 干声四声道（Doppler + 等功率声像）
    ; 干声归一化（-6 dB）：把工作点压回限幅器的线性区
    aDry = 0.5 * aMono * aDistAmp
    aFL = aDry * aL * aF
    aFR = aDry * aR * aF
    aRL = aDry * aL * aB
    aRR = aDry * aR * aB

    ; 湿声发送：min/max 区间按归一化径向距离插值（同样用慢速距离）
    aNormDist = aDist / 0.7071
    aNormDist limit aNormDist, 0, 1
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aNormDist * (aMaxWet - aMinWet))
    ; 湿声发送同样乘距离衰减：否则盘边处干声被压 -19~-30 dB，湿声却按
    ; Wet Send Max 涨到 +15.6 dB，湿/干比高达 20 倍 —— 远端只剩混响，
    ; 「音源在消散」的听感被糊成一团。乘上之后湿/干比仍随距离增长
    ; （Wet Send 的 +15.6 dB 保留），但整体电平明确下降。
    aWetSend = aWetSend * aDistAmp
    aWetL = 0.5 * aMono * aWetSend
    aWetR = 0.5 * aMono * aWetSend

    ; 湿声软限幅防爆音
    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)

    xout aFL, aFR, aRL, aRR, aWetL, aWetR
endop

; [UDO] 四种周期波形，相位以「周期」为单位（0 = 起点），与前端 JS 逐字同构
;   0 = sine  1 = triangle  2 = saw  3 = square
opcode WaveShape, k, kk
    kPh, kWave xin
    kW = int(round(limit(kWave, 0, 3)))
    kQ = kPh - floor(kPh)
    if kW == 1 then
        if kQ < 0.25 then
            kOut = 4 * kQ
        elseif kQ < 0.75 then
            kOut = 2 - (4 * kQ)
        else
            kOut = (4 * kQ) - 4
        endif
    elseif kW == 2 then
        kS = kQ + 0.5
        kS = kS - floor(kS)
        kOut = (2 * kS) - 1
    elseif kW == 3 then
        if kQ < 0.5 then
            kOut = 1
        else
            kOut = -1
        endif
    else
        kOut = sin(6.283185307 * kQ)
    endif
    xout kOut
endop

instr 1
    ; --- 1. 读取 UI 参数 ---
    kRate   cabbageGetValue "rate"
    kRatio  cabbageGetValue "ratio"
    kPhase  cabbageGetValue "phase"
    kScale  cabbageGetValue "scale"
    kChaos  cabbageGetValue "chaos"
    kGlide  cabbageGetValue "glide"

    kInGain cabbageGetValue "inGain"
    kXsrc   cabbageGetValue "xsrc"
    kYsrc   cabbageGetValue "ysrc"
    kWave   cabbageGetValue "wave"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; --- 2. 李萨如轨迹 ---
    ; 相位用「连续累加」而不是 phasor：phasor 每圈从 1 跳回 0，
    ; 只要 ratio 不是整数，y 相位就会在绕回处留下台阶 —— 那就是「突然折回」的病根。
    ;
    ; x(t) = 1/2 + A/2 · sin(2π(Φ + φ))        Φ = 累计的 x 周期数
    ; y(t) = 1/2 + A/2 · sin(2π·r·Φ)
    ;
    ; Φ 每绕回 8 个 x 周期才减 8：
    ;   · x 相位跨 8 个整周期 → 正弦不变
    ;   · y 相位跨 8r 个周期，而 r 强制量化到 1/8 的整数倍 → 8r 必为整数 → 正弦不变
    ; 所以绕回处一阶连续，光点永远贴着前端画的导引线走。
    kScaleS portk kScale, kGlide
    kPhaseS portk kPhase, kGlide
    kRateS  portk kRate,  kGlide
    kFigFit = 1.0

    ; ratio 量化到 1/8：DAW 自动化送来任意值也不会破坏 y 相位的整周期闭合
    kRatioQ = round(kRatio * 8) / 8

    kPhAcc init 0
    kPhAcc = kPhAcc + (kRateS / kr)
    if kPhAcc >= 8 then
        kPhAcc = kPhAcc - 8
    endif

    ; 合成轴：波形由 Wave 选择（sine / tri / saw / square），仍是 8 个 x 周期闭合
    ; 与前端 paintFigure 逐字同构：坐标 = 0.5 + 0.5·kFigFit·Scale·wave
    ; （原来写成裸 WaveShape，输出 -1..1 直接被 limit 到 0，
    ;   负半周全被拍在左边/下边，声音轨迹只剩一个象限）
    kSynXr WaveShape (kPhAcc + (kPhaseS * 0.0027777778)), kWave
    kSynYr WaveShape (kPhAcc * kRatioQ), kWave
    kSynX = 0.5 + (0.5 * kFigFit * kScaleS * kSynXr)
    kSynY = 0.5 + (0.5 * kFigFit * kScaleS * kSynYr)

    ; 输入轴：实时输入音频当作轴坐标（±1 → 0..1），先去直流再乘 Scale / In Gain
    aInL, aInR inch 1, 2
    aInLdc dcblock aInL
    aInRdc dcblock aInR
    aInMdc = (aInLdc + aInRdc) * 0.5

    aAxL = 0.5 + (0.5 * kFigFit * kScaleS * kInGain * aInLdc)
    aAxR = 0.5 + (0.5 * kFigFit * kScaleS * kInGain * aInRdc)
    aAxM = 0.5 + (0.5 * kFigFit * kScaleS * kInGain * aInMdc)

    aSynX interp kSynX
    aSynY interp kSynY

    ; 源选择：0 = 合成轴，1 = 输入 L，2 = 输入 R，3 = 输入 M
    kXs = int(round(limit(kXsrc, 0, 3)))
    kYs = int(round(limit(kYsrc, 0, 3)))

    if kXs == 1 then
        aXr = aAxL
    elseif kXs == 2 then
        aXr = aAxR
    elseif kXs == 3 then
        aXr = aAxM
    else
        aXr = aSynX
    endif

    if kYs == 1 then
        aYr = aAxL
    elseif kYs == 2 then
        aYr = aAxR
    elseif kYs == 3 then
        aYr = aAxM
    else
        aYr = aSynY
    endif

    ; 叠加高频细碎混沌微颤
    kChsX random -kChaos, kChaos
    kChsY random -kChaos, kChaos

    aX = limit(aXr + kChsX, 0, 1)
    aY = limit(aYr + kChsY, 0, 1)

    ; --- 3. 四声道渲染（音频在上面已捕获） ---
    aFL, aFR, aRL, aRR, aWetL, aWetR QuadRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 4. 干湿送入全局总线，由 instr 2 统一做混响与输出 ---
    gaFL = gaFL + aFL
    gaFR = gaFR + aFR
    gaRL = gaRL + aRL
    gaRR = gaRR + aRR
    gaWetL = gaWetL + aWetL
    gaWetR = gaWetR + aWetR

    ; --- 5. 视觉反馈 ---
    ; 只推相位 Φ（x 周期数，0~8）：前端用它和同一套公式算出光点与余晖，
    ; 这样轨迹永远贴着曲线，帧率掉了也不会在图上拉出弦。
    kTrig metro 60
    kVisX downsamp aX
    kVisY downsamp aY

    ; 输入轴驱动时，坐标要以「采样率无关」的高速率送出去：
    ;   · 60 Hz 采 220 Hz 的波形，相位比值是有理数 11/3 → 只有 3 个相位，画不出图形
    ;   · 用 150.7 Hz 这种「不整除」的速率，相位每帧缓慢进动 → 荧光点累积后铺满整条轨迹
    ; 合成轴不用坐标（前端按相位解析画线），保持 60 Hz 省带宽。
    kAudioAxis = (kXs != 0) || (kYs != 0) ? 1 : 0
    kFastTrig metro 150.7

    if kAudioAxis == 1 then
        cabbageSetValue "lis_x", kVisX, kFastTrig
        cabbageSetValue "lis_y", kVisY, kFastTrig
    else
        cabbageSetValue "lis_p", kPhAcc, kTrig
        cabbageSetValue "lis_x", kVisX, kTrig
        cabbageSetValue "lis_y", kVisY, kTrig
    endif

endin

; =========================================================
; INSTR 2: 共享混响 + 主输出 + 四路电平表
; =========================================================
instr 2
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_sm portk kFeedback, 0.05
    kCutoff_sm   portk kCutoff, 0.05

    ; 全插件唯一一台混响，挂在湿声总线上
    aRevL, aRevR reverbsc gaWetL, gaWetR, kFeedback_sm, kCutoff_sm

    ; 干声四声道 + 混响尾音四角环绕
    aOutFL = gaFL + (aRevL * 0.5)
    aOutFR = gaFR + (aRevR * 0.5)
    aOutRL = gaRL + (aRevL * 0.5)
    aOutRR = gaRR + (aRevR * 0.5)

    ; 总输出增益（0~8，1.0 = 单位增益）
    kMasterGain cabbageGetValue "masterGain"
    aOutFL = aOutFL * kMasterGain
    aOutFR = aOutFR * kMasterGain
    aOutRL = aOutRL * kMasterGain
    aOutRR = aOutRR * kMasterGain

    ; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。

    aOutFL = SoftClip(aOutFL)

    aOutFR = SoftClip(aOutFR)

    aOutRL = SoftClip(aOutRL)

    aOutRR = SoftClip(aOutRR)


    out aOutFL, aOutFR, aOutRL, aOutRR

    ; --- 电平表反馈（30 Hz，峰值保持 + 平滑） ---
    kUIMetro metro 30
    kP1 maxk abs(aOutFL), kUIMetro, 1
    kP2 maxk abs(aOutFR), kUIMetro, 1
    kP3 maxk abs(aOutRL), kUIMetro, 1
    kP4 maxk abs(aOutRR), kUIMetro, 1

    cabbageSetValue "outFL", portk(kP1, .05), kUIMetro
    cabbageSetValue "outFR", portk(kP2, .05), kUIMetro
    cabbageSetValue "outRL", portk(kP3, .05), kUIMetro
    cabbageSetValue "outRR", portk(kP4, .05), kUIMetro

    ; --- 清空总线 ---
    clear gaFL, gaFR, gaRL, gaRR, gaWetL, gaWetR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 2 0 -1
</CsScore>
</CsoundSynthesizer>
