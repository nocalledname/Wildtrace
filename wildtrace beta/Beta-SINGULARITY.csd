<Cabbage>
form caption("Beta-Singularity") size(700, 435), guiMode("queue"), pluginId("BTSI") colour(12, 18, 51, 255)
image bounds(0, 0, 700, 435) colour(12, 18, 51, 255) channel("bg")

; =========================================================
; UI 区域 1：THE SINGULARITY PAD (引力深渊视觉反馈区 / Gravity Abyss Visual Feedback Area)
; =========================================================
image bounds(50, 50, 300, 300) colour(0, 0, 0, 255) outlineThickness(1) outlineColour(255, 120, 40, 160) channel("image12")

; --- 背景星空装饰层 / Background Starfield Decoration Layer ---
image bounds(85, 120, 2, 2) shape("circle") colour(0, 255, 255, 200)
image bounds(145, 90, 1, 1) shape("circle") colour(255, 255, 255, 240)
image bounds(230, 210, 3, 3) shape("circle") colour(138, 43, 226, 190)
image bounds(315, 65, 2, 2) shape("circle") colour(255, 215, 0, 200)
image bounds(72, 280, 1, 1) shape("circle") colour(255, 105, 180, 160)
image bounds(190, 320, 3, 3) shape("circle") colour(0, 191, 255, 210)
image bounds(280, 150, 2, 2) shape("circle") colour(0, 255, 127, 180)
image bounds(110, 250, 1, 1) shape("circle") colour(255, 99, 71, 150)
image bounds(330, 290, 3, 3) shape("circle") colour(255, 255, 210, 190)
image bounds(60, 180, 2, 2) shape("circle") colour(0, 255, 255, 170)
image bounds(205, 85, 1, 1) shape("circle") colour(138, 43, 226, 210)
image bounds(260, 110, 3, 3) shape("circle") colour(255, 255, 220, 220)
image bounds(340, 220, 2, 2) shape("circle") colour(255, 215, 0, 180)
image bounds(95, 65, 1, 1) shape("circle") colour(0, 191, 255, 190)
image bounds(175, 275, 3, 3) shape("circle") colour(255, 105, 180, 170)
image bounds(295, 310, 2, 2) shape("circle") colour(0, 255, 127, 160)
image bounds(130, 160, 1, 1) shape("circle") colour(255, 255, 210, 200)
image bounds(245, 335, 3, 3) shape("circle") colour(138, 43, 226, 180)
image bounds(80, 315, 2, 2) shape("circle") colour(0, 255, 255, 210)
image bounds(215, 130, 1, 1) shape("circle") colour(255, 99, 71, 170)
image bounds(310, 175, 3, 3) shape("circle") colour(255, 255, 230, 230)
image bounds(160, 200, 2, 2) shape("circle") colour(255, 215, 0, 190)
image bounds(105, 95, 1, 1) shape("circle") colour(0, 191, 255, 180)
image bounds(270, 70, 3, 3) shape("circle") colour(255, 105, 180, 150)
image bounds(335, 115, 2, 2) shape("circle") colour(0, 255, 127, 200)
image bounds(120, 290, 1, 1) shape("circle") colour(138, 43, 226, 190)
image bounds(225, 260, 3, 3) shape("circle") colour(255, 255, 210, 180)
image bounds(285, 235, 2, 2) shape("circle") colour(0, 255, 255, 160)
image bounds(150, 110, 1, 1) shape("circle") colour(255, 255, 255, 250)
image bounds(195, 170, 3, 3) shape("circle") colour(255, 99, 71, 140)
image bounds(65, 225, 2, 2) shape("circle") colour(255, 215, 0, 210)
image bounds(255, 190, 1, 1) shape("circle") colour(0, 191, 255, 200)
image bounds(320, 330, 3, 3) shape("circle") colour(255, 105, 180, 180)
image bounds(140, 240, 2, 2) shape("circle") colour(0, 255, 127, 170)
image bounds(90, 145, 1, 1) shape("circle") colour(138, 43, 226, 220)
image bounds(235, 95, 3, 3) shape("circle") colour(255, 255, 210, 200)
image bounds(305, 135, 2, 2) shape("circle") colour(0, 255, 255, 190)
image bounds(165, 305, 1, 1) shape("circle") colour(255, 255, 255, 240)
image bounds(290, 280, 3, 3) shape("circle") colour(255, 215, 0, 170)
image bounds(115, 215, 2, 2) shape("circle") colour(255, 99, 71, 160)
image bounds(185, 105, 1, 1) shape("circle") colour(0, 191, 255, 210)
image bounds(265, 160, 3, 3) shape("circle") colour(255, 105, 180, 190)
image bounds(345, 75, 2, 2) shape("circle") colour(0, 255, 127, 180)
image bounds(75, 170, 1, 1) shape("circle") colour(138, 43, 226, 200)
image bounds(210, 295, 3, 3) shape("circle") colour(255, 255, 210, 210)
image bounds(135, 80, 2, 2) shape("circle") colour(0, 255, 255, 180)
image bounds(325, 205, 1, 1) shape("circle") colour(255, 255, 255, 255)
image bounds(240, 140, 3, 3) shape("circle") colour(255, 215, 0, 200)
image bounds(100, 275, 2, 2) shape("circle") colour(255, 99, 71, 150)
image bounds(180, 230, 1, 1) shape("circle") colour(0, 191, 255, 190)
image bounds(275, 335, 3, 3) shape("circle") colour(255, 105, 180, 160)
image bounds(55, 105, 2, 2) shape("circle") colour(0, 255, 127, 190)
image bounds(155, 325, 1, 1) shape("circle") colour(138, 43, 226, 170)
image bounds(220, 60, 3, 3) shape("circle") colour(255, 255, 210, 200)
image bounds(300, 255, 2, 2) shape("circle") colour(0, 255, 255, 210)
image bounds(85, 205, 1, 1) shape("circle") colour(255, 255, 255, 230)
image bounds(250, 285, 3, 3) shape("circle") colour(255, 215, 0, 190)
image bounds(125, 135, 2, 2) shape("circle") colour(255, 99, 71, 180)
image bounds(335, 165, 1, 1) shape("circle") colour(0, 191, 255, 200)
image bounds(195, 85, 2, 2) shape("circle") colour(255, 105, 180, 170)

