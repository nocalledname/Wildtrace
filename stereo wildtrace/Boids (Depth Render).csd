;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-Boids.vst3

<Cabbage>
form caption("Depth-Boids") size(620, 400), guiMode("queue"), pluginId("DPBS") pluginType("effect")
image bounds(0, 0, 620, 400) channel("bg") file("Boids_back.png") alpha(0.7)

; 1. 严格正方形自制雷达网格 | square radar grid
image bounds(222, 146, 150, 150) colour(170, 184, 214, 25)  outlineThickness(1) channel("grid") corners(5)
image bounds(297, 146, 1, 150) colour(137, 137, 137, 200) channel("grid_v")
image bounds(222, 221, 150, 1) colour(137, 137, 137, 200) channel("grid_h")

; 2. 动态游标小球（头鸟：实心红点） | leader bird (solid red dot)
image bounds(289, 213, 16, 16) shape("circle") channel("visualBall") colour(241, 105, 105, 255)

; 2.5 动态从鸟集群（7只跟随者：空心褪色渐变） | 7 follower birds (hollow fading circles)
image bounds(0, 0, 16, 16) shape("circle") channel("bird1") colour(0, 0, 0, 0) outlineColour(245, 120, 110, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird2") colour(0, 0, 0, 0) outlineColour(248, 135, 115, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird3") colour(0, 0, 0, 0) outlineColour(250, 150, 120, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird4") colour(0, 0, 0, 0) outlineColour(252, 165, 125, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird5") colour(0, 0, 0, 0) outlineColour(254, 180, 130, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird6") colour(0, 0, 0, 0) outlineColour(255, 195, 135, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird7") colour(0, 0, 0, 0) outlineColour(255, 210, 140, 200) outlineThickness(1)

; 3. 高精数显输入框 | numeric X/Y readouts
nslider bounds(224, 312, 70, 24) channel("box_x") automatable(0) range(0, 1, 0.5, 1, 0.001) text("X") colour(0, 0, 0, 0) fontColour(255, 255, 255, 255) textColour(0, 0, 0, 255)
nslider bounds(294, 312, 70, 24) channel("box_y") automatable(0) range(0, 1, 0.5, 1, 0.001) text("Y") colour(255, 255, 255, 0) fontColour(0, 0, 0, 255) textColour(255, 255, 255, 255)

; 4. 隐藏的宿主自动化映射底座 | hidden host-automation sliders
hslider bounds(-100, -100, 50, 20) channel("x") range(0, 1, 0.5)
hslider bounds(-100, -100, 50, 20) channel("y") range(0, 1, 0.5)

; 物理控制 | flock physics controls
rslider bounds(90, 264, 60, 60) channel("sep") range(0, 1, 1, 1, 0.001) text("Separation") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) valueTextBox(1) fontColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(90, 324, 60, 60) channel("ali") range(0, 1, 0, 1, 0.001) text("Alignment") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1)
rslider bounds(30, 264, 60, 60) channel("coh") range(0, 1, 0, 1, 0.001) text("Cohesion") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(30, 324, 60, 60) channel("speed") range(0.001, 0.1, 0.01, 1, 0.001) text("Speed") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)

; 核心 DSP 控制 | core DSP controls
rslider bounds(26, 34, 60, 60) channel("delay_base") range(10, 2000, 500, 1, 1) text("Delay Base") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) markerColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255) fontColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1)
rslider bounds(90, 94, 60, 60) channel("feedback") range(0, 0.95, 0.4, 1, 0.001) text("Feedback") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255)  fontColour(0, 0, 0, 255) colour(255, 255, 255, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(90, 34, 60, 60) channel("mod_rate") range(0.01, 5, 0.5, 0.5, 0.01) text("LFO Rate") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255)  fontColour(0, 0, 0, 255) colour(255, 255, 255, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(26, 94, 60, 60) channel("Flock_Decay") range(0, 1, 0.3727, 1, 0.0001) outlineColour(255, 255, 255, 255)  text("Flock Decay") trackerColour(255, 255, 255, 255) fontColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) markerColour(255, 255, 255, 255)

rslider bounds(492, 266, 60, 60) channel("dry_wet") range(0, 1, 0.5, 1, 0.001) text("Flock Mix") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255) colour(255, 255, 255, 255) valueTextBox(1) fontColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(492, 324, 60, 60) channel("vol") range(0, 16, 4, 1, 0.001) text("Master Gain") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255)

