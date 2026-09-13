;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-Loom.vst3

;<Cabbage>
form caption("Depth-Loom") size(374, 500), guiMode("queue"), pluginId("DPLM") colour(15, 10, 5, 255) typeface("EricaType-mPwa.ttf")
image bounds(0, 112, 374, 374) colour(200, 100, 200, 55)  channel("imageback")  outlineColour(0, 0, 0, 255) file("loomback.png")

image bounds(0, 0, 374, 379) colour(200, 100, 200, 55)  channel("imageback")  outlineColour(0, 0, 0, 255) file("loomback.png")

; 1. 严格正方形自制雷达网格 | square radar grid
image bounds(48, 4, 276, 276) colour(200, 100, 200, 25) outlineThickness(10) channel("image7") corners(7) outlineColour(0, 0, 0, 200)
; 视觉线与小球 | visual line/ball
image bounds(53, 115, 266, 1)   channel("aline") colour(135, 100, 80, 255)
image bounds(152, 110, 50, 10)   channel("visualBall") colour(255, 17, 62, 80) outlineColour(255, 17, 62, 255) file("loom target.png")



; 双声道电平表 | stereo level meters
vmeter bounds(12, 54, 15, 150), channel("outL"), outlineColour(0, 0, 0, 255), overlayColour(34, 25, 20, 255), meterColour:0(255, 200, 100, 255) meterColour:1(130, 100, 50, 255)
vmeter bounds(347, 54, 15, 150), channel("outR"), outlineColour(0, 0, 0, 255), overlayColour(34, 25, 20, 255),  meterColour:0(255, 200, 100, 255) meterColour:1(130, 100, 50, 255)

; 逻辑分组一：编织矩阵（含 Path 旋钮） | group 1: weave matrix (+ path knob)
groupbox bounds(1, 282, 185, 97) channel("box_matrix") text("MATRIX") fontColour(255, 200, 100, 200) outlineColour(255, 170, 50, 150) colour(40, 20, 0, 100)

