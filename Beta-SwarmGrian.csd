<Cabbage> bounds(0, 0, 0, 0)
form caption("Wildtrace SwarmGrain 3.5 (Clipping Mask Core)") size(410, 650), guiMode("queue"), pluginId("WTG3"), colour(15, 15, 15, 255) 

; ==========================================
; 【图层 1】：全局底漆
; ==========================================
image bounds(0, 0, 410, 650) channel("bg") colour(10, 10, 10, 255)

; ==========================================
; 【图层 2】：虚拟 Pad 底座 (暗色观察窗)
; ==========================================
image bounds(44, 44, 200, 200), colour(0, 0, 0, 255)

; ==========================================
; 【图层 3】：10 层热力场同心圆 (在底层游荡，可能越界)
; ==========================================
image bounds(0,0, 10,10), channel("circle100"), shape("ellipse"), colour(255,255,255,255), outlineColour(25,25,25,255), outlineThickness(1)
image bounds(0,0, 10,10), channel("circle90"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle80"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle70"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle60"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle50"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle40"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle30"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle20"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
; 准星直接整合在 10% 最小圆的描边上
image bounds(0,0, 10,10), channel("circle10"),  shape("ellipse"), colour(255,255,255,255), outlineColour(255, 32, 55, 255), outlineThickness(1)

<Cabbage> bounds(0, 0, 0, 0)
form caption("Wildtrace SwarmGrain 3.5 (Clipping Mask Core)") size(410, 650), guiMode("queue"), pluginId("WTG3"), colour(15, 15, 15, 255) 

; ==========================================
; 【图层 1】：全局底漆 / Layer 1: Global Primer Background
; ==========================================
image bounds(0, 0, 410, 650) channel("bg") colour(10, 10, 10, 255)

; ==========================================
; 【图层 2】：虚拟 Pad 底座 (暗色观察窗) / Layer 2: Virtual Pad Base (Dark Observation Window)
; ==========================================
image bounds(44, 44, 200, 200), colour(0, 0, 0, 255)

; ==========================================
; 【图层 3】：10 层热力场同心圆 (在底层游荡，可能越界) / Layer 3: 10-Layer Thermal Field Concentric Circles
; ==========================================
image bounds(0,0, 10,10), channel("circle100"), shape("ellipse"), colour(255,255,255,255), outlineColour(25,25,25,255), outlineThickness(1)
image bounds(0,0, 10,10), channel("circle90"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle80"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle70"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle60"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle50"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle40"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle30"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle20"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
; 准星直接整合在 10% 最小圆的描边上 / Reticle integrated directly on the 10% innermost circle's stroke
image bounds(0,0, 10,10), channel("circle10"),  shape("ellipse"), colour(255,255,255,255), outlineColour(255, 32, 55, 255), outlineThickness(1)


; ==========================================
; 【图层 4】：物理遮罩涂层 (CLIPPING MASKS) / Layer 4: Physical Mask Coating (Clipping Masks)
; ==========================================
; 左遮罩 (X: 0~44) / Left Mask
image bounds(0, 0, 44, 650), colour(10, 10, 10, 255)
; 右遮罩 (X: 244~410) / Right Mask
image bounds(244, 0, 166, 650), colour(10, 10, 10, 255)
; 上遮罩 (Y: 0~44) / Top Mask
image bounds(44, 0, 200, 44), colour(10, 10, 10, 255)
; 下遮罩 (Y: 244~620) / Bottom Mask
image bounds(44, 244, 200, 406), colour(10, 10, 10, 255)

; ==========================================
; 【图层 5】：顶层 UI 框架与控制器 (架在遮罩之上) / Layer 5: Top-Level UI Framework & Controllers
; ==========================================
; 重新描绘 Pad 的精准外边框 / Redraw precise outer border of the Pad
image bounds(44, 44, 200, 200), colour(0, 0, 0, 0), outlineColour(80, 80, 80, 255), outlineThickness(1) channel("pad")

; 我们自己的 X/Y 轴推子 / Custom X/Y Axis Sliders
hslider bounds(44, 24, 200, 20), channel("centerX"), range(0, 1, 0.5, 1, 0.01), trackerColour(200, 200, 200, 255)
vslider bounds(24, 44, 20, 200), channel("centerY"), range(0, 1, 0.5, 1, 0.01), trackerColour(200, 200, 200, 255)

label bounds(44, 8, 80, 15), text("X-Axis"), fontColour(150, 150, 150, 255), align("left") channel("X-axis")
label bounds(24, 44, 80, 15), text("Y-Axis"), fontColour(150, 150, 150, 255), align("left") channel("Y-axis") rotate(1.57079, 0, 0)

; 四声道反馈矩阵 / Quadraphonic Feedback Matrix
vmeter bounds(288, 0, 30, 45), channel("m1"), rotate(3.14159, 15, 48), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
vmeter bounds(324, 0, 30, 45), channel("m2"), rotate(3.14159, 15, 48), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
vmeter bounds(288, 102, 30, 45), channel("m3"), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
vmeter bounds(324, 102, 30, 45), channel("m4"), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
label bounds(250, 28, 130, 15), text("Quad Out"), fontColour(150, 150, 150, 255),  channel("quadout")

; ==========================================
; 【核心修复】：gentable 窗函数可视化 / Core Fix: gentable Window Function Visualization
; ==========================================
gentable bounds(250, 166, 130, 78),channel("windowTable") , tableNumber(1.0), colour(255, 255, 255, 255), outlineColour(255, 0, 80, 255), ampRange(0.0, 1.0, -1.0, 0.0100), , tableGridColour(255, 255, 255, 175) tableColour:0(255, 32, 55, 205)
label bounds(20, 432, 110, 18), text("window"), fontColour(150, 150, 150, 255) channel("Wind") align("left")

; ------------------------------------------
; 麦克迪原始颗粒控制参数 / McCurdy Granular Control Parameters
; ------------------------------------------
label bounds(20, 256, 181, 15), text("1.  GAUSS FIELD"), fontColour(205, 32, 55, 255), align("left") channel("gaussfield")
image bounds(20, 273, 362, 1), colour(50, 50, 50, 255)

hslider bounds(20, 278, 245, 20), channel("Dens"), range(1, 500, 100, 1, 1), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 452, 240, 20), channel("GSize"), range(0.005, 1, 0.1, 0.5, 0.001), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 384, 240, 20), channel("DlyMax"), range(0.01, 5, 1, 0.5, 0.001), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 410, 240, 20), channel("reverse"), range(0, 1, 0.5, 1, 0.001), valueTextBox(1), trackerColour(200, 200, 200, 255)
label bounds(270, 280, 110, 16), text("Density") channel("density")align("right")
label bounds(20, 454, 110, 16), text("Grain Size")align("left")
label bounds(20, 386, 110, 16), text("Max Delay")align("left")
label bounds(20, 412, 110, 16), text("Reverse Prob")align("left") channel("reverse")

