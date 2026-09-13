;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-Zephyr.vst3 

<Cabbage>
form caption("Depth-Zephyr") size(380, 490), guiMode("queue"), pluginId("DPzz") colour(15, 23, 42, 255)
image bounds(0, 0, 380, 390) channel("bg") colour(15, 23, 42, 255) file("zephyr_back.png")

; 1. 严格正方形自制雷达网格 | square radar grid
image bounds(100, 42, 180, 180) colour(28, 76, 115, 220) outlineThickness(7) channel("image7") corners(7) outlineColour(101, 217, 184, 105)
image bounds(190, 42, 1, 180) colour(201, 213, 195, 100) channel("image43")
image bounds(100, 132, 180, 1) colour(201, 213, 195, 100) channel("image44")

; 2. 动态游标小球 | visual ball
image bounds(182, 124, 16, 16) shape("circle")  channel("visualBall") colour(200, 70, 160, 255) outlineColour(0, 0, 0, 255) file("Zephyr_target.png")
groupbox bounds(192, 280, 190, 114) channel("groupbox10018") text("TURBULENCE") fontColour(200, 77, 162, 205) outlineColour(51, 144, 156, 255) colour(28, 76, 115, 255)

groupbox bounds(0, 280, 190, 114) channel("groupbox10017") text("TRAJECTORY") fontColour(200, 77, 162, 205) outlineColour(51, 144, 156, 255) colour(28, 76, 115, 255)

rslider bounds(0, 310, 70, 70), channel("fallTime"), range(0.1, 600, 2, 0.25, 0.01), text("Fall Time(s)"), fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)
rslider bounds(66, 310, 70, 70), channel("angle"), range(0, 360, 90, 1, 1), text("Angle:°"), fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)
rslider bounds(130, 310, 70, 70), channel("radius"), range(0, 0.5, 0.353, 1, 0.001), text("Radius"), fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)

groupbox bounds(0, 394, 380, 78) channel("groupbox10016") text("ROOM") fontColour(200, 77, 162, 205) outlineColour(51, 144, 156, 255) colour(28, 76, 115, 255)

rslider bounds(190, 310, 70, 70), channel("drift"), range(0, 0.5, 0.1, 1, 0.001), text("Drift"), fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)
rslider bounds(256, 310, 70, 70), channel("dfreq"), range(0.01, 10, 0.2, 1, 0.01), text("DriftFrq:Hz"), fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)
rslider bounds(320, 310, 70, 70), channel("jitter"), range(0, 0.2, 0.02, 1, 0.001), text("Jitter"), fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)

; 4. 混响发送量范围条 | wet send range (min/max)
label bounds(80, 422, 210, 15) text("Wet Send Range (Min / Max)")fontColour(101, 217, 184, 205) channel("labelWet") 
hrange bounds(94, 438, 180, 28) channel("minWet", "maxWet") range(0, 1, 0.1:0.6, 1, 0.001) fontColour(101, 217, 184, 205), trackerColour(200, 77, 162, 205), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)

; 5. 声场声学控制参数（Room Size 与 Damping） | room size & damping knobs
rslider bounds(10, 416, 69, 52) channel("roomSize") range(10, 100, 50, 1, 0.1) text("Room Size") fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)
rslider bounds(292, 418, 75, 49) channel("cutoff") range(1000, 16000, 6000, 0.5, 1) text("Damping (Hz)") fontColour(101, 217, 184, 205), trackerColour(201, 217, 184, 255), valueTextBox(1)textColour(101, 217, 184, 205) colour(28, 76, 115, 255)markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)


button bounds(0, 259, 190, 20) channel("Loop") value(1)  colour:0(144,164,162, 255) colour:1(201, 217, 184, 255) corners(7) fontColour:0(28, 76, 115, 255) fontColour:1(200, 77, 162, 255) text("LOOP ON", "LOOP OFF") 
button bounds(191, 259, 190, 20) channel("Start") value(1) latched(1) colour:0(144,164,162, 255) colour:1(201, 217, 184, 255) corners(7) fontColour:0(28, 76, 115, 255) fontColour:1(200, 77, 162, 255) text("Start", "Stop")

