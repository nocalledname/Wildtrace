;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-SwarmGrain.vst3

<Cabbage> bounds(0, 0, 0, 0)
form caption("Depth-SwarmGrain") size(410, 740), guiMode("queue"), pluginId("DPSG"), colour(15, 15, 15, 255) 

; 【图层 1】全局底漆 | layer 1: global background
image bounds(0, 0, 410, 740) channel("bg") colour(10, 10, 10, 255)

; 【图层 2】虚拟 Pad 底座（暗色观察窗） | layer 2: virtual pad base
image bounds(44, 44, 200, 200), colour(0, 0, 0, 255)

; 【图层 3】10 层热力场同心圆 | layer 3: 10 heat-field rings
image bounds(0,0, 10,10), channel("circle100"), shape("ellipse"), colour(255,255,255,255), outlineColour(25,25,25,255), outlineThickness(1)
image bounds(0,0, 10,10), channel("circle90"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle80"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle70"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle60"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle50"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle40"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle30"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
image bounds(0,0, 10,10), channel("circle20"),  shape("ellipse"), colour(255,255,255,255), outlineColour(0,0,0,0)
; 准星整合在 10% 最小圆描边上 | crosshair merged into the 10% ring outline
image bounds(0,0, 10,10), channel("circle10"),  shape("ellipse"), colour(255,255,255,255), outlineColour(255, 32, 55, 255), outlineThickness(1)

; 【图层 4】物理遮罩涂层 | layer 4: clipping masks
; 左遮罩 | left mask (X: 0~44)
image bounds(0, 0, 44, 740), colour(10, 10, 10, 255)
; 右遮罩 | right mask (X: 244~410)
image bounds(244, 0, 166, 740), colour(10, 10, 10, 255)
; 上遮罩 | top mask (Y: 0~44)
image bounds(44, 0, 200, 44), colour(10, 10, 10, 255)
; 下遮罩 | bottom mask (Y: 244~620)
image bounds(44, 244, 200, 496), colour(10, 10, 10, 255) channel("image39")

; 【图层 5】顶层 UI 框架与控制器 | layer 5: top UI frame & controllers
; 重新描绘 Pad 的外边框 | redraw the pad's outer border
image bounds(44, 44, 200, 200), colour(0, 0, 0, 0), outlineColour(80, 80, 80, 255), outlineThickness(1) channel("pad")

; X/Y 轴推子 | X/Y faders
hslider bounds(44, 24, 200, 20), channel("centerX"), range(0, 1, 0.5, 1, 0.01), trackerColour(200, 200, 200, 255)
vslider bounds(24, 44, 20, 200), channel("centerY"), range(0, 1, 0.5, 1, 0.01), trackerColour(200, 200, 200, 255)

label bounds(44, 8, 80, 15), text("X-Axis"), fontColour(150, 150, 150, 255), align("left") channel("X-axis")
label bounds(24, 44, 80, 15), text("Y-Axis"), fontColour(150, 150, 150, 255), align("left") channel("Y-axis") rotate(1.57079, 0, 0)

; 双声道电平表 | stereo meters
vmeter bounds(272, 60, 15, 85), channel("outL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), value(0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)
vmeter bounds(344, 60, 15, 85), channel("outR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)

label bounds(250, 28, 130, 15), text("Stero Out"), fontColour(150, 150, 150, 255),  channel("Main_Out")

; 【核心修复】gentable 窗函数可视化 | gentable window visualization
gentable bounds(250, 166, 130, 78) , channel("windowTable"), tableNumber(1.0), colour(255, 255, 255, 255), outlineColour(255, 0, 80, 255), ampRange(0.0, 1.0, -1.0), tableGridColour(255, 255, 255, 175) tableColour:0(255, 32, 55, 205)

label bounds(20, 434, 110, 16), text("window"), fontColour(150, 150, 150, 255) channel("Windo") align("left")

; ------------------------------------------
; 麦克迪颗粒控制参数 | McCurdy grain controls
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
; 空间滤波与主输出 | spatial filtering & master out
; ------------------------------------------
label bounds(20, 360, 246, 15), , fontColour(205, 32, 55, 255), align("left") channel("delaygrain")align("left") text("2.Delay GRAIN")
image bounds(20, 380, 360, 1), colour(50, 50, 50, 255) channel("image98")

hslider bounds(20, 302, 248, 20), channel("radius"), range(0.01, 0.5, 0.25, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)

; 滤波范围数字输入框 | filter range numeric boxes
nslider bounds(44, 324, 75, 22) channel("rangeMin") range(20, 20000, 20000, 0.5, 1) 
nslider bounds(158, 324, 75, 22) channel("rangeMax") range(20, 20000, 100, 0.5, 1)

label bounds(270, 304, 110, 15), text("Field Radius")align("right") channel("fieldradius")
label bounds(234, 328, 148, 15), text("Cutoff Range:Hz")align("right") channel("Damping")

hslider bounds(20, 512, 240, 20), channel("step"), range(0.001, 0.5, 0.5, 1, 0.001), , textColour(150, 150, 150, 255), trackerColour(200, 200, 200, 255) valueTextBox(1)
label bounds(275, 514, 108, 16), text("Dry Step Size") channel("drystep") align("right")

hslider bounds(20, 680, 225, 16), channel("drywet"), range(0, 1, 0.5, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)
hslider bounds(140, 702, 240, 16), channel("level"), range(0, 4, 1, 1, 0.01), valueTextBox(1), trackerColour(200, 200, 200, 255)
label bounds(268, 680, 110, 16), text("Dry/Wet Mix") channel("mix")align("left")
label bounds(20, 702, 110, 16), text("Master Output") channel("out")align("left")

label bounds(6, 724, 400, 16), text("WILDTRACE SERIES"), align("right"), fontColour(255, 32, 55, 205) channel("label112")

image bounds(20, 504, 360, 2), colour(50, 50, 50, 255) channel("image99")

label bounds(20, 484, 183, 16) channel("label10056") text("3.BROWNIAN PLANKTON") align("left") colour(202, 28, 28, 0) fontColour(188, 29, 29, 255)
label bounds(20, 652, 172, 16) channel("label10057") text("5.MASTER SETTING") align("left") colour(192, 17, 17, 0) fontColour(192, 21, 21, 255)
image bounds(20, 557, 364, 2), colour(50, 50, 50, 255) channel("image999")

; 4. 混响发送量范围条 | wet send range (min/max)
label bounds(20, 540, 110, 16), text("4.ROOM"), fontColour(188, 29, 29, 255) channel("room") align("left")

label bounds(104, 588, 197, 13) text("Wet Send Range (Min / Max)") fontColour(255, 255, 255, 120) channel("labelWet") 
hrange bounds(112, 606, 180, 28) channel("minWet", "maxWet") range(0, 1, 0.1:0.6, 1, 0.001) trackerColour(188, 29, 29, 255) outlineColour(0, 0, 0, 150)

; 5. 声场声学控制参数（Room Size 与 Damping） | room size & damping knobs
rslider bounds(20, 564, 85, 85) channel("roomSize") range(10, 100, 50, 1, 0.1) text("Room Size") trackerColour(188, 29, 29, 255) outlineColour(30, 41, 59, 255) fontColour(255, 255, 255, 150) textColour(255, 255, 255, 200)
rslider bounds(300, 566, 85, 85) channel("cutoff") range(1000, 16000, 6000, 0.5, 1) text("Damping(Hz)") trackerColour(188, 29, 29, 255) outlineColour(30, 41, 59, 255) fontColour(255, 255, 255, 150) textColour(255, 255, 255, 200)

image bounds(20, 671, 360, 2), colour(50, 50, 50, 255) channel("image101")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -m0
</CsOptions>

<CsInstruments>
ksmps = 64
nchnls = 2
0dbfs = 1

; 🚨 核心逻辑：定义显示缓冲区 (Table 1) | display buffer (table 1)
giDisplay ftgen 1, 0, 1024, 10, 1 

; 定义源窗函数 | source window functions (101-105)
giw101 ftgen 101, 0, 1024, 9, 0.5, 1, 0 
giw102 ftgen 102, 0, 1024, 20,8,1
giw104 ftgen 103, 0, 1024, 20, 1, 1
giw105 ftgen 104, 0, 1024, 20, 6, 1
giw103 ftgen 105, 0, 1024, 20, 3, 1
giwindows ftgen 100, 0, 8, -2, 101, 102, 103, 104, 105

giBufL ftgen 0, 0, 1048576, -2, 0 
giBufR ftgen 0, 0, 1048576, -2, 0 

; 【全局变量清理】 | global buses
gaGrainL, gaGrainR init 0       ; 粒子干声总线 | grain dry bus
gaRevSendL, gaRevSendR init 0   ; 粒子混响发送总线 | grain reverb send bus
gaDryL, gaDryR init 0           ; 输入直通捕获 | direct input capture

; [UDO] 空间摆位渲染器 | spatial renderer opcode
opcode DepthStereoRender, aaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin
    
    aX limit aX, 0.001, 0.999
    aY limit aY, 0.001, 0.999
    
    aDepth = aY
    aRoomSize interp kRoomSize
    
    aL_pan = cos(aX * 1.570796)
    aR_pan = sin(aX * 1.570796)
    aMono = (aInL + aInR) * 0.5
    
    aPanL = aMono * aL_pan
    aPanR = aMono * aR_pan
    
    aDelayTime = 0.1 + (aDepth * aRoomSize)
    aDlyL vdelay3 aPanL, aDelayTime, 150
    aDlyR vdelay3 aPanR, aDelayTime, 150
    
    aDepthInv = 1 - aDepth
    aCutoff = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)
    
    aFiltL tone aDlyL, aCutoff
    aFiltR tone aDlyR, aCutoff
    
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDepth * aDecayFactor) 
    
    aDryL = aFiltL * aDistAmp
    aDryR = aFiltR * aDistAmp
    
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDepth * (aMaxWet - aMinWet))
    
    aWetL = aFiltL * aWetSend
    aWetR = aFiltR * aWetSend
 
    aWetL = tanh(aWetL)  
    aWetR = tanh(aWetR)       
    xout aDryL, aDryR, aWetL, aWetR
