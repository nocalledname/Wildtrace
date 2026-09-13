;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Beta-Loom.vst3

<Cabbage>
form caption("Beta-Loom") size(374, 395), guiMode("queue"), pluginId("BTLM") colour(15, 10, 5, 255) typeface("EricaType-mPwa.ttf")

; --- 1. Background | 底层背景 ---
image bounds(0, 0, 374, 374) colour(200, 100, 200, 55)  channel("imageback")  outlineColour(0, 0, 0, 255) file("loomback.png")

; --- 2. Radar Grid | 严格正方形自制雷达网格 ---
image bounds(48, 4, 276, 276) colour(200, 100, 200, 25) outlineThickness(10) channel("image7") corners(7) outlineColour(0, 0, 0, 200)

; --- 3. Visual Cursor (Line & Ball) | 动态扫描线与游标目标 ---
image bounds(53, 115, 266, 1)   channel("aline") colour(135, 100, 80, 255)
image bounds(152, 110, 50, 10)   channel("visualBall") colour(255, 17, 62, 80) outlineColour(255, 17, 62, 255) file("loom target.png")

; --- 4. 4-Channel Visual Feedback | 四声道视觉电平表反馈 ---
vmeter bounds(48, 26, 27, 36), channel("m1"), text("FL"), outlineColour(255, 255, 255, 255), overlayColour(20, 10, 0, 255), rotate(2.35, 0, 0) meterColour:0(255, 255, 255, 255) meterColour:1(255, 170, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(342, 46, 27, 36), channel("m2"), text("FR"), outlineColour(255, 255, 255, 255), overlayColour(20, 10, 0, 255), rotate(3.9269, 0, 0) meterColour:0(255, 255, 255, 255) meterColour:1(255, 170, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(32, 224, 27, 36), channel("m3"), text("RL"), outlineColour(255, 255, 255, 255), overlayColour(20, 10, 0, 255), rotate(0.7853, 0, 0) meterColour:0(255, 255, 255, 255) meterColour:1(255, 170, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(322, 244, 27, 36), channel("m4"), text("RR"), outlineColour(255, 255, 255, 255), overlayColour(20, 10, 0, 255), rotate(5.4977, 0, 0) meterColour:0(255, 255, 255, 255) meterColour:1(255, 170, 50, 255) meterColour:2(255, 255, 255, 255)

; --- 5. Group 1: The Matrix | 逻辑分组一：编织矩阵 ---
groupbox bounds(1, 275, 185, 100) channel("box_matrix") text("MATRIX") fontColour(255, 200, 100, 200) outlineColour(255, 170, 50, 150) colour(40, 20, 0, 100)
rslider bounds(-6, 303, 65, 65), channel("rows"), range(1, 10, 4, 1, 1), text("Rows"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)   outlineColour(0, 0, 0, 0) filmstrip("loom10.png", 10)
rslider bounds(38, 303, 65, 65), channel("cols"), range(1, 10, 4, 1, 1), text("Cols"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0) filmstrip("loom10.png", 10)
rslider bounds(84, 303, 65, 65), channel("path"), range(1, 8, 1, 1, 1), text("Path"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom8.png", 8)
rslider bounds(130, 303, 65, 65), channel("speed"), range(0.1, 10, 0.2, 0.5, 0.01), text("Speed"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 0), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)

; --- 6. Group 2: The Shuttle | 逻辑分组二：穿梭质感 ---
groupbox bounds(189, 275, 185, 100) channel("box_shuttle") text("SHUTTLE") fontColour(255, 200, 100, 200) outlineColour(255, 170, 50, 150) colour(40, 20, 0, 100)
rslider bounds(190, 303, 65, 65), channel("glide"), range(0.001, 0.15, 0.03, 1, 0.001), text("Glide"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)
rslider bounds(250, 303, 65, 65), channel("texture"), range(0, 1, 0.6, 1, 0.01), text("Texture"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)
rslider bounds(310, 303, 65, 65), channel("warp"), range(0, 20, 5, 1, 0.01), text("Warp:ms"), fontColour(255, 170, 50, 150), trackerColour(255, 170, 50, 255), valueTextBox(1) textColour(255, 170, 50, 150)outlineColour(0, 0, 0, 0)filmstrip("loom128.png", 128)

; --- 7. Bottom Decoration | 底部控制装饰栏 ---
image bounds(0, 375, 375, 20) colour(255, 170, 50, 250) channel("image30") corners(10)
label bounds(4, 380, 365, 16), text("WILDTRACE SERIES"), fontColour(0, 0, 0, 255), align("right") channel("label31")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 4
0dbfs = 1

; =========================================================
; [UDO: Core Quad Render Engine | 核心环绕声渲染引擎]
; =========================================================
opcode QuadRender, aaaa, aaaa
    aInL, aInR, aX, aY xin
    
    aX limit aX, 0.001, 0.999
    
    ; Invert standard Y (1=Front) to math angle 0 | 将标准Y值(1=前)反转为角度0
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
    ; --- 1. Read UI Parameters | 获取 UI 参数 ---
    kRows    cabbageGetValue "rows"
    kCols    cabbageGetValue "cols"
    kPath    cabbageGetValue "path"  ; Path mode (1-8) | 路径模式
    kSpeed   cabbageGetValue "speed"
    kGlide   cabbageGetValue "glide"
    kTexture cabbageGetValue "texture"
    kWarp    cabbageGetValue "warp"

    ; --- 2. 8-Way Boustrophedon Scanning Math | 八极蛇形扫描核心算法 ---
    kTotalCells = kRows * kCols
    kPhasor phasor kSpeed
    
    ; Analyze path mode: 1-4 Horizontal, 5-8 Vertical | 分析路径模式：1-4水平优先，5-8垂直优先
    kIsVert = (kPath >= 5) ? 1 : 0
    
    ; Dynamic logic matrix mapping | 动态分配逻辑行与列
    kLogicCols = (kIsVert == 1) ? kRows : kCols
    kLogicRows = (kIsVert == 1) ? kCols : kRows
    kLogicDivX = (kLogicCols > 1) ? (kLogicCols - 1) : 1
    kLogicDivY = (kLogicRows > 1) ? (kLogicRows - 1) : 1

    ; Calculate current cell index | 计算当前所处的格子索引
    kCurrentCell = limit(floor(kPhasor * kTotalCells), 0, kTotalCells - 1)
    
    ; Extract basic logical row & col | 提取基础逻辑行与列
    kLogicRow = floor(kCurrentCell / kLogicCols)
    kLogicCol = kCurrentCell % kLogicCols

    ; Odd row reversal (S-shaped core fold) | 奇数行折返 (S型核心弯折)
    kIsOddRow = kLogicRow % 2
    kLogicCol = (kIsOddRow == 1) ? (kLogicCols - 1 - kLogicCol) : kLogicCol

    ; Map to 0-1 base matrix space | 获取 0-1 的基础矩阵空间
    kBaseX = kLogicCol / kLogicDivX
    kBaseY = kLogicRow / kLogicDivY

    ; Map logical space back to physical XY | 将逻辑空间映射回真实的物理 XY 轴
    kRawX = (kIsVert == 1) ? kBaseY : kBaseX
    kRawY = (kIsVert == 1) ? kBaseX : kBaseY

    ; Starting point mirror flip (Corners 1-8 logic) | 判定起点镜像翻转 (解析 1-8 的角点特性)
    kInvX = (kPath == 3 || kPath == 4 || kPath == 7 || kPath == 8) ? 1 : 0
    kInvY = (kPath == 2 || kPath == 4 || kPath == 6 || kPath == 8) ? 1 : 0

    ; Final target coordinate assignment | 最终目标坐标赋值
    kX_target = (kInvX == 1) ? (1 - kRawX) : kRawX
    kY_target = (kInvY == 1) ? (1 - kRawY) : kRawY

    ; --- 3. Shuttle Smoothing & Tension Envelope | 梭子平滑与张力包络计算 ---
    kX portk kX_target, kGlide
    kY portk kY_target, kGlide

    aX interp kX
    aY interp kY

    kLocalPhase = (kPhasor * kTotalCells) % 1
    kPulse = sin(kLocalPhase * 3.14159265) 
    
    kAmpMod = kTexture + (1 - kTexture) * kPulse
    aAmp interp kAmpMod

    ; --- 4. Physical Modeling of Weaving (Delay Doppler) | 针脚交织物理建模 (延迟多普勒) ---
    aInL, aInR inch 1, 2
    
    kDelayMod = (kX + kY) * kWarp
    aDelayTime interp (10 + kDelayMod)

    aWarpL vdelay3 aInL, aDelayTime, 60
    aWarpR vdelay3 aInR, aDelayTime, 60

    aWarpL = aWarpL * aAmp
    aWarpR = aWarpR * aAmp

    ; --- 5. Surround Rendering & Audio Output | 环绕渲染与音频输出 ---
    aFL, aFR, aRL, aRR QuadRender aWarpL, aWarpR, aX, aY
    outq aFL, aFR, aRL, aRR

    ; --- 6. UI Visual Dispatch | UI 视觉刷新机制 ---
    kX downsamp aX
    kY downsamp aY
    kBallX = 30 + (kX * 265)
    kBallY = 20 + ((1 - kY) * 240)
      
    kTrig metro 30 
    S_Bounds sprintfk "bounds(%d, %d, 50, 10)", kBallX, kBallY
    cabbageSet kTrig, "visualBall", S_Bounds
    S_Bounds sprintfk "bounds(53, %d, 264, 1)", kBallY + 5
    cabbageSet kTrig, "aline", S_Bounds
    
    kP1 max_k abs(aFL), kTrig, 1
    kP2 max_k abs(aFR), kTrig, 1
    kP3 max_k abs(aRL), kTrig, 1
    kP4 max_k abs(aRR), kTrig, 1

    cabbageSetValue "m1", portk(kP1, .05), kTrig
    cabbageSetValue "m2", portk(kP2, .05), kTrig
    cabbageSetValue "m3", portk(kP3, .05), kTrig
    cabbageSetValue "m4", portk(kP4, .05), kTrig
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>