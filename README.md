
# Wildtrace

## Introduction
An open-source, LLM-assisted quadraphonic spatial audio plugin suite built with Csound and Cabbage, utilizing complex system algorithms for immersive panning and spatial sound design.

Wildtrace transforms complex system models such as swarm behavior, nonlinear motion and chaotic dynamics into spatial sound imaging algorithms, providing dynamic spatial audio solutions for electronic music, immersive art and sound installations. It supports both stereo and quadraphonic working modes, and can be exported as VST / VST3 / AU plugins to run on mainstream digital audio workstations.

## 项目简介
本项目是一套基于 Csound 与 Cabbage 开发的开源四声道空间音频插件套件，结合大语言模型辅助开发，将复杂系统算法应用于沉浸式声像定位与空间声音设计。

Wildtrace 将群体行为、非线性运动、混沌动力学等复杂系统模型转化为空间声像算法，为电子音乐、沉浸式艺术、声音装置提供动态空间音频解决方案。支持立体声与四声道两种工作模式，可导出为 VST / VST3 / AU 插件，运行于主流数字音频工作站。

## Repository Structure
| Directory | Description |
| --- | --- |
| `stereo wildtrace` | Stereo stable version, adapted for standard stereo monitoring environments |
| `wildtrace beta` | Quadraphonic beta version, supporting 4.0 surround sound imaging and full experimental algorithms |

Both directories contain complete `.csd` project source files and GUI skin assets, which can be directly opened and compiled in Cabbage.

## 仓库目录
| 目录 | 说明 |
| --- | --- |
| `stereo wildtrace` | 立体声稳定版本，适配标准双声道监听环境 |
| `wildtrace beta` | 四声道测试版本，支持 4.0 环绕声声像定位，包含全部实验性算法 |

两个目录均包含完整的 `.csd` 工程源文件与 GUI 皮肤资源文件，可直接在 Cabbage 中打开并编译。

## Environment & Build Requirements
To ensure normal DSP operation and GUI rendering, please strictly use the exact versions specified below:

- **DSP Engine**: Csound 6.18 — **exact version required. Other 6.x releases are not compatible.**
- **Frontend Platform**: Cabbage 2.9.0

> Any other version — higher, lower, or alternative 6.x releases — may cause control misalignment, compilation failure or channel mapping errors.

## 环境与编译要求
为保证 DSP 运算与 GUI 渲染正常工作，请严格使用以下指定版本：

- **DSP 引擎**：Csound 6.18 — **必须使用该 exact 版本，其他 6.x 系列版本不兼容。**
- **前端平台**：Cabbage 2.9.0

> 任何其他版本，包括更高、更低版本以及其他 6.x 系列版本，均可能出现控件错位、编译失败或声道映射错误。

## Quick Start
1. Clone or download this repository to your local machine
   ```bash
   git clone https://github.com/nocalledname/Wildtrace.git
   ```

2. Launch Cabbage 2.9.0

3. Open any `.csd` project file from the corresponding directory (e.g. `wildtrace beta/Beta-Orbita.csd`)

4. In the Cabbage menu bar, select `File → Export Plugin` to compile into native plugin formats (AU / VST / VST3) for your platform.

5. **Manually place GUI assets**: After compilation, right-click the plugin and select "Show Package Contents" (macOS), then place image, font and other asset files from the same directory into the corresponding path of the plugin package to ensure custom skins render correctly.

## 快速开始
1. 克隆或下载本仓库到本地
   ```bash
   git clone https://github.com/nocalledname/Wildtrace.git
   ```

2. 打开 Cabbage 2.9.0

3. 从对应目录中打开任意 `.csd` 工程文件（例如 `wildtrace beta/Beta-Orbita.csd`）

4. 在 Cabbage 菜单栏选择 `File → Export Plugin`，编译为对应平台的原生插件格式（AU / VST / VST3）。

5. **手动放置 GUI 资源**：编译完成后，右键插件选择「显示包内容」（macOS），将同目录下的图片、字体等资源文件放入插件包对应路径，确保自定义皮肤正常渲染。

## Included Algorithms
Wildtrace includes multiple sets of spatial sound imaging algorithms based on different complex system models:

- **Boids**: Swarm behavior model. Multiple sound image particles move autonomously following separation, alignment and cohesion rules.
- **Lévy**: Lévy flight random walk model. Nonlinear sound image trajectory combining long-distance jumps and local exploration.
- **Loom**: Weaving trajectory algorithm. Generates regularly interwoven spatial sound image paths.
- **Orbita**: Orbital surround model. Multi-channel circular revolution and eccentric motion.
- **SINGULARITY**: Singularity gravity model. Chaotic motion of sound image collapsing and ejecting towards the center.
- **SwarmGran**: Swarm particle granular synthesis. Spatial distribution and particle sound generation are synchronized.
- **Zephyr**: Airflow disturbance model. Smooth continuous spatial drift and gradual sound image change.

## 内置算法
Wildtrace 包含多套基于不同复杂系统模型的空间声像算法：

- **Boids**：群体行为模型，多声像粒子遵循分离、对齐、聚合规则自主运动。
- **Lévy**：莱维飞行随机游走模型，长距离跳跃与局部探索结合的非线性声像轨迹。
- **Loom**：编织型轨迹算法，生成规则交织的空间声像路径。
- **Orbita**：轨道环绕模型，多声道环形公转与偏心运动。
- **SINGULARITY**：奇点引力模型，声像向中心坍缩与抛射的混沌运动。
- **SwarmGran**：群体粒子粒声合成，空间分布与颗粒发声同步联动。
- **Zephyr**：气流扰动模型，平滑连续的空间漂移与渐变声像。

## Usage Notes
- The quadraphonic version requires a 4-channel audio interface and corresponding monitoring environment. A 4.0 channel bus must be configured in your DAW.
- It is recommended to use the beta version in hosts that support multi-channel plugins such as Ableton Live and Max/MSP.
- CPU usage increases with higher particle counts. Adjust the particle number parameter to balance performance and effect.

## 使用说明
- 四声道版本需要 4 声道音频接口与对应监听环境，DAW 中需设置 4.0 声道总线。
- 建议在 Ableton Live、Max/MSP 等支持多声道插件的宿主中使用 beta 版本。
- 高粒子数量下 CPU 占用会升高，可通过调整粒子数参数平衡性能与效果。

## License
This project is open source under the **MIT License**. You are free to use, modify and distribute the code and derivative works of this project, only need to retain the original author's copyright notice.

See the [LICENSE](./LICENSE) file for details.

## 开源协议
本项目基于 **MIT License** 开源，你可以自由使用、修改、分发本项目的代码与衍生作品，仅需保留原作者版权声明。

详见 [LICENSE](./LICENSE) 文件。
```
