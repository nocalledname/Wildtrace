;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-Singularity.vst3

<Cabbage>
form caption("Depth-Singularity") size(700, 460), guiMode("queue"), pluginId("DPSI") colour(12, 18, 51, 255)
image bounds(0, 0, 700, 460) colour(12, 18, 51, 255) channel("bg")

; UI 区域 1：THE SINGULARITY PAD（引力深渊） | singularity pad (gravity well)
image bounds(50, 50, 300, 300) colour(0, 0, 0, 255) outlineThickness(1) outlineColour(255, 120, 40, 160) channel("image12")

; 漫天星光层 | starfield layer
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

; 奇点核心渐变层 | singularity core gradient layers
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

; 视觉反馈（电平表） | meters
vmeter bounds(24, 50, 15, 300), channel("outL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), value(0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)
vmeter bounds(362, 50, 15, 301), channel("outR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), value(0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)

; 控制旋钮组 | control knobs
rslider bounds(480, 152, 130, 130), channel("masterGain"), range(0, 4, 2, 1, 0.01), text("Master Gain"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 255) markerColour(255, 68, 50, 255) colour(255, 205, 68, 255)
rslider bounds(378, 212, 70, 70), channel("fallTime"), range(0.1, 600, 4, 0.25, 0.01), text("Fall Time(s)"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) markerColour(255, 255, 255, 255) colour(0, 0, 0, 255)
rslider bounds(412, 314, 60, 60), channel("spinSpeed"), range(0.05, 0.5, 0.25, 1, 0.001), text("Spin Speed"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)
rslider bounds(604, 278, 65, 50), channel("gravityCurve"), range(0.2, 5, 0.5, 0.4, 0.01), text("Gravity Curve"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)
rslider bounds(592, 220, 63, 46), channel("inputGain"), range(0, 4, 1, 1, 0.01), text("Input Gain"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)

; Doppler Mix 升级为二元自锁硬切换按钮 | doppler mix as two-state toggle button
button bounds(492, 376, 71, 35), channel("dopplerMode"), text("Raw Audio", "Doppler"), , value(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 68, 50, 255), fontColour:1(255, 205, 68, 255)

rslider bounds(576, 342, 75, 50), channel("dopplerFactor"), range(-100, 100, -100, 1, 0.1), text("Doppler Factor"), fontColour(255, 205, 68, 255), trackerColour(255, 68, 50, 255), valueTextBox(1), textColour(255, 68, 50, 200) colour(0, 0, 0, 255) markerColour(255, 255, 255, 255)

; 装饰边框与声明 | decorative footer & label
image bounds(0, 445, 700, 15) colour(5, 5, 25, 255) channel("image106")
label bounds(0, 445, 700, 15), text("WILDTRACE SERIES"), fontColour(255, 205, 68, 255), align("right") channel("label49")


; 功能型按钮组 | function buttons
button bounds(512, 44, 180, 33), channel("mode"), text("White/Black Hole", "White/Black Hole"), latched(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 68, 50, 255), fontColour:1(255, 205, 68, 255), rotate(-0.2, 0, 0)
button bounds(424, 108, 100, 28), channel("loop"), text("Loop", "Loop", "", ""), , value(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 68, 50, 255), fontColour:1(255, 205, 68, 255), rotate(-0.7, 0, 0)
button bounds(380, 174, 63, 41), channel("start"), text("Start", "Stop"), latched(1), value(1), colour:0(0, 0, 0, 0), colour:1(0, 0, 0, 0), fontColour:0(255, 70, 53, 255), fontColour:1(255, 205, 68, 255), rotate(-1.1, 0, 0)
; 准星粒子 | crosshair particle
image bounds(195, 195, 8, 8) shape("circle") colour(255, 215, 0, 255) outlineColour(180, 180, 180, 255) channel("particle") outlineThickness(1)


; 声学旋钮（底部） | acoustic knobs
hrange bounds(98, 394, 200, 20), channel("minWet", "maxWet"), range(0, 1, 0.1:0.3, 0.65, 0.001), trackerColour(255, 205, 68, 255)   max(1) min(0) colour(149, 113, 113, 255) colour:0(255, 68, 50, 255)
rslider bounds(10, 360, 60, 60), channel("roomSize"), range(10, 100, 50, 1, 0.1),      text("Room"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255) colour(255, 68, 50, 255) markerColour(255, 205, 68, 255) textColour(255, 68, 50, 255)
rslider bounds(326, 358, 60, 60), channel("cutoff"), range(1000, 16000, 6000, 0.5, 1), text("Damp"), fontColour(255, 68, 50, 255), trackerColour(255, 205, 68, 255) colour(255, 68, 50, 255) markerColour(255, 205, 68, 255) textColour(255, 68, 50, 255)
label bounds(98, 378, 201, 15) text("Wet Send Range (Min / Max)") fontColour(255, 205, 68, 255) channel("mm") colour(0, 0, 0, 255)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>

<CsInstruments>
ksmps = 64
nchnls = 2
0dbfs = 1

; Singularity 核心操作码：DepthStereoRender | Singularity core opcode
; X 轴 = 立体声左右相位平移 | X = stereo pan
; Y 轴 = 物理声学绝对深度 | Y = depth
opcode DepthStereoRender, aaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin
    
    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999
    
    ; Y 轴直通深度 | Y = depth
    aDepth = aY
    aRoomSize interp kRoomSize
    
    ; 1. 方位：X轴等功率左右平移 | equal-power X pan
    aL_pan = cos(aX * 1.570796)
    aR_pan = sin(aX * 1.570796)
    aMono = (aInL + aInR) * 0.5
    
    aPanL = aMono * aL_pan
    aPanR = aMono * aR_pan
    
    ; 2. 距离延迟 | distance delay
    aDelayTime = 0.1 + (aDepth * aRoomSize)
    aDlyL vdelay3 aPanL, aDelayTime, 150
    aDlyR vdelay3 aPanR, aDelayTime, 150
    
    ; 3. 空气吸收（高频随深度衰减） | air absorption (highs roll off with depth)
    aDepthInv = 1 - aDepth
    aCutoff = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)
    
    aFiltL tone aDlyL, aCutoff
    aFiltR tone aDlyR, aCutoff
    
    ; 4. 空间衰减（与房间大小绑定） | distance attenuation tied to room size
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDepth * aDecayFactor) 
    
    aDryL = aFiltL * aDistAmp
    aDryR = aFiltR * aDistAmp
    
    ; 5. 空间混响发送量 | reverb send amount
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDepth * (aMaxWet - aMinWet))
    
    aWetL = aFiltL * aWetSend
    aWetR = aFiltR * aWetSend
    
    xout aDryL, aDryR, aWetL, aWetR
