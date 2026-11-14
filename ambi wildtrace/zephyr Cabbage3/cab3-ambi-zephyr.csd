; Depth-Zephyr — Cabbage 3 版（4 声道 Ambisonics）
; 极坐标直线穿梭 + 湍流扰动 + 深度渲染
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Cabbage 2 版的差别只在「UI 反馈」这一层：
;   · 原来的 visualBall image 控件由 HTML 自己画
;   · Csound 只推 zep_x / zep_y（0~1 位置）、zep_env（振幅门）与 outL / outR
;   · 所有控件都是隐藏的宿主参数，界面完全由 index.html 决定
;
; 信号流（PARAM_IDX 必须与这里的 widget 书写顺序逐字一致）：
;   Start → Loop → fallTime → angle → radius → drift → dfreq → jitter
;   → minWet → maxWet → roomSize → cutoff

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "A3ZP",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-Zephyr",
            "size": {
                "width": 620,
                "height": 700
            },
            "guiMode": "queue"
        },
        {
            "type": "button",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 50,
                "height": 26
            },
            "label": {
                "text": {
                    "off": "Stop",
                    "on": "Start"
                }
            },
            "channels": [
                {
                    "id": "Start",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 1,
                        "skew": 1,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "button",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 50,
                "height": 26
            },
            "label": {
                "text": {
                    "off": "Loop Off",
                    "on": "Loop On"
                }
            },
            "channels": [
                {
                    "id": "Loop",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 1,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Fall Time"
            },
            "channels": [
                {
                    "id": "fallTime",
                    "range": {
                        "min": 0.1,
                        "max": 600,
                        "defaultValue": 2,
                        "skew": 0.25,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Angle"
            },
            "channels": [
                {
                    "id": "angle",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 90,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Radius"
            },
            "channels": [
                {
                    "id": "radius",
                    "range": {
                        "min": 0,
                        "max": 0.5,
                        "defaultValue": 0.353,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Drift"
            },
            "channels": [
                {
                    "id": "drift",
                    "range": {
                        "min": 0,
                        "max": 0.5,
                        "defaultValue": 0.1,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Drift Freq"
            },
            "channels": [
                {
                    "id": "dfreq",
                    "range": {
                        "min": 0.01,
                        "max": 10,
                        "defaultValue": 0.2,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Jitter"
            },
            "channels": [
                {
                    "id": "jitter",
                    "range": {
                        "min": 0,
                        "max": 0.2,
                        "defaultValue": 0.02,
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
                "left": -120,
                "top": -120,
                "width": 80,
                "height": 24
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
                "left": -120,
                "top": -120,
                "width": 80,
                "height": 24
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
                        "defaultValue": 0.6,
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
                "left": -120,
                "top": -120,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Damp"
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
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "zep_x",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "zep_y",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "zep_env",
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
        }
    ]
}
</Cabbage>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
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

; [UDO] 核心渲染引擎（与 Cabbage 2 版一致）

; =========================================================
; 一阶 B-format → 四角阵列解码
; bformdec1 setup 2（Quad）的输出顺序是 FL(45), BL(135), BR(-135), FR(-45)，
; 这里统一重排成 FL, FR, BL, BR，与 Quad 版的 out 顺序一致。
; =========================================================
opcode AmbiDecode4, aaaa, aaaa
    aW, aX, aY, aZ xin
    aFL, aBL, aBR, aFR bformdec1 2, aW, aX, aY, aZ
    xout aFL, aFR, aBL, aBR
endop
opcode DepthStereoRender, aaaa, aaaakkka
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize, aEnvSmooth xin

    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999

    ; 统一距离：以 (0.5, 0.5) 画布中心为圆心，统一驱动延迟/多普勒、
    ; 空气吸收、距离衰减与混响发送。
    ; 声场是圆盘：归一化坐标里圆盘半径 = 0.5，系数取 2.0 使盘边 = 1.0，
    ; 圆外（方形 pad 的四角）按 1.0 截断。
    aDistance = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2)) * 2.0
    aDistance limit aDistance, 0, 1
    aRoomSize interp kRoomSize

    ; 1. 方位声像映射
    ; 不再在此处做左右平移：声像改由调用方按声源逐个编码成 B-format
    ; （多声源插件必须每个声源用自己的方位角编码，否则方向信息会丢失）
    aMono = (aInL + aInR) * 0.5

    aPanL = aMono
    aPanR = aMono

    ; 2. 动态多普勒距离延迟
    aDelayTime = 0.01 + (aDistance * (aRoomSize * 0.002))

    aDlyL vdelay3 aPanL, aDelayTime * 1000, 500
    aDlyR vdelay3 aPanR, aDelayTime * 1000, 500

    ; 3. 空气声学吸收
    aDepthInv = 1 - aDistance
    aAirCutoff = 800 + ((aDepthInv * aDepthInv * aDepthInv) * 19200)

    aFiltL tone aDlyL, aAirCutoff
    aFiltR tone aDlyR, aAirCutoff

    ; 4. 空间平方反比衰减
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDistance * aDecayFactor)

    ; 应用绝对毫秒防护包络
    aDryL = 0.5 * aFiltL * aDistAmp * aEnvSmooth
    aDryR = 0.5 * aFiltR * aDistAmp * aEnvSmooth

    ; 5. 声能空间反射混响发送矩阵
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDistance * (aMaxWet - aMinWet))
    ; 湿声发送同样乘距离衰减：否则远端干声被压 -19~-30 dB，湿声却按
    ; Wet Send Max 涨到 +15.6 dB，湿/干比高达 20 倍 —— 只剩混响，
    ; 「音源在消散」的听感被糊成一团。
    aWetSend = aWetSend * aDistAmp

    aWetL = 0.5 * aFiltL * aWetSend * aEnvSmooth
    aWetR = 0.5 * aFiltR * aWetSend * aEnvSmooth

    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)
    xout aDryL, aDryR, aWetL, aWetR
endop

instr 1
    ; --- 1. 获取 UI 参数 ---
    kFallTime cabbageGetValue "fallTime"
    kRawAngle cabbageGetValue "angle"
    kRad      cabbageGetValue "radius"
    kDrift    cabbageGetValue "drift"
    kDfreq    cabbageGetValue "dfreq"
    kJitAmt   cabbageGetValue "jitter"

    kLoop     cabbageGetValue "Loop"
    kStart    cabbageGetValue "Start"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    kAngle wrap kRawAngle, 0, 360

    ; --- 2. 核心状态初始化与相位累加器 ---
    kPhase init 0
    kSafeFallTime = max(kFallTime, 0.05)
    kFreq = 1 / kSafeFallTime

    kStartTrig trigger kStart, 0.5, 0
    if kStartTrig == 1 then
        kPhase = 0
    endif

    if kStart == 1 then
        kPhase = kPhase + (kFreq / kr)
        if kPhase >= 1 then
            if kLoop == 1 then
                kPhase = kPhase - 1
            else
                kPhase = 1
                kStart = 0
                cabbageSetValue "Start", 0, 1
            endif
        endif
    else
        if kLoop == 0 then
            kPhase = 0
        endif
    endif

    ; --- 3. 风场流体运动计算 ---
    kMaxRad = kRad * 1.4142

    ; 基于绝对毫秒的硬静音与平滑过零
    kSilenceTime = 0.010
    kFadeTime    = 0.005

    kSilencePhase = kSilenceTime / kSafeFallTime
    kFadePhase    = kFadeTime / kSafeFallTime
    kTotalMargin  = kSilencePhase + kFadePhase

    kSineEnv = sin(kPhase * 3.14159265)

    if (kStart == 0) then
        kAmpGate = 0
    elseif (kPhase < kSilencePhase || kPhase > (1 - kSilencePhase)) then
        kAmpGate = 0
    elseif (kPhase < kTotalMargin) then
        kRamp = (kPhase - kSilencePhase) / kFadePhase
        kAmpGate = kSineEnv * kRamp
    elseif (kPhase > (1 - kTotalMargin)) then
        kRamp = ((1 - kSilencePhase) - kPhase) / kFadePhase
        kAmpGate = kSineEnv * kRamp
    else
        kAmpGate = kSineEnv
    endif

    kRadAng = kAngle * 0.0174532925
    kMovement = (kPhase - 0.5) * kMaxRad * 2

    kMoveGate portk kStart, 0.015

    kLFO lfo kDrift, kDfreq, 0
    kJit jitter kJitAmt, 8, 28

    kLateral = (kLFO + kJit) * kMoveGate

    kX_raw = 0.5 + (cos(kRadAng) * kMovement) - (sin(kRadAng) * kLateral)
    kY_raw = 0.5 + (sin(kRadAng) * kMovement) + (cos(kRadAng) * kLateral)

    ; 坐标跳变无阻尼，在静音 10ms 内完成瞬间重置
    aX interp limit(kX_raw, 0, 1)
    aY interp limit(kY_raw, 0, 1)

    kX downsamp aX
    kY downsamp aY

    ; --- 4. 生成干净的音频级包络 ---
    aEnvSmooth interp kAmpGate

    ; --- 5. 硬件捕获与公共引擎渲染 ---
    aInL, aInR inch 1, 2

    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize, aEnvSmooth
    ; 本声源的 B-format 编码（方位角取本声源自己的坐标）
    kXe downsamp aX
    kYe downsamp aY
    kXe = limit(kXe, 0, 1)
    kYe = limit(kYe, 0, 1)
    kDxe = kXe - 0.5
    kDye = kYe - 0.5
    kRae = min(1.0, sqrt(kDxe * kDxe + kDye * kDye) / 0.5)
    kAre taninv2 kDxe, kDye
    kAce = kAre * 57.2957795
    kAce wrap kAce, 0, 360
    ; 中心处方位角无定义，锁定正前（此时 X/Y 已趋于 0，无可听跳变）
    kAce = (kRae < 0.0005 ? 0 : kAce)
    ; Cabbage 角度是顺时针(0=前,90=右)，bformenc1 要逆时针，故取 360-a
    kAlp = 360 - kAce
    kAlp wrap kAlp, 0, 360
    aBW, aBX, aBY, aBZ bformenc1 aDryL, kAlp, 0

    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kCutoff, 0.04

    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; 总输出增益（0~8，1.0 = 单位增益）
    kMasterGain cabbageGetValue "masterGain"

    ; --- 4 声道 Ambisonics 输出 ---
    aZeroA = 0
    aDecFL, aDecFR, aDecBL, aDecBR AmbiDecode4 aBW, aBX, aBY, aZeroA
    aOutL = (aDecFL + aRevL * 0.5) * kMasterGain
    aOutR = (aDecFR + aRevR * 0.5) * kMasterGain
    aOutBL = (aDecBL + aRevL * 0.5) * kMasterGain
    aOutBR = (aDecBR + aRevR * 0.5) * kMasterGain

    ; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。

    aOutL = SoftClip(aOutL)

    aOutR = SoftClip(aOutR)

    aOutBL = SoftClip(aOutBL)

    aOutBR = SoftClip(aOutBR)


    out aOutL, aOutR, aOutBL, aOutBR

    ; --- 6. UI 视讯刷新（60 Hz） ---
    kUIMetro metro 60
    cabbageSetValue "zep_x", kX, kUIMetro
    cabbageSetValue "zep_y", kY, kUIMetro
    cabbageSetValue "zep_env", kAmpGate, kUIMetro

    ; --- 7. 输出电平监听 ---
    kOutFL maxk abs(aOutL), kUIMetro, 1
    kOutFR maxk abs(aOutR), kUIMetro, 1
    kOutRL maxk abs(aOutBL), kUIMetro, 1
    kOutRR maxk abs(aOutBR), kUIMetro, 1
    cabbageSetValue "outFL", portk(kOutFL, .05), kUIMetro
    cabbageSetValue "outFR", portk(kOutFR, .05), kUIMetro
    cabbageSetValue "outRL", portk(kOutRL, .05), kUIMetro
    cabbageSetValue "outRR", portk(kOutRR, .05), kUIMetro
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>
