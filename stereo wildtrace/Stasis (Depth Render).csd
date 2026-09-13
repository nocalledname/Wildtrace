;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-Stasis.vst3

<Cabbage>
form caption("Depth-Stasis") size(320, 490), guiMode("queue"), pluginId("DPST") colour(15, 23, 42, 255)
; 0. 极夜纯黑底层背景 | dark background
image bounds(0, 0, 320, 490) channel("bg") colour(15, 18, 25, 255) 

; 1. 严格正方形自制雷达网格 | square radar grid
image bounds(70, 78, 180, 180) colour(170, 184, 214, 15)  outlineThickness(1) channel("radarGrid") corners(6)
image bounds(159, 78, 1, 180) colour(255, 255, 255, 50) channel("centerV")
image bounds(70, 167, 180, 1) colour(255, 255, 255, 50) channel("centerH")

; 2. 动态游标小球（高亮金黄色） | golden cursor ball
image bounds(152, 160, 16, 16) shape("circle")  channel("visualBall") colour(245, 158, 11, 255) 

; 3. 高精数显输入框 | numeric X/Y readouts
nslider bounds(70, 275, 85, 28) channel("box_x") automatable(0) range(0, 1, 0.5, 1, 0.001) text("X (Pan)") colour(30, 41, 59, 255) fontColour(255, 255, 255, 220)
nslider bounds(165, 275, 85, 28) channel("box_y") automatable(0) range(0, 1, 0.5, 1, 0.001) text("Y (Depth)") colour(30, 41, 59, 255) fontColour(255, 255, 255, 220)

; 4. 混响发送量范围条 | wet send range (min/max)
label bounds(70, 315, 180, 15) text("Wet Send Range (Min / Max)") fontColour(255, 255, 255, 120) channel("labelWet") align("center")
hrange bounds(70, 332, 180, 28) channel("minWet", "maxWet") range(0, 1, 0.1:0.6, 1, 0.001) trackerColour(14, 165, 233, 200) outlineColour(0, 0, 0, 150)

; 5. 声场声学控制参数（Room Size 与 Damping） | room size & damping knobs
rslider bounds(65, 385, 85, 85) channel("roomSize") range(10, 100, 50, 1, 0.1) text("Room Size") trackerColour(14, 165, 233, 255) outlineColour(30, 41, 59, 255) fontColour(255, 255, 255, 150) textColour(255, 255, 255, 200)
rslider bounds(170, 385, 85, 85) channel("cutoff") range(1000, 16000, 6000, 0.5, 1) text("Damping (Hz)") trackerColour(14, 165, 233, 255) outlineColour(30, 41, 59, 255) fontColour(255, 255, 255, 150) textColour(255, 255, 255, 200)

; 6. 宿主自动化映射底座（隐藏） | hidden host-automation sliders
hslider bounds(-100, -100, 50, 20) channel("x") range(0, 1, 0.5)
hslider bounds(-100, -100, 50, 20) channel("y") range(0, 1, 0.5) 

; 7. Master L/R 总输出垂直电平表 | master L/R meters
vmeter bounds(30, 78, 15, 180), channel("outL"), outlineColour(0, 0, 0, 150), overlayColour(15, 23, 42, 255), value(0) meterColour:0(16, 185, 129, 255) meterColour:1(245, 158, 11, 255) meterColour:2(239, 68, 68, 255)
vmeter bounds(275, 78, 15, 180), channel("outR"), outlineColour(0, 0, 0, 150), overlayColour(15, 23, 42, 255), value(0) meterColour:0(16, 185, 129, 255) meterColour:1(245, 158, 11, 255) meterColour:2(239, 68, 68, 255)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2      
0dbfs = 1

; 核心操作码：DepthStereoRender（双声道深度渲染引擎） | core opcode (stereo depth renderer)
opcode DepthStereoRender, aaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin
    
    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999
    
    aDepth = aY
    aRoomSize interp kRoomSize
    
    ; 1. 方位声像：X轴等功率几何平移 | equal-power X pan
    aL_pan = cos(aX * 1.570796)
    aR_pan = sin(aX * 1.570796)
    aMono = (aInL + aInR) * 0.5
    
    aPanL = aMono * aL_pan
    aPanR = aMono * aR_pan
    
    ; 2. 动态多普勒距离延迟 | doppler distance delay
    aDelayTime = 0.01 + (aDepth * (aRoomSize * 0.002)) ; 优化空间尺寸物理映射 | physical room-size delay mapping
    aDlyL vdelay3 aPanL, aDelayTime * 1000, 500
    aDlyR vdelay3 aPanR, aDelayTime * 1000, 500
    
    ; 3. 空气声学吸收（高频随深度衰减） | air absorption (highs roll off with depth)
    aDepthInv = 1 - aDepth
    aAirCutoff = 800 + ((aDepthInv * aDepthInv * aDepthInv) * 19200)
    
    aFiltL tone aDlyL, aAirCutoff
    aFiltR tone aDlyR, aAirCutoff
    
    ; 4. 空间平方反比衰减（与房间尺寸绑定） | distance attenuation tied to room size
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDepth * aDecayFactor) 
    
    aDryL = aFiltL * aDistAmp
    aDryR = aFiltR * aDistAmp
    
    ; 5. 声能空间反射混响发送矩阵 | reverb send matrix
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDepth * (aMaxWet - aMinWet))
    
    aWetL = aFiltL * aWetSend
    aWetR = aFiltR * aWetSend
    
    xout aDryL, aDryR, aWetL, aWetR
endop

; 主乐器通道控制逻辑 | main instrument control logic
instr 1
    ; --- 1. 实时捕获前端组件与宿主自动化状态 | read widgets & host automation ---
    kHostX cabbageGetValue "x"
    kHostY cabbageGetValue "y"
    kBoxX  cabbageGetValue "box_x"
    kBoxY  cabbageGetValue "box_y"
    
    kMinWet cabbageGetValue "minWet"
    kMaxWet cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"

    kMouseDown cabbageGetValue "MOUSE_DOWN_LEFT"
    kMouseX    cabbageGetValue "MOUSE_X"
    kMouseY    cabbageGetValue "MOUSE_Y"
    kClickTrig changed kMouseDown
    
    ; --- 2. 核心状态边缘检测触发器 | edge-change triggers ---
    kHostX_Chg changed kHostX
    kHostY_Chg changed kHostY
    kBoxX_Chg  changed kBoxX
    kBoxY_Chg  changed kBoxY

    kTimer init 0
    kTimer = kTimer + (ksmps / sr)

    kX init 0.5
    kY init 0.5

    ; --- 3. 双击归位与网格拖拽状态机 | double-click recenter & drag state machine ---
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

    ; --- 4. 三路控制数据互锁路由 | three-way data routing ---
    if (kDoubleClickEvent == 1) then
        kX = 0.5
        kY = 0.5
        cabbageSetValue "x", 0.5, kDoubleClickEvent
        cabbageSetValue "y", 0.5, kDoubleClickEvent
        cabbageSetValue "box_x", 0.5, kDoubleClickEvent
        cabbageSetValue "box_y", 0.5, kDoubleClickEvent
        
    elseif (kActive == 1 && kIgnoreDrag == 0) then
        kTargetX = (kMouseX - 70) / 180
        kTargetX limit kTargetX, 0, 1
        
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

    ; --- 5. DSP 渲染与防爆音平滑 | DSP rendering & smoothing ---
    kX_smooth portk limit(kX, 0, 1), 0.06
    kY_smooth portk limit(kY, 0, 1), 0.06

    aX interp kX_smooth
    aY interp kY_smooth
    
    aInL, aInR inch 1, 2
    
    ; 接入核心空间运算 | run spatial engine
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize
    
    ; RoomSize(10~100) 映射到 Feedback 系数(0.15~0.92) | map RoomSize to feedback
    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    
    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kCutoff, 0.04
    
    ; 注入双立体声混响矩阵 | stereo reverb
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    ; 双声道最终信号合流 | final stereo mix
    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
    outs aOutL, aOutR

    ; --- 6. UI 雷达球坐标刷新 (30Hz) | radar ball UI refresh (30 Hz) ---
    kBallX = 70 + (kX * 180) - 8
    kBallY = 78 + ((1 - kY) * 180) - 8
    
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