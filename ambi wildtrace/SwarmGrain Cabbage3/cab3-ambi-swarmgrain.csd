; Depth-SwarmGrain — Cabbage 3 版（4 声道 Ambisonics）
; 布朗运动源 → 颗粒环形缓冲 → Gaussian 场域空间化 → 全局混响
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Cabbage 2 版的差别只在「UI 反馈」这一层：
;   · 10 个 circle* image 热力环、windowTable gentable、pad 遮罩全部由 HTML 自己画
;   · Csound 只推 swarm_x / swarm_y（布朗位置）、g1*/g2*（颗粒火花取样）与 outL / outR
;   · 所有控件都是隐藏的宿主参数，界面完全由 index.html 决定
;
; 信号流（PARAM_IDX 必须与这里的 widget 书写顺序逐字一致）：
;   Dens → step → centerX → centerY → radius → rangeMin → rangeMax
;   → GSize → DlyMax → reverse → window
;   → minWet → maxWet → roomSize → cutoff → drywet → level

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "A3SW",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-SwarmGrain",
            "size": {
                "width": 620,
                "height": 820
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
                "text": "Density"
            },
            "channels": [
                {
                    "id": "Dens",
                    "range": {
                        "min": 1,
                        "max": 500,
                        "defaultValue": 100,
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
                "text": "Step"
            },
            "channels": [
                {
                    "id": "step",
                    "range": {
                        "min": 0.001,
                        "max": 0.5,
                        "defaultValue": 0.5,
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
                "text": "Center X"
            },
            "channels": [
                {
                    "id": "centerX",
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
                "text": "Center Y"
            },
            "channels": [
                {
                    "id": "centerY",
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
                "text": "Field Radius"
            },
            "channels": [
                {
                    "id": "radius",
                    "range": {
                        "min": 0.01,
                        "max": 0.5,
                        "defaultValue": 0.25,
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
                "text": "Range Min"
            },
            "channels": [
                {
                    "id": "rangeMin",
                    "range": {
                        "min": 20,
                        "max": 20000,
                        "defaultValue": 20000,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Range Max"
            },
            "channels": [
                {
                    "id": "rangeMax",
                    "range": {
                        "min": 20,
                        "max": 20000,
                        "defaultValue": 100,
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Grain Size"
            },
            "channels": [
                {
                    "id": "GSize",
                    "range": {
                        "min": 0.005,
                        "max": 1,
                        "defaultValue": 0.1,
                        "skew": 0.5,
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
                "text": "Max Delay"
            },
            "channels": [
                {
                    "id": "DlyMax",
                    "range": {
                        "min": 0.01,
                        "max": 5,
                        "defaultValue": 1,
                        "skew": 0.5,
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
                "text": "Reverse Prob"
            },
            "channels": [
                {
                    "id": "reverse",
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
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 24
            },
            "label": {
                "text": "Window"
            },
            "channels": [
                {
                    "id": "window",
                    "range": {
                        "min": 1,
                        "max": 5,
                        "defaultValue": 4,
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
                "text": "Dry / Wet"
            },
            "channels": [
                {
                    "id": "drywet",
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
                    "id": "level",
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
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "swarm_x",
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
                    "id": "swarm_y",
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
<CsOptions>
-n -d -+rtmidi=NULL -m0
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

; 窗口函数表：101 半正弦、102 矩形、103 Hamming、104 Gaussian、105 三角
giw101 ftgen 101, 0, 1024, 9, 0.5, 1, 0
giw102 ftgen 102, 0, 1024, 20, 8, 1
giw104 ftgen 103, 0, 1024, 20, 1, 1
giw105 ftgen 104, 0, 1024, 20, 6, 1
giw103 ftgen 105, 0, 1024, 20, 3, 1
giwindows ftgen 100, 0, 8, -2, 101, 102, 103, 104, 105

giBufL ftgen 0, 0, 1048576, -2, 0
giBufR ftgen 0, 0, 1048576, -2, 0

; 全局总线
gaGrainW, gaGrainX, gaGrainY init 0
gaRevSendL, gaRevSendR init 0
gaBrownW, gaBrownX, gaBrownY init 0
gaBrownWL, gaBrownWR init 0

; [UDO] 空间摆位渲染器

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

    ; 不再在此处做左右平移：声像改由调用方按声源逐个编码成 B-format
    ; （多声源插件必须每个声源用自己的方位角编码，否则方向信息会丢失）
    aMono = (aInL + aInR) * 0.5

    aPanL = aMono
    aPanR = aMono

    aDelayTime = 0.1 + (aDistance * aRoomSize)
    aDlyL vdelay3 aPanL, aDelayTime, 150
    aDlyR vdelay3 aPanR, aDelayTime, 150

    aDepthInv = 1 - aDistance
    aCutoff = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)

    aFiltL tone aDlyL, aCutoff
    aFiltR tone aDlyR, aCutoff

    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDistance * aDecayFactor)

    aDryL = 0.5 * aFiltL * aDistAmp
    aDryR = 0.5 * aFiltR * aDistAmp

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

; INSTR 1: 母体调度与布朗运动
instr 1
    kDens     cabbageGetValue "Dens"
    kGSize    cabbageGetValue "GSize"
    kDlyMax   cabbageGetValue "DlyMax"
    kreverse  cabbageGetValue "reverse"
    kwindow   cabbageGetValue "window"

    kCenterX  cabbageGetValue "centerX"
    kCenterY  cabbageGetValue "centerY"
    kRadius   cabbageGetValue "radius"
    kStepBase cabbageGetValue "step"

    ; 盘心钳制：声场是以 (0.5, 0.5) 为圆心、半径 0.5 的圆盘，
    ; 方形 pad 的四角在盘外，前端 markDisc/clampDisc01 也把中心点收到盘内。
    kCdx = kCenterX - 0.5
    kCdy = kCenterY - 0.5
    kCrad = sqrt(kCdx*kCdx + kCdy*kCdy)
    if kCrad > 0.5 then
        kCenterX = 0.5 + kCdx / kCrad * 0.5
        kCenterY = 0.5 + kCdy / kCrad * 0.5
    endif

    kRanMin   cabbageGetValue "rangeMin"
    kRanMax   cabbageGetValue "rangeMax"

    ; --- 高斯布朗运动 ---
    kX init 0.5
    kY init 0.5
    kTrig metro kDens

    if kTrig == 1 then
        kAng random 0, 6.2831853
        kStep gauss kStepBase
        kNextX = kX + cos(kAng) * kStep
        kNextY = kY + sin(kAng) * kStep
        kNextX = kNextX + (kCenterX - kNextX) * 0.15
        kNextY = kNextY + (kCenterY - kNextY) * 0.15
        kX limit kNextX, 0, 1
        kY limit kNextY, 0, 1
        ; 盘内钳制：游走点超出盘边就沿半径收回到盘上（与前端 clampDisc01 一致）
        kWdx = kX - 0.5
        kWdy = kY - 0.5
        kWrad = sqrt(kWdx*kWdx + kWdy*kWdy)
        if kWrad > 0.5 then
            kX = 0.5 + kWdx / kWrad * 0.5
            kY = 0.5 + kWdy / kWrad * 0.5
        endif
    endif

    kX_disp portk kX, 0.05
    kY_disp portk kY, 0.05

    ; --- 捕获音频 + 布朗串联处理 ---
    aL, aR inch 1, 2

    kDist = sqrt((kX_disp - kCenterX)^2 + (kY_disp - kCenterY)^2)
    kNormDist = limit(kDist / kRadius, 0, 1)

    kGaussFilter exp -(kNormDist * kNormDist * 5)
    kCutoff = kRanMin + ((kRanMax - kRanMin) * kGaussFilter)
    kCutoff_sm portk kCutoff, 0.05

    aMono = aL + aR
    aFiltered butterlp aMono, kCutoff_sm

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    aWX interp kX_disp
    aWY interp kY_disp
    aBrownDryL, aBrownDryR, aBrownWetL, aBrownWetR DepthStereoRender aFiltered, aFiltered, aWX, aWY, kMinWet, kMaxWet, kRoomSize

    ; 本声源的 B-format 编码（方位角取本声源自己的坐标）
    kXeBr downsamp aWX
    kYeBr downsamp aWY
    kXeBr = limit(kXeBr, 0, 1)
    kYeBr = limit(kYeBr, 0, 1)
    kDxeBr = kXeBr - 0.5
    kDyeBr = kYeBr - 0.5
    kRaeBr = min(1.0, sqrt(kDxeBr * kDxeBr + kDyeBr * kDyeBr) / 0.5)
    kAreBr taninv2 kDxeBr, kDyeBr
    kAceBr = kAreBr * 57.2957795
    kAceBr wrap kAceBr, 0, 360
    ; 中心处方位角无定义，锁定正前（此时 X/Y 已趋于 0，无可听跳变）
    kAceBr = (kRaeBr < 0.0005 ? 0 : kAceBr)
    ; Cabbage 角度是顺时针(0=前,90=右)，bformenc1 要逆时针，故取 360-a
    kAlpBr = 360 - kAceBr
    kAlpBr wrap kAlpBr, 0, 360
    aBWBr, aBXBr, aBYBr, aBZBr bformenc1 aBrownDryL, kAlpBr, 0
    gaBrownW = aBWBr
    gaBrownX = aBXBr
    gaBrownY = aBYBr
    gaBrownWL = aBrownWetL
    gaBrownWR = aBrownWetR

    ilen = ftlen(giBufL)
    aptr phasor sr/ilen
    aWriteIdx = aptr * ilen
    tablew aBrownDryL, aWriteIdx, giBufL
    tablew aBrownDryR, aWriteIdx, giBufR

    kptr downsamp aWriteIdx

    ; --- 实例化调度 ---
    ktrig metro kDens
    kMinDly = 0
    kMaxDly = kDlyMax + 0.001
    ioffset = 1/sr

    if ktrig == 1 then
        kDly random 0, 1
        kDly = kDly * kMaxDly
        schedkwhen ktrig, 0, 0, 2, kDly+0.0001, kGSize, kptr, kreverse, kDly, kMinDly+ioffset, kMaxDly+0.0001, kwindow, kCenterX, kCenterY, kRadius, kRanMin, kRanMax

    endif

    ; --- UI 视讯刷新（30 fps） ---
    kUIMetro metro 30
    if kUIMetro == 1 then
        cabbageSetValue "swarm_x", kX_disp, kUIMetro
        cabbageSetValue "swarm_y", kY_disp, kUIMetro
    endif
endin

; INSTR 2: McCurdy 颗粒对象 + Wildtrace 空间滤波
instr 2
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"

    iGStart = p4
    ireverse = (rnd(1) > p5 ? 1 : -1)
    idly = p6
    iMinDly = p7
    iMaxDly = p8
    iwindow table p9 - 1, 100

    iCX = p10
    iCY = p11
    iRadius = p12
    iRanMin = p13
    iRanMax = p14

    ; 物理位置分布
    iR = iRadius * sqrt(rnd(1))
    iTheta = rnd(6.2831853)
    iPosX = limit(iCX + iR * cos(iTheta), 0.001, 0.999)
    iPosY = limit(iCY + iR * sin(iTheta), 0.001, 0.999)

    ; 盘内钳制：颗粒位置同样收进以 (0.5, 0.5) 为心的圆盘，
    ; 否则盘外四角会得到无法到达的声像增益
    iPdx = iPosX - 0.5
    iPdy = iPosY - 0.5
    iPrad = sqrt(iPdx*iPdx + iPdy*iPdy)
    if iPrad > 0.5 then
        iPosX = 0.5 + iPdx / iPrad * 0.5
        iPosY = 0.5 + iPdy / iPrad * 0.5
    endif

    ; 滤波映射
    iDist = sqrt((iPosX - iCX)^2 + (iPosY - iCY)^2)
    iNormDist = limit(iDist / (iRadius + 0.0001), 0, 1)

    iGauss = exp(-(iNormDist * iNormDist * 5))
    iCutoff = iRanMin * ((iRanMax / iRanMin) ^ iGauss)

    ; 强制安全读取偏移（延迟+颗粒长度）
    iStrtOS = (idly + p3) * sr

    aline line iGStart - iStrtOS, p3, iGStart - iStrtOS + (p3 * sr * ireverse)
    aenv oscili 1, 1/p3, iwindow

    ; 1. 提取原始采样
    aL tablei aline, giBufL, 0, 0, 1
    aR tablei aline, giBufR, 0, 0, 1

    ; 2. 原始高斯滤波
    aFiltL butterlp aL, iCutoff
    aFiltR butterlp aR, iCutoff

    ; 此时不乘 aenv！保留未修剪信号送入空间渲染

    ; 3. 送入空间摆位（延迟+距离衰减）
    kPosX = k(iPosX)
    kPosY = k(iPosY)
    aX interp kPosX
    aY interp kPosY
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aFiltL, aFiltR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; 4. Wet 信号二次高切
    aSafeWetL tone aWetL, 4000
    aSafeWetR tone aWetR, 4000

    ; 5. Drive 与饱和限幅
    kDrive = 1.2
    aSafeWetL = tanh(aSafeWetL * kDrive)
    aSafeWetR = tanh(aSafeWetR * kDrive)

    ; 6. 终极大门：所有处理之后最后乘包络
    aFinalDryL = aDryL * aenv
    aFinalDryR = aDryR * aenv

    aFinalWetL = aSafeWetL * aenv
    aFinalWetR = aSafeWetR * aenv

    ; 7. 送入全局总线（在 B-format 域累加，每颗粒用自己的方位角）
    ; 本声源的 B-format 编码（方位角取本声源自己的坐标）
    kXeGr downsamp aX
    kYeGr downsamp aY
    kXeGr = limit(kXeGr, 0, 1)
    kYeGr = limit(kYeGr, 0, 1)
    kDxeGr = kXeGr - 0.5
    kDyeGr = kYeGr - 0.5
    kRaeGr = min(1.0, sqrt(kDxeGr * kDxeGr + kDyeGr * kDyeGr) / 0.5)
    kAreGr taninv2 kDxeGr, kDyeGr
    kAceGr = kAreGr * 57.2957795
    kAceGr wrap kAceGr, 0, 360
    ; 中心处方位角无定义，锁定正前（此时 X/Y 已趋于 0，无可听跳变）
    kAceGr = (kRaeGr < 0.0005 ? 0 : kAceGr)
    ; Cabbage 角度是顺时针(0=前,90=右)，bformenc1 要逆时针，故取 360-a
    kAlpGr = 360 - kAceGr
    kAlpGr wrap kAlpGr, 0, 360
    aBWGr, aBXGr, aBYGr, aBZGr bformenc1 aFinalDryL, kAlpGr, 0
    gaGrainW = gaGrainW + aBWGr
    gaGrainX = gaGrainX + aBXGr
    gaGrainY = gaGrainY + aBYGr

    gaRevSendL = gaRevSendL + aFinalWetL
    gaRevSendR = gaRevSendR + aFinalWetR
endin

; INSTR 3: 输出终端与全局混响（Master Bus）
instr 3
    kmix  cabbageGetValue "drywet"
    klevel cabbageGetValue "level"

    kRoomSize  cabbageGetValue "roomSize"
    kRevCutoff cabbageGetValue "cutoff"

    ; 串联：空间化布朗干声写入颗粒环形缓冲，粒子由该缓冲生成
    aBW = gaBrownW * (1-kmix) + gaGrainW * kmix
    aBX = gaBrownX * (1-kmix) + gaGrainX * kmix
    aBY = gaBrownY * (1-kmix) + gaGrainY * kmix

    aMasterWetL = gaBrownWL * (1-kmix) + gaRevSendL * kmix
    aMasterWetR = gaBrownWR * (1-kmix) + gaRevSendR * kmix

    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kRevCutoff, 0.04

    aRevL, aRevR reverbsc aMasterWetL, aMasterWetR, kFeedback_smooth, kCutoff_smooth

    ; --- 4 声道 Ambisonics 输出 ---
    aZeroA = 0
    aDecFL, aDecFR, aDecBL, aDecBR AmbiDecode4 aBW, aBX, aBY, aZeroA
    aPreOutL  = (aDecFL + aRevL * 0.5) * klevel
    aPreOutR  = (aDecFR + aRevR * 0.5) * klevel
    aPreOutBL = (aDecBL + aRevL * 0.5) * klevel
    aPreOutBR = (aDecBR + aRevR * 0.5) * klevel

    ; Master Bus 终极软限幅器
    aOutL  = SoftClip(aPreOutL)
    aOutR  = SoftClip(aPreOutR)
    aOutBL = SoftClip(aPreOutBL)
    aOutBR = SoftClip(aPreOutBR)

    out aOutL, aOutR, aOutBL, aOutBR

    kUIMetro metro 30
    kOutFL maxk abs(aOutL), kUIMetro, 1
    kOutFR maxk abs(aOutR), kUIMetro, 1
    kOutRL maxk abs(aOutBL), kUIMetro, 1
    kOutRR maxk abs(aOutBR), kUIMetro, 1
    cabbageSetValue "outFL", portk(kOutFL, .05), kUIMetro
    cabbageSetValue "outFR", portk(kOutFR, .05), kUIMetro
    cabbageSetValue "outRL", portk(kOutRL, .05), kUIMetro
    cabbageSetValue "outRR", portk(kOutRR, .05), kUIMetro

    ; 每控制周期清空总线
    clear gaGrainW, gaGrainX, gaGrainY, gaRevSendL, gaRevSendR, gaBrownW, gaBrownX, gaBrownY, gaBrownWL, gaBrownWR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 3 0 -1
</CsScore>
</CsoundSynthesizer>
