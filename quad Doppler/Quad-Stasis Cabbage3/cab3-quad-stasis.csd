; Quad-Stasis-Doppler — Cabbage 3 版（cab3-quad-stasis）
; 四声道极简 UI：四区光晕 + 正方形雷达 + 四只电平表
; 自定义 UI 入口见 cabbage.project.json -> index.html
; 数据流:
;   雷达拖拽 / 输入框 -> sendControlData -> x/y 走 DAW 参数，box_x/box_y 直达通道
;   Csound 互锁后把规范化状态通过 cabbageSetValue 推回 box_x/box_y 与四只电平表
;   宿主自动化 x/y -> Csound 检测变化 -> 推回 box_* -> HTML 刷新
;
; ★ 关于四声道导出
;   Cabbage 3 的包装器**不写 channelConfig**，回退读取本 CSD 的 nchnls：
;     nchnls = 4 → 输出 4 声道（不写 nchnls_i：Csound 令其等于 nchnls，即 4 in / 4 out）
;   已实测：这个形式在 Ableton Live 里 AU 四声道正常。
;
;   ✗ 不要用 channelConfig "2+2" 多总线（2026-11-03 实测）：
;     它能通过 Live 的 VST3 总线协商（日志出现 "VST3: Created"），
;     但紧接着创建界面时崩溃（AU 与 VST3 同样闪退），见模板 §9.0。
;   当前 AU 上报的能力是 [in 4..4, out 4..4]（单条 4 声道总线），
;   宿主把输出格式设成 4 声道后即可正常渲染四路 —— 已用 AudioUnitRender 实测：
;     FL/FR/RL/RR 均有真实信号（rms ≈ 0.246），无 NaN、无越界。
;
;   三个注意点：
;   1) auval 会报 "Default Format of unit does not match reported Channel handling
;      capabilities"，因为包装器把默认总线格式固定成 2 声道。这只是**默认值**问题：
;      宿主一旦主动配置 4 声道就正常（已实测 set 4ch 成功、回读 4ch、渲染正确）。
;   2) 输入也是 4 声道（nchnls_i 缺省 = nchnls）。DSP 只用 inch 1,2，多余输入不影响声音。
;   3) 不要用 "2+2" 多总线写法：Lattice 的 process() 只取端口 0，而
;      CabbageProcessor 按总线求和写扁平数组 → 越界写 → 崩溃。单条 4 声道总线是唯一稳定路径。

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "Q3ST",
    "enableDevTools": true,
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Quad-Stasis",
            "size": {
                "width": 380,
                "height": 465
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
                "text": "X"
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
                "text": "Y"
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
                "left": -140,
                "top": -140,
                "width": 60,
                "height": 20
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
        }
    ]
}
</Cabbage>

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
    aCutoff   = 800 + ((aDepthInv * aDepthInv * aDepthInv) * 19200)
    aFiltL    tone aDlyL, aCutoff
    aFiltR    tone aDlyR, aCutoff

    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp     = exp(-aNormDist * aDecayFactor)

    aMono = (aFiltL + aFiltR) * 0.5

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

    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)

    xout aFL, aFR, aRL, aRR, aWetL, aWetR
endop

instr 1
    ; --- 1. 读取前端与宿主自动化状态 ---
    kHostX cabbageGetValue "x"
    kHostY cabbageGetValue "y"
    kBoxX  cabbageGetValue "box_x"
    kBoxY  cabbageGetValue "box_y"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"

    ; --- 2. 边缘检测触发器 ---
    kHostX_Chg changed kHostX
    kHostY_Chg changed kHostY
    kBoxX_Chg  changed kBoxX
    kBoxY_Chg  changed kBoxY

    kX init 0.5
    kY init 0.5

    ; --- 3. 三路控制数据互锁路由（拖拽 / 输入框 / 宿主自动化） ---
    ; 鼠标交互在 HTML 前端，这里只做通道互锁与规范化状态回写
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

    ; 带触发回写，避免 k 率消息洪泛
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

    aFL, aFR, aRL, aRR, aWetL, aWetR QuadRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 5. 干湿送入全局总线，由 instr 2 统一做混响与输出 ---
    gaFL = gaFL + aFL
    gaFR = gaFR + aFR
    gaRL = gaRL + aRL
    gaRR = gaRR + aRR
    gaWetL = gaWetL + aWetL
    gaWetR = gaWetR + aWetR
endin

; =========================================================
; INSTR 2: 单台共享混响 + 主输出 + 四路电平表
; =========================================================
instr 2
    ; Room Size 映射反馈系数，Damping 映射高频截止
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"
    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    kFeedback_sm portk kFeedback, 0.04
    kCutoff_sm   portk kCutoff, 0.04

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

    ; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。

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
