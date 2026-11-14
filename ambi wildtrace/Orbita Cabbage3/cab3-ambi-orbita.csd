; Depth-Orbita — Cabbage 3 版（4 声道 Ambisonics）
; 深蓝 / 橙红 配色，HTML 前端重构
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Stasis 的差别：这里的位置是「自动轨道运动」，不是用户拖拽。
;   Csound 用 phasor 生成 kX_raw / kY_raw → 推给 orb_x / orb_y → HTML 画小球。
;   轨道路径 = 椭圆：半轴 a = radius*1.4142*Shape（水平），b = radius*1.4142*(1-Shape)（垂直）
;   HTML 直接画这条椭圆，所以调 Shape 时轨道形状会实时变化。

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "A3OB",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-Orbita",
            "size": {
                "width": 400,
                "height": 588
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
                "text": "Speed"
            },
            "channels": [
                {
                    "id": "speed",
                    "range": {
                        "min": 0.1,
                        "max": 20,
                        "defaultValue": 0.25,
                        "skew": 0.25,
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
                "text": "Radius"
            },
            "channels": [
                {
                    "id": "radius",
                    "range": {
                        "min": 0,
                        "max": 0.353,
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
                "text": "Shape"
            },
            "channels": [
                {
                    "id": "Shape",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.01
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
                    "off": "CCW",
                    "on": "CW"
                }
            },
            "channels": [
                {
                    "id": "dir",
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
                    "id": "orb_x",
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
                    "id": "orb_y",
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
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": 24,
                "top": 60,
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
                "left": 283,
                "top": 60,
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
                "left": 283,
                "top": 60,
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
                "left": 283,
                "top": 60,
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

; Orbita 核心操作码：DepthStereoRender（与 Cabbage2 版一致）
; X 轴 = 立体声左右相位平移，Y 轴 = 物理声学绝对深度

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

    ; 1. 方位：X轴等功率左右平移
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
    ; --- 1. 读取轨道与状态参数 ---
    kDir    cabbageGetValue "dir"
    kSpeed  cabbageGetValue "speed"
    kRad    cabbageGetValue "radius"
    kInvert cabbageGetValue "Shape"

    ; 声学引擎参数
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; --- 2. 动力学计算（生成二维坐标） ---
    kPhasor phasor kSpeed
    kMaxRad = kRad * 1.4142

    if kDir == 0 then
        ; [逆时针] CCW
        kX_raw = 0.5 + (cos(kPhasor * 2 * $M_PI) * kMaxRad * kInvert)
        kY_raw = 0.5 + (sin(kPhasor * 2 * $M_PI) * kMaxRad * (1 - kInvert))
    else
        ; [顺时针] CW
        kX_raw = 0.5 + (cos(-1 * kPhasor * 2 * $M_PI) * kMaxRad * kInvert)
        kY_raw = 0.5 + (sin(-1 * kPhasor * 2 * $M_PI) * kMaxRad * (1 - kInvert))
    endif

    aX interp limit(kX_raw, 0, 1)
    aY interp limit(kY_raw, 0, 1)

    ; --- 3. 深度引擎处理 ---
    aInL, aInR inch 1, 2
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize
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

    ; --- 4. 混响器 ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05

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

    ; --- 5. 视觉与电平反馈 ---
    ; 轨道位置 60Hz 推送；HTML 负责把归一化坐标映射到画布
    kTrig metro 60
    cabbageSetValue "orb_x", kX_raw, kTrig
    cabbageSetValue "orb_y", kY_raw, kTrig

    ; L/R 主输出电平捕捉
    kOutFL maxk abs(aOutL), kTrig, 1
    kOutFR maxk abs(aOutR), kTrig, 1
    kOutRL maxk abs(aOutBL), kTrig, 1
    kOutRR maxk abs(aOutBR), kTrig, 1
    cabbageSetValue "outFL", portk(kOutFL, .05), kTrig
    cabbageSetValue "outFR", portk(kOutFR, .05), kTrig
    cabbageSetValue "outRL", portk(kOutRL, .05), kTrig
    cabbageSetValue "outRR", portk(kOutRR, .05), kTrig

endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>
