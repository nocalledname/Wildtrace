; Lissajous — Cabbage 3 版（HRTF 双耳渲染）
; 李萨如 XY 轨迹 + 立体声深度渲染 + reverbsc
; 自定义 UI 入口见 cabbage.project.json -> index.html

<Cabbage>
{
    "pluginId": "H3LJ",
    "enableDevTools": true,
    "channelConfig": [
        {
            "name": "2 in 2 out",
            "ins": "2",
            "outs": "2"
        }
    ],
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-HRTF-Lissajous",
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
                "left": -140,
                "top": -140,
                "width": 20,
                "height": 60
            },
            "channels": [
                {
                    "id": "outL",
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
                "left": -140,
                "top": -140,
                "width": 20,
                "height": 60
            },
            "channels": [
                {
                    "id": "outR",
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
nchnls = 2
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

; [UDO] 核心双声道深度渲染引擎 | core stereo depth render engine
; 与 Stasis / levy 同一套：等功率声像 + 距离延迟 + 空气吸收 + 距离衰减 + 混响发送

; =========================================================
; HRTF 数据文件定位（插件采样率由宿主决定，不写死 sr）
; 可用数据集只有 44.1k / 48k / 96k 三套；非标准采样率取最近的一套并告警
; =========================================================
opcode HrtfResolve, SSi, 0
    iSr = sr

    iCand[] init 3
    iCand[0] = 44100
    iCand[1] = 48000
    iCand[2] = 96000

    iSel = iCand[1]
    iBest = 999999
    ind = 0
    while ind < 3 do
        idiff = abs(iCand[ind] - iSr)
        if idiff < iBest then
            iBest = idiff
            iSel = iCand[ind]
        endif
        ind += 1
    od

    if iSel != iSr then
        prints "HrtfResolve: host sr = %d, HRTF data is %d (nearest); " \
               , iSr, iSel
        prints "set host to 44100/48000/96000 for correct HRTF\n"
    endif

    Ssfx = sprintf("%d", iSel)

    Sdirs[] init 6
    Sdirs[0] = ""
    Sdirs[1] = "./"
    Sdirs[2] = "/Applications/Csound/CsoundLib64.framework/Versions/7.0/samples/"
    Sdirs[3] = "/Library/Frameworks/CsoundLib64.framework/Versions/6.0/samples/"
    Sdirs[4] = "/usr/local/share/csound/"
    Sdirs[5] = "/opt/homebrew/share/csound/"

    SoutL = ""
    SoutR = ""
    indx = 0
    while (indx < lenarray(Sdirs)) && (strlen(SoutL) == 0) do
        Sc = sprintf("%shrtf-%s-left.dat", Sdirs[indx], Ssfx)
        iok filevalid Sc
        if iok == 1 then
            SoutL = Sc
            SoutR = sprintf("%shrtf-%s-right.dat", Sdirs[indx], Ssfx)
        endif
        indx += 1
    od

    if strlen(SoutL) == 0 then
        prints "HrtfResolve: HRTF data (%s) not found, using relative path\n", Ssfx
        SoutL = sprintf("hrtf-%s-left.dat", Ssfx)
        SoutR = sprintf("hrtf-%s-right.dat", Ssfx)
    endif

    xout SoutL, SoutR, iSel
endop
opcode DepthStereoRender, aaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin

    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999

    ; 统一距离：双耳声场是以听者为圆心（(0.5, 0.5)）的圆盘，与方位角用同一个参考点。
    ; 归一化坐标里圆盘半径 = 0.5，系数取 2.0 使盘边 = 1.0，圆外按 1.0 截断。
    aDistance = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2)) * 2.0
    aDistance limit aDistance, 0, 1

    ; ★ 环境参数（延迟 / 吸收 / 衰减 / 发送）用「慢速距离」：
    ;   一旦某个轴被输入音频驱动，原始距离就是音频速率 —— 拿去调 vdelay3 会变成
    ;   音频速率延迟调制（啸叫 + 混叠），那不是多普勒。10 ms 平滑保留慢速轨迹的全部听感。
    kDistanceFast downsamp aDistance
    aDistance interp portk(kDistanceFast, 0.01)

    aRoomSize interp kRoomSize

    ; 1. 方位：X 轴等功率左右平移
    aMono = (aInL + aInR) * 0.5

    ; ---- HRTF 声像（替换原等功率左右平移）----
    ; 修复①：不对方位角做 ±180 wrap。hrtfmove2 对超出 ±180 的角度按周期处理
    ;        （实测 200° 与 -160° 输出完全一致），多余 wrap 只会在经过正后方时
    ;        制造一次 358° 跳变。
    ; 修复④：中心附近对坐标做低通。穿心时方位角要在单帧内翻转 180°，
    ;        hrtfmove2 的 STFT 重合成跟不上，低通把翻转摊平成缓慢扫过。
    ;        远离中心时混合系数为 0，轨迹原样通过（实测 8 Hz 轨迹 0.000 dB 偏差）。
    ;
    ; 注意：低通不能用 portk —— portk 的初值是 0，会让起振时声像从原点
    ; 扫到目标位置（实测中心位置 L/R 严重不平衡）。这里手动实现，首周期
    ; 直接取当前值作为初值，避免起振瞬态。
    kXh downsamp aX
    kYh downsamp aY
    kXh = limit(kXh, 0, 1)
    kYh = limit(kYh, 0, 1)

    kFirst init 1
    kCoef = 1 - exp(-1 / (kr * 0.06))
    if kFirst == 1 then
        kXsm = kXh
        kYsm = kYh
        kFirst = 0
    else
        kXsm = kXsm + (kXh - kXsm) * kCoef
        kYsm = kYsm + (kYh - kYsm) * kCoef
    endif

    kRhPre = min(1.0, sqrt((kXh - 0.5) ^ 2 + (kYh - 0.5) ^ 2) / 0.5)
    kBh = 1 - min(1, max(0, (kRhPre - 0.12) / 0.23))

    kXf = kXh + (kXsm - kXh) * kBh
    kYf = kYh + (kYsm - kYh) * kBh

    kXc = kXf - 0.5
    kYc = kYf - 0.5
    kRadH = min(1.0, sqrt(kXc * kXc + kYc * kYc) / 0.5)

    kAngRh taninv2 kXc, kYc
    kAngH = kAngRh * 57.2957795
    kAngH wrap kAngH, 0, 360
    kAzH = (kRadH < 0.0005 ? 0 : kAngH)

    SHLh, SHRh, iSrH HrtfResolve
    aPanL, aPanR hrtfmove2 aMono * 1.6, kAzH, 0, SHLh, SHRh, 4, 9.0, iSrH

    ; 2. 距离延迟
    aDelayTime = 0.1 + (aDistance * aRoomSize)
    aDlyL vdelay3 aPanL, aDelayTime, 150
    aDlyR vdelay3 aPanR, aDelayTime, 150

    ; 3. 空气吸收（高频随深度衰减）
    aDepthInv = 1 - aDistance
    aCutoff = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)

    aFiltL tone aDlyL, aCutoff
    aFiltR tone aDlyR, aCutoff

    ; 4. 空间衰减（与房间大小绑定）
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDistance * aDecayFactor)

    aDryL = 0.5 * aFiltL * aDistAmp
    aDryR = 0.5 * aFiltR * aDistAmp

    ; 5. 空间混响发送量
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDistance * (aMaxWet - aMinWet))
    ; 湿声发送同样乘距离衰减：否则远端干声被压 -19~-30 dB，湿声却按
    ; Wet Send Max 涨到 +15.6 dB，湿/干比高达 20 倍 —— 只剩混响，
    ; 「音源在消散」的听感被糊成一团。
    aWetSend = aWetSend * aDistAmp

    aWetL = 0.5 * aFiltL * aWetSend
    aWetR = 0.5 * aFiltR * aWetSend

    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)
    xout aDryL, aDryR, aWetL, aWetR
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
    kFigFit = 0.70710678

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

    ; --- 3. 深度渲染（音频在上面已捕获） ---
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 4. 混响器 ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05

    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; --- 5. 总输出增益（0~8，1.0 = 单位增益） ---
    kMasterGain cabbageGetValue "masterGain"

    aOutL = (aDryL + aRevL) * kMasterGain
    aOutR = (aDryR + aRevR) * kMasterGain

    ; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。

    aOutL = SoftClip(aOutL)

    aOutR = SoftClip(aOutR)


    out aOutL, aOutR

    ; --- 6. 视觉与电平反馈 ---
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

    ; 双声道电平捕捉（与 Stasis / levy 同一套：maxk 做峰值保持 + portk 平滑）
    kOutL maxk abs(aOutL), kTrig, 1
    kOutR maxk abs(aOutR), kTrig, 1
    cabbageSetValue "outL", portk(kOutL, .05), kTrig
    cabbageSetValue "outR", portk(kOutR, .05), kTrig
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>