image bounds(0, 472, 380, 18) colour(28, 76, 115, 255) channel("image30") corners(7)
; 底部控制装饰栏 | bottom decorative bar
label bounds(0, 474, 377, 16), text("WILDTRACE SERIES"), fontColour(200, 77, 162, 255), align("right") channel("label31")

vmeter bounds(44, 42, 15, 180), channel("outL"), outlineColour(0, 0, 0, 150), overlayColour(15, 23, 42, 255), value(0) meterColour:0(80, 77, 162, 255) meterColour:1(140, 77, 162, 255) meterColour:2(200, 77, 162, 255)
vmeter bounds(316, 44, 15, 180), channel("outR"), outlineColour(0, 0, 0, 150), overlayColour(15, 23, 42, 255), value(0) meterColour:0(80, 77, 162, 255) meterColour:1(140, 77, 162, 255) meterColour:2(200, 77, 162, 255)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1

; [UDO] 核心渲染引擎 | core render engine

opcode DepthStereoRender, aaaa, aaaakkka
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize, aEnvSmooth xin
    
    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999
    
    aDepth = aY
    aRoomSize interp kRoomSize
    
    ; 1. 方位声像映射 | equal-power X pan
    aL_pan = cos(aX * 1.570796)
    aR_pan = sin(aX * 1.570796)
    aMono = (aInL + aInR) * 0.5
    
    aPanL = aMono * aL_pan
    aPanR = aMono * aR_pan
    
    ; 2. 动态多普勒距离延迟 | doppler distance delay
    aDelayTime = 0.01 + (aDepth * (aRoomSize * 0.002)) 
    
    aDlyL vdelay3 aPanL, aDelayTime * 1000, 500
    aDlyR vdelay3 aPanR, aDelayTime * 1000, 500
    
    ; 3. 空气声学吸收 | air absorption
    aDepthInv = 1 - aDepth
    aAirCutoff = 800 + ((aDepthInv * aDepthInv * aDepthInv) * 19200)
    
    aFiltL tone aDlyL, aAirCutoff
    aFiltR tone aDlyR, aAirCutoff
    
    ; 4. 空间平方反比衰减 | distance attenuation
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDepth * aDecayFactor) 
    
    ; 应用绝对毫秒防护包络 | apply ms safety envelope
    aDryL = aFiltL * aDistAmp * aEnvSmooth
    aDryR = aFiltR * aDistAmp * aEnvSmooth
    
    ; 5. 声能空间反射混响发送矩阵 | reverb send matrix
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDepth * (aMaxWet - aMinWet))
    
    aWetL = aFiltL * aWetSend * aEnvSmooth
    aWetR = aFiltR * aWetSend * aEnvSmooth
    
    xout aDryL, aDryR, aWetL, aWetR
endop

instr 1
    ; --- 1. 获取 UI 参数 | read UI parameters ---
    kFallTime cabbageGetValue "fallTime"
    kRawAngle cabbageGetValue "angle"
    kRad      cabbageGetValue "radius"
    kDrift    cabbageGetValue "drift"
    kDfreq    cabbageGetValue "dfreq"
    kJitAmt   cabbageGetValue "jitter"
    
    kLoop     cabbageGetValue "Loop"
    kStart    cabbageGetValue "Start"

    kMinWet cabbageGetValue "minWet"
    kMaxWet cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    kAngle wrap kRawAngle, 0, 360

    ; --- 2. 核心状态初始化与相位累加器 | state init & phase accumulator ---
    kPhase init 0
    kSafeFallTime = max(kFallTime, 0.05) ; 限制最小时间防除零 | minimum time to avoid div by zero
    kFreq = 1 / kSafeFallTime

    kStartTrig trigger kStart, 0.5, 0
    if kStartTrig == 1 then
        kPhase = 0
    endif

    if kStart == 1 then
        kPhase = kPhase + (kFreq / kr)
        if kPhase >= 1 then
            if kLoop == 1 then
                kPhase = kPhase - 1 
            else
                kPhase = 1          
                kStart = 0          
                cabbageSetValue "Start", 0, 1 
            endif
        endif
    else
        if kLoop == 0 then
            kPhase = 0 
        endif
    endif

    ; --- 3. 风场流体运动计算 | wind flow motion ---
    kMaxRad = kRad * 1.4142
    
    ; =========================================================
    ; 【核心修复】基于绝对毫秒的硬静音与平滑过零 | fix: hard mute & smooth zero-crossing
    ; =========================================================
    kSilenceTime = 0.010 ; 10ms 绝对硬静音窗口 | 10 ms hard mute window
    kFadeTime    = 0.005 ; 5ms 软平滑坡度（无 Click） | 5 ms fade ramp (no clicks)

    ; 绝对时间映射为相位比例 | map absolute time to phase ratios
    kSilencePhase = kSilenceTime / kSafeFallTime
    kFadePhase    = kFadeTime / kSafeFallTime
    kTotalMargin  = kSilencePhase + kFadePhase

    kSineEnv = sin(kPhase * 3.14159265)

    if (kStart == 0) then
        kAmpGate = 0
    elseif (kPhase < kSilencePhase || kPhase > (1 - kSilencePhase)) then
        ; 重置点前后 10ms 安全区内：100% 硬静音 | hard mute inside the 10 ms window
        kAmpGate = 0
    elseif (kPhase < kTotalMargin) then
        ; 起始 5ms 坡度淡入 | 5 ms fade-in
        kRamp = (kPhase - kSilencePhase) / kFadePhase
        kAmpGate = kSineEnv * kRamp
    elseif (kPhase > (1 - kTotalMargin)) then
        ; 结尾 5ms 坡度淡出 | 5 ms fade-out
        kRamp = ((1 - kSilencePhase) - kPhase) / kFadePhase
        kAmpGate = kSineEnv * kRamp
    else
        kAmpGate = kSineEnv
    endif

    kRadAng = kAngle * 0.0174532925
    kMovement = (kPhase - 0.5) * kMaxRad * 2

    kMoveGate portk kStart, 0.015

    kLFO lfo kDrift, kDfreq, 0        
    kJit jitter kJitAmt, 8, 28        
    
    kLateral = (kLFO + kJit) * kMoveGate

    kX_raw = 0.5 + (cos(kRadAng) * kMovement) - (sin(kRadAng) * kLateral)
    kY_raw = 0.5 + (sin(kRadAng) * kMovement) + (cos(kRadAng) * kLateral)

    ; 坐标跳变无阻尼，在静音 10ms 内完成瞬间重置 | reset instantly inside the silent 10 ms window
    aX interp limit(kX_raw, 0, 1)
    aY interp limit(kY_raw, 0, 1)

    kX downsamp aX
    kY downsamp aY

    ; --- 4. 生成干净的音频级包络 | clean audio-rate envelope ---
    aEnvSmooth interp kAmpGate

    ; --- 5. 硬件捕获与公共引擎渲染 | input capture & engine render ---
    aInL, aInR inch 1, 2
    
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize, aEnvSmooth
    
    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kCutoff, 0.04
    
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; 最终混合输出 | final mix output
    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
    
    outs aOutL, aOutR

    ; --- 6. UI 视讯刷新 | UI refresh ---
    kBallX = 100 + (kX * 180) - 8
    kBallY = 42 + ((1 - kY) * 180) - 8
    
    kUIMetro metro 30
    S_Bounds sprintfk "bounds(%d, %d, 16, 16)", kBallX, kBallY
    cabbageSet kUIMetro, "visualBall", S_Bounds
    
    ; --- 7. 输出电平监听 | output meters ---
    kOutL max_k abs(aOutL), kUIMetro, 1
    kOutR max_k abs(aOutR), kUIMetro, 1

    cabbageSetValue "outL", portk(kOutL, .05), kUIMetro
    cabbageSetValue "outR", portk(kOutR, .05), kUIMetro
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>