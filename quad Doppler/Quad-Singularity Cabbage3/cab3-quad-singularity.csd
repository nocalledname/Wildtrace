; Quad-Singularity-Doppler — Cabbage 3 版（cab3-quad-singularity）
; 引力深渊：粒子沿螺旋轨道坠入（黑洞）或喷出（白洞）奇点
;
; 四声道版：立体声的 DepthStereoRender 换成 QuadRender（X/Y 等功率分配到 FL/FR/RL/RR，
; 径向距离驱动 vdelay3 做多普勒），干湿送进全局总线，由 instr 2 统一 reverbsc + outq + 四路电平表。
; 包装器不写 channelConfig，只写 nchnls = 4（与 Cabbage 2 版一致，不写 nchnls_i）；写 "2+2" 多总线会越界崩溃。
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Orbita 的差别：位置不是匀速圆周，而是「半径按指数律收缩/膨胀」的螺旋。
;   Csound 用 40Hz 的 k 率积分推进 kRadius / kAngle → 推给 sing_x / sing_y → HTML 画粒子。
;   轨道半径 = kRadius（0.001 ~ 0.5），HTML 按 0.5 归一化到 pad 半径。
;   Start / Loop / Mode 是离散状态，走 A 类宿主参数；Csound 自动停机时回写 start。


<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "Q3SG",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Quad-Singularity",
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

; --- 全局总线：干声四声道 + 湿声发送 | global buses: dry quad + wet send ---
gaFL, gaFR, gaRL, gaRR init 0
gaWetL, gaWetR init 0

; [UDO] 四声道多普勒渲染 | quad doppler render
; 中心径向距离驱动 a-rate 延迟（多普勒），X/Y 等功率声像分配到四角，距离插值控制混响发送
opcode QuadRender, aaaaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin

    aX limit aX, 0.001, 0.999

    ; 径向距离（以 (0.5, 0.5) 为圆心）驱动延迟量：远离中心 → 延迟变大 → 音高下降
    aDist = sqrt(((aX - 0.5) ^ 2) + ((aY - 0.5) ^ 2))
    aRoomSize interp kRoomSize
    aDelayTime = 0.01 + (aDist * (aRoomSize * 0.002))
    aDelayTime limit aDelayTime, 0.001, 0.5
    aDlyL vdelay3 aInL, aDelayTime * 1000, 500
    aDlyR vdelay3 aInR, aDelayTime * 1000, 500

    ; Y 取反：标准 Y=1 表示前方，转成数学角 0 后 cos(0)=1，声能集中在前置通道
    aY_inverted = 1 - aY
    aY_val limit aY_inverted, 0.001, 0.999

    aL = cos(aX * 1.570796)
    aR = sin(aX * 1.570796)
    aF = cos(aY_val * 1.570796)
    aB = sin(aY_val * 1.570796)

    ; 归一化径向距离（0 = 盘心，1 = 盘边）
    aNormDist = aDist / 0.7071
    aNormDist limit aNormDist, 0, 1

    ; 距离模型：与 Depth / HRTF / Ambi 的 DepthStereoRender 同一套曲线。
    ; 远了要既变暗也变轻，否则远离中心的声源和中心一样亮、一样响 ——
    ; 四声道下听感就是「远端声源糊在脸上」。
    aDepthInv = 1 - aNormDist
    aCutoff   = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)
    aFiltL    tone aDlyL, aCutoff
    aFiltR    tone aDlyR, aCutoff

    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp     = exp(-aNormDist * aDecayFactor)

    aMono = (aFiltL + aFiltR) * 0.5

    ; 干声四声道（Doppler + 等功率声像）
    ; 干声归一化（-6 dB）：把工作点压回限幅器的线性区
    aDry = 0.5 * aMono * aDistAmp
    aFL = aDry * aL * aF
    aFR = aDry * aR * aF
    aRL = aDry * aL * aB
    aRR = aDry * aR * aB

    ; 湿声发送：min/max 区间按归一化径向距离插值
    aNormDist = aDist / 0.7071
    aNormDist limit aNormDist, 0, 1
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aNormDist * (aMaxWet - aMinWet))
    ; 湿声发送同样乘距离衰减：否则盘边处干声被压 -19~-30 dB，湿声却按
    ; Wet Send Max 涨到 +15.6 dB，湿/干比高达 20 倍 —— 远端只剩混响，
    ; 「音源在消散」的听感被糊成一团。乘上之后湿/干比仍随距离增长
    ; （Wet Send 的 +15.6 dB 保留），但整体电平明确下降。
    aWetSend = aWetSend * aDistAmp
    aWetL = 0.5 * aMono * aWetSend
    aWetR = 0.5 * aMono * aWetSend

    ; 湿声软限幅防爆音
    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)

    xout aFL, aFR, aRL, aRR, aWetL, aWetR
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

    aFL, aFR, aRL, aRR, aWetL, aWetR QuadRender aMasterL, aMasterR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 干湿送入全局总线，由 instr 2 统一做混响与输出 ---
    gaFL = gaFL + aFL
    gaFR = gaFR + aFR
    gaRL = gaRL + aRL
    gaRR = gaRR + aRR
    gaWetL = gaWetL + aWetL
    gaWetR = gaWetR + aWetR

    ; --- 7. 视觉反馈 ---
    ; 归一化坐标 60Hz 推送；HTML 负责映射到 pad 画布
    kUIMetro metro 60
    cabbageSetValue "sing_x", portk(kX_disp, 0.02), kUIMetro
    cabbageSetValue "sing_y", portk(kY_disp, 0.02), kUIMetro
    cabbageSetValue "sing_r", portk(kRadius, 0.02), kUIMetro

    kTeleport = 0