endop

; INSTR 1: 母体调度与 UI 场域绘画 | INSTR 1: scheduler & UI field drawing
instr 1 
    kDens   chnget "Dens"
    kGSize  chnget "GSize"
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

    ; --- 捕获音频 | capture input ---
    aL, aR inch 1, 2
    gaDryL = aL
    gaDryR = aR
     
    ilen = ftlen(giBufL)
    aptr phasor sr/ilen
    aWriteIdx = aptr * ilen
    tablew aL, aWriteIdx, giBufL
    tablew aR, aWriteIdx, giBufR
    
    kptr downsamp aWriteIdx

    ; --- UI 热力雷达绘制 (30fps) | UI heat-field radar drawing ---
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

    ; --- 实例化调度 | spawn grains ---
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

; 🚨 核心刷新工具 | UI table refresh
instr UpdateUI
    iSource = p4
    tablecopy 1, iSource 
    cabbageSet "windowTable", "tableNumber", 1
endin

; INSTR 2: McCurdy 颗粒对象 + Wildtrace 空间滤波 | INSTR 2: McCurdy grain + spatial filter
instr 2
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    
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
    
    ; 物理位置分布 | random position in field
    iR = iRadius * sqrt(rnd(1))
    iTheta = rnd(6.2831853)
    iPosX limit (iCX + iR * cos(iTheta)), 0.001, 0.999
    iPosY limit (iCY + iR * sin(iTheta)), 0.001, 0.999
    
    ; 滤波映射 | filter mapping
    iDist = sqrt((iPosX - iCX)^2 + (iPosY - iCY)^2)
    iNormDist = limit(iDist / (iRadius + 0.0001), 0, 1)
    
    iGauss = exp(-(iNormDist * iNormDist * 5))
    iCutoff = iRanMin * ((iRanMax / iRanMin) ^ iGauss)

    ; 强制安全读取偏移（延迟+颗粒长度） | safe read offset (delay + grain length)
    iStrtOS = (idly + p3) * sr
    
    aline line iGStart - iStrtOS, p3, iGStart - iStrtOS + (p3 * sr * ireverse)
    aenv oscili 1, 1/p3, iwindow
    
    ; 1. 提取原始采样 | read original samples
    aL tablei aline, giBufL, 0, 0, 1
    aR tablei aline, giBufR, 0, 0, 1

    ; 2. 原始高斯滤波 | gaussian filter
    aFiltL butterlp aL, iCutoff
    aFiltR butterlp aR, iCutoff   

    ; 【注意】此时不乘 aenv！保留未修剪信号送入空间渲染 | note: do NOT apply aenv here

    ; 3. 送入空间摆位（延迟+距离衰减） | spatial placement (delay + attenuation)
    kPosX = k(iPosX)
    kPosY = k(iPosY)
    aX interp kPosX
    aY interp kPosY    
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aFiltL, aFiltR, aX, aY, kMinWet, kMaxWet, kRoomSize
    
    ; 4. Wet 信号二次高切 | second low-pass on wet
    aSafeWetL tone aWetL, 4000
    aSafeWetR tone aWetR, 4000

    ; 5. Drive 与饱和限幅（混响更肥且防爆） | drive & saturation
    kDrive = 1.2
    aSafeWetL = tanh(aSafeWetL * kDrive)
    aSafeWetR = tanh(aSafeWetR * kDrive)

    ; =====================================================
    ; 🚨 6. 终极大门：所有处理之后最后乘包络，p3 结束瞬间平滑归零
    ; final gate: apply envelope AFTER all filters/delay/tanh
    ; =====================================================
    aFinalDryL = aDryL * aenv
    aFinalDryR = aDryR * aenv
    
    aFinalWetL = aSafeWetL * aenv
    aFinalWetR = aSafeWetR * aenv

    ; 7. 送入全局总线 | send to global buses
    gaGrainL = gaGrainL + aFinalDryL
    gaGrainR = gaGrainR + aFinalDryR

    gaRevSendL = gaRevSendL + aFinalWetL
    gaRevSendR = gaRevSendR + aFinalWetR