; 7只跟随鸟的独立变调深度 | per-bird pitch warp
label   bounds(442, 14, 158, 20) text("Birds Pitch Warp") channel("label17") fontColour(255, 255, 255, 255)
rslider bounds(456, 34, 60, 60) channel("m1") range(0, 50, 1, 0.3, 0.001) text("1") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255)  fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(516, 34, 60, 60) channel("m2") range(0, 50, 2, 0.3, 0.001) text("2") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(424, 94, 60, 60) channel("m3") range(0, 50, 3, 0.3, 0.001) text("3") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(480, 88, 73, 75) channel("m4") range(0, 50, 4, 0.3, 0.001) text("4") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) fontColour(255, 255, 255, 255)  markerColour(255, 255, 255, 255) valueTextBox(1) outlineColour(255, 255, 255, 255)
rslider bounds(544, 94, 60, 60) channel("m5") range(0, 50, 5, 0.3, 0.001) text("5") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(456, 154, 60, 60) channel("m6") range(0, 50, 6, 0.3, 0.001) text("6") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(516, 154, 60, 60) channel("m7") range(0, 50, 7, 0.3, 0.001) text("7") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
label bounds(26, 14, 124, 20) channel("Delay_Set") text("Delay Set") fontColour(255, 255, 255, 255)

; 电平表 | meters
vmeter bounds(184, 144, 15, 180), channel("outL"), outlineColour(0, 0, 0, 150), overlayColour(15, 23, 42, 255), value(0) meterColour:0(255, 255, 255, 255) meterColour:1(241, 105, 105, 255) meterColour:2(241, 105, 105, 205)
vmeter bounds(394, 144, 15, 180), channel("outR"), outlineColour(0, 0, 0, 150), overlayColour(15, 23, 42, 255), value(0) meterColour:0(255, 255, 255, 255) meterColour:1(241, 105, 105, 255) meterColour:2(241, 105, 105, 205)


; 4. 混响发送量范围条 | wet send range (min/max)
label bounds(198, 18, 210, 15) text("Wet Send Range (Min / Max)")fontColour(0, 0, 0, 205) channel("labelWet") 
hrange bounds(214, 36, 180, 28) channel("minWet", "maxWet") range(0, 1, 0.1:0.6, 1, 0.001) fontColour(0, 0, 0, 205), trackerColour(0, 0, 0, 205), valueTextBox(1)textColour(101, 217, 184, 205) markerColour(200, 77, 162, 255) outlineColour(58, 58, 58, 0)  fontColour:0(0, 0, 0, 205) max(1) min(0)

; 5. 声场声学控制参数（Room Size 与 Damping） | room size & damping knobs
rslider bounds(224, 338, 69, 52) channel("roomSize") range(10, 100, 50, 1, 0.1) text("Room Size") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255) colour(255, 255, 255, 255) valueTextBox(1) fontColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)

; 高频阻尼旋钮 | damping cutoff
rslider bounds(294, 338, 75, 49) channel("cutoff") range(1000, 16000, 6000, 0.5, 1) text("Damping (Hz)")  trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255) colour(255, 136, 136, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255)


label bounds(40, 240, 103, 24) channel("label10021") fontColour(255, 255, 255, 255) text("Birds Set")
label bounds(448, 242, 144, 24) channel("label10022") text("Master set") fontColour(255, 255, 255, 255)
label bounds(184, 88, 228, 24) text("Position of  Boids") channel("label35") fontColour(0, 0, 0, 255)
label bounds(300, 384, 320, 16), text("WILDTRACE SERIES"), fontColour(0, 0, 0, 255), align("right") channel("label54")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>

ksmps = 32
nchnls = 2
0dbfs = 1

; 全局定义 | global definitions
giNumBoids = 8
gkX[] init 8
gkY[] init 8
gkVx[] init 8
gkVy[] init 8