endop

instr 1
    ; --- 1. 读取控制参数 | read control parameters ---
    kSpinSpeed   cabbageGetValue "spinSpeed"
    kFallTime     cabbageGetValue "fallTime"
    kMasterGain  cabbageGetValue "masterGain"
    kMode        cabbageGetValue "mode" 
    kInputGain   cabbageGetValue "inputGain"
    kEnvIndex    cabbageGetValue "gravityCurve"
    kLoop        cabbageGetValue "loop"
    kstart       cabbageGetValue "start"
    
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"
    
    ; 获取多普勒模式开关 | doppler mode switch
    kDopplerMode cabbageGetValue "dopplerMode"
    kDopplerSwitch portk kDopplerMode, 0.015 ; 15ms 交叉线性平滑防爆音 | 15 ms crossfade to avoid clicks

    kDopplerScaleRaw cabbageGetValue "dopplerFactor"
    kDopplerScale portk kDopplerScaleRaw, 0.05

    ; --- 2. 核心状态初始化 | state init ---
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

    ; --- 3. 双向非线性螺旋物理引擎 | two-way nonlinear spiral engine ---
    if kTrig == 1 && kstart == 1 then
        kAngle = kAngle + kSpinSpeed       
        
        if kMode == 0 then
            ; 【黑洞模式】 | black hole mode
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
            ; 【白洞模式】 | white hole mode
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

    ; 声像位移平滑 | pan position smoothing
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
    ; 【硬核修复 1】边缘防护淡出门 | fix 1: edge protection gate
    ; =========================================================================
    kEdgeFade init 1
    if kstart == 1 then
        if kMode == 0 then
            ; 黑洞模式：逼近 0.001 时增益平滑迫降到0 | black hole: fade gain to 0 near 0.001
            if kRadius < 0.012 then
                kEdgeFade = (kRadius - 0.001) / (0.012 - 0.001)
            else
                kEdgeFade = 1
            endif
        else
            ; 白洞模式：逼近 0.5 时增益平滑迫降到0 | white hole: fade gain to 0 near 0.5
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

    ; 【硬核修复 2】Start/Stop 淡入淡出防护 | fix 2: start/stop fade
    kStartSmooth portk kstart, 0.015 ; 15ms 动态斜坡 | 15 ms ramp on start/stop

    ; --- 4. 核心声学衰减 & 多普勒时空扭曲 | acoustic decay & doppler warp ---
    kNormRadius limit (kRadius / 0.5), 0, 1
    kGainEnv = pow(kNormRadius, kEnvIndex)
    
    ; 合并增益矩阵：重力曲线 * 边界阻断 * 启停保护 | combined gain: gravity * edge gate * start/stop
    kTotalGain = kGainEnv * kEdgeFade * kStartSmooth
    kTotalGain portk kTotalGain, 0.005 ; 微弱 k 级平滑 | light k-rate smoothing
    
    aInL, aInR inch 1, 2
    aMono = (aInL + aInR) * 0.5 * kInputGain
    
    if kDopplerScale >= 0 then
        kSourcePos = kNormRadius * kDopplerScale
        kMicPos = 0
    else
        kSourcePos = (1 - kNormRadius) * abs(kDopplerScale)
        kMicPos = 0
    endif
    
    ; 【硬核修复 3】完美重置盾（15ms 去毛刺包络） | fix 3: reset shield (15 ms declick)
    if kTeleport == 1 then
        reinit REINIT_DOPPLER
    endif
