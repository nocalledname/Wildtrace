<Cabbage>
form caption("Beta-Boids") size(620, 400), guiMode("queue"), pluginId("TTBS") pluginType("effect")
image bounds(0, 0, 620, 400) channel("bg") file("Boids_back.png") alpha(0.7)

; --- 1. 严格正方形自制雷达网格 / Strict Square Custom Radar Grid ---
image bounds(222, 146, 150, 150) colour(170, 184, 214, 25)  outlineThickness(1) channel("grid") corners(5)
image bounds(297, 146, 1, 150) colour(137, 137, 137, 200) channel("grid_v")
image bounds(222, 221, 150, 1) colour(137, 137, 137, 200) channel("grid_h")

; --- 2. 动态自制游标小球 (头鸟：实心红点) / Dynamic Custom Cursor Ball (Leader Bird: Solid Red Dot) ---
image bounds(289, 213, 16, 16) shape("circle") channel("visualBall") colour(241, 105, 105, 255)

; --- 2.5 动态从鸟集群 (7只跟随者：空心褪色渐变) / Dynamic Follower Flock (7 Followers: Hollow Fading Gradients) ---
image bounds(0, 0, 16, 16) shape("circle") channel("bird1") colour(0, 0, 0, 0) outlineColour(245, 120, 110, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird2") colour(0, 0, 0, 0) outlineColour(248, 135, 115, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird3") colour(0, 0, 0, 0) outlineColour(250, 150, 120, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird4") colour(0, 0, 0, 0) outlineColour(252, 165, 125, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird5") colour(0, 0, 0, 0) outlineColour(254, 180, 130, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird6") colour(0, 0, 0, 0) outlineColour(255, 195, 135, 200) outlineThickness(1)
image bounds(0, 0, 16, 16) shape("circle") channel("bird7") colour(0, 0, 0, 0) outlineColour(255, 210, 140, 200) outlineThickness(1)

; --- 3. 工业级高精数显输入框 / Industrial-Grade High-Precision Numeric Display Inputs ---
nslider bounds(224, 312, 70, 24) channel("box_x") automatable(0) range(0, 1, 0.5, 1, 0.001) text("X") colour(0, 0, 0, 0) fontColour(255, 255, 255, 255) textColour(0, 0, 0, 255)
nslider bounds(294, 312, 70, 24) channel("box_y") automatable(0) range(0, 1, 0.5, 1, 0.001) text("Y") colour(255, 255, 255, 0) fontColour(0, 0, 0, 255) textColour(255, 255, 255, 255)

; --- 4. 【绝对隐藏】宿主自动化映射底座 / [Absolutely Hidden] Host Automation Mapping Base ---
hslider bounds(-100, -100, 50, 20) channel("x") range(0, 1, 0.5)
hslider bounds(-100, -100, 50, 20) channel("y") range(0, 1, 0.5)

; --- 物理控制 / Physics Controls ---
rslider bounds(90, 264, 60, 60) channel("sep") range(0, 1, 1, 1, 0.001) text("Separation") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) valueTextBox(1) fontColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(90, 324, 60, 60) channel("ali") range(0, 1, 0, 1, 0.001) text("Alignment") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1)
rslider bounds(30, 264, 60, 60) channel("coh") range(0, 1, 0, 1, 0.001) text("Cohesion") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)
rslider bounds(30, 324, 60, 60) channel("speed") range(0.001, 0.1, 0.01, 1, 0.001) text("Speed") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255)

; --- 核心 DSP 控制 / Core DSP Controls ---
rslider bounds(26, 34, 60, 60) channel("delay_base") range(10, 2000, 500, 1, 1) text("Delay Base") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) markerColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255) fontColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1)
rslider bounds(90, 94, 60, 60) channel("feedback") range(0, 0.95, 0.4, 1, 0.001) text("Feedback") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255)  fontColour(0, 0, 0, 255) colour(255, 255, 255, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(90, 34, 60, 60) channel("mod_rate") range(0.01, 5, 0.5, 0.5, 0.01) text("LFO Rate") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255)  fontColour(0, 0, 0, 255) colour(255, 255, 255, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(26, 94, 60, 60) channel("Flock_Decay") range(0, 1, 0.3727, 1, 0.0001) outlineColour(255, 255, 255, 255)  text("Flock Decay") trackerColour(255, 255, 255, 255) fontColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) markerColour(255, 255, 255, 255)