rslider bounds(-6, 306, 65, 65), channel("rows"), range(1, 10, 4, 1, 1), text("Rows"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)   outlineColour(0, 0, 0, 0) filmstrip("loom10.png", 10)
rslider bounds(38, 306, 65, 65), channel("cols"), range(1, 10, 4, 1, 1), text("Cols"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0) filmstrip("loom10.png", 10)
rslider bounds(84, 306, 65, 65), channel("path"), range(1, 8, 1, 1, 1), text("Path"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom8.png", 8)
rslider bounds(130, 306, 65, 65), channel("speed"), range(0.1, 10, 0.2, 0.5, 0.01), text("Speed"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)


; 逻辑分组二：穿梭质感 | group 2: shuttle
groupbox bounds(188, 282, 185, 97) channel("box_shuttle") text("SHUTTLE") fontColour(255, 200, 100, 200) outlineColour(255, 170, 50, 150) colour(40, 20, 0, 100)
rslider bounds(190, 306, 65, 65), channel("glide"), range(0.001, 0.15, 0.03, 1, 0.001), text("Glide"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)
rslider bounds(250, 306, 65, 65), channel("texture"), range(0, 1, 0.6, 1, 0.01), text("Texture"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)
rslider bounds(310, 306, 65, 65), channel("warp"), range(0, 20, 5, 1, 0.01), text("Warp:ms"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)



groupbox bounds(0, 380, 374, 98) channel("ROOMset")text("ROOM")fontColour(255, 200, 100, 200) outlineColour(255, 170, 50, 150) colour(40, 20, 0, 100)
hrange bounds(80, 434, 219, 18), channel("minWet", "maxWet"), range(0, 1, 0.1:0.3, 1, 0.001), trackerColour(255, 170, 50, 255),colour:0(255, 170, 50, 150) max(1) min(0) 
rslider bounds(4, 404, 65, 65), channel("roomSize"), range(10, 100, 50, 1, 0.1), text("Room"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)
rslider bounds(308, 404, 65, 65), channel("cutoff"), range(1000, 16000, 6000, 0.5, 1), text("Damp"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)
label bounds(70, 418, 235, 15) text("Wet Send Range (Min / Max)") fontColour(255, 200, 100, 200) channel("label18")

; 底部控制装饰栏 | bottom decorative bar
image bounds(0, 480, 375, 20) colour(255, 170, 50, 250) channel("image30") corners(10)
label bounds(6, 482, 365, 16), text("WILDTRACE SERIES"), fontColour(0, 0, 0, 255), align("right") channel("label31")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1

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
    ; --- 1. 获取 UI 参数 | read UI parameters ---
    kRows    cabbageGetValue "rows"
    kCols    cabbageGetValue "cols"
    kPath    cabbageGetValue "path"  ; 路径模式 (1-8) | path mode (1-8)
    kSpeed   cabbageGetValue "speed"
    kGlide   cabbageGetValue "glide"
    kTexture cabbageGetValue "texture"
    kWarp    cabbageGetValue "warp"

    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"


    ; --- 2. 八极蛇形扫描核心算法 | 8-way serpentine scan ---
    kTotalCells = kRows * kCols
    kPhasor phasor kSpeed
    
    ; 路径模式：1-4 水平优先，5-8 垂直优先 | paths 1-4 horizontal, 5-8 vertical
    kIsVert = (kPath >= 5) ? 1 : 0
    
    ; 动态分配逻辑行列（垂直扫描时对调） | swap rows/cols for vertical paths
    kLogicCols = (kIsVert == 1) ? kRows : kCols
    kLogicRows = (kIsVert == 1) ? kCols : kRows
    kLogicDivX = (kLogicCols > 1) ? (kLogicCols - 1) : 1
    kLogicDivY = (kLogicRows > 1) ? (kLogicRows - 1) : 1

    ; 当前格子索引 | current cell index
    kCurrentCell = limit(floor(kPhasor * kTotalCells), 0, kTotalCells - 1)
    
    ; 提取基础逻辑行与列 | base logical row & column
    kLogicRow = floor(kCurrentCell / kLogicCols)
    kLogicCol = kCurrentCell % kLogicCols

    ; 奇数行折返（S型弯折） | reverse odd rows (S-bend)
    kIsOddRow = kLogicRow % 2
    kLogicCol = (kIsOddRow == 1) ? (kLogicCols - 1 - kLogicCol) : kLogicCol

    ; 获取 0-1 基础矩阵空间 | base 0-1 matrix space
    kBaseX = kLogicCol / kLogicDivX
    kBaseY = kLogicRow / kLogicDivY

    ; 逻辑空间映射回物理 XY 轴 | map logical space to physical XY
    kRawX = (kIsVert == 1) ? kBaseY : kBaseX
    kRawY = (kIsVert == 1) ? kBaseX : kBaseY

    ; 起点镜像翻转（解析 1-8 角点） | mirror start points per path (1-8)
    kInvX = (kPath == 3 || kPath == 4 || kPath == 7 || kPath == 8) ? 1 : 0
    kInvY = (kPath == 2 || kPath == 4 || kPath == 6 || kPath == 8) ? 1 : 0

    ; 最终目标坐标 | final target coordinates
    kX_target = (kInvX == 1) ? (1 - kRawX) : kRawX
    kY_target = (kInvY == 1) ? (1 - kRawY) : kRawY

    ; --- 3. 梭子平滑与张力包络 | shuttle smoothing & tension envelope ---
    kX portk kX_target, kGlide
    kY portk kY_target, kGlide

    aX interp kX
    aY interp kY

    kLocalPhase = (kPhasor * kTotalCells) % 1
    kPulse = sin(kLocalPhase * 3.14159265) 
    
    kAmpMod = kTexture + (1 - kTexture) * kPulse
    aAmp interp kAmpMod

    ; --- 4. 针脚交织物理建模（延迟多普勒） | weave warp (delay doppler) ---
    aInL, aInR inch 1, 2
    
    kDelayMod = (kX + kY) * kWarp
    aDelayTime interp (10 + kDelayMod)

    aWarpL vdelay3 aInL, aDelayTime, 60
    aWarpR vdelay3 aInR, aDelayTime, 60

    aWarpL = aWarpL * aAmp
    aWarpR = aWarpR * aAmp

    ; --- 5. 深度渲染与视觉分发 | depth render & visual output ---
;    aFL, aFR, aRL, aRR QuadRender aWarpL, aWarpR, aX, aY
;    outq aFL, aFR, aRL, aRR
;
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aWarpL, aWarpR, aX, aY, kMinWet, kMaxWet, kRoomSize

  
    ; --- 4. 混响器 | reverb (reverbsc) ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05
    
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
    
    outs aOutL, aOutR
  
    kX downsamp aX
    kY downsamp aY
    kBallX = 30 + (kX * 265)
    kBallY =20+ ((1 - kY) * 240)
      
    ; UI 视觉刷新 | UI refresh
    kTrig metro 30 
    S_Bounds sprintfk "bounds(%d, %d, 50, 10)", kBallX, kBallY
    cabbageSet kTrig, "visualBall", S_Bounds
    S_Bounds sprintfk "bounds(53, %d, 264, 1)",kBallY+5
    cabbageSet kTrig, "aline", S_Bounds

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