REINIT_DOPPLER:
    aDeclick linseg 0, 0.015, 1
    ; 内部平滑滤波器固定在 20Hz | fixed 20 Hz internal smoothing
    aDopplered doppler aMono, kSourcePos, kMicPos, 340.29, 200
rireturn
    
    ; 【核心改变 3】二元硬切换，不混原声避免 Phasing | hard bypass switch (no phasing)
    aMixed = (aDopplered * kDopplerSwitch) + (aMono * (1 - kDopplerSwitch))
    
    aProcessed = aMixed * kTotalGain * aDeclick

    ; 总音量调节与硬幅值限幅 | master volume & hard limiter
    aMasterL limit (aProcessed * kMasterGain), -1, 1
    aMasterR limit (aProcessed * kMasterGain), -1, 1


;    ; 四声道声像渲染（已弃用） | quad render (deprecated)
;    aFL, aFR, aRL, aRR QuadRender aMasterL, aMasterR, aX, aY
;    outq aFL, aFR, aRL, aRR
 
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aMasterL, aMasterR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 4. 混响器 | reverb (reverbsc) ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05
    
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
    
    outs aOutL, aOutR
    ; --- 5. 前端 UI 通信与像素重映射 | UI communication & pixel remap ---
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
    ; --- 5. 视觉与电平反馈 | visual & level refresh ---
    kTrig metro 60
    
;    ; 视讯游标刷新（已弃用） | visual cursor refresh (deprecated)
;    kBallX = int(65 + (kX_raw * 180) + 0.5)
;    kBallY = int(80 + ((1 - kY_raw) * 180) + 0.5)
;    S_Bounds sprintfk "bounds(%d, %d, 10, 10)", kBallX, kBallY
;    cabbageSet kTrig, "visualBall", S_Bounds
    
    ; L/R 主输出电平捕捉 | L/R level capture
    kOutL max_k abs(aOutL), kTrig, 1
    kOutR max_k abs(aOutR), kTrig, 1

    cabbageSetValue "outL", portk(kOutL, .05), kTrig
    cabbageSetValue "outR", portk(kOutR, .05), kTrig

    kTeleport = 0
endin
</CsInstruments>

<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>