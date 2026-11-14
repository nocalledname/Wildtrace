; Depth-Stasis — Cabbage 3 版（4 声道 Ambisonics）
; 极简黑白 HTML 前端 + Cabbage3 JSON 参数表
; 自定义 UI 入口见 cabbage.project.json -> index.html
; 数据流:
;   雷达拖拽/输入框 -> sendControlData -> (x/y 走 DAW 参数, box_x/box_y 直达通道)
;   Csound 互锁后把规范化状态通过 cabbageSetValue 推回 box_x/box_y 与电平表
;   宿主自动化 x/y -> Csound 检测变化 -> 推回 box_x/box_y -> HTML 刷新

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "A3ST",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Ambi-Stasis",
            "size": {
                "width": 320,
                "height": 490
            },
            "guiMode": "queue"
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -100,
                "top": -100,
                "width": 50,
                "height": 20
            },
            "channels": [
                {
                    "id": "x",
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
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -100,
                "top": -100,
                "width": 50,
                "height": 20
            },
            "channels": [
                {
                    "id": "y",
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
                "left": 70,
                "top": 275,
                "width": 85,
                "height": 28
            },
            "channels": [
                {
                    "id": "box_x",
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
                "left": 165,
                "top": 275,
                "width": 85,
                "height": 28
            },
            "channels": [
                {
                    "id": "box_y",
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
            "type": "horizontalSlider",
            "visible": true,
            "automatable": true,
            "bounds": {
                "left": 70,
                "top": 332,
                "width": 88,
                "height": 28
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
            "visible": true,
            "automatable": true,
            "bounds": {
                "left": 162,
                "top": 332,
                "width": 88,
                "height": 28
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
            "visible": true,
            "automatable": true,
            "bounds": {
                "left": 65,
                "top": 385,
                "width": 85,
                "height": 85
            },
            "label": {
                "text": "Room Size"
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
            "visible": true,
            "automatable": true,
            "bounds": {
                "left": 170,
                "top": 385,
                "width": 85,
                "height": 85
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
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": 30,
                "top": 78,
                "width": 15,
                "height": 180
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
                "left": 275,
                "top": 78,
                "width": 15,
                "height": 180
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
                "left": 275,
                "top": 78,
                "width": 15,
                "height": 180
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
                "left": 275,
                "top": 78,
                "width": 15,
                "height": 180
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

; 核心操作码:DepthStereoRender(双声道深度渲染引擎,与 Cabbage2 版一致)

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

    ; 统一距离:以 (0.5, 0.5) 画布中心为圆心,统一驱动延迟Doppler、
    ; 空气吸收、距离衰减与混响发送。
    ; 声场是圆盘：归一化坐标里圆盘半径 = 0.5，所以系数取 2.0，
    ; 使盘边 = 1.0。圆外（方形 pad 的四角）按 1.0 截断，
    ; 因为那部分不在声场内（前端也已钳制，这里只是宿主自动化的兜底）。
    aDistance = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2)) * 2.0
    aDistance limit aDistance, 0, 1
    aRoomSize interp kRoomSize

    ; 1. 方位声像:X轴等功率几何平移
    ; 不再在此处做左右平移：声像改由调用方按声源逐个编码成 B-format
    ; （多声源插件必须每个声源用自己的方位角编码，否则方向信息会丢失）
    aMono = (aInL + aInR) * 0.5

    aPanL = aMono
    aPanR = aMono

    ; 2. 动态多普勒距离延迟
    aDelayTime = 0.01 + (aDistance * (aRoomSize * 0.002))
    aDlyL vdelay3 aPanL, aDelayTime * 1000, 500
    aDlyR vdelay3 aPanR, aDelayTime * 1000, 500

    ; 3. 空气声学吸收(高频随深度衰减)
    aDepthInv = 1 - aDistance
    aAirCutoff = 800 + ((aDepthInv * aDepthInv * aDepthInv) * 19200)

    aFiltL tone aDlyL, aAirCutoff
    aFiltR tone aDlyR, aAirCutoff

    ; 4. 空间平方反比衰减(与房间尺寸绑定)
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDistance * aDecayFactor)

    aDryL = 0.5 * aFiltL * aDistAmp
    aDryR = 0.5 * aFiltR * aDistAmp

    ; 5. 声能空间反射混响发送矩阵
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

; 主乐器:参数互锁 + DSP + UI 回写
instr 1
    ; --- 1. 读取前端与宿主自动化状态 ---
    kHostX cabbageGetValue "x"
    kHostY cabbageGetValue "y"
    kBoxX  cabbageGetValue "box_x"
    kBoxY  cabbageGetValue "box_y"

    kMinWet cabbageGetValue "minWet"
    kMaxWet cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; --- 2. 边缘检测触发器 ---
    kHostX_Chg changed kHostX
    kHostY_Chg changed kHostY
    kBoxX_Chg  changed kBoxX
    kBoxY_Chg  changed kBoxY

    kX init 0.5
    kY init 0.5

    ; --- 3. 三路控制数据互锁路由(拖拽/输入/宿主自动化) ---
    ; 鼠标交互已移到 HTML 前端,这里只负责通道互锁与规范化状态回写
    if (kBoxX_Chg == 1 && abs(kBoxX - kX) > 0.001) then
        kX = kBoxX
        kXChg = 1
    elseif (kHostX_Chg == 1 && abs(kHostX - kX) > 0.001) then
        kX = kHostX
        kXChg = 1
    else
        kXChg = 0
    endif

    if (kBoxY_Chg == 1 && abs(kBoxY - kY) > 0.001) then
        kY = kBoxY
        kYChg = 1
    elseif (kHostY_Chg == 1 && abs(kHostY - kY) > 0.001) then
        kY = kHostY
        kYChg = 1
    else
        kYChg = 0
    endif

    ; x/y 通道与 box_x/box_y 读数保持同步(带触发,避免 k 率消息洪泛)
    cabbageSetValue "x", kX, kXChg
    cabbageSetValue "y", kY, kYChg
    cabbageSetValue "box_x", kX, kXChg
    cabbageSetValue "box_y", kY, kYChg

    ; --- 4. DSP 渲染与防爆音平滑 ---
    kX_smooth portk limit(kX, 0, 1), 0.06
    kY_smooth portk limit(kY, 0, 1), 0.06

    aX interp kX_smooth
    aY interp kY_smooth

    aInL, aInR inch 1, 2

    ; 接入核心空间运算
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

    ; RoomSize(10~100) 映射到 Feedback 系数(0.15~0.92)
    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77

    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kCutoff, 0.04

    ; 注入双立体声混响矩阵
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; 双声道最终信号合流
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

    ; --- 5. 输出电平监听(30Hz 回写,供 HTML 黑白电平表) ---
    kUIMetro metro 30
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
