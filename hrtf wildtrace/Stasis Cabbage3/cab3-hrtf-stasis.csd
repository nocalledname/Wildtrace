; Depth-Stasis — Cabbage 3 版（HRTF 双耳渲染）
; 极简黑白 HTML 前端 + Cabbage3 JSON 参数表
; 自定义 UI 入口见 cabbage.project.json -> index.html
; 数据流:
;   雷达拖拽/输入框 -> sendControlData -> (x/y 走 DAW 参数, box_x/box_y 直达通道)
;   Csound 互锁后把规范化状态通过 cabbageSetValue 推回 box_x/box_y 与电平表
;   宿主自动化 x/y -> Csound 检测变化 -> 推回 box_x/box_y -> HTML 刷新

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "H3ST",
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
            "caption": "Cab3-HRTF-Stasis",
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
                "left": 275,
                "top": 78,
                "width": 15,
                "height": 180
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

; 核心操作码:DepthStereoRender(双声道深度渲染引擎,与 Cabbage2 版一致)

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

    ; 统一距离:以 (0.5, 0.5) 画布中心为圆心,统一驱动延迟Doppler、
    ; 空气吸收、距离衰减与混响发送。
    ; 声场是圆盘：归一化坐标里圆盘半径 = 0.5，所以系数取 2.0，
    ; 使盘边 = 1.0。圆外（方形 pad 的四角）按 1.0 截断，
    ; 因为那部分不在声场内（前端也已钳制，这里只是宿主自动化的兜底）。
    aDistance = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2)) * 2.0
    aDistance limit aDistance, 0, 1
    aRoomSize interp kRoomSize

    ; 1. 方位声像:X轴等功率几何平移
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

    ; RoomSize(10~100) 映射到 Feedback 系数(0.15~0.92)
    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77

    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kCutoff, 0.04

    ; 注入双立体声混响矩阵
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; 双声道最终信号合流
    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR

    ; 总输出增益（0~8，1.0 = 单位增益）
    kMasterGain cabbageGetValue "masterGain"
    aOutL = aOutL * kMasterGain
    aOutR = aOutR * kMasterGain
    ; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。
    aOutL = SoftClip(aOutL)
    aOutR = SoftClip(aOutR)

    out aOutL, aOutR

    ; --- 5. 输出电平监听(30Hz 回写,供 HTML 黑白电平表) ---
    kUIMetro metro 30
    kOutL maxk abs(aOutL), kUIMetro, 1
    kOutR maxk abs(aOutR), kUIMetro, 1

    cabbageSetValue "outL", portk(kOutL, .05), kUIMetro
    cabbageSetValue "outR", portk(kOutR, .05), kUIMetro
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>