opcode  DepStereoRender, aaaa, aaaakkk
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
    ; --- 1. 读取外部组件状态 | read widget & host state ---
    kHostX cabbageGetValue "x"
    kHostY cabbageGetValue "y"
    kBoxX  cabbageGetValue "box_x"
    kBoxY  cabbageGetValue "box_y"

    kMouseDown cabbageGetValue "MOUSE_DOWN_LEFT"
    kMouseX    cabbageGetValue "MOUSE_X"
    kMouseY    cabbageGetValue "MOUSE_Y"
    kClickTrig changed kMouseDown

    ; --- 2. 获取 UI 参数 | read UI parameters ---
    kSep chnget "sep"
    kAli chnget "ali"
    kCoh chnget "coh"
    kMaxSpeed chnget "speed"
    kDelayBase chnget "delay_base"
    kFbk chnget "feedback"
    kLFORate chnget "mod_rate"
    kVol chnget "vol"
    kMix chnget "dry_wet"
    kFD chnget "Flock_Decay"
    
    kMinWet cabbageGetValue "minWet"
    kMaxWet cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"
    
    kM1 chnget "m1"
    kM2 chnget "m2"
    kM3 chnget "m3"
    kM4 chnget "m4"
    kM5 chnget "m5"
    kM6 chnget "m6"
    kM7 chnget "m7"

    ; 边缘触发器 | edge triggers
    kHostX_Chg changed kHostX
    kHostY_Chg changed kHostY
    kBoxX_Chg  changed kBoxX
    kBoxY_Chg  changed kBoxY

    kTimer init 0
    kTimer = kTimer + (ksmps / sr)

    kX init 0.5
    kY init 0.5

    ; --- 3. 初始化 Boids | init boids ---
    if timeinstk() == 1 then
        kInitI = 1
        while kInitI < giNumBoids do
            gkX[kInitI] = rnd(1)
            gkY[kInitI] = rnd(1)
            gkVx[kInitI] = rnd(0.02) - 0.01
            gkVy[kInitI] = rnd(0.02) - 0.01
            kInitI = kInitI + 1
        od
    endif

    ; --- 4. 双击与拖拽状态机 | double-click & drag state machine ---
    kLastClickTime init -99
    kDoubleClickEvent init 0
    kActive init 0
    kIgnoreDrag init 0

    if (kMouseDown == 0) then
        kActive = 0
        kIgnoreDrag = 0 
    endif

    if (kClickTrig == 1 && kMouseDown == 1) then
        if (kMouseX >= 222 && kMouseX <= 372 && kMouseY >= 146 && kMouseY <= 296) then
            kActive = 1
            
            kTimeDiff = kTimer - kLastClickTime
            if (kTimeDiff > 0.02 && kTimeDiff < 0.4) then
                kDoubleClickEvent = 1
                kIgnoreDrag = 1 
                kLastClickTime = -99
            else
                kDoubleClickEvent = 0
                kLastClickTime = kTimer
            endif
        endif
    else
        kDoubleClickEvent = 0
    endif

    ; --- 5. 三路数据路由 | three-way data routing ---
    if (kDoubleClickEvent == 1) then
        kX = 0.5
        kY = 0.5
        cabbageSetValue "x", 0.5, kDoubleClickEvent
        cabbageSetValue "y", 0.5, kDoubleClickEvent
        cabbageSetValue "box_x", 0.5, kDoubleClickEvent
        cabbageSetValue "box_y", 0.5, kDoubleClickEvent
        
    elseif (kActive == 1 && kIgnoreDrag == 0) then
        kTargetX = (kMouseX - 222) / 150
        kTargetX limit kTargetX, 0, 1
        
        kTargetY = 1 - ((kMouseY - 146) / 150)
        kTargetY limit kTargetY, 0, 1
        
        if (kTargetX != kX || kTargetY != kY) then
            kX = kTargetX
            kY = kTargetY
            cabbageSetValue "x", kX
            cabbageSetValue "y", kY
            cabbageSetValue "box_x", kX
            cabbageSetValue "box_y", kY
        endif
        
    else
        if (kBoxX_Chg == 1 && abs(kBoxX - kX) > 0.001) then
            kX = kBoxX                
            cabbageSetValue "x", kX    
        elseif (kHostX_Chg == 1 && abs(kHostX - kX) > 0.001) then
            kX = kHostX                
            cabbageSetValue "box_x", kX
        endif

        if (kBoxY_Chg == 1 && abs(kBoxY - kY) > 0.001) then
            kY = kBoxY 
            cabbageSetValue "y", kY
        elseif (kHostY_Chg == 1 && abs(kHostY - kY) > 0.001) then
            kY = kHostY
            cabbageSetValue "box_y", kY
        endif
    endif

    ; --- 6. Boids 物理循环 | boids physics loop ---
    if metro(30) == 1 then
        gkX[0] = kX
        gkY[0] = kY
        
        kIdx = 1
        while kIdx < giNumBoids do
            kAvgX = 0
            kAvgY = 0
            kAvgVx = 0
            kAvgVy = 0
            kSepX = 0
            kSepY = 0
            kCount = 0
            
            kJdx = 0
            while kJdx < giNumBoids do
                if kIdx != kJdx then
                    kDx = gkX[kJdx] - gkX[kIdx]
                    kDy = gkY[kJdx] - gkY[kIdx]
                    kDist = sqrt(kDx*kDx + kDy*kDy) + 0.001
                    if kDist < 0.25 then
                        kAvgX = kAvgX + gkX[kJdx]
                        kAvgY = kAvgY + gkY[kJdx]
                        kAvgVx = kAvgVx + gkVx[kJdx]
                        kAvgVy = kAvgVy + gkVy[kJdx]
                        kCount = kCount + 1
                        if kDist < 0.06 then
                            kSepX = kSepX - (kDx / kDist)
                            kSepY = kSepY - (kDy / kDist)
                        endif
                    endif
                endif
                kJdx = kJdx + 1
            od
            
            if kCount > 0 then
                gkVx[kIdx] = gkVx[kIdx] + ((kAvgX/kCount - gkX[kIdx]) * kCoh * 0.04)
                gkVy[kIdx] = gkVy[kIdx] + ((kAvgY/kCount - gkY[kIdx]) * kCoh * 0.04)
                gkVx[kIdx] = gkVx[kIdx] + ((kAvgVx/kCount - gkVx[kIdx]) * kAli * 0.04)
                gkVy[kIdx] = gkVy[kIdx] + ((kAvgVy/kCount - gkVy[kIdx]) * kAli * 0.04)
            endif
            
            gkVx[kIdx] = gkVx[kIdx] + (kSepX * kSep * 0.025) + ((gkX[0] - gkX[kIdx]) * 0.005)
            gkVy[kIdx] = gkVy[kIdx] + (kSepY * kSep * 0.025) + ((gkY[0] - gkY[kIdx]) * 0.005)
            
            kSpd = sqrt(gkVx[kIdx]*gkVx[kIdx] + gkVy[kIdx]*gkVy[kIdx]) + 0.0001
            if kSpd > kMaxSpeed then
                gkVx[kIdx] = (gkVx[kIdx] / kSpd) * kMaxSpeed
                gkVy[kIdx] = (gkVy[kIdx] / kSpd) * kMaxSpeed
            endif
            gkX[kIdx] = limit(gkX[kIdx] + gkVx[kIdx], 0, 1)
            gkY[kIdx] = limit(gkY[kIdx] + gkVy[kIdx], 0, 1)
            kIdx = kIdx + 1
        od
    endif

    ; --- 7. UI 刷新（头鸟与7只从鸟） | UI refresh (leader + 7 followers) ---
    kUIMetro metro 30

    ; 头鸟渲染 | leader
    kBallX = 222 + (kX * 150) - 8
    kBallY = 146 + ((1 - kY) * 150) - 8
    S_Bounds sprintfk "bounds(%d, %d, 16, 16)", kBallX, kBallY
    cabbageSet kUIMetro, "visualBall", S_Bounds

    ; 从鸟 1-7 批量渲染 | followers 1-7
    kBirdX1 = 222 + (gkX[1] * 150) - 8
    kBirdY1 = 146 + ((1 - gkY[1]) * 150) - 8
    S_B1 sprintfk "bounds(%d, %d, 16, 16)", kBirdX1, kBirdY1
    cabbageSet kUIMetro, "bird1", S_B1

    kBirdX2 = 222 + (gkX[2] * 150) - 8
    kBirdY2 = 146 + ((1 - gkY[2]) * 150) - 8
    S_B2 sprintfk "bounds(%d, %d, 16, 16)", kBirdX2, kBirdY2
    cabbageSet kUIMetro, "bird2", S_B2

    kBirdX3 = 222 + (gkX[3] * 150) - 8
    kBirdY3 = 146 + ((1 - gkY[3]) * 150) - 8
    S_B3 sprintfk "bounds(%d, %d, 16, 16)", kBirdX3, kBirdY3
    cabbageSet kUIMetro, "bird3", S_B3

    kBirdX4 = 222 + (gkX[4] * 150) - 8
    kBirdY4 = 146 + ((1 - gkY[4]) * 150) - 8
    S_B4 sprintfk "bounds(%d, %d, 16, 16)", kBirdX4, kBirdY4
    cabbageSet kUIMetro, "bird4", S_B4

    kBirdX5 = 222 + (gkX[5] * 150) - 8
    kBirdY5 = 146 + ((1 - gkY[5]) * 150) - 8
    S_B5 sprintfk "bounds(%d, %d, 16, 16)", kBirdX5, kBirdY5
    cabbageSet kUIMetro, "bird5", S_B5

    kBirdX6 = 222 + (gkX[6] * 150) - 8
    kBirdY6 = 146 + ((1 - gkY[6]) * 150) - 8
    S_B6 sprintfk "bounds(%d, %d, 16, 16)", kBirdX6, kBirdY6
    cabbageSet kUIMetro, "bird6", S_B6

    kBirdX7 = 222 + (gkX[7] * 150) - 8
    kBirdY7 = 146 + ((1 - gkY[7]) * 150) - 8
    S_B7 sprintfk "bounds(%d, %d, 16, 16)", kBirdX7, kBirdY7
    cabbageSet kUIMetro, "bird7", S_B7

    ; --- 8. 音频处理（10秒延迟线 + LFO调制） | audio processing (10 s delay + LFO) ---
    aInL, aInR inch 1, 2
    aSig = (aInL + aInR) * 0.5
    aFbkSum init 0
    
    aBuf delayr 10.0
    
    ; 7路带相位偏移的 LFO | 7 phase-offset LFOs
    kL1 oscil kM1, kLFORate, -1, 0.0
    kL2 oscil kM2, kLFORate * 1.1, -1, 0.1
    kL3 oscil kM3, kLFORate * 0.9, -1, 0.2
    kL4 oscil kM4, kLFORate * 1.2, -1, 0.3
    kL5 oscil kM5, kLFORate * 0.8, -1, 0.4
    kL6 oscil kM6, kLFORate * 1.3, -1, 0.5
    kL7 oscil kM7, kLFORate * 0.7, -1, 0.6

    ; 将基准延迟转为 a率 | base delay to a-rate
    aDelayBase interp kDelayBase
    
    ; 7路延迟读出（LFO转a率，消除拉链声） | 7 delay taps (LFO to a-rate)
    aL1 interp kL1
    aL2 interp kL2
    aL3 interp kL3
    aL4 interp kL4
    aL5 interp kL5
    aL6 interp kL6
    aL7 interp kL7
    
    aT1 deltapi limit((aDelayBase*1.0 + aL1)/1000, 0.01, 9.9)
    aT2 deltapi limit((aDelayBase*1.3 + aL2)/1000, 0.01, 9.9)
    aT3 deltapi limit((aDelayBase*1.6 + aL3)/1000, 0.01, 9.9)
    aT4 deltapi limit((aDelayBase*1.9 + aL4)/1000, 0.01, 9.9)
    aT5 deltapi limit((aDelayBase*2.2 + aL5)/1000, 0.01, 9.9)
    aT6 deltapi limit((aDelayBase*2.5 + aL6)/1000, 0.01, 9.9)
    aT7 deltapi limit((aDelayBase*2.8 + aL7)/1000, 0.01, 9.9)
  
    aFD interp kFD
    aT1 = aT1 * aFD 
    aT2 = aT2 * aFD^2
    aT3 = aT3 * aFD^3
    aT4 = aT4 * aFD^4
    aT5 = aT5 * aFD^5
    aT6 = aT6 * aFD^6 
    aT7 = aT7 * aFD^7   
    
    ; 反馈混合并回灌 | feedback mix back into delay line
    aFbkSum = (aT1+aT2+aT3+aT4+aT5+aT6+aT7) * kFbk / 7
    delayw aSig + aFbkSum

    ; --- 9. 空间分配与混合输出 | spatial placement & mix output ---
    kGlide = 0.05  ; 50ms 平滑，填补 30Hz 阶梯 | 50 ms smoothing for 30 Hz steps

    ; 头鸟 (0) | leader (0)
    kX0_sm portk gkX[0], kGlide
    kY0_sm portk gkY[0], kGlide
    aX0 interp kX0_sm
    aY0 interp kY0_sm
    aIn0 = aSig * (1 - kMix)
    aDryL0, aDryR0, aWetL0, aWetR0 DepStereoRender aIn0, aIn0, aX0, aY0, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 1 | follower 1
    kX1_sm portk gkX[1], kGlide
    kY1_sm portk gkY[1], kGlide
    aX1 interp kX1_sm
    aY1 interp kY1_sm
    aIn1 = aT1 * kMix
    aDryL1, aDryR1, aWetL1, aWetR1 DepStereoRender aIn1, aIn1, aX1, aY1, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 2 | follower 2
    kX2_sm portk gkX[2], kGlide
    kY2_sm portk gkY[2], kGlide
    aX2 interp kX2_sm
    aY2 interp kY2_sm
    aIn2 = aT2 * kMix
    aDryL2, aDryR2, aWetL2, aWetR2 DepStereoRender aIn2, aIn2, aX2, aY2, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 3 | follower 3
    kX3_sm portk gkX[3], kGlide
    kY3_sm portk gkY[3], kGlide
    aX3 interp kX3_sm
    aY3 interp kY3_sm
    aIn3 = aT3 * kMix
    aDryL3, aDryR3, aWetL3, aWetR3 DepStereoRender aIn3, aIn3, aX3, aY3, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 4 | follower 4
    kX4_sm portk gkX[4], kGlide
    kY4_sm portk gkY[4], kGlide
    aX4 interp kX4_sm
    aY4 interp kY4_sm
    aIn4 = aT4 * kMix
    aDryL4, aDryR4, aWetL4, aWetR4 DepStereoRender aIn4, aIn4, aX4, aY4, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 5 | follower 5
    kX5_sm portk gkX[5], kGlide
    kY5_sm portk gkY[5], kGlide
    aX5 interp kX5_sm
    aY5 interp kY5_sm
    aIn5 = aT5 * kMix
    aDryL5, aDryR5, aWetL5, aWetR5 DepStereoRender aIn5, aIn5, aX5, aY5, kMinWet, kMaxWet, kRoomSize
    
    ; 从鸟 6 | follower 6
    kX6_sm portk gkX[6], kGlide
    kY6_sm portk gkY[6], kGlide
    aX6 interp kX6_sm
    aY6 interp kY6_sm
    aIn6 = aT6 * kMix
    aDryL6, aDryR6, aWetL6, aWetR6 DepStereoRender aIn6, aIn6, aX6, aY6, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 7 | follower 7
    kX7_sm portk gkX[7], kGlide
    kY7_sm portk gkY[7], kGlide
    aX7 interp kX7_sm
    aY7 interp kY7_sm
    aIn7 = aT7 * kMix
    aDryL7, aDryR7, aWetL7, aWetR7 DepStereoRender aIn7, aIn7, aX7, aY7, kMinWet, kMaxWet, kRoomSize

    aDryL = (aDryL0+aDryL1+aDryL2+aDryL3+aDryL4+aDryL5+aDryL6+aDryL7)
    aDryR = (aDryR0+aDryR1+aDryR2+aDryR3+aDryR4+aDryR5+aDryR6+aDryR7)

    aWetL = (aWetL0+aWetL1+aWetL2+aWetL3+aWetL4+aWetL5+aWetL6+aWetL7)
    aWetR = (aWetR0+aWetR1+aWetR2+aWetR3+aWetR4+aWetR5+aWetR6+aWetR7)   

    ; --- 10. 混响器 | reverb (reverbsc) ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05
    
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
  
    aVol interp kVol  
    aOutL = aOutL*aVol
    aOutR = aOutR*aVol

    outs aOutL,aOutR
    
    kTrig metro 60

    ; 双声道电平捕捉 | stereo level capture
    kOutL max_k abs(aOutL), kTrig, 1
    kOutR max_k abs(aOutR), kTrig, 1

    cabbageSetValue "outL", portk(kOutL, .05), kTrig
    cabbageSetValue "outR", portk(kOutR, .05), kTrig
endin

</CsInstruments>
<CsScore>
f0 z 
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>