; --- 奇点核心渐变层 (吸积盘) / Singularity Core Gradient Layer (Accretion Disk) ---
image bounds(100, 100, 200, 200) shape("circle") colour(150, 30, 12, 10) channel("image19") outlineColour(150, 30, 12, 10)
image bounds(102, 102, 196, 196) shape("circle") colour(150, 40, 11, 30) channel("image21") outlineColour(150, 40, 11, 30)
image bounds(104, 104, 192, 192) shape("circle") colour(150, 50, 10, 50) channel("image23") outlineColour(150, 50, 10, 50)
image bounds(106, 106, 188, 188) shape("circle") colour(150, 60, 9, 70) channel("image25") outlineColour(150, 60, 9, 70)
image bounds(108, 108, 184, 184) shape("circle") colour(150, 70, 8, 90) channel("image27") outlineColour(150, 70, 8, 90)
image bounds(110, 110, 180, 180) shape("circle") colour(150, 80, 7, 110) channel("image28") outlineColour(150, 80, 7, 110)
image bounds(112, 112, 176, 176) shape("circle") colour(150, 90, 6, 130) channel("image29") outlineColour(150, 90, 6, 130)
image bounds(114, 114, 172, 172) shape("circle") colour(150, 100, 5, 150) channel("image30") outlineColour(150, 100, 5, 150)
image bounds(116, 116, 168, 168) shape("circle") colour(150, 110, 4, 170) channel("image31") outlineColour(150, 110, 14, 170)
image bounds(118, 118, 164, 164) shape("circle") colour(150, 120, 3, 190) channel("image32") outlineColour(150, 120, 3, 190)
image bounds(120, 120, 160, 160) shape("circle") colour(150, 130, 2, 210) channel("image33") outlineColour(150, 130, 2, 210)
image bounds(122, 122, 156, 156) shape("circle") colour(150, 140, 1, 230) channel("image34") outlineColour(150, 140, 1, 230)
image bounds(124, 124, 152, 152) shape("circle") colour(150, 150, 0, 255) channel("image35") outlineColour(150, 15, 0, 250)
image bounds(126, 126, 148, 148) shape("circle") colour(0, 0, 0, 255) channel("black") outlineColour(0, 0, 0, 255)

