; Quad-SwarmGrain-Doppler — Cabbage 3 版（cab3-quad-swarmgrain）
; 布朗运动源 → 颗粒环形缓冲 → Gaussian 场域空间化 → 全局混响
;
; 四声道版：立体声的 DepthStereoRender 换成 QuadRender（X/Y 等功率分配到 FL/FR/RL/RR，
; 径向距离驱动 vdelay3 做多普勒），干湿送进全局总线，由 instr 2 统一 reverbsc + outq + 四路电平表。
; 包装器不写 channelConfig，只写 nchnls = 4（与 Cabbage 2 版一致，不写 nchnls_i）；写 "2+2" 多总线会越界崩溃。
; 自定义 UI 入口见 cabbage.project.json -> index.html
; 相对 Cabbage 2 版只改了「UI 反馈」这一层：
;   · 10 个 circle* image 热力环、windowTable gentable、pad 遮罩全部由 HTML 自己画
;   · Csound 只推 swarm_x / swarm_y（布朗位置）、g1*/g2*（颗粒火花取样）与 outFL..outRR 四路电平
;   · 所有控件都是隐藏的宿主参数，界面完全由 index.html 决定
;
; 信号流（PARAM_IDX 必须与这里的 widget 书写顺序逐字一致）：
;   Dens → step → centerX → centerY → radius → rangeMin → rangeMax
;   → GSize → DlyMax → reverse → window
;   → minWet → maxWet → roomSize → cutoff → drywet → level


<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "Q3SW",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Quad-SwarmGrain",
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

; 窗口函数表：101 半正弦、102 矩形、103 Hamming、104 Gaussian、105 三角
giw101 ftgen 101, 0, 1024, 9, 0.5, 1, 0
giw102 ftgen 102, 0, 1024, 20, 8, 1
giw104 ftgen 103, 0, 1024, 20, 1, 1
giw105 ftgen 104, 0, 1024, 20, 6, 1
giw103 ftgen 105, 0, 1024, 20, 3, 1
giwindows ftgen 100, 0, 8, -2, 101, 102, 103, 104, 105

giBufL ftgen 0, 0, 1048576, -2, 0
giBufR ftgen 0, 0, 1048576, -2, 0

; 全局总线（四声道：布朗层 + 颗粒层各自一套干声四路，湿声合并成两路）
gaGrainFL, gaGrainFR, gaGrainRL, gaGrainRR init 0
gaRevSendL, gaRevSendR init 0
gaBrownFL, gaBrownFR, gaBrownRL, gaBrownRR init 0
gaBrownWL, gaBrownWR init 0

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
    aBFL, aBFR, aBRL, aBRR, aBWetL, aBWetR QuadRender aFiltered, aFiltered, aWX, aWY, kMinWet, kMaxWet, kRoomSize

    gaBrownFL = aBFL
    gaBrownFR = aBFR
    gaBrownRL = aBRL
    gaBrownRR = aBRR
    gaBrownWL = aBWetL
    gaBrownWR = aBWetR

    ; 颗粒的原始素材仍按立体声折叠（四角之和取半），多普勒已在写入前完成
    aBrownDryL = (aBFL + aBRL) * 0.7071
    aBrownDryR = (aBFR + aBRR) * 0.7071

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

    ; 3. 送入空间摆位（距离模型 + 延迟 + 等功率声像，都在 QuadRender 里）
    kPosX = k(iPosX)
    kPosY = k(iPosY)
    aX interp kPosX
    aY interp kPosY
    aFL, aFR, aRL, aRR, aWetL, aWetR QuadRender aFiltL, aFiltR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; 4. Wet 信号二次高切
    aSafeWetL tone aWetL, 4000
    aSafeWetR tone aWetR, 4000

    ; 5. Drive 与饱和限幅
    kDrive = 1.2
    aSafeWetL = tanh(aSafeWetL * kDrive)
    aSafeWetR = tanh(aSafeWetR * kDrive)

    ; 6. 终极大门：所有处理之后最后乘包络
    aFinalFL = aFL * aenv
    aFinalFR = aFR * aenv
    aFinalRL = aRL * aenv
    aFinalRR = aRR * aenv

    aFinalWetL = aSafeWetL * aenv
    aFinalWetR = aSafeWetR * aenv

    ; 7. 送入全局总线
    gaGrainFL = gaGrainFL + aFinalFL
    gaGrainFR = gaGrainFR + aFinalFR
    gaGrainRL = gaGrainRL + aFinalRL
    gaGrainRR = gaGrainRR + aFinalRR

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
    aMasterFL = gaBrownFL * (1-kmix) + gaGrainFL * kmix
    aMasterFR = gaBrownFR * (1-kmix) + gaGrainFR * kmix
    aMasterRL = gaBrownRL * (1-kmix) + gaGrainRL * kmix
    aMasterRR = gaBrownRR * (1-kmix) + gaGrainRR * kmix

    aMasterWetL = gaBrownWL * (1-kmix) + gaRevSendL * kmix
    aMasterWetR = gaBrownWR * (1-kmix) + gaRevSendR * kmix

    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kRevCutoff, 0.04

    aRevL, aRevR reverbsc aMasterWetL, aMasterWetR, kFeedback_smooth, kCutoff_smooth

    ; 干声四声道 + 混响尾音四角环绕
    aPreOutFL = (aMasterFL + (aRevL * 0.5)) * klevel
    aPreOutFR = (aMasterFR + (aRevR * 0.5)) * klevel
    aPreOutRL = (aMasterRL + (aRevL * 0.5)) * klevel
    aPreOutRR = (aMasterRR + (aRevR * 0.5)) * klevel

    ; Master Bus 终极软限幅器
    aOutFL = SoftClip(aPreOutFL)
    aOutFR = SoftClip(aPreOutFR)
    aOutRL = SoftClip(aPreOutRL)
    aOutRR = SoftClip(aPreOutRR)

    out aOutFL, aOutFR, aOutRL, aOutRR
    kMeterMetro metro 30
    kP1 maxk abs(aOutFL), kMeterMetro, 1
    kP2 maxk abs(aOutFR), kMeterMetro, 1
    kP3 maxk abs(aOutRL), kMeterMetro, 1
    kP4 maxk abs(aOutRR), kMeterMetro, 1

    cabbageSetValue "outFL", portk(kP1, .05), kMeterMetro
    cabbageSetValue "outFR", portk(kP2, .05), kMeterMetro
    cabbageSetValue "outRL", portk(kP3, .05), kMeterMetro
    cabbageSetValue "outRR", portk(kP4, .05), kMeterMetro

    ; 每控制周期清空总线
    clear gaGrainFL, gaGrainFR, gaGrainRL, gaGrainRR, gaRevSendL, gaRevSendR, \
          gaBrownFL, gaBrownFR, gaBrownRL, gaBrownRR, gaBrownWL, gaBrownWR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 3 0 -1
</CsScore>
</CsoundSynthesizer>