combobox bounds(302, 432, 77, 18), channel("window"), value(4), text("Half Sine", "rectangle", "Hamming", "Gaussian", "traingle")

; ------------------------------------------
; 空间滤波与主输出 / Spatial Filtering & Master Output
; ------------------------------------------
label bounds(20, 360, 246, 15), , fontColour(205, 32, 55, 255), align("left") channel("delaygrain")align("left") text("2.Delay GRAIN")
image bounds(20, 380, 360, 1), colour(50, 50, 50, 255) channel("image98")

hslider bounds(20, 302, 248, 20), channel("radius"), range(0.01, 0.5, 0.25, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)

; 滤波范围控制 - 数字输入框 / Filter Range Control - Numeric Sliders
nslider bounds(44, 324, 75, 22) channel("rangeMin") range(20, 20000, 20000, 0.5, 1) 
nslider bounds(158, 324, 75, 22) channel("rangeMax") range(20, 20000, 100, 0.5, 1)

label bounds(270, 304, 110, 16), text("Field Radius")align("right") channel("fieldradius")
label bounds(260, 328, 120, 16), text("Cutoff Range:Hz")align("left") channel("cutoff")

hslider bounds(20, 512, 240, 20), channel("step"), range(0.001, 0.5, 0.5, 1, 0.001), , textColour(150, 150, 150, 255), trackerColour(200, 200, 200, 255) valueTextBox(1)
label bounds(275, 514, 108, 16), text("Dry Step Size") channel("drystep") align("right")

hslider bounds(140, 564, 240, 16), channel("mix"), range(0, 1, 0.5, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 586, 240, 20), channel("level"), range(0, 4, 1, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)
label bounds(20, 560, 110, 16), text("Dry/Wet Mix") channel("mix")align("left")
label bounds(20, 588, 110, 16), text("Master Output") channel("out")align("left")

label bounds(10, 636, 400, 16), text("WILDTRACE SERIES"), align("right"), fontColour(255, 32, 55, 205) channel("label112")

image bounds(20, 474, 360, 1), colour(50, 50, 50, 255) channel("image99")

