; Quad-Loom-Doppler — Cabbage 3 版（cab3-quad-loom）
; 编织矩阵 / 八极蛇形穿梭 + 深度渲染
;
; 四声道版：立体声的 DepthStereoRender 换成 QuadRender（X/Y 等功率分配到 FL/FR/RL/RR，
; 径向距离驱动 vdelay3 做多普勒），干湿送进全局总线，由 instr 2 统一 reverbsc + outq + 四路电平表。
; 包装器不写 channelConfig，只写 nchnls = 4（与 Cabbage 2 版一致，不写 nchnls_i）；写 "2+2" 多总线会越界崩溃。
; 自定义 UI 入口见 cabbage.project.json -> index.html
; 相对 Cabbage 2 版只改了「UI 反馈」这一层：
;   · 原来的 visualBall / aline 两个 image 控件由 HTML 自己画
;   · Csound 只推 loom_x / loom_y（0~1 矩阵坐标）与 outFL..outRR 四路电平
;   · 所有旋钮都是隐藏的宿主参数，界面完全由 index.html 决定
;
; 信号流（PARAM_IDX 必须与这里的 widget 书写顺序逐字一致）：
;   rows → cols → path → speed → glide → texture → warp
;   → minWet → maxWet → roomSize → cutoff


<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "Q3LM",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Quad-Loom",
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
; 软膝限幅器：|x| ≤ 0.85 时**完全线性**（零谐波），
; 超过后按 C1 连续地压到 0.98 上限。
; 之所以不用 tanh：tanh 从 0.5 起就开始明显弯曲，
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
    ; 湿声发送：先归一化再软限幅。
    ; reverbsc 在颗粒冲击下有自激励硬伤 —— 哪怕很小的增益也会「滋滋」，
    ; 所以发送端必须保留 tanh 把包络压住；但直接 tanh(满量程) 会削出
    ; 大量谐波，同样脏。这里先乘 0.5（-6 dB）把工作点压回 tanh 的线性区，
    ; 再 tanh，既保底防自激励、又几乎不产生谐波失真。
    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)

    xout aFL, aFR, aRL, aRR, aWetL, aWetR
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

    aX interp kX
    aY interp kY

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
    aFL, aFR, aRL, aRR, aWetL, aWetR QuadRender aWarpL, aWarpR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 干湿送入全局总线，由 instr 2 统一做混响与输出 ---
    gaFL = gaFL + aFL
    gaFR = gaFR + aFR
    gaRL = gaRL + aRL
    gaRR = gaRR + aRR
    gaWetL = gaWetL + aWetL
    gaWetR = gaWetR + aWetR

    ; --- 7. 视觉反馈（60 Hz） ---
    kTrig metro 60
    cabbageSetValue "loom_x", kX, kTrig
    cabbageSetValue "loom_y", kY, kTrig
endin

; =========================================================
; INSTR 2: 共享混响 + 主输出 + 四路电平表
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

    ; 总输出增益（0~8，1.0 = 单位增益）
    kMasterGain cabbageGetValue "masterGain"
    aOutFL = aOutFL * kMasterGain
    aOutFR = aOutFR * kMasterGain
    aOutRL = aOutRL * kMasterGain
    aOutRR = aOutRR * kMasterGain

    ; 唯一的限幅器：链末端（混响之后、出声之前）
    aOutFL = SoftClip(aOutFL)
    aOutFR = SoftClip(aOutFR)
    aOutRL = SoftClip(aOutRL)
    aOutRR = SoftClip(aOutRR)

    out aOutFL, aOutFR, aOutRL, aOutRR
    ; --- 电平表反馈（30 Hz，峰值保持 + 平滑） ---
    kUIMetro metro 30
    kP1 maxk abs(aOutFL), kUIMetro, 1
    kP2 maxk abs(aOutFR), kUIMetro, 1
    kP3 maxk abs(aOutRL), kUIMetro, 1
    kP4 maxk abs(aOutRR), kUIMetro, 1

    cabbageSetValue "outFL", portk(kP1, .05), kUIMetro
    cabbageSetValue "outFR", portk(kP2, .05), kUIMetro
    cabbageSetValue "outRL", portk(kP3, .05), kUIMetro
    cabbageSetValue "outRR", portk(kP4, .05), kUIMetro

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
