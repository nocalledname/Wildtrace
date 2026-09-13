<Cabbage>
form caption("Beta-Stasis") size(320, 380), guiMode("queue"), pluginId("BTst") colour(15, 23, 42, 255)

; --- 1. Background | 底层纯黑背景 ---
image bounds(0, 0, 320, 380) channel("bg") colour(10, 10, 10, 255) file("stasis_background.png")

; --- 2. Radar Grid (Overlays the halo) | 正方形雷达网格 (压在光晕之上) ---
image bounds(70, 78, 180, 180) colour(170, 184, 214, 25)  outlineThickness(1) channel("image7") corners(5)
image bounds(159, 78, 1, 180) colour(137, 137, 137, 200) channel("image43")
image bounds(70, 167, 180, 1) colour(137, 137, 137, 200) channel("image44")

; --- 3. Dynamic Cursor Ball | 动态游标小球 ---
image bounds(152, 160, 16, 16) shape("circle")  channel("visualBall") colour(224, 177, 50, 255) 

; --- 4. High-Precision Number Input Boxes | 高精度数值输入框 ---
nslider bounds(76, 322, 85, 30) channel("box_x") automatable(0) range(0, 1, 0.5, 1, 0.001) text("X") colour(0, 0, 0, 255) fontColour(255, 255, 255, 255)
nslider bounds(166, 322, 85, 30) channel("box_y") automatable(0) range(0, 1, 0.5, 1, 0.001) text("Y") colour(0, 0, 0, 255) fontColour(255, 255, 255, 255)

; --- 5. Hidden Host Automation Sliders | 【绝对隐藏】宿主自动化映射底座 ---
hslider bounds(-100, -100, 50, 20) channel("x") range(0, 1, 0.5)
hslider bounds(-100, -100, 50, 20) channel("y") range(0, 1, 0.5) 

; --- 6. Symmetrical 4-Channel VU Meters | 四声道对称视觉电平表 ---
vmeter bounds(54, 64, 35, 50), channel("m1"), , text("FL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(2.3561, 13, 6)    value(0.00446036) meterColour:0(20, 30, 20, 255) meterColour:1(50, 232, 255, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(232, 64, 35, 50), channel("m2"), , text("FR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(3.9269, 22, 6)    value(0.00446036) meterColour:0(0, 30, 0, 255) meterColour:1(19, 0, 255, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(54, 246, 35, 50), channel("m3"), , text("RL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(0.7853, 0, 0)    value(0.00446036) meterColour:0(30, 0, 0, 255) meterColour:1(255, 50, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(240, 270, 35, 50), channel("m4"), , text("RR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(5.4977, 0, 0)    value(0.00446036) meterColour:0(0, 30, 30, 255) meterColour:1(255, 50, 224, 255) meterColour:2(255, 255, 255, 255)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 4
0dbfs = 1

opcode QuadRender, aaaa, aaaa
    aInL, aInR, aX, aY xin
    
    aX limit aX, 0.001, 0.999
    
    ; Invert standard Y (1=Front) to math angle 0 so cos(0)=1 (sound focuses on front).
    ; DSP映射：将标准Y值(1=前)反转为角度0，使得 cos(0)=1，声音完美集中在前置通道。
    aY_inverted = 1 - aY
    aY_val limit aY_inverted, 0.001, 0.999

    ; Constant power panning calculation | 等功率声像计算
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
    ; --- 1. Read UI & Mouse State | 读取组件与鼠标状态 ---
    kHostX cabbageGetValue "x"
    kHostY cabbageGetValue "y"
    kBoxX  cabbageGetValue "box_x"
    kBoxY  cabbageGetValue "box_y"

    kMouseDown cabbageGetValue "MOUSE_DOWN_LEFT"
    kMouseX    cabbageGetValue "MOUSE_X"
    kMouseY    cabbageGetValue "MOUSE_Y"
    kClickTrig changed kMouseDown
    
    ; --- 2. Change Detectors (Edge Triggers) | 数值变化边缘触发器 ---
    kHostX_Chg changed kHostX
    kHostY_Chg changed kHostY
    kBoxX_Chg  changed kBoxX
    kBoxY_Chg  changed kBoxY

    kTimer init 0
    kTimer = kTimer + (ksmps / sr)

    kX init 0.5
    kY init 0.5

    ; --- 3. Mouse State Machine (Double-click & Drag) | 极简鼠标状态机 (双击与拖拽) ---
    kLastClickTime init -99
    kDoubleClickEvent init 0
    kActive init 0
    kIgnoreDrag init 0

    if (kMouseDown == 0) then
        kActive = 0
        kIgnoreDrag = 0 
    endif

    if (kClickTrig == 1 && kMouseDown == 1) then
        if (kMouseX >= 70 && kMouseX <= 250 && kMouseY >= 78 && kMouseY <= 258) then
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

    ; --- 4. 3-Way Data Routing & Sync | 三路数据路由与同步 ---
    if (kDoubleClickEvent == 1) then
        ; Reset to center on double click | 双击回中
        kX = 0.5
        kY = 0.5
        cabbageSetValue "x", 0.5, kDoubleClickEvent
        cabbageSetValue "y", 0.5, kDoubleClickEvent
        cabbageSetValue "box_x", 0.5, kDoubleClickEvent
        cabbageSetValue "box_y", 0.5, kDoubleClickEvent
        
    elseif (kActive == 1 && kIgnoreDrag == 0) then
        ; Mouse dragging logic | 鼠标拖拽逻辑
        kTargetX = (kMouseX - 70) / 180
        kTargetX limit kTargetX, 0, 1
        
        ; Map screen Y to standard Y: invert so 1=Top, 0=Bottom.
        ; 屏幕坐标映射：反转屏幕Y轴，使 1=最上(前)，0=最下(后)。
        kTargetY = 1 - ((kMouseY - 78) / 180)
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
        ; Sync with Host Automation or Input Boxes | 与宿主自动化或输入框同步
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

    ; --- 5. DSP Processing & Output | DSP 渲染与音频输出 ---
    aX interp limit(kX, 0, 1)
    aY interp limit(kY, 0, 1)
    aInL, aInR inch 1, 2
    aFL, aFR, aRL, aRR QuadRender aInL, aInR, aX, aY
    outq aFL, aFR, aRL, aRR

    ; --- 6. UI Visual Update | 界面视讯刷新 ---
    kBallX = 70 + (kX * 180) - 8
    
    ; Re-invert standard Y (1=Top) back to physical screen coordinates for UI rendering.
    ; UI渲染映射：把标准的Y值重新反转回屏幕的物理坐标用于绘制小球。
    kBallY = 78 + ((1 - kY) * 180) - 8
    
    kUIMetro metro 30
    S_Bounds sprintfk "bounds(%d, %d, 16, 16)", kBallX, kBallY
    cabbageSet kUIMetro, "visualBall", S_Bounds
    
    ; --- 7. High-Precision Meter Feedback | 高精电平表反馈 ---
    kP1 max_k abs(aFL), kUIMetro, 1
    kP2 max_k abs(aFR), kUIMetro, 1
    kP3 max_k abs(aRL), kUIMetro, 1
    kP4 max_k abs(aRR), kUIMetro, 1

    cabbageSetValue "m1", portk(kP1, .05), kUIMetro
    cabbageSetValue "m2", portk(kP2, .05), kUIMetro
    cabbageSetValue "m3", portk(kP3, .05), kUIMetro
    cabbageSetValue "m4", portk(kP4, .05), kUIMetro
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>