rslider bounds(492, 266, 60, 60) channel("dry_wet") range(0, 1, 0.5, 1, 0.001) text("Flock Mix") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) outlineColour(255, 255, 255, 255) colour(255, 255, 255, 255) valueTextBox(1) fontColour(0, 0, 0, 255) markerColour(0, 0, 0, 255)
rslider bounds(492, 324, 60, 60) channel("vol") range(0, 16, 4, 1, 0.001) text("Master Gain") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) outlineColour(255, 255, 255, 255) colour(0, 0, 0, 255) valueTextBox(1) fontColour(255, 255, 255, 255) markerColour(255, 255, 255, 255)

; --- 7个跟随鸟的独立变调深度 / 7 Follower Birds Independent Pitch Warp Controls ---
label   bounds(442, 14, 158, 20) text("Birds Pitch Warp") channel("label17") fontColour(255, 255, 255, 255)
rslider bounds(456, 34, 60, 60) channel("m1") range(0, 50, 1, 0.3, 0.001) text("1") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255)  fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(516, 34, 60, 60) channel("m2") range(0, 50, 2, 0.3, 0.001) text("2") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(424, 94, 60, 60) channel("m3") range(0, 50, 3, 0.3, 0.001) text("3") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(480, 88, 73, 75) channel("m4") range(0, 50, 4, 0.3, 0.001) text("4") trackerColour(255, 255, 255, 255) textColour(255, 255, 255, 255) colour(0, 0, 0, 255) fontColour(255, 255, 255, 255)  markerColour(255, 255, 255, 255) valueTextBox(1) outlineColour(255, 255, 255, 255)
rslider bounds(544, 94, 60, 60) channel("m5") range(0, 50, 5, 0.3, 0.001) text("5") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(456, 154, 60, 60) channel("m6") range(0, 50, 6, 0.3, 0.001) text("6") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
rslider bounds(516, 154, 60, 60) channel("m7") range(0, 50, 7, 0.3, 0.001) text("7") trackerColour(255, 255, 255, 255) textColour(0, 0, 0, 255) colour(255, 255, 255, 255) fontColour(0, 0, 0, 255) valueTextBox(1) markerColour(0, 0, 0, 255)
label bounds(26, 14, 124, 20) channel("Delay_Set") text("Delay Set") fontColour(255, 255, 255, 255)

