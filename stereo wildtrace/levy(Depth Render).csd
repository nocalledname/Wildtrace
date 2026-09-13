;sudo xattr -rd com.apple.quarantine /Library/Audio/Plug-Ins/VST3/Depth-LévyChase.vst3

<Cabbage>
form caption("Depth-LévyChase") size(380, 423), guiMode("queue"), pluginId("DPLV") colour(0, 0, 0, 255) typeface("Ithaca-LVB75.ttf")

image bounds(0, 0, 381, 423) channel("back") file("levy_back.png") outlineColour(255, 255, 255, 0)
; 1. 严格正方形自制雷达网格 | square radar grid
image bounds(100, 42, 180, 180) colour(0, 40, 15, 255) outlineThickness(7) channel("image7") corners(7) outlineColour(0, 0, 0, 100)
image bounds(190, 42, 1, 180) colour(0, 0, 0, 100) channel("image43")
image bounds(100, 132, 180, 1) colour(0, 0, 0, 100) channel("image44")
; 游标小球 | visual ball
image bounds(152, 160, 8, 8)   channel("visualBall") colour(255, 17, 62, 150) outlineColour(255, 17, 62, 255)outlineThickness(3)
; 双声道电平表 | stereo level meters
vmeter bounds(42, 56, 15, 150), channel("outL"), outlineColour(0, 0, 0, 255), overlayColour(0, 40, 15, 255), value(0.000596503) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)
vmeter bounds(318, 56, 15, 150), channel("outR"), outlineColour(0, 0, 0, 255), overlayColour(0, 40, 15, 255), value(0) meterColour:0(30, 10, 10, 255) meterColour:1(255, 68, 50, 255)

; 逻辑分组一：莱维步履矩阵 | group 1: levy steps matrix
groupbox bounds(0, 230, 190, 100) channel("box_levy") text("LÉVY STEPS") fontColour(255, 17, 62, 205) outlineColour(255, 17, 62, 100) colour(22, 87, 22, 100) 
{
rslider bounds(0, 26, 65, 65), channel("rate"), range(0.5, 20, 4, 1, 0.01), text("Rate:Hz"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255)markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(66, 26, 65, 65), channel("alpha"), range(0.3, 2, 1.1, 1, 0.01), text("Alpha"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255)markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(130, 26, 65, 65), channel("scale"), range(0.05, 1, 0.4, 1, 0.001), text("Scale"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200)colour(0, 40, 20, 255)markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
}
; 逻辑分组二：随机值抑制系统 | group 2: suppression system
groupbox bounds(190, 230, 190, 100) channel("box_suppress") text("SUPPRESSION") fontColour(255, 17, 62, 205) outlineColour(255, 17, 62, 100) colour(22, 87, 22, 100)
{
rslider bounds(0, 26, 65, 65), channel("damp"), range(0, 1, 0.4, 1, 0.01), text("Damp"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(66, 26, 65, 65), channel("chaos"), range(0, 0.08, 0.05, 1, 0.001), text("Chaos"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(130, 26, 65, 65), channel("inertia"), range(0.001, 0.4, 0.01, 1, 0.001), text("Inertia"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
}
; 底部控制装饰栏 | bottom decorative bar
image bounds(218, 0, 165, 21) colour(255, 17, 62, 255) channel("image30") corners(10)
;
image bounds(228, 4, 146, 14) channel("wildserial") file("levy_wild.png")

groupbox bounds(0, 331, 380, 91) channel("box_reverb") text("ROOM") fontColour(255, 17, 62, 205) outlineColour(255, 17, 62, 100) colour(22, 87, 22, 100)

hrange bounds(82, 386, 219, 18), channel("minWet", "maxWet"), range(0, 1, 0.1:0.3, 1, 0.001), trackerColour(255, 17, 62, 30) colour(255, 17, 62, 200) colour:0(255, 17, 62, 200) max(1) min(0) 
rslider bounds(10, 352, 65, 65), channel("roomSize"), range(10, 100, 50, 1, 0.1), text("Room"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
rslider bounds(306, 352, 65, 65), channel("cutoff"), range(1000, 16000, 6000, 0.5, 1), text("Damp"), fontColour(255, 17, 62, 200), trackerColour(255, 17, 62, 30), valueTextBox(1) textColour(255, 17, 62, 200) colour(0, 40, 20, 255) markerColour(255, 0, 0, 255) outlineColour(58, 58, 58, 0)
label bounds(74, 362, 235, 15) text("Wet Send Range (Min / Max)") fontColour(255, 17, 62, 205) channel("label18")

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1

; [UDO] 核心双声道深度渲染引擎 | core stereo depth render engine
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
    kRate   cabbageGetValue "rate"
    kAlpha  cabbageGetValue "alpha"
    kScale  cabbageGetValue "scale"
    kDamp   cabbageGetValue "damp"
    kChaos  cabbageGetValue "chaos"
    kInert  cabbageGetValue "inertia"
    
    kMinWet   cabbageGetValue "minWet"
    kMaxWet   cabbageGetValue "maxWet"
    kRoomSize cabbageGetValue "roomSize"
    kCutoff   cabbageGetValue "cutoff"
    ; --- 2. 莱维飞行核心计算（事件驱动） | levy flight steps (event-driven) ---
    kX_acc init 0.5
    kY_acc init 0.5

    ; 离散时钟触发器 | discrete clock trigger
    kStepTrig metro kRate

    if kStepTrig == 1 then
        ; [第一套随机]：突发飞行的矢量角度 (0 到 2*PI) | random jump angle (0..2*PI)
        kRandAng random 0, 6.283185307
        
        ; [第二套随机]：构筑逆变换幂函数分布 | two random vars for inverse power-law
        kRnd1 random 0.001, 1.0
        kRnd2 random 0.001, 1.0
        
        ; 经典莱维长尾算式（陡峭幂函数产生大跨步） | classic levy heavy-tail step
        kTail pow kRnd2, (-1.0 / kAlpha)
        
        ; 【修复一】基于当前位置的动态步长抑制 | fix 1: position-based step suppression
        ; 当前点距中心 (0.5,0.5) 的欧氏距离 | distance from center
        kDistFromCenter = sqrt((kX_acc - 0.5)^2 + (kY_acc - 0.5)^2)
        
        ; Damp 抑制权重：越近边缘，大跳跃被压制得越小 | damp suppresses big jumps near edges
        kSuppressedScale = kScale * (1.0 - limit(kDistFromCenter * kDamp * 1.414, 0, 0.95))
        
        ; 两套随机结合幂函数产生最终步长 | final step from both random layers
        kStepRaw = kRnd1 * kTail * kSuppressedScale * 0.1
        kStep limit kStepRaw, 0, 0.95
        
        ; 极坐标向量叠加至累加器 | add polar vector to accumulator
        kX_acc = kX_acc + (cos(kRandAng) * kStep)
        kY_acc = kY_acc + (sin(kRandAng) * kStep)
        
        ; 【修复二】边界镜像碰撞折返（撞墙即反弹） | fix 2: mirror bounce at boundaries
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

    ; 叠加高频细碎混沌微颤 | chaos jitter
    kChsX random -kChaos, kChaos
    kChsY random -kChaos, kChaos

    kX_final = limit(kX_acc + kChsX, 0, 1)
    kY_final = limit(kY_acc + kChsY, 0, 1)

    ; 音频级平滑插值（Inertia 过冲滑行） | audio-rate smoothing via inertia
    aX interp portk(kX_final, kInert)
    aY interp portk(kY_final, kInert)

    ; --- 3. 音频捕获与深度渲染 | capture input & depth render ---
    aInL, aInR inch 1, 2
    aDryL, aDryR, aWetL, aWetR DepthStereoRender aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize

    ; --- 4. 混响器 | reverb (reverbsc) ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05
    
    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR
    
    outs aOutL, aOutR
    
    ; --- 5. UI 视觉刷新 (30Hz) | UI refresh (30 Hz) ---

    kX downsamp aX
    kY downsamp aY
    kBallX = 100 + (kX * 180) - 4
    kBallY = 42 + ((1 - kY) * 180) - 4
    
    kTrig metro 60
    S_Bounds sprintfk "bounds(%d, %d, 8, 8)", kBallX, kBallY
    cabbageSet kTrig, "visualBall", S_Bounds
    ; 双声道电平捕捉 | stereo level capture
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