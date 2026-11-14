; Depth-Singularity — Cabbage 3 版（4 声道 Ambisonics）
; 引力深渊：粒子沿螺旋轨道坠入（黑洞）或喷出（白洞）奇点
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Orbita 的差别：位置不是匀速圆周，而是「半径按指数律收缩/膨胀」的螺旋。
;   Csound 用 40Hz 的 k 率积分推进 kRadius / kAngle → 推给 sing_x / sing_y → HTML 画粒子。
;   轨道半径 = kRadius（0.001 ~ 0.5），HTML 按 0.5 归一化到 pad 半径。
;   Start / Loop / Mode 是离散状态，走 A 类宿主参数；Csound 自动停机时回写 start。

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "A3SG",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-Singularity",
            "size": {
                "width": 620,
                "height": 700
            },
            "guiMode": "queue"
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
                        "defaultValue": 4,
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
                "text": "Spin Speed"
            },
            "channels": [
                {
                    "id": "spinSpeed",
                    "range": {
                        "min": 0.05,
                        "max": 0.5,
                        "defaultValue": 0.25,
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
                "text": "Gravity Curve"
            },
            "channels": [
                {
                    "id": "gravityCurve",
                    "range": {
                        "min": 0.2,
                        "max": 5,
                        "defaultValue": 0.5,
                        "skew": 0.4,
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
                "text": "Input Gain"
            },
            "channels": [
                {
                    "id": "inputGain",
                    "range": {
                        "min": 0,
                        "max": 4,
                        "defaultValue": 1,
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
                "text": "Doppler Factor"
            },
            "channels": [
                {
                    "id": "dopplerFactor",
                    "range": {
                        "min": -100,
                        "max": 100,
                        "defaultValue": -100,
                        "skew": 1,
                        "increment": 0.1
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
                    "off": "Black Hole",
                    "on": "White Hole"
                }
            },
            "channels": [
                {
                    "id": "mode",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
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
                    "off": "Raw",
                    "on": "Doppler"
                }
            },
            "channels": [
                {
                    "id": "dopplerMode",
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
                    "off": "Stop",
                    "on": "Start"
                }
            },
            "channels": [
                {
                    "id": "start",
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
                    "off": "Once",
                    "on": "Loop"
                }
            },
            "channels": [
                {
                    "id": "loop",
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
                        "defaultValue": 0.3,
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
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 20
            },
            "channels": [
                {
                    "id": "sing_x",
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
                "height": 20
            },
            "channels": [
                {
                    "id": "sing_y",
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
                "height": 20
            },
            "channels": [
                {
                    "id": "sing_r",
                    "range": {
                        "min": 0,
                        "max": 0.5,
                        "defaultValue": 0.5,
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
                "width": 20,
                "height": 60
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
                "width": 20,
                "height": 60
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
                "width": 20,
                "height": 60
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
                "width": 20,
                "height": 60
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

; [UDO] 核心双声道深度渲染引擎 | core stereo depth render engine
; 本插件 Y 轴反转：视觉下边 = Y=1，所以参考点取 (0.5, 1)

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
opcode DepthStereoRender, aaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin

    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999

    ; 统一距离：以 (0.5, 0.5) 画布中心为圆心，统一驱动延迟/多普勒、
    ; 空气吸收、距离衰减与混响发送。
    ; 声场是圆盘：归一化坐标里圆盘半径 = 0.5，系数取 2.0 使盘边 = 1.0，
    ; 圆外（方形 pad 的四角）按 1.0 截断。
    aDistance = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2)) * 2.0
    aDistance limit aDistance, 0, 1

    aRoomSize interp kRoomSize

    ; 1. 方位：X 轴等功率左右平移
    ; 不再在此处做左右平移：声像改由调用方按声源逐个编码成 B-format
    ; （多声源插件必须每个声源用自己的方位角编码，否则方向信息会丢失）
    aMono = (aInL + aInR) * 0.5

    aPanL = aMono
    aPanR = aMono

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

instr 1
    ; --- 1. 读取 UI 参数 ---
    kSpinSpeed    cabbageGetValue "spinSpeed"
    kFallTime     cabbageGetValue "fallTime"
    kMasterGain   cabbageGetValue "masterGain"
    kMode         cabbageGetValue "mode"
    kInputGain    cabbageGetValue "inputGain"
    kEnvIndex     cabbageGetValue "gravityCurve"
    kLoop         cabbageGetValue "loop"
    kstart        cabbageGetValue "start"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; 多普勒模式开关：15ms 交叉平滑防爆音
    kDopplerMode   cabbageGetValue "dopplerMode"
    kDopplerSwitch portk kDopplerMode, 0.015

    kDopplerScaleRaw cabbageGetValue "dopplerFactor"
    kDopplerScale portk kDopplerScaleRaw, 0.05

    ; --- 2. 核心状态初始化 ---
    kOldMode  init 0
    kRadius   init 0.5
    kAngle    init 0
    kTeleport init 0

    kInitTrig init 1
    if kInitTrig == 1 then
        kAngle random 0, 6.2831853
        kRadius = (kMode == 0 ? 0.5 : 0.001)
        kInitTrig = 0
    endif

    kStartTrig trigger kstart, 0.5, 0
    if kStartTrig == 1 then
        kRadius = (kMode == 0 ? 0.5 : 0.001)
        kAngle random 0, 6.2831853
        kTeleport = 1
    endif

    if kMode != kOldMode then
        kRadius = (kMode == 0 ? 0.5 : 0.001)
        kTeleport = 1
        kOldMode = kMode
    endif

    kTrig metro 40
    kFallTime max kFallTime, 0.001

    ; --- 3. 双向非线性螺旋物理引擎 ---
    if kTrig == 1 && kstart == 1 then
        kAngle = kAngle + kSpinSpeed

        if kMode == 0 then
            ; 【黑洞模式】半径指数收缩
            kFallRate = exp(-6.2146 / (kFallTime * 40))
            kRadius = kRadius * kFallRate
            if kRadius <= 0.001 then
                if kLoop == 1 then
                    kRadius = 0.5
                    kAngle random 0, 6.2831853
                    kTeleport = 1
                else
                    kstart = 0
                    cabbageSetValue "start", 0, 1
                    kTeleport = 0
                endif
            endif
        else
            ; 【白洞模式】半径指数膨胀
            kGrowRate = exp(6.2146 / (kFallTime * 40))
            kRadius = kRadius * kGrowRate
            if kRadius >= 0.5 then
                if kLoop == 1 then
                    kRadius = 0.001
                    kAngle random 0, 6.2831853
                    kTeleport = 1
                else
                    kstart = 0
                    cabbageSetValue "start", 0, 1
                    kTeleport = 0
                endif
            endif
        endif
    endif

    if kstart == 0 && kLoop == 0 then
        kRadius = 0
    endif

    ; 声像位移平滑（Teleport 时直接跳变，避免跨屏滑行）
    kX = 0.5 + cos(kAngle) * kRadius
    kY = 0.5 + sin(kAngle) * kRadius

    kX_disp init 0.5
    kY_disp init 0.5

    if kTeleport == 1 then
        kX_disp = kX
        kY_disp = kY
    else
        kX_disp = kX_disp + 0.08 * (kX - kX_disp)
        kY_disp = kY_disp + 0.08 * (kY - kY_disp)
    endif

    aX interp kX_disp
    aY interp kY_disp

    ; --- 4. 边缘防护淡出 ---
    kEdgeFade init 1
    if kstart == 1 then
        if kMode == 0 then
            ; 黑洞：逼近 0.001 时增益平滑迫降到 0
            if kRadius < 0.012 then
                kEdgeFade = (kRadius - 0.001) / (0.012 - 0.001)
            else
                kEdgeFade = 1
            endif
        else
            ; 白洞：逼近 0.5 时增益平滑迫降到 0
            if kRadius > 0.488 then
                kEdgeFade = (0.5 - kRadius) / (0.5 - 0.488)
            else
                kEdgeFade = 1
            endif
        endif
    else
        kEdgeFade = 0
    endif
    kEdgeFade limit kEdgeFade, 0, 1

    ; Start/Stop 15ms 斜坡
    kStartSmooth portk kstart, 0.015

    ; --- 5. 声学衰减 & 多普勒时空扭曲 ---
    kNormRadius limit (kRadius / 0.5), 0, 1
    kGainEnv = pow(kNormRadius, kEnvIndex)

    ; 合并增益矩阵：重力曲线 * 边界阻断 * 启停保护
    kTotalGain = kGainEnv * kEdgeFade * kStartSmooth
    kTotalGain portk kTotalGain, 0.005

    aInL, aInR inch 1, 2
    aMono = (aInL + aInR) * 0.5 * kInputGain

    if kDopplerScale >= 0 then
        kSourcePos = kNormRadius * kDopplerScale
        kMicPos = 0
    else
        kSourcePos = (1 - kNormRadius) * abs(kDopplerScale)
        kMicPos = 0
    endif

    ; 完美重置盾：Teleport 时重触发 15ms 去毛刺包络
    if kTeleport == 1 then
        reinit REINIT_DOPPLER
    endif
REINIT_DOPPLER:
    aDeclick linseg 0, 0.015, 1
    ; 内部平滑滤波器固定在 20Hz
    aDopplered doppler aMono, kSourcePos, kMicPos, 340.29, 200
rireturn

    ; 二元硬切换，不混原声避免 Phasing
    aMixed = (aDopplered * kDopplerSwitch) + (aMono * (1 - kDopplerSwitch))

    aProcessed = aMixed * kTotalGain * aDeclick

    ; 总音量调节与硬幅值限幅
    aMasterL = SoftClip(aProcessed * kMasterGain)
    aMasterR = SoftClip(aProcessed * kMasterGain)

    aDryL, aDryR, aWetL, aWetR DepthStereoRender aMasterL, aMasterR, aX, aY, kMinWet, kMaxWet, kRoomSize
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

    ; --- 6. 混响器 ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05

    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; --- 4 声道 Ambisonics 输出 ---
    aZeroA = 0
    aDecFL, aDecFR, aDecBL, aDecBR AmbiDecode4 aBW, aBX, aBY, aZeroA
    aOutL = aDecFL + aRevL * 0.5
    aOutR = aDecFR + aRevR * 0.5
    aOutBL = aDecBL + aRevL * 0.5
    aOutBR = aDecBR + aRevR * 0.5

    ; 链末端限幅：混响会再抬电平，这里兜底

    aOutL = SoftClip(aOutL)

    aOutR = SoftClip(aOutR)

    aOutBL = SoftClip(aOutBL)

    aOutBR = SoftClip(aOutBR)


    out aOutL, aOutR, aOutBL, aOutBR

    ; --- 7. 视觉与电平反馈 ---
    ; 归一化坐标 60Hz 推送；HTML 负责映射到 pad 画布
    kUIMetro metro 60
    cabbageSetValue "sing_x", portk(kX_disp, 0.02), kUIMetro
    cabbageSetValue "sing_y", portk(kY_disp, 0.02), kUIMetro
    cabbageSetValue "sing_r", portk(kRadius, 0.02), kUIMetro

    ; L/R 主输出电平捕捉
    kOutFL maxk abs(aOutL), kUIMetro, 1
    kOutFR maxk abs(aOutR), kUIMetro, 1
    kOutRL maxk abs(aOutBL), kUIMetro, 1
    kOutRR maxk abs(aOutBR), kUIMetro, 1
    cabbageSetValue "outFL", portk(kOutFL, .05), kUIMetro
    cabbageSetValue "outFR", portk(kOutFR, .05), kUIMetro
    cabbageSetValue "outRL", portk(kOutRL, .05), kUIMetro
    cabbageSetValue "outRR", portk(kOutRR, .05), kUIMetro

    kTeleport = 0
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>
