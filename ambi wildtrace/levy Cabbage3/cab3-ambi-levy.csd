; Depth-Levy — Cabbage 3 版（4 声道 Ambisonics）
; 血红 / 暗绿 雷达画风，对应莱维飞行的捕猎者野性姿态
; 自定义 UI 入口见 cabbage.project.json -> index.html

<Cabbage>
{
    "pluginId": "A3LV",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-Levy",
            "size": {
                "width": 507,
                "height": 747
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
                        "min": 0.5,
                        "max": 20,
                        "defaultValue": 4,
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
                "text": "Alpha"
            },
            "channels": [
                {
                    "id": "alpha",
                    "range": {
                        "min": 0.3,
                        "max": 2,
                        "defaultValue": 1.1,
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
                "text": "Scale"
            },
            "channels": [
                {
                    "id": "scale",
                    "range": {
                        "min": 0.05,
                        "max": 1,
                        "defaultValue": 0.4,
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
                "text": "Damp"
            },
            "channels": [
                {
                    "id": "damp",
                    "range": {
                        "min": 0,
                        "max": 1,
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
                "text": "Chaos"
            },
            "channels": [
                {
                    "id": "chaos",
                    "range": {
                        "min": 0,
                        "max": 0.08,
                        "defaultValue": 0.05,
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
                "text": "Inertia"
            },
            "channels": [
                {
                    "id": "inertia",
                    "range": {
                        "min": 0.001,
                        "max": 0.4,
                        "defaultValue": 0.01,
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
                    "id": "levy_x",
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
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 20
            },
            "channels": [
                {
                    "id": "levy_y",
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
                "left": -140,
                "top": -140,
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
                "left": -140,
                "top": -140,
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
                "left": -140,
                "top": -140,
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
                "left": -140,
                "top": -140,
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

; [UDO] 核心双声道深度渲染引擎 | core stereo depth render engine

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
    kRate   cabbageGetValue "rate"
    kAlpha  cabbageGetValue "alpha"
    kScale  cabbageGetValue "scale"
    kDamp   cabbageGetValue "damp"
    kChaos  cabbageGetValue "chaos"
    kInert  cabbageGetValue "inertia"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; --- 2. 莱维飞行核心计算（事件驱动） ---
    kX_acc init 0.5
    kY_acc init 0.5

    ; 离散时钟触发器
    kStepTrig metro kRate

    if kStepTrig == 1 then
        ; [第一套随机]：突发飞行的矢量角度 (0..2*PI)
        kRandAng random 0, 6.283185307

        ; [第二套随机]：构筑逆变换幂函数分布
        kRnd1 random 0.001, 1.0
        kRnd2 random 0.001, 1.0

        ; 经典莱维长尾算式（陡峭幂函数产生大跨步）
        kTail pow kRnd2, (-1.0 / kAlpha)

        ; 动态步长抑制：越靠边缘，大跳跃被压制得越小
        kDistFromCenter = sqrt((kX_acc - 0.5)^2 + (kY_acc - 0.5)^2)
        kSuppressedScale = kScale * (1.0 - limit(kDistFromCenter * kDamp * 1.414, 0, 0.95))

        ; 两套随机结合幂函数产生最终步长
        kStepRaw = kRnd1 * kTail * kSuppressedScale * 0.1
        kStep limit kStepRaw, 0, 0.95

        ; 极坐标向量叠加至累加器
        kX_acc = kX_acc + (cos(kRandAng) * kStep)
        kY_acc = kY_acc + (sin(kRandAng) * kStep)

        ; 盘边镜像折返：声场是以 (0.5, 0.5) 为圆心、半径 0.5 的圆盘，
        ; 方形 pad 的四角在盘外，所以没有"墙"可撞，只能关于盘边镜射回来。
        ; 越界量原样折回（最多折到圆心 0.01，避免穿过中心后方向反转）。
        kDdx = kX_acc - 0.5
        kDdy = kY_acc - 0.5
        kDrad = sqrt(kDdx*kDdx + kDdy*kDdy)
        if kDrad > 0.5 then
            kOver = min(kDrad - 0.5, 0.49)
            kX_acc = 0.5 + (kDdx / kDrad) * (0.5 - kOver)
            kY_acc = 0.5 + (kDdy / kDrad) * (0.5 - kOver)
        endif
    endif

    ; 叠加高频细碎混沌微颤
    kChsX random -kChaos, kChaos
    kChsY random -kChaos, kChaos

    kX_final = limit(kX_acc + kChsX, 0, 1)
    kY_final = limit(kY_acc + kChsY, 0, 1)

    ; 平滑插值（Inertia 过冲滑行）
    aX interp portk(kX_final, kInert)
    aY interp portk(kY_final, kInert)

    ; --- 3. 音频捕获与深度渲染 ---
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
    ; 归一化坐标 60Hz 推送；HTML 负责映射到雷达画布
    kTrig metro 60
    cabbageSetValue "levy_x", portk(kX_final, 0.02), kTrig
    cabbageSetValue "levy_y", portk(kY_final, 0.02), kTrig

    ; 双声道电平捕捉
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
i 1 0 86400
</CsScore>
</CsoundSynthesizer>
