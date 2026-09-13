; macOS Quarantine Removal | macOS 签名解除指令: sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Beta-levy.vst3

<Cabbage>
form caption("Beta-Lévy-Chase") size(380, 402), guiMode("queue"), pluginId("BTLV") colour(0, 0, 0, 255) typeface("Ithaca-LVB75.ttf")

image bounds(-1, -1, 381, 403) channel("back") file("levy_back.png") outlineColour(255, 255, 255, 0)

; --- 1. Strict Square Custom Radar Grid | 严格正方形自制雷达网格 ---
image bounds(100, 42, 180, 180) colour(0, 40, 15, 255) outlineThickness(7) channel("image7") corners(7) outlineColour(0, 0, 0, 100)
image bounds(190, 42, 1, 180) colour(0, 0, 0, 100) channel("image43")
image bounds(100, 132, 180, 1) colour(0, 0, 0, 100) channel("image44")

; Dynamic Visual Cursor Ball | 动态自制游标小球
image bounds(152, 160, 8, 8)   channel("visualBall") colour(255, 17, 62, 150) outlineColour(255, 17, 62, 255)outlineThickness(3)

; --- 2. 4-Channel Visual Feedback (Surround Layout) | 四声道视觉反馈 (环绕四周) ---
vmeter bounds(108, 34, 27, 36), channel("m1"), text("FL"), outlineColour(0, 0, 0, 255), overlayColour(0, 40, 40, 255), rotate(2.35, 0, 0)    value(0.0050069) meterColour:0(255, 255, 255, 255) meterColour:1(255, 17, 62, 255) meterColour:2(255, 255, 255, 55)
vmeter bounds(290, 52, 27, 36), channel("m2"), text("FR"), outlineColour(0, 0, 0, 255), overlayColour(0, 40, 40, 255), rotate(3.9269, 0, 0)    value(0.00776347) meterColour:0(255, 255, 255, 255) meterColour:1(255, 17, 62, 255) meterColour:2(255, 255, 255, 55)
vmeter bounds(90, 212, 27, 36), channel("m3"), text("RL"), outlineColour(0, 0, 0, 255), overlayColour(0, 40, 40, 255), rotate(0.7853, 0, 0)    value(0.00163356) meterColour:0(255, 255, 255, 255) meterColour:1(255, 17, 62, 255) meterColour:2(255, 255, 255, 55)
vmeter bounds(272, 232, 27, 36), channel("m4"), text("RR"), outlineColour(0, 0, 0, 255), overlayColour(0, 40, 40, 255), rotate(5.4977, 0, 0)    value(0.00253067) meterColour:0(255, 255, 255, 255) meterColour:1(255, 17, 62, 255) meterColour:2(255, 255, 255, 55)

; --- 3. Logic Group 1: Lévy Step Matrix | 逻辑分组一：莱维步履矩阵 ---
groupbox bounds(0, 281, 190, 100) channel("box_levy") text("LÉVY STEPS") fontColour(255, 17, 62, 205) outlineColour(255, 17, 62, 100) colour(22, 87, 22, 100) 
{
rslider bounds(0, 26, 65, 65), channel("rate"), range(0.5, 20, 4, 1, 0.01), text("Rate:Hz"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255)markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(66, 26, 65, 65), channel("alpha"), range(0.3, 2, 1.1, 1, 0.01), text("Alpha"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255)markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(130, 26, 65, 65), channel("scale"), range(0.05, 1, 0.4, 1, 0.001), text("Scale"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200)colour(0, 40, 20, 255)markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
}

; --- 4. Logic Group 2: Random Value Suppression System | 逻辑分组二：随机值抑制系统 ---
groupbox bounds(190, 281, 190, 100) channel("box_suppress") text("SUPPRESSION") fontColour(255, 17, 62, 205) outlineColour(255, 17, 62, 100) colour(22, 87, 22, 100)
{
rslider bounds(0, 26, 65, 65), channel("damp"), range(0, 1, 0.4, 1, 0.01), text("Damp"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(66, 26, 65, 65), channel("chaos"), range(0, 0.08, 0.05, 1, 0.001), text("Chaos"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(130, 26, 65, 65), channel("inertia"), range(0.001, 0.4, 0.01, 1, 0.001), text("Inertia"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
}

; --- 5. Bottom Control Decoration Bar | 底部控制装饰栏 ---
image bounds(215, 380, 165, 21) colour(255, 17, 62, 255) channel("image30") corners(10)
image bounds(223, 385, 146, 14) channel("wildserial") file("levy_wild.png")

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
; [UDO: Core Surround Render Engine | UDO 核心环绕声渲染引擎]
; =========================================================
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
    ; --- 1. Read UI Parameters | 获取 UI 参数 ---
    kRate   cabbageGetValue "rate"
    kAlpha  cabbageGetValue "alpha"
    kScale  cabbageGetValue "scale"
    kDamp   cabbageGetValue "damp"
    kChaos  cabbageGetValue "chaos"
    kInert  cabbageGetValue "inertia"

    ; --- 2. Core Lévy Flight Matrix Calculation (Event-Driven) | 莱维飞行核心矩阵计算 (事件驱动型) ---
    kX_acc init 0.5
    kY_acc init 0.5

    ; Discrete Clock Trigger | 离散时钟触发器
    kStepTrig metro kRate

    if kStepTrig == 1 then
        ; [First Random Set]: Determine the vector angle of burst flights (0 to 2*PI) | [第一套随机]：决定突发飞行的矢量角度 (0 到 2*PI)
        kRandAng random 0, 6.283185307
        
        ; [Second Random Set]: Dual random variables to construct inverse transform power function distribution | [第二套随机]：双重随机变量用于构筑逆变换幂函数分布
        kRnd1 random 0.001, 1.0
        kRnd2 random 0.001, 1.0
        
        ; Classic Lévy Long-Tail Formula: Generating long-tail burst large steps via a steep power function | 经典莱维长尾算式：通过极其陡峭的幂函数产生长尾突变大跨步
        kTail pow kRnd2, (-1.0 / kAlpha)
        
        ; [Core Fix 1: Dynamic Step Suppression System Based on Current Spatial Position | 修复核心一：基于当前空间位置的动态步长抑制系统]
        ; Calculate Euclidean distance from the current point to the radar center (0.5, 0.5) (Max is approx. 0.707 diagonally) | 计算当前点距离雷达中心点 (0.5, 0.5) 的欧氏距离（最大为对角线约 0.707）
        kDistFromCenter = sqrt((kX_acc - 0.5)^2 + (kY_acc - 0.5)^2)
        
        ; Damp as suppression weight: The closer the ball is to the edge, the more the scale of large jumps is suppressed. | Damp 作为抑制权重：球离边缘越近，大跳跃的尺度就被压制得越小。
        ; This replaces the previous hard coordinate pulling, applying probability suppression at the "source" to ensure the ball can freely explore small steps at the edges. | 这替代了之前的生拽坐标，转而在“产生源头”进行概率压制，确保小球能在边缘自由探索小步。
        kSuppressedScale = kScale * (1.0 - limit(kDistFromCenter * kDamp * 1.414, 0, 0.95))
        
        ; Combine two sets of random logic with power function to generate the final step size | 两套随机逻辑结合幂函数产生最终步长
        kStepRaw = kRnd1 * kTail * kSuppressedScale * 0.1
        kStep limit kStepRaw, 0, 0.95
        
        ; Superimpose polar vectors to the accumulator | 极坐标向量叠加至累加器
        kX_acc = kX_acc + (cos(kRandAng) * kStep)
        kY_acc = kY_acc + (sin(kRandAng) * kStep)
        
        ; [Core Fix 2: Boundary Mirror Collision Rebound | 修复核心二：边界镜像碰撞折返]
        ; Completely eliminate high-frequency recentering per frame! Rebound upon hitting the wall, perfectly maintaining the traversal depth of Lévy space. | 彻底干掉每帧高频回中！撞墙就反弹，完美维持莱维空间遍历深度。
        if (kX_acc < 0) then
            kX_acc = -kX_acc
        elseif (kX_acc > 1) then
            kX_acc = 2.0 - kX_acc
        endif

        if (kY_acc < 0) then
            kY_acc = -kY_acc
        elseif (kY_acc > 1) then
            kY_acc = 2.0 - kY_acc
        endif
    endif

    ; Superimpose high-frequency underlying detailed chaos tremor (Chaos Noise) | 叠加高频底层细碎混沌微颤 (Chaos Noise)
    kChsX random -kChaos, kChaos
    kChsY random -kChaos, kChaos

    kX_final = limit(kX_acc + kChsX, 0, 1)
    kY_final = limit(kY_acc + kChsY, 0, 1)

    ; Audio-rate smooth interpolation (Inertia takes over the flight overshoot gliding sensation between jump points) | 音频级平滑插值（Inertia 接管跳跃点之间的飞行过冲滑行感）
    aX interp portk(kX_final, kInert)
    aY interp portk(kY_final, kInert)

    ; --- 3. Audio Capture & Surround Rendering | 音频捕获与环绕渲染 ---
    aInL, aInR inch 1, 2
    aFL, aFR, aRL, aRR QuadRender aInL, aInR, aX, aY

    outq aFL, aFR, aRL, aRR
    
    ; --- 4. Unified UI Visual Refresh Mechanism (30Hz) | 统一 UI 视觉刷新机制 (30Hz) ---

    kX downsamp aX
    kY downsamp aY
    kBallX = 100 + (kX * 180) - 4
    kBallY = 42 + ((1 - kY) * 180) - 4
    
    kUIMetro metro 30
    S_Bounds sprintfk "bounds(%d, %d, 8, 8)", kBallX, kBallY
    cabbageSet kUIMetro, "visualBall", S_Bounds
    
    ; 4-Channel Level Capture | 四声道电平捕捉
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