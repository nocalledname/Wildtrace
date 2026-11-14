; Depth-Orbita — Cabbage 3 版（HRTF 双耳渲染）
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
    "pluginId": "H3OB",
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
            "caption": "Cab3-HRTF-Orbita",
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
                "left": 283,
                "top": 60,
                "width": 13,
                "height": 170
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

; Orbita 核心操作码：DepthStereoRender（与 Cabbage2 版一致）
; X 轴 = 立体声左右相位平移，Y 轴 = 物理声学绝对深度

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
    aRoomSize interp kRoomSize

    ; 1. 方位：X轴等功率左右平移
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

    ; --- 4. 混响器 ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05

    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

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

    ; --- 5. 视觉与电平反馈 ---
    ; 轨道位置 60Hz 推送；HTML 负责把归一化坐标映射到画布
    kTrig metro 60
    cabbageSetValue "orb_x", kX_raw, kTrig
    cabbageSetValue "orb_y", kY_raw, kTrig

    ; L/R 主输出电平捕捉
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