endin

; =========================================================
; INSTR 2: 共享混响 + 主输出 + 四路电平表
; master gain 已在 instr 1 里作用过（aMasterL/aMasterR），这里不再乘一次
; =========================================================
instr 2
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_sm portk kFeedback, 0.05
    kCutoff_sm   portk kCutoff, 0.05

    ; 全插件唯一一台混响，挂在湿声总线上
    aRevL, aRevR reverbsc gaWetL, gaWetR, kFeedback_sm, kCutoff_sm

    ; 干声四声道 + 混响尾音四角环绕
    aOutFL = gaFL + (aRevL * 0.5)
    aOutFR = gaFR + (aRevR * 0.5)
    aOutRL = gaRL + (aRevL * 0.5)
    aOutRR = gaRR + (aRevR * 0.5)

    ; 链末端限幅：混响会再抬电平，这里兜底

    aOutFL = SoftClip(aOutFL)

    aOutFR = SoftClip(aOutFR)

    aOutRL = SoftClip(aOutRL)

    aOutRR = SoftClip(aOutRR)


    out aOutFL, aOutFR, aOutRL, aOutRR
    ; --- 电平表反馈（30 Hz，峰值保持 + 平滑） ---
    kMeterMetro metro 30
    kP1 maxk abs(aOutFL), kMeterMetro, 1
    kP2 maxk abs(aOutFR), kMeterMetro, 1
    kP3 maxk abs(aOutRL), kMeterMetro, 1
    kP4 maxk abs(aOutRR), kMeterMetro, 1

    cabbageSetValue "outFL", portk(kP1, .05), kMeterMetro
    cabbageSetValue "outFR", portk(kP2, .05), kMeterMetro
    cabbageSetValue "outRL", portk(kP3, .05), kMeterMetro
    cabbageSetValue "outRR", portk(kP4, .05), kMeterMetro

    ; --- 清空总线 ---
    clear gaFL, gaFR, gaRL, gaRR, gaWetL, gaWetR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 2 0 -1
</CsScore>
</CsoundSynthesizer>