; --- 电平表 / VU Meters ---
vmeter bounds(230, 138, 25, 30), channel("mm1"), text("FL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255),rotate(2.35, 0, 0) corners(5) meterColour:0(255, 255, 255, 255) meterColour:1(229, 93, 93, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(382, 156, 25, 30), channel("mm2"), text("FR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(3.9269, 0, 0) corners(5) meterColour:0(255, 255, 255, 255) meterColour:1(229, 93, 93, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(214, 288, 25, 30), channel("mm3"), text("RL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(0.7853, 0, 0) corners(5) meterColour:0(255, 255, 255, 255) meterColour:1(229, 93, 93, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(362, 306, 25, 30), channel("mm4"), text("RR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(5.4977, 0, 0) corners(5) meterColour:0(255, 255, 255, 255) meterColour:1(229, 93, 93, 255) meterColour:2(255, 255, 255, 255)

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
nchnls = 4
0dbfs = 1

; 全局定义 / Global Definitions
giNumBoids = 8
gkX[] init 8
gkY[] init 8
gkVx[] init 8
gkVy[] init 8

; --- 引入 Statis 的等功率环绕渲染器 / Import Statis's Equal-Power Surround Renderer ---
opcode QuadRender, aaaa, aaaa
    aInL, aInR, aX, aY xin
    
    aX limit aX, 0.001, 0.999
    
    aY_inverted = 1 - aY
    aY_val limit aY_inverted, 0.001, 0.999

    aL = cos(aX * 1.570796)
    aR = sin(aX * 1.570796)
    aF = cos(aY_val * 1.570796)
    aB = sin(aY_val * 1.570796)

    aMono = (aInL + aInR) * 0.5
    
    aFL = aMono * aL * aF
    aFR = aMono * aR * aF
    aRL = aMono * aL * aB
    aRR = aMono * aR * aB
    
    xout aFL, aFR, aRL, aRR
endop

instr 1
    ; --- 1. 读取外部组件状态 / Read External Component States ---
    kHostX cabbageGetValue "x"
    kHostY cabbageGetValue "y"
    kBoxX  cabbageGetValue "box_x"
    kBoxY  cabbageGetValue "box_y"

    kMouseDown cabbageGetValue "MOUSE_DOWN_LEFT"
    kMouseX    cabbageGetValue "MOUSE_X"
    kMouseY    cabbageGetValue "MOUSE_Y"
    kClickTrig changed kMouseDown

    ; --- 2. 获取 UI 参数 / Fetch UI Parameters ---
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
    
    kM1 chnget "m1"
    kM2 chnget "m2"
    kM3 chnget "m3"
    kM4 chnget "m4"
    kM5 chnget "m5"
    kM6 chnget "m6"
    kM7 chnget "m7"

    ; 边缘触发器 / Edge Triggers
    kHostX_Chg changed kHostX
    kHostY_Chg changed kHostY
    kBoxX_Chg  changed kBoxX
    kBoxY_Chg  changed kBoxY

    kTimer init 0
    kTimer = kTimer + (ksmps / sr)

    kX init 0.5
    kY init 0.5

    ; --- 3. 初始化 Boids / Initialize Boids ---
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

    ; --- 4. 极简双击与拖拽状态机 / Minimalist Double-Click & Drag State Machine ---
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

    ; --- 5. 三路数据路由 / Three-Way Data Routing ---
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

    ; --- 6. Boids 物理循环 / Boids Physics Loop ---
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

    ; --- 7. UI 视讯刷新 (头鸟与7只从鸟位置渲染) / UI Visual Refresh (Leader and 7 Follower Birds Position Rendering) ---
    kUIMetro metro 30

    ; 头鸟渲染 / Leader Bird Rendering
    kBallX = 222 + (kX * 150) - 8
    kBallY = 146 + ((1 - kY) * 150) - 8
    S_Bounds sprintfk "bounds(%d, %d, 16, 16)", kBallX, kBallY
    cabbageSet kUIMetro, "visualBall", S_Bounds

    ; 从鸟 1-7 批量渲染 / Follower Birds 1-7 Batch Rendering
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

    ; --- 8. 音频处理 (10秒延迟线 + LFO调制) / Audio Processing (10s Delay Line + LFO Modulation) ---
    aInL, aInR inch 1, 2
    aSig = (aInL + aInR) * 0.5
    aFbkSum init 0
    
    aBuf delayr 10.0
    
    ; 生成 7 路带相位偏移的 LFO / Generate 7 LFOs with Phase Offsets
    kL1 oscil kM1, kLFORate, -1, 0.0
    kL2 oscil kM2, kLFORate * 1.1, -1, 0.1
    kL3 oscil kM3, kLFORate * 0.9, -1, 0.2
    kL4 oscil kM4, kLFORate * 1.2, -1, 0.3
    kL5 oscil kM5, kLFORate * 0.8, -1, 0.4
    kL6 oscil kM6, kLFORate * 1.3, -1, 0.5
    kL7 oscil kM7, kLFORate * 0.7, -1, 0.6

    ; 7路延迟读出 (基准延迟 + LFO偏移) / 7-Channel Delay Readout (Base Delay + LFO Offset)
    aT1 deltapi limit((kDelayBase*1.0 + kL1)/1000, 0.01, 9.9)
    aT2 deltapi limit((kDelayBase*1.3 + kL2)/1000, 0.01, 9.9)
    aT3 deltapi limit((kDelayBase*1.6 + kL3)/1000, 0.01, 9.9)
    aT4 deltapi limit((kDelayBase*1.9 + kL4)/1000, 0.01, 9.9)
    aT5 deltapi limit((kDelayBase*2.2 + kL5)/1000, 0.01, 9.9)
    aT6 deltapi limit((kDelayBase*2.5 + kL6)/1000, 0.01, 9.9)
    aT7 deltapi limit((kDelayBase*2.8 + kL7)/1000, 0.01, 9.9)
  
    aFD interp kFD
    aT1 = aT1 * aFD 
    aT2 = aT2 * aFD^2
    aT3 = aT3 * aFD^3
    aT4 = aT4 * aFD^4
    aT5 = aT5 * aFD^5
    aT6 = aT6 * aFD^6 
    aT7 = aT7 * aFD^7    
    
    ; 反馈混合并回灌 / Feedback Mixing and Re-injection
    aFbkSum = (aT1+aT2+aT3+aT4+aT5+aT6+aT7) * kFbk / 7
    delayw aSig + aFbkSum

    ; --- 9. 空间分配与混合输出 (应用 QuadRender) / Spatial Allocation & Mixed Output (Applying QuadRender) ---
    aX0 interp gkX[0]
    aY0 interp gkY[0]
    aIn0 = aSig * (1 - kMix)
    aL1, aR1, aSL1, aSR1 QuadRender aIn0, aIn0, aX0, aY0

    aX1 interp gkX[1]
    aY1 interp gkY[1]
    aIn1 = aT1 * kMix
    aL2, aR2, aSL2, aSR2 QuadRender aIn1, aIn1, aX1, aY1

    aX2 interp gkX[2]
    aY2 interp gkY[2]
    aIn2 = aT2 * kMix
    aL3, aR3, aSL3, aSR3 QuadRender aIn2, aIn2, aX2, aY2

    aX3 interp gkX[3]
    aY3 interp gkY[3]
    aIn3 = aT3 * kMix
    aL4, aR4, aSL4, aSR4 QuadRender aIn3, aIn3, aX3, aY3

    aX4 interp gkX[4]
    aY4 interp gkY[4]
    aIn4 = aT4 * kMix
    aL5, aR5, aSL5, aSR5 QuadRender aIn4, aIn4, aX4, aY4

    aX5 interp gkX[5]
    aY5 interp gkY[5]
    aIn5 = aT5 * kMix
    aL6, aR6, aSL6, aSR6 QuadRender aIn5, aIn5, aX5, aY5

    aX6 interp gkX[6]
    aY6 interp gkY[6]
    aIn6 = aT6 * kMix
    aL7, aR7, aSL7, aSR7 QuadRender aIn6, aIn6, aX6, aY6

    aX7 interp gkX[7]
    aY7 interp gkY[7]
    aIn7 = aT7 * kMix
    aL8, aR8, aSL8, aSR8 QuadRender aIn7, aIn7, aX7, aY7

    aFL = (aL1+aL2+aL3+aL4+aL5+aL6+aL7+aL8) * kVol
    aFR = (aR1+aR2+aR3+aR4+aR5+aR6+aR7+aR8) * kVol
    aRL = (aSL1+aSL2+aSL3+aSL4+aSL5+aSL6+aSL7+aSL8) * kVol
    aRR = (aSR1+aSR2+aSR3+aSR4+aSR5+aSR6+aSR7+aSR8) * kVol

    outq aFL, aFR, aRL, aRR

    ; --- 10. 高精电平表反馈 / High-Precision VU Meter Feedback ---
    kP1 max_k abs(aFL), kUIMetro, 1
    kP2 max_k abs(aFR), kUIMetro, 1
    kP3 max_k abs(aRL), kUIMetro, 1
    kP4 max_k abs(aRR), kUIMetro, 1

    cabbageSetValue "mm1", portk(kP1, .05), kUIMetro
    cabbageSetValue "mm2", portk(kP2, .05), kUIMetro
    cabbageSetValue "mm3", portk(kP3, .05), kUIMetro
    cabbageSetValue "mm4", portk(kP4, .05), kUIMetro

endin
</CsInstruments>
<CsScore>
f0 z 
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>