endin
; INSTR 3: 输出终端与全局混响 (Master Bus) | INSTR 3: output & global reverb
instr 3
    kCenterX chnget "centerX"
    kCenterY chnget "centerY"
    kRate    chnget "Dens"  
    kStepBase   cabbageGetValue "step"    
    kRadius  chnget "radius"  
    kRanMin chnget "rangeMin"
    kRanMax chnget "rangeMax"      

    ; 【致命拼写修复】滑块叫 drywet，之前误读为 label 的 mix 导致永远为0
    ; the UI slider is "drywet" (previously misread "mix" label, always 0)
    kmix chnget "drywet"
    
    klevel chnget "level"
    
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kRevCutoff cabbageGetValue "cutoff"

    kX init 0.5
    kY init 0.5
    kTrig metro kRate
    
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
    
    kDist = sqrt((kX_disp - kCenterX)^2 + (kY_disp - kCenterY)^2)
    kNormDist limit (kDist / kRadius), 0, 1

    kGaussFilter exp -(kNormDist * kNormDist * 5)
    kCutoff = kRanMin + ((kRanMax - kRanMin) * kGaussFilter)
    kCutoff_sm portk kCutoff, 0.05    
    
    gadry = gaDryL + gaDryR 
    aFiltered butterlp gadry, kCutoff_sm 
    
    aDryL_brown, aDryR_brown, aWetL_brown, aWetR_brown DepthStereoRender aFiltered, aFiltered, aCenterX, aCenterY, kMinWet, kMaxWet, kRoomSize
    
    ; ========================================================
    ; 【核心合流机制】 | core mix logic
    ; kmix = 0：完全 Brownian 干声 | 0: pure Brownian dry
    ; kmix = 1：完全粒子集群声 | 1: pure grain swarm
    ; ========================================================
    aMasterDryL = aDryL_brown * (1-kmix) + gaGrainL * kmix
    aMasterDryR = aDryR_brown * (1-kmix) + gaGrainR * kmix

    aMasterWetL = aWetL_brown * (1-kmix) + gaRevSendL * kmix
    aMasterWetR = aWetR_brown * (1-kmix) + gaRevSendR * kmix



    kFeedback = 0.15 + ((kRoomSize - 10) / 90) * 0.77
    kFeedback_smooth portk kFeedback, 0.04
    kCutoff_smooth   portk kRevCutoff, 0.04
    
    aRevL, aRevR reverbsc aMasterWetL, aMasterWetR, kFeedback_smooth, kCutoff_smooth


    aPreOutL = (aMasterDryL + aRevL) * klevel
    aPreOutR = (aMasterDryR + aRevR) * klevel

    ; Master Bus 终极软限幅器（防爆音+模拟染色） | master bus soft limiter
    aOutL = tanh(aPreOutL)
    aOutR = tanh(aPreOutR)

    outs aOutL, aOutR
  
    kUIMetro metro 30 
    cabbageSetValue "outL", portk(max_k(abs(aOutL), kUIMetro, 1), 0.05), kUIMetro
    cabbageSetValue "outR", portk(max_k(abs(aOutR), kUIMetro, 1), 0.05), kUIMetro

    ; 🚨 每控制周期清空总线 | clear buses each control cycle
    clear gaGrainL, gaGrainR, gaRevSendL, gaRevSendR
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
i 3 0 -1
</CsScore>
</CsoundSynthesizer>