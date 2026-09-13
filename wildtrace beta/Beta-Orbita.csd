; macOS Quarantine Removal | macOS 签名解除指令: sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Wildtrace-Orbita.vst3

<Cabbage>
form caption("Wildtrace-Orbita") size(320, 433), guiMode("queue"), pluginId("BTOR") colour(15, 23, 42, 255)
image bounds(0, 0, 320, 433) channel("image10011") file("background-orbita.png")

; --- 1. 4-Channel Visual Feedback (Diagonal Layout) | 四声道视觉反馈 (保持 STATIS 风格的对角线旋转布局) ---
vmeter bounds(78, 78, 30, 50), channel("m1"), text("FL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(2.35, 0, 0)    value(0.00208596) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(270, 100, 30, 50), channel("m2"), text("FR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(3.9269, 0, 0)    value(0.00121986) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(58, 256, 30, 50), channel("m3"), text("RL"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(0.7853, 0, 0)    value(0.00210493) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 255, 255, 255)
vmeter bounds(250, 272, 30, 50), channel("m4"), text("RR"), outlineColour(0, 0, 0, 255), overlayColour(0, 0, 0, 255), rotate(5.4977, 0, 0)    value(0.00121602) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255) meterColour:2(255, 255, 255, 255)

; --- 2. Core Control Area: Center Parameters | 核心控制区：参数居中 ---
; Speed Control | 速度控制
rslider bounds(86, 334, 81, 70), channel("speed"), range(0.1, 20, 0.25, 0.25, 0.001), text("Speed/Hz"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255), valueTextBox(1) ,textColour(255, 68, 50, 200) 
; Radius Control | 半径控制
rslider bounds(166, 334, 70, 70), channel("radius"), range(0, 0.5, 0.5, 1, 0.01), text("Radius"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255), valueTextBox(1) ,textColour(255, 68, 50, 200) 
; Shape Control (Circle to Ellipse) | 形状控制 (正圆 -> 椭圆)
rslider bounds(236, 334, 70, 70), channel("Shape"), range(0, 1, 0.5, 1, 0.01), text("Shape"), fontColour(255, 205, 68, 255), trackerColour(255, 205, 68, 255), valueTextBox(1) ,textColour(255, 68, 50, 200) 
; Direction Control (0/1 Binary Logic) | 方向控制 (使用绝对的 0 和 1 二进制逻辑)
button bounds(12, 354, 70, 30), channel("dir"), text("CCW", "CW"), , fontColour:0(224, 69, 69, 255), fontColour:1(12, 18, 51, 255), colour:0(12, 18, 51, 255), colour:1(224, 69, 69, 255), corners(3) 

; --- 3. Dynamic Visual Cursor Ball | 动态自制游标小球 ---
image bounds(152, 160, 10, 10) shape("circle")  channel("visualBall") colour(255, 220, 124, 255) outlineColour(255, 220, 124, 255) 

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
; [UDO: Core Quad Render Engine] | [UDO 核心渲染引擎 (完美复用)]
; =========================================================
opcode QuadRender, aaaa, aaaa
    aInL, aInR, aX, aY xin
    
    aX limit aX, 0.001, 0.999
    aY_inverted = 1-aY
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
    ; --- 1. Read UI Parameters | 获取 UI 参数 ---
    kDir    cabbageGetValue "dir"       ; 0 = CCW (Counter-Clockwise | 逆时针), 1 = CW (Clockwise | 顺时针)
    kSpeed  cabbageGetValue "speed"     ; Speed | 速度
    kRad    cabbageGetValue "radius"    ; Radius | 半径
    kInvert cabbageGetValue "Shape"     ; Shape (0 to 1) | 形状 (0 到 1)

    ; --- 2. Core Orbital Dynamics | 核心动力学计算 (星系轨道) ---
    ; Define kPhasor as the "time engine" driving the rotation | 这里定义 kPhasor！它是驱动一切旋转的"时间引擎"
    kPhasor phasor kSpeed
    
    ; 1.414 diagonal coefficient ensures the max radius reaches corners | 1.414 破壁系数，确保最大半径能触及矩形的四个角落
    kMaxRad = kRad * 1.4142             

    if kDir == 0 then
        ; [Counter-Clockwise CCW | 逆时针]
        kX_raw = 0.5 + (cos(kPhasor * 2 * $M_PI) * kMaxRad * kInvert)
        kY_raw = 0.5 + (sin(kPhasor * 2 * $M_PI) * kMaxRad * (1 - kInvert))
    else
        ; [Clockwise CW | 顺时针]
        kX_raw = 0.5 + (cos(-1 * kPhasor * 2 * $M_PI) * kMaxRad * kInvert)
        kY_raw = 0.5 + (sin(-1 * kPhasor * 2 * $M_PI) * kMaxRad * (1 - kInvert))
    endif

    ; Smooth interpolation to prevent out-of-bounds clipping | 平滑插值，防止超界导致爆音
    aX interp limit(kX_raw, 0, 1)
    aY interp limit(kY_raw, 0, 1)

    ; --- 3. Surround Rendering | 环绕渲染 ---
    aInL, aInR inch 1, 2
    aFL, aFR, aRL, aRR QuadRender aInL, aInR, aX, aY

    outq aFL, aFR, aRL, aRR

    ; --- 4. High-Frequency Visual Feedback | 视觉高频反馈 ---
    kTrig metro 60
    
    ; Level Capture | 电平捕捉
    kP1 max_k abs(aFL), kTrig, 1
    kP2 max_k abs(aFR), kTrig, 1
    kP3 max_k abs(aRL), kTrig, 1
    kP4 max_k abs(aRR), kTrig, 1

    cabbageSetValue "m1", portk(kP1, .05), kTrig
    cabbageSetValue "m2", portk(kP2, .05), kTrig
    cabbageSetValue "m3", portk(kP3, .05), kTrig
    cabbageSetValue "m4", portk(kP4, .05), kTrig
    
    ; --- 5. UI Visual Dispatch | UI 视讯刷新 ---
    ; Rounding safely for Csound bounds rendering | 完美四舍五入！绝对不报错的 Csound 写法：
    kBallX = int(65 + (kX_raw * 180) + 0.5)
    kBallY = int(80 + ((1 - kY_raw) * 180) + 0.5)
    
    kTrig metro 60
    S_Bounds sprintfk "bounds(%d, %d, 10, 10)", kBallX, kBallY
    cabbageSet kTrig, "visualBall", S_Bounds
    
endin

</CsInstruments>
<CsScore>
f 0 z
i 1 0 -1
</CsScore>
</CsoundSynthesizer>