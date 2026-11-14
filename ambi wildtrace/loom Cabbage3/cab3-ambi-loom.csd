; Depth-Loom — Cabbage 3 版（4 声道 Ambisonics）
; 编织矩阵 / 八极蛇形穿梭 + 深度渲染
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Cabbage 2 版的差别只在「UI 反馈」这一层：
;   · 原来的 visualBall / aline 两个 image 控件由 HTML 自己画
;   · Csound 只推 loom_x / loom_y（0~1 矩阵坐标）与 outL / outR 电平
;   · 所有旋钮都是隐藏的宿主参数，界面完全由 index.html 决定
;
; 信号流（PARAM_IDX 必须与这里的 widget 书写顺序逐字一致）：
;   rows → cols → path → speed → glide → texture → warp
;   → minWet → maxWet → roomSize → cutoff

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "A3LM",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-Loom",
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
                "text": "Rows"
            },
            "channels": [
                {
                    "id": "rows",
                    "range": {
                        "min": 1,
                        "max": 10,
                        "defaultValue": 4,
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
                "text": "Cols"
            },
            "channels": [
                {
                    "id": "cols",
                    "range": {
                        "min": 1,
                        "max": 10,
                        "defaultValue": 4,
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
                "text": "Path"
            },
            "channels": [
                {
                    "id": "path",
                    "range": {
                        "min": 1,
                        "max": 8,
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
                "text": "Speed"
            },
            "channels": [
                {
                    "id": "speed",
                    "range": {
                        "min": 0.1,
                        "max": 10,
                        "defaultValue": 0.2,
                        "skew": 0.5,
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
                "text": "Glide"
            },
            "channels": [
                {
                    "id": "glide",
                    "range": {
                        "min": 0.001,
                        "max": 0.15,
                        "defaultValue": 0.03,
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
                "text": "Texture"
            },
            "channels": [
                {
                    "id": "texture",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.6,
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
                "text": "Warp"
            },
            "channels": [
                {
                    "id": "warp",
                    "range": {
                        "min": 0,
                        "max": 100,
                        "defaultValue": 5,
                        "skew": 0.4,
                        "increment": 0.01
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
                    "id": "loom_x",
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
                    "id": "loom_y",
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

; Loom 核心操作码：DepthStereoRender（与 Cabbage 2 版一致）
; X 轴 = 立体声左右相位平移，Y 轴 = 物理声学深度

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

    ; 干声同样归一化（-6 dB）：把工作点压回限幅器的线性区，
    ; 音量不足时由末端 Master Gain 补回。
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
    ; 湿声发送：先归一化再软限幅。
    ; reverbsc 在颗粒冲击下有自激励硬伤 —— 哪怕很小的增益也会「滋滋」，
    ; 所以发送端必须保留 tanh 把包络压住；但直接 tanh(满量程) 会削出
    ; 大量谐波，同样脏。这里先乘 0.5（-6 dB）把工作点压回 tanh 的线性区，
    ; 再 tanh，既保底防自激励、又几乎不产生谐波失真。
    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)
    xout aDryL, aDryR, aWetL, aWetR
endop

instr 1
    ; --- 1. 获取 UI 参数 ---
    kRows    cabbageGetValue "rows"
    kCols    cabbageGetValue "cols"
    kPath    cabbageGetValue "path"
    kSpeed   cabbageGetValue "speed"
    kGlide   cabbageGetValue "glide"
    kTexture cabbageGetValue "texture"
    kWarp    cabbageGetValue "warp"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; --- 2. 八极蛇形扫描核心算法 ---
    kTotalCells = kRows * kCols
    kPhasor phasor kSpeed

    ; 路径模式：1-4 水平优先，5-8 垂直优先
    kIsVert = (kPath >= 5) ? 1 : 0

    ; 动态分配逻辑行列（垂直扫描时对调）
    kLogicCols = (kIsVert == 1) ? kRows : kCols
    kLogicRows = (kIsVert == 1) ? kCols : kRows
    kLogicDivX = (kLogicCols > 1) ? (kLogicCols - 1) : 1
    kLogicDivY = (kLogicRows > 1) ? (kLogicRows - 1) : 1

    ; 当前格子索引
    kCurrentCell = limit(floor(kPhasor * kTotalCells), 0, kTotalCells - 1)

    ; 提取基础逻辑行与列
    kLogicRow = floor(kCurrentCell / kLogicCols)
    kLogicCol = kCurrentCell % kLogicCols

    ; 奇数行折返（S型弯折）
    kIsOddRow = kLogicRow % 2
    kLogicCol = (kIsOddRow == 1) ? (kLogicCols - 1 - kLogicCol) : kLogicCol

    ; 获取 0-1 基础矩阵空间
    kBaseX = kLogicCol / kLogicDivX
    kBaseY = kLogicRow / kLogicDivY

    ; 逻辑空间映射回物理 XY 轴
    kRawX = (kIsVert == 1) ? kBaseY : kBaseX
    kRawY = (kIsVert == 1) ? kBaseX : kBaseY

    ; 起点镜像翻转（解析 1-8 角点）
    kInvX = (kPath == 3 || kPath == 4 || kPath == 7 || kPath == 8) ? 1 : 0
    kInvY = (kPath == 2 || kPath == 4 || kPath == 6 || kPath == 8) ? 1 : 0

    ; 最终目标坐标
    kX_target = (kInvX == 1) ? (1 - kRawX) : kRawX
    kY_target = (kInvY == 1) ? (1 - kRawY) : kRawY

    ; --- 3. 梭子平滑与张力包络 ---
    kX portk kX_target, kGlide
    kY portk kY_target, kGlide

    ; 声场是圆盘，织机必须落在它的内接正方形里：坐标向内收 1/√2，
    ; 四个角的节点正好贴在圆上，落到扬声器上不会有任何一点出盘。
    ; 与前端 FIG_FIT 必须同值。推给 UI 的 loom_x / loom_y 仍是原始矩阵坐标。
    kFigFit = 0.70710678
    kXf = 0.5 + (kX - 0.5) * kFigFit
    kYf = 0.5 + (kY - 0.5) * kFigFit

    aX interp kXf
    aY interp kYf

    kLocalPhase = (kPhasor * kTotalCells) % 1
    kPulse = sin(kLocalPhase * 3.14159265)

    kAmpMod = kTexture + (1 - kTexture) * kPulse
    aAmp interp kAmpMod

    ; --- 4. 针脚交织物理建模（延迟多普勒） ---
    aInL, aInR inch 1, 2

    kDelayMod = (kX + kY) * kWarp
    aDelayTime interp (10 + kDelayMod)

    aWarpL vdelay3 aInL, aDelayTime, 260
    aWarpR vdelay3 aInR, aDelayTime, 260

    aWarpL = aWarpL * aAmp
    aWarpR = aWarpR * aAmp

    ; --- 5. 深度渲染 ---
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aWarpL, aWarpR, aX, aY, kMinWet, kMaxWet, kRoomSize
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
    aOutL  = SoftClip(aOutL)
    aOutR  = SoftClip(aOutR)
    aOutBL = SoftClip(aOutBL)
    aOutBR = SoftClip(aOutBR)

    out aOutL, aOutR, aOutBL, aOutBR

    ; --- 7. 视觉与电平反馈（60 Hz） ---
    kTrig metro 60
    cabbageSetValue "loom_x", kX, kTrig
    cabbageSetValue "loom_y", kY, kTrig

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