label bounds(20, 484, 183, 16) channel("label10056") text("3.BROWNIAN PLANKTON") align("left") colour(202, 28, 28, 0) fontColour(188, 29, 29, 255)
label bounds(20, 538, 172, 16) channel("label10057") text("4.MASTER SETTING") align("left") colour(192, 17, 17, 0) fontColour(192, 21, 21, 255)
image bounds(20, 558, 364, 1), colour(50, 50, 50, 255) channel("image999")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -m0
</CsOptions>

<CsInstruments>
ksmps = 64
nchnls = 4
0dbfs = 1

; =========================================================
; 🚨 核心逻辑：定义显示缓冲区 (Table 1) / Core Logic: Define Display Buffer Table
; =========================================================
giDisplay ftgen 1, 0, 1024, 10, 1 

; 定义源窗函数 (101-105) / Define Source Window Functions
giw101 ftgen 101, 0, 1024, 9, 0.5, 1, 0 
giw102 ftgen 102, 0, 1024, 20,8,1
giw104 ftgen 103, 0, 1024, 20, 1, 1
giw105 ftgen 104, 0, 1024, 20, 6, 1
giw103 ftgen 105, 0, 1024, 7, 0, 512, 1, 512, 0 
giwindows ftgen 100, 0, 8, -2, 101, 102, 103, 104, 105

giBufL ftgen 0, 0, 1048576, -2, 0 
giBufR ftgen 0, 0, 1048576, -2, 0 

gaGMixFL, gaGMixFR, gaGMixRL, gaGMixRR init 0
gaDryL, gaDryR init 0

; ---------------------------------------------------------
; [UDO] 空间摆位渲染器 (aaii) / Quadraphonic Positioning Renderer UDO
; ---------------------------------------------------------
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

; =========================================================
; INSTR 1: 母体调度与 UI 场域绘画 / Master Scheduling & UI Field Drawing
; =========================================================
instr 1 
    kDens    chnget "Dens"
    kGSize   chnget "GSize"
    kDlyMax  chnget "DlyMax"
    kreverse chnget "reverse"
    kwindow  chnget "window"
    
    kCenterX chnget "centerX"
    kCenterY chnget "centerY"
    kRadius  chnget "radius"

    kRanMin  chnget "rangeMin"
    kRanMax  chnget "rangeMax"

    if changed(kwindow) == 1 || timeinstk() == 1 then
        kSourceNum table kwindow - 1, 100
        event "i", "UpdateUI", 0, 0.01, kSourceNum
    endif
     
    ; --- 捕获音频 / Capture Audio ---
    aL, aR inch 1, 2
    gaDryL = aL
    gaDryR = aR
     
    ilen = ftlen(giBufL)
    aptr phasor sr/ilen
    aWriteIdx = aptr * ilen
    tablew aL, aWriteIdx, giBufL
    tablew aR, aWriteIdx, giBufR
    
    kptr downsamp aWriteIdx

    ; --- UI 场域热力雷达绘制 (30fps) / UI Thermal Field Radar Rendering ---
    kUIMetro metro 30
    if kUIMetro == 1 then
        kPadX = 44
        kPadY = 44
        kPadW = 200
        
        kCX_px = kPadX + (kCenterX * kPadW)
        kCY_px = kPadY + ((1 - kCenterY) * kPadW)
        kR_px = kRadius * kPadW
        
        kScales[] fillarray 1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1
        S_chans[] fillarray "circle100", "circle90", "circle80", "circle70", "circle60", "circle50", "circle40", "circle30", "circle20", "circle10"
        
        kIndex = 0
        while kIndex < 10 do
            kNormDist = kScales[kIndex]
            kCurR = kR_px * kNormDist
            kBoundX = kCX_px - kCurR
            kBoundY = kCY_px - kCurR
            kBoundW = kCurR * 2
            
            kGauss = exp(-(kNormDist * kNormDist * 5))
            kCutoff = kRanMin * ((kRanMax / kRanMin) ^ kGauss)
            kLogRatio = log10(kCutoff / 20) / log10(20000 / 20)
            kRGB = limit(kLogRatio * 255, 1, 255)
            
            S_col sprintfk "colour(%d, %d, %d, 255)", int(kRGB), int(kRGB), int(kRGB)
            cabbageSet 1, S_chans[kIndex], "bounds", kBoundX, kBoundY, kBoundW, kBoundW
            cabbageSet 1, S_chans[kIndex], S_col
            kIndex += 1
        od
    endif

    ; --- 实例化调度 / Grain Scheduling ---
    ktrig metro kDens
    kMinDly = 0
    kMaxDly = kDlyMax + 0.001
    ioffset = 1/sr
    
    if ktrig == 1 then
        kDly random 0, 1
        kDly = kDly * kMaxDly
        schedkwhen ktrig, 0, 0, 2, kDly+0.0001, kGSize, kptr, kreverse, kDly, kMinDly+ioffset, kMaxDly+0.0001, kwindow, kCenterX, kCenterY, kRadius, kRanMin, kRanMax
    endif