; --- 四声道视觉反馈 (电平表) / Quadraphonic Visual Feedback (VU Meters) ---
vmeter bounds(58, 36, 30, 50), channel("m1"), text("FL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(2.35, 0, 0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 205, 68, 255)
vmeter bounds(364, 60, 30, 50), channel("m2"), text("FR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(3.9269, 0, 0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 205, 68, 255)
vmeter bounds(36, 342, 30, 50), channel("m3"), text("RL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(0.7853, 0, 0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 205, 68, 255)
vmeter bounds(340, 362, 30, 50), channel("m4"), text("RR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(5.4977, 0, 0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 205, 68, 255)

; --- 核心参数控制旋钮 / Core Parameter Control Knobs ---
rslider bounds(460, 152, 130, 130), channel("masterGain"), range(0, 4, 2, 1, 0.01), text("Master Gain"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 255) markerColour(255, 68, 50, 255) colour(255, 205, 68, 255)
rslider bounds(352, 202, 70, 70), channel("fallTime"), range(0.1, 600, 4, 0.25, 0.01), text("Fall Time(s)"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) markerColour(255, 255, 255, 255) colour(0, 0, 0, 255)
rslider bounds(378, 300, 60, 60), channel("spinSpeed"), range(0.05, 0.5, 0.25, 1, 0.001), text("Spin Speed"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)
rslider bounds(584, 276, 65, 50), channel("gravityCurve"), range(0.2, 5, 0.5, 0.4, 0.01), text("Gravity Curve"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)
rslider bounds(564, 222, 63, 46), channel("inputGain"), range(0, 4, 1, 1, 0.01), text("Input Gain"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)

; --- 多普勒引擎控制 / Doppler Engine Control ---
; [UI 更新 / UI Update]: Doppler Mix 旋钮重构为二元自锁硬切换按钮 (Button)，以简化交互逻辑并避免干湿比 Phasing 现象
; Refactored from a continuous knob to a binary hard-switch button to simplify interaction and avoid wet/dry phasing.
button bounds(448, 372, 71, 35), channel("dopplerMode"), text("Raw Audio", "Doppler"), , value(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 68, 50, 255), fontColour:1(255, 205, 68, 255)

rslider bounds(544, 342, 75, 50), channel("dopplerFactor"), range(-100, 100, -100, 1, 0.1), text("Doppler Factor"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)

; --- 功能与状态控制按钮 / Function and State Control Buttons ---
button bounds(484, 44, 180, 33), channel("mode"), text("White/Black Hole", "White/Black Hole"), latched(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 68, 50, 255), fontColour:1(255, 205, 68, 255), rotate(-0.2, 0, 0)
button bounds(404, 106, 100, 28), channel("loop"), text("Loop", "Loop", "", ""), , value(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 68, 50, 255), fontColour:1(255, 205, 68, 255), rotate(-0.7, 0, 0)
button bounds(362, 174, 63, 41), channel("start"), text("Start", "Stop"), latched(1), value(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 70, 53, 255), fontColour:1(255, 205, 68, 255), rotate(-1.1, 0, 0)

; --- 声像准星追踪器 / Panning Reticle Tracker ---
image bounds(195, 195, 8, 8) shape("circle") colour(255, 215, 0, 255) outlineColour(180, 180, 180, 255) channel("particle") outlineThickness(1)

; --- 装饰边框与品牌声明 / Decorative Border and Brand Statement ---
image bounds(0, 420, 700, 15) colour(5, 5, 25, 255)
label bounds(0, 420, 700, 15), text("WILDTRACE SERIES"), fontColour(255, 205, 68, 255), align("right") channel("label49")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>

<CsInstruments>
ksmps = 64
nchnls = 4
0dbfs = 1

; =========================================================================
; [UDO] QuadRender: 四声道空间声像映射模块 / Quadraphonic Panning Module
; =========================================================================
opcode QuadRender, aaaa, aaaa
    aInL, aInR, aX, aY xin
    
    aX limit aX, 0, 1
    aY limit aY, 0, 1

    aL = cos(aX * 1.5707963)
    aR = sin(aX * 1.5707963)
    aF = cos(aY * 1.5707963)
    aB = sin(aY * 1.5707963)

    aMid = (aInL + aInR) * 0.5
    aMid limit aMid, -1, 1

    aFL = aMid * aL * aF
    aFR = aMid * aR * aF
    aRL = aMid * aL * aB
    aRR = aMid * aR * aB
    
    xout aFL, aFR, aRL, aRR
endop

instr 1
    ; =========================================================================
    ; 1. 读取控制参数 / Control Signals Acquisition
    ; =========================================================================
    kSpinSpeed  cabbageGetValue "spinSpeed"
    kFallTime   cabbageGetValue "fallTime"
    kMasterGain cabbageGetValue "masterGain"
    kMode       cabbageGetValue "mode" 
    kInputGain  cabbageGetValue "inputGain"
    kEnvIndex   cabbageGetValue "gravityCurve"
    kLoop       cabbageGetValue "loop"
    kstart      cabbageGetValue "start"
    
    ; [DSP 逻辑 / DSP Logic]: 获取多普勒模式开关 / Fetch Doppler mode switch state
    kDopplerMode cabbageGetValue "dopplerMode"
    ; 采用 15ms 内部交叉线性平滑 (portk)，消除开关硬切换瞬间可能产生的 Click 噪声
    ; Apply 15ms internal linear portamento (portk) to eliminate clicks during hard mode switches
    kDopplerSwitch portk kDopplerMode, 0.015 

    kDopplerScaleRaw cabbageGetValue "dopplerFactor"
    kDopplerScale portk kDopplerScaleRaw, 0.05

    ; =========================================================================
    ; 2. 核心状态初始化 / State Initialization
    ; =========================================================================
    kOldMode   init 0
    kRadius    init 0.5
    kAngle     init 0
    kTeleport  init 0  

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

    ; =========================================================================
    ; 3. 双向非线性螺旋运动引擎 / Non-linear Spiral Kinematics Engine
    ; =========================================================================
    if kTrig == 1 && kstart == 1 then
        kAngle = kAngle + kSpinSpeed       
        
        if kMode == 0 then
            ; [黑洞模式 / Black Hole Mode]: 吸积效应，向核心衰减 / Accretion effect, decay towards the core
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
            ; [白洞模式 / White Hole Mode]: 喷射效应，从核心向外扩张 / Ejection effect, expand outward from the core
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

    ; --- 声像坐标映射与位移平滑 / Panning Coordinate Mapping and Displacement Smoothing ---
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

    ; =========================================================================
    ; 4. 音频 DSP 处理架构 / Audio DSP Architecture
    ; =========================================================================
    
    ; [DSP 修复 1 / DSP Fix 1]: 边界保护门限 / Edge Protection Gate
    ; 作用：解决由于重力曲线导致物理循环边界处能量不为 0 而引发的突变脉冲/颗粒爆音。
    ; Purpose: Prevents sudden transient/granular pops caused by non-zero energy at loop boundaries due to gravity curves.
    kEdgeFade init 1
    if kstart == 1 then
        if kMode == 0 then
            ; 黑洞模式：当粒子逼近 0.001 时（在 0.012 处切入），强制让增益平滑衰减至 0
            ; Black Hole: Smoothly ramp gain down to 0 as particle approaches 0.001 (triggering at 0.012)
            if kRadius < 0.012 then
                kEdgeFade = (kRadius - 0.001) / (0.012 - 0.001)
            else
                kEdgeFade = 1
            endif
        else
            ; 白洞模式：当粒子逼近 0.5 时（在 0.488 处切入），强制让增益平滑衰减至 0
            ; White Hole: Smoothly ramp gain down to 0 as particle approaches 0.5 (triggering at 0.488)
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

    ; [DSP 修复 2 / DSP Fix 2]: Start/Stop 按钮动态斜坡防护 / Start/Stop Dynamic Ramping Protection
    ; 作用：手动按下启停时提供 15ms 的平滑包络，防止音频截断爆音
    ; Purpose: Provides a 15ms smoothing envelope on manual start/stop to prevent truncation clicks.
    kStartSmooth portk kstart, 0.015 

    ; --- 声学衰减与多普勒时空扭曲模块 / Acoustic Attenuation and Doppler Spacetime Warping Module ---
    kNormRadius limit (kRadius / 0.5), 0, 1
    kGainEnv = pow(kNormRadius, kEnvIndex)
    
    ; 终极合并增益控制矩阵：基础重力曲线 × 循环边界门限 × 启停保护包络
    ; Ultimate Combined Gain Control Matrix: Base Gravity Curve × Loop Edge Gate × Start/Stop Protection Envelope
    kTotalGain = kGainEnv * kEdgeFade * kStartSmooth
    kTotalGain portk kTotalGain, 0.005 ; 添加微量的 k 速率平滑，消除控制信号步进导致的数字毛刺 (Zipper noise) / Add minor k-rate smoothing to eliminate control signal zipper noise.
    
    aInL, aInR inch 1, 2
    aMono = (aInL + aInR) * 0.5 * kInputGain
    
    if kDopplerScale >= 0 then
        kSourcePos = kNormRadius * kDopplerScale
        kMicPos = 0
    else
        kSourcePos = (1 - kNormRadius) * abs(kDopplerScale)
        kMicPos = 0
    endif
    
    ; [DSP 修复 3 / DSP Fix 3]: 空间重置保护 (15ms Anti-click De-zipper Envelope) / Spatial Reset Protection
    if kTeleport == 1 then
        reinit REINIT_DOPPLER
    endif
REINIT_DOPPLER:
    aDeclick linseg 0, 0.015, 1
    ; 内部平滑滤波器固定在 20Hz 截止频率，提供稳定的多普勒频移过渡
    ; Internal smoothing filter fixed at 20Hz cutoff, providing a stable Doppler frequency shift transition
    aDopplered doppler aMono, kSourcePos, kMicPos, 340.29, 200
rireturn
    
    ; [信号路由更新 / Signal Routing Update]: 直接使用二元硬切换，不再混入原声（干湿比），从而彻底消除相位抵消 (Phasing) 问题
    ; Directly uses binary hard-switching without mixing dry audio, completely eliminating phasing issues.
    aMixed = (aDopplered * kDopplerSwitch) + (aMono * (1 - kDopplerSwitch))
    
    aProcessed = aMixed * kTotalGain * aDeclick

    ; 总音量调节与硬限幅 (Hard Clipping) / Master volume adjustment and hard clipping
    aMasterL limit (aProcessed * kMasterGain), -1, 1
    aMasterR limit (aProcessed * kMasterGain), -1, 1

    ; 四声道空间声像渲染输出 / Quadraphonic spatial panning render output
    aFL, aFR, aRL, aRR QuadRender aMasterL, aMasterR, aX, aY
    outq aFL, aFR, aRL, aRR

    ; =========================================================================
    ; 5. 前端 UI 动态通信与像素重映射 (UI Telemetry) / Frontend UI Telemetry & Pixel Remapping
    ; =========================================================================
    kUIMetro metro 30 
    
    kParticleSize = 4 + (kNormRadius * 8)
    kPx = 50 + (kX_disp * 300) - (kParticleSize / 2)
    kPy = 50 + (kY_disp * 300) - (kParticleSize / 2)

    cabbageSet kUIMetro, "particle", "bounds", kPx, kPy, kParticleSize, kParticleSize

    if kMode == 1 then
        cabbageSet kUIMetro, "black", "colour(220, 220, 220, 255)"
        cabbageSet kUIMetro, "black", "outlineColour(220, 220, 220, 255)"
    else
        cabbageSet kUIMetro, "black", "colour(0, 0, 0, 255)"
        cabbageSet kUIMetro, "black", "outlineColour(0, 0, 0, 255)"
    endif

    kP1 max_k abs(aFL), kUIMetro, 1
    kP2 max_k abs(aFR), kUIMetro, 1
    kP3 max_k abs(aRL), kUIMetro, 1
    kP4 max_k abs(aRR), kUIMetro, 1

    cabbageSetValue "m1", portk(kP1, 0.05), kUIMetro
    cabbageSetValue "m2", portk(kP2, 0.05), kUIMetro
    cabbageSetValue "m3", portk(kP3, 0.05), kUIMetro
    cabbageSetValue "m4", portk(kP4, 0.05), kUIMetro

    kTeleport = 0
endin
</CsInstruments>

<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>