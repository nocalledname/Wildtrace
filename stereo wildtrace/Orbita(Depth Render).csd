;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-Orbita.vst3

<Cabbage>
form caption("Depth-Orbita") size(320, 433), guiMode("queue"), pluginId("DPOB") colour(15, 23, 42, 255)
image bounds(0, 0, 320, 433) channel("image10011") file("background-orbita.PNG")

; 1. 双声道电平表（紧凑布局） | stereo level meters
vmeter bounds(20, 80, 15, 150), channel("outL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), value(0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)
vmeter bounds(285, 80, 15, 150), channel("outR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), value(0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)

; 2. 动力学旋钮 | motion knobs
rslider bounds(30, 14, 61, 50), channel("speed"), range(0.1, 20, 0.25, 0.25, 0.001), text("Speed"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255), valueTextBox(1)
rslider bounds(24, 250, 50, 50), channel("radius"), range(0, 0.5, 0.5, 1, 0.01), text("Radius"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255), valueTextBox(1)
rslider bounds(232, 252, 50, 50), channel("Shape"), range(0, 1, 0.5, 1, 0.01), text("Shape"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255), valueTextBox(1)
button bounds(242, 20, 50, 30), channel("dir"), text("CCW", "CW"), colour:0(12, 18, 51, 255), colour:1(224, 69, 69, 255), corners(3)

; 3. 声学旋钮（底部） | room & damping knobs
hrange bounds(60, 380, 200, 20), channel("minWet", "maxWet"), range(0, 1, 0.1:0.3, 0.65, 0.001), trackerColour(255, 205, 68, 255)
rslider bounds(0, 356, 60, 60), channel("roomSize"), range(10, 100, 50, 1, 0.1), text("Room"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255)
rslider bounds(260, 356, 60, 60), channel("cutoff"), range(1000, 16000, 6000, 0.5, 1), text("Damp"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255)
label bounds(60, 362, 201, 15) text("Wet Send Range (Min / Max)") fontColour(255, 255, 255, 150) channel("label18")

; 4. 游标 | visual ball
image bounds(152, 160, 10, 10) shape("circle") channel("visualBall") colour(255, 220, 124, 255)
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2      ; 双声道输出 | stereo output
0dbfs = 1

; Orbita 核心操作码：DepthStereoRender | Orbita core opcode
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
    ; --- 1. 获取轨道与状态参数 | read state parameters ---
    kDir    cabbageGetValue "dir"       
    kSpeed  cabbageGetValue "speed"     
    kRad    cabbageGetValue "radius"    
    kInvert cabbageGetValue "Shape"     

    ; 获取声学引擎参数 | acoustic engine parameters
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    ; --- 2. 动力学计算（生成二维坐标） | orbital motion (2D position) ---
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

    ; --- 3. 深度引擎处理 | depth engine ---
    aInL, aInR inch 1, 2
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 4. 混响器 | reverb (reverbsc) ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05
    
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
    
    outs aOutL, aOutR

    ; --- 5. 视觉与电平反馈 | visual & level refresh ---
    kTrig metro 60
    
    ; 游标位置刷新 | ball position
    kBallX = int(65 + (kX_raw * 180) + 0.5)
    kBallY = int(80 + ((1 - kY_raw) * 180) + 0.5)
    S_Bounds sprintfk "bounds(%d, %d, 10, 10)", kBallX, kBallY
    cabbageSet kTrig, "visualBall", S_Bounds
    
    ; L/R 主输出电平捕捉 | L/R level capture
    kOutL max_k abs(aOutL), kTrig, 1
    kOutR max_k abs(aOutR), kTrig, 1

    cabbageSetValue "outL", portk(kOutL, .05), kTrig
    cabbageSetValue "outR", portk(kOutR, .05), kTrig
    
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>