endin

; 🚨 核心刷新工具：专门处理 UI 渲染同步 / Core Refresh Utility: Handles UI Render Sync
instr UpdateUI
    iSource = p4
    ; 1. 将源表数据物理复制到显示表 (Table 1) / Physically copy source table data to display table
    tablecopy 1, iSource 
    ; 2. 给 UI 控件发一个“重绘”指令 / Send "redraw" command to UI control
    cabbageSet "windowTable", "tableNumber", 1
endin

; =========================================================
; INSTR 2: McCurdy 颗粒对象 + Wildtrace 空间滤波 / McCurdy Granular Object + Spatial Filtering
; =========================================================
instr 2
    iGStart = p4
    ireverse = (rnd(1) > p5 ? 1 : -1)
    idly = p6
    iMinDly = p7
    iMaxDly = p8
    iwindow table p9 - 1, 100
    
    iCX = p10
    iCY = p11
    iRadius = p12
    iRanMin = p13
    iRanMax = p14
    
    ; 物理位置分布 / Physical Position Distribution
    iR = iRadius * sqrt(rnd(1))
    iTheta = rnd(6.2831853)
    iPosX limit (iCX + iR * cos(iTheta)), 0.001, 0.999
    iPosY limit (iCY + iR * sin(iTheta)), 0.001, 0.999
    
    ; 滤波映射 / Filtering Mapping
    iDist = sqrt((iPosX - iCX)^2 + (iPosY - iCY)^2)
    iNormDist = limit(iDist / (iRadius + 0.0001), 0, 1)
    
    ; 指数级音频 DSP 滤波计算 / Exponential Audio DSP Filter Calculation
    iGauss = exp(-(iNormDist * iNormDist * 5))
    iCutoff = iRanMin * ((iRanMax / iRanMin) ^ iGauss)

    ; 音频捕获 / Audio Capture
    iStrtOS = 0
    aline line iGStart - iStrtOS, p3, iGStart - iStrtOS + (p3 * sr * ireverse)
    aenv oscili 1, 1/p3, iwindow
    
    aL tablei aline, giBufL, 0, 0, 1
    aR tablei aline, giBufR, 0, 0, 1
    
    aGrainL = aL * aenv
    aGrainR = aR * aenv

    ; 高斯滤波 / Gaussian Filtering
    aGrainL butterlp aGrainL, iCutoff
    aGrainR butterlp aGrainR, iCutoff

    kPosX = k(iPosX)
    kPosY = k(iPosY)
    aPosX interp kPosX
    aPosY interp kPosY    
    
    ; 声道路由 / Audio Routing
    aFL, aFR, aRL, aRR QuadRender aGrainL, aGrainR, aPosX, aPosY
    
    gaGMixFL = gaGMixFL + aFL
    gaGMixFR = gaGMixFR + aFR
    gaGMixRL = gaGMixRL + aRL
    gaGMixRR = gaGMixRR + aRR
endin

; =========================================================
; INSTR 3: 输出终端 / Output Terminal
; =========================================================
instr 3
    kCenterX chnget "centerX"
    kCenterY chnget "centerY"
    kRate    chnget "Dens"   
    kStepBase  cabbageGetValue "step"    
    kRadius  chnget "radius"  
    kRanMin  chnget "rangeMin"
    kRanMax  chnget "rangeMax"      
    kmix     chnget "mix"
    klevel   chnget "level"

    kX init 0.5
    kY init 0.5
    kTrig metro kRate
    
    ; --- 2. 高斯布朗运动算法 / Gaussian Brownian Motion Algorithm ---
    if kTrig == 1 then
        kAng random 0, 6.2831853
        kStep gauss kStepBase   
        kNextX = kX + cos(kAng) * kStep
        kNextY = kY + sin(kAng) * kStep
        kNextX = kNextX + (kCenterX - kNextX) * 0.15
        kNextY = kNextY + (kCenterY - kNextY) * 0.15
        kX limit kNextX, 0, 1
        kY limit kNextY, 0, 1
    endif

    kX_disp portk kX, 0.05
    kY_disp portk kY, 0.05
    
    aCenterX interp kX_disp
    aCenterY interp kY_disp    
    
    ; --- 3. 距离与滤波器截止频率映射 / Distance & Filter Cutoff Mapping ---
    kDist = sqrt((kX_disp - kCenterX)^2 + (kY_disp - kCenterY)^2)
    kNormDist limit (kDist / kRadius), 0, 1

    kGaussFilter exp -(kNormDist * kNormDist * 5)
    kCutoff = kRanMin + ((kRanMax - kRanMin) * kGaussFilter)
    kCutoff_sm portk kCutoff, 0.05    
    
    gadry = gaDryL + gaDryR 
     
    aFiltered butterlp gadry, kCutoff_sm              
    aFLdry, aFRdry, aRLdry, aRRdry QuadRender aFiltered, aFiltered, aCenterX, aCenterY

    aOutFL = (aFLdry * (1-kmix) + gaGMixFL * kmix) * klevel
    aOutFR = (aFRdry * (1-kmix) + gaGMixFR * kmix) * klevel
    aOutRL = (aRLdry * (1-kmix) + gaGMixRL * kmix) * klevel
    aOutRR = (aRRdry * (1-kmix) + gaGMixRR * kmix) * klevel

    outq aOutFL, aOutFR, aOutRL, aOutRR

    kUIMetro metro 30 
    cabbageSetValue "m1", portk(max_k(abs(aOutFL), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "m2", portk(max_k(abs(aOutFR), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "m3", portk(max_k(abs(aOutRL), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "m4", portk(max_k(abs(aOutRR), kUIMetro, 1), 0.05), kUIMetro

    clear gaGMixFL, gaGMixFR, gaGMixRL, gaGMixRR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 3 0 -1
</CsScore>
</CsoundSynthesizer>
; ==========================================
; 【图层 4】：物理遮罩涂层 (CLIPPING MASKS) 
; ==========================================
; 左遮罩 (X: 0~44)
image bounds(0, 0, 44, 650), colour(10, 10, 10, 255)
; 右遮罩 (X: 244~410)
image bounds(244, 0, 166, 650), colour(10, 10, 10, 255)
; 上遮罩 (Y: 0~44)
image bounds(44, 0, 200, 44), colour(10, 10, 10, 255)
; 下遮罩 (Y: 244~620)
image bounds(44, 244, 200, 406), colour(10, 10, 10, 255)

; ==========================================
; 【图层 5】：顶层 UI 框架与控制器 (架在遮罩之上)
; ==========================================
; 重新描绘 Pad 的精准外边框
image bounds(44, 44, 200, 200), colour(0, 0, 0, 0), outlineColour(80, 80, 80, 255), outlineThickness(1) channel("pad")

; 我们自己的 X/Y 轴推子
hslider bounds(44, 24, 200, 20), channel("centerX"), range(0, 1, 0.5, 1, 0.01), trackerColour(200, 200, 200, 255)
vslider bounds(24, 44, 20, 200), channel("centerY"), range(0, 1, 0.5, 1, 0.01), trackerColour(200, 200, 200, 255)

label bounds(44, 8, 80, 15), text("X-Axis"), fontColour(150, 150, 150, 255), align("left") channel("X-axis")
label bounds(24, 44, 80, 15), text("Y-Axis"), fontColour(150, 150, 150, 255), align("left") channel("Y-axis") rotate(1.57079, 0, 0)

; 四声道反馈矩阵
vmeter bounds(288, 0, 30, 45), channel("m1"), rotate(3.14159, 15, 48), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
vmeter bounds(324, 0, 30, 45), channel("m2"), rotate(3.14159, 15, 48), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
vmeter bounds(288, 102, 30, 45), channel("m3"), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
vmeter bounds(324, 102, 30, 45), channel("m4"), meterColour:0(20, 30, 20, 255), meterColour:1(255, 32, 55, 255), meterColour:2(255, 255, 255, 255), overlayColour(0, 0, 0, 255)
label bounds(250, 28, 130, 15), text("Quad Out"), fontColour(150, 150, 150, 255),  channel("quadout")

; ==========================================
; 【核心修复】：gentable 窗函数可视化
; ==========================================

gentable bounds(250, 166, 130, 78),channel("windowTable") , tableNumber(1.0), colour(255, 255, 255, 255), outlineColour(255, 0, 80, 255), ampRange(0.0, 1.0, -1.0, 0.0100), , tableGridColour(255, 255, 255, 175) tableColour:0(255, 32, 55, 205)
label bounds(20, 432, 110, 18), text("window"), fontColour(150, 150, 150, 255) channel("Wind") align("left")




; ------------------------------------------
; 麦克迪原始颗粒控制参数
; ------------------------------------------
label bounds(20, 256, 181, 15), text("1.  GAUSS FIELD"), fontColour(205, 32, 55, 255), align("left") channel("gaussfield")
image bounds(20, 273, 362, 1), colour(50, 50, 50, 255)

hslider bounds(20, 278, 245, 20), channel("Dens"), range(1, 500, 100, 1, 1), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 452, 240, 20), channel("GSize"), range(0.005, 1, 0.1, 0.5, 0.001), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 384, 240, 20), channel("DlyMax"), range(0.01, 5, 1, 0.5, 0.001), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 410, 240, 20), channel("reverse"), range(0, 1, 0.5, 1, 0.001), valueTextBox(1), trackerColour(200, 200, 200, 255)
label bounds(270, 280, 110, 16), text("Density") channel("density")align("right")
label bounds(20, 454, 110, 16), text("Grain Size")align("left")
label bounds(20, 386, 110, 16), text("Max Delay")align("left")
label bounds(20, 412, 110, 16), text("Reverse Prob")align("left") channel("reverse")


combobox bounds(302, 432, 77, 18), channel("window"), value(4), text("Half Sine", "rectangle", "Hamming", "Gaussian", "traingle")

; ------------------------------------------
; 空间滤波与主输出
; ------------------------------------------
label bounds(20, 360, 246, 15), , fontColour(205, 32, 55, 255), align("left") channel("delaygrain")align("left") text("2.Delay GRAIN")
image bounds(20, 380, 360, 1), colour(50, 50, 50, 255) channel("image98")

hslider bounds(20, 302, 248, 20), channel("radius"), range(0.01, 0.5, 0.25, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)

; 滤波范围控制 - 数字输入框
nslider bounds(44, 324, 75, 22) channel("rangeMin") range(20, 20000, 20000, 0.5, 1) 
nslider bounds(158, 324, 75, 22) channel("rangeMax") range(20, 20000, 100, 0.5, 1)

label bounds(270, 304, 110, 16), text("Field Radius")align("right") channel("fieldradius")
label bounds(260, 328, 120, 16), text("Cutoff Range:Hz")align("left") channel("cutoff")

hslider bounds(20, 512, 240, 20), channel("step"), range(0.001, 0.5, 0.5, 1, 0.001), , textColour(150, 150, 150, 255), trackerColour(200, 200, 200, 255) valueTextBox(1)
label bounds(275, 514, 108, 16), text("Dry Step Size") channel("drystep") align("right")

hslider bounds(140, 564, 240, 16), channel("mix"), range(0, 1, 0.5, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 586, 240, 20), channel("level"), range(0, 4, 1, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)
label bounds(20, 560, 110, 16), text("Dry/Wet Mix") channel("mix")align("left")
label bounds(20, 588, 110, 16), text("Master Output") channel("out")align("left")

label bounds(10, 636, 400, 16), text("WILDTRACE SERIES"), align("right"), fontColour(255, 32, 55, 205) channel("label112")

image bounds(20, 474, 360, 1), colour(50, 50, 50, 255) channel("image99")


label bounds(20, 484, 183, 16) channel("label10056") text("3.BROWNIAN PLANKTON") align("left") colour(202, 28, 28, 0) fontColour(188, 29, 29, 255)
label bounds(20, 538, 172, 16) channel("label10057") text("4.MASTER SETTING") align("left") colour(192, 17, 17, 0) fontColour(192, 21, 21, 255)
image bounds(20, 558, 364, 1), colour(50, 50, 50, 255) channel("image999")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -m0
</CsOptions>

<CsInstruments>
ksmps = 64
nchnls = 4
0dbfs = 1

; =========================================================
; 🚨 核心逻辑：定义显示缓冲区 (Table 1)
; =========================================================
giDisplay ftgen 1, 0, 1024, 10, 1 

; 定义源窗函数 (101-105)
giw101 ftgen 101, 0, 1024, 9, 0.5, 1, 0 
giw102 ftgen 102, 0, 1024, 20,8,1

giw104 ftgen 103, 0, 1024, 20, 1, 1
giw105 ftgen 104, 0, 1024, 20, 6, 1
giw103 ftgen 105, 0, 1024, 7, 0, 512, 1, 512, 0 
giwindows ftgen 100, 0, 8, -2, 101, 102, 103, 104, 105

giBufL ftgen 0, 0, 1048576, -2, 0 
giBufR ftgen 0, 0, 1048576, -2, 0 

gaGMixFL, gaGMixFR, gaGMixRL, gaGMixRR init 0
gaDryL, gaDryR init 0

; ---------------------------------------------------------
; [UDO] 空间摆位渲染器 (aaii)
; ---------------------------------------------------------
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

; =========================================================
; INSTR 1: 母体调度与 UI 场域绘画
; =========================================================
instr 1 
    kDens    chnget "Dens"
    kGSize   chnget "GSize"
    kDlyMax  chnget "DlyMax"
    kreverse chnget "reverse"
    kwindow chnget "window"
    
    kCenterX chnget "centerX"
    kCenterY chnget "centerY"
    kRadius  chnget "radius"

    kRanMin chnget "rangeMin"
    kRanMax chnget "rangeMax"



if changed(kwindow) == 1 || timeinstk() == 1 then
        kSourceNum table kwindow - 1, 100
        event "i", "UpdateUI", 0, 0.01, kSourceNum
    endif
     

        
          
    ; --- 捕获音频 ---
    aL, aR inch 1, 2
    gaDryL = aL
    gaDryR = aR
     
;i(kCenterX     
     
     
     
    ilen = ftlen(giBufL)
    aptr phasor sr/ilen
    aWriteIdx = aptr * ilen
    tablew aL, aWriteIdx, giBufL
    tablew aR, aWriteIdx, giBufR
    
    kptr downsamp aWriteIdx

    ; --- UI 场域热力雷达绘制 (30fps) ---
    kUIMetro metro 30
    if kUIMetro == 1 then
        kPadX = 44
        kPadY = 44
        kPadW = 200
        
        kCX_px = kPadX + (kCenterX * kPadW)
        kCY_px = kPadY + ((1 - kCenterY) * kPadW)
        kR_px = kRadius * kPadW
        
        kScales[] fillarray 1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1
        S_chans[] fillarray "circle100", "circle90", "circle80", "circle70", "circle60", "circle50", "circle40", "circle30", "circle20", "circle10"
        
        kIndex = 0
        while kIndex < 10 do
            kNormDist = kScales[kIndex]
            kCurR = kR_px * kNormDist
            kBoundX = kCX_px - kCurR
            kBoundY = kCY_px - kCurR
            kBoundW = kCurR * 2
            
            kGauss = exp(-(kNormDist * kNormDist * 5))
            kCutoff = kRanMin * ((kRanMax / kRanMin) ^ kGauss)
            kLogRatio = log10(kCutoff / 20) / log10(20000 / 20)
            kRGB = limit(kLogRatio * 255, 1, 255)
            
            S_col sprintfk "colour(%d, %d, %d, 255)", int(kRGB), int(kRGB), int(kRGB)
            cabbageSet 1, S_chans[kIndex], "bounds", kBoundX, kBoundY, kBoundW, kBoundW
            cabbageSet 1, S_chans[kIndex], S_col
            kIndex += 1
        od
    endif

    ; --- 实例化调度 ---
    ktrig metro kDens
    kMinDly = 0
    kMaxDly = kDlyMax + 0.001
    ioffset = 1/sr
    
    if ktrig == 1 then
        kDly random 0, 1
        kDly = kDly * kMaxDly
        schedkwhen ktrig, 0, 0, 2, kDly+0.0001, kGSize, kptr, kreverse, kDly, kMinDly+ioffset, kMaxDly+0.0001, kwindow, kCenterX, kCenterY, kRadius, kRanMin, kRanMax
    endif
endin



; 🚨 核心刷新工具：专门处理 UI 渲染同步
instr UpdateUI
    iSource = p4
    ; 1. 将源表数据物理复制到显示表 (Table 1)
    tablecopy 1, iSource 
    ; 2. 给 UI 控件发一个“重绘”指令
    cabbageSet "windowTable", "tableNumber", 1
endin
; =========================================================
; INSTR 2: McCurdy 颗粒对象 + Wildtrace 空间滤波
; =========================================================
instr 2
    iGStart = p4
    ireverse = (rnd(1) > p5 ? 1 : -1)
    idly = p6
    iMinDly = p7
    iMaxDly = p8
    iwindow table p9 - 1, 100
    
    iCX = p10
    iCY = p11
    iRadius = p12
    iRanMin = p13
    iRanMax = p14
    
    ; 物理位置分布
    iR = iRadius * sqrt(rnd(1))
    iTheta = rnd(6.2831853)
    iPosX limit (iCX + iR * cos(iTheta)), 0.001, 0.999
    iPosY limit (iCY + iR * sin(iTheta)), 0.001, 0.999
    
    ; 滤波映射
    iDist = sqrt((iPosX - iCX)^2 + (iPosY - iCY)^2)
    iNormDist = limit(iDist / (iRadius + 0.0001), 0, 1)
    
    ; 指数级音频 DSP 滤波计算
    iGauss = exp(-(iNormDist * iNormDist * 5))
    iCutoff = iRanMin * ((iRanMax / iRanMin) ^ iGauss)

    ; 音频捕获
    iStrtOS = 0
    aline line iGStart - iStrtOS, p3, iGStart - iStrtOS + (p3 * sr * ireverse)
    aenv oscili 1, 1/p3, iwindow
    
    aL tablei aline, giBufL, 0, 0, 1
    aR tablei aline, giBufR, 0, 0, 1
    
    aGrainL = aL * aenv
    aGrainR = aR * aenv

    ; 高斯滤波
    aGrainL butterlp aGrainL, iCutoff
    aGrainR butterlp aGrainR, iCutoff

    kPosX =k(iPosX)
    kPosY =k(iPosY)
    aPosX interp kPosX
    aPosY interp kPosY    
    ; 声道路由
    aFL, aFR, aRL, aRR QuadRender aGrainL, aGrainR, aPosX, aPosY
    
    gaGMixFL = gaGMixFL + aFL
    gaGMixFR = gaGMixFR + aFR
    gaGMixRL = gaGMixRL + aRL
    gaGMixRR = gaGMixRR + aRR
endin

; =========================================================
; INSTR 3: 输出终端
; =========================================================
instr 3
    kCenterX chnget "centerX"
    kCenterY chnget "centerY"
    kRate    chnget "Dens"   
    kStepBase   cabbageGetValue "step"    
    kRadius  chnget "radius"  
    kRanMin chnget "rangeMin"
    kRanMax chnget "rangeMax"      
    kmix chnget "mix"
    klevel chnget "level"


 
    kX init 0.5
    kY init 0.5
    kTrig metro kRate
    ; --- 2. 高斯布朗运动算法 ---
    if kTrig == 1 then
        kAng random 0, 6.2831853
        kStep gauss kStepBase   
        kNextX = kX + cos(kAng) * kStep
        kNextY = kY + sin(kAng) * kStep
        kNextX = kNextX + (kCenterX - kNextX) * 0.15
        kNextY = kNextY + (kCenterY - kNextY) * 0.15
        kX limit kNextX, 0, 1
        kY limit kNextY, 0, 1
    endif

    kX_disp portk kX, 0.05
    kY_disp portk kY, 0.05
    
    aCenterX interp kX_disp
    aCenterY interp kY_disp    
    ; --- 3. 距离与滤波器截止频率映射 ---
    kDist = sqrt((kX_disp - kCenterX)^2 + (kY_disp - kCenterY)^2)
    kNormDist limit (kDist / kRadius), 0, 1

    kGaussFilter exp -(kNormDist * kNormDist * 5)
    kCutoff = kRanMin + ((kRanMax - kRanMin) * kGaussFilter)
    kCutoff_sm portk kCutoff, 0.05    
    
     gadry =gaDryL  + gaDryR 
     
     aFiltered butterlp gadry, kCutoff_sm 
                
    aFLdry, aFRdry, aRLdry, aRRdry QuadRender aFiltered, aFiltered, aCenterX, aCenterY

    
    aOutFL = (aFLdry * (1-kmix) + gaGMixFL * kmix) * klevel
    aOutFR = (aFRdry * (1-kmix) + gaGMixFR * kmix) * klevel
    aOutRL = (aRLdry * (1-kmix) + gaGMixRL * kmix) * klevel
    aOutRR = (aRRdry * (1-kmix) + gaGMixRR * kmix) * klevel

    outq aOutFL, aOutFR, aOutRL, aOutRR

    kUIMetro metro 30 
    cabbageSetValue "m1", portk(max_k(abs(aOutFL), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "m2", portk(max_k(abs(aOutFR), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "m3", portk(max_k(abs(aOutRL), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "m4", portk(max_k(abs(aOutRR), kUIMetro, 1), 0.05), kUIMetro

    clear gaGMixFL, gaGMixFR, gaGMixRL, gaGMixRR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 3 0 -1
</CsScore>
</CsoundSynthesizer>