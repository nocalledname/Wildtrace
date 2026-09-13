Wildtrace
An open-source, LLM-assisted spatial audio plugin suite built with Csound and Cabbage, turning complex-system algorithms into spatial imaging engines for immersive sound design.
Wildtrace transforms models of collective behaviour, nonlinear motion and chaotic dynamics into spatial audio algorithms, driven by an inverted design premise: instead of moving sound objects through space as an end in itself, it treats spatial motion as the engine that generates sonic effects — Doppler shift, granulation and chorus grow out of the trajectories themselves. The suite is available in stereo and quadraphonic working modes and exports to VST / VST3 / AU for mainstream DAWs.
项目简介
本项目是一套基于 Csound 与 Cabbage 开发的开源空间音频插件套件，结合大语言模型辅助开发，将复杂系统算法转化为空间声像引擎。
Wildtrace 将群体行为、非线性运动、混沌动力学等复杂系统模型转化为空间音频算法，并采用一种反向的设计前提：不以声音对象在空间中运动为目的，而是以空间运动为引擎，驱动多普勒频移、粒子化与合唱等音效的生成——音效从轨迹本身生长出来。套件提供立体声与四声道两种工作模式，可导出为 VST / VST3 / AU，运行于主流数字音频工作站。
  本套件是论文 Immersive Engagement: Building the "Wildtrace" Sound World with AI Assistance（ICSC 2026，第 8 届国际 Csound 会议）的配套开源实现。
Repository Structure
      Directory
      Description
      stereo wildtrace
      Stereo "Depth Render" version — the Y axis is reinterpreted as spatial depth; dry/wet dual paths feed a reverbsc stage, with its own reverb front-end controls
      wildtrace beta
      Quadraphonic beta version — 4.0 surround imaging via equal-power panning, containing all experimental algorithms
Both directories contain complete .csd project sources together with the GUI skin assets; each file can be opened and compiled directly in Cabbage.
仓库目录
      目录
      说明
      stereo wildtrace
      立体声「深度渲染（Depth Render）」版——Y 轴由前后声像重释为空间深度，渲染器改出干/湿双路并交由 reverbsc 完成空间混响，配套独立的混响前端控制
      wildtrace beta
      四声道测试版——基于等功率平移实现 4.0 环绕声声像定位，包含全部实验性算法
两个目录均包含完整的 .csd 工程源文件与 GUI 皮肤资源文件，可直接在 Cabbage 中打开并编译。
Environment & Build Requirements
To ensure correct DSP operation and GUI rendering, please use the exact versions specified below:
- DSP Engine: Csound 6.18 — exact version required. Other 6.x releases are not compatible.
- Frontend Platform: Cabbage 2.9.0
  Other versions — higher, lower, or alternative 6.x releases — may cause control misalignment, compilation failure or channel-mapping errors.
环境与编译要求
为保证 DSP 运算与 GUI 渲染正常工作，请严格使用以下指定版本：
- DSP 引擎：Csound 6.18 — 必须使用该 exact 版本，其他 6.x 系列版本不兼容。
- 前端平台：Cabbage 2.9.0
  任何其他版本，包括更高、更低版本以及其他 6.x 系列版本，均可能出现控件错位、编译失败或声道映射错误。
Quick Start
1. Clone or download this repository:
  git clone https://github.com/nocalledname/Wildtrace.git
2. Launch Cabbage 2.9.0.
3. Open any .csd project file from the corresponding directory (e.g. wildtrace beta/Beta-Orbita.csd).
4. In the Cabbage menu bar, select File → Export Plugin to compile into native plugin formats (AU / VST / VST3) for your platform.
5. Place the GUI assets manually: after compilation, right-click the plugin and choose "Show Package Contents" (macOS), then copy the image, font and other asset files from the same directory into the corresponding path inside the plugin bundle so the custom skin renders correctly.
快速开始
1. 克隆或下载本仓库：
  git clone https://github.com/nocalledname/Wildtrace.git
2. 打开 Cabbage 2.9.0。
3. 从对应目录中打开任意 .csd 工程文件（例如 wildtrace beta/Beta-Orbita.csd）。
4. 在 Cabbage 菜单栏选择 File → Export Plugin，编译为对应平台的原生插件格式（AU / VST / VST3）。
5. 手动放置 GUI 资源：编译完成后，右键插件选择「显示包内容」（macOS），将同目录下的图片、字体等资源文件放入插件包对应路径，确保自定义皮肤正常渲染。
Included Algorithms
Wildtrace comprises eight plugins, each driven by a distinct spatial imaging algorithm:
      Plugin
      Core Algorithm
      Sonic Character
      STASIS (立定)
      Manual positioning baseline — mouse, numeric entry and host automation as three parallel inputs
      The reference prototype with no algorithmic intervention, establishing the motion-driven imaging paradigm
      ORBITA (旋星)
      Continuous circular / elliptical orbit switching (Shape); angular velocity varies naturally over the elliptical segments
      Slight Doppler from front–back displacement, producing a sense of distance
      SINGULARITY (奇点)
      Bidirectional spiral trajectory plus a built-in doppler opcode
      Black-hole contraction and white-hole ejection create depth; the core is the reversely introduced built-in Doppler
      ZEPHYR (沐风)
      LFO combined with data jitter driving a back-and-forth traversal
      Each traversal is one grain envelope; fast traversal forms a grain stream
      LÉVY-CHASE (驰猎)
      Lévy flight with a power-law heavy-tailed step-length distribution
      Long-tailed jumps with smooth gliding, producing intermittent Doppler
      LOOM (针织)
      Row × column lattice weaving motion with serpentine (boustrophedon) traversal
      Each pass scatters the sound into N fixed-position grains
      SWARM-GRAIN (迸粒)
      McCurdy delay-based grain scheduling with normal-distribution spatial filtering
      Grains fall into a circular field, forming a centre-to-edge particle cloud
      BOIDS (群游)
      Boids flocking algorithm (separation / alignment / cohesion)
      Followers track the leader; Doppler drift forms a natural chorus
内置算法
Wildtrace 共 8 款插件，每款由一套独立的空间声像算法驱动：
      插件
      核心算法
      音效本质
      STASIS（立定）
      手工摆位基准——鼠标、输入框、宿主自动化三路输入
      无算法介入的对照原型，确立运动驱动声像的基础范式
      ORBITA（旋星）
      圆周/椭圆轨道连续切换（Shape），椭圆段角速度自然起伏
      前后位移引起轻微多普勒，产生距离远近感
      SINGULARITY（奇点）
      双向螺旋轨迹 + 内置 doppler 算子
      黑洞收缩、白洞发散形成距离感，核心为反向引入的内置多普勒
      ZEPHYR（沐风）
      LFO + 数据抖动驱动的往复穿越
      每次穿越即一个粒子包络，高速穿越形成粒子流
      LÉVY-CHASE（驰猎）
      莱维飞行，幂函数长尾步长分布
      长尾突变跳跃 + 平滑滑行，间歇性多普勒
      LOOM（针织）
      行×列点阵纺织运动，蛇形往复巡行
      每次巡行将声音打散为 N 个固定点位粒子
      SWARM-GRAIN（迸粒）
      McCurdy 延迟颗粒调度 + 正态分布空间滤波
      颗粒落入圆域，形成中心—边缘明暗粒子云
      BOIDS（群游）
      鸟群 Boids 算法（分离/对齐/聚合三规则）
      从鸟追踪头鸟，多普勒漂移形成自然合唱
Usage Notes
- The quadraphonic version requires a 4-channel audio interface and a matching monitoring environment; configure a 4.0 channel bus in your DAW.
- It is recommended to use the beta version in hosts that support multi-channel plugins, such as Ableton Live and Max/MSP.
- CPU load rises with higher particle counts. Adjust the particle-number parameter to balance performance and effect.
使用说明
- 四声道版本需要 4 声道音频接口与对应监听环境，DAW 中需设置 4.0 声道总线。
- 建议在 Ableton Live、Max/MSP 等支持多声道插件的宿主中使用 beta 版本。
- 高粒子数量下 CPU 占用会升高，可通过调整粒子数参数平衡性能与效果。
License
Released under the MIT License. You are free to use, modify and distribute the code and derivative works — you only need to retain the original copyright notice.
See the LICENSE file for details.
开源协议
本项目基于 MIT License 开源，你可以自由使用、修改、分发本项目的代码与衍生作品，仅需保留原作者版权声明。
详见 LICENSE 文件。
Citation
If you use Wildtrace in academic work, please cite:
  Immersive Engagement: Building the "Wildtrace" Sound World with AI Assistance. In: Proceedings of the 8th International Csound Conference (ICSC 2026), Trapani, Sicily.
引用
如您在学术工作中使用 Wildtrace，请引用：
  置身世内——在AI辅助下构建声音世界的"野痕". 第 8 届国际 Csound 会议（ICSC 2026）论文集, 特拉帕尼, 西西里.
