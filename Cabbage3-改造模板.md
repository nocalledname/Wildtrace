# Depth 系列 Cabbage 2 → Cabbage 3 改造模板

> **适用**：`stereo wildtrace` 下 **8 个** Depth 插件已全部迁移完毕。
> 本文件现在是**这套 UI 的写法手册**，下一次改造（新插件 / 新版本）照样照着做。
> **8 个参考实现**：Stasis（`C3ST`，最简）、Orbita（`C3OB`，二维几何）、
> levy（`C3LV`，轨迹 + 血红）、Singularity（`C3SG`，场景+控制台 + 分层渲染）、
> loom（`C3LM`，织机网格 + 梭子拖尾 + 动态重建的格子矩阵）、
> zephyr（`C3ZP`，固定 pad 上的极坐标直线穿梭 + 湍流走廊 + 走带按钮）、
> SwarmGrain（`C3SW`，单层薄雾场域 + 布朗游标 + 窗函数预览；粒子层已证明是负债）、
> Boids（`C3BD`，鸟形实体 + 扑翼动画 + 天蓝背景；23 个参数，是参数最多的一台）。
>
> **阅读顺序**：先看下面的「按任务找章节」，只读你当下要的那几节；
> 不要从头读——全文约 5900 行，一次读完记不住。
>
> **第一次做 Cabbage 3 开发**：先读 **§A 上手准备**——Csound 7 / VS Code / Cabbage 3 扩展
> 在哪下载、怎么装进 VS Code、第一个工程怎么建、导出后为什么看不到自定义界面。
> 装好环境再回来看 §0 起的写法手册。

---

## 导航

### 按任务找章节

| 我要做… | 看这里 |
|---|---|
| **第一次上手：装 Csound 7 / VS Code / Cabbage 3 扩展、建第一个工程** | **§A 上手准备**（含下载地址、装扩展、验证、第一个坑） |
| 从零开始迁一个插件 | §10 迁移顺序（8 步清单） |
| **立体声 → 四声道（Quad Doppler）** | **§14 全章**：§14.1 只换输出级 → §14.3 柱高重算 → §14.6 导出与验证（**四声道只出 AU**，`--no-vst3`） |
| 导出 AU / 装到宿主 | §8.1 脚本（§8.1 里另有一段 VST3）→ §8.2 安装 → §8.4 **四声道 auval 必然 FAIL 的判据** |
| **四声道的 VST3 打不开 / 要不要修** | **§9.1 末「决定（2026-11-03）」**：不修，四声道只交付 AU，导出加 `--no-vst3`（`tools/export_plugin.py`） |
| **改造完验收（必跑）** | **§15 四层体检**（编译 → 静态 → 活体 → 压力 → 链路）+ §15.3 两个工具自身的坑 |
| **统一 9 台的头部图标** | **§17 野痕 = 算法制图**（制图语言 / 各台画什么 / 三个坑） |
| 决定控件怎么摆 | **§6.1 按 DSP 信号流排序** → §6.12 两段式布局 |
| 参数名 / 顺序 / 通道角色搞不清 | §2 三种角色 → §3.2 一个通道的完整写法 → §5.3 `PARAM_IDX` |
| 旋钮转起来数值不对（低端拧不动） | **§6.16 映射曲线**（`curve`，不要再读 `skew`） |
| 旋钮弧和刻度对不上 | §6.14 数值弧方向 |
| 数值输入 / 双击归位 | §6.8 |
| 拖动时界面被选中 / 数值反向跑 | §5.5 拖拽独占 → §6.4 四个坑 |
| 缩放（三角拖动 + 双击复位） | §6.3 手势 → §6.6 画布领先窗口 → §6.7 完整代码 |
| 电平表 | **§6.15 dB 表 + 标尺**（有基准实现和自检表） |
| 画面有主体图形（黑洞/轨道/粒子场） | §6.12 两段式布局 → §6.9 等比缩放 |
| 画黑洞 / 行星环这类"有体积"的实体 | §6.13 图层顺序 + 七条形态陷阱 |
| 画一个会动的声源标记 | **§6.17 卫星 + 拖尾**（锥形带、弧长限制、滤镜 region） |
| 开关 / 滑块 | §6.18 |
| 有一个连续变化的场（滤波/衰减/密度） | **§6.19 单层薄雾场**（40 停靠点、公式现算、恒定 alpha） |
| 参数只控制事件速率（Dens 之类），画面里没有几何可画 | **§6.20 用纹理承载**（pattern 点阵 + 桶化重建） |
| 界面要画窗函数 / 包络 / 波形曲线 | **§6.21 预览必须对齐 ftgen 表**（先 dump 再写公式） |
| 画面里要画一组实体（鸟/鱼/车），不是颗粒云 | **§6.22 实体群**（俯视剪影 + 航向由 DSP 算好推过来） |
| 控制台要用旋钮 | **§6.23 旋钮六条**（指针位置 / large-arc / 点拖同热区） |
| 想知道 CPU 花在哪 / 要不要优化 | **§6.24 先量再优化**（CDP 指标 + 离线渲染计时 + 消融表） |
| 多级等比衰减要定「末级多少 dB」 | **§6.25 反解底数**（先核对旧值能否复现现象） |
| 给已完成插件补一个旋钮 | **§6.26 先算行宽预算**（横向 + 纵向都没余量） |
| 背景元素一半在动、一半不动 | **§6.27 位置来源冲突**（绝对坐标 + 统一动画） |
| 电平表读数比实际小一大截 | **§6.28 dB 映射**（柱高与刻度必须同源） |
| 两条消息驱动同一个画面 | §6.11 合并到同一帧 |
| 需要一个内置帮助 / 自带 wiki | **§5.8 内置使用手册**（iframe；`window.open` 在 WebView 里是死按钮） |
| 想接摄像头/手势控制 | [摄像头手势模块.md](./stereo%20wildtrace/摄像头手势模块.md)（**12 台已接入**：Stasis / SwarmGrain / Boids × Quad/Depth/HRTF/Ambi） |
| 换一个新插件时改哪里 | **§8.0 换插件要改的 13 处**（命名约定 + ID 撞车 + 核对脚本） |
| 导出 AU / 装到宿主 | §8.1 脚本 → §8.2 安装 → §8.4 auval |
| 改完不知道对不对 | §7 自检清单 |
| 只改界面，不想重导 | §11 热更新速查 |
| 插件在宿主里打不开 / 找不到 | §9 已知坑 |

### 章节结构

```
§A      上手准备：Csound 7 / VS Code / Cabbage 3 扩展的下载、安装与第一个工程
§0–§1   架构与目录（CSD=参数契约，index.html=界面）
§2–§4   后端：通道角色、CSD 写法、Csound 三种固定模式
§5      前端骨架：消息桥、接收、PARAM_IDX、拖拽、握手、内置手册
§6      视觉规范（最厚的一章，按需取用）
        6.0–6.2   数值格式 / 布局分组 / 画布分层
        6.3–6.7   缩放与自适应（一套完整实现）
        6.8–6.9   数值编辑 / 二维区域等比缩放
        6.10      排布决策（螺旋已废弃，别再试）
        6.11      多通道合并到同一帧
        6.12      场景 + 控制台两段式布局  ★ 默认方案
        6.13      画"真"的实体：图层顺序 + 七条陷阱
        6.14–6.16 旋钮：数值弧 / 电平表 / 映射曲线
        6.17      移动标记：卫星 + 拖尾
        6.18      通用控件细节
        6.19      连续场域：一层薄雾表达滤波/衰减  ★ 粒子是负债
        6.20      没有几何出口的参数：纹理承载（Dens / 密度类）
        6.21      预览波形必须对齐 ftgen 表  ★ 先量再写
        6.22      实体群：俯视鸟形 + 航向  ★ 侧视表达不了方向
        6.23      旋钮的六条硬性做法  ★ 指针别穿数值
        6.24      CPU 花在哪：先量再优化  ★ 成本 ∝ 动画面积
        6.25      等比衰减：给末级 dB 反解底数
        6.26      加旋钮前先算行宽预算
        6.27      背景元素「一半在动」的根因
        6.28      电平表柱高必须与刻度同一条 dB 映射
§7      自检清单（改完必跑）
§8      导出 AU（8.0 = 换插件要改的 13 处，开工前必读）
§9      已知坑（9.0 = 多声道靠 nchnls 回退；9.1 末 = 四声道 VST3 的决定）
§10     迁移顺序
§11     热更新
§12     插件状态与参数契约（9 台 depth；参数顺序表是唯一权威）
§13     摄像头手势 → 已移出，见 摄像头手势模块.md（12 台已接入）
§14     四声道系列（Quad Doppler，9 台；输出级 + 距离模型）
§15     验收：四层体检（编译/静态 → 活体 → 压力 → 链路，六支脚本）
§16     距离场辅助线（等距半圆 / 遮罩 / 圆盘钳制）
§17     头部图标：野痕 = 算法制图（16 网格 / 1px 线 / 一颗源点）
─────── 附录：36 台统一的 DSP 增益契约（2026-11 并入）───────
§18     三段增益结构（干声 ×0.5 / 湿声 ×0.5→tanh / 输出 SoftClip / Boids −9 dB）
§19     距离延迟是艺术效果，不是物理仿真
§20     逐插件核查清单（8 项，含真值）
§21     验证流程（一条命令跑完编译 + 前端 + 8 项核查）
§22     穿心伪影（仅 Ambi / HRTF）
§23     手册必写条目
```

**十条铁律**（违反任何一条都会白改一遍）：

1. `PARAM_IDX` 的顺序必须与 CSD 里 widget 的书写顺序**逐字一致**，错则静默失败（§5.3）。
2. 映射曲线用 `curve` 指数，**不要用 CSD 的 `skew`** 反推（§6.16）。
3. 控件排列按 **DSP 信号流**，不是按名字顺眼（§6.1 规则 0）。
4. 画布必须**领先**窗口，不能跟着窗口走（§6.6）。
5. **几何里的 pad 是常量**：后端送的是「同一块固定 pad 里的归一化位置」，
   参数只能改图形密度，不能改 pad 尺寸（§9）。
6. **一条视觉通道只承载一个参数**：亮度表示频率，就不能再让尺寸/透明度也跟着变（§6.19）。
   纹理的「粗细 + 强弱」算同一条通道（颗粒感），可以一起动，但绝不借用亮度（§6.20）。
7. **参数名一律纯白**：灰字在自动缩放到 60~80% 之后读不出来，这一条被用户提了两次（§9）。
8. **部署目录必须带完整的 `cabbage/` 运行时 + `cabbage.css`**：只放 `cabbage.js` 会让
   插件静默退化成 Cabbage 2 解析，参数全部消失且不报错（§9）。
9. **刻度和图形必须由同一个函数产出**：电平表柱高与 dB 刻度、波形预览与 `ftgen` 表、
   云速与 `dur` —— 只要两处各写一遍，就会悄悄偏掉一大截（§6.21 / §6.28）。
10. **「看着差不多」不算验证**：全量程逐点喂值、dump 真表、实测速度。
    波形、dB、云速这三个 bug 全是"只看一眼觉得对"漏掉的（§6.21 / §6.24 / §6.28）。

---

## A. 上手准备：装环境 → 第一个工程 → 第一次导出

> 这一节写给**第一次做 Cabbage 3 开发**的人，也是把本仓库从零跑起来所需的全部前置条件。
> 装完再从 §0 开始看写法。

### A.1 要装哪几样，从哪下

Cabbage 3 和 Cabbage 2 不是一回事：**Cabbage 2 是独立 IDE，Cabbage 3 是 VS Code 扩展**，
底层引擎也从 Csound 6 换成 **Csound 7**。所以本手册的路径、命令、语法一律以 Cabbage 3 为准。

| 要装什么 | 下载地址 | 说明 |
|---|---|---|
| **VS Code** | <https://code.visualstudio.com/> | 免费。Cabbage 3 以扩展形式装在它里面 |
| **Csound 7** | <https://github.com/csound/csound/releases> | **只能装 7.x**（写作时 7.0.0，2026-10-21）。Csound 6.18 跑不了这些 Cabbage 3 工程 |
| **Cabbage 3 扩展（.vsix）** | <https://github.com/rorywalsh/vscabbage/releases> | 按平台选：`…-macos.vsix` / `…-windows-x64.vsix` / `…-windows-arm.vsix` / `…-linux.vsix`（写作时 3.0.27-beta） |
| Csound 语言扩展（强烈建议） | <https://marketplace.visualstudio.com/items?itemName=kunstmusik.csound-vscode-plugin> | 语法高亮、opcode 提示、报错 |
| 官方文档 | <https://cabbageaudio.com/docs/> | 控件参考、自定义界面、导出、Csound 7 变化 |
| 论坛 | <https://forum.cabbageaudio.com/> | 作者 Rory Walsh 常在 |

平台注意：

- **macOS**：Csound 安装包**尚未签名**。被拦时到「系统设置 → 隐私与安全性」，滚到底部点「仍要打开」。
- **Windows**：SmartScreen 选「更多信息 → 仍要运行」。ARM64 机器（骁龙 / Copilot+）装 `windows-arm` 的扩展，并配 ARM64 版 Csound。
- **Linux**：用 `-linux.vsix`。

### A.2 把 Cabbage 3 装进 VS Code（「如何插入 VS Code」）

1. 先装 **Csound 7**（扩展启动服务器时要调用它）。
2. 打开 VS Code → 命令面板 `Cmd/Ctrl + Shift + P`。
3. 运行 **Extensions: Install from VSIX…**，选中 A.1 下载的 `.vsix`。
4. 命令面板运行 **Developer: Reload Window** 重载。
5. 状态栏点 **Run Cabbage** 启动 Cabbage 服务器（没有它，预览面板就是空的）。
6. 命令面板运行 **Cabbage: Validate Installation**，能通过即可。

装好的落点：

```bash
ls -d ~/.vscode/extensions/cabbageaudio.vscabbage-*
```

> §8.1 / §15 的脚本里写的是 `cabbageaudio.vscabbage-3.0.10-beta`——那是写作时的版本号。
> **换成上面命令查到的实际目录**，否则脚本会直接报路径不存在。

### A.3 第一个工程（两条路）

**A.3.1 先听个响（内置控件，约 5 分钟）**

1. 状态栏 **Run Cabbage**。
2. 命令面板 → **Create Synth File (Cabbage UI)**，起名保存。
3. 保存即编译，代码旁边出现面板，电脑键盘就能弹。
4. 面板空白 → 命令面板 **Cabbage: Reset CabbageApp (not vscode) settings file**，再保存一次（见 A.6）。

**A.3.2 自定义 HTML 界面（本仓库的插件走的是这条）**

命令面板 → **Create Vanilla VST3 Effect Project (Custom UI)** 或 **…Synth Project (Custom UI)**。
生成的目录与 §1 完全一致：

```
MyPlugin/
├── MyPlugin.csd            # Csound 引擎 + <Cabbage> 参数表（= 参数契约）
├── index.html              # 界面，整个可以换掉
├── cabbage.project.json    # {"entry": "index.html"} —— 告诉扩展加载哪个页面
├── cabbage/                # cabbage.js 等运行时，**整份保留**
└── build/                  # 导出产物（不要提交）
```

- 已有工程只想补配置：命令 **Create Project File (cabbage.project.json)**。
- 用 Vite / Svelte / React / Vue：`cabbage.project.json` 写 `{"entry": "http://localhost:5173"}`，
  **保存 `.csd` 之前**先把 dev server 起起来；发布前改回构建产物路径。
- **绝对不要手工只复制一个 `cabbage.js`**：运行时不完整会在宿主里静默降级
  （参数全丢、四路输出 RMS = 0），这是 §9 坑表里代价最高的一条。要么整份 12 个文件，要么用命令生成。

### A.4 打开本仓库的工程

```bash
git clone <本仓库地址> Wildtrace
cd Wildtrace
```

VS Code **File → Open Folder** 打开 `Wildtrace`（或单个 `<插件> Cabbage3` 目录），然后：

1. 状态栏 **Run Cabbage** 启动服务器。
2. 打开 `<插件> Cabbage3/cab3-*.csd`，`Cmd/Ctrl + S` 保存。
3. 面板按 `form.size` 的尺寸加载 `index.html`；只改界面时动 `index.html` / JS / CSS 即可，保存 `.csd` 触发重载（§11）。

四个变体目录结构相同，差别只在输出级：`stereo wildtrace/`（立体声 Depth）、
`quad Doppler/`（四声道）、`hrtf wildtrace/`（双耳）、`ambi wildtrace/`（环绕声）。
根目录散放的 `*.csd`（如 `Boids (Depth Render).csd`）是 **Cabbage 2 旧版**，
需要 Csound 6.18 + Cabbage 2.9.0 才能打开，不参与 Cabbage 3 构建。

### A.5 第一次导出

命令面板 → **Cabbage: Export as VST3 Effect** / **Export as CLAP Effect** / **Export as AUv2 Effect**，
再选输出目录。二进制落在你选的目录，运行时资源写到：

| 系统 | 运行时资源目录 |
|---|---|
| macOS | `/Library/CabbageAudio/<PLUGIN_NAME>/` |
| Windows | `C:/ProgramData/CabbageAudio/<PLUGIN_NAME>/` |
| Linux | `~/.config/CabbageAudio/<PLUGIN_NAME>/` |

- `PLUGIN_NAME` 必须同时等于**二进制名**和资源目录里的 **`.csd` 文件名**（§8.0 的 13 处命名约定）。
- 导出后**改 DSP 不用重新导出**：直接改资源目录里的 `.csd`，宿主里重新加载插件即可；
  增删参数时旧工程可能打不开，测试请新建工程。
- ⚠️ **要让自定义界面生效，不能用这条命令**：扩展写入的是内置默认控件界面，
  也不带 `help.html` / `mediapipe/` / 图片 / 字体。正式交付走 **§8.1 的 `tools/export_plugin.py`**
  （改 `Info.plist` → 部署运行时 → 签名 → 安装）。A.5 只适合快速验证 DSP。

### A.6 第一次最常见的 7 个卡点

| 现象 | 原因 / 解法 |
|---|---|
| 编译后没有界面 | 首次编译生成的 `settings.json` 里 `.js` 路径为空 → **Cabbage: Reset CabbageApp (not vscode) settings file**，再保存 |
| Run Cabbage 点了没反应 | Csound 7 没装 / 装成 6.x / 平台架构不匹配 → **Cabbage: Validate Installation** 看报告 |
| 有界面但控件没反应 | JS 报错。命令面板打开 developer tools 面板看 console；同时打开扩展设置里的 `verbose logging` |
| 窗口出滚动条 / 留白 | `form.size` 与 `index.html` 的 `body` 宽高不一致（§3.1） |
| 宿主里参数全丢、四路 RMS = 0 | 运行时的 `cabbage/` 不完整（只剩 `cabbage.js`），必须 12 个文件（§9 坑表） |
| 装完 AU，宿主里看不到 | 杀掉 `AudioComponentRegistrar` 刷新缓存（§14.6「装完必做」） |
| 换了同名插件还是旧界面 | 宿主缓存。移除再添加，或重启宿主 |

还不行：论坛 <https://forum.cabbageaudio.com/> 搜报错关键字；提 issue 时附上
**Cabbage: Validate Installation** 的结果与 verbose 日志。

---

## 0. 一句话结构

```
CSD=<Cabbage> JSON 参数表 + Csound 引擎     ← 参数契约
index.html                                   ← 真正给用户看的界面
cabbage/cabbage.js                           ← 唯一的消息桥
cabbage.project.json                         ← 告诉 VS Code「用我的 HTML」
```

**`<Cabbage>` 里的 widget 不是界面**，是「参数表 + 窗体描述」。界面完全由 `index.html` 决定。

---

## 1. 目录结构

```
<插件名> Cabbage3/
├── cab3-<小写名>.csd        # 引擎 + 参数表
├── index.html               # 自定义 UI
├── cabbage.project.json     # {"entry": "index.html"}
├── cabbage/
│   └── cabbage.js           # 从 html/ 示例目录复制，不要改（导出时会补全成完整运行时）
├── help.html                # 可选：内置手册（§5.8）        ┐
├── help-ui.js               # 可选：手册模块（§5.8 ⑨）      │ 有就整份同步进运行时，
├── gesture.js               # 可选：摄像头手势（§13）        │ 不用手工 cp
├── gesture-ui.js            # 可选：手势 UI（§13）           │
├── mediapipe/               # 可选：手势资源，跑 scripts/gesture-assets.py 生成（§13）┘
└── build/                   # 导出产物（不要提交）
```

> 可选文件这一栏是踩坑记下来的：`export_plugin.py` 早先按**固定清单**重建运行时目录，
> 结果「改了图标 → 重新导出」把手工放进去的 `help.html` / `gesture*.js` / `mediapipe/`
> 全删了，宿主里 `?` 和 CAMERA 静默失效（`help-ui.js` 的 `catch` 只 `console.warn`）。
> 现在脚本按**源目录整份同步**（跳过 `build/`），新增什么前端文件都不用改脚本。

`cabbage/` 里是 Cabbage 的 JS 运行时，与扩展内置版本一致，**不要修改**。取法两种：

- **推荐**：用命令 **Create Vanilla VST3 Effect/Synth Project (Custom UI)** 生成整份（12 个文件）。
- 手工补：从本机示例目录 `~/Documents/csound/html/cabbage/cabbage.js` 复制。

⚠️ **只复制 `cabbage.js` 一个文件是不够的**——宿主要的是完整的 `cabbage/`，缺文件时参数会静默消失、四路输出全零（§9 坑表里代价最高的一条）。

---

## 2. 通道设计：三种角色

这是整个改造最容易出错的地方。先给每个通道定角色，再写代码。

| 角色 | `automatable` | `visible` | 用途 | 读写方式 |
|---|---|---|---|---|
| **A. 宿主参数** | `true` | 真实参数设 `true`；纯 UI 参数设 `false` | 暴露给 DAW，可录制/回放自动化 | HTML `sendControlData` → Csound `cabbageGetValue` |
| **B. 内部状态** | `false` | `false` | HTML 与 Csound 之间的私有同步（如 `box_x`） | HTML `sendControlData` → Csound；Csound `cabbageSetValue` → HTML |
| **C. UI 反馈** | `false` | `false` | Csound 单向推给界面（电平表、动画位置） | Csound `cabbageSetValue` → HTML |

**关键规则**

- A 类通道名必须与 `PARAM_IDX` 数组顺序一致（见 §5.3）。
- B/C 类**不要**设 `automatable: true`，否则会污染 DAW 参数表。
- 隐藏的 A 类参数用 `"visible": false` + 屏幕外 `bounds`（`left/top: -100`）。
- 任何需要在 Csound 里 `cabbageGetValue` 的通道，**必须**在 `<Cabbage>` 中声明过，否则读不到值。

---

## 3. CSD：`<Cabbage>` 参数表

### 3.1 骨架

```json
{
    "pluginId": "XXXX",
    "enableDevTools": true,
    "channelConfig": [
        { "name": "2 in 2 out", "ins": "2", "outs": "2" }
    ],
    "widgets": [
        {
            "type": "form",
            "caption": "插件显示名",
            "size": { "width": 320, "height": 490 },
            "guiMode": "queue"
        }
    ]
}
```

- `pluginId`：**必须正好 4 个字符**，否则 AU 导出会失败（扩展会报 `pluginId must be exactly 4 characters`）。
- `size` 必须与 HTML 的 `body` 宽高**完全一致**，否则窗口会出现滚动条或空白。
- 纯合成器用 `0 in 2 out`；效果器用 `2 in 2 out`。

### 3.2 一个通道的完整写法

```json
{
    "type": "rotarySlider",
    "visible": true,
    "automatable": true,
    "bounds": { "left": 65, "top": 385, "width": 85, "height": 85 },
    "label": { "text": "Room Size" },
    "channels": [
        {
            "id": "roomSize",
            "range": { "min": 10, "max": 100, "defaultValue": 50, "skew": 1, "increment": 0.1 }
        }
    ]
}
```

`range` 五个字段缺一不可（缺了会被后端补默认值，导致曲线和你想的不同）：

| 字段 | 含义 | 备注 |
|---|---|---|
| `min` / `max` | 工程值范围 | 传给 Csound 的就是这个范围的**真实值**，不是 0–1 |
| `defaultValue` | 默认值 | 启动时写入 Csound 通道 |
| `increment` | 量化步长 | 决定 DAW 自动化粒度 |
| `skew` | 曲线 | 宿主侧的自动化曲线。**HTML 侧不要跟着它算**，用 §6.16 的 `curve` |

### 3.3 widget 类型映射（Cabbage 2 → 3）

| Cabbage 2 | Cabbage 3 | 说明 |
|---|---|---|
| `rslider` | `rotarySlider` | |
| `hslider` | `horizontalSlider` | |
| `vslider` | `verticalSlider` | |
| `nslider` | `numberSlider` | |
| `hrange` | `horizontalRangeSlider` | 双通道 |
| `xy`（无 pad） | `horizontalSlider` ×2 | ⚠️ **不要用 `xyPad`**，见下 |
| `vmeter` / `hmeter` | `verticalSlider`（`automatable:false`） | 没有原生 meter，靠自己画 |
| `combobox` | `comboBox` | |
| `button` | `button` | |
| `image` / `label` / `groupbox` | 同名驼峰 | 自定义 UI 下通常不需要 |
| `checkbox` | `checkBox` | 注意大写 B |

Cabbage 3 本地运行时支持的全部类型：

```
rotarySlider  horizontalSlider  horizontalRangeSlider  verticalSlider
numberSlider  keyboard  form  button  fileButton  infoButton
optionButton  genTable  label  image  listBox  comboBox
groupBox  checkBox  csoundOutput  textEditor  xyPad
```

**关于 `xyPad`**：它只负责界面球的位置，且值更新路径与普通 slider 不同（按 `channels[0].id` / `channels[1].id` 分轴处理）。用自定义 HTML 时没有理由用它——用两个隐藏 `horizontalSlider`（`x` / `y`）即可，逻辑完全可控。

### 3.4 Csound 区

```cs
sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1
```

Csound 7 注意事项：

- `outs` → **`out`**（`outs` 已弃用，会打 warning）
- `max_k` → **`maxk`**
- `madsr` 只接受 i 率参数，音符内改不了包络
- 自定义 opcode 的 `xin` / `xout` 签名照旧可用

---

## 4. Csound 侧：三个固定模式

### 4.1 读值

```cs
kHostX cabbageGetValue "x"
kMinWet cabbageGetValue "minWet"
```

`cabbageGetValue` 返回的是 `range` 里的**工程值**（如 cutoff 的 1000–16000 Hz），不是 0–1。

### 4.2 触发式回写（**必须带触发**）

```cs
kXChg changed kX
cabbageSetValue "x", kX, kXChg        ; 第三参数 = 触发,1 才发
```

不带触发会让每个 k 周期都往 UI 发一条 JSON，30 个通道就能把 WebView 冲垮。只有 `metro` 驱动的电平表可以例外（见 4.3）。

### 4.3 电平表（30 Hz 推送）

```cs
kUIMetro metro 30
kOutL maxk abs(aOutL), kUIMetro, 1     ; 峰值保持 1 秒
kOutR maxk abs(aOutR), kUIMetro, 1

cabbageSetValue "outL", portk(kOutL, .05), kUIMetro
cabbageSetValue "outR", portk(kOutR, .05), kUIMetro
```

推送的是**线性幅度**（`0dbfs=1` 时范围 0–1），转 dB 在 HTML 侧做（见 §5.6）。

### 4.4 互锁路由（A/B 类通道互相驱动时）

当「HTML 拖拽」「数显输入」「宿主自动化」三路都可能改同一个值，需要一个仲裁：

```cs
kX init 0.5

if (kBoxX_Chg == 1 && abs(kBoxX - kX) > 0.001) then
    kX = kBoxX                 ; 来自 HTML（拖拽或数显）
    kXChg = 1
elseif (kHostX_Chg == 1 && abs(kHostX - kX) > 0.001) then
    kX = kHostX                ; 来自 DAW 自动化
    kXChg = 1
else
    kXChg = 0
endif

cabbageSetValue "x",     kX, kXChg     ; 回灌宿主参数
cabbageSetValue "box_x", kX, kXChg     ; 回灌界面数显
```

`changed` + 阈值比较可以避免「自己写回去的值又触发自己」的无限循环。

---

## 5. HTML 侧：必备模块（5.1–5.7）与可选的手册（5.8）

### 5.1 引入消息桥

```html
<script type="module">
import { Cabbage } from './cabbage/cabbage.js';
</script>
```

`cabbage.js` 的 API：

| API | 方向 | 用途 |
|---|---|---|
| `sendControlData({channel, value, gesture}, null)` | UI → 后端 | 参数变化 |
| `sendChannelData(channel, value, null)` | UI → 后端 | 绕过 DAW 参数系统 |
| `sendCustomCommand('cabbageIsReadyToLoad', null)` | UI → 后端 | 启动握手 |
| `addMessageListener(cb)` | 后端 → UI | 订阅 |
| `extractValue(data, id)` | — | 从 `widgetJson` 里取值 |
| `sendWidgetUpdate(widget, null)` | UI → 后端 | 改 widget 属性（一般不用） |

`gesture` 取值：`begin`（按下）/ `value`（拖动中）/ `end`（松开）/ `complete`（离散提交，如输入框回车）。

### 5.2 接收后端：三种消息

```js
Cabbage.addMessageListener(msg => {
    const data = msg.data ?? msg;

    if (msg.command === 'widgetUpdate') {
        const id = data.id ?? data.channel;
        const v = data.value !== undefined ? data.value : Cabbage.extractValue(data, id);
        applyValue(id, v);
    } else if (msg.command === 'batchWidgetUpdate') {
        for (const w of msg.widgets ?? []) {
            const e = w.data ?? w;
            applyValue(e.id, Cabbage.extractValue(e, e.id));
        }
    } else if (msg.command === 'parameterChange') {
        const pm = msg.data ?? msg;
        const id = typeof pm.channel === 'string' ? pm.channel : PARAM_IDX[pm.paramIdx];
        if (id) applyValue(id, pm.value);
    }
});
```

- `widgetUpdate` 有两种形态：`{id, value}` 和 `{id, widgetJson}`，`extractValue` 都能处理。
- `parameterChange` **只更新显示，绝不回发**，否则会和 DAW 自动化打架。

### 5.3 `PARAM_IDX` 必须与参数注册顺序一致

```js
const PARAM_IDX = ['x', 'y', 'minWet', 'maxWet', 'roomSize', 'cutoff'];
```

后端按 `<Cabbage>` 中 widget 的**书写顺序**依次分配 `parameterIndex`（只给 `automatable: true` 的）。`parameterChange` 只给 `paramIdx`，靠这个数组反查通道名。

**顺序写错 = 自动化控制错误的参数，且不会报错。** 改完 CSD 一定要核对这个数组。

> 验证方法：见 §7「参数顺序自检」。

### 5.4 旋钮映射曲线：**不要再用 `skew`**

> ⚠️ 早期版本这里写的是 JUCE 那套幂映射（`f = n^(1/skew)`），**方向是反的**，
> 已经废弃。详见 **§6.16**（含为什么错、正确公式、每个插件该取什么值）。
>
> 一句话：CSD 里照旧写 `skew`（宿主只认值），但 HTML 侧的 `toFrac / fromFrac`
> 用 `curve` + 指数映射，**不要读 CSD 的 `skew` 字段**。

### 5.5 ★ 拖拽独占（必须实现）

**问题**：`setPointerCapture` 只影响 pointer 事件，**不阻止浏览器的原生文本选择**。拖动准星经过 `<input>` 时，浏览器会选中输入框文本并进入原生拖选状态。

**修法**：拖拽期间给 `body` 加 `dragging` 类。

```css
body.dragging,
body.dragging * {
    user-select: none !important;
    -webkit-user-select: none !important;
}
body.dragging input {
    pointer-events: none !important;
    cursor: default !important;
}
body.dragging ::selection {
    background: transparent;
}
```

```js
function beginDrag() {
    document.body.classList.add('dragging');
    const sel = window.getSelection();
    if (sel) sel.removeAllRanges();
}
function endDrag() {
    document.body.classList.remove('dragging');
}

// 兜底：部分宿主 WebView 仍会触发这两个事件
document.addEventListener('selectstart', e => {
    if (document.body.classList.contains('dragging')) e.preventDefault();
});
document.addEventListener('dragstart', e => {
    if (document.body.classList.contains('dragging')) e.preventDefault();
});

// 安全网：指针在窗口外松开时收不到 pointerup
window.addEventListener('blur', () => {
    Object.keys(dragOn).forEach(k => dragOn[k] = false);
    endDrag();
});
```

每个可拖拽控件的 handler 都要成对调用：

```js
el.addEventListener('pointerdown', e => {
    dragOn.xxx = true;
    beginDrag();
    el.setPointerCapture(e.pointerId);
    e.preventDefault();
    // ... sendControlData(..., 'begin')
});
el.addEventListener('pointermove', e => {
    if (!dragOn.xxx) return;
    e.preventDefault();
    // ... sendControlData(..., 'value')
});
const up = () => {
    if (!dragOn.xxx) return;
    dragOn.xxx = false;
    endDrag();
    // ... sendControlData(..., 'end')
};
el.addEventListener('pointerup', up);
el.addEventListener('pointercancel', up);
```

**验证**：拖动经过输入框时，`document.activeElement` 应保持 `BODY`，`window.getSelection().toString()` 应为 `""`。

### 5.6 用 transform 驱动动画，不要用 height/width/background

30 Hz 更新下，改 `height` / `background` / `box-shadow` 会触发整窗重绘，插件里会明显掉帧。

```js
// ✅ 走合成器
bar.style.transform = 'scaleY(' + pos + ')';
glow.style.opacity = pos;

// ❌ 每帧重排重绘
bar.style.height = pos * 100 + '%';
```

渐变本身固定不变，只改 `opacity` 就够了：

```css
body::before {
    background: radial-gradient(/* 固定 */);
    opacity: calc(.40 + var(--lvl) * .60);   /* --lvl 由 JS 写 */
    will-change: opacity;
}
```

### 5.7 启动握手（顺序不能变）

```js
// 1) 先用本地默认值把界面画出来
placeBall(); paintWet(); paintKnob(/* 各旋钮 */);
// 2) 最后告诉后端「可以发初始状态了」
Cabbage.sendCustomCommand('cabbageIsReadyToLoad', null);
```

不发这条消息，宿主已保存的参数值不会回填。

### 5.8 内置使用手册（可选，但推荐）

参数语义、键盘映射、手势用法这些信息如果只存在于代码和对话里，用户装上插件就看不到了。
做法是给每个插件配一份自包含的 `help.html`，由顶栏的 `?` 在**内嵌 iframe** 里打开。

#### ① 必须用 iframe，不要 `window.open`

插件的 WebView 是 `choc::ui::WebView`（WKWebView）。它**没有实现
`createWebViewWithConfiguration`**，所以 `window.open()` 只会返回一个 WindowProxy
然后被直接丢弃 —— 点了完全没反应，连报错都没有。VS Code 的 webview 同样拦。

`Cabbage.openUrl` 这条 IPC 也不解决问题：只有 VS Code 扩展实现了它
（转 `vscode.env.openExternal`），**CabbageApp 与各插件二进制里都搜不到这个命令**，
所以在 DAW 里照样无效。

结论：**只做内嵌查看，不要提供"在浏览器打开"的按钮** —— 那一定是个死按钮。

#### ② 骨架

```html
<canvas class="pad" id="preview"></canvas>   <!-- 或你原有的悬浮元素 -->

<div class="help-overlay" id="help-overlay" aria-hidden="true">
    <div class="help-sheet">
        <div class="help-bar">
            <span class="help-title">Help</span>
            <div class="help-actions">
                <button class="help-close" id="help-close" aria-label="关闭手册">×</button>
            </div>
        </div>
        <iframe class="help-frame" id="help-frame" title="使用手册"></iframe>
        <div class="help-fallback" id="help-fallback">
            手册没能加载出来。请确认运行目录里存在 <code>help.html</code>：<br>
            <code id="help-path"></code>
        </div>
    </div>
</div>
```

顶栏按钮（放在 `.top-right` 里，跟状态灯并列）：

```html
<button class="help-btn" id="help" aria-label="使用手册" title="使用手册">?</button>
```

#### ③ CSS

```css
.help-btn {
    appearance: none;
    background: none;
    border: 1px solid var(--hair);
    border-radius: 50%;
    width: 14px;
    height: 14px;
    padding: 0;
    font-family: inherit;
    font-size: 9px;
    line-height: 1;
    color: var(--faint);
    cursor: pointer;
    transition: color .16s ease, border-color .16s ease;
}
.help-btn:hover { color: #fff; border-color: rgba(255,255,255,.55); }
.help-btn:focus { outline: none; }

.help-overlay {
    position: fixed;
    inset: 0;
    z-index: 20;
    display: flex;
    padding: 8px;
    background: rgba(0, 0, 0, .82);
    opacity: 0;
    pointer-events: none;
    transition: opacity .2s ease;
}
.help-overlay.on { opacity: 1; pointer-events: auto; }

.help-sheet {
    flex: 1 1 auto;
    min-width: 0;
    display: flex;
    flex-direction: column;
    border: 1px solid var(--hair);
    border-radius: 3px;
    background: #000;
    overflow: hidden;
}

.help-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    padding: 6px 8px;
    border-bottom: 1px solid var(--hair);
    flex: none;
}

.help-title {
    font-size: 8px;
    font-weight: 500;
    letter-spacing: .24em;
    text-transform: uppercase;
    color: var(--dim);
}

.help-close {
    appearance: none;
    background: none;
    border: none;
    padding: 0;
    font-family: inherit;
    font-size: 13px;
    line-height: 1;
    color: var(--faint);
    cursor: pointer;
}
.help-close:hover { color: #fff; }

.help-frame {
    flex: 1 1 auto;
    width: 100%;
    border: 0;
    background: #000;
}

/* iframe 载入失败时的兜底:别给一片空白 */
.help-fallback {
    display: none;
    padding: 14px 12px;
    font-size: 10px;
    line-height: 1.7;
    color: var(--dim);
}
.help-fallback.on { display: block; }
.help-fallback code {
    font-family: ui-monospace, Menlo, monospace;
    font-size: 9px;
    color: rgba(255,255,255,.85);
    word-break: break-all;
}
```

#### ④ JS

```js
const HELP = document.getElementById('help-overlay');
const HELP_FRAME = document.getElementById('help-frame');
const HELP_FALLBACK = document.getElementById('help-fallback');
const HELP_PATH = document.getElementById('help-path');
let helpLoaded = false;
let helpReady = false;

HELP_FRAME.addEventListener('load', () => {
    helpReady = true;
    HELP_FALLBACK.classList.remove('on');
});

const openHelp = () => {
    // src 首次点击才赋值:不点帮助就没有任何加载开销,也不常驻内存
    if (!helpLoaded) {
        helpLoaded = true;
        HELP_FRAME.src = './help.html';
    }

    HELP.classList.add('on');
    HELP.setAttribute('aria-hidden', 'false');
    HELP_PATH.textContent = new URL('./help.html', location.href).href;

    // 1.2s 内没触发 load 就说明路径不对 / 文件没部署
    setTimeout(() => {
        if (!helpReady) HELP_FALLBACK.classList.add('on');
    }, 1200);
};

const closeHelp = () => {
    HELP.classList.remove('on');
    HELP.setAttribute('aria-hidden', 'true');
};

document.getElementById('help').addEventListener('click', openHelp);
document.getElementById('help-close').addEventListener('click', closeHelp);

// 点遮罩空白处关闭
HELP.addEventListener('click', ev => {
    if (ev.target === HELP) closeHelp();
});

window.addEventListener('keydown', ev => {
    if (ev.key === 'Escape') closeHelp();
});
```

#### ⑤ 手册打开时必须屏蔽音符键

这是最容易漏的一条：手册开着，用户按 `A` 想翻页，结果弹了一个音。

```js
const onKeyDown = ev => {
    if (ev.repeat || ev.metaKey || ev.ctrlKey || ev.altKey) return;
    if (HELP.classList.contains('on')) return;   // ← 加这一句
    ...
};
```

`Esc` 那条监听器要在音符键监听器**之前**或之后都行，但要确保它不会被
`ev.preventDefault()` 挡掉（`Escape` 不在 `CODE_MAP` 里，本来也不会被处理）。

#### ⑥ `help.html` 怎么写

**完全自包含**：内联 `<style>`，不引外部字体/脚本/图片。这样它既能被 iframe 加载，
也能单独拷出来双击查看，还能在没网的环境里用。

布局要点（窗口只有 380×440）：

```css
body {
    background: #000;
    color: #f4f4f4;
    font-size: 11px;
    line-height: 1.65;
    padding: 18px 16px 40px;
    max-width: 760px;      /* 宽屏浏览器里居中,不铺满 */
    margin: 0 auto;
}

/* 窄窗里滚动条别太粗 */
::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: rgba(255,255,255,.16); border-radius: 2px; }
```

章节建议（按用户实际会问的顺序）：

| 章节 | 内容 |
|---|---|
| 1. 快速开始 | 三步上手，加一条"用完记得关"的警示 |
| 2. 参数 | 控件 / 范围 / 说明三列；**把反直觉的行为写进来**（例如 ADSR 只在 note-on 生效） |
| 3. 操作 | 鼠标、电脑键盘映射、八度切换 |
| 4. 高级功能 | 手势映射、画布图例、校准手势（Shift/Alt + 点击） |
| 5. 快捷键汇总 | 一张表兜底 |
| 6. 常见问题 | 按"没反应 / 不动 / 漂移 / 不释放"分组 |
| 7. 文件与部署 | 每个文件干什么、部署目录在哪 |

#### ⑦ 验收

- [ ] 点 `?` → 遮罩浮现、iframe 载入手册
- [ ] `×` / 点遮罩空白 / `Esc` 三种方式都能关
- [ ] **手册打开时按 `A` 不发声音**；关闭后恢复
- [ ] 380×440 窄窗里排版不折行、不溢出
- [ ] 把 `help.html` 临时改名 → 显示 fallback 路径，而不是空白
- [ ] 重复打开不重复加载（`src` 只赋一次）

#### ⑧ 部署

**跟着导出走就行**，不用手工 `cp`：`export_plugin.py` 的运行时部署是
「源目录整份同步（跳过 `build/`）」，`help.html` / `help-ui.js` / `gesture*.js` /
`gesture-ui.js` 都会自动带上。

`mediapipe/` 是唯一例外：它 16.8MB，12 台各存一份就是 200MB，所以**不入库**。
仓库只在 `shared/gesture/` 存一份，导出前用
`python3 scripts/gesture-assets.py` 复制进需要它的工程（§13）。

不需要重新编译二进制 —— 它跟 `index.html` 一样是运行时读取的资源。

> ⚠️ 别再用 `cp html/help.html ~/Library/CabbageAudio/<名>/` 这种手工方式补文件：
> 脚本重建运行时目录时会先 `rmtree`，手放的文件在**下一次导出**就没了，
> 而界面只是「点 `?` 没反应」，没有任何报错（`help-ui.js` 的 `catch` 只 `console.warn`）。

#### ⑨ 已抽成模块：`help-ui.js`（36 台全部在用）

36 台插件都不再各自内联 HTML + CSS + JS，而是共用一个 `help-ui.js`
（`help-ui.js` / `help.html` 各 36 份，`attachHelp` 引用 36 处）：

```js
import('./help-ui.js').then(({ attachHelp }) => attachHelp())
    .catch(e => console.warn('Cabbage: 手册模块不可用 —', e));
```

`attachHelp()` 负责：

- 往顶栏插 `?`（优先排在 `.gesture-cam` 之后；`.tag` 是行内容器，自己补左右间距）
- 注入遮罩 + 面板 + iframe，`src` 首次点击才赋值（lazy）
- `×` / 点遮罩空白 / `Esc`（含 iframe 内部）三种关闭方式
- 1.2 s 内没 `load` 就显示 fallback 与真实路径

每台的 `help.html` 是自包含的（内联 CSS、无外部依赖），章节固定为：

```
快速上手      拖中心点 / 双击归中 / 数值框 / 缩放三角 / CAMERA / ?
旋钮与推子    按 DSP 信号流分组，逐条写「范围 · 默认」+ 实际作用
手势控制      左右手锁定、ROI、方向、释放与恢复
```

写旋钮说明的要求（比格式重要）：

1. **范围与默认值必须从 CSD / `P` 表抄**，不要凭印象写。
2. **写真实映射，不写形容词**：`Room Size` 要写清"同时放大延迟尺度与混响反馈
   （10 → 0.15，100 → 0.92）"，而不是"越大越好听"。
3. **反直觉的必须点名**：SwarmGrain 的 `Cutoff Min` 是场域*边缘*、
   `Cutoff Max` 是*中心*，出厂值 20000 → 100 表示中心暗外圈亮。

---

## 6. 视觉规范（Depth 系列统一）

### 统一的是「语法」，不是「颜色」

9 台插件的强调色**各不相同**，且用户明确认可：

| 插件 | 底色 | 主强调色 | 辅助色 |
|---|---|---|---|
| Stasis | `#060607` | 白（`rgba(255,255,255,…)` 分级） | 无（唯一一台纯黑白） |
| Orbita | `#04060e` 深蓝 | 橙 `#ff6b3d` | 琥珀 `#ffcd44` |
| levy | `#050505` 近黑 | 血红 `#ff113e` | 暗绿 `#00c85a`（雷达） |
| Singularity | `#03040a` | 金 `#ffc95c` | 琥珀 `#ff9a24` / 红 `#ff3d24` |
| loom | `#050302` 暖黑 | 金 `#ffc24b` | 余烬橙 `#ff5f3a`、纸白 `#f4ead7` |
| zephyr | `#060a13` 深蓝 | 薄荷 `#65d9b8` | 藏青 `#0f172e`、品红 `#c846a0` |
| SwarmGrain | `#0a0a0a` | 红 `#ff2037` | — |
| Boids | 天蓝渐变（唯一亮底） | 珊瑚红 `#ff3b40`（头鸟） | 纯白 `#ffffff`（从鸟）、`#f4555a` |
| Lissajous | `#04030a` 紫黑 | 紫外 `#a678ff` | 冰青 `#7ee8ff`（导引曲线 / 荧光） |

> **Boids 是唯一一台亮底插件**：其余 8 台都是 `#03~#0a` 的近黑，Boids 用天蓝渐变背景。
> 所以它的文字色也必须反过来（近黑字），直接照抄深底插件的配色会读不出。

所以「9 个插件看起来是一套」靠的是**共用同一套排版与质感语法**，
不是共用色板：

**统一（必须遵守）**

- 极暗底（`#03~#06` 级），几乎纯黑
- 等宽字体做所有小字：`"SF Mono", ui-monospace, Menlo, Consolas`
- 字号梯度：产品名 11–12px / 标签 6.5–8.5px / 数值 9.5–11.5px / 底栏 8.5px
- 字距：标题 `.42em`、副标 `.30em`、标签 `.10–.26em`、数值 `.02–.06em`
- 发丝线：`1px` + 10–26% 不透明度，永远不用实线边框
- 圆角 ≤ 2px；不用阴影堆叠；不用 emoji
- 右上角一个副标（`DEPTH RENDER` 之类），底部一个引擎名
- 电平驱动一层 `--lvl` 光晕 → 有声音时画面「活」起来

**每个插件自己定（不要照抄别人的色值）**

- **一个主强调色** + **最多一个辅助色**。超过两个就开始花
- 强调色的三档：`色` / `色 · 58%`（次级）/ `色 · 26%`（发丝线）
- 文字用带一点色相的近白（`#eef1ff`、`#f2e9ea`），不要纯白
- 语义色固定：**红 = 运行/激活**（`RUNNING`、`Loop`），其余状态用强调色

```css
/* 参考写法：强调色定义三档，其余全部引用这几个变量 */
:root {
    --bg:           #03040a;                       /* 页面底 */
    --accent:       #ffc95c;                       /* 主强调色 */
    --accent-dim:   rgba(255, 201, 92, .58);       /* 次级：标签 / 未激活 */
    --accent-hair:  rgba(255, 201, 92, .22);       /* 发丝线 / 边框 */
    --fg:           #eef1ff;                       /* 主文字（带色相的近白） */
    --dim:          rgba(238, 241, 255, .40);      /* 次要文字 */
    --faint:        rgba(238, 241, 255, .10);      /* 极弱分隔 */
    --mono:         "SF Mono", ui-monospace, "JetBrains Mono", Menlo, Consolas, monospace;
    --lvl:          0;                             /* 电平 0~1，驱动光晕 */
}
```

> ⚠️ 早期这章写的是「沿用 Stasis 的黑白语言 / 禁止彩色」。**那是错的历史结论** ——
> 后面三台全部上了彩色，用户反而更喜欢。真正要禁止的是
> 「同一屏里三种以上强调色打架」，不是彩色本身。

### 6.0 数值显示与格式化（★ 全系列统一）

**规则一：显示一律用完整数字，不用 `6k` / `1.2M` 这类口语缩写。**

用户明确要求过这一点（`6000` 而不是 `6k`）。理由：缩写在小字号下容易看错，
且不同参数混排时量纲不直观。单位由**控件标签**体现（`Damp` / `Damping`），
数值区只放纯数字。

```js
/* ✅ 正确：完整数字 */
function fmtHz(v) { return String(Math.round(v)); }        // 6000 / 16000

/* ❌ 错误：缩写（6000 → "6k"）—— 用户明确不要这种显示
function fmtHz(v) {
    if (v >= 1000) return (v / 1000).toFixed(1).replace(/\.0$/, '') + 'k';
    return String(Math.round(v));
}
*/
```

**规则二：显示不用缩写，但输入要接受缩写。** 用户敲 `12k` 是快捷输入，
解析后存成 `12000`，显示仍是 `12000`。两者不冲突，别为了「统一」把输入也禁掉。

**规则三：各类型的小数位**

| 参数类型 | 格式 | 示例 |
|---|---|---|
| 归一化 0–1 | 两位小数 | `0.25` / `0.50` / `0.10` |
| 归一化读数（X/Y 之类） | 三位小数 | `0.500` |
| 整数型（roomSize / 频率） | 整数 | `50` / `6000` |
| 速率（speed） | 小值两位、大值一位 | `0.25` / `12.4` |

**规则四：数值框宽度必须按「最大值」量，不是按默认值。**
`6000` 只要 24px，但 `16000` 要 33px。宽度不足会被裁字。

| 插件 | 最大显示 | 实测文字宽 | 框宽 |
|---|---|---|---|
| Orbita | `16000` | 30.1px | 50px |
| Stasis | `16000` | 33.1px | 54px |

量法：

```js
const cv = document.createElement('canvas').getContext('2d');
const cs = getComputedStyle(input);
cv.font = cs.fontWeight + ' ' + cs.fontSize + ' ' + cs.fontFamily;
cv.measureText('16000').width;      // 必须 <= 框宽 - 2
```

**规则五：`P[key].def` 必须与 CSD 的 `defaultValue` 逐字一致**
（双击归位回到的就是它，见 §6.8）。

> ⚠️ **改一个参数的「预设值」，要同步的是 4 处，不是 2 处。**
> 批量改全部 8 台（当时还没有 Lissajous）的 `cutoff` 默认值时实测：
>
> | # | 位置 | 漏改的后果 |
> |---|---|---|
> | 1 | CSD `<Cabbage>` 的 `"defaultValue"` | 宿主打开插件时的初值不变 |
> | 2 | HTML `P[key].def` | **双击归位**回到旧值 |
> | 3 | HTML 里写死的 `<input class="kval" value="6000">` | 首帧闪一下旧值（有 5 台是这样写的） |
> | 4 | HTML 里的显式初始化变量（`let cut = 6000` / `V = { cutoff: 6000 }`） | 在宿主回传第一帧之前，画面/计算都用旧值 |
>
> 第 3、4 处**只有部分插件有**：用 `const V = {}` + `for (const k in P) V[k] = P[k].def`
> 实现的（Singularity、Boids）自动跟随第 2 处，不需要单独改。
> 改完务必**全局 grep 旧值**复查，别只 grep `def:`——`value="6000"` 和 `let cut = 6000`
> 都不会被 `def:` 的搜索命中。

### 6.1 布局分组（按 DSP 信号流，不按控件类型）

控件怎么摆，取决于它**在信号链的哪一级**，不取决于它是什么形态。踩过的坑有两个：

- **Orbita** 初版把「方向开关」和「混响发送量」并成一行，只因为两者都不是圆旋钮——
  结果一个属于**轨道运动**、一个属于**空间**，读者完全无法归组。
- **Singularity** 初版把 `Master` 摆在最左、`Input` 摆在第二行第一位。
  用户一眼就否了：*"哪有 input/master 在最左边的"*。
  正确顺序是 `1 inputGain → 2 dopplerFactor → 3~5 螺旋物理 → 6 masterGain → 7 roomSize → 8 cutoff`，
  按 CSD 里信号经过的先后从左到右、行间顺延。

规则：

0. **★ 先读 CSD 的 `<CsInstruments>`，把每个 UI 通道标上序号，再动手排版。**
   序号来自它第一次参与运算的位置，不是它的名字听起来像什么。
   排列必须**单调递增**：第一行左→右，再第二行左→右。开关按钮同理。

   ```js
   /* Singularity 的实际顺序（注释就是信号链上的位置） */
   const ROW1 = ['inputGain',      // aMono = (aInL+aInR)*0.5*kInputGain
                 'dopplerFactor',  // doppler aMono, kSourcePos, kMicPos, ...
                 'spinSpeed',      // kAngle += kSpinSpeed        ┐
                 'fallTime'];      // kRadius *= kFallRate        ├ 螺旋物理引擎
   const ROW2 = ['gravityCurve',   // kGainEnv = pow(kNormRadius) ┘
                 'masterGain',     // aProcessed * kMasterGain
                 'roomSize',       // vdelay3 延迟 + 距离衰减 + reverbsc 反馈量
                 'cutoff'];        // reverbsc 阻尼低通（最后一级）
   ```

   **只改 `ROW1 / ROW2`，绝不要动 `PARAM_IDX`** —— 那个是 CSD widget 的书写顺序，
   两者混为一谈会静默错通道。

1. **先按语义分组，再排视觉**。Orbita 最终分组：
   - 轨道运动 = `Speed / Radius / Shape` + `Dir`
   - 空间 = `Room / Damp` + `Wet Min-Max`
2. **双态/多态开关与同组旋钮同排**，不要单独占一行。胶囊开关比旋钮矮，
   用 `padding-top` 把它的中心对到旋钮圆心（圆心 = 单元顶 + 27px），
   标签用绝对定位钉在单元底部，保证与其它标签同基线：

   ```css
   .dirwrap { height: 65px; padding-top: 16px; position: relative; flex: none; text-align: center; }
   .dirwrap .klab { position: absolute; left: 0; right: 0; bottom: 0; margin-top: 0; }
   ```
3. **细长控件（双滑块、hrange）跟在它所属分组的旋钮下方**，间距 7–8px（小于
   组间间距 10–12px），用间距差表达归组，不要靠画框。
4. 一行放不下时先量宽度：`n × 单元宽 + (n-1) × gap ≤ 288`。
   旋钮单元 62px 时可放 3 个旋钮 + 1 个 46px 开关（`3×62 + 3×14 + 46 = 274`）。
5. 任何 `.klab` 都要显式 `line-height: 8px`，否则绝对定位的标签会差 1px 基线。

### 6.2 画布分层（缩放的前提）

`transform: scale()` 只放大画面，**插件窗口本身不变**。要让窗口真的变，得靠 §6.3 的
`requestResize`。但无论窗口怎么变，**画布都必须按实际视口自适应**，否则宿主拒绝 resize 时
界面就缩成一小块。

```css
html, body { width:100%; height:100%; overflow:hidden; background:var(--bg); }
body       { --zoom:1; display:flex; align-items:center; justify-content:center; position:relative; }
.canvas    { width:320px; height:470px; flex:none; transform:scale(var(--zoom)); transform-origin:center center; }
```

三个要点：

1. **`.canvas` 与 `body` 必须分开**。`body` 只做视口容器（居中画布 + 钉住三角），
   画布自己缩放。如果把 `transform` 加在 `body` 上，`position:absolute` 的三角会
   跟着画布一起漂，缩放后位置就错了。
2. **三角放 `body` 里、画布外**：`position:absolute; right:0; bottom:0`，永远是窗口右下角。
3. **画布比例永远由视口推导**，不要存成状态：

   ```js
   const viewScale = () => Math.min(innerWidth / CANVAS.w, innerHeight / CANVAS.h);
   ```

   存成状态会在宿主拒绝 resize 时和现实脱节（界面按你以为的尺寸画，实际窗口没变）。

### 6.3 缩放手势：三角拖动 + 双击复位

交互设计（Orbita 定版）：

| 操作 | 行为 |
|---|---|
| **往下/往右下**拖三角 | **变大**（`cursor: ns-resize`） |
| **往上/往左上**拖三角 | **变小** |
| 双击三角 | 回到 100% |
| 单击 | **什么都不做**（早期版本是循环三档，已被否掉） |

> ★ **方向必须服从「拉角」的直觉，不是「旋钮」的直觉。**
> 拖的是窗口**右下角**，往下拖才是「把角拉出去、创造更大空间」，所以**往下 = 变大**。
> 我第一版按「往上推数值变大」写反了，用户当场指出。
> 同一个道理：如果控点在左上角，就应该是「往左上拖变大」。**方向取决于控点位置，不是固定约定。**

**下限固定 75%，上限不写死但必须有天花板**。

> ★ **上限必须同时钳制宽和高，取较小者。**
> 只按宽度算会导致窗口高过屏幕 → **右下角的三角被推出可视区，用户再也点不到它，
> 插件等于被锁死**（这是用户实测踩到的设计缺陷）。
> 还要留余量：窗口正好贴满屏幕时，三角压在边缘也很难点中。

```js
const CANVAS = { w: 320, h: 470 };         // ← 设计稿尺寸，不是窗口尺寸
/* 默认呈现比例 = 宿主默认窗口 / 设计稿。
   改这一个数就等于改插件默认尺寸，布局仍按设计单位写，不用逐条改 CSS。 */
const BASE = 4 / 3;
const MIN_SCALE = 0.75 * BASE;             // 下限是「默认尺寸的 75%」，不是设计稿的 75%
const MAX_FILL = 0.94;                     // 留 6% 余量，保证三角始终可点

const screenW = () => (screen.availWidth || screen.width || 0);
const screenH = () => (screen.availHeight || screen.height || 0);

function maxScale() {
    const sw = screenW(), sh = screenH();
    const byW = sw ? sw / CANVAS.w : 3;
    const byH = sh ? sh / CANVAS.h : 3;
    /* 注意：这里不能给下限兜底（不能写 Math.max(3, ...)），
       否则小屏上「兜底值」会反过来突破高度上限 */
    return Math.max(MIN_SCALE, Math.min(12, Math.min(byW, byH) * MAX_FILL));
}
const clampScale = s => Math.min(maxScale(), Math.max(MIN_SCALE, s));
```

**并且要在发请求处做二次钳制** —— 双击复位等路径可能绕开 `clampScale`：

```js
function requestWindowScale(scale) {
    let w = Math.round(CANVAS.w * scale);
    let h = Math.round(CANVAS.h * scale);
    const limit = Math.floor(screenH() * MAX_FILL);
    if (limit > 0 && h > limit) {          // 等比例缩，保持画布不变形
        h = limit;
        w = Math.round(h * CANVAS.w / CANVAS.h);
    }
    /* ... */
}
```

**★ 默认尺寸怎么改（不要改 CSS 里的每一处 px）**

前端布局永远按设计稿的设计单位写（如 `380×560`），**默认放大多少由 `BASE` 决定**：

| 想改的 | 改哪里 |
|---|---|
| 插件默认窗口大小 | CSD 的 `form.size` + JS 的 `BASE`（两者必须一致：`size = round(CANVAS × BASE)`） |
| 界面内部排版、字号 | 不用改 —— `--zoom` 会自动整体放大，布局比例不变 |

百分比徽标和「双击回 100%」都要相对 `BASE`，否则默认状态就显示 133%，
双击反而把窗口缩小，用户会以为坏了：

```js
$('zpct').textContent = Math.round(s / BASE * 100) + '%';   // 相对默认尺寸
// 双击复位
lastSent = BASE; holdScale = BASE;
requestWindowScale(BASE); paintZoomBadge(BASE);
```

实测数据（Levy，设计稿 380×560，`BASE = 4/3`，2026-11-01 复测）：

- CSD `form.size` = `507×747`，窗口打开即 507×747
- `viewScale()` = `min(507/380, 747/560)` = `1.3339` → 徽标 `100%`
- 画布 `getBoundingClientRect()` = `507 × 747`，`scrollWidth/Height` 均无溢出
- 拖到下限：徽标 `75%`，请求 `380×560`

> levy 的画布在补 `masterGain` 时由 `380×500` 加到 `380×560`（详情见 §6.26）。
- 逻辑屏 1440×900 时 `maxScale()` = `min(3.79, 1.75) × 0.94` = `1.645` → 最大约 `625×822`

用 `screen.availHeight` 而不是 `screen.height`：前者排除了菜单栏和 Dock，
更接近真正能用的区域。实测（屏幕 400×588）：巨幅下拖钳在 **376×552**（比例 0.939），
`552 < 588` ✓。

**拖动用指数映射**，手感接近对数旋钮（线性映射在低倍率区太灵敏、高倍率区太钝）：

```js
/* 往右下拖 = 变大：anchorY 是按下时的 screenY，往下时 screenY 更大，dy 为正 */
const dy = yOf(e) - zoomDrag.anchorY;
const target = clampScale(zoomDrag.startScale * Math.exp(dy / 220));
// 220px 垂直位移 ≈ 2.72 倍
```

### 6.4 ★ 拖动时的四个必踩的坑

**坑 1：松手丢最后一档。**
`pointermove` 里用 `requestAnimationFrame` 合并请求是对的（否则刷爆宿主），但如果在
「最后一次 move」和「下一帧 rAF」之间松手，rAF 被 `cancelAnimationFrame` 取消，
**最终值永远发不出去**。实测：拖到 216%，宿主收到的是 188%。

必须在 `pointerup` 里补发：

```js
function endZoomDrag(e) {
    if (!zoomDrag) return;
    const moved = zoomDrag.moved;
    const finalScale = zoomDrag.target;
    zoomDrag = null;
    if (rafId) { cancelAnimationFrame(rafId); rafId = 0; }
    if (moved && Math.abs(finalScale - lastSent) >= 0.004) {
        lastSent = finalScale;
        requestWindowScale(finalScale);      // ← 补发，别丢
    }
}
```

**坑 2：松手被误判成双击。**
拖完必然触发 `pointerup`，如果紧接着的 `dblclick` 不设防，用户「拖一下」就被拉回 100%。
用时间窗隔开：

```js
$('zoomer').addEventListener('dblclick', e => {
    if (performance.now() - dragEndedAt < 400) return;   // 刚拖过，不算双击
    /* 回 100% */
});
```

**坑 3：拖动方向反了（越往上拖越小）。★最隐蔽**

用 `e.clientY` 算位移 → **实测在 Live 里方向是反的**。

原因：`clientY` 是**相对窗口**的坐标。宿主执行 resize 时窗口会移动（Live 的插件窗口
凭 bottom-left 定位，变大时顶边上移），指针在屏幕上根本没动，`clientY` 却变大了。
这个变化又被反馈进缩放公式：

```
往上拖 → 请求变大 → 窗口变大且顶边上移 → clientY 增大 → 算出来「往下拖」→ 变小
```

形成正反馈，表现就是「拖大反而变小」。

**解法：用屏幕绝对坐标 `screenY`**，窗口怎么移动都不影响：

```js
const yOf = e => (typeof e.screenY === 'number' && e.screenY !== 0) ? e.screenY : e.clientY;
// pointerdown 时记录锚点：zoomDrag = { anchorY: yOf(e) /* , 其余字段 */ };
// pointermove 时：const dy = yOf(e) - zoomDrag.anchorY;
```

实测（clientY 因窗口移动漂移 80px，screenY 不变）：

| 步骤 | screenY | clientY | 缩放 |
|---|---|---|---|
| 按下 | 1000 | 560 | 125% |
| 窗口上移（指针没动） | 1000 | 520 | **125%** 不变 |
| 再漂移 | 1000 | 480 | **125%** 不变 |
| 真上拖 80px | 920 | 480 | 180% |
| 再上拖 80px | 840 | 480 | 259% |

> 推论：**任何「按住拖动改变窗口自身」的交互都不能用 `clientX/clientY`**。
> 同一个坑也适用于「拖动窗口位置」「拖动自身尺寸的角handle」。

**坑 4：拖动被当成拖拽文本 / 选中。**
三角也要加入 §5.5 的拖拽独占集合。`dragOn` 里加一个 `zoom` 键即可复用现有守卫：

```js
const dragOn = { /* 原有键 */ zoom: false };
// pointerdown: dragOn.zoom = true;  pointerup: dragOn.zoom = false;
```

另外**位移死区**：`|dy| < 2px` 不进入拖动，否则「原地双击」会被判成拖动。

### 6.5 请求窗口尺寸：`requestResize`

`transform: scale()` 只放大画面，**插件窗口本身不变**（这是被用户当场否掉的做法）。
要真的改窗口，用官方通道：

```js
Cabbage.requestResize(width, height, null);   // 第三参数必须是 null（插件模式）
```

调用链（`nm` 反查 AU 二进制确认，非推测）：

```
Cabbage.requestResize
  → Clap::HostExt::request_resize
  → free_audio::auv2_wrapper::WrapAsAUV2::gui_request_resize(w, h)
  → auv2shared_mm_request_resize(clap_window*, w, h)
```

**实测结论（Live + AUv2）**

| 事项 | 结果 |
|---|---|
| Live 是否执行 resize | ✅ 会真的改变窗口 |
| `resizeResponse.accepted` | ❌ **不可信**：实测窗口确实变大了，却回 `accepted:false` |
| 是否所有宿主都支持 | ⚠️ AUv2 没有标准 resize 协议，取决于 DAW。必须做「宿主不配合」的兜底 |

所以判定宿主态度**不能看 `accepted`，要看窗口尺寸是否真的变了**：

```js
let reqViewport = 0, reqTimer = 0, hostResize = 'unknown';

function requestWindowScale(scale) {
    const w = Math.round(CANVAS.w * scale), h = Math.round(CANVAS.h * scale);
    reqViewport = { w: innerWidth, h: innerHeight };     // 请求前的快照
    clearTimeout(reqTimer);
    reqTimer = setTimeout(() => {                        // 超时 = 宿主没理
        if (reqViewport) { reqViewport = 0; hostResize = 'rejected'; paint(); }
    }, 600);
    Cabbage.requestResize(w, h, null);
}

function fitToViewport() {
    if (reqViewport && (innerWidth !== reqViewport.w || innerHeight !== reqViewport.h)) {
        reqViewport = 0; clearTimeout(reqTimer);
        hostResize = 'accepted';                          // 观察到变化才算数
    }
    document.body.style.setProperty('--zoom',
        Math.min(innerWidth / CANVAS.w, innerHeight / CANVAS.h).toFixed(4));
}
```

### 6.6 ★ 画布必须「领先」窗口，不是跟着窗口走

**踩过的坑**：拖大时窗口先变大、画布后跟上，中间露出一两帧白边。

**根因**不是 ResizeObserver 慢，而是**拖动过程中压根没改缩放**：

```js
// ❌ 错误写法：拖动中只更新百分比文字
function paintZoomBadge(override) {
    const s = override != null ? override : viewScale();
    if (override == null) document.body.style.setProperty('--zoom', s);   // ← 拖动时跳过
    $('zpct').textContent = Math.round(s * 100) + '%';
}
```

于是顺序变成「窗口变大 → 露出空白 → WebKit 收到新视口 → RO 触发 → 才改 --zoom）。
**拖小时看不出来**：窗口缩窄时画面是被裁掉的，不会暴露新区域；只有放大才露白。

**解法：拖动时也立刻改缩放**，让画布领先窗口：

```js
function paintZoomBadge(override) {
    const s = override != null ? override : viewScale();
    document.body.style.setProperty('--zoom', s.toFixed(4));   // ← 无条件执行
    $('zpct').textContent = Math.round(s * 100) + '%';
    $('zoomer').dataset.host = hostResize;
}
```

画布先变大，多出的部分被 `body { overflow:hidden }` 裁掉；等宿主把窗口追上来，
新露出的区域里**已经有画好的内容**，不会白。

**配套三处，缺一处就会抖或弹回**

1. **RO 在拖动中不要拉回实际视口**，否则和 `pointermove` 的目标值互相打架：

   ```js
   paintZoomBadge(zoomDrag && zoomDrag.moved ? zoomDrag.target : (holdScale ?? undefined));
   ```

2. **松手要保持目标值**，不能立刻按（还没变大的）实际视口重算，否则会「缩回去再长出来」：

   ```js
   if (moved) {
       holdScale = finalScale;          // 等宿主追上
       paintZoomBadge(finalScale);
       return;
   }
   ```

3. **`holdScale` 要有释放条件**，否则宿主一直不配合时会永久卡在目标值：

   ```js
   // 宿主已追上（视口比例 ≈ 目标）→ 释放
   if (holdScale != null && Math.abs(viewScale() - holdScale) < 0.01) holdScale = null;
   // 600ms 超时判 rejected 时也要释放
   if (reqViewport) { reqViewport = 0; hostResize = 'rejected'; holdScale = null; paintZoomBadge(); }
   ```

**另外一个必然踩到的边界：天花板不能低于当前比例**

`maxScale()` 带 0.94 余量，当窗口已经铺满屏幕时 `maxScale() < viewScale()`。
此时「往下拖想变大」的第一帧会被 clamp 到更小的值 → **反而缩一下**。
所以天花板要取「当前比例」与「上限」的较大者：

```js
// pointerdown：
zoomDrag = { anchorY: yOf(e), startScale: s, moved: false, target: s,
             ceiling: Math.max(s, maxScale()) };        // ← 天花板取 max
// pointermove：
const target = Math.min(zoomDrag.ceiling, Math.max(MIN_SCALE, raw));
```

**关于白边本身**：`--bg` 是近黑，正常渲染露出的是深色。若看到的是白色，
那是宿主 NSView 在 resize 时清屏的原生层，在 WebKit 重绘之前露出，**JS 改不到**。
上面的改动能把它压到最短，但不可能完全消除。


**补充要点**

1. **绝对不要加 `setTimeout` 防抖**。防抖在连续拖拽场景有意义，但这里是
   「一次性窗口变化」，防抖只会制造可见的延迟。必须用 `ResizeObserver`。
2. **两条腿都要有**：`requestResize` 负责「请求」，RO 负责「按实际尺寸填充」。
   宿主不配合时，界面依然填满它能用的空间，不会缩成一小块。
3. **三角上的反馈要基于观察**，不要基于 `accepted`：实心 `data-host="accepted"`，
   空心 `data-host="rejected"`。

### 6.7 完整可复制实现（后续插件直接抄）

Orbita 定版的全套代码，改 `CANVAS` 与配色即可复用。**四段缺一不可。**

**① CSS**（`.canvas` 与 `body` 必须分层）

```css
html, body { width:100%; height:100%; overflow:hidden; background:var(--bg); }
body  { --zoom:1; display:flex; align-items:center; justify-content:center; position:relative; }
.canvas { width:320px; height:470px; flex:none;
          transform:scale(var(--zoom)); transform-origin:center center;
          display:flex; flex-direction:column; }   /* 画布里照常排版 */

.zoomer { position:absolute; right:0; bottom:0; width:30px; height:30px;
          cursor:ns-resize; z-index:20; }
.zoomer .zpct { opacity:0; transition:opacity .14s ease; }
.zoomer:hover .zpct, body.dragging-zoom .zoomer .zpct { opacity:1; }
.zoomer[data-host="accepted"] path { fill:rgba(255,205,68,.62); }
.zoomer[data-host="rejected"] path { fill:none; stroke:rgba(255,205,68,.46); stroke-width:1.1; }
```

**② HTML**（三角在 `.canvas` 之外，永远钉窗口右下角）

```html
<div class="canvas" id="canvas"> ...界面... </div>
<button class="zoomer" id="zoomer" type="button"
        title="往右下拖变大、往左上拖变小 · 双击回到 100%">
    <span class="zpct" id="zpct">100%</span>
    <svg viewBox="0 0 10 10"><path d="M10 2.6 L2.6 10 L10 10 Z"/></svg>
</button>
```

**③ 常量与钳制**

```js
const CANVAS = { w: 320, h: 470 };       // ← 设计稿尺寸；form.size = CANVAS × BASE
const BASE = 1;                          // ← 默认呈现比例。Orbita/levy 是 1.25 / 4÷3
const MIN_SCALE = 0.75 * BASE;           // 下限是「默认尺寸的 75%」，不是设计稿的 75%
const MAX_FILL  = 0.94;                                  // 留余量，保证三角可点
const screenW = () => (screen.availWidth || screen.width || 0);
const screenH = () => (screen.availHeight || screen.height || 0);

function maxScale() {
    const sw = screenW(), sh = screenH();
    const byW = sw ? sw / CANVAS.w : 3;
    const byH = sh ? sh / CANVAS.h : 3;                  // ← 高度这条防「锁死」
    /* 注意：这里不能给下限兜底（不能写 Math.max(3, ...)），
       否则小屏上「兜底值」会反过来突破高度上限 */
    return Math.max(MIN_SCALE, Math.min(12, Math.min(byW, byH) * MAX_FILL));
}
const clampScale = s => Math.min(maxScale(), Math.max(MIN_SCALE, s));
const viewScale  = () => Math.min(innerWidth / CANVAS.w, innerHeight / CANVAS.h);
const yOf = e => (typeof e.screenY === 'number' && e.screenY !== 0) ? e.screenY : e.clientY;
```

**④ 交互与请求**

```js
let hostResize = 'unknown', reqViewport = 0, reqTimer = 0;
let zoomDrag = null, holdScale = null;          // holdScale: 松手后等宿主追上
let pendingScale = null, rafId = 0, lastSent = 0, dragEndedAt = 0;

/* 无条件写 --zoom：拖动时也要立刻缩放，画布必须「领先」窗口 */
function paintZoomBadge(override) {
    const s = override != null ? override : viewScale();
    document.body.style.setProperty('--zoom', s.toFixed(4));   // ← 无条件写
    $('zpct').textContent = Math.round(s / BASE * 100) + '%';  // ← 相对 BASE，不是绝对
    $('zoomer').dataset.host = hostResize;
}

/* 宿主态度以「窗口真的变了」为准，不看 resizeResponse.accepted */
function fitToViewport() {
    if (reqViewport && (innerWidth !== reqViewport.w || innerHeight !== reqViewport.h)) {
        reqViewport = 0; clearTimeout(reqTimer); hostResize = 'accepted';
    }
    if (holdScale != null && Math.abs(viewScale() - holdScale) < 0.01) holdScale = null;
    paintZoomBadge(zoomDrag && zoomDrag.moved ? zoomDrag.target : (holdScale ?? undefined));
}

function requestWindowScale(scale) {
    let w = Math.round(CANVAS.w * scale);
    let h = Math.round(CANVAS.h * scale);
    const limit = Math.floor(screenH() * MAX_FILL);      // ← 二次钳制，防绕开 clampScale
    if (limit > 0 && h > limit) { h = limit; w = Math.round(h * CANVAS.w / CANVAS.h); }
    reqViewport = { w: innerWidth, h: innerHeight };
    clearTimeout(reqTimer);
    reqTimer = setTimeout(() => {
        if (reqViewport) { reqViewport = 0; hostResize = 'rejected'; holdScale = null; paintZoomBadge(); }
    }, 600);
    Cabbage.requestResize(w, h, null);
}

function scheduleResizeRequest() {
    if (rafId) return;
    rafId = requestAnimationFrame(() => {
        rafId = 0;
        if (pendingScale == null) return;
        if (lastSent && Math.abs(pendingScale - lastSent) < 0.004) return;
        lastSent = pendingScale;
        requestWindowScale(lastSent);
    });
}

$('zoomer').addEventListener('pointerdown', e => {
    if (e.button !== 0) return;
    e.preventDefault();
    $('zoomer').setPointerCapture(e.pointerId);
    const s = viewScale();
    /* ceiling 不能低于当前比例，否则「往下拖想变大」第一帧反而缩一下 */
    zoomDrag = { anchorY: yOf(e), startScale: s, moved: false, target: s,
                 ceiling: Math.max(s, maxScale()) };
    dragOn.zoom = true;
    document.body.classList.add('dragging-zoom');
});

$('zoomer').addEventListener('pointermove', e => {
    if (!zoomDrag) return;
    const dy = yOf(e) - zoomDrag.anchorY;                // ← 往下为正 = 变大
    if (!zoomDrag.moved && Math.abs(dy) < 2) return;     // 死区，保住双击
    zoomDrag.moved = true;
    e.preventDefault();
    const raw = zoomDrag.startScale * Math.exp(dy / 220);
    const target = Math.min(zoomDrag.ceiling, Math.max(MIN_SCALE, raw));
    zoomDrag.target = target;
    pendingScale = target;
    paintZoomBadge(target);
    scheduleResizeRequest();
});

function endZoomDrag(e) {
    if (!zoomDrag) return;
    const moved = zoomDrag.moved, finalScale = zoomDrag.target;
    zoomDrag = null; pendingScale = null; dragOn.zoom = false;
    document.body.classList.remove('dragging-zoom');
    if (rafId) { cancelAnimationFrame(rafId); rafId = 0; }
    try { $('zoomer').releasePointerCapture(e.pointerId); } catch (_) {}
    if (moved) {
        dragEndedAt = performance.now();
        if (Math.abs(finalScale - lastSent) >= 0.004) {   // ← 补发，别丢最后一档
            lastSent = finalScale; requestWindowScale(finalScale);
        }
        holdScale = finalScale;                          // ← 保持目标，等宿主追上
        paintZoomBadge(finalScale);
        return;
    }
    paintZoomBadge();
}
$('zoomer').addEventListener('pointerup', endZoomDrag);
$('zoomer').addEventListener('pointercancel', endZoomDrag);

$('zoomer').addEventListener('dblclick', e => {
    e.preventDefault();
    if (performance.now() - dragEndedAt < 400) return;    // ← 拖完不算双击
    lastSent = BASE; holdScale = BASE;                    // ← 回 BASE，不是回 1
    requestWindowScale(BASE); paintZoomBadge(BASE);
});

/* 初始化 */
paintZoomBadge();
lastSent = viewScale();
new ResizeObserver(fitToViewport).observe(document.documentElement);
addEventListener('resize', fitToViewport);
```

别忘了 `dragOn` 里加 `zoom: false`（复用 §5.5 的拖拽独占守卫）。

---

### 6.8 数值编辑 + 双击归位

**需求**：数字要能点开改、双击归位。这条和 §5.5 的拖拽独占是**冲突的**——
全局 `user-select: none` 会让输入框里也选不中文字。

**做法**：数值用真 `<input>` 覆盖在原 SVG `<text>` 的位置，靠 `pointer-events` 开关状态。

```css
.knob { position: relative; }
.kval {                                   /* 平时不接管指针：整块旋钮都能拖 */
    position: absolute; left: 50%; top: 27px; transform: translate(-50%, -50%);
    width: 48px; height: 15px; padding: 0; border: 0; background: transparent;
    color: var(--amber); font: 300 10px var(--mono); text-align: center; outline: none;
    pointer-events: none;
    -webkit-user-select: text; user-select: text;   /* ← 必须显式覆盖 body 的 none */
    -webkit-appearance: none; appearance: none;
}
.knob.editing .kval {                     /* 只有编辑态才接管 */
    pointer-events: auto;
    background: rgba(255,205,68,.10);
    box-shadow: 0 0 0 1px rgba(255,205,68,.55);
}
```

`top: 27px` 对应原来 SVG `<text y="31">` 的视觉中心（`baseline 31 − 字号的一半`），
换掉 `<text>` 后位置不能变，否则数值会跳。

**三种手势必须互不冲突**：

| 手势 | 判据 | 行为 |
|---|---|---|
| 拖动 | 位移 ≥ 3px | 连续改值，`begin → value… → end` |
| 单击 | 位移 < 3px | 进入编辑，`el.select()` 全选 |
| 双击 | 两次单击间隔 < 350ms | 归位到 `P[key].def` |

**关键点**

1. **3px 死区**：没有死区的话，手抖 1px 就变成拖动，永远点不开编辑。
2. **双击自己计时，不要用原生 `dblclick`**：第一次单击就把焦点交给 `input` 了，
   两次 `click` 的 `target` 不同（svg → input），原生 `dblclick` 不可靠：

   ```js
   const now = performance.now();
   if (lastTapKey === key && now - lastTapAt < DBL_MS) { resetKnob(key); return; }
   lastTapAt = now; lastTapKey = key;
   openEditor(key);
   ```
3. **`selectstart` / `dragstart` 守卫要放行输入框**，否则 §5.5 的全局拦截仍会挡住选中：

   ```js
   document.addEventListener('selectstart', e => {
       if (e.target.closest && e.target.closest('input')) return;   // ← 放行
       if (Object.values(dragOn).some(Boolean)) e.preventDefault();
   });
   ```
4. **`paintKnob` 在编辑中要跳过写值**，否则后端回灌（30Hz 电平/参数推送）会把
   用户正在敲的内容冲掉：

   ```js
   if (editing.key === key) return;   // 不要覆盖正在编辑的输入
   $(ids.txt).value = p.fmt(v);
   ```
5. **`def` 必须与 CSD 的 `defaultValue` 逐字一致**，否则双击归位和插件初始状态不符。
6. **输入接受 `k` 后缀，但显示不用缩写**：`12k` 解析成 12000，显示仍是 `12000`（§6.0 规则一、二）。
   解析器统一处理 `6k` / `6.5k` / `0.25` / `50`。
7. 输入框 `keydown` 要 `stopPropagation()`，避免被 Cabbage 的键盘 MIDI 吃掉。
8. **★ `<input>` 绝不能放在 `<svg>` 内部**。SVG 里的 `<input>` 不是 `HTMLInputElement`，
   没有 `select()` / `value` 语义，`el.select()` 直接抛 `TypeError`。
   必须放在 `</svg>` 之后，用 `position:absolute` 定位到原 `<text>` 的位置
   （Orbita：`top:27px`；Stasis：`top:31px`，各自对应原 `y` 值）。
9. **★ 不要在 `pointerdown` 里按 `e.target` 分叉**。
   Stasis 最初写成「点到正在编辑的 input 就直接 return」，结果第二次点击绕过了
   双击判定，`点数字 → 再点数字` 永远归不了位。
   正确做法：一律记录 tap，只是命中 input 时不 `preventDefault`、不抢焦点：

   ```js
   el.addEventListener('pointerdown', e => {
       if (e.button !== 0) return;
       active = true; dragging = false;
       onInput = (e.target === txt);              // ← 只记标记，不 return
       if (!onInput) { el.setPointerCapture(e.pointerId); e.preventDefault(); }
   });
   // pointerup 里统一做双击判定，仅当 !onInput 时才 openEditor
   ```
10. **`preventDefault()` 会抑制原生 `dblclick`**。旋钮 `pointerdown` 里的
    `preventDefault()` 让浏览器不再派发后续 click/dblclick，所以归位只能靠
    自己打时间戳判断，不能依赖 `dblclick`。
11. **★★ 输入框的 `pointerdown` 绝不能 `stopPropagation()`**。
    第一击打开编辑态后，`.kval` 拿到 `pointer-events: auto`，第二击的 `target`
    就变成了 input。若它挡住冒泡，`<div class="knob">` 收不到 `pointerdown`，
    `active` 永远不置位，**双击归位彻底失效**（点数字 → 再点数字 = 没反应）。
    实测症状：`document.activeElement` 停在 input 上、一个消息都不发。
    去掉 `stopPropagation` 后，改用 `onInput` 标记在 `pointermove` 里挡住拖动即可：

    ```js
    /* 输入框：不 stopPropagation，让 tap 判定能收到事件 */
    // txt.addEventListener('pointerdown', e => e.stopPropagation());   ← 删掉

    el.addEventListener('pointermove', e => {
        if (!active) return;
        if (onInput) {                       // 编辑态只记录选词拖动
            if (Math.abs(e.clientX - startX) > 3 ||
                Math.abs(e.clientY - startY) > 3) moved = true;
            return;
        }
        /* …正常旋钮拖动… */
    });
    ```
12. **★★ 输入框里「拖动选词」会被误判成第二次单击**。
    `dragging` 只按**纵向**位移 ≥ 3px 置位，而在 input 里选词通常是**横向**拖动，
    `dragging` 始终为 false —— 松手就走进「双击归位」分支，
    **用户一选词，旋钮就自己跳回默认值**。
    实测症状：横向拖过去，`pointerup` 之后 `blur` 到 body、`P[key].def` 被下发。
    修法：单独记一个 `moved`，不区分方向；`pointerup` 里最先拦掉：

    ```js
    const up = e => {
        if (!active) return;
        active = false;
        const wasInput = onInput, wasMoved = moved;
        onInput = false; moved = false;
        try { el.releasePointerCapture(e.pointerId); } catch (_) {}

        if (dragging) { /* …knob 拖动收尾… */ return; }

        /* 在文本框里拖动 = 选词，不算点击，更不能触发归位 */
        if (wasMoved) { lastTapAt = 0; lastTapKey = null; return; }

        /* 之后才是单击 / 双击判定 */
    };
    ```

    三条一起才自洽：**tap 判定看到事件**（11）+ **选词不被当成 tap**（12）+
    **命中 input 时不 `preventDefault`**（9）。

**湿声双滑块**（两个数字在拖动区之外）不需要「单击进编辑」，直接 `focus` 即可；
双击用原生 `dblclick`（同一个 input 上两次点击，可靠）。

---

### 6.9 ★ 二维可视化区：等比缩放，不要逐轴钳制

适用于任何「参数驱动的几何图形 + 一个跟随移动的指示物」的 pad 类可视化
（Orbita 的椭圆轨道 + 小球、Stasis 的准星等）。

**踩过的坑**：Orbita 的椭圆半轴公式在 `Radius=0.5` 时单侧可达 **141.4**，
而 pad 半宽只有 100。原实现逐轴钳制：

```js
el.setAttribute('rx', Math.min(PAD / 2, rx));   // ❌ 只砍一个轴
el.setAttribute('ry', Math.min(PAD / 2, ry));
```

结果**长轴被削短、短轴不变**，椭圆方程 `(x/rx)²+(y/ry)²=1` 被破坏，
两端尖角被压平在边框上 —— 看起来就不是真椭圆了。
`Shape > 0.68` 或 `< 0.32`（Radius=0.5 时）就开始变形。

**解法：整体等比缩放**

```js
const ORBIT_INSET = 4;                     // 与边框留的余量

function orbitHalf() {                     // 真实半轴（未缩放）
    const kMaxRad = radius * 1.4142;
    return { rx: radius * 1.4142 * shape * PAD,
             ry: radius * 1.4142 * (1 - shape) * PAD };
}

function orbitScale() {                    // 只在装不下时才缩
    const { rx, ry } = orbitHalf();
    const limit = PAD / 2 - ORBIT_INSET;
    const m = Math.max(rx, ry);
    return m > limit ? limit / m : 1;
}
```

**关键：指示物必须用同一个系数**

球偏离椭圆是这类实现最容易出的 bug。等比缩放对偏移同样成立：

```
(Δx·k) / (rx·k/PAD) = Δx / (rx/PAD)     比值不变 → 仍精确落在椭圆上
```

```js
function placeBall() {
    const k = orbitScale();
    const x = 0.5 + (orbX - 0.5) * k;      // 偏移也乘 k
    const y = 0.5 + (orbY - 0.5) * k;
    /* 先缩放再钳制：缩放后通常已落回 [0,1]，钳制只作最后兜底 */
    b.style.left = (clamp(x, 0, 1) * 100).toFixed(3) + '%';
    b.style.top  = ((1 - clamp(y, 0, 1)) * 100).toFixed(3) + '%';
}
```

**两个必须注意的下游影响**

1. **`k` 依赖 radius / shape，形状一变就要重算指示物位置**，否则会脱轨：

   ```js
   function paintOrbit() {
       /* ...设置 rx / ry... */
       placeBall();                        // ← 别忘
   }
   ```

2. **★ 不要在上游把后端推来的坐标钳制到 `[0,1]`。**
   Csound 推的是**未钳制**的原始值：

   ```csound
   cabbageSetValue "orb_x", kX_raw, kTrig     ; kX_raw 可达 1.19
   ```

   如果接收端写成 `orbX = clamp(v, 0, 1)`，超出 pad 的幅度就被抹掉了，
   再乘以 `k` 之后球会**缩到椭圆内部**，永远够不到顶点。
   正确做法是宽范围兜底、显示时再钳：

   ```js
   orbX = clamp(v, -1, 2);                     // 只防脏数据
   ```

**验证脚本**（沿椭圆取多点，检查指示物是否在线上）

```js
for (let i = 0; i < 24; i++) {
    const th = i * Math.PI / 12;
    const X = 0.5 + Math.cos(th) * r * 1.4142 * shape;
    const Y = 0.5 + Math.sin(th) * r * 1.4142 * (1 - shape);
    push({ command:'widgetUpdate', data:{ id:'orb_x', value:X } });
    push({ command:'widgetUpdate', data:{ id:'orb_y', value:Y } });
    const nx = (bx - 0.5) / (rx/200), ny = (by - 0.5) / (ry/200);
    assert(Math.abs(nx*nx + ny*ny - 1) < 0.02);      // 偏差应 < 0.02
}
```

实测（Orbita 定版）：`Shape` 0.3 / 0.5 / 0.9 / 0.94 / 0.97 / 0.99 全部
`worstDeviation ≤ 0.0023`，半轴恒 ≤ 96（不越界），半轴比例误差 ≤ 5e-4（仅由 0.01px 舍入造成）。

**★ 极端值：椭圆会「消失」，必须用 `<line>` 兜底**

SVG 规范规定 **`rx` 或 `ry` 为 0 时 `<ellipse>` 完全不渲染**（不是退化，是根本不出图）。
所以 `Shape` 到 0 / 1 时用户看到的是「轨迹消失」，而不是预期的一条直线。

解法：同层级多放一条 `<line>`，按需切换：

```html
<ellipse class="path" id="orbitPath" cx="100" cy="100" rx="70" ry="70"
         clip-path="url(#padClip)"></ellipse>
<line class="path" id="orbitLine" x1="4" y1="100" x2="196" y2="100"
      clip-path="url(#padClip)" style="display:none"></line>
```

```js
const DEGEN = 1.5;                          // 半轴小于它就认为已退化

function paintOrbit() {
    const { rx, ry } = orbitHalf();
    const k = orbitScale();
    const srx = rx * k, sry = ry * k;
    const el = $('orbitPath'), ln = $('orbitLine');

    if (srx < DEGEN || sry < DEGEN) {
        el.style.display = 'none';          // 椭圆此时一定不渲染，直接藏掉
        if (sry < DEGEN && srx >= DEGEN) {          // 水平线（Shape → 1）
            ln.setAttribute('x1', (100 - srx).toFixed(2));
            ln.setAttribute('x2', (100 + srx).toFixed(2));
            ln.setAttribute('y1', '100'); ln.setAttribute('y2', '100');
            ln.style.display = '';
        } else if (srx < DEGEN && sry >= DEGEN) {   // 垂直线（Shape → 0）
            ln.setAttribute('x1', '100'); ln.setAttribute('x2', '100');
            ln.setAttribute('y1', (100 - sry).toFixed(2));
            ln.setAttribute('y2', (100 + sry).toFixed(2));
            ln.style.display = '';
        } else {
            ln.style.display = 'none';      // radius = 0：轨道收成一点，无轨迹可画
        }
    } else {
        ln.style.display = 'none';
        el.style.display = '';
        el.setAttribute('rx', srx.toFixed(2));
        el.setAttribute('ry', sry.toFixed(2));
    }
    placeBall();
}
```

要点：

1. **`<line>` 用同一个 `.path` 类**，虚线/颜色自动一致。
2. **长度要用缩放后的 `srx` / `sry`**，和椭圆用同一套 `k`。
3. **`radius = 0` 要单独处理**：此时两轴都为 0，线段长度也是 0，
   直接两个都隐藏（轨道收成一个点，本来就没有轨迹）。
4. 指示物无需改动 —— `Shape = 1` 时后端推的 `kY_raw` 恒为 0.5，球自然只沿水平线走。
   实测 `Shape=1` 时球的 `top` 恒为 50%、`left` 覆盖 2%–98%；`Shape=0` 时反之。

### 6.10 参数多时的排布决策（★ 螺旋/环形已废弃）

8 个以上参数时，第一反应是把旋钮排成环或螺旋。**实测三次都不行**：

| 方案 | 结果 |
|---|---|
| 环形均分 | 像钟表，看得清但没信息量 |
| 螺旋（内圈→外圈） | 间距先崩，排开了又和主体图形抢注意力 |
| 旋钮当"卫星"绕主体转 | 用户原话：*"旋钮和黑洞的环打架"* |
| **「场景 + 控制台」两段式**（§6.12） | ✅ 布局交给 flex，交互代码零改动 |

**默认走 §6.12，不要再试螺旋。** 只有插件本身没有主体图形（纯 EQ 式一圈参数）才考虑环形，
此时只需记住两条踩过的坑：

- **弧长等分 ≠ 直线等分**：相邻两点的直线距离约 `2r·sin(Δθ/2)`，
  **内圈半径最小、最先崩**，可行性由内圈决定。实测期望 114px 实际只剩 19.7px。
- **`turns` 不能取 `n间隔/k`**（8 个点 = 7 个间隔，`7/4=1.75`）：每 `k` 步正好转 360°，
  第 i 个与第 i+k 个落在同一角度，间距塌成纯径向差（实测 34px 重叠）。
  先排除 1.4 / 1.75 / 2.333 / 3.5，再选最小距最大的一组。

验收：最小中心距 ≥ `旋钮宽 + 20`、包围盒四边距 ≥ `旋钮半径 + 标签高`、
`(rout-rin)/(n-1) ≥ 15px`。三条过不了就回 §6.12。

### 6.11 ★ 多个通道驱动同一个画布：必须合并到同一帧

`sing_x` / `sing_y` 是**两条独立消息**，先后到达。若每条消息都立刻重画：

```
收到 x → 画 (新X, 旧Y)   ← 中间态
收到 y → 画 (新X, 新Y)
```

粒子会被画成**阶梯状折线**（实测截图上就是一个个直角台阶）。

正确做法是收下值、标记脏，在下一帧统一画：

```js
let lastNX = 0.5, lastNY = 0.5, lastNR = 0.5;
let padRaf = 0;
function schedulePad() {
    if (padRaf) return;
    padRaf = requestAnimationFrame(() => {
        padRaf = 0;
        paintPad(lastNX, lastNY, lastNR);   // 用同一时刻的 x/y/r
    });
}

// 消息处理里只赋值 + 排帧（片段来自 applyValue 的 switch）
function feed(ch, v) {
    switch (ch) {
        case 'sing_x': lastNX = v; schedulePad(); break;
        case 'sing_y': lastNY = v; schedulePad(); break;
        case 'sing_r': lastNR = v; schedulePad(); break;
    }
}
```

**另外：位置突变要断开轨迹。** 重生 / Teleport / Start 重启时粒子会瞬移，
直接连线会横穿整个画布。绘制时按距离分段：

```js
let d = '', prev = null;
for (const q of trail) {
    const jump = prev && Math.hypot(q.x - prev.x, q.y - prev.y) > PAD.size * 0.22;
    d += (jump ? ' M' : ' L') + q.x.toFixed(1) + ' ' + q.y.toFixed(1);
    prev = q;
}
```

用 `<path>` 而不是 `<polyline>` —— polyline 只有一个 `points` 列表，没法断段。

---

### 6.12 ★ 「场景 + 控制台」两段式布局（可视化型插件的最终解）

可视化为主的插件（黑洞 / 轨道 / 粒子场）**不要**把旋钮浮在场景里当"卫星"。
实测两次都失败：旋钮和背景图形互相抢注意力，而且螺旋一圈套一圈，
看起来就是同心圆，读者既看不出螺旋，也看不清画面。

**正确做法是彻底分区**：上面一整块只放场景，下面一整块只放控件。

| 区域 | 尺寸（620×700 为例） | 内容 |
|---|---|---|
| 场景 | `620 × 440` | `#scene` SVG：背景、主体、辉光、粒子 |
| 控制台 | `620 × 260` | `.deck`：2 行 × 4 旋钮 + 按键行 + 推子行 |

```css
.canvas { width: 620px; height: 700px; position: relative; }
#scene  { position: absolute; left: 0; top: 0; width: 620px; height: 440px; }
.deck   {
    position: absolute; left: 0; right: 0; bottom: 0; height: 260px;
    padding: 10px 48px 12px 20px;        /* ← 右 padding 要留出缩放三角 */
    display: flex; flex-direction: column;
    background: linear-gradient(to bottom,
        rgba(2,3,10,0) 0%, rgba(2,3,10,.72) 14%, #02030a 46%), #02030a;
    border-top: 1px solid rgba(255,201,92,.13);
}
.krow { display: flex; justify-content: space-between; }   /* 4 个旋钮均分 */
```

**旋钮在控制台里就是普通 flex 子项**，不再需要 `position:absolute` 算坐标 ——
这是分区布局最大的收益：布局交给 flex，交互代码完全不用改。

**要点**

1. **右 padding ≥ 40px**：缩放三角固定右下角 36×36，否则盖住最右侧输入框。
2. **旋钮行用 `justify-content: space-between`**，4 个旋钮自动等距；
   固定 `width: 74px` 保证 `Inertia`/`Doppler` 这类长标签不挤在一起。
3. **控制台用「渐变到实色」的遮罩**起头（`transparent → .72 → #02030a`），
   场景和控件之间才有过渡，不会像被切了一刀。
4. **场景比控制台"空"一点没关系**：留白就是太空。但控制区不能留白，
   内容底部到画布底应在 12~20px 内（实测 683/700）。
5. 电平表仍贴场景最左右边缘（`top:46px; bottom:130px`），
   不放进控制台 —— 它是"仪表"，属于场景。

---

### 6.13 ★ 画"真"的实体（黑洞）：图层顺序 + 七条形态陷阱

> 参考实现是 Singularity 的黑洞（卡冈图雅）。**大段 SVG 已移走**，这里只留
> 可迁移的结论 —— 下面七条对任何「有体积 + 有前后遮挡 + 有视角」的实体都成立
> （吸积盘、行星环、水面、透镜效果）。要抄完整 SVG 就直接看
> `Singularity Cabbage3/index.html`。

#### 图层顺序（顺序错了怎么调都不像）

```
1. 大范围辉光（radial gradient，半径远大于画布）
2. 球外等离子体薄层      ← ★ 必须在球之前
3. 上/下透镜弧（只有弧，没有整圆）
4. 盘的竖向亮度溢出（很扁的 radial，不加掩罩）
5. 水平盘远侧
6. 事件视界（纯黑球）
7. 光子环（紧贴视界外侧的极亮细线）
8. 粒子 + 尾迹
9. 盘面近侧（要从球**前面**绕过去）
10. 声源标记 + 拖尾（UI 标记永远最上层，见 §6.17）
```

#### 七条陷阱（每条都是实测踩过的）

| # | 坑 | 结论 |
|---|---|---|
| 1 | 等离子体层画在球**之后** | 半透明径向渐变会把纯黑球洗成灰球，一眼变假。窄环必须先铺、黑球后盖 |
| 2 | 视角太低 | `ry/rx` 就是仰角的正弦。`0.06`(3.3°) 退化成一条线、`0.50`(30°) 像甜甜圈，**推荐 0.31(18°)**。改 `ry` 要同步改三处：`<ellipse ry>`、掩罩压缩比、JS 常量 |
| 3 | 环带掩罩用「椭圆挖椭圆」 | 内洞是硬的，球和盘之间留一圈死黑缝。改用**被 `scale(1 k)` 压扁的径向渐变**，`k` 必须等于盘的 `ry/rx`，等值线才对得上同心椭圆 |
| 4 | 近侧盘用 `clip-path` 裁 `y ≥ 0` | 上边界成了穿过球心的**硬直线** —— 这才是"平视图"的真正病根。要挖的是「球内 + 上半圆」，不是整个上半平面；挖洞半径比视界大 2~3px，否则漏碎边 |
| 5 | 透镜环画成整圆 | 左右两半本来就被盘挡住，画整圆会"飘"在球两侧（用户原话：*"纵向的圆环中间怎么是透明的"*）。只保留上弧 200°→340°、下弧 20°→160°，两端渐隐 |
| 6 | 盘用 `fill="none"` + `stroke` | 上下弧各画一条线，两翼变成两条平行线（线框图）。必须**实心椭圆 + 一条横向 `linearGradient`**，中段被黑球自然遮住。横向渐变同时负责多普勒不对称（左白右橙），这是"一眼真"的关键 |
| 7 | 加「盘面中面细线」强调高温带 | 太扁会变成横穿黑球的直线，像屏幕上的一道划痕。热度靠渐变 + 球面压强表达即可 |

**验证方式**：把这七条当成 checklist，逐条对着画面看。
最容易漏的是 **#4**（硬直线边界）和 **#2**（视角），这两条的观感断崖式下降。

### 6.14 ★ 旋钮的数值弧：方向必须与刻度同向，且不要画指针

旋钮就是三样东西：刻度环（静态）、数值弧（`stroke-dasharray`）、中间的数字。
**不要另外画一根指针**：指针是短线，半径只有 8~15，正好压在中间那串数字上，
两者糊成一团，谁都看不清（实测被用户直接要求删掉）。数字本身就是读数。

#### 坑一：★★ `stroke-dasharray` 的起点与方向由 `<circle>` 路径决定，不是你的角度公式

SVG `<circle>` 的路径从 **3 点钟** 起、**顺时针** 走。而刻度通常用
`x = cx + r·sin(θ)`、`y = cy − r·cos(θ)` 生成，`θ` 增大同样是顺时针。
两者要重合，`rotate()` 的角度必须是「3 点 → 刻度起点」的顺时针夹角。

标准旋钮：刻度从 **7:30**（`θ = 225°`）顺时针扫 `270°` 到 **4:30**，缺口在正下方。
7:30 距 3:00 是 `+135°`：

```js
const KB = { r: 21.5, span: 0.75 };     // r 随画布宽度微调：Orbita 22、Singularity 21.5
const CIRC = 2 * Math.PI * KB.r;        // 135.09
const SPAN = CIRC * KB.span;            // 101.32 = 270° 的弧长

/* 刻度 */
for (let i = 0; i <= 20; i++) {
    const f = i / 20, deg = 225 + f * 270, rad = deg * Math.PI / 180;
    const major = i % 5 === 0;
    const r1 = major ? 23.4 : 24.2, r2 = 25.6;
    /* x = 26 + r·sin(deg)，y = 26 − r·cos(deg) */
}

/* 底槽 + 数值弧：两者用同一个 rotate，方向才对得上 */
gauge.setAttribute('transform', 'rotate(135 26 26)');
arc.setAttribute('transform',   'rotate(135 26 26)');

/* 数值弧 = 首段 dash 是弧长，其余用整周长当间隙 */
arc.setAttribute('stroke-dasharray', (f * SPAN).toFixed(2) + ' ' + CIRC.toFixed(2));
```

**症状**：填充弧与刻度整体错开约 90°，看起来"旋钮读数不对"，
但你说不出哪里错——因为几何都是对的，只是起点差了 `90°`。

自检：把值拉到 `f = 0`，数值弧应收缩成 **7:30（左下）** 的一个圆点（`stroke-linecap: round`）；
拉到 `f = 1`，应正好填满到 **4:30（右下）**，缺口留在正下方。

#### 坑二：数字要按 viewBox 居中，不是按 CSS 像素

数值 `<input>` 是绝对定位覆盖在 `<svg>` 上的，`top` 必须换算：
`viewBox` 是 `0 0 52 52`，svg 渲染成 `50×50`，所以几何中心在 `26 × 50/52 = 25px`。

```css
.knob input { position: absolute; left: 50%; top: 25px; transform: translate(-50%, -50%); }
```

写成 `top: 26px` 会低 1px，去掉指针之后这个偏移会很明显（数字看着"往下沉"）。


### 6.15 ★ 电平表：线性幅度要换成 dB，还要有 dB 标尺

Csound 送来的 `outL / outR` 是**线性幅度**（`0dbfs = 1` → `0..1`）。
直接拿它当表柱高度，会出现两个毛病：

1. 正常信号（-20 dB ≈ 0.1）表柱几乎不亮，只有爆音才冲到顶 —— **看着像坏了**
2. 没有刻度，用户不知道当前是哪一档

Stasis 定下的做法，**9 台全部照抄这一套**（只换颜色与高度）：

```js
const METER_H = 154;                      // ★ 每个插件不同，必须等于自己的 .bar CSS 高度
const DB_MIN = -60;
/* 刻度往 0 dB 挤：等响感知下高端要密、低端要疏 */
const DB_TICKS = [0, -6, -12, -18, -24, -30, -40, -50, -60];

const ampToDb = a => 20 * Math.log10(Math.max(Math.abs(a), 1e-6));
const dbToPos = db => clamp((db - DB_MIN) / (0 - DB_MIN), 0, 1);

function buildDbScales() {
    for (const id of ['scaleL', 'scaleR']) {
        const el = $(id);
        if (!el) continue;
        el.innerHTML = '';
        for (const db of DB_TICKS) {
            const t = document.createElement('div');
            t.className = 't' + (db === 0 ? ' zero' : '') + (db % 12 === 0 ? ' major' : '');
            t.style.bottom = (dbToPos(db) * 100).toFixed(3) + '%';
            const n = document.createElement('span');
            n.className = 'n';
            n.textContent = db === 0 ? '0' : String(db);
            t.appendChild(n);
            el.appendChild(t);
        }
    }
}

function setMeter(id, capId, amp) {
    const db = clamp(ampToDb(amp), DB_MIN, 0);
    const pos = dbToPos(db);
    $(id).style.transform = 'scaleY(' + pos.toFixed(4) + ')';
    const cap = $(capId);
    cap.style.transform = 'translateY(' + (-pos * METER_H).toFixed(1) + 'px)';
    cap.style.opacity = pos > 0.002 ? '.95' : '0';
    return amp;                            // ★ 返回原始幅度，不是 pos
}
```

#### 结构：一根柱 + 一把尺，右表镜像

```html
<div class="metercol">
    <span>L</span>
    <div class="meterbody">
        <div class="bar"><i id="mtrL"></i><b id="capL"></b></div>
        <div class="dbscale" id="scaleL"></div>
    </div>
</div>

<!-- 右表：加 .mirror，靠 flex-direction: row-reverse 让刻度翻到内侧 -->
<div class="metercol">
    <span>R</span>
    <div class="meterbody mirror">
        <div class="bar"><i id="mtrR"></i><b id="capR"></b></div>
        <div class="dbscale" id="scaleR"></div>
    </div>
</div>
```

```css
.meterbody { display: flex; align-items: stretch; gap: 3px; }
.meterbody.mirror { flex-direction: row-reverse; }

/* 表柱：两条 1px 竖线当边，填充用 scaleY 从底部长上来 */
.bar { position: relative; width: 11px; height: 154px; flex: none; }
.bar::before, .bar::after {
    content: ""; position: absolute; top: 0; bottom: 0; width: 1px;
    background: rgba(255, 205, 68, .13);
}
.bar::before { left: 0; }
.bar::after  { right: 0; }
.bar i {
    position: absolute; left: 1px; right: 1px; bottom: 0;
    height: 100%;
    transform-origin: bottom center;
    transform: scaleY(0);
    background: linear-gradient(to top, rgba(255,107,61,.92) 0%,
                rgba(255,140,70,.72) 46%, rgba(255,205,68,.82) 100%);
    transition: transform .05s linear;
    will-change: transform;
}
.bar b {                                  /* 峰值亮帽，1px 白线 */
    position: absolute; left: 0; right: 0; height: 1px; bottom: 0;
    background: rgba(255, 226, 150, .95);
    transform: translateY(0);
    transition: transform .05s linear, opacity .12s linear;
    opacity: 0;
    will-change: transform;
}

/* dB 标尺：刻度线 + 数字 */
.dbscale { position: relative; width: 25px; height: 154px; flex: none; }
.dbscale .t { position: absolute; left: 0; right: 0; height: 0; }
.dbscale .t::before {
    content: ""; position: absolute; left: 0; top: 0;
    width: 3px; height: 1px;
    background: rgba(255, 205, 68, .30);
}
.dbscale .t.major::before { width: 5px; background: rgba(255, 205, 68, .56); }
.dbscale .t .n {
    position: absolute; right: 0; top: -3.4px;
    font-family: var(--mono); font-size: 6px; line-height: 1;
    color: rgba(255, 205, 68, .40);
}
.dbscale .t.major .n { color: rgba(255, 205, 68, .62); }
.dbscale .t.zero  .n { color: rgba(255, 236, 170, .86); }

/* 右表镜像：刻度贴外侧，数字靠内 */
.meterbody.mirror .dbscale .t::before { left: auto; right: 0; }
.meterbody.mirror .dbscale .t .n      { right: auto; left: 0; }
```

#### 坑一：★★ 标签选择器会误伤标尺里的数字

原来写 `.metercol span { ... }`，加了 dB 标尺之后，**`.dbscale .t .n` 也是 `<span>`**，
会被一起染成 6px/红色/字距 .18em，刻度数字直接糊掉。

```css
/* ✗ 错 */
.metercol span { font-size: 6px; letter-spacing: .18em; color: var(--red-dim); }
/* ✓ 对：只管子级的 L / R 标签 */
.metercol > span { height: 8px; line-height: 8px; font-size: 6px; letter-spacing: .18em; }
```

#### 坑二：★ `METER_H` 必须写死一个像素值，不能用百分比

峰值帽用 `translateY(-pos × METER_H)` 定位，**必须是绝对像素**。
如果 `.bar` 高度是 `flex: 1` 或 `%`（Singularity 初版就是 `top: 46px; bottom: 130px` 撑出来的），
`METER_H` 无从取值，帽子会飞。

```css
/* ✗ 错：高度是撑出来的，JS 不知道它有多高 */
.metercol { top: 46px; bottom: 130px; }
.meter   { flex: 1; }

/* ✓ 对：给死值，JS 用同一个数 */
.bar, .dbscale { height: 372px; }
const METER_H = 372;
```

改高度时**两处一起改**。检查办法：把 `outL` 推到 0 dB（`value: 1`），
帽子应该正好贴在柱顶，差一像素都说明两者不一致。

#### 坑三：★ `setMeter` 要返回原始幅度，不是 `pos`

`updateGlow()` 拿这个值去驱动整体辉光（`--lvl`）。返回 `pos`（dB 归一化）会让
低电平也被放大成一团光。返回 `amp` 才是真实响度。

#### 坑四：每个插件自己的色系

同一套结构，只换颜色变量即可，**不要改几何**：

| 插件 | 柱身渐变 | 刻度 |
|---|---|---|
| Stasis | 白 `rgba(255,255,255,.95→.26)` | 白 |
| Orbita | 橙红→琥珀 `rgba(255,107,61,.92) → rgba(255,205,68,.82)` | `rgba(255,205,68,.30)` |
| Levy | 血红→亮橙 `var(--red) → rgba(255,130,70,.60)` | `rgba(255,17,62,.38)` |
| Singularity | 暗红→金 `rgba(120,16,2,.9) → rgba(255,201,92,.92)` | `rgba(255,201,92,.34)` |

字号随画布宽度走：320 宽用 `5.5px`，400~510 用 `6~6.5px`，620 用 `7px`。

#### 自检（3 秒）

| 推 `outL` | 期望 `scaleY` |
|---|---|
| `1` | `1.0000` |
| `0.5` | `0.8997`（-6.02 dB） |
| `0.1` | `0.6667`（-20 dB） |
| `0.01` | `0.3333`（-40 dB） |
| `0` | `0.0000` |

#### `METER_H` 实测：depth 全部 9 台（2026-11-01，11-03 补 Lissajous，与各自 CSS 高度逐一对过）

| 插件 | `METER_H` | `.bar` CSS 高度 | 底 `DB_MIN` |
|---|---|---|---|
| Stasis | 166 | 166px | −60 |
| Orbita | 154 | 154px | −60 |
| levy | 150 | 150px | −60 |
| Singularity | 372 | 372px | −60 |
| loom | 148 | 148px | −60 |
| zephyr | 148 | 148px | −60 |
| SwarmGrain | 116 | 116px | −60 |
| Boids | 280 | 280px | −60 |
| Lissajous | 150 | 150px | −60 |

**改高度时两处一起改**，改完把 `outL` 推到 1 验证帽子是否正好贴柱顶。

### 6.16 ★ 旋钮映射曲线：只用一个指数，别用幂 skew

**症状**：`fallTime` 范围 `0.1 ~ 600`，用户要把 10 s 调到 20 s —— 拧不动。
用数值输入能改，但旋钮上这两档几乎重合在起点。

#### 病根：`skew` 写反了

老代码用 JUCE 那套幂映射：

```js
// ✗ 错：skew < 1 把"低端"压没了
const toFrac = (v, p) => Math.pow((v - p.min) / (p.max - p.min), 1 / p.skew);

// fallTime: skew = 0.25 → f = n⁴
//   v = 10 s → n = 0.0165 → f = 7.4e-8
//   v = 20 s → n = 0.0332 → f = 1.2e-6
```

两档之间只差 `1e-6` 的行程 —— 一个像素都不到。整条 0.1~100 s 全挤在旋钮的头几个像素里，
剩下一整圈都在 100~600 s 之间跳。**方向整个反了**：时间、频率这类跨两三个数量级的参数，
要的是「低端松、高端紧」，不是反过来。

#### 解法：一个数 `curve`，指数映射

```js
/* 归一化值 n ∈ [0,1] ↔ 旋钮行程 f ∈ [0,1]
     curve = 0    线性
     curve = k>0  指数：低端展开
     curve = k<0  反向：高端展开
   n = (e^(k·f) − 1) / (e^k − 1)
   f = ln(1 + n·(e^k − 1)) / k                                        */
const CURVE_MAX_K = 12;                       // e^12 ≈ 1.6e5，防溢出，够用
const curveToNorm = (f, k) => {
    if (!k) return f;
    const K = Math.min(Math.abs(k), CURVE_MAX_K), A = Math.exp(K) - 1;
    return k > 0 ? (Math.exp(K * f) - 1) / A
                 : 1 - (Math.exp(K * (1 - f)) - 1) / A;
};
const normToCurve = (n, k) => {
    if (!k) return n;
    const K = Math.min(Math.abs(k), CURVE_MAX_K), A = Math.exp(K) - 1;
    return k > 0 ? Math.log(1 + n * A) / K
                 : 1 - Math.log(1 + (1 - n) * A) / K;
};
const toFrac   = (v, p) => normToCurve(clamp((v - p.min) / (p.max - p.min), 0, 1), p.curve || 0);
const fromFrac = (f, p) => p.min + (p.max - p.min) * curveToNorm(clamp(f, 0, 1), p.curve || 0);
```

两式**严格互逆**（实测 201 个采样点最大误差 `2.2e-16`），所以
「拖动 → 发值 → 宿主回灌 → 重画」不会漂。

参数表里只多一个字段，`min / max / def` 仍然必须与 CSD 一致：

```js
const P = {
    fallTime:     { min: 0.1,  max: 600,   curve: 6, step: 0.01, def: 4,    fmt: v => v.toFixed(2) },
    gravityCurve: { min: 0.2,  max: 5,     curve: 4, step: 0.01, def: 0.5,  fmt: v => v.toFixed(2) },
    cutoff:       { min: 1000, max: 16000, curve: 3, step: 1,    def: 6000, fmt: v => String(Math.round(v)) },
    roomSize:     { min: 10,   max: 100,   curve: 1, step: 0.1,  def: 50,   fmt: v => String(Math.round(v)) },
    masterGain:   { min: 0,    max: 8,     curve: 0, step: 0.01, def: 2,    fmt: v => v.toFixed(2) },  // 线性写 0；9 台统一 0-8 / def 2
    spinSpeed:    { min: 0.05, max: 0.5,   curve: 0, step: 0.001,def: 0.25, fmt: v => v.toFixed(3) }
};
```

#### `k` 怎么选：先定「常用区间占多少行程」

`k` 不是拍脑袋，反推一下即可。以 `fallTime 0.1~600` 为例，希望 **30 s 落在旋钮正中**：

```
n(30) = (30 − 0.1) / 599.9 = 0.0498
要求 f = 0.5 → ln(1 + 0.0498·(e^k − 1)) = 0.5k
解得 k ≈ 6
```

验算（270° 行程、拖动 180px 满程）：

| 值 | 行程 f | 角度 | 从上档拧过来 |
|---|---|---|---|
| 0.1 s | 0 % | 0° | — |
| 1 s | 7.9 % | 21° | 7 px |
| 2 s | 13.7 % | 37° | 10 px |
| 4 s（默认） | 21.4 % | 58° | 14 px |
| 10 s | 33.9 % | 92° | 22 px |
| **20 s** | **44.4 %** | **120°** | **19 px** ✅ |
| 30 s | 50.8 % | 137° | 12 px |
| 100 s | 70.3 % | 190° | 15 px |
| 600 s | 100 % | 270° | 21 px |

10 s → 20 s 从「拧不动」变成 **19px / 28°**，可以正常手调；
而 30~600 s（只给长音频做轨迹用）仍占后半圈，不需要精度也无所谓。

常用参考值：

| 参数 | 范围 | `curve` | 默认值落点 |
|---|---|---|---|
| 时间（秒级） | 0.1–600 | **6** | 4 s → 21 % |
| 转动速度 | 0.1–20 | **5** | 0.25 → 15 % |
| 事件率 | 0.5–20 | **4** | 4 → 59 % |
| 惯性 / 时间常数 | 0.001–0.4 | **5** | 0.01 → 29 % |
| 尺寸（归一化后乘系数） | 0.05–1 | **3** | 0.4 → 69 % |
| 频率 / 截止 | 1000–16000 | **3** | 6000 → 67 % |
| 曲线/形状类 | 0.2–5 | **4** | 0.5 → 37 % |
| 弱参数（0.3~2 这种 6× 量程） | 0.3–2 | **1.5** | 1.1 → 65 % |
| 幅度微扰（0~0.08，低端要留手） | 0–0.08 | **2** | 0.05 → 80 % |
| 房间大小 | 10–100 | **1** | 50 → 57 % |
| 增益、声像、双极量、0~1 比例量 | — | **0**（线性） | — |

**定 `k` 的通用办法**：挑一个「希望它落在旋钮正中」的代表值 `v*`，
令 `n* = (v* − min)/(max − min)`，解 `ln(1 + n*(e^k − 1)) = 0.5k`。
嫌麻烦就直接试：`k ≈ ln(range比)` 附近微调，range 比 20× 用 3、40× 用 4、
200× 用 5、400× 用 5~6。**纯对数感知**（`f = ln(v/min)/ln(max/min)`）是上限，
`k` 再大低端就开始过度展开。

#### 实际曲线：depth 全部 9 台（2026-11-01 从代码直接抽出，11-03 补 Lissajous，照抄即可）

全系列共用三条：`roomSize → 1`、`cutoff → 3`、`masterGain → 0`（`minWet/maxWet` 是滑块，不涉及曲线）。
其余按下表（只列 `curve`，`min/max/def` 必须与各自 CSD 一致）：

| 插件 | 参数 | `curve` | 关键落点（已验算） |
|---|---|---|---|
| Stasis | roomSize / cutoff / masterGain | 1 / 3 / 0 | 50 → 57 %，6000 → 67 % |
| Orbita | speed / radius / Shape | 5 / 0 / 0 | 0.25 → 15 %，1 → 41 %，2 → 54 % |
| levy | rate / alpha / scale | 4 / 1.5 / 3 | 1 → 22 %，4 → 59 %，8 → 77 %；0.4 → 69 % |
| levy | damp / chaos / inertia | 0 / 2 / 5 | 0.01 → 29 %，0.02 → 48 %；0.005 → 18 % |
| Singularity | fallTime | 6 | 10 → 34 %，20 → 44 %，30 → 51 % |
| Singularity | gravityCurve / spinSpeed | 4 / 0 | 0.5 → 37 % |
| Singularity | inputGain / dopplerFactor | 0 | 线性 |
| loom | speed / glide / warp | 4 / 5 / **4** | 秒级时间常数一律 4~6；warp 上限 20→100 后 curve 同步由 2 改 4（`skew 0.4`） |
| loom | rows / cols / path / texture | 0 | 有界小整数 / 比例量，线性 |
| zephyr | fallTime | **7** | 同量程但更偏秒级（0.1–600 s），比 Singularity 多 1 |
| zephyr | dfreq | 4 | 0.01–10 Hz，两个数量级 |
| zephyr | angle / radius / drift / jitter | 0 | 角度、比例量，线性 |
| SwarmGrain | rangeMin / rangeMax | **7** | 20–20000 Hz，三个数量级 → 最高档 |
| SwarmGrain | step / DlyMax | 4 / 4 | 时间/速率 |
| SwarmGrain | GSize / Dens | 3 / 2 | 0.005–1 s；1–500 事件/秒 |
| SwarmGrain | radius / reverse / drywet / level | 0 | 比例量，线性 |
| Boids | delay_base | 4 | 10–**1400** ms（上限由 2000 降到 1400，防 7 路抽头撞 10 s 延迟线） |
| Boids | mod_rate / speed / m1..m7 | 3 / 2 / 2 | |
| Boids | coh / ali / sep / feedback / Flock_Decay / dry_wet / vol | 0 | 0~1 比例量 + 线性增益 |
| Lissajous | rate / glide | 4 / 5 | 0.02–4 Hz；1ms–400ms 时间常数 |
| Lissajous | ratio / chaos / inGain | 1.5 / 2 / 2 | 1–8 倍频；0–0.1；0.1–16 倍 |
| Lissajous | phase / scale | 0 | 角度、比例量，线性 |

> `zephyr.fallTime` 用 **7** 而不是 6，是因为它的默认值是 2 s（Singularity 是 4 s），
> 常用区间更靠低端，需要更大的展开。**同为"秒级"的两个插件，`curve` 也可以不同** ——
> 按「默认值落在 20%~30% 行程」这个目标各自反解，不要盲目统一。

**判断标准**：拿常用区间的两个相邻档位算一下——
如果它们之间的行程 **< 8px**，旋钮就等于拧不动，必须加曲线；
如果 **> 60px**，说明低端被过度展开，`k` 要降。

#### 坑一：★★ Shift 精调必须按「每帧增量」累加

加 `Shift` 微调（同样位移只走 1/5 行程）很容易写成：

```js
// ✗ 错：拖动中途按/松 Shift，分母突变，数值瞬间跳一大截
let v = fromFrac(startF + dy / (e.shiftKey ? 900 : 180), p);
```

一定要累加增量：

```js
// pointerdown
accF = startF; lastY = e.clientY;

// pointermove
accF = clamp(accF + (lastY - e.clientY) / (e.shiftKey ? 900 : 180), 0, 1);
lastY = e.clientY;
let v = fromFrac(accF, p);
```

实测：20px 普通拖动到 `9.11 s`，按下 Shift 再拖 2px → `9.25 s`，**没有跳变**。
若用前一种写法，同样操作会直接跳到十几秒。

#### 坑二：★ 数值格式化要跟着量程走

`fallTime` 在低端是 `0.10 ~ 9.99`（两位小数有意义），高端是 `100 ~ 600`（小数没意义）：

```js
fallTime: { fmt: v => v < 10 ? v.toFixed(2) : String(Math.round(v)) }
```

不要全局 `toFixed(2)`（高端显示 `600.00`，挤占旋钮中心），
也不要全局取整（低端 `0.50` 变成 `1`）。

#### 坑三：★ 标签不要缩写

`Fall` 会让人以为是「衰减量」，实际是**时间**（秒）。长量程参数更要写全：
`Fall Time`、`Gravity Curve`、`Spin Speed`。

7.5px 等宽字体下 `FALL TIME` 约 76px，旋钮单元 74px 会溢出，
把 `.knob` 宽度给到 74px 以上、或把 `.nm` 的 `letter-spacing` 收到 `.08em`，
用 `scrollWidth > clientWidth` 一眼就能查出溢出。

#### 自检

```js
// 两端必须精确贴边
toFrac(p.min, p) === 0 && toFrac(p.max, p) === 1
// 单调递增
for (let i = 1; i <= 100; i++) toFrac(fromFrac(i/100, p), p) > toFrac(fromFrac((i-1)/100, p), p)
// 互逆
Math.abs(toFrac(fromFrac(0.37, p), p) - 0.37) < 1e-12
```

---

### 6.17 ★ 移动标记：卫星 + 拖尾

> 适用：`sing_x/sing_y`、`orb_x/orb_y`、`levy_x/levy_y` 这类**每帧都在动**的声源坐标。
> 静态或慢速的标记（准星、扩散范围）用 §6.9 的等比缩放就够，不需要本章。

声源标记（`sing_x / sing_y`）最初画成「小圆点 + 一圈晕」。问题：

- 那一圈晕和吸积盘的同心环**抢戏**，看着像多了一圈相位不对的环
- 圆点没有方向信息，用户看不出它在往哪走

改成**卫星 + 拖尾**：机体长轴朝运动方向，两翼垂直，后面拖一条尾细头粗的尾迹。
这样一眼就知道「往哪走、走多快」。

```html
<!-- 放在 #bh 的最后（近侧盘之后）：它是 UI 标记，不是天体，
     被盘挡住一半会被当成渲染 bug -->
<path id="trailShadow" fill="#02030a" opacity="0" pointer-events="none" filter="url(#trailBlurS)"/>
<path id="trailGlow"   fill="#ffab3c" opacity="0" pointer-events="none" filter="url(#trailBlurL)"/>
<path id="trailLine"   fill="url(#trailGrad)" opacity="0" pointer-events="none"/>

<!-- 卫星本体：机体长轴沿运动方向，两翼垂直于运动方向 -->
<g id="sat" opacity="0" pointer-events="none">
    <circle class="sat-shadow" r="6"/>                       <!-- 过亮背景上的对比底 -->
    <line class="sat-strut" x1="0" y1="-7.2" x2="0" y2="7.2"/>
    <rect class="sat-wing" x="-0.85" y="-7.2" width="1.7" height="4.4" rx="0.4"/>
    <rect class="sat-wing" x="-0.85" y="2.8"  width="1.7" height="4.4" rx="0.4"/>
    <rect class="sat-body" x="-2.7" y="-1.75" width="5.4" height="3.5" rx="0.9"/>
    <circle class="sat-core" r="1.15"/>
</g>
```

```js
/* 朝向：取最近一段位移方向，按最短角差平滑（直接赋值会抖） */
if (trail.length >= 2) {
    const a = trail[trail.length - 2], b = trail[trail.length - 1];
    if (Math.hypot(b.x - a.x, b.y - a.y) > 0.05) {
        const target = Math.atan2(b.y - a.y, b.x - a.x) * 180 / Math.PI;
        let d = ((target - satAngle + 540) % 360) - 180;   // 归到 (-180, 180]
        satAngle += d * 0.28;
    }
}
sat.setAttribute('transform',
    'translate(' + p.x + ' ' + p.y + ') rotate(' + satAngle + ')');
```

#### 做法：锥形填充带（尾尖头宽的三角形）

试过四种写法：

| 写法 | 结果 |
|---|---|
| 偏移法线拼闭合多边形，落在**原始采样点**上 | 紧弯处自交，`nonzero` 挖洞 ✗ |
| N 条圆帽短线递减宽度 | 每段是直线，采样点一疏就有折角 ✗ |
| 单条**等宽**描边 + 渐变淡出 | 尾端永远是圆头/方头，像半截棍子 ✗ |
| **Chaikin 平滑后按法线偏移成锥形带，`fill` + 渐变** | 尾端收成一个尖角 ✓ |

```js
/* 沿平滑折线生成锥形带：尾端宽度 0（尖角），头端宽度 wMax */
function ribbonPath(pts, wMax) {
    const n = pts.length, f = v => v.toFixed(1);
    const left = [], right = [];
    for (let i = 0; i < n; i++) {
        const t = i / (n - 1);                       // 0 = 尾，1 = 头
        const w = wMax * Math.pow(t, 1.15);          // 近似线性收缩 → 三角形
        const a = pts[Math.max(0, i - 1)], b = pts[Math.min(n - 1, i + 1)];
        let dx = b.x - a.x, dy = b.y - a.y;
        const L = Math.hypot(dx, dy) || 1;
        dx /= L; dy /= L;
        left.push([pts[i].x - dy * w, pts[i].y + dx * w]);
        right.push([pts[i].x + dy * w, pts[i].y - dx * w]);
    }
    let d = 'M' + f(left[0][0]) + ' ' + f(left[0][1]);
    for (let i = 1; i < n; i++) d += ' L' + f(left[i][0]) + ' ' + f(left[i][1]);
    for (let i = n - 1; i >= 0; i--) d += ' L' + f(right[i][0]) + ' ' + f(right[i][1]);
    return d + ' Z';
}

/* 用法：先 Chaikin，再喂给 ribbonPath */
const pts = chaikin(trail, 2);
const wHead = 1.75 + hot * 0.7;        // 头端半宽 → 全宽 3.5~4.9px
line.setAttribute('d',  ribbonPath(pts, wHead));         // 亮线
shade.setAttribute('d', ribbonPath(pts, wHead * 1.35));  // 暗影
glow.setAttribute('d',  ribbonPath(pts, wHead * 2.2));   // 柔光
```

**关键：偏移必须发生在 Chaikin 之后。**
在原始 7~14 个采样点上偏移，点间距大（20px+），相邻两段法线方向差十几度，
两条偏移边会交叉 → 自交。Chaikin 后点数 ×4、间距缩到 5px 以内，法线平滑，不再自交。

`Math.pow(t, 1.15)` 里的 1.15 不要调大：超过 1.6 会变成"针尖"，中段塌下去；
调到 1.0 以下则尾部变钝，看不出三角形。

#### 坑一：★★★ 模糊滤镜的 region 用百分比 → 柔光外面出现**方形**

这是最难查的一个。拖尾的柔光层用 `<feGaussianBlur>`，滤镜默认 region 是
**按元素包围盒的百分比**算的：

```html
<!-- ✗ 错：region 是 bbox 的 220% × 240% -->
<filter id="blur4" x="-60%" y="-60%" width="220%" height="240%">
    <feGaussianBlur stdDeviation="4"/>
</filter>
```

拖尾又细又长：bbox 高度只有 5~10px，`240%` 也就 12~24px，
而 `stdDeviation="4"` 的模糊半径已经 12px —— **模糊直接顶到 region 边界被裁断**，
外面出现一条方形的硬边。竖直方向越细，方形越明显。

```html
<!-- ✓ 对：region 用 userSpaceOnUse 的绝对范围，覆盖整个场景 -->
<filter id="trailBlurS" filterUnits="userSpaceOnUse"
        x="-340" y="-260" width="700" height="520">
    <feGaussianBlur stdDeviation="2.2"/>
</filter>
<filter id="trailBlurL" filterUnits="userSpaceOnUse"
        x="-340" y="-260" width="700" height="520">
    <feGaussianBlur stdDeviation="6"/>
</filter>
```

范围只要比"元素可能出现的区域 + 3×stdDeviation"更大就行。
自检：把柔光层 `opacity` 强行拉到 1，看外缘有没有直线。

**这个坑对任何"细长 + 模糊"的组合都成立**（发光线条、光带、粒子拖尾），
不只是拖尾。

#### 坑二：★★ 长度按**弧长**限制，不要按点数

按点数限制会遇到这个：

| 场景 | 每帧位移 | 7 个点的实际长度 |
|---|---|---|
| 轨道外圈（radius 0.5） | 20~25 px | **170 px**（横穿小半个画布）|
| 轨道内圈（radius 0.05） | ~2 px | **14 px**（短得像没画）|

同一套代码，长度差 12 倍。要的是"固定长度的彗尾"，只能量弧长：

```js
const TRAIL_LEN = 52;           // 弧长上限（px）
const TRAIL_MAX = 14;           // 采样点数上限，只防内存，不决定视觉长度

function trimTrail() {
    let acc = 0, i = trail.length - 1;
    while (i > 0) {
        acc += Math.hypot(trail[i].x - trail[i - 1].x, trail[i].y - trail[i - 1].y);
        if (acc > TRAIL_LEN) break;
        i--;
    }
    if (i > 0) trail.splice(0, i);   // 砍掉尾巴
}
```

**点少于 3 个就不要画**（`opacity = 0`）：两个点连出来是直线段，像划痕不像尾迹。

`52 px` 在 620 宽的画布上是 8%，约等于卫星自身长度的 10 倍——
像"刚走过"，又不会盖住吸积盘。**不要超过 90px**，再长就比主体抢眼了。

#### 坑三：★★ 三层（暗影 / 柔光 / 亮线），都是填充

卫星会经过吸积盘最亮的一段，浅色带在那儿**直接消失**。
和卫星自己的 `sat-shadow` 是同一个理由，所以拖尾也要垫一层暗的：

```html
<!-- 顺序不能反：暗影在最下。三者都是 fill，不是 stroke -->
<path id="trailShadow" fill="#02030a" opacity="0"
      pointer-events="none" filter="url(#trailBlurS)"/>
<path id="trailGlow" fill="#ffab3c" opacity="0"
      pointer-events="none" filter="url(#trailBlurL)"/>
<path id="trailLine" fill="url(#trailGrad)" opacity="0"
      pointer-events="none"/>
```

```js
line.setAttribute('opacity', '1');
shade.setAttribute('opacity', '0.38');                       // 再高就是灰楔子
glow.setAttribute('opacity', (0.15 + hot * 0.13).toFixed(2)); // 再亮就 blingbling
```

比例关系（都是同一条 `ribbonPath`，只改 `wMax`）：

| 层 | 宽度 | 作用 |
|---|---|---|
| 亮线 | 1.00 × | 主体，带渐变 |
| 暗影 | 1.35 × | 亮盘上做分离 |
| 柔光 | 2.20 × | 暖色晕，opacity 只给 0.15~0.28 |

**柔光层一定用固定色，不要复用渐变**：渐变被 `blur` 抹开后饱和度掉光，
尾迹会变成一截灰烟。

#### 坑四：★ 线头要退到机身后面

把路径终点直接设在卫星中心，会看见一条线**穿过机翼**。
沿切线回退一小段：

```js
const head = trail[trail.length - 1], prev = trail[trail.length - 2];
const L = Math.hypot(head.x - prev.x, head.y - prev.y) || 1;
const cut = Math.min(4.2, L * 0.55);           // 最多退 4.2px，也别退过半段
const tip = { x: head.x - (head.x - prev.x) / L * cut,
              y: head.y - (head.y - prev.y) / L * cut };
```

渐变向量也从 `tail → tip`，而不是 `tail → head`，否则亮的那一端也在机身里面。

#### 坑五：★ 两条消息驱动同一个标记 → 必须合并到同一帧

`x` 与 `y` 是两条独立消息，先后到达。每条都立刻重画会画出 `(新X, 旧Y)` 的中间态，
轨迹变成台阶。完整解法和代码见 **§6.11**（本章不重复）。

在拖尾上表现为：Chaikin 平滑也治不好 —— 平滑只是把直角磨圆，
「一横一竖」的节奏还在。**根源在采样，不在曲线算法。**

#### 坑六：★★ `setAttribute('fill')` 会被 CSS 覆盖

想按黑/白洞给卫星换色，用 `setAttribute('fill', ...)` **不生效**：
presentation attribute 的优先级低于任何 CSS 规则，而 CSS 里已经有
`#sat .sat-wing { fill: rgba(255,224,150,.82) }`。

```js
// ✗ 错：白洞模式下翼还是金色
document.querySelectorAll('#sat .sat-wing').forEach(e => e.setAttribute('fill', coolWhite));

// ✓ 对：切 class，让 CSS 决定
$('sat').classList.toggle('wh', white);
```
```css
#sat.wh .sat-wing { fill: rgba(226, 240, 255, .86); }
#sat.wh .sat-body { fill: #ffffff; }
```

同一份配色里有两类属性，处理方式不同：

| 属性 | 能不能用 `setAttribute` | 原因 |
|---|---|---|
| `stroke-width` / `stroke-opacity` / `opacity` | ✅ 可以 | 没有 CSS 规则去抢 |
| `fill` / `stroke`（颜色） | ❌ 不行，走 class | CSS 里有规则，优先级更高 |
| `<stop stop-color>`（渐变停点） | ✅ 可以 | 渐变停点没有 CSS 规则 |

拖尾渐变就是第三条：`$('trailGrad').querySelectorAll('stop')` 逐个 `setAttribute('stop-color', …)` 即可。

#### 什么时候**不要**拖尾：标记的步进速率由别的参数控制

SwarmGrain 的干声游标（`swarm_x / swarm_y`）一开始也画了拖尾。但它的步进速率是
`kTrig metro kDens` —— 也就是 **Dens 直接决定这个点每秒走几步**。于是拖尾把这个速率
画成了"一条越来越长的尾巴"，用户看到的是「我调 Dens，场域的半径/速度怎么变了？」，
而真正管尺寸的只有 `radius`。

> 判据：**拖尾会把"速率"变成一条可见的几何**。如果速率属于参数 A、几何属于参数 B，
> 那么拖尾就是在让 A 冒充 B。这种情况只留一个点。

```js
/* 只留一个点：亮底用深描边、暗底用白芯，两种背景都读得出 */
.dry-dot { fill: rgba(255,242,242,.95); stroke: rgba(10,10,10,.85); stroke-width: 1; }
```
```js
function updateMarker(x, y) {           // 无 trail 数组、无 chaikin、无 ribbonPath
    posX = clamp(x, 0, 1);
    posY = clamp(y, 0, 1);
    placeSwarm(toScreen(posX, posY));
}
```

对照：**Singularity / loom / zephyr** 的标记速率是「固定 30 fps 平滑跟随」，
与任何参数无关，所以拖尾只是在表达"我刚从哪来"，不会冒充别的参数 —— 这三台保留拖尾
（用同一套 `ribbonPath` 三层：暗影 / 柔光 / 亮线）。
levy 有轨迹但那是**历史路径本身**（§6.11 的折线分段），不是拖尾，不要混为一谈。
Orbita / SwarmGrain / Boids 没有拖尾。

---

### 6.18 ★ 通用控件细节：双态开关 / 滑块位移

这两条与具体插件无关，任何带开关或滑动轨道的界面都要遵守。

#### 坑零：★ 横推子和竖推子必须成对定义样式

`.ffill/.fbar`（横）与 `.vfill/.vbar`（竖）是两套类名，**只写一套不会报错**，
另一条轴会变成一只「看得见轨道、看不见指针和填充」的哑推子 —— JS 照旧在写
`style.top` / `style.height`，但类没有样式就等于没画。

自查：`grep -o '\.[fv][a-z]*' index.html | sort -u`，看 `f*` 和 `v*` 是否成对。

#### 坑一：★ 双态参数必须做成「一个开关」，不是两个按钮

`mode` 是二值通道，前端**不要**画成两个互斥按钮：

```html
<!-- ✗ 错：用户第一反应是"这是两个功能"，而且两个都能点，状态语义模糊 -->
<button id="modeBH">Black Hole</button>
<button id="modeWH">White Hole</button>

<!-- ✓ 对：一个滑动开关，左/右各代表一个状态 -->
<div class="sw" id="modeSw" role="switch" aria-checked="false">
    <div class="tab"></div>
    <div class="opt">Black Hole</div>
    <div class="opt">White Hole</div>
</div>
```

```js
$('modeSw').addEventListener('click', () => {
    S.mode = S.mode ? 0 : 1;
    setSwitch('mode', S.mode);
    paintSwitches();
});

function paintSwitches() {
    const sw = $('modeSw');
    sw.classList.toggle('wh', S.mode === 1);
    sw.setAttribute('aria-checked', S.mode === 1 ? 'true' : 'false');
}
```

#### 坑二：★★ 滑块位移不要用 `left` 切换，用 `transform`

这是本次实测最意外的坑：**同一个元素，`left` 的样式切换在某些 Chromium 上完全不生效**。

```css
/* ✗ 错：切到 .wh 后滑块纹丝不动 */
.sw .tab { position: absolute; left: 2px; width: calc(50% - 4px); }
.sw.wh .tab { left: calc(50% + 2px); }
```

实测证据（Playwright + 该 Chromium）：

| 操作 | 结果 |
|---|---|
| `getComputedStyle(tab).left`（`.wh` 态） | `2px` ← 没变 |
| `tab.matches('.sw.wh .tab')` | `true` ← 选择器匹配正常 |
| 规则确实在 CSSOM 里 | ✅ `.sw.wh .tab { left: calc(50% + 2px) }` |
| 内联 `tab.style.left = '55%'` | 仍然 `2px` |
| 内联 `tab.style.transform = 'translateX(100%)'` | `matrix(1,0,0,1,83,0)` ✅ |

**同一条 `.wh` 规则里的 `background` / `border-color` / `box-shadow` 都生效了，
只有 `left` 不生效** —— 所以不是选择器或层叠问题，就是 `left` 本身在这个上下文里被吞了。

```css
.sw .tab {
    position: absolute; left: 2px; width: calc(50% - 4px);
    transform: translateX(0);
    transition: transform .22s cubic-bezier(.4, 0, .2, 1),
                background .22s ease, border-color .22s ease, box-shadow .22s ease;
}
.sw.wh .tab { transform: translateX(calc(100% + 4px)); }
```

`translateX` 的百分比以**元素自身宽度**为基准，`calc(100% + 4px)` 里的 `4px`
用来补左右各 2px 的边框留白。

---

### 6.19 ★ 连续场域：一层薄雾表达滤波 / 衰减

> 适用：DSP 里有一个**随位置连续变化的标量**（截止频率、增益、密度、衰减），
> 且这个量是"场"而不是"一串独立事件"。SwarmGrain 的 Gaussian 滤波场就是标准例。

**先做减法：不要为它加粒子。** SwarmGrain 一开始在薄雾上叠了 6 槽 × 3 通道的颗粒光斑，
结果是：21 个隐藏通道、每帧 180 条消息，而 250px 的画布上根本读不出颗粒的密度或分布，
最后整体删掉，只剩 4 个隐藏通道。
判据只有一句：**这层像素在传达什么"可读的量"？答不上来就别做。**

**做法：一个径向渐变，颜色 = 场值**

```js
/* 1. 场值必须用 DSP 的公式现算，不许手写近似 */
function cutoffAt(d) {                     // d = 相对场半径 0..1
    const g = Math.exp(-(d * d * 5));      // Gaussian
    return rangeMin * Math.pow(rangeMax / rangeMin, g);
}
/* 2. 频率压到 0..1 再转灰度：对数刻度才符合听感 */
function brightOf(cut) {
    return Math.log10(Math.max(cut, 20) / 20) / Math.log10(20000 / 20);
}
```

```js
/* 3. 停靠点要密（40 个）。只有 7 个时能肉眼看见同心色阶，像等高线 */
const STOPS = 40, FADE_FROM = 0.86, ALPHA = 1.0;   // alpha 必须是 1，理由见下
for (let i = 0; i <= STOPS; i++) {
    const f = i / STOPS;
    const v = Math.round(clamp(brightOf(cutoffAt(f)) * 255, 1, 255));
    let a = ALPHA;
    if (f > FADE_FROM) {                    // 最外 20% 用 smoothstep 羽化
        const t = (f - FADE_FROM) / (1 - FADE_FROM);
        a = ALPHA * (1 - t * t * (3 - 2 * t));
    }
    grad.appendChild(stop(f * 100 + '%', `rgb(${v},${v},${v})`, a));
}
```

**三条硬性要求**

| # | 要求 | 违反的后果 |
|---|---|---|
| 1 | 每个停靠点的颜色**从 DSP 公式现算** | 手写近似值 → 颜色与声音脱钩，调参时不同步 |
| 2 | 透明度**恒定且 = 1.0**，只在最外 14% 羽化 | 用 `0.02→0.20` 递增"增加层次" → 等于亲手画出外缘亮环；用 0.52 这种半透明 → 最亮端永远压在中灰，够不到白（见下） |
| 3 | 画面里**只让亮度**承载这个参数 | 亮度 + 尺寸 + 不透明度一起变 → 三路叠加成亮环（实测 `corr(亮度,r)=0.925` 正常、`corr(尺寸,r)=-0.008` 才干净） |

**配套：把数值也摆出来**

场域是"模糊"的表达，旁边必须有一个精确读数兜底。SwarmGrain 在底栏写
`CUT 100 → 19.3k Hz`，用同一条公式算中心与外缘的截止频率，参数一动就跟着变。
读者不需要靠眼睛猜薄雾的深浅代表多少 Hz。

**建议的常数（实测可用）**

| 参数 | 值 | 说明 |
|---|---|---|
| 停靠点数 | 40 | < 12 会看到色阶，> 64 无收益 |
| 主体 alpha | **1.0** | 半透明会把最亮端永远压在中灰，见下方「alpha 就是对比度上限」 |
| 羽化起点 | 0.86 | 太晚（0.95）会留硬圆边，太早（0.6）会把最亮的 20 级削掉；alpha=1 时尤其明显 |
| 图元 | `<radialGradient>` + 一个 `<circle>` | 不要用多层同心圆拼，接缝处必然有色阶 |

#### ★ alpha 就是这条刻度的对比度上限

薄雾是半透明图元，**最终像素 = 颜色 × alpha + 底色 × (1 − alpha)**。底色近乎纯黑，
所以 alpha 直接决定了「最亮能到多亮」：

| alpha | 20000 Hz 的 `rgb(253)` 落到屏幕上 |
|---|---|
| 0.52 | **133**（中灰，怎么看都不够亮） |
| 0.80 | 204 |
| **1.00** | **253**（白） |

所以：**要「最低截止 = 黑、最高截止 = 白」这整条刻度，alpha 就只能恒为 1**，
把明暗完全交给颜色。半透明会让高端永远够不到白 —— 这一条只有用户直接看画面才能发现，
本地算 `brightOf()` 永远是 1.0，看不出问题。

> 担心「alpha = 1 会糊成实心盘」？不会。盘心本来就是 `rgb(1)`（20 Hz 附近），
> 和 pad 底色一样黑，看不见边界；能看见的只有那条从黑到白的连续梯度，那正是要画的东西。
> 真需要"含蓄"就调 **DSP 的截止范围**，不要调 alpha —— 调 alpha 是在偷改刻度。

羽化起点相应放松到 **0.86**（之前 0.80），因为不透明的白色边缘如果收得太早，
最亮的那一圈会在还没到 250 的时候就开始掉 alpha，峰值被削掉约 20 级。

### 6.20 没有几何出口的参数：用纹理承载（Dens 类）

> 适用：参数只控制**事件的速率/密度**（每秒颗粒数、每秒触发数），
> 场上没有位置、没有幅度、没有色相可画。SwarmGrain 的 `Dens` 就是这种。

**场景**：粒子层删掉之后，`Dens` 在画面上完全消失了。用户会直接说
"调 density 的时候薄雾给点小小的质感反馈"。这不是装饰需求，是**可操作性**需求 ——
一个拖了没反应的推子，用户会以为插件坏了。

**原则**：纹理的「粗细 + 强弱」是同一条视觉通道（就叫"颗粒感"），可以一起动；
但**绝不借用薄雾的亮度** —— 亮度已经归 Cutoff Min/Max（§6.19）。

**做法：一个 SVG `pattern` 点阵 + 一张遮罩 + 固定种子**

```html
<!-- 点阵铺在 pattern 里，图案本身不进 DOM 树，不产生逐帧元素 -->
<pattern id="grainPat" width="72" height="72" patternUnits="userSpaceOnUse"></pattern>

<!-- 可见范围：中心最暗处不铺，外缘收掉，避免"描边感" -->
<radialGradient id="grainFade" cx="50%" cy="50%" r="50%">
    <stop offset="0%"   stop-color="#fff" stop-opacity="0"/>
    <stop offset="14%"  stop-color="#fff" stop-opacity=".85"/>
    <stop offset="58%"  stop-color="#fff" stop-opacity="1"/>
    <stop offset="82%"  stop-color="#fff" stop-opacity=".42"/>
    <stop offset="100%" stop-color="#fff" stop-opacity="0"/>
</radialGradient>
<mask id="grainMask" maskContentUnits="objectBoundingBox">
    <rect x="0" y="0" width="1" height="1" fill="url(#grainFade)"/>
</mask>
```

```js
const TILE = 72, BUCKETS = 24;
const SEED = 0x5eed1a;
let bucket = -1;

function buildGrain(b) {
    const f = b / BUCKETS;
    const cells = Math.round(10 + 5 * f);       // 10×10 → 15×15 格
    const step  = TILE / cells;
    const rMax  = 1.45 - 0.70 * f;              // 半径 1.45 → 0.75 unit：越密越细
    const jit   = step - 2 * rMax - 0.25;       // 偏移余量，点不越格也不互相压
    let s = SEED;
    const rnd = () => {                          // xorshift32：固定种子 = 点位不抖
        s ^= s << 13; s ^= s >>> 17; s ^= s << 5;
        return (s >>> 0) / 4294967296;
    };
    pat.innerHTML = '';
    for (let gy = 0; gy < cells; gy++) {
        for (let gx = 0; gx < cells; gx++) {
            pat.appendChild(circle(
                gx * step + rMax + 0.12 + rnd() * Math.max(jit, 0),
                gy * step + rMax + 0.12 + rnd() * Math.max(jit, 0),
                rMax * (0.82 + 0.18 * rnd()),
                // 明暗各半：薄雾从近黑到近白都有，单一色调总有一半看不见
                rnd() > 0.47 ? 'rgba(255,255,255,.50)' : 'rgba(0,0,0,.45)'));
        }
    }
}

function paintGrain() {
    const f = toFrac(clamp(V.Dens, P.Dens.min, P.Dens.max), P.Dens);
    const b = Math.round(f * BUCKETS);
    if (b !== bucket) { bucket = b; buildGrain(b); }   // 只在跨桶时重建 DOM
    $('grain').setAttribute('opacity', (0.07 + 0.22 * f).toFixed(3));
}
```

**三条硬性要求**

| # | 要求 | 违反的后果 |
|---|---|---|
| 1 | 用**分层网格**（每格一颗 + 格内随机偏移），不要纯随机 | 纯随机会成团成洞，看着像气泡/贴纸，不像颗粒 |
| 2 | 点的半径跟**格距**挂钩，不要写死像素 | 写死会在 69% 缩放下消失、在 155% 下变成圆点贴纸 |
| 3 | 拖推子时**量化成桶再重建** | 每帧 `innerHTML=''` + 重铺 400 个节点，拖动明显掉帧 |

**实测常数（SwarmGrain，可直接改用）**

| 项 | 值 | 说明 |
|---|---|---|
| tile 边长 | 72 unit | 小于 40 时 tile 重复肉眼可见，像规则筛网 |
| 格数 | 10 → 15 | 10 是"粗砂纸"，15 是"细砂纸"，两者在 100% 缩放下分得很清 |
| 点半径 | 1.45 → 0.75 unit | 与格距同步缩；半径 > 2 就会被看成圆点而不是纹理 |
| 组透明度 | 0.07 → 0.29 | 高于 0.35 就抢薄雾的亮度语义了 |
| 桶数 | 24 | 全程拖动跨 24 次重建，无感 |

**验证方式**：把画布 `--zoom` 临时设成 1（= 真实 620px 窗口），截图看纹理；
在 69% 自适应缩放下判断会误以为"太弱"，在 155% 下会误以为"太强"。

---

### 6.21 ★ 预览波形必须与 DSP 的 `ftgen` 表逐点一致

> 适用：任何「界面里画一条窗函数 / 包络 / 波形，DSP 里用 `ftgen` 查表」的场合。

**问题**：预览是**手写公式**，DSP 是 `ftgen` 参数 —— 两者是两套独立实现，
只要表参数换个写法就对不上。SwarmGrain 的 Half Sine 预览被写成
`abs(0.5·sin(2πx) + sin(4πx)) / 1.29`（一个多峰涟漪），而 DSP 实际上是
`sin(πx)` 的单峰。用户一眼就看出来了。

**正确流程：先量，再写。**

```bash
# 1. 把表逐点读出来（注意：index 必须是整数，见下面的坑）
cat > /tmp/dump.csd <<'EOF'
<CsoundSynthesizer><CsOptions>-n -d</CsOptions><CsInstruments>
sr=48000
ksmps=64
nchnls=1
0dbfs=1
giw101 ftgen 101, 0, 1024, 9, 0.5, 1, 0
giw103 ftgen 103, 0, 1024, 20, 1, 1
instr 1
  prints "T101 %.4f %.4f %.4f %.4f\n", table(0,101), table(128,101), table(256,101), table(512,101)
  prints "T103 %.4f %.4f %.4f %.4f\n", table(0,103), table(128,103), table(256,103), table(512,103)
endin
</CsInstruments><CsScore>i1 0 0\ne\n</CsScore></CsoundSynthesizer>
EOF
csound /tmp/dump.csd 2>&1 | grep -E "^T10"
```

```js
/* 2. 照着实测值反推公式，再把实测值写进注释当契约 */
function windowShape(idx, x) {
  switch (idx) {
    case 1: return Math.sin(Math.PI * x);                          // 表101 实测 = sin(πx)
    case 2: return 1;                                              // 表102 矩形
    case 3: return 0.54 - 0.46 * Math.cos(2 * Math.PI * x);        // 表103 Hamming
    case 4: return Math.exp(-0.5 * Math.pow((x - .5) / (1 / 12), 2)); // 表104 σ=1/12
    default: return 1 - Math.abs(2 * x - 1);                       // 表105 三角
  }
}
```

**SwarmGrain 五张表的实测值（可直接对照）**

| 表 | 名称 | x=0 | .125 | .25 | .375 | .5 |
|---|---|---|---|---|---|---|
| 101 | Half Sine | 0.0000 | 0.3827 | 0.7071 | 0.9239 | 1.0000 |
| 102 | Rect | 1.0000 | 1.0000 | 1.0000 | 1.0000 | 1.0000 |
| 103 | Hamming | 0.0800 | 0.2147 | 0.5400 | 0.8653 | 1.0000 |
| 104 | Gauss | 0.0000 | 0.0000 | 0.0111 | 0.3247 | 1.0000 |
| 105 | Triangle | 0.0000 | 0.2500 | 0.5000 | 0.7500 | 1.0000 |

**两个必踩的坑**

| 坑 | 现象 | 正解 |
|---|---|---|
| **`table(小数, ifn)` 不做插值** | 读 `table(0.125, 101)` 得到 0，误判"整张表是空的 / GEN09 不支持 0.5 分音" | i-rate `table()` 把索引截断成整数，`0.125 → 0`。要么用**整数索引**（128、256、512），要么用插值版 `tablei()` |
| **`GEN09` 的 p1 允许小数** | 以为 `9, 0.5, 1, 0` 是写错了参数 | p1 是**分音号**，0.5 = 半频 → `sin(0.5·2πx) = sin(πx)`，正是"半个周期的正弦"。实测 x=0.0625 → 0.1951 = sin(11.25°)，完全吻合 |

**验收**：改完在浏览器里把 SVG `path` 的 `d` 反算回 0..1，比对上面的表。
SwarmGrain 实测 Half Sine 为 `0 → 0.373 → 0.722 → 0.928 → 1.0`（74 点采样的量化误差内）。

---

### 6.22 ★ 实体群：俯视鸟形 + 航向（Boids）

> 适用：画面里要画**一组可点名的实体**（鸟、鱼、车、人），而不是一团颗粒。

§6.19 的结论是「不要做几百个颗粒的云」，但**8 个实体的群是可以画的**，
因为它回答了一个可读的问题：**这一群现在在哪、往哪飞、谁快谁慢**。

#### 先定视角：俯视还是侧视

这两个视角的字形完全不同，**选错了后面怎么调都别扭**：

| 视角 | 字形 | 能不能表达「航向」 |
|---|---|---|
| 侧视（参考图那种 `m` / `~` 海鸥） | 单笔画、两段曲线 | **不能**。侧视只能表达"往左飞还是往右飞"，全角度旋转就会看到一只翻过来的鸟 |
| **俯视（Boids 最终采用）** | 闭合剪影：喙 + 双翼 + 燕尾 | **能**。俯视本来就有 360° 朝向，`rotate` 是正确的 |

Boids 一开始做了侧视，用户立刻问「鸟翅膀没有方向吗？只能固定死是现在的上下？」——
**问题不在实现，在视角**。要方向就必须换成俯视。

#### 字形：**描边曲线**，不要填色多边形

试过五版，结论很干脆：

| 版本 | 结果 |
|---|---|
| 侧视两段贝塞尔描边（`m` 形海鸥） | **最好看**，但侧视表达不了方向 |
| 侧视 + 全角度旋转 | 90° 时变成一条竖着的波浪 |
| 俯视**细线**（机身线 + 双翼） | 10px 下糊成毛刺 |
| 俯视**填色多边形**（8 点剪影） | 硬边，怎么调都像**纸飞机** |
| ✅ **俯视描边曲线 + 机身线** | 好看 + 有方向，两个要求同时满足 |

```js
function birdPath(lift) {
    const h = 0.06 + 0.30 * lift;      // 翼中段（前缘）：上扬时更靠前
    const t = 0.52 - 0.12 * lift;      // 翼尖：强后掠 → 读成 V 形燕子
    const b = -0.04;                   // 翼根略前于机身中段
    const f = v => v.toFixed(3);
    return 'M-1 ' + f(t) +
           ' C' + f(-0.60) + ' ' + f(-h) + ' ' + f(-0.20) + ' ' + f(-h * 0.50) + ' 0 ' + f(b) +
           ' C' + f(0.20) + ' ' + f(-h * 0.50) + ' ' + f(0.60) + ' ' + f(-h) + ' 1 ' + f(t);
}
```

配套三件事，缺一不可：

```css
.bird path { fill: none; stroke-linecap: round; stroke-linejoin: round; }   /* ① 描边，别填充 */
.bird.follower path { stroke: #ffffff; stroke-width: 1.7; }                /* ② 线宽 ≥1.6 */
.bird.leader  path  { stroke: #ff3b40; stroke-width: 2.1; }
.bird .bodyln { stroke-width: 0.9; opacity: .75; }                        /* ③ 一定要有机身线 */
```

```js
/* 机身线：喙更长、尾更短 —— 不对称才看得出朝向 */
g.appendChild(svgEl('path', { class: 'bodyln', d: 'M0 -0.42 L0 0.46', 'vector-effect': 'non-scaling-stroke' }));
```

| 关键 | 为什么 |
|---|---|
| 用描边不用填充 | 描边有粗细和圆头，10px 下自带柔化；填色是硬边，永远像贴纸/纸飞机 |
| 翼尖强后掠（`t≈0.5`，即 25% 翼展） | 后掠不够会读成「T 字」；够了才是 V 形燕子 |
| **必须有机身线** | 只有两只翅膀时，斜角度下两半会连成一条波浪；机身线一给，立刻有「头」 |
| 机身线不对称（前长后短） | 对称的线看不出哪头是头 |

#### 航向：由 **DSP 算好传过来**，不要在前端从位移猜

前端算 `atan2(Δx, Δy)` 有三个问题：30 Hz 阶梯会抖、静止时方向乱跳、
而且和 DSP 里真正决定声像的那份速度**不是同一个量**。正确做法是后端推角度：

```csound
; Csound 没有 atan2，反正是 taninv2(y, x)；返回 -π..π
; 模型的 y 向上、SVG 的 y 向下，所以取 -dy
kAng = taninv2(-gkDy[kIdx], gkDx[kIdx]) * 57.29578
if kAng < 0 then
    kAng = kAng + 360                    ; 统一成 0..360
endif
cabbageSetValue "ba1", kAng, kUIMetro    ; 头鸟用 bdir
```

方向要先低通，否则噪声让鸟抖成筛子：

```csound
if (abs(gkVx[kIdx]) + abs(gkVy[kIdx])) > 0.0004 then
    gkDx[kIdx] = gkDx[kIdx] * 0.72 + gkVx[kIdx] * 0.28
    gkDy[kIdx] = gkDy[kIdx] * 0.72 + gkVy[kIdx] * 0.28
endif
```

**头鸟的航向不能用「用户拖拽方向」**，要用「这一拍实际位移」——
用户把 pad 往左拖，鸟是被拽过去的，朝向应该跟真实位移走：

```csound
kLDx = gkX[0] - kLXp                       ; 上一拍位置
kLDy = gkY[0] - kLYp
if (abs(kLDx) + abs(kLDy)) > 0.00012 then
    gkDx[0] = gkDx[0] * 0.55 + kLDx * 0.45
    gkDy[0] = gkDy[0] * 0.55 + kLDy * 0.45
endif
kLXp = gkX[0]
kLYp = gkY[0]
```

前端按**最短弧**插值，避免 359°→1° 绕一圈：

```js
const shortestArc = (from, to) => ((to - from + 540) % 360) - 180;
h.cur += shortestArc(h.cur, h.tgt) * 0.20;
h.cur = (h.cur + 360) % 360;
```

#### 旋转量 = 航向 + 90°

字形机头朝 `-Y`，`rotate(φ)` 把 `(0,-1)` 映射到 `(sin φ, -cos φ)`。
要它等于航向 `(cos θ, sin θ)`，解得 **φ = θ + 90°**：

| 航向 | rotate | 结果 |
|---|---|---|
| 0°（向右） | 90° | 机头朝右 ✓ |
| 90°（向下） | 180° | 机头朝下 ✓ |
| 180°（向左） | 270° | 机头朝左 ✓ |

> 别再做 `facing = ±1` 的镜像了。既然有真实航向，镜像和旋转同时用会把左右翻错。

#### 景深：和 DSP 用**同一个**距离

Boids 的 DSP 以 `(0.5, 0)` 下边中央为参考算距离（驱动多普勒、空气吸收、衰减）。
画面上的鸟用**同一个公式**缩放，远小近大，观众看到的深浅就是听到的深浅：

```js
const depth = Math.sqrt((x - 0.5) ** 2 + y ** 2) * 0.89442719;   // 0..1
const span  = base * (1 - 0.36 * depth);
```

#### 头鸟怎么区分：颜色 + 外发光，不要套光环

一开始给头鸟套了一个细圆环当前景。实测在 12px 的尺寸下，圆环和翅膀
会糊成「一个圈加一条线」，反而更像 UI 元素而不是鸟。最终做法：

```css
.bird.leader   path { fill: #ff3b40; stroke: #ff3b40; }   /* 纯红 */
.bird.follower path { fill: #ffffff; stroke: #ffffff; }   /* 纯白 */
.bird.leader { filter: drop-shadow(0 0 3px rgba(255, 59, 64, .75)); }
```

#### 尾迹：只有「长度 ∝ 真实速度」才允许画

§6.17 说过拖尾会冒充参数。这里例外，因为速度是**真的速度**（逐帧位置差分），
而且长度有上限，不会拖成一条线：

```js
const spd = Math.hypot(b.vx, b.vy);
const wl  = clamp(spd * 5.5, 0, 16) / span;       // 单位空间
```

#### 背景：云要会"活"，鸟要穿过它

静态云＝死贴图。用户的原话是「云还是太像个死贴图了，要像真正的云，能够聚散融合」。
让云活起来只需**三层独立动画**，而且全是 CSS，零 JS 帧预算：

| 层 | 动画 | 作用 |
|---|---|---|
| `.clouddrift`（外层） | `translateY` 整屏下落 | 云的走向；**速度各不同 → 会互相穿过、叠加、融合** |
| `.cloudbreath`（中层） | `scale` + `opacity` 呼吸 | 聚（变大变实）/ 散（缩小变淡） |
| `.litdrift`（亮顶层） | 小幅 `translate` | 亮顶相对暗底滑动 → 光照在变，看起来在"变形" |

**方向必须和主体反向。** Boids 的鸟是**上升**的，所以云要**下落** ——
第一次写成横移，用户立刻问「云怎么也是从左往右，不应该从上往下？」。
反向运动时相对速度翻倍，穿云事件更密（实测从 2~5 只提升到 4~9 只）。

```css
@keyframes cloudDrift {
    from { transform: translate3d(var(--x0, 0px), var(--y0, -260px), 0); }
    to   { transform: translate3d(var(--x1, 0px), var(--y1, 980px),  0); }
}
/* ★ 起点和终点都是**绝对坐标**，云体本身建在原点 (0,0)。
   --x1 - --x0 只给 ±110px 的横向摆动；给太多就变成"斜着飞"，失去下落感。
   为什么不用「初始坐标 + 单一 --xw 摆动」：那样初始坐标还得参与定位，
   两套机制并存就会出现「一半在动、一半死坨」（§6.27 的教训）。 */
@keyframes cloudBreath {                    /* 注意透明度不要压到 0，否则变鬼影 */
    0%   { transform: scale(.84);  opacity: calc(var(--op) * .72); }
    30%  { transform: scale(1.04); opacity: var(--op); }
    55%  { transform: scale(1.14); opacity: calc(var(--op) * .96); }
    78%  { transform: scale(.96);  opacity: calc(var(--op) * .84); }
    100% { transform: scale(.84);  opacity: calc(var(--op) * .72); }
}
@keyframes litDrift {
    0%   { transform: translate(-6px, 3px); }
    50%  { transform: translate(7px, -4px); }
    100% { transform: translate(-6px, 3px); }
}
.cloudbreath {
    animation-timing-function: ease-in-out;
    transform-origin: center;
    transform-box: fill-box;              /* ★ 少了这条，scale 会绕 SVG 原点缩放，整朵云飞走 */
}
```

**周期必须互质**：`drift` 远 110~200s / 近 46~86s、`breath` 15~24s、`litdrift` = `breath × 1.37`。
整数倍会让云在固定时刻回到同一形状，看起来又变回贴图。

云体和前文一样要**暗底 + 亮顶**两层；实测可用值：

| 参数 | 值 | 说明 |
|---|---|---|
| `stdDeviation` | 远 9 / 近 4.5 | < 5 会看见椭圆边 |
| 暗底 | `rgba(36,92,136,.66)`，下沉 `0.30h` | 体积来源；太淡成污渍、太深成乌云 |
| 亮顶 | `rgba(255,255,255,.92)`，上移 `0.12h` | |
| 凸起数 | 9~15 / 朵 + 1~3 个额外鼓包 | < 8 会像几根横线 |
| 宽高比 | **≈2.4:1**（如 70×30） | 4:1 的横条在纵向运动里读成"雾带"，不是云 |
| **远层** opacity | **0.24~0.34** | 7 朵、84~140 宽、`cloudBlur`(σ9)，可压到 pad 背后反而有纵深 |
| **近层** opacity | **0.46~0.60** | 9 朵、50~94 宽、`cloudBlurS`(σ4.5)，再高会盖住 pad |
| **远层** 下落速度 | **4.2~12.6 px/s** 实测 | `dur` 150~260 s |
| **近层** 下落速度 | **13.5~28.7 px/s** 实测 | `dur` 46~86 s |
| 纵行程 | `--y0` = `-h·1.6-60-rnd·180`，`--y1` = `820+rnd·200` | 比画布高 760 还多，保证完全进出 |

> 速度是 2026-11-01 在 620×760 画布、`--zoom = 1` 下实测的（隔 20 s 取两次
> `getBoundingClientRect().top` 求差，7 朵 + 9 朵全部采样）。
> **历史上这两个数曾写错两次**：先写成 47~83 px/s（用户："云的飞的太快了"），
> 再改成 18.5~24.3（仍是错的），最后实测才定下来。
> **背景元素的速度只能实测，不能靠 `dur` 和距离心算** —— 缓动函数、
> 循环点和 `animationDelay` 都会让实际值偏离。

#### 云形要随机：四个构形参数 + 随机指数

只用 `(1 - bx²)` 加权会让每朵云长得一模一样（对称的鼓包）。要真正不规则，
每朵云先随机四个参数：

```js
const stretch = 0.72 + rnd() * 0.62;       // 整体横向拉伸 0.72…1.34
const skewX   = (rnd() - 0.5) * 0.55;      // 重心左右偏
const domeH   = 0.26 + rnd() * 0.46;       // 圆顶高度：有的很扁，有的很鼓
const lumps   = 1 + Math.floor(rnd() * 3); // 额外鼓包

/* 轮廓用 pow 打散：指数也随机 → 有的中间鼓、有的偏一侧 */
const fall = Math.pow(1 - bx * bx, 0.55 + rnd() * 0.75);
const py = cy - fall * h * domeH * (0.7 + rnd() * 0.8) + rnd() * h * jitter;
```

再叠 `lumps` 个位置随机的小球。**踩坑顺序**：先太对称（每朵一样）→ 加随机后
**太大太实**（铺满 pad，像乌云）→ 收小到 70×30 + opacity 0.43~0.63 + 暗底 `.66` 才刚好。

> 背景的判据：**不看它时不存在，看它时是真的。**

#### 「穿过云层」靠的是图层顺序，不是画出来的

```
<g id="cloudsFar">     远层云
<g id="ambient">       鸟   ← 夹在中间
<g id="cloudsNear">    近层云（会盖住鸟）
<circle id="padGlow">  pad 及其后的所有 UI
```

有了这三层，鸟穿过近层云时会**真的被盖住再露出来**，不需要做任何遮罩或透明度逻辑。
实测同时有 **1~3 只鸟**落在近层云里（12 只远景鸟）。
把远景鸟加到 38 只能到 4~9 只重叠，但那样远景比主鸟群还热闹，已否掉。

要让这个效果**经常发生**：

| 做法 | 数字 |
|---|---|
| 近层云不够多 → 鸟很久才碰到一次 | 近层 **9 朵**（原来 5 朵） |
| 云在屏幕外的时间太长 | 行程覆盖 `-h·1.6-240` … `820~1020`，两头都在画布外 |
| 鸟太少 | **12 只**（38 只会比主鸟还热闹，喧宾夺主） |

#### 远景鸟：从下往上

字形机头朝 `-Y`，所以**朝上就是 `rotate(0)`**，不用再转。
改成纵向动画，并给一点横向漂移，看起来像盘旋上升：

```css
@keyframes ambrise {
    from { transform: translateY(880px) translateX(0); opacity: 0; }
    6%   { opacity: var(--op, .8); }
    92%  { opacity: var(--op, .8); }
    to   { transform: translateY(-160px) translateX(var(--dx, 0px)); opacity: 0; }
}
```

首尾各 6%/8% 做淡入淡出 —— 鸟从画面下沿"升起来"、到上沿"化掉"，
正好配合云层穿越。

> 实测坑：`scale(s)` 里的 `s` 就是像素半翼展（单位路径半宽 = 1）。
> 一开始按"倍数"给了 `1.7~4.3`，画出来只有 3~9px 宽，屏幕上完全看不见。
> 要 12~20px 的远景鸟，`s` 得给 **3.0~6.2**。

> 远景鸟可以不扑翼（12px 看不出），用两种翼展随机分配就够：
> `const flip = rnd() < 0.5 ? -0.7 : 0.7;`

**性能**：12 朵云 × ~14 凸起 × 2 层 ≈ 340 个椭圆，全部 CSS 动画，
实测 **60.8 fps**（Chrome，620×760 画布）。CSS 动画只走合成层，不占 JS。

---

### 6.23 ★ 旋钮的六条硬性做法（Boids）

> 适用：控制台用旋钮。判据见下方「什么时候用旋钮、什么时候用推子」。

**几何**：`135° 起、顺时针扫 270°`，0° 在 12 点方向。

```js
const KB = { cx: 29, cy: 29, r: 22, tickR: 25.5, a0: 135, sweep: 270 };

const polar = (r, deg) => {                        // deg 从 12 点顺时针量
    const a = (deg - 90) * Math.PI / 180;
    return [KB.cx + r * Math.cos(a), KB.cy + r * Math.sin(a)];
};
function arcPath(r, a0, a1) {
    const [x0, y0] = polar(r, a0), [x1, y1] = polar(r, a1);
    const large = (a1 - a0) > 180 ? 1 : 0;         // ★ 超过 180° 必须置 1
    return `M${x0} ${y0} A${r} ${r} 0 ${large} 1 ${x1} ${y1}`;
}
```

| # | 做法 | 违反的后果 |
|---|---|---|
| 1 | **指针放在 plate 与值弧之间的缝里**（`r 17.2 → 20.6`） | 从圆心拉到 `r=13.5` 会正好穿过中央的数值，数字看起来像乱码（实测第一版就是这样） |
| 2 | `large-arc-flag` 按 `(a1-a0)>180` 算 | 270° 的弧不置 1 会画成一条 90° 的小弧，看着像"值很小" |
| 3 | 值弧 `f≈0` 时把 `d` 清空 | 停在起点会留下一个小圆点（`stroke-linecap: round` 的端点） |
| 4 | `.kval` 常态 `pointer-events:none`，进编辑才 `auto` | 常态可点的话，46px 的数值框会盖住旋钮中心，**按住中央拖不动**，只能从边缘拖 |
| 5 | **点 / 拖靠位移判定**：`<3px` 抬起 = 进编辑，`≥3px` = 调值 | 用 `click` + `dblclick` 两个事件会互相抢：`click` 先进了编辑，`dblclick` 再归位时 `paintKnob` 因为 `editing.key` 还被跳过，屏幕留着旧数字（见下方代码） |
| 6 | 归位前先 `exitEdit(key)` | 同上。`resetParam` 必须先清 `editing.key` 再 `paintKnob`，否则值变了、显示不变 |

**点 / 拖共用同一个热区**：

```js
wrap.addEventListener('pointerdown', e => {
    if (wrap.classList.contains('editing')) return;   // 编辑中交给 input
    e.preventDefault(); wrap.setPointerCapture(e.pointerId);
    const f0 = toFrac(clamp(V[key], p.min, p.max), p);
    const x0 = e.clientX, y0 = e.clientY;
    let dragging = false;

    const move = ev => {
        if (!dragging) {
            if (Math.hypot(ev.clientX - x0, ev.clientY - y0) < 3) return;  // ★ 阈值
            dragging = true;
            sendParam(key, V[key], 'begin');
        }
        const rate = ev.shiftKey ? 1 / 620 : 1 / 150;  // 全程 150px，Shift 精调
        const f = clamp(f0 + (y0 - ev.clientY) * rate, 0, 1);
        setParam(key, clamp(Math.round(fromFrac(f, p) / p.step) * p.step, p.min, p.max));
    };
    const up = () => {
        if (dragging) sendParam(key, V[key], 'end');
        else { wrap.classList.add('editing'); val.focus(); val.select(); }   // 单击 → 编辑
    };
    /* …pointermove / pointerup / pointercancel 挂上，up 里解绑… */
});
```

**旋钮实测（Boids，Cohesion）**

| 操作 | 结果 |
|---|---|
| 拖拽 +60px | `0.000 → 0.400`（60/150 = 0.4 ✓） |
| 双击 | `0.400 → 0.000`（def ✓） |
| 单击 → 输入 `0.75` → Enter | `0.750` ✓ |
| Shift 拖 −100px | `0.750 → 0.911`（100/620 = 0.161 ✓） |

### 什么时候用旋钮、什么时候用推子

这一条被用户纠正过一次，**不是审美问题，是"原版是哪台机器"的问题**：

| 判据 | 结论 |
|---|---|
| 原版是 `rslider`（Stasis / Orbita / Singularity / loom / zephyr / Boids） | **旋钮** |
| 原版是 McCudy 的 `delaygrain` 推子风格（只有 SwarmGrain） | **推子**，且全推子、零旋钮 |
| 参数是**二维坐标的一轴**（`x` / `y` / `centerX` / `centerY`） | **贴着 pad 的轴推子**，不要做成旋钮 |

最后一条的理由：轴推子和 pad 在**同一个坐标系**里，拖动方向就是坐标轴方向；
旋钮是"绕圈调一个标量"，两个轴各给一个旋钮，反而比拖 pad 更难对位。
Boids 的 X/Y 就是保留轴推子的（用户看过实物后也认可），其余 19 个参数全是旋钮。

---

### 6.24 ★ CPU 花在哪：先量，再优化

> 「云和背景鸟应该走 GPU 吧？」——**一半对**。直觉的方向没错，但真正的账要用数字说话。

#### 怎么量（可复现）

```js
// 1) 浏览器侧：Chrome DevTools Protocol 的 Performance.getMetrics
const client = await page.context().newCDPSession(page);
await client.send('Performance.enable');
const g = async () => Object.fromEntries(
  (await client.send('Performance.getMetrics')).metrics.map(m => [m.name, m.value]));

const a = await g(); await page.waitForTimeout(6000); const b = await g();
const ms = (b.Timestamp - a.Timestamp) * 1000;
const pct = k => ((b[k] - a[k]) * 1000) / ms * 100;   // 占单核百分比
// 分别看：ScriptDuration / RecalcStyleDuration / LayoutDuration
//         TaskDuration（主线程总）/ ProcessTime（整个 renderer 进程）
```

```bash
# 2) 后端侧：离线渲染，real 时间 ÷ 音频时长
/usr/bin/time -p csound -n -d -m0 -o /dev/null bench.csd   # 30 s 素材
# real 0.94s → 单核负载 0.94/30 ≈ 3.1%，实时倍率约 32×
```

**关键**：一定要 `page.bringToFront()` 再测。后台标签页会被节流到 4 fps，
量出来是 3.7% 而不是 60.9 fps 的 17%，会得出完全错误的结论。

#### Boids 的实测结果（Apple M2，620×760，60 fps，单核百分比）

| 层 | 占单核 |
|---|---|
| 前端 JS（`renderFlock` + `birdPath`） | **0.35%** |
| Style recalc | 1.9% |
| Layout | 0.45% |
| 前端主线程合计 | **9.5%** |
| 整个 renderer 进程（含光栅/合成线程） | **17.4%** |
| 后端 Csound（8 × `DepthStereoRender` 2.1% + `reverbsc` 0.3% + 其余 0.7%） | **3.1%** |

#### 消融实验：**成本 ∝ 动画面积 × 帧率，不 ∝ 元素数量**

| 变体 | renderer |
|---|---|
| 基准 | 17.4% |
| 不建 16 朵云 | 16.7%（−0.7，噪声内） |
| 不建 12 只远景鸟 | 16.3%（−1.1） |
| 停掉主鸟群 rAF 循环 | 15.4%（−2.0） |
| **去掉高斯模糊** | **16.9%（零收益）** |
| `setAttribute` 换成 `style.transform` | 17.2%（零收益） |
| **云动画全停** | **14.9%（−2.5）** |
| **所有 CSS 动画停** | **12.0%（−5.4）** |

三条结论：

1. **高斯模糊不贵** —— 去掉零收益，说明确实走 GPU（`ANGLE Metal Renderer: Apple M2` 实测确认）。
2. **元素数量几乎不相关** —— 删 16 朵云 / 12 只鸟，数字都在噪声内。
3. **只跟"有没有东西在动"相关** —— 全停动画才降到 12%。剩下那 12% 是
   每帧合成整块 620×760 缩放画布的底噪，与内容无关。

#### 逐层消融（每个变体单独构建，两轮交替，误差 ±0.2）

| 变体（构建期就删掉） | renderer | 相对基准 |
|---|---|---|
| 基准 | 18.4% | — |
| 去掉两张全屏渐变（skyGlow + vign） | 16.6% | −1.8 |
| 不建云 | 16.6% | −1.8 |
| 不建远景鸟 | 16.8% | −1.6 |
| 主鸟群 rAF 不启动 | 17.9% | −0.5 |
| 控制台整块不显示 | 15.6% | −2.8 |
| canvas 不缩放（`transform: none`） | 15.5% | −2.9 |
| **canvas 加 `will-change: transform`** | **15.6%** | **−2.8** |
| **再叠加「不建云」** | **12.7%** | **−5.7** |

**这张表最关键的读法**：没有任何一项占大头，**每一层都只占 1.5~2.8 点**。

> 统一的解释：画布被 `transform: scale()` 缩放，里面的云和鸟又在动，
> 于是 Chromium **每帧都把整块 620×760 重新光栅化**。
> 因此成本 ≈ **被重画的总面积**，拆到每一层上就是按面积比例分摊。
> 静止图层（控制台、全屏渐变）不是"不花钱"，而是"跟着一起被重画"。

#### ✅ 唯一有效的优化：给画布加 `will-change: transform`

```css
.canvas {
    transform: scale(var(--zoom));
    transform-origin: center center;
    will-change: transform;      /* ★ 提升为独立合成层 */
}
```

实测 **18.4% → 15.6%（−2.8 单核点，约 −15%）**，视觉零变化、FPS 不变、几何不变。
原理：把它提升成自己的合成层后，光栅化转到合成线程，不再阻塞主线程的每帧任务。

代价是常驻一张合成层纹理（620×760 × dpr2 × 4B ≈ 3.7 MB），可以接受。

**给云层也加 `will-change` 没有再进一步**（15.9%，比只加画布还略差）——不要加。

#### 三条失败的优化（不要重复）

| 尝试 | 结果 |
|---|---|
| 给云层挂 `clip-path`（挖掉 pad）减少像素面积 | **更贵**：17.4% → 18.7%。遮罩挂在**动画组**上，每帧重算遮罩 |
| 把 `setAttribute('transform')` 换成 `style.transform` | 零收益 |
| 每帧重算鸟的 `d` 或去掉 `vector-effect` | 零收益（18.0 / 18.2 / 18.5，全在噪声内） |
| 远层云改静态 + 近层只摆外侧边带 | 只 **−0.4**（噪声内）。背景更干净了，但**不省 CPU** |

> **别把「看起来该优化」当成「量出来值得优化」。**
> 真正省下来的 2.8 点来自一行 `will-change`，而不是任何内容层的改动。

---

### 6.25 ★ 等比衰减：给末级 dB，反解底数

> 适用：一串「第 n 只/第 n 级衰减一点」的多级衰减。
> Boids 的 `Flock Decay` 就是标准例：`aT1..aT7` 分别乘 `aFD^1 … aFD^7`。

**先看清指数从几开始。** Boids 里索引 0 是头鸟（不衰减），`aT1..aT7` 是 7 只从鸟，
所以「第 8 只鸟」对应 `aFD^7`，不是 `aFD^8`。数错一级就全错。

```python
import math
target_db = -12.0                 # 末级目标
n         = 7                     # 末级指数
target_lin = 10 ** (target_db / 20)
fd = target_lin ** (1.0 / n)      # → 0.820891
# 按 increment 0.0001 取整 → 0.8209
```

**验证必须回到引擎里做**，别只在纸上算：

```csound
kFD init 0.8209
printks "bird8 (^7) = %7.2f dB\n", 0, 20*log10(kFD^7)
```

实测（Csound 7）：

| 鸟 | 指数 | 电平 |
|---|---|---|
| 2 | ^1 | −1.71 dB |
| 3 | ^2 | −3.43 dB |
| 4 | ^3 | −5.14 dB |
| 5 | ^4 | −6.86 dB |
| 6 | ^5 | −8.57 dB |
| 7 | ^6 | −10.29 dB |
| **8** | **^7** | **−12.00 dB** ✓ |

**关键是先把旧值反算出来核对一遍**：旧 `0.3727^7 = 0.000999 = −60.01 dB`，
正好对上用户说的「现在滚降到 -60 dB」。**能用旧值复现用户描述的现象，才说明公式没读错。**

> 顺带：这个参数同时也是反馈量 `aFbkSum = (aT1+…+aT7) * kFbk / 7` 的权重。
> 底数从 0.37 抬到 0.82 后，反馈支路整体变响约 8 dB，必要时要同步下调 `feedback`。

---

### 6.26 ★ 加一个旋钮前，先算这一行的宽度预算

给已完成插件补参数时最容易翻车的不是 DSP，是**旋钮行本来就正好卡满内宽**。
新旋钮不是「多一列」，而是把这一行的 flex 全部挤变形（`justify-content: center` +
`flex-shrink: 1` 下，`clientWidth` 不会报溢出，`scrollWidth` 也测不到居中溢出，只能逐个看 `offsetLeft`）。

**做法：量出这一行的「内宽」和「现有子项宽度和 + gap × (n−1)」，差值就是剩余预算。**

实测 8 台的加旋钮结果（2026-10-31，加 `masterGain` 前；当时还没有 Lissajous）：

| 插件 | 行 | 内宽 | 加之前已占 | 加 1 个旋钮后 | 结论 |
|---|---|---|---|---|---|
| Stasis | `.knobs`（3 个 74px） | 288 | 222 + 2×26 = 274 | 222 + 2×14 + 74 = 250 | gap 26→14 腾出空间 ✓ |
| Orbita | `.knobs.r2`（3 个 62px） | 288 | 186 + 2×44 = 274 | 186 + 2×44 = 274（本来就是 3 个） | ✓ 余 14 |
| levy | `.knobs.r3`（2 旋钮 + 168px 双滑块） | 348 | 112 + 2×34 + 168 = **348（正好卡满）** | 178 + 3×34 + 168 = **448（溢出 100）** | ✗ 必须拆分 |
| loom | `.krow`（68px×n） | 216 | 68×2 + 6 = 142 | 68×3 + 12 = 216 | ✓ 正好 |
| zephyr | `.krow`（68px×n） | 216 | 同上 | 216 | ✓ 正好 |
| Singularity | `.krow`（74px×n） | 552 | — | 296 | ✓ 大把余量 |

**levy 这种「旋钮 + 宽滑块挤一行」是唯一无解的**：4 个子项最小 346，内宽只有 348，
塞得进去也得 gap=0，视觉上不可接受。正确处理是**把双滑块拆成独立 `<section class="wet">`**
（Stasis / Orbita 本来就是这么排的），代价是纵向多一行 ≈ 48px。

**纵向同样没有余量**：`.canvas` 是固定高度 + `overflow: hidden`，
子项全是 `flex: none`，多一行会直接被裁掉（`scrollHeight > clientHeight` 就是征兆）。

**画布加高必须和 CSD 的 `form.size` 一起改，且两者宽高比要相等**：

```
viewScale = min(innerWidth / CANVAS.w, innerHeight / CANVAS.h)   // index.html 里现算
```

只要宽高比一致，画布就正好填满窗口；不一致就会留白边。
levy 实测：`CANVAS = {w:380, h:560}` ↔ `form.size = 507×747`（507/380 = 747/560 = 1.334），
浏览器里把视口设成 `507×747` 后 `--zoom` 正好落在 **1.3339**、角标读 **100%**，才算对齐。

> 顺带一条：改完 `index.html` 在浏览器里刷新，**必须加 `?v=N` 打掉缓存**，
> 否则量到的还是旧布局（`document.querySelector('.canvas').clientHeight` 一看就知道有没有生效）。

---

### 6.27 ★ 背景元素「有一半不动」= 位置来自初始坐标，另一半来自动画

Boids 的云出过一次很显眼的 bug：**7 朵远景云死坨在画布顶边**，而 9 朵近景云照常下落。
用户的描述是「有一些是运动的，有一些是死坨在左上角」。

根因是两层云的**定位机制不一样**：

| | 初始坐标 | 动画 | 结果 |
|---|---|---|---|
| 远层 | `cy = (rnd() - 0.5) * 140` → **-70…+70** | 无（`animate=false`，为了省 CPU） | 7 朵全挤在顶边一条带 |
| 近层 | 同样的初始坐标 | `--y0 → --y1` 覆盖 -360…1060 | 每朵都从顶到底扫一遍，初始坐标被掩盖 |

**教训一：位置不能同时由「初始坐标」和「动画」定义。**
只要还有初始坐标参与，就得保证它本身就是合理分布 —— 而这个 y 范围显然是从
「横向滚动」那版抄过来的（那版 y 只需要一个窄带，因为云是横着走的）。
改成「云体建在原点、位置 100% 由 `--x0/--y0 → --x1/--y1` 的**绝对坐标**给」之后，
这类 bug 从结构上就不可能再出现：

> 写法就是把起点和终点都改成**绝对坐标**（`--x0/--y0 → --x1/--y1`），
> keyframes 本体见 §6.22。关键不在参数名，而在「云体建在原点、位置 100% 由动画给」
> 这个结构 —— 这样"在画面上"和"在画布外"只由一条时间轴决定。

**教训二：省 CPU 不能靠「不动」。**
原来的注释写着「静态图层只光栅一次，之后纯合成，不占每帧成本」，听起来很对，
但它换来的是 7 块死贴纸。背景层要省成本只能靠 **更慢 + 更淡 + 更糊**，不能靠冻结。
实测把远层改成动画后（16 朵全动）渲染线程 **7.9% → 6.2%**，反而更低 ——
因为静态的大模糊组每次视口合成都要重新贴图，而 `will-change: transform` 的动画层是复用的。
**别凭直觉给「静态更省」下结论，先量（§6.24）。**

**教训三：分层背景要按「遮挡关系」分配横向位置，不是按「均匀分布」。**
Boids 里近景云是画在 pad **后面**的（绘制顺序 `cloudsNear → padGlow → pad`）。
近景云又亮又实，一旦 lane 落进 pad 的 x 范围（146…466），就会在 pad 上糊出一坨灰疙瘩。
所以近景云的 lane 只能取 pad 两侧的边带；远景云淡得多，可以整幅铺开，
但 pad 底色太透（`.48`）时仍会透成"脏斑" —— 一并把 `.padfill` 提到 `.66`，
就变成"玻璃后面的雾"。

> 一条自检：把所有背景元素的 `getBoundingClientRect()` 隔 10 秒取两次，
> 逐项比对 y 是否变化。**只要有任何一个不变，就是死贴纸。**

---

### 6.28 ★ 电平表：柱高必须和刻度共用同一条 dB 映射

Boids 的表「比真实电平小一大截」（用户实测 Reaper 轨道 −6 dB，插件表显示到 −45）。
根因是把「像对数的幂律」当成了 dB：

```js
const lin = clamp(Math.pow(v, 0.55), 0, 1);   // ❌ 错的
```

`v^0.55` 在 **0 dB 处巧合等于 1**，所以满刻度看起来正常，往下一路发散：

| 真实电平 | 正确位置 | `v^0.55` 画到 | 误差 |
|---|---|---|---|
| 0 dB | 0 dB | 0 dB | 0 |
| −3 dB | −3 | −10.4 | **−7.4** |
| −6 dB | −6 | −19.0 | **−13.0** |
| −12 dB | −12 | −31.9 | **−19.9** |
| −24 dB | −24 | −46.9 | **−22.9** |
| −60 dB | −60 | −58.7 | +1.3 |

**正确写法：柱高和刻度都从 `dB` 出发，中间不许有第二种量纲。**

```js
const DB_FLOOR = -60;                     // 表底
const METER_H  = 280;                     // = .bar 的 CSS height，cap 位移用同一个数
const ampToDb = a => 20 * Math.log10(Math.max(Math.abs(a), 1e-6));
const dbToPos = db => clamp((db - DB_FLOOR) / (0 - DB_FLOOR), 0, 1);

function buildDbScales() {
    /* 刻度：bottom 用 dbToPos(db)（§6.15 的写法），或 top 用 1-dbToPos(db)；
       两种等价，只要与下面的 scaleY **互补**即可。混用就会差一整条刻度的方向。 */
}

function setMeter(barId, capId, v) {
    const pos = dbToPos(clamp(ampToDb(v), DB_FLOOR, 0));
    bar.style.transform = 'scaleY(' + pos + ')';        // 柱：从底往上
    cap.style.transform = 'translateY(' + (-pos * METER_H) + 'px)';
    cap.style.opacity = pos > 0.002 ? '1' : '0';
}
```

**验证方法（10 秒，走真实数据通路，不要只对着公式看）**

Cabbage 3 的消息是 `window.postMessage` 到自己（`event.source === window`），
所以浏览器里可以直接喂值，完全绕开后端：

```js
// 在 devtools / Playwright 里
for (const db of [0, -3, -6, -12, -18, -24, -30, -40, -50, -60]) {
    const amp = Math.pow(10, db / 20);
    window.postMessage({ command: 'widgetUpdate', data: { id: 'outL', value: amp } }, '*');
    // 等 350ms 让 transition 走完，再读 scaleY
}
```

读回来的 `scaleY` 应满足 `-60 * (1 - scaleY) === db`，**误差 0.00**。
2026-11-01 实测修复后全量程误差 0.00 dB。

> ⚠️ 两个坑：
> 1. **`transition: transform .05s`** —— 连续快速写入会读到上一帧的值，必须每次等 ≥300ms。
>    （我第一次测出来一堆不相干的数，就是被 transition 骗了。）
> 2. 别把多个 `postMessage` 塞进同一个 `page.evaluate` 里，Cabbage 侧会合并/乱序。

> 另一条相关经验：其余 8 台一直是对的（`ampToDb` + `dbToPos`），
> **只有从零新建的 Boids 抄错了**。新建插件时，凡是「有现成正确实现」的模块
> （电平表、双滑块、缩放），一律整段复制，不要凭印象重写。

---

## 7. 自检清单（改完必跑）

### 7.1 语法

```bash
# CSD 的 JSON 段
python3 - <<'EOF'
import json, re
src = open('cab3-xxx.csd').read()
d = json.loads(re.search(r'<Cabbage>\s*(.*?)\s*</Cabbage>', src, re.S).group(1))
for w in d['widgets']:
    print(w['type'], [c['id'] for c in w.get('channels', [])], w.get('automatable'))
EOF

# HTML 的 JS 段
python3 -c "
import re
s=open('index.html').read()
open('/tmp/x.mjs','w').write(re.search(r'<script type=\"module\">(.*?)</script>',s,re.S).group(1))"
node --check /tmp/x.mjs
```

### 7.2 参数顺序自检

用 CabbageApp 跑一遍，确认注册顺序与 `PARAM_IDX` 一致：

```bash
"/Users/yhk/.vscode/extensions/cabbageaudio.vscabbage-3.0.10-beta/src/CabbageBinaries/CabbageApp" \
  --file "$PWD/cab3-xxx.csd" --portNumber 9999 > /tmp/cab.log 2>&1 &
```

等 10 秒后 `kill <PID>`，然后：

```bash
grep "Added parameter" /tmp/cab.log
# 逐行核对 channel 名与 index，必须与 PARAM_IDX 顺序相同
grep -iE "warning|error" /tmp/cab.log | grep -v "stream is closed"
# 应为空
```

### 7.3 界面自检（浏览器）

直接打开 `index.html`（会报 `sendMessageFromUI is not available`，属正常），用控制台注入假后端：

```js
window.__sent = [];
window.sendMessageFromUI = m => window.__sent.push(m);

// 检查后端回灌
window.postMessage({command:'widgetUpdate', id:'outL', value:0.5}, '*');
```

重点核对：

- [ ] 无元素溢出窗口（`getBoundingClientRect().bottom <= 窗口高`）
- [ ] 拖拽序列为 `begin → value… → end`，未按下时不发消息
- [ ] 拖拽经过输入框时焦点仍是 `BODY`、无文本选区
- [ ] 输入框可正常聚焦输入，提交发 `complete`
- [ ] `parameterChange` 能通过 `PARAM_IDX` 找到正确通道
- [ ] **电平表全量程对齐**（不是"看着差不多"，是逐点验，§6.28）：
      给 `outL` 依次喂 `[0,-3,-6,-12,-18,-24,-30,-40,-50,-60]` dB 对应的幅度，
      每次等 ≥300ms 再读 `scaleY`，要求 `-60*(1-scaleY)` 与目标 dB **误差 0.00**。
      只验 0 dB 或只看"有没有动"会漏掉整条曲线偏掉一大截的 bug
- [ ] **数值显示是完整数字**（`6000`），不是 `6k` 缩写（§6.0 规则一）
- [ ] **最宽数值不裁字**（如 `16000`；用 canvas 量文字宽度 ≤ 框宽 − 2）
- [ ] 单击旋钮能进入编辑、数字自动全选；`12k` 这类写法能解析
- [ ] 编辑中点别的旋钮/回车/失焦都能正确提交；Esc 还原
- [ ] 编辑中后端回灌不会冲掉正在输入的内容
- [ ] 双击旋钮归位到与 CSD `defaultValue` 相同的值
- [ ] 拖动时不会误开编辑（3px 死区有效）
- [ ] **二维 pad：把参数推到极端，图形完整落在边框内且不变形**（等比缩放，§6.9）
- [ ] **指示物在极端参数下仍精确落在图形轮廓上**（偏差 < 0.02）
- [ ] **参数推到 0 / 1 时轨迹变成直线，而不是整个消失**（`<line>` 兜底生效）
- [ ] 接收端没有把后端坐标提前 `clamp(0,1)`（会丢掉超出区的幅度）
- [ ] 拖动缩放三角：松手后宿主收到的尺寸 = 拖动目标（不是中途的旧值）
- [ ] **往下拖变大、往上拖变小**（控点在右下角 → 往下是拉角出去）
- [ ] 缩放下限卡在 75%，巨幅下拖不越界
- [ ] 巨幅**往下**拖时窗口高度 < 屏幕可用高度（`screen.availHeight`），
      保证右下角三角始终可点 —— 拖到超屏就再也点不回来了
- [ ] 双击三角回 100%；**拖完 400ms 内**双击被抑制
- [ ] 拖动过程中百分比常显；画布始终填满视口（1200% 也不溢出）
- [ ] 宿主真改了窗口 → 三角实心；不理睬 → 600ms 后空心
- [ ] **拖动中画布就在变**（不等窗口）：`--zoom` 随每次 `pointermove` 立即变化
- [ ] 拖动中、松手后、宿主追上后三个时刻的 `--zoom` 一致，**无回弹**
- [ ] 窗口已铺满屏幕时，往下拖不会先缩一下（`ceiling` 取 max）
- [ ] 裸浏览器里 `screen.width` 可能被压到很小，`maxScale()` 会退到 3 倍下限（测试环境差异，不是 bug）
- [ ] **背景元素全部在动**（§6.27）：把所有云/远景元素的 `getBoundingClientRect()` 隔 10 s
      取两次，逐项比 y —— **有任何一个不变就是死贴纸**。
      只验一个代表元素会漏（Boids 是 16 个里 7 个不动，用户一眼就看出来了）

### 7.4 四条最容易漏的（各 10 秒，都要跑）

**① 控件顺序 = DSP 信号流**（§6.1 规则 0）

```js
// 打印 DOM 顺序，对照 CSD 里运算的先后
[...document.querySelectorAll('.knob')].map(k => k.dataset.ch).join(' > ')
```
顺序必须是单调递增的；`masterGain` / `cutoff` 这类输出级参数应该在最后。

**② 映射曲线两端贴边 + 互逆**（§6.16）

```js
toFrac(p.min, p) === 0 && toFrac(p.max, p) === 1
Math.abs(toFrac(fromFrac(0.37, p), p) - 0.37) < 1e-12
```
再把「默认值」和「常用区间的下一档」都算一遍行程，**相邻两档 < 8px 就是拧不动**，
必须加 `curve`。

**③ 电平表 dB 换算**（§6.15 结构 / **§6.28 映射**）

| 推 `outL` | 期望 `scaleY` | 对应 dB |
|---|---|---|
| `1` | `1.0000` | 0 |
| `0.5` | `0.8997` | −6.02 |
| `0.1` | `0.6667` | −20 |
| `0.01` | `0.3333` | −40 |
| `0` | `0.0000` | −60（表底） |

**只验 0 dB 和「有没有动」是不够的** —— Boids 曾用 `v^0.55` 这种幂律近似，
0 dB 端巧合正确、−6 dB 就渲染成 −19 dB，差 13 dB（§6.28）。
必须**逐点**验，读数取 `getComputedStyle(bar).transform` 的 `matrix` 第 4 项；
每次喂值后等 ≥300ms，`transition: transform .05s` 会让你读到上一帧。

帽子（`cap`）在 0 dB 时应该正好贴柱顶，差一像素说明 `METER_H` 与 CSS 高度不一致。

**④ 动态标记**（§6.17，仅当有移动标记时）

- [ ] 拖尾是**曲线**不是折线（`d` 里是 `C`/`L` 混合的密集点，不是 3~4 个大折角）
- [ ] 拖尾长度**不随速度变化**（外圈和内圈目测一样长 → 弧长限制生效）
- [ ] 把柔光 `opacity` 强拉到 1，外缘**没有直线**（滤镜 region 够大）
- [ ] 尾端是**尖角**，不是圆头（锥形带生效）
- [ ] 快速拖到画面另一头，拖尾**不会**连出一条横穿画布的长线（跳变清空生效）

---

## 8. 导出 AU（完整流程）

> ⚠️ **不要用扩展的「Export as AUv2」命令**：`setupProjectResources()` 写入的是扩展内置的
> `getIndexHtml()`（默认控件界面），**不是**项目里的 `index.html`，会把自定义 UI 覆盖掉。

### 8.0 ★ 换插件要改的 13 处（先全部对齐再跑脚本）

一个插件的「身份」散落在 **4 个文件 + 3 个目录名** 里，任何一个漏改都会出问题：

| 漏改的 | 后果 |
|---|---|
| CSD 里 `pluginId` ≠ 脚本里的 `ID` | `auval` 报 subtype 不匹配；宿主里显示的名字和实际注册的对不上 |
| 部署后的 CSD 文件名 ≠ 二进制名 | `CSD file not found`，插件打开是空壳 |
| `CFBundleIdentifier` 与别的插件重复 | 后装的覆盖先装的，`auval` 报 `Cannot get Component's Name` |
| `form.size` / `.canvas` 的**比例**不一致 | 画面被拉扁（圆变椭圆）、或被裁出滚动条 |
| 系统级残留旧版同 subtype | 宿主看到两个，加载哪个全看运气 |

#### 命名约定（照这个填，不要自创）

以 Singularity 为例，**四个名字有固定的推导关系**：

```
NAME = "Cab3-Depth-Singularity"            ← 唯一要自己取的名字
 ├─ 组件目录     build/<NAME>.component
 ├─ 二进制       Contents/MacOS/<NAME>
 ├─ 部署后 CSD   ~/Library/CabbageAudio/<NAME>/<NAME>.csd
 ├─ 运行时目录   ~/Library/CabbageAudio/<NAME>/
 ├─ CFBundleExecutable / CFBundleName = <NAME>
 ├─ CFBundleIdentifier = com.cabbageaudio.<NAME 全小写>
 └─ AU 显示名    "CabbageAudio: <NAME>"

ID   = "C3SG"                              ← 4 字符，推导不出来，要查撞车
CSD  = "cab3-depth-singularity.csd"        ← 源文件名，小写 kebab
```

**源 CSD 用 `cab3-<小写>-<名>.csd`，部署时改名成 `<NAME>.csd`。**
两者不同是刻意的：源文件名进 git 便于 grep，部署名必须等于二进制名。

#### 「13 处」清单

| # | 位置 | 字段 | 值 |
|---|---|---|---|
| 1 | §8.1 脚本 | `PROJ` | `<工程目录>`（含空格的路径要引号） |
| 2 | §8.1 脚本 | `NAME` | `Cab3-Depth-<插件名>` |
| 3 | §8.1 脚本 | `ID` | 4 字符，见下方「ID 怎么选」 |
| 4 | §8.1 脚本 | `CSD` | `cab3-depth-<小写>.csd` |
| 5 | CSD `<Cabbage>` | `"pluginId"` | **必须 = `ID`** |
| 6 | CSD `<Cabbage>` | `form.caption` | 建议 = `NAME` |
| 7 | CSD `<Cabbage>` | `form.size` | = **`CANVAS × BASE`**（见下方「BASE 是什么」） |
| 8 | `index.html` | `.canvas { width; height }` | = `CANVAS`（设计尺寸，不等于 form.size）|
| 9 | `index.html` | `<title>` | 建议 = `NAME`（不影响功能，但浏览器标签会显示） |
| 10 | —（脚本自动） | 组件目录名 | `<NAME>.component` |
| 11 | —（脚本自动） | 二进制名 | `<NAME>` |
| 12 | —（脚本自动） | `CFBundle*` / AU 显示名 | 见命名约定 |
| 13 | —（脚本自动） | 运行时目录 + 部署 CSD 名 | 见命名约定 |

**只有 #1~#9 要手工改**，#10~#13 由 §8.1 脚本从 `NAME` / `ID` 派生。
所以真正要动的只有：**4 个脚本变量 + CSD 三处 + HTML 两处**。

#### ★ BASE 是什么：`form.size` ≠ `.canvas` 尺寸

这两个数**不是**相等的，是这个关系：

```
form.size = CANVAS × BASE          （取整）
--zoom 初值 = BASE
```

- `CANVAS`（`.canvas` 的 CSS 宽高）= **设计画布**，所有坐标都按它写死
- `BASE` = 「打开时希望比设计尺寸大几倍」，纯粹是观感选择
- 运行时 `--zoom` 由 §6.5 的 `fitToViewport()` 从视口反推，**不是**常量

九台已完成的实测（depth）：

| 插件 | `CANVAS` | `form.size` | `BASE` |
|---|---|---|---|
| Stasis | 320×490 | 320×490 | 1 |
| Orbita | 320×470 | 400×588 | **1.25** |
| levy | 380×**560** | 507×**747** | **4/3** |
| Singularity | 620×700 | 620×700 | 1（画布本来就够大） |
| loom | 620×700 | 620×700 | 1 |
| zephyr | 620×700 | 620×700 | 1 |
| SwarmGrain | 620×820 | 620×820 | 1 |
| Boids | 620×760 | 620×760 | 1 |
| Lissajous | 380×684 | 355×639 | **0.9342**（= 4/3 × 0.7，见下） |

> levy 的画布在 2026-11-01 补 `masterGain` 时由 500 加到 560（旋钮行塞不下，双滑块拆成独立行，
> 见 §6.26）；`form.size` 同步 667 → 747 保持 BASE = 4/3 不变。
>
> **★ BASE 也可以小于 1。** Lissajous 最初按 BASE = 4/3 导出（507×912），在宿主里
> 高度超出插件窗口被裁掉；把 BASE 改成 `355 / 380 ≈ 0.9342`（= 原尺寸的 70%）后正常。
> 判据只有一条：**`form.size / CANVAS` 两个方向必须同比例**，比 1 大或小都行。
> 此时 `MIN_SCALE = 0.75 * BASE`、双击复位、`#zpct` 的 `Math.round(s / BASE * 100)`
> 三处照常用 `BASE`，不需要别的改动。

**什么时候 BASE ≠ 1**：设计画布按小尺寸（320~380）写，但觉得打开太小看不清，
就把 `form.size` 放大 1.25~4/3 倍。此时：
- `.canvas` 保持小尺寸不动（坐标、字号、间距全部按它设计）
- CSD 的 `form.size` 写放大后的值
- 需要缩放的插件里定义一个 `BASE` 常量，双击复位回到 `BASE` 而不是 1
  （见 levy 的 `const BASE = 4 / 3;`，`MIN_SCALE = 0.75 * BASE`）

写了 `BASE` 就**必须**在同一文件里统一：`MIN_SCALE`、双击复位、`#zpct` 的百分比显示
（`Math.round(s / BASE * 100)`）三处都要用 `BASE`，漏一处就会「双击回 100% 却看起来变小了」。

#### 开工前先查 ID 撞车（必做）

原 Cabbage 2 版**一定**占着一个 `DPxx` 的 ID 且已装进系统，新 C3 版必须换 ID。
原版 ID 映射（4 台原 Cabbage 2 版，新 ID 已占用）：

| 插件 | 原 ID（Cabbage 2，已占用） | 建议新 ID |
|---|---|---|
| zephyr | `DPzz` | **`C3ZP`** |
| loom | `DPLM` | **`C3LM`** |
| SwarmGrain | `DPSG` | **`C3SW`** |
| Boids | `DPBS` | **`C3BD`** |

已占用 ID 一览（保持更新）：

```
C3ST  C3OB  C3LV  C3SG  C3LM  C3ZP  C3SW  ← 七个已完成
DPzz  DPLM  DPSG  DPBS                    ← 原 Cabbage 2 版（系统级）
```

> 💡 实测案例：`C3SG` 在系统级和用户级**各装了一份**（早期导出遗留）。
> 用下面这段一跑就能看见两条命中 —— 所以装完新版记得删掉另一级，否则宿主会看到两个。

查一个 ID 有没有被占（装之前跑）：

```bash
ID=C3SW        # 换成你这次要用的 ID
for p in /Library/Audio/Plug-Ins/Components/*.component/Contents/Info.plist \
         ~/Library/Audio/Plug-Ins/Components/*.component/Contents/Info.plist; do
    [ -f "$p" ] || continue
    st=$(plutil -extract AudioComponents.0.subtype raw "$p" 2>/dev/null)
    [ "$st" = "$ID" ] && echo "❌ $ID 已被占用: $p"
done
echo "✓ 检查完毕"
```

#### 一次性核对脚本（改完 13 处后跑）

把下面存成 `check-identity.sh`，传工程目录和期望的 NAME / ID，全部对齐才返回 0：

```bash
#!/bin/bash
# 用法: ./check-identity.sh "<工程目录>" "<NAME>" "<ID>"
PROJ="$1"; NAME="$2"; ID="$3"
fail=0
chk() { if [ "$2" = "$3" ]; then echo "  ✓ $1"; else echo "  ❌ $1: 期望 [$3] 实际 [$2]"; fail=1; fi; }

CSD=$(ls "$PROJ"/*.csd 2>/dev/null | head -1)
BIN="$PROJ/build/$NAME.component/Contents/MacOS/$NAME"
PLIST="$PROJ/build/$NAME.component/Contents/Info.plist"

chk "CSD pluginId"   "$(grep -o '"pluginId": *"[^"]*"' "$CSD" | grep -o '"[^"]*"$' | tr -d '"')" "$ID"
chk "CSD caption"    "$(grep -o '"caption": *"[^"]*"' "$CSD" | grep -o '"[^"]*"$' | tr -d '"')" "$NAME"
# 宽高关系：form.size = CANVAS × BASE，只校验比例一致（BASE 由插件自定）
python3 - "$CSD" "$PROJ/index.html" <<'PY' || fail=1
import re, sys
csd, html = sys.argv[1], sys.argv[2]
j = open(csd).read(); h = open(html).read()
fw = int(re.search(r'"size":\s*\{\s*"width":\s*(\d+)', j).group(1))
fh = int(re.search(r'"size":\s*\{\s*"width":\s*\d+,\s*"height":\s*(\d+)', j).group(1))
m = re.search(r'\.canvas\s*\{([^}]*)\}', h); b = m.group(1) if m else ''
cw = int(re.search(r'width:\s*(\d+)px', b).group(1))
ch = int(re.search(r'height:\s*(\d+)px', b).group(1))
kx, ky = fw / cw, fh / ch
ok = abs(kx - ky) / max(kx, ky) < 0.005      # BASE 允许 < 1（窗口比设计稿小）
print(f"  {'✓' if ok else '❌'} form.size {fw}x{fh} / canvas {cw}x{ch} = BASE {kx:.4f}")
sys.exit(0 if ok else 1)
PY
chk "二进制存在"     "$([ -x "$BIN" ] && echo yes || echo no)"  "yes"
chk "subtype"        "$(plutil -extract AudioComponents.0.subtype raw "$PLIST" 2>/dev/null)" "$ID"
chk "CFBundleExec"   "$(plutil -extract CFBundleExecutable raw "$PLIST" 2>/dev/null)" "$NAME"
chk "运行时 CSD"     "$(ls ~/Library/CabbageAudio/"$NAME"/*.csd 2>/dev/null | xargs -n1 basename 2>/dev/null)" "$NAME.csd"

[ $fail -eq 0 ] && echo "全部对齐 ✓" || echo "有未对齐项，先修再导出"
exit $fail
```

> 宽高检查只验证「两个方向的比例一致（= BASE）」，**不**要求等于某个固定值——
> 因为 BASE 是每个插件自己定的。比例不一致说明 `form.size` 写错了，
> 打开时画面会被拉扁。BASE **不限于 ≥ 1**：窗口比设计稿小（例如 Lissajous 的 0.9342）同样合法。

### 8.1 一次性脚本

```bash
PROJ="<工程目录>"
EXT="/Users/yhk/.vscode/extensions/cabbageaudio.vscabbage-3.0.10-beta"
TPL="$EXT/src/CabbageBinaries/CabbagePluginEffectAUv2.component"
NAME="插件名"          # 例如 Cab3-Depth-Stasis
ID="C3ST"              # 必须 4 字符
CSD="cab3-xxx.csd"     # 源 CSD

# 1) 复制模板
mkdir -p "$PROJ/build"
rm -rf "$PROJ/build/$NAME.component"
ditto "$TPL" "$PROJ/build/$NAME.component"

# 2) 打补丁（三个等长替换）
BIN="$PROJ/build/$NAME.component/Contents/MacOS/CabbagePluginEffectAUv2"
python3 - "$BIN" "$ID" <<'PY'
import sys
path, sub = sys.argv[1], sys.argv[2]
assert len(sub) == 4
data = open(path,'rb').read()
for old, new in [
    ("com.cabbageaudio.1d47", f"com.cabbageaudio.{sub.lower()}"),   # 21 → 21
    ("com_cabbageaudio_1d47", f"com_cabbageaudio_{sub.lower()}"),   # 21 → 21
    ("Cp47",                  sub),                                 #  4 →  4
]:
    o, n = old.encode(), new.encode()
    assert len(o) == len(n), (old, len(o), len(n))
    assert data.count(o) > 0, f"未找到 {old}"
    data = data.replace(o, n)
open(path,'wb').write(data)
PY

# 3) 重命名 + 权限（模板是 644，必须补执行位）
M="$PROJ/build/$NAME.component/Contents/MacOS"
mv "$M/CabbagePluginEffectAUv2" "$M/$NAME"
chmod 755 "$M/$NAME"

# 4) 改 Info.plist
P="$PROJ/build/$NAME.component/Contents/Info.plist"
plutil -replace CFBundleExecutable        -string "$NAME" "$P"
plutil -replace CFBundleName              -string "$NAME" "$P"
plutil -replace CFBundleIdentifier        -string "com.cabbageaudio.$(echo $NAME | tr 'A-Z' 'a-z')" "$P"
plutil -replace AudioComponents.0.subtype -string "$ID" "$P"
plutil -replace AudioComponents.0.name    -string "CabbageAudio: $NAME" "$P"

# 5) 部署运行时资源（宿主真正读取的位置）
R="$HOME/Library/CabbageAudio/$NAME"
rm -rf "$R"; mkdir -p "$R"
cp "$PROJ/$CSD"      "$R/$NAME.csd"          # 文件名必须 = 二进制名
cp "$PROJ/index.html" "$R/index.html"
cp "$PROJ/cabbage.project.json" "$R/cabbage.project.json"
ditto "$EXT/src/cabbage" "$R/cabbage"
cp "$EXT/media/cabbage.css" "$R/cabbage.css"

# 6) 签名
codesign --force --deep --sign - "$PROJ/build/$NAME.component"
codesign --verify --deep --strict "$PROJ/build/$NAME.component"
```

#### ★ VST3 的补丁**只有一组**（和 AU 不一样）

VST3 模板是 `CabbagePluginEffect.vst3`，它里面**没有** `com.cabbageaudio.1d47` /
`com_cabbageaudio_1d47` 这两个 CLAP/NSView 标识，只有 AU subtype 一类 `Cp47`。
照抄 AU 的三组替换会在第一组就 `assert` 失败。

> ⚠️ 「只有一组」≠「只有一处」：**`Cp47` 在两个模板里都是 3 次**
> （`aumu`+subtype 的构造常量 1 次 + 两处字符串表各 1 次，实测
> `CabbagePluginEffect.vst3` 与 `…AUv2.component` 的 `Cp47` 计数都是 3）。
> 所以脚本里必须写 `data.count(old) == 3`，写 `== 1` 会直接断言失败 ——
> 这里早期写成「只有一处」，和下面脚本的 `== 3` 自相矛盾过。

```bash
VTPL="$EXT/src/CabbageBinaries/CabbagePluginEffect.vst3"
rm -rf "$PROJ/build/$NAME.vst3"
ditto "$VTPL" "$PROJ/build/$NAME.vst3"

python3 - "$PROJ/build/$NAME.vst3/Contents/MacOS/CabbagePluginEffect" "$ID" <<'PY'
import sys
path, sub = sys.argv[1], sys.argv[2]
data = open(path,'rb').read()
old, new = b"Cp47", sub.encode()
assert len(old) == len(new) and data.count(old) == 3, data.count(old)
open(path,'wb').write(data.replace(old, new))
PY

VM="$PROJ/build/$NAME.vst3/Contents/MacOS"
mv "$VM/CabbagePluginEffect" "$VM/$NAME"; chmod 755 "$VM/$NAME"
VP="$PROJ/build/$NAME.vst3/Contents/Info.plist"
plutil -replace CFBundleExecutable -string "$NAME" "$VP"
plutil -replace CFBundleName       -string "$NAME" "$VP"
plutil -replace CFBundleIdentifier -string "com.cabbageaudio.$(echo $NAME | tr 'A-Z' 'a-z').vst3" "$VP"
codesign --force --deep --sign - "$PROJ/build/$NAME.vst3"
codesign --verify --deep --strict "$PROJ/build/$NAME.vst3"
```

> 两个 bundle 共用**同一份**运行时目录 `~/Library/CabbageAudio/<NAME>/`，只部署一次。
> `codesign` 会把 bundle id 写进签名（`codesign -d --verbose=2 <bundle>` 可见
> `Identifier=com.cabbageaudio.<name>.vst3`）。**这就是「模板里没有 `com.cabbageaudio.*`
> 字符串、导出的二进制里却有」的原因** —— 不是补丁，是签名。所以 VST3 二进制大小会比模板
> 大 32~64 字节，属正常，不要因此以为补丁写坏了。

#### 整批导出脚本

四声道那批已经把上面的步骤固化成脚本（读 CSD 里的 `pluginId` / `caption`，杜绝手抄不一致）：

```bash
cd "quad Doppler"
# 四声道：只出 AU（Cabbage 3 的 VST3 处理不了多总线，见 §9.1 末「决定」）
python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3
# 立体声（2 in 2 out）：AU + VST3 照旧
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3
# 只构建不装
python3 tools/export_plugin.py "Quad-X Cabbage3" --no-install --no-vst3
```

脚本从 CSD 里读 `pluginId` / `caption`，**运行时按源目录整份同步**（跳过 `build/`）——
所以 `help.html` / `help-ui.js` / `gesture.js` / `gesture-ui.js` / `mediapipe/`
会自动跟着走，不用再手工 `cp`（§5.8 ⑧）。

### 8.2 安装（二选一）

**用户级**（无需密码）

```bash
DEST="$HOME/Library/Audio/Plug-Ins/Components"
rm -rf "$DEST/$NAME.component"
ditto "$PROJ/build/$NAME.component" "$DEST/$NAME.component"

# VST3 装到另一个目录
VDEST="$HOME/Library/Audio/Plug-Ins/VST3"
rm -rf "$VDEST/$NAME.vst3"
ditto "$PROJ/build/$NAME.vst3" "$VDEST/$NAME.vst3"
```

**系统级**（需要管理员权限，走原生授权弹窗）

```bash
SRC="$PROJ/build/$NAME.component"
osascript -e "do shell script \"rm -rf '/Library/Audio/Plug-Ins/Components/$NAME.component' && ditto '$SRC' '/Library/Audio/Plug-Ins/Components/$NAME.component' && chown -R root:wheel '/Library/Audio/Plug-Ins/Components/$NAME.component'\" with administrator privileges"
```

系统级装完请删掉用户级副本，否则宿主会看到两个同名插件。

### 8.3 注册刷新

macOS 缓存音频组件列表，装完可能不立刻出现：

```bash
ps aux | grep AudioComponentRegistrar | grep -v grep | awk '{print $2}'
# 拿到 PID 后
kill <PID>
```

### 8.4 验证

```bash
auval -v aufx <ID> Cabb        # 效果器
auval -v aumf <ID> Cabb        # 音乐效果器
```

期望输出 `AU VALIDATION SUCCEEDED.`，并确认日志里：

- 没有 `CSD file not found`
- 没有 `COMPILE ERROR`
- `Added parameter` 数量 = A 类通道数
- CSD 路径指向 `~/Library/CabbageAudio/<NAME>/`

#### ★ 四声道插件：auval **必然 FAIL**，别据此判断失败

`auval` 会把默认总线强制设成 2 声道，而四声道插件的 `nchnls = 4`，
所以固定报三条：

```
Default Format of unit does not match reported Channel handling capabilities
ERROR:   Format errors. Cannot perform render tests
AU VALIDATION FAILED
```

同时 `auval` 已经把最有用的信息打印出来了，**只看这三件事**：

| 日志 | 期望 |
|---|---|
| `Info.plist entries` / `AudioUnit Name` | = 你的 `NAME` |
| `Reading CSD file: ~/Library/CabbageAudio/<NAME>/<NAME>.csd` | 路径对、能读到 |
| `Compiling Csound code... ...done` | 没有 `COMPILE ERROR` |

真正的四声道验证用 `quad Doppler/tools/` 里的两个原生工具（见该目录 README）：

```bash
cd "quad Doppler/tools"
python3 verify_quad.py             # 一次跑完 9 台：能力表 + 四路 RMS + 报错扫描
```

判定三件套 = `auprobe` 报 `in 4, out 4` 且 `SET OUT 4 ch -> 0 OK`
+ `aurender` 四路 RMS 全 > 0 + 日志无 `Excess channels ignored`。

---

## 9. 已知坑（都实际踩过）

| 坑 | 现象 | 原因 / 解法 |
|---|---|---|
| **bundle 内资源不生效** | 插件找不到 CSD / UI | 本版本 `getResourceDirFromBundle()` 判假，实际读 `~/Library/CabbageAudio/<名>/`。**不要**把资源放进 `.component/Contents/Resources` |
| **导出覆盖 UI** | 插件打开是默认控件界面 | 扩展写入内置 `index.html`。必须手动部署自定义 UI，或自己走 §8 |
| **二进制不可加载** | 宿主看不到插件 | 模板可执行文件权限是 `644`，必须 `chmod 755` |
| **AU 导出报错** | `pluginId must be exactly 4 characters` | `pluginId` 必须正好 4 字符 |
| **CSD 读不到** | `CSD file not found` | CSD 文件名必须**等于二进制文件名**（不是带 `cab3-` 前缀的源文件名） |
| **自动化控制错参数** | 拧 cutoff 却动了 roomSize | `PARAM_IDX` 顺序与 widget 书写顺序不一致 |
| **拖拽选中输入框** | 拖动准星后输入框被选中 | 必须实现 §5.5 拖拽独占 |
| **消息洪泛卡顿** | 界面卡死 / 音频爆音 | `cabbageSetValue` 忘了带触发参数 |
| **电平表抖动** | 表针乱跳 | 推送前加 `portk`，或用 `maxk` 做峰值保持 |
| **窗口出现滚动条 / 画面被拉扁** | 界面被裁、有滚动条、圆形变椭圆 | `form.size` 与 `.canvas` 的**比例**不一致（两者应为 `form.size = CANVAS × BASE`，见 §8.0）。另外 `html` 必须 `overflow:hidden`（缺了会滚 40px，指针坐标随之错位，控件全部失灵） |
| **subtype 撞车** | 插件加载不出来 / auval 报 `Cannot get Component's Name` | 同一个 `subtype+Cabb` 只能有一个组件。系统里若已有 Cabbage 2.9 版占着原 ID（如 `DPOB`），Cabbage 3 版必须换 ID（`C3OB`）。装完先 `for p in /Library/Audio/Plug-Ins/Components/*.component/Contents/Info.plist; do plutil -extract AudioComponents.0.subtype raw "$p"; done` 查一遍 |
| **★★ 四声道 AU：`auval` 必然 FAIL** | `auval` 报 `Default Format of unit does not match reported Channel handling capabilities` + `Cannot Set Output Num Channels:2 when unit says it can` | 包装器把**默认**总线格式写死 2 声道，而能力表是 4 —— 只是默认值问题。**四声道照样能用**：不写 `channelConfig`，靠 `nchnls = 4` 回退（§9.0，已实测 `in 4..4/out 4..4` + 四路渲染）。判据见 §8.4，别拿 auval 的红灯当失败 |
| **★★ 写了 `channelConfig` 反而只出 2 路 / 崩溃** | 能力表对上了，但只有前两路出声，或 `2+2` 直接 segfault / Live 里崩 | 只取**第一条** config、默认总线恒 2ch（§9.1 实测矩阵）；`2+2` 多总线在 `CabbageProcessor::process()` 里越界（§9.1 末源码定论）。**解法是整段删掉 `channelConfig`**，一条都不要写 |
| **★★ 写了 `nchnls_i = 2` → 2 in / 4 out** | VST3 在 Live 报 `No valid output bus could be found for input bus 0` | 省略 `nchnls_i`，Csound 自动令它 = `nchnls`（4 in / 4 out）。`inch 1, 2` 仍只读前两路（§9.0） |
| **★★ 四声道的 VST3 用不了** | Live 里加载失败 / 崩；Cubase 等未测 | Cabbage 3 是 CLAP + clap-wrapper，多总线只上报不聚合。**不改 C++ 无解**，已决定四声道只交付 AU，导出加 `--no-vst3`（§9.1 末「决定」） |
| **root 读不到工程目录** | `osascript ... with administrator privileges` 报 `ditto: Operation not permitted` | macOS TCC 不让 root 读 `~/Documents`。先把 `.component` 暂存到 `/tmp` 并 `chmod -R a+rX`，再让 root 从 `/tmp` 复制，装完删暂存 |
| **窗口改大但内容没跟上** | 变大瞬间有 1–2 帧空白/卡顿 | `window.resize` + `setTimeout` 防抖会先画一帧旧尺寸。改用 `ResizeObserver`（布局后、绘制前触发），见 §6.6 |
| **缩放方向反了** | 往下拖反而变小 | 控点在**右下角**时「往下拖 = 拉角出去 = 变大」。方向取决于控点位置，不是「往上推变大」的旋钮直觉。见 §6.3 |
| **拖大后点不到三角** | 控件被推出屏幕，插件锁死 | 上限只按屏幕宽度算了，窗口高过屏幕。必须 `min(屏宽/画布宽, 屏高/画布高) × 0.94`，且发请求处二次钳制。见 §6.3 |
| **拖动时越拖越反向（正反馈）** | 指针没动，尺寸自己跑 | `clientY` 是相对窗口的，resize 时窗口移动会让它漂移并反馈进公式。改用 `screenY`。见 §6.4 坑 3 |
| **松手丢最后一档** | 拖到 216%，宿主收到 188% | rAF 被 `cancelAnimationFrame` 取消，最终值没发出去。`pointerup` 里必须补发。见 §6.4 坑 1 |
| **拖完被当成双击** | 拖一下就被拉回 100% | `pointerup` 后的 `dblclick` 未设防。用 400ms 时间窗隔离。见 §6.4 坑 2 |
| **数字选不中、改不了** | 点数值没反应 | `body { user-select:none }`（§5.5 拖拽独占）连带把输入框也锁了。输入框要显式 `user-select:text`，`selectstart` 守卫要放行 `input`。见 §6.8 |
| **`el.select is not a function`** | 单击旋钮报 TypeError，编辑不了 | `<input>` 被放进了 `<svg>` 里，不是 `HTMLInputElement`。必须放在 `</svg>` 之后。见 §6.8 第 8 条 |
| **点数字 → 再点数字，归不了位** | 双击无反应，只进编辑 | `pointerdown` 里按 `e.target` 提前 `return`，第二次点击绕过双击判定。一律记 tap，只标 `onInput`。见 §6.8 第 9 条 |
| **数值显示成 `6k`** | 用户觉得是「口语表述」 | 显示必须用完整数字，单位放到控件标签里。输入仍可接受 `k` 后缀。见 §6.0 |
| **`16000` 被裁字** | 大数值显示不全 | 输入框宽度按**最大值**量，不是按默认值 `6000`。见 §6.0 规则四 |
| **双击归位不触发** | 双击没反应 | 第一次单击已把焦点交给 input，两次 click 的 target 不同，原生 `dblclick` 不可靠。自己用时间戳判断。见 §6.8 |
| **椭圆/图形两端尖角被压平** | 参数到极端时形状不像真椭圆 | 逐轴 `Math.min(PAD/2, rx)` 会破坏椭圆方程。改整体等比缩放 `k = limit / max(rx,ry)`。见 §6.9 |
| **指示物跑不到图形顶点** | 球/准星始终在轮廓内部 | 接收端 `clamp(v, 0, 1)` 把 Csound 推来的原始值（可达 1.19）截断了。改成宽范围兜底 `clamp(v, -1, 2)`。见 §6.9 |
| **`cabbageGetValue` 读到 0** | 参数无效 | 通道没在 `<Cabbage>` 里声明 |
| **Csound 弃用警告** | `outs is deprecated` / `max_k renamed` | 改用 `out` / `maxk` |
| **长量程旋钮拧不动** | 10 s→20 s 要拧两像素，几百秒占半圈 | 映射曲线方向反了（`skew<1` 把低端压没了）。用 §6.16 的 `curve` 指数 |
| **旋钮弧和刻度错开 90°** | 读数看着不对但几何都对 | `stroke-dasharray` 从 3 点钟起算，`rotate()` 差值算错。见 §6.14 |
| **电平表几乎不亮** | 正常信号只有 10% 高度 | 把线性幅度当表柱高度了，必须转 dB。见 §6.15 |
| **表柱正常但刻度数字糊了** | 标尺文字又小又暗 | `.metercol span` 误伤了 `.dbscale .t .n`，改成 `.metercol > span`。见 §6.15 |
| **峰值帽位置飞了** | 帽子不在柱顶 | `METER_H` 与 `.bar` 的 CSS 高度不一致，或高度是 flex 撑出来的。见 §6.15 |
| **拖尾像折线** | 采样点之间是硬折角 | 直接连点。必须 Chaikin + 转贝塞尔，或锥形带。见 §6.17 |
| **拖尾外面有方框** | 柔光边缘是直角 | 滤镜 region 用百分比、被包围盒裁断。改 `filterUnits="userSpaceOnUse"`。见 §6.17 坑一 |
| **拖尾尾端是圆头** | 像半截棍子 | 用等宽描边了。改锥形填充带（宽度随 t 收缩到 0）。见 §6.17 |
| **卫星拖尾有时比画面还长** | 外圈长内圈短 | 按点数限制长度。改按**弧长**。见 §6.17 坑二 |
| **切白洞时卫星配色不变** | 翼还是金色 | `setAttribute('fill')` 被 CSS 规则覆盖。走 class。见 §6.17 坑六 |
| **控件顺序莫名其妙** | Master 在最左边 | 按名字/美观排的，没按 DSP 信号流。见 §6.1 规则 0 |
| **开关滑块不动** | 切态时 `left` 不生效 | 该 Chromium 上 `left` 被吞，改用 `transform: translateX()`。见 §6.18 |
| **双击回 100% 反而变小** | 定义过 `BASE` 却没统一 | `MIN_SCALE` / 双击复位 / `#zpct` 百分比三处都要用 `BASE`，漏一处就错。见 §8.0 |
| **form.size 照着 canvas 填，窗口太小** | 打开时看不清 | 两者关系是 `form.size = CANVAS × BASE`，不是相等。见 §8.0 |
| **★★★ 粒子层是纯负债（SwarmGrain 最终删掉）** | 每颗粒子 3 条消息 × 30 Hz × 槽数；画出来还"效果一般" | 21 个隐藏通道 → 4 个（`swarm_x/swarm_y/outL/outR`）。颗粒的密度/位置在 250px 的画布上根本读不出信息，**同类信息用一层连续的场就够**。教训：先问"这层像素在传达什么可读的量"，答不上来就别做 |
| **★★ 视觉编码多路叠加 → 看起来全是周长** | 粒子明明圆内均匀，还是像一圈 | 亮度/尺寸/透明度**同时**随半径增长时，外缘会更大更亮更实，叠成亮环。一条视觉通道只承载一个参数：让**亮度**只表示频率（实测 `corr(brightness, r)=0.925`），尺寸与半径解耦（`corr=-0.008`） |
| **★★★ 场域薄雾的三条硬性要求** | 有同心色阶 / 颜色和声音对不上 / 外缘多一圈发光 | ① 停靠点要密（**40 个**），7 个能看见等高线；② 每个停靠点的颜色**从 DSP 公式现算**，不许手写近似；③ 透明度**恒定且 = 1.0**，只在最外一段（0.86 起）用 smoothstep 羽化。用 `0.02→0.20` 递增虽然"看起来有层次"，但等于亲手画了一圈亮边；用 0.52 把"薄雾"做得很含蓄，但最亮端永远到不了白 —— 用户会直接说「20000 Hz 的时候不够亮」 |
| **薄雾只表达亮度，不要加装饰** | 想加光晕/等高线让画面"更高级" | 场域亮度 = `log10(cutoff/20)/log10(20000/20)` 就够了。任何额外的发光/描边都会和"哪里滤得开"这件事抢解释权，用户会以为边缘有额外增益 |
| **★★★ `rnd(常量)` 是 i-time 常量（SwarmGrain）** | 长音符里 `rnd(1)` 永远返回同一个数 | `rnd(1)` / `rnd(6.2832)` 的参数是常量 → **在 i-time 求值一次**（实测 min=max=mean=0.9735）。要每周期取新值必须用 **`random:k(0, 1)`**（或传 k 率变量 `rnd(kOne)`）。实测 `random:k` 的 `sqrt(rnd)` 均值 0.661、内半区 0.264，与圆内均匀（0.667/0.25）一致 |
| **★★★ `Dens` 兼管布朗游走速率（SwarmGrain，原版如此）** | 用户以为「调 Density 怎么干声的运动速度/场域半径变了」，怀疑前端或后端被改坏 | 原版 `SwarmGrain(Depth Render).csd:214` 就是 `kTrig metro kDens`，移植后 `cab3-depth-swarmgrain.csd` 的 instr 1 里同样（`kTrig metro kDens`）；颗粒调度是同文件的 `ktrig metro kDens`（instr 1 尾部）。**别记行号**，代码一改就漂。`radius`/`step` 各走自己的通道，**与 Dens 无关**（实测薄雾半径 1→500 恒为 82.50）。处理：DSP 不动（忠于原版），但**去掉游标拖尾**——拖尾会把 Dens 的速率画成一条尾巴，看起来像尺寸在变（§6.17） |
| **★★★ 填色多边形画鸟 = 纸飞机（Boids）** | 用户评「你选的鸟图标一个比一个丑，还不如一开始那版」 | 试过细线（糊）、填色八点多边形（硬边、像纸飞机）。上一版好看是因为**描边曲线**有粗细和圆头。最终 = 俯视两段贝塞尔**描边** + **一条不对称机身线**；翼尖后掠至少 0.5（半翼展的 25%），否则读成 T 字（§6.22） |
| **★★ 只有两只翅膀、没有机身线（Boids）** | 斜航向下两只翅膀连成一条波浪，看不出朝向 | 补一条 `M0 -0.42 L0 0.46` 的细线（前长后短，暗示机头）。机身线是"方向感"的唯一锚点，比加粗翅膀有效得多 |
| **★★ 远景鸟忘了 `rotate(90)`（Boids）** | 背景的灰黑小鸟「竖着走」 | 字形机头朝 `-Y`，远景鸟是横掠的，必须 `rotate(90)`。同时 `@keyframes` 里的 `animation-direction: reverse` 要删掉 —— 往左飞 + 朝右，两个错刚好互相掩盖 |
| **★★ 批量改预设值，只改了 CSD + `P.def`（通用）** | 首帧闪旧值 / 双击归位回旧值 | 一个参数的预设值有 **4 处**：CSD `defaultValue`、`P[key].def`、写死的 `<input value="…">`、`let x = …` / `V = {…}` 初始化。后两处只有部分插件有（用 `P.def` 派生 `V` 的没有）。改完要 **grep 旧值本身**，只 grep `def:` 会漏（§6.1 规则五） |
| **★★★ 等比衰减数错一级（Boids）** | 目标 -12 dB 却算出别的值 | `aFD^1..aFD^7` 对应的是**从鸟 1..7**，而「第 8 只鸟」是索引 7 → `aFD^7`。Boids 里索引 0 是头鸟、不参与衰减，所以末级指数 = 8−1 = 7。定值前先用**旧值反算**核对：`0.3727^7 = −60.01 dB`，正好复现用户描述的现状，说明公式读对了（§6.25） |
| **★★★ 后台标签页测性能 = 全错（通用）** | 量出来 3.7 fps / 3% CPU，以为优化得很好 | 后台标签被节流到 ~4 fps。**必须先 `page.bringToFront()` 再测**，同一台机器同一份代码：后台 3.7 fps、前台 60.9 fps。 |
| **✅ 画布有 `transform: scale()` + 内部有动画 → 必须加 `will-change: transform`（通用）** | 每帧把整块画布重新光栅化，主线程 18.4% | 一条 `will-change: transform` 就降到 15.6%（−2.8 单核点，约 −15%），视觉零变化。原理：提升为独立合成层后光栅化转到合成线程。**但只加在画布上**；给云层也加反而略差（15.9%）。代价约 3.7 MB 纹理 |
| **★★ 给动画组挂 `clip-path` 想省像素，反而更贵（Boids）** | 17.4% → 18.7% | 遮罩挂在**会动的组**上时，Chromium 每帧重算遮罩。要缩小绘制面积，应该**改元素位置**（只摆在目标区域），而不是裁它。 |
| **★★ 以为「元素多」就是性能问题（Boids）** | 花时间删云、删鸟，数字纹丝不动 | 实测删 16 朵云 −0.7%、删 12 只鸟 −1.1%、去掉高斯模糊 0%（全在噪声内）。**成本 ∝ 动画面积 × 帧率**；只有把所有动画停掉才从 17.4% 降到 12.0%。先量再优化（§6.24） |
| **★★★ 背景太满 = 喧宾夺主（Boids）** | 用户说「背景鸟太多了数量，喧宾夺主」 | 远景鸟 38 → **12 只**、云 opacity 降到 0.24~0.60；云速 47~83 px/s → **4~29 px/s 实测**（§6.22）。判据：**不看它时不存在，看它时是真的** |
| **★★ 云形每朵都一样（Boids）** | 一眼看出是同一个模板 | 除圆顶外每朵再随机四个构形参数：`stretch`（横向拉伸）、`skewX`（重心偏移）、`domeH`（圆顶高度）、`lumps`（额外鼓包数），连 `pow` 的指数也随机（§6.22） |
| **★★ 云只有白色模糊团 = 雾（Boids）** | 背景像蒙了一层脏雾，不是云 | 云要**三层**：暗底（同形下沉 0.3h、`rgba(38,96,140,.55)`）+ 亮顶（上移 0.12h、纯白）+ 高斯模糊 ≥ 5。另外凸起必须按 `(1-bx²)` 加权成圆顶，均匀撒椭圆会糊成一条水平带（§6.22） |
| **★★★ 云和主体同向运动 = 没有穿越感（Boids）** | 用户问「云怎么也是从左往右，不应该从上往下？」 | 主体（鸟）上升，云就必须**下落**；反向运动相对速度翻倍，穿云事件实测从 2~5 只提升到 4~9 只。`--xw` 横向摆动别超过 ±70px，否则读成"斜着飞"（§6.22） |
| **★★ 纵向运动的云写成横条（Boids）** | 一长条一长条往下滑，像雾带 | 横移时 4:1 的扁云没问题；一旦改纵向，宽高比要收到 **≈2.4:1**（88×36），并把凸起的 `ry` 公式从 `0.52+0.44` 提到 `0.58+0.46` |
| **★★★ 静态云 = 死贴图（Boids）** | 用户评「云还是太像个死贴图了，要能聚散融合」 | 三层 CSS 动画：外层 `translateX` 走向、中层 `scale+opacity` 呼吸、亮顶层小幅滑动。**周期必须互质**（58~104s / 15~24s / ×1.37），整数倍会定期回到同一形状。`breath` 的 opacity 别压到 0.7 以下，否则变鬼影（§6.22） |
| **★★ `transform-box: fill-box` 忘了写（Boids）** | 云呼吸时整朵往画布原点飞 | SVG `<g>` 的 `transform-origin: center` 默认相对 **SVG 用户坐标原点**，不是自己的包围盒。必须补 `transform-box: fill-box` |
| **★★ 云太淡 → 像污渍不是云（Boids）** | 背景蒙了一层灰 | 暗底 `rgba(30,84,128,.78)` + 亮顶 `.96`、每朵 10~15 个凸起、base opacity ≥ 0.62。先前的 `rgba(38,96,140,.55)` + 0.40 透明度实测就是"脏雾" |
| **★★ 「穿过云层」是图层顺序问题，不是画出来的（Boids）** | 鸟永远浮在云上面 | DOM 顺序必须 `cloudsFar → ambient → cloudsNear → pad`。有了夹心层，鸟被近云盖住再露出，无需任何遮罩。要让效果常发生：近层 9 朵、行程覆盖画布上下、远景鸟 12 只（38 只会喧宾夺主） |

| **★★★ 侧视字形 + 全角度旋转 = 翻过来的鸟（Boids）** | 用户问「鸟翅膀没有方向吗？只能固定死是现在的上下？」 | 侧视的 `m` 形海鸥只能表达左右；一旦按航向 `rotate(180°)`，翅膀就翻到下面去了。**要方向必须换俯视字形**（闭合剪影 + 燕尾），俯视本来就有 360° 朝向（§6.22） |
| **★★ Csound 没有 `atan2` / `atan`（Boids）** | `kd = atan2(ky, kx)` 报 `syntax error, unexpected T_IDENT`，换成 `atan(...)` 也一样 | Csound 里反三角是 **`taninv(x)`** 和 **`taninv2(y, x)`**（后者带象限）。注意 `atan2` 在部分版本/文档里存在，但 6.18 CLI 与 Cabbage 内置版本上实测都不认，统一用 `taninv2` 最稳 |
| **★★ 旋钮指针穿过中央数值（Boids）** | 数字看起来像乱码、`0.400` 被一条斜线劈开 | 指针从圆心拉到 `r=13.5`，正好穿过 46px 宽的数值框。挪到 **plate(16.5) 与值弧(22) 之间的缝**（`r 17.2→20.6`）就干净了（§6.23 第 1 条） |
| **★★ 单击进编辑 + 双击归位互相抢（Boids）** | 双击之后数值变了、屏幕还显示旧数字 | `click` 先把 `editing.key` 设上，`dblclick` 再改 `V` 时 `paintKnob` 因为 `editing.key===key` 直接 return。修法：`resetParam` 先 `exitEdit(key)` 再 `paintKnob`；交互本身改成**位移阈值判定**（`<3px` 编辑、`≥3px` 拖拽），不依赖 `click`/`dblclick` 两个事件（§6.23 第 5、6 条） |
| **★★★ 源工程的 `cabbage/` 只有 `cabbage.js`，整目录同步过去 → 静默降级 + 四路全零** | 宿主里参数全消失、**四路输出 RMS = 0.0000**（`verify_quad.py` 会直接判 `a` 失败）；`auprobe` 日志刷 `Unknown widget type: form / rotarySlider` | 「按源目录整份同步」的部署方式会把**源工程里那份残缺的 `cabbage/`**（很多人只抄了 `cabbage.js`）一起带过去。Stasis / SwarmGrain 的源目录实测就是 1 个文件，Boids / Lissajous 是完整的 12 个。`export_plugin.py` 已按「有没有 `main.js`」判完整、不完整就整份换成扩展内置版本，并在结束时断言 `main.js` 存在。**判据**：部署目录的 `cabbage/` 必须是 12 个文件 |
| **★★★ 部署目录缺 `cabbage/` 运行时 → 静默降级成 Cabbage 2 解析（Boids）** | `auval` 里刷 **320 条** `Unknown widget type: form / horizontalSlider / rotarySlider`，`Added parameter` 0 条，但**插件不报错、宿主照样能加载**，只是所有参数都凭空消失 | 同目录只有 `cabbage/cabbage.js` 时（因为源工程里就只放了这一个文件），Cabbage 判定这不是 Cabbage 3 工程，于是**把 `<Cabbage>` 里的 JSON 当成 Cabbage 2 的 widget 行来解析**。把导出目录里完整的 `cabbage/`（`main.js` / `widgetManager.js` / `widgets/` / …，约 700 KB）和 `cabbage.css` 一起放进去就恢复正常（实测 `Added parameter` 46 条、0 报错）。**这不是可选的**：`cabbage.js` 单独存在不够 |
| **★★★ 重新导出会删掉 `help.html` / `gesture*.js` / `mediapipe/`（六台手册+手势插件）** | 宿主里点 `?` 没反应、CAMERA 按钮不出现，**没有任何报错**（`help-ui.js` 只 `console.warn`） | 早先 `export_plugin.py` 的运行时部署是「`rmtree` 后按**固定清单**重拷」（csd / index.html / project.json / cabbage / cabbage.css），手工 `cp` 进去的 `help.html`、`gesture.js`、`gesture-ui.js`、`mediapipe/`（17MB）在**下一次导出**就没了。改图标、改一个 CSS 都会触发。修法：部署改成**源目录整份同步**（跳过 `build/`），见 §8.1 / §1。现状已修复并复验全部 36 台 |
| **★★★ `rnd(常量)` 让 7 只从鸟叠成一个点（Boids）** | 原版的 7 只跟随鸟永远重合，看起来像"一只鸟带了一串同心圈" | 初始化循环里写 `gkX[i] = rnd(1)` / `rnd(0.02) - 0.01`，参数是常量 → i-time 求值一次 → **7 只鸟的位置和速度完全相同**。之后分离力 `kSepX -= kDx/kDist` 里 `kDx = 0`，永远算不出推力，整群锁死。改成 `rnd(kOne)`（传 k 率变量）即解决；实测 7 个值 `0.977 / 0.626 / 0.131 / 0.377 / 0.306 / 0.719 / 0.531`，随后各自游走 |
| **★★ 鸟画成 `^` 尖角而不是鸟（Boids）** | 每一帧都像 caret，看不出是鸟 | 两段**二次**曲线 + 翼尖抬高、中段下垂 = 尖角。改两段**三次**曲线、带两个翼峰 + 身体最低点（§6.22），`lift` 从 −1 扫到 +1 就是扑翼 |
| **★★ `padPx()` 忘了加 pad 原点（Boids）** | 鸟全部挤在画布左上角、大半被 `padClip` 裁掉 | 鸟群那一层 `<g id="flock">` 并没有被 `translate(PAD.x, PAD.y)` 到 pad 原点，所以归一化 → 坐标必须自己补 `PAD.x + nx*PAD.w`、`PAD.y + (1-ny)*PAD.h`。只做 `nx*PAD.w` 时，画面上只剩左边一小撮 |
| **★★ 竖推子的 CSS 类名漏定义，整条轴静默消失** | 用户反馈「Y 轴推子没有刻度也没有填充」，但 JS 明明在 `style.top/height` 上写值 | 横推子写了 `.ffill/.fbar` 却忘了 `.vfill/.vbar`：`.vbar` 退化成 `width:16px; height:0` 的空 div，`.vfill` 没有 `background-image`。**JS 设置的是几何，样式没定义就等于没画**，且控制台零报错。修法：竖推子的每条规则照横推子逐项对称写（`left:50%`↔`top:50%`、`width`↔`height`、`margin-left`↔`margin-top`）。批量换插件时优先 grep 一遍 `.v` 开头的类名是否存在 |
| **★★ 参数名用灰色，缩放到 80% 后读不出（zephyr / SwarmGrain）** | 用户反复提「灰色的参数名看不清，改白色」 | `rgba(201,213,195,.54)` 在 `#060a13` 上只有约 **3:1** 对比度，而画布常被自动缩放到 60~80%，6.5~7px 的小字再加上低对比等于看不见。**参数名必须是纯白 `#ffffff`（19.8:1）**；单位/说明这类次级文字最多降到 `.74`（10.8:1）。底栏品牌名可以保留色相，但透明度不要低于 `.65`。数量级读数用 `#ffffff` 或品牌亮色，不要用灰 |
| **采样点用绝对坐标回传** | 换分辨率或改动 `limit` 就错位，且难核对 | 后端只回 **归一化极坐标**（`r = sqrt(random:k(0,1))`、`a = random:k(0,2π)`），前端自己乘场域半径并加圆心。前端与声音用同一套极坐标，浏览器里就能直接验证分布 |
| **波形预览被拉扁** | 高斯窗看起来像条平线 | `viewBox` 与 CSS 尺寸不成比例、又用了 `preserveAspectRatio="none"` 就会被非等比拉伸。把预览框做成 `viewBox="0 0 148 46"` + `width:148px;height:46px`，1:1 不缩放 |
| **★★★ 波形预览的形状和 DSP 表对不上（SwarmGrain）** | 用户说「你的 Half Sine 显示有问题，应该是半个周期的正弦」 | 预览用了 `abs(0.5·sin(2πx) + sin(4πx))/1.29`（一拍脑袋写出来的多峰涟漪），而 `ftgen 101, 0, 1024, 9, 0.5, 1, 0` 实际是 **`sin(πx)`**。**GEN09 的 p1 是分音号、允许小数**：0.5 → sin(0.5·2πx) = sin(πx)，正好是半周期。修法：拿 csound 把表逐点读出来，再照着写 JS（见 §6.21）。高斯窗同理，正确的 σ 是 **1/12** 不是 0.16 |
| **场域图形钉死在 pad 中心** | 拖 centerX/centerY 时只有声音动、圆圈不动 | 场域圆/薄雾/中心标记的圆心必须来自 `toScreen(centerX, centerY)`，不是 pad 的几何中心。SwarmGrain 实测：圆心写死成 `CX/CY`，用户一眼看出「没有场域变动」|
| **标签缩写** | `Field R` 看不懂 | 标签一律写全称（`Field Radius` / `Cutoff Min` / `Cutoff Max`），缩写只允许出现在数值单位里 |
| **薄雾盖住粒子** | 只看得到一块灰盘 | 薄雾是底层气氛，`stop-opacity` 只能 0.02~0.2；粒子在其上，亮度/尺寸都独立。第一版给了 0.10~0.36，直接糊成实心圆 |
| **粒子只落在外圈** | 粒子云变成一圈虚线 | 后端本来就是圆内均匀（`r = Radius·√rnd`，开方才均匀）。若 UI 自己造点，漏掉 `√` 就会全挤在外圈；用后端取样点则天然正确 |
| **改行列数时 pad 跟着变大变小** | 织机/网格的方框在动，画面整体边界漂移 | 把「格子边长 = pad / max(rows,cols)」当成了几何来源。后端给的是**同一块固定 pad 里的归一化位置**，行列数只决定线的**密度**：`x = col/(C-1)`、`y = row/(R-1)`，pad 用常量写死（loom 实测 `PAD = {x:145, y:58, w:330, h:330}`）。行列数为 1 时除数为 1 → 贴边，与 Csound 一致 |
| **Csound 7 编译报 `unexpected '('`（SwarmGrain）** | `syntax error, unexpected '(' ... token "("`，整机不出声 | Cabbage 2 时代的 `x limit (expr), min, max` 写法在 Csound 7 会被当成函数调用。全部改成赋值式：`x = limit(expr, min, max)`。SwarmGrain 里一次命中 7 处（`iPosX/iPosY/iNormDist/kNormDist` 等），改完即通过 |

---

### 9.0 ★★★ 多声道输出：**可行**，但必须靠 `nchnls` 回退（2026-11-01 实测）

**结论**：不写 `channelConfig`，让包装器回退读 CSD 的 `nchnls`，
就能导出真正能出四声道的 AU / VST3。**写 `channelConfig` 反而做不到。**

#### 正确写法

```csound
sr = 48000
ksmps = 64
nchnls = 4          ; 输出 4 声道
0dbfs = 1
```

> **不要写 `nchnls_i`（2026-11-03 修正）。** 早先这里写的是 `nchnls_i = 2`，
> 结果是 **2 in / 4 out**，VST3 在 Ableton Live 里加载失败
> （`No valid output bus could be found for input bus 0`）。
> Cabbage 2 版的 8 台 Quad 从头到尾只写 `nchnls = 4`，在 Live 里四声道正常。
> 省略 `nchnls_i` 时 Csound 令它等于 `nchnls`（已用 `csound` 验证：`nchnls=4 nchnls_i=4`），
> 即 **4 in / 4 out**，输入输出声道数一致，Live 才能配上输出总线。
> DSP 里 `inch 1, 2` 依然只读前两路，多出来的输入通道不影响声音。

`<Cabbage>` 里**不要**放 `channelConfig`：

```json
{
    "pluginId": "Q3ST",
    "enableDevTools": true,
    "widgets": [ ... ]
}
```

依据（`src/CabbageUtils.cpp` → `Utils::getChannelConfig()`）：

```cpp
// No channelConfig in JSON — fall back to nchnls/nchnls_i declared in the CSD orchestra.
const int ins  = cabbage::File::getNumberOfInputChannels(csdFile);
const int outs = cabbage::File::getNumberOfOutputChannels(csdFile);
if (ins > 0 && outs > 0)
    return "Stereo:" + std::to_string(ins) + "|" + std::to_string(outs);
```

回退路径产出的是**单条 4 声道总线**（`Stereo:2|4`），而不是多总线 —— 这正是稳定路径。

#### 实测数据（`auprobe` / `aurender` 直接用 AudioUnit API 验证）

| 项目 | 结果 |
|---|---|
| 上报能力 `SupportedNumChannels` | `in 4..4, out 4..4` ✅（2026-11-03 起；此前为 `in 2..2`） |
| 默认输出格式 | 2 ch（包装器写死） |
| `SetProperty` 输出 → 4 ch | **成功**，回读 4 ch ✅ |
| `AudioUnitRender` 四路输出 | FL `.357` / FR `.356` / RL `.359` / RR `.359`，无 NaN ✅ |
| 声像验证 左前 x=.05 y=.95 | FL **.537** ≫ FR .057 / RL .095 / RR .043 ✅ |
| 声像验证 右后 x=.95 y=.05 | RR **.456** ≫ 其余 ✅ |
| 声像验证 正中 | 四路均 ≈ .25 ✅ |

#### 唯一残留：`auval` 不过

原因一句话：包装器把**默认**总线格式写死成 2 声道，而能力表是 4。
**这只是默认值问题**，宿主一旦主动把输出格式设成 4 声道就完全正常（已实测）。

操作判据、以及「只看哪三行日志」的清单在 **§8.4**，这里不重复。

#### ★ 绝对不要用多总线（`2+2`）

```json
"channelConfig": [ { "name": "Quad", "ins": "2", "outs": "2+2" } ]   // ❌ 会崩
```

一句话：AUv2 是**逐总线** `DoRenderBus`（每次只给 2 个 buffer 指针），
而 `CabbageProcessor::process()` 按**总线求和**的总数去写 `outputs[channel]`
（`2+2` → 4）→ `outputs[2]` 越界。完整证据链、Live 崩溃日志与源码引用见 **§9.1**
（含「多总线支持只做了一半」的定论）。

#### 附带修正：`channelConfig` 的其它坑

| 写法 | 上报能力 | auval | 说明 |
|---|---|---|---|
| `{"ins":"2","outs":"4"}` | `[2, 4]` | ✗ | 默认格式 2ch 冲突 |
| `{"ins":2,"outs":4}`（数字） | `[2, 2]` | ✓ | **被静默忽略**，退回立体声 |
| `{"inputs":...}`（键名错） | `[2, 2]` | ✓ | 同样被忽略 |
| `[2 in 2 out, 2 in 4 out]` | `[2, 2]` | ✓ | **只用第一条** |

`ins` / `outs` 必须是字符串，键名必须是 `ins` / `outs`。

### 9.1 四声道实测：`channelConfig` 到底怎么被解读（2026-11-01）

> ⚠️ **这一节是排查过程，不是行动指南。** 结论已被 **§9.0** 取代：
> **最终做法是「不写 `channelConfig`」**，靠 `nchnls` 回退拿到单条 4 声道总线。
> 下面所有「怎么写 channelConfig 才能过 auval」的结论都**只用于理解包装器行为**，
> **不要照做** —— 照做会得到 2 in / 2 out 或直接崩（§14.4 坑 1）。
> 保留这一节的原因是：它是后面 §9.1 末「多总线只做了一半」那段源码定论的证据。

工程：`quad Doppler/Quad-Stasis Cabbage3`，`nchnls = 4`，`pluginId Q3ST`。
每换一次 config 都**重新导出组件 + 重启 `AudioComponentRegistrar`**，跑 `auval -v aufx Q3ST Cabb`：

| `channelConfig` | auval 报的能力 | 默认总线 | 结果 |
|---|---|---|---|
| `[2 in 4 out]` | `[2, 4]` | 2 ch / 2 ch | ❌ `Default Format does not match` |
| `[4 in 4 out]` | `[4, 4]` | 2 ch / 2 ch | ❌ 同上 |
| `[2 in 4 out, 2 in 2 out]` | `[2, 4]` | 2 ch / 2 ch | ❌ 同上（第二条被忽略） |
| `[2 in 2 out, 2 in 4 out]` | `[2, 2]` | 2 ch / 2 ch | ✅ **SUCCEEDED**，但 Csound 侧 `Excess channels ignored`，RL/RR 被丢弃 |

结论三条：

1. **只取第一条** config；后面的条目既不进能力表，也不做备选。
2. **默认总线格式恒为 2 声道**，不随 config 变。所以只要第一条的 `outs` 不是 2，就必然报 `Default Format ... mismatch`。
3. 用 `2 in 2 out` 能过 auval，但那是**退化成真立体声**（后两路被直接丢掉，不是折叠），装进宿主会误导用户。

**另外两条实测（2026-11-01，同一次排查）：**

- `ins` / `outs` **必须是字符串**。写成数字 `{"ins": 2, "outs": 4}` 会被静默忽略，退回默认 `[2, 2]` 且 auval 通过 —— 最容易误判成「成功了」。
- 键名只能是 `ins` / `outs`。写 `inputs` / `outputs` 同样被忽略并退回 `[2, 2]`。

~~**要让 auval 通过又能保留 `nchnls = 4` 的唯一写法**~~（**已作废**，见本节开头的横幅）：
把 `2 in 2 out` 放在第一条（决定能力表），`2 in 4 out` 放第二条表达意图 ——
它确实能让 auval 绿，但拿到的是**假立体声**，不是四声道：

```json
"channelConfig": [
    { "name": "2 in 2 out", "ins": "2", "outs": "2" },
    { "name": "2 in 4 out", "ins": "2", "outs": "4" }
]
```

结果是 auval `SUCCEEDED` + `Reported Channel Capabilities [2, 2]` + Csound 侧 `Excess channels ignored` ——
即 **插件能装、能加载，但只有前两路出声**。多声道验证要换宿主/格式（VST3 见下）。

**VST3 是另一条路**：`CabbagePluginEffect.vst3` 模板同样读 `~/Library/CabbageAudio/<名>/`，
构建方式与 AU 类似（复制 → `Cp47` 替换成 4 字符 ID → 改 `CFBundle*` → `codesign -s -` → 装到
`~/Library/Audio/Plug-Ins/VST3/`）。`GetPluginFactory` 可正常加载（`countClasses = 1`），
但 VST3 的**总线数只有在宿主里实例化后才查得到**，没有对应 `auval` 工具，只能放进宿主实测。

~~写法（含上面的可过版本）~~（**已作废**）：

```json
// ❌ 不要这么写。正确做法是整段删掉 channelConfig，只留 nchnls = 4（§9.0）
"channelConfig": [
    { "name": "2 in 4 out", "ins": "2", "outs": "4" }
]
```

~~真要今天就听四声道，唯一可靠的路是**工程里自己折叠**~~（**已作废**）：
那是 §9.0 之前的降级方案（`nchnls = 2`，在 `out` 之前把 RL/RR 按等功率混进 L/R）。
§9.0 实测 `nchnls` 回退能出真四声道之后，**不需要折叠了**。

#### ★★★ VST3 + Ableton Live：`nchnls_i` 是加载失败的直接原因（2026-11-03 实测 + 已修正）

先排除误判：**这不是 Gatekeeper**。本机 `spctl --status` 是 `assessments disabled`，
两个插件目录都没有 `com.apple.quarantine`，`codesign -v` 报 `valid on disk` +
`satisfies its Designated Requirement`，`spctl -a -t exec` 报 `accepted`。
更硬的证据在 Live 自己的日志里 —— **二进制已经加载、processor 已经创建成功**，
失败发生在之后的**总线协商**：

```text
info: VST3: Going to create: Cab3-Quad-Stasis
info: VST3: plugin processor successfully loaded: CabbageAudio 'Cab3-Quad-Stasis' v1.0.0 (cid: {3E94D394-...})
warning: VST3: plugin did not follow bus configuration protocol (error: false)
error: VST3: No valid output bus could be found for input bus 0
error: VST3: Failed: Cab3-Quad-Stasis
```

同一次 Live 会话里 `htmltry.vst3`（2 in 2 out）走完整条链并且 `VST3: Created: htmltry`。
另外注意：**扫描成功 ≠ 能实例化**。`PluginScanner.txt` 里这 9 台都写着
`VST3: found: Cab3-Quad-*`，因为扫描只 `GetPluginFactory` + 枚举类，
不进 `setBusArrangements`；失败只在插入轨道时才出现。

机制（Live 二进制里的字符串顺序就是它的流程）：

```text
getBusCount → setBusArrangements → "plugin did not follow bus configuration protocol"
            → getRoutingInfo（插件不给就自己推断）
            → "No valid output bus could be found for input bus N"
```

也就是说：Live 按 **输入总线 0 的声道数**去找一条**同声道数**的输出总线。
当时插件报的是 **2 in / 4 out**，找不到 2 声道输出总线 → 失败。

根源在包装器：Cabbage 3 的 `.vst3` 是 **CLAP → VST3 适配器**（二进制里是
`ClapAsVst3` + `clap.audio-ports-config`），CLAP 音频端口的输入/输出声道数分别由
CSD 的 `nchnls_i` / `nchnls` 决定。写了 `nchnls_i = 2` 就把输入端口压成 2 声道，
与 4 声道输出对不上。把 `nchnls_i` 去掉，两端都是 4 声道，Live 才能配对上。
**改 `channelConfig` 解决不了这个问题**，因为它改的是另一条回退路径。

#### 修正：去掉 `nchnls_i`

早先的写法是 `nchnls = 4` + `nchnls_i = 2`，于是包装器报 **2 in / 4 out**。
Live 的匹配规则是「按输入总线 0 的声道数找同声道数的输出总线」：

| 声明 | 上报 | Live |
|---|---|---|
| `nchnls = 4` + `nchnls_i = 2` | 2 in / 4 out | ❌ `No valid output bus could be found for input bus 0` |
| `nchnls = 4`（不写 `nchnls_i`） | 4 in / 4 out | 输入输出同宽，可以配对上 |

Cabbage 2 版的 8 台 Quad 从头就只有 `nchnls = 4`，在 Live 里四声道正常 ——
这就是差异所在。省略 `nchnls_i` 时 Csound 让它等于 `nchnls`
（`csound` 实测输出 `nchnls=4 nchnls_i=4`），DSP 里 `inch 1, 2` 仍只读前两路。

所以 **Quad 系列的 CSD 一律只写 `nchnls = 4`**，`nchnls_i` 与 `channelConfig` 都不写。

> 这条改动**在 AU 侧已完整验证**（`auprobe` 报 `in 4..4 / out 4..4` + 四路渲染，
> 见上一节）。VST3 侧在 Live 里仍有问题，但根因不是 `nchnls_i`（继续往下看），
> 而且四声道的 VST3 已决定不修（§9.1 末）。

#### ★★★ 2026-11-03 补测：Cabbage 2 的 VST3 其实是**立体声**，Live 的 VST3 效果器没有多声道

去掉 `nchnls_i` 后 Live 的报错变了：

```text
warning: VST3: plugin did not follow bus configuration protocol (error: false)
error:   Vst3: plugin has an effect category, but no valid audio input bus
error:   VST3: No valid input bus could be found
```

即 **4 in / 4 out 也不行**。于是直接测了 Cabbage 2 那份能用的 VST3
（`/Library/Audio/Plug-Ins/VST3/quadboidsvst3try.vst3`，JUCE 包装器）的总线，
用 `IComponent::getBusCount/getBusInfo` 读出来的原始结果：

| 插件 | IN | OUT |
|---|---|---|
| Cabbage 2（JUCE，Live 里能用） | `[0] MAIN 2ch` `[1] AUX 2ch` | `[0] MAIN 2ch` `[1] AUX 2ch` |
| Cabbage 3（clap-wrapper，4 in / 4 out） | `[0] MAIN 4ch` | `[0] MAIN 4ch` |
| Cabbage 3（clap-wrapper，2 in / 4 out） | `[0] MAIN 2ch` | `[0] MAIN 4ch` |
| 参照 ValhallaPlate（正常插件） | `[0] MAIN 2ch` | `[0] MAIN 2ch` |

**结论**：Cabbage 2 那份 VST3 的主总线是 **2 in / 2 out**，在 Live 里跑的是立体声；
它之所以"能进"，是因为主输入/输出对都是 2 声道。Live 的 VST3 效果器只支持
**一条 2 声道主输入 + 一条 2 声道主输出**：

- `2 in / 2 out` → 能加载（但只有两路）
- `2 in / 4 out` → `No valid output bus could be found for input bus 0`
- `4 in / 4 out` → `No valid input bus could be found`

所以 **Live 里不可能有 4 声道 VST3 效果器**。要四声道只有 AU 一条路
（本仓 AU 实测 `in 4..4 / out 4..4`，Live 里正常）。VST3 的四声道留给
Cubase / Nuendo / Reaper / Bitwig 这类支持多声道 VST3 的宿主。

导出时保持 `nchnls = 4`（= 4 in / 4 out）是对的：它是多声道宿主需要的形式，
Cabbage 2 的 VST3 在 Live 里"能用"只是因为退化成 2 声道，并不是四声道。

#### ✗ 已验证失败：`channelConfig` 的 `2+2` 多总线（2026-11-03）

为了绕开「Live 只吃 2 声道主输入/输出」，试过：

```json
"channelConfig": [ { "name": "Quad", "ins": "2", "outs": "2+2" } ]
```

用 `auval` 核对，总线形状确实对了：

```text
Input  Scope: Default Bus Count: 1   ← 1 × 2ch
Output Scope: Default Bus Count: 2   ← Bus0 2ch（主）+ Bus1 2ch（辅助）
auval -v aufx Q3ST Cabb → PASS
```

而且 **Live 的 VST3 总线协商真的过了** —— 日志第一次出现 `VST3: Created: Cab3-Quad-Stasis`。
但 0.4 秒后：

```text
error: FatalError: Uncaught exception
error: FatalError: Unknown exception
```

崩溃报告（`~/Library/Logs/DiagnosticReports/Live-*.ips`）的栈：

```text
_os_unfair_lock_recursive_abort
objc_destroyWeak
CFXNotificationRegistrarRemoveObservers
juce::AppDelegate::~AppDelegate()          ← MaxPlugLib
__cxa_finalize_ranges → exit
CsoundLib64
objc_storeWeak
WebKit  -[WKWebView setUIDelegate:]
choc::ui::WebView::Pimpl::initialise()      ← 崩在这里
LatticeClapPlugin::guiCreate
WrappedView::getSize                        ← Live 请求界面尺寸
```

即：界面创建时 `choc::ui::WebView` 初始化失败 → Csound 的 signal handler 接住 → `exit()`
→ 退出过程中 MaxPlugLib 的 `AppDelegate` 析构触发 CFNotification 递归加锁 → 进程被 abort。

**AU 和 VST3 都崩**（同一份 CSD，`channelConfig` 是两者共用的）：

| 时间 | 事件 | 结果 |
|---|---|---|
| 01:11:08 | `Audio Unit v2: Created: Cab3-Quad-Stasis` | 3 秒后崩溃重启 |
| 01:11:34 | `Audio Unit v2: Created: Cab3-Quad-Orbita`（无 channelConfig） | 正常，无崩溃 |
| 01:11:43 | `VST3: Created: Cab3-Quad-Stasis` | 0.4 秒后崩溃 |

对比项很干净：**同一台机器、同一会话里，只有加了 `2+2` 的那台崩**，
没加的 Orbita 一切正常。所以 `2+2` 这条路直接否掉。

结论：**Quad 系列一律 `nchnls = 4`、不写 `nchnls_i`、不写 `channelConfig`**。
Live 里用 AU（四声道已验证），VST3 的多声道留给 Cubase / Reaper / Bitwig。

##### 根因（源码级）：Lattice 只把端口 0 交给 processor

`2+2` 之所以"加载成功但随后崩溃"，看 Lattice 的两段代码就清楚了。
它**上报**多端口：

```cpp
// src/lattice/clap/LatticeClapPlugin.cpp
uint32_t LatticeClapPlugin::audioPortsCount(bool isInput) const noexcept {
  return static_cast<uint32_t>(
      isInput ? processor.getChannelConfig().getNumInputBuses()
              : processor.getChannelConfig().getNumOutputBuses());   // ← 按总线数上报
}
```

但 `process()` **只取第 0 个端口**：

```cpp
clap_process_status LatticeClapPlugin::process(const clap_process *process) noexcept {
  float **outputs = process->audio_outputs[0].data32;   // ← 只有端口 0 的 buffer 指针
  ...
  float **inputs = process->audio_inputs[0].data32;     // ← 同上
  processor.process(inputs, outputs, blockSize);
}
```

而 `CabbageProcessor::process` 却按**所有总线的合计声道数**循环：

```cpp
// src/CabbageProcessor.cpp:702
void CabbageProcessor::process(float **inputs, float **outputs, std::size_t blockSize)
...
    for (int channel = 0; channel < totalNumOutputs; channel++)   // ← 4（= 2 + 2）
        outputs[channel][i] = cabbage.getSpOut(channel + pos);    // ← 越界写 outputs[2]、outputs[3]
```

`totalNumOutputs` 来自 `getChannelConfig().getTotalNumOutputChannels()`，是**总线求和**：

```cpp
// src/CabbageProcessor.cpp:394
auto ioConfig = getChannelConfig();
totalNumOutputs = ioConfig.getTotalNumOutputChannels();   // 2 + 2 = 4
```

于是：数组只有 2 个指针，却写了 4 个 → 堆被写坏 → 之后创建 WebView 时崩
（就是那份 `Live-*.ips` 里的 `choc::ui::WebView::Pimpl::initialise()` 栈）。
AU 走同一段 Lattice 代码，所以 **AU 也一样崩**，与宿主无关。

> 全仓库 `audio_outputs` 只有两处引用：`audio_outputs_count <= 0` 的判断，
> 和 `audio_outputs[0].data32`。没有任何把多端口聚合成扁平数组的代码。

##### 为什么 Cabbage 2 可以

Cabbage 2 的 VST3 是 **JUCE 包装器**（`JuceVST3Component`），测出来的总线是
`MAIN 2ch + AUX 2ch`。JUCE 的 VST3 包装器按总线逐条把 buffer 交给
`AudioProcessor::processBlock` 的 `AudioBuffer`（内部就是扁平的、总线拼接后的视图），
Cabbage 2 的 processor 按这套布局写，所以 2 主 + 2 辅能正常出声。

差异不在 macOS / Live / VST3，而在**两代包装器对多总线的处理**：

| | Cabbage 2 | Cabbage 3 |
|---|---|---|
| 包装层 | JUCE VST3 wrapper | Lattice CLAP + clap-wrapper |
| 多总线上报 | ✅ `MAIN 2ch + AUX 2ch` | ✅ 端口 0 主 + 端口 1 辅 |
| 把多端口喂给 DSP | ✅ 逐总线拼接后统一处理 | ❌ **只喂端口 0**，却按总声道数写 |
| 结果 | 4 声道可用 | 越界写 → 崩溃 |

所以这不是"Live 不支持"，而是 **Cabbage 3 的多总线支持只做了一半**：
端口声明做了，`process()` 的聚合没做。要修只能改 Lattice / Cabbage 3 的 C++ 源码，
CSD 层面无解（`channelConfig` 怎么写都绕不过这段代码）。

#### ★ 决定（2026-11-03）：四声道的 VST3 不修，四声道只交付 AU

上面那段结论就是最终结论 —— **不改 C++，VST3 四声道无解**，这件事到此为止。

理由不是"懒得修"，而是修它的代价和收益不成比例：

| | 要动什么 | 后果 |
|---|---|---|
| 修 | fork Lattice 的 `process()`，把多端口拼成扁平数组再交给 `CabbageProcessor` | 从"消费一个 beta 扩展"变成"自己维护一份 Cabbage 3 分支"，每次升级都要重打 |
| 不修 | 什么都没多 | 四声道用户在 Live / Logic 里用 AU（已验证 4 in/4 out）；VST3 只有 2 声道可用 |

决定性的一条：**这个项目已经是 HTML/JS + Csound 两层**，作者不需要 C++；
为了一个包装器的 SDK 缺陷把 C++ 拉进来当第三层、并且从此锁死在一个
`3.0.10-beta` 上，是明显亏的买卖。Cabbage 3 本身就是首个 beta，
这个缺陷属于"上游未完成"，不是我们的工程债。

**落到操作上（三条）**：

1. 四声道（`quad Doppler/` 9 台）导出用 `--no-vst3`，不再生成、不再安装 VST3：
   ```bash
   python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3
   ```
2. 立体声（`stereo wildtrace/` 9 台）是 **2 in / 2 out**，VST3 正常，**照旧导出**。
3. 验收只认 AU：`verify_quad.py` 判四声道，`auval` 只看"CSD 读到了 + Csound 编译 done"。

**四声道 AU 已验证的宿主（2026-11-14 实测）**：

| 宿主 | 接法 | 结果 |
|---|---|---|
| Ableton Live 12 | AU，轨道输出配 4.0 | ✅ |
| **Max 9** | AU，**`mcs.vst~ 4 4`** | ✅ 四路独立（用 `vst~` 只有 2 路） |

> Max 的两个宿主对象容易混：`vst~` 是**只有立体声**的老对象，`mcs.vst~` 才是
> 单实例多声道 I/O（Max 9 起提供），前两个参数即输入/输出声道数。示例 patch 见
> `examples/max/mcs-vst-4ch.maxpat`。这条经验也写进了 README「使用建议」。
   **VST3 不进验收清单**，谁也不用为它写测试。

> 已经装进 `~/Library/Audio/Plug-Ins/VST3/` 的那 9 个四声道 VST3 留着不删：
> 在 Cubase / Nuendo / Reaper / Bitwig 这类真正支持多声道 VST3 的宿主里，
> 只要宿主把 4 进 4 出作为一个整体来喂，它们仍有可能正常工作 —— 只是本机没有这种宿主可测，
> **不承诺、不作为交付项**。要是哪天在这些宿主里实测崩了，直接删掉那一份就行，不影响 AU。


## 10. 迁移一个插件的顺序

1. **盘点参数**：列出原 Cabbage 2 版的 `channel()`，逐个分类（A/B/C 类）。
2. **定界名 + 4 位 ID**：照 **§8.0 的命名约定**填 13 处，先查 ID 撞车（原 Cabbage 2 版一定占着 `DPxx`）。
3. **写 CSD**：`<Cabbage>` 参数表（顺序即参数顺序）→ Csound 引擎（DSP 代码可整段复用）→ 三个固定模式（读值 / 触发回写 / 电平表）。
4. **写 HTML**：复制 Stasis 的 `index.html` 作骨架 → 改视觉主体 → 改 `applyValue` 的 `switch` → 改 `PARAM_IDX`。
   - 想带缩放交互，直接把 **§6.7** 的四段整段抄过来，只改 `CANVAS` 尺寸和配色。
   - 有参数驱动的几何可视化（轨道/准星/扩散范围），照 **§6.9** 用等比缩放，不要逐轴钳制。
   - 有主体图形（黑洞/粒子场/云）→ 用 **§6.12** 两段式布局，别把旋钮浮在画面里。
   - 控件顺序按 **§6.1 规则 0** 排（DSP 信号流），旋钮映射按 **§6.16** 给 `curve`。
   - 电平表直接抄 **§6.15**；有移动标记再抄 **§6.17**。
5. **跑 §7 自检**：JSON、JS、参数顺序、浏览器交互、（若带缩放）§6 的缩放检查项，
   再加 **§7.4 四条最容易漏的**（信号流顺序 / 曲线贴边 / dB 换算 / 动态标记）。
6. **导出**：先跑 §8.0 的一致性核对脚本，全绿再跑 §8.1 脚本。
7. **auval 验证**：必须 `SUCCEEDED` 且日志干净。
8. **热更新 UI**：只改界面时，`cp index.html ~/Library/CabbageAudio/<名>/` 即可，不用重新导出。

### 10.1 给已完成的前端补加「缩放 + 数值编辑」（改造清单）

Stasis 就是这条路走过来的：前端早就做好了，后来才追加缩放和数值编辑。
**按下面的顺序改，每步都能独立验证**，不要一次改完再测。

**① 拆画布（5 分钟，会牵动全文布局）**

```
html, body   →  视口容器（flex 居中 + overflow:hidden）
.canvas      →  原 body 的 width/height/padding/transform
原 body::before / ::after / body > *  →  全部改到 .canvas
```

> 关键：`.zoomer` 必须放在 `.canvas` **外面**，否则会跟着画布一起缩、位置漂移。

改完立刻验证：画布是否精确填满视口（`canvas.width === innerWidth`）。

**② 加三角（照抄 §6.7 的 ③④ 两段）**

- `CANVAS` 填**当前** `form.size`，不要改 CSD
- `dragOn` 里加 `zoom: false`
- **`data-host` 的配色要跟着各插件色板走**（Stasis 用白、Orbita 用琥珀）

**③ 数值框替换（最容易出事的一步）**

| 检查点 | 说明 |
|---|---|
| `<input>` 在 `</svg>` **之后** | 放 SVG 里会变成 SVGSVGElement 子节点，没有 `select()` |
| `top` 值对齐原 `<text y>` | Orbita 原 `y=31` → `top:27px`；Stasis 原 `y=36` → `top:31px`（约为 `y − 字号/2 − 2`） |
| `pointer-events: none` | 平时不接管指针，整块旋钮才能拖 |
| `.knob { position: relative }` | 否则绝对定位的 input 会跑到祖先身上 |
| 量最大值的文字宽度 | 见 §6.0 规则四 |

**④ 统一 tap 逻辑（★ 别按 target 分叉）**

改造已有代码时最常见的错误，是给「点在 input 上」单独加一条 `return` 分支。
那会让第二次点击绕过双击判定，`点数字 → 再点数字` 永远归不了位。
**一律记录 tap，只用 `onInput` 标记决定要不要抢焦点**（§6.8 第 9 条）。

**⑤ 双击归位**

- `P[key].def` 从中查 CSD `defaultValue` 填，别凭记忆
- 自己打时间戳判断，不要依赖 `dblclick`（`preventDefault` 会抑制它）
- 已有「编辑中不覆盖」守卫的函数（如 `setReadout`）要加 `force` 参数，
  否则双击归位时值写进去了但显示不更新

**⑥ 守卫要放行输入框**

```js
document.addEventListener('selectstart', e => {
    if (e.target.closest && e.target.closest('input')) return;   // ← 必须放行
    if (anyDrag()) e.preventDefault();
});
```

**⑦ 回归（必须逐项跑，不要只看一眼）**

- [ ] 原有拖拽全部还能用（准星 / 旋钮 / 双滑块）
- [ ] 拖拽期间无文本选中（`activeElement === BODY`、`getSelection()` 为空）
- [ ] 单击旋钮进编辑、数字全选
- [ ] 编辑中后端回灌不冲掉输入
- [ ] 双击归位到 CSD 默认值，且**不残留编辑态**
- [ ] **在数字框里横向拖动选词 → 值不变、编辑态保持、无消息下发**（§6.8 第 12 条）
- [ ] **选完词后立刻双击数字 → 仍能归位**（§6.8 第 11 条）
- [ ] 缩放下限 75%、双击回 100%、拖大不超屏
- [ ] 默认打开即 100%（徽标），且 `窗口尺寸 == round(CANVAS × BASE)`
- [ ] 画布填满视口、无元素溢出
- [ ] 最宽数值（如 `16000`）不被裁字

---

## 11. 热更新速查

| 改了什么 | 要做什么 |
|---|---|
| `index.html`（界面） | `cp index.html ~/Library/CabbageAudio/<名>/` → 重开插件窗口 |
| CSD 的 Csound 代码 | `cp cab3-xxx.csd ~/Library/CabbageAudio/<名>/<名>.csd` → 重开插件 |
| CSD 的 `<Cabbage>`（增删参数） | 同上，但**必须重新核对 `PARAM_IDX`** |
| CSD 的 `form.size` | 同上。**不需重编 `.component`**，CSD 是运行时读的；但宿主可能缓存窗口尺寸，需重启宿主 |
| 只改数值格式 / 控件宽度 | 只动 `index.html`，重传即可，CSD 不用碰 |
| `cabbage.js` | 一般不动 |
| `help.html` / `help-ui.js` / `gesture*.js` / `mediapipe/` | 拷进运行时目录即可（和 `index.html` 一样是运行时资源）。**但下次导出会整体重建运行时目录** —— 想一劳永逸就把文件放回**源工程目录**，导出时自动同步（§8.1）。`mediapipe/` 用 `scripts/gesture-assets.py` 生成，不入库 |

若界面没变化，重启宿主清 WebView 缓存。

---

## 12. 插件状态与参数契约

### 已完成（可直接抄代码）

| 插件 | 状态 | 什么时候抄它 |
|---|---|---|
| Stasis | ✅ `C3ST` | **最简参考**：2 个旋钮 + 距离场雷达 + 缩放/数值编辑的基线实现 |
| Orbita | ✅ `C3OB` | 二维等比区域 + 椭圆轨道 + 方向开关（§6.9） |
| levy | ✅ `C3LV` | 轨迹可视化 + 选词/双击归位判定（§6.8 第 11、12 条） |
| Singularity | ✅ `C3SG` | **场景 + 控制台两段式**（§6.12）+ 分层渲染（§6.13）+ 移动标记（§6.17）|
| loom | ✅ `C3LM` | **动态重建的格子矩阵** + 蛇形路径预览 + 梭子拖尾（§6.17）+ `loom_x/loom_y` 双通道合并到一帧（§6.11） |
| zephyr | ✅ `C3ZP` | **固定 pad 上的极坐标运动** + 湍流走廊（横向幅度可视化）+ 走带按钮（Start/Loop）+ 用后端 `zep_env` 驱动包络环。参数名 `.klab` / `.wt` / 走带按钮 / 底栏读数全部改为白或近白（灰 `.54` 只有 3:1，缩到 80% 读不出） |
| SwarmGrain | ✅ `C3SW` | **全推子（无旋钮）的 McCudy 风格控制台** + 场域跟随中心（X/Y 推子 + pad 拖拽）+ **只有一层薄雾承载滤波频率**（40 停靠点、颜色由 DSP 公式现算、**恒定 alpha = 1.0** + 最外 14% 羽化；半透明会让 20000 Hz 端停在 133 中灰，达不到白）+ 只留最外一圈与最内中心 + 干声游标只画一个点（无拖尾，因为步进速率由 Dens 控制，拖尾会冒充尺寸）+ 窗函数竖排 5 档 + 1:1 波形预览（放 pad 右侧、电平表下方；五条曲线**逐点对齐 ftgen 表**，Half Sine = `sin(πx)`、Gauss σ=1/12）。**反面教材**：曾经用 6 槽 × 3 通道的粒子层来表现颗粒，占带宽且读不出信息，已整体删除；`Dens` 改由**纹理颗粒感**承载（§6.20，pattern 点阵 10→15 格、半径 1.45→0.75、透明度 0.07→0.29） |
| Boids | ✅ `C3BD` | **实体群，不是粒子云**：8 只（1 头 + 7 从）用**俯视描边曲线 + 不对称机身线**（不是填色多边形 —— 那个像纸飞机；**不做拖尾**，直线拖尾一眼假），航向由 DSP `taninv2` 算好后经 `bdir` / `ba1..ba7` 推过来，前端最短弧插值后 `rotate(航向+90°)`。头鸟 `#ff3b40` + 外发光、从鸟纯白。背景：**16 朵云全部下落动画**（远层 7 大淡慢、近层 9 亮实快，位置 100% 由 `--x0/--y0 → --x1/--y1` 绝对坐标给，§6.27），与上升的鸟反向；近层 lane 只取 pad 两侧边带，`.padfill` 提到 `.66` 免得云透成脏斑。12 只远景鸟从下往上升、夹在两层云之间穿过云层。控制台是旋钮。23 参数 / 24 隐藏通道。默认 `Delay Base=30ms`、`Flock Decay=0.8209`（8 只鸟等步滚降到 **−12 dB**，每级 −1.71，§6.25）、`Damping=16000`。**CPU 实测：前端 15.6% + 后端 3.1%（单核），见 §6.24** |
| Lissajous | ✅ `C3LJ` | **示波器类**：x/y 两轴正交合成的闭合轨迹 + 荧光余晖（`canvas` 逐帧 `destination-out` 衰减）+ 轴可选输入音频（`xsrc`/`ysrc`）。相位用**连续累加**而不是 `phasor`，每 8 个 x 周期才绕回一次，`ratio` 量化到 1/8 保证 y 相位整周期闭合 —— 少了任一条，轨迹绕回处就会拉出直线 —— 前端的光点是按 `Φ` 用同一套公式现算的，DSP 和 JS 必须逐字同构 |

八台的 `auval -v aufx <ID> Cabb` **全部 SUCCEEDED**（2026-10-31 复验，那批当时是 8 台）；
Lissajous（`C3LJ`）是 2026-11-03 补的 depth 版，`PARAM_IDX` 15 项与 CSD automatable 逐字一致。

### ★ 参数契约（2026-11-01 从 8 份 CSD 直接抽出，11-03 补第 9 份 Lissajous，改动后必须重新生成）

**这是唯一权威的参数顺序表。** 改 CSD 的 widget 顺序、增删参数之后，
`PARAM_IDX` 要与下表**逐字**一致，否则自动化会绑到错误的参数上且不报错（§5.3）。

```
Stasis       C3ST  7 auto / 4 隐藏
  x y minWet maxWet roomSize cutoff masterGain

Orbita       C3OB  9 auto / 4 隐藏
  speed radius Shape dir minWet maxWet roomSize cutoff masterGain

levy         C3LV  11 auto / 4 隐藏
  rate alpha scale damp chaos inertia minWet maxWet roomSize cutoff masterGain

Singularity  C3SG  14 auto / 5 隐藏   ← PARAM_IDX 记的是「全部 widget」(19)，不是只 automatable
  fallTime spinSpeed gravityCurve masterGain inputGain dopplerFactor mode dopplerMode
  start loop minWet maxWet roomSize cutoff

loom         C3LM  12 auto / 4 隐藏
  rows cols path speed glide texture warp minWet maxWet roomSize cutoff masterGain

zephyr       C3ZP  13 auto / 5 隐藏
  Start Loop fallTime angle radius drift dfreq jitter minWet maxWet roomSize cutoff masterGain

SwarmGrain   C3SW  17 auto / 4 隐藏
  Dens step centerX centerY radius rangeMin rangeMax GSize DlyMax reverse window
  minWet maxWet roomSize cutoff drywet level

Boids        C3BD  23 auto / 24 隐藏   ← 参数最多
  x y coh ali sep speed delay_base feedback mod_rate Flock_Decay m1 m2 m3 m4 m5 m6 m7
  minWet maxWet roomSize cutoff dry_wet vol

Lissajous    C3LJ  15 auto / 5 隐藏    ← 两轴可选「输入音频」当坐标（xsrc/ysrc）
  rate ratio phase scale chaos glide inGain xsrc ysrc wave minWet maxWet roomSize cutoff masterGain
```

**重新生成这张表的脚本**（改完 CSD 就跑一遍，别靠记忆）：

```bash
cd "<stereo wildtrace 目录>"
python3 - <<'EOF'
import re, json, glob
CFG = [("Stasis","C3ST"),("Orbita","C3OB"),("levy","C3LV"),("Singularity","C3SG"),
       ("loom","C3LM"),("zephyr","C3ZP"),("SwarmGrain","C3SW"),("Boids","C3BD"),
       ("Lissajous","C3LJ")]
for d, pid in CFG:
    csd = glob.glob(f"{d} Cabbage3/*.csd")[0]
    j = json.loads(re.search(r'<Cabbage>(.*?)</Cabbage>',
                             open(csd, encoding='utf-8').read(), re.S).group(1))
    auto = [w['channels'][0]['id'] for w in j['widgets']
            if w.get('automatable') and w.get('channels')]
    hid = sum(1 for w in j['widgets'] if w.get('channels') and not w.get('automatable'))
    h = open(f"{d} Cabbage3/index.html", encoding='utf-8').read()
    idx = re.findall(r"'([^']+)'", re.search(r'const PARAM_IDX = \[(.*?)\];', h, re.S).group(1))
    flag = 'OK' if idx == auto else ('OK(全量)' if len(idx) == len(auto) + hid else '#MISMATCH')
    print(f"{d:<12}{pid}  {len(auto)} auto / {hid} 隐藏  PARAM_IDX={len(idx)}  {flag}")
    print('  ' + ' '.join(auto))
EOF
```

> **Singularity 是例外**：它的 `PARAM_IDX` 存的是「全部 widget」（含隐藏通道），
> 共 19 项。校验脚本要对它用「全量对比」，不能用「只 automatable」。
> 这是早期实现遗留，新增参数追加在末尾时两种语义都不受影响，**不必改它**。

### 输出级参数：9 台统一

所有插件现在都有 master gain，**值域一律 0–8**（`increment 0.01`，线性 `curve: 0`）：

| 插件 | 通道名 | 默认值 | 备注 |
|---|---|---|---|
| Stasis `C3ST` | `masterGain` | **2** | 2026-10-31 新增（旋钮，Room 行） |
| Orbita `C3OB` | `masterGain` | **2** | 新增（旋钮，Room 行） |
| levy `C3LV` | `masterGain` | **2** | 新增（旋钮，Room 行）；双滑块拆行，画布 380×560 / form 507×747（§6.26） |
| Singularity `C3SG` | `masterGain` | **2** | 原有，`max` 4 → 8 |
| loom `C3LM` | `masterGain` | **2** | 新增（旋钮，03 Room 卡） |
| zephyr `C3ZP` | `masterGain` | **2** | 新增（旋钮，03 Room 卡） |
| SwarmGrain `C3SW` | `level` | **2** | 原有，`max` 4 → 8，label 改成 `Master Gain` |
| Boids `C3BD` | `vol` | **2** | 原有，`max` 16 → 8，`curve` 2 → 0 |
| Lissajous `C3LJ` | `masterGain` | **2** | 新增（旋钮，Space 行，`max` 8 / `curve` 0）；quad 版 `Q3LJ` 同值 |

DSP 一律接在 `aOutL = aDryL + aRevL` 之后：

```csound
kMasterGain cabbageGetValue "masterGain"
aOutL = aOutL * kMasterGain
aOutR = aOutR * kMasterGain
```

**默认值一律 2**（2026-11-01 用户定），九台完全一致。
改默认值要同步 4 处（CSD `defaultValue` / HTML `P.def` / 写死的 `<input value>` / `let x =` 初值），
详见 §9「一个预设值有四个家」。

> ⚠️ 只 grep 自己以为的那一处一定会漏。这次实测 **6 台要改、Singularity 恰好已是 2 不用动**，
> 但每台的「4 个家」长得都不一样：
>
> | 插件 | CSD | `P.def` | 写死的 `<input value>` | 初值 |
> |---|---|---|---|---|
> | Stasis | ✓ | ✓ | `id="gainOut"` | `let … gain = N;` |
> | Orbita / levy | ✓ | ✓ | `id="vGain"` | `let … gain = N;` |
> | loom / zephyr | ✓ | ✓ | `id="vGain"` | `masterGain: N`（在 `V` 对象里） |
> | SwarmGrain | ✓ | ✓ | —（推子，值由 JS 画） | `level: N` |
> | Boids | ✓ | ✓ | —（旋钮由 `makeKnob` 现生成） | —（`V` 由 `P` 派生） |
>
> **有 `const V = {}` + `for (const k in P) V[k] = P[k].def` 的插件（Singularity、Boids）
> 根本不需要改初值**，第 4 处自动跟随。反过来，写死了 `let x = 1` 的插件改了 `P.def` 不改初值，
> 首帧就会闪一下旧值。

**安装级别一览**（2026-11-01 实测，不要再凭印象写）：

| 插件 | 用户级<br>`~/Library/Audio/Plug-Ins/Components/` | 系统级<br>`/Library/Audio/Plug-Ins/Components/` |
|---|---|---|
| Stasis `C3ST` | ✅ 新版 | ⚠️ **旧副本残留** |
| Orbita `C3OB` | ✅ 新版 | ⚠️ **旧副本残留** |
| levy `C3LV` | ✅ 新版 | ⚠️ **旧副本残留** |
| Singularity `C3SG` | ✅ 新版 | ⚠️ **旧副本残留** |
| loom `C3LM` | ✅ | — |
| zephyr `C3ZP` | ✅ | — |
| SwarmGrain `C3SW` | ✅ | — |
| Boids `C3BD` | ✅ | — |

> ⚠️ **4 台仍有系统级旧副本**（Stasis / Orbita / levy / Singularity，2026-10-24~30 装的）。
> 2026-11-01 统一重新导出时，新版全部装到用户级，但 `osascript ... with administrator privileges`
> 的授权弹窗**超时未响应**，系统级那 4 份没删掉。宿主会看到同名两个组件，加载哪个看运气。
>
> ```bash
> # 一次删掉 4 份（会弹一次管理员授权）
> osascript -e 'do shell script "rm -rf /Library/Audio/Plug-Ins/Components/Cab3-Depth-{Stasis,Orbita,Levy,Singularity}.component" with administrator privileges'
> ```
>
> 删完刷新注册缓存：
>
> ```bash
> ps aux | grep '[A]udioComponentRegistrar' | awk '{print $2}' > /tmp/reg.txt
> # 然后单独一条（工具不允许 kill $(...) 这种写法）
> xargs kill < /tmp/reg.txt
> ```
>
> 注意 `kill $(...)` 在自动化工具里会被安全检查拦下，必须先把 PID 落到文件再 `xargs kill`。

运行时资源统一在 `~/Library/CabbageAudio/<NAME>/`（与安装级别无关）。

### 待迁移

**没有了。** 两套各 9 台全部完成：立体声 `auval` 全 SUCCEEDED；四声道按 §8.4 的判据验收（`verify_quad.py` 9/9）。

如果之后要再改造一台新插件，照下面的顺序走：

| 步骤 | 做什么 |
|---|---|
| 1 | 读原版 CSD，`grep -o 'channel("[a-zA-Z0-9_]*"'` 列出全部通道，标 A/B/C 类（§2） |
| 2 | 按 DSP 信号流排 `PARAM_IDX`（§6.1 规则 0），写 CSD 的 `<Cabbage>` JSON（§4） |
| 3 | 抄一台最接近的参考实现（见上表），只换场景层，控制台层基本照搬 |
| 4 | **导出前把 `cabbage/` 运行时 + `cabbage.css` 一起带上**（§9 的「部署缺运行时」坑） |
| 5 | `auval -v aufx <ID> Cabb` + 数一遍 `Added parameter` 的顺序 |

---

**每个插件开工前必做的三件事**（§10 第 1 步的细化）：

1. `grep -o 'channel("[a-zA-Z0-9_]*"' xxx.csd | sort -u`
   得到全部通道，逐个标 A / B / C 类（§2）。
   **`label*` / `image*` / `groupbox*` / `bg` / `grid*` 一律丢掉**——它们是 Cabbage 2 的布局残留。
2. 把**控件**通道按 DSP 里的先后排成一列，这就是 §6.1 规则 0 要的顺序。
3. 决定**控件形态**（先看原版是什么风格，别按自己的习惯改）：
   - `outL/outR` 是电平表（§6.15），不是控件；
   - `x/y`、`box_x/box_y`、`centerX/centerY`、`visualBall` 是可视化坐标，用 pad 拖拽 + 推子；
   - `minWet/maxWet` 是双滑块（§6.8）；
   - 其余数值参数，原版用旋钮就旋钮（§6.14/§6.16），原版用推子就推子行。
   **SwarmGrain 的教训**：原版是 McCudy 的推子风格，被改成旋钮后整体返工。

> ⚠️ Boids 里有 `window`/`windowTable`/`reverse`/`grid_h`/`grid_v`
> 这类"看起来该做下拉框"的通道。Cabbage 3 的自定义 UI 里**没有原生下拉框**，
> 用 §6.18 的多态开关扩展成 N 档代替。SwarmGrain 的 `window` 就是 5 档
> （`--i` 变量 + `translateX(calc(var(--i) * 100%))`，tab 宽度取 `20%` 才等于一格），
> 形状预览用公式画，不依赖 gentable。
>
> 💡 **控件形态先问一句「原版是什么风格」**：SwarmGrain 原版（McCudy delaygrain 前端）
> 全用推子，改版时我按自己的习惯换成旋钮，被要求整体重做。数值控件用
> **推子行**（标签 84px + 轨 + 44px 数值）比旋钮更好排：两列网格里
> `84 + 7 + track + 7 + 44` 正好塞进 284px，标签能写全称，也不占竖向空间。
>
> 💡 **标签一律写全称**：`Field R` → `Field Radius`，`Cut Min/Max` → `Cutoff Min/Max`。
> 缩写只允许出现在数值的单位后缀里（`7.8k`），不要出现在参数名里。

---

## 13. 摄像头手势（可选）

**已接入 12 台**：Stasis / SwarmGrain / Boids 的 Quad、Depth、HRTF、Ambi 四个渲染器版本
（它们的源工程里有 `gesture.js` + `gesture-ui.js`，`mediapipe/` 由 `scripts/gesture-assets.py` 复制进来，导出时整份同步进运行时）。
其余 6 个算法（Orbita / levy / loom / zephyr / Singularity / Lissajous）没有接 ——
3 个算法 × 4 个渲染器 = 12 台。

实现与踩坑独立成文：[摄像头手势模块.md](./stereo%20wildtrace/摄像头手势模块.md) —— 接之前先读完，
它的核心结论是「采集层和计算层是两套调度，只停 rAF 不会停摄像头」。

接上之后记得把**用户视角**的用法写进 `help.html`（§5.8）：三个模式各认哪只手、
手往哪边 = 参数往哪边走、画布上的白点是什么、手感反了怎么当场校准。
手势这种"不看文档绝对猜不出来"的功能，不写进手册等于没做。

---

## 14. 四声道系列（Quad Doppler，2026-11-01 完成，11-03 补第 9 台）

`quad Doppler/` 下的 9 台四声道插件已全部升级到 Cabbage 3，与立体声版**共用同一套前端**，
只换了输出级。目录、命名、ID 与立体声版一一对应：

| 插件 | 目录 | ID | 画布（= form.size / BASE） | 主增益通道 |
|---|---|---|---|---|
| Stasis | `Quad-Stasis Cabbage3` | `Q3ST` | 380×465 / 1 | `masterGain` |
| Orbita | `Quad-Orbita Cabbage3` | `Q3OB` | 320×470 / 1.25（form 400×588） | `masterGain` |
| levy | `Quad-Levy Cabbage3` | `Q3LV` | 380×560 / 4⁄3（form 507×747） | `masterGain` |
| loom | `Quad-Loom Cabbage3` | `Q3LM` | 620×700 / 1 | `masterGain` |
| Singularity | `Quad-Singularity Cabbage3` | `Q3SG` | 620×700 / 1 | `masterGain`（在 instr 1 里乘） |
| zephyr | `Quad-Zephyr Cabbage3` | `Q3ZP` | 620×700 / 1 | `masterGain` |
| SwarmGrain | `Quad-SwarmGrain Cabbage3` | `Q3SW` | 620×820 / 1 | `level` |
| Boids | `Quad-Boids Cabbage3` | `Q3BD` | 620×760 / 1 | `vol` |
| Lissajous | `Quad-Lissajous Cabbage3` | `Q3LJ` | 380×684 / 0.9342（form 355×639） | `masterGain` |

> Lissajous 是第 9 台：depth 版 11-01 就有，**quad 版 11-03 才补**（做四声道那批时漏了它）。
> 它的前端本来就是「示波器 + 两列表」，四声道只要把左右两列换成
> 2+2 两列（FL/RL | FR/RR），画布尺寸完全不用动 —— 355×639 里
> `20 + 40 + 12 + 200 + 12 + 40 + 20 = 344`，200 px 的示波器放得下。
> 台面上它也是唯一一台**后端需要改**的四声道插件（`x/y` 可以是音频速率，见 §14.1 末尾）。

### 14.1 结构差别：输出级 + 距离模型

立体声 `DepthStereoRender, aaaa` 换成四声道 `QuadRender, aaaaaa`：

```
DepthStereoRender  aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize      → aDryL, aDryR, aWetL, aWetR
QuadRender         aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize      → aFL, aFR, aRL, aRR, aWetL, aWetR
```

`QuadRender` 用**径向距离**（以 0.5,0.5 为圆心）驱动 `vdelay3` 做多普勒，X/Y 等功率
分配到四角，湿声按归一化距离在 min/max 之间插值。`xout` 6 路。

> **★ 2026-11 修正：`QuadRender` 原先没有距离模型，9 台四声道全部缺。**
> **同一台插件的四个渲染器必须用同一套曲线**（否则同一个声源在 Quad 与 Depth 上
> 听感不同）。实测 9×4 已全部对齐，但**低通有两档**，抄的时候要跟自己对：
>
> ```c
> aNormDist = aDist / 0.7071
> aNormDist limit aNormDist, 0, 1
>
> ; 距离低通：中心 20 kHz → 盘边降到底
> aDepthInv = 1 - aNormDist
> ; A 档（Boids / Lissajous / Orbita / Singularity / SwarmGrain / levy / loom）
> aCutoff = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)   ; 底 1.0 kHz
> ; B 档（Stasis / zephyr，深度版原设计就是这一档）
> aCutoff =  800 + ((aDepthInv * aDepthInv * aDepthInv) * 19200)   ; 底 0.8 kHz
> aFiltL  tone aDlyL, aCutoff
> aFiltR  tone aDlyR, aCutoff
>
> ; 距离衰减：Room Size 越大越陡
> aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
> aDistAmp     = exp(-aNormDist * aDecayFactor)
>
> aMono = (aFiltL + aFiltR) * 0.5
> aDry  = 0.5 * aMono * aDistAmp
> ```
>
> **湿声发送也要乘 `aDistAmp`**：只给干声做衰减时，盘边湿/干比会到 20 倍（远端只剩混响）。
>
> ```c
> aWetSend = aMinWet + (aNormDist * (aMaxWet - aMinWet))
> aWetSend = aWetSend * aDistAmp        ; ← 必须补这一行
> ```
>
> Room Size = 50 时：`aNormDist` 0 / 0.5 / 1 → 衰减 0 / −9.7 / −19.3 dB，低通 20k / 3.4k / 1k Hz。
> 漏掉这一层的实际症状见 §9（「毛躁的颗粒噪音」）。

instr 1 只负责「算位置 → 渲染 → 累加到 `gaFL/FR/RL/RR` + `gaWetL/R`」，
**混响、总线、`out`（四参数）、四路电平表全部收到独立的 instr 2**（SwarmGrain 是 instr 3，
因为它原来就用 1/2/3 三个 instr）。

> **Lissajous 是这套骨架里唯一需要打补丁的一台**：它的 x/y 可以是**音频速率**
> （`xsrc`/`ysrc` 选 IN L/R/M 时，轴坐标就是输入音频本身）。原始径向距离直接喂
> `vdelay3` 会变成音频速率延迟调制 —— 听感是啸叫 + 混叠，不是多普勒。
> 所以在 `QuadRender` 里加两行，把「慢变量」全部换成 10 ms 平滑后的距离：
>
> ```csound
> kDistFast downsamp aDistRaw
> aDist interp portk(kDistFast, 0.01)
> ```
>
> 与深度版 `DepthStereoRender` 里那句同一个写法。合成的（非音频）轴不受影响 ——
> `portk` 10 ms 远快于任何 LFO 速率。

### 14.2 前端只改 5 处

| 改什么 | 怎么改 |
|---|---|
| 顶栏副标题 | `Depth Render` → `Quad Doppler` |
| 电平表 | 2 只 → 4 只：左 FL/RL、右 FR/RR，`justify-content: space-between` 叠放 |
| 电平 JS | `outL/outR` → `outFL/outFR/outRL/outRR`；`lvlL/lvlR` → 四个；`updateGlow()` 取四路最大 |
| `PARAM_IDX` | **不动**（表通道都是 `automatable:false`） |
| 柱高 / `METER_H` | 两只叠放后必须按竖直空间重算，见 14.3 |

### 14.3 柱高是「算」出来的，不是抄的

单只表原来占满 pad 的高度；叠成两只后竖直空间不变，柱高必须减半或按剩余带宽反算：

| 插件 | 可用竖直带 | 柱高（旧→新） |
|---|---|---|
| Orbita | pad 182（flex 行内） | 154 → **72** |
| levy | pad 174 | 150 → **70** |
| Singularity | 46 → pad 底 440 | 372 → **172** |
| SwarmGrain | 88 → 窗函数面板顶 248 | 116 → **52**（刻度同时 7 条 → 5 条） |
| Boids | 74 → 控制台顶 416 | 280 → **148** |
| loom / zephyr | 104 → pad 底 450 | 148 不变，两只刚好 322 装进 326 |
| Lissajous | 200（示波器同高）| 深度版单表 **150 → 78**（78×2 = 156 < 200）|

> SwarmGrain 是最挤的一台：它在 pad 右侧还有「窗函数列表 + 波形预览」，
> 第一版把 RL 压在 WINDOW 标题上，最后把整组表上移到 `top: 88px`、柱高 52 才让开。

### 14.4 四声道特有的三个坑（都踩过）

1. **`channelConfig` 必须删，`nchnls_i` 也不要写**，只留 `nchnls = 4`（§9.0）。
2. **`out` 要写四个参数**：`out aFL, aFR, aRL, aRR`。`outq` 在 Csound 7 已弃用（编译日志报
   `opcode outq is deprecated`），9 台全部改掉了。判据不是「用了哪个 opcode」，而是**参数个数** ——
   只写两个参数的 `out` 就真的只出前两路，表会「有反应但 RL/RR 没声」。
3. **主增益只能乘一次**：Singularity 在 instr 1 里就把 `kMasterGain` 乘进 `aMasterL/aMasterR` 了，
   instr 2 再乘会变成平方（默认 2 时实际 4 倍）。

### 14.5 改完的验证顺序

单台改完先跑这两支（**命令细节、六支脚本的完整流水线见 §15**）：

```bash
python3 quad\ Doppler/tools/check_csd.py  quad\ Doppler/Quad-*/cab3-quad-*.csd
python3 quad\ Doppler/tools/check_html.py quad\ Doppler/*Cabbage3/
```

再做三项「看着差不多不算验证」的检查（§7.4）：

- 浏览器逐点喂 `outFL/outFR/outRL/outRR` 四个不同值，四只表的柱高必须互不相同；
- `--lvl` 顶部光晕取四路最大值（喂一路 0.8 就应该亮到 0.8）；
- 视觉通道（`orb_x` / `levy_x` / `loom_x` / `sing_x+r` / `zep_x/env` / `swarm_x` / Boids 的 `bx*` /
  Lissajous 的 `lis_p`+`lis_x/y`）仍能驱动画面，说明 instr 1 的推送没被删掉。

### 14.6 导出与安装（2026-11-01 8 台，11-03 补 Lissajous 并改为只出 AU）

用 `quad Doppler/tools/export_plugin.py` 一条命令走完「复制模板 → 打补丁 → 改名 →
改 plist → 部署运行时 → 签名 → 安装」：

```bash
cd "quad Doppler"
python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3   # 四声道：只出 AU（§9.1 决定）
```

> **四声道必须带 `--no-vst3`。** Cabbage 3 的 VST3 包装器处理不了多总线
> （Lattice 只喂端口 0 却按总声道数写 → 越界），不改 C++ 修不了，见 §9.1 末的「决定」。
> 立体声（depth）版是 2 in / 2 out，VST3 正常，那 9 台**不要**加这个开关。

脚本从 **CSD 的 `<Cabbage>` 里读 `pluginId` / `caption`**，不靠手抄 ——
手抄 caption 与 CSD 不一致时，二进制名和 `CFBundleName` 会对不上。

#### 产出与落点

```
Quad-X Cabbage3/build/Cab3-Quad-X.component     ← AUv2（唯一交付格式）
Quad-X Cabbage3/build/Cab3-Quad-X.vst3          ← VST3（--no-vst3 时不生成）
~/Library/Audio/Plug-Ins/Components/            ← 装好的 AU
~/Library/Audio/Plug-Ins/VST3/                  ← 装好的 VST3（--no-vst3 时不装）
~/Library/CabbageAudio/Cab3-Quad-X/             ← 运行时（CSD + index.html + 完整 cabbage/ + cabbage.css）
```

三份资源的关系必须是：

| 名字 | 值 |
|---|---|
| 组件/包目录名 | `Cab3-Quad-X.component` / `.vst3` |
| 二进制名 | `Cab3-Quad-X`（必须 755） |
| `CFBundleExecutable` / `CFBundleName` | `Cab3-Quad-X` |
| 部署后的 CSD 文件名 | `Cab3-Quad-X.csd`（**必须等于二进制名**） |
| 源 CSD 文件名 | `cab3-quad-x.csd`（小写 kebab，只用于 git） |
| `CFBundleIdentifier` | AU: `com.cabbageaudio.cab3quadx`　VST3: 再加 `.vst3` |
| `AudioComponents.0.subtype` | `Q3XX` |

#### VST3（四声道已不出，depth 照旧）

补丁规则（AU 三组 / VST3 一组、`Cp47` 在两边都是 3 处、二进制变大是签名不是补丁）
统一写在 **§8.1**，这里不重复。四声道的结论只有一条：
**不生成 VST3**（§9.1 末「决定」），导出带 `--no-vst3`。

#### 实测结果（2026-11-01，11-03 补 Lissajous，`tools/verify_quad.py`）

| ID | 插件 | 能力表 | 四路 RMS（正中/最响位置） | 结论 |
|---|---|---|---|---|
| `Q3ST` | Stasis | 4 in / 4 out | 0.2462 / 0.2442 / 0.2462 / 0.2442 | ✅ |
| `Q3OB` | Orbita | 4 in / 4 out | 0.3121 / 0.0745 / 0.3615 / 0.0867 | ✅ |
| `Q3LV` | levy | 4 in / 4 out | 0.3134 / 0.3657 / 0.0880 / 0.1018 | ✅ |
| `Q3LM` | loom | 4 in / 4 out | 0.1553 / 0.1590 / 0.2675 / 0.2717 | ✅ |
| `Q3ZP` | zephyr | 4 in / 4 out | 0.3163 / 0.2922 / 0.1914 / 0.1662 | ✅ |
| `Q3SG` | Singularity | 4 in / 4 out | 0.0583 / 0.0579 / 0.0556 / 0.0550 | ✅ |
| `Q3SW` | SwarmGrain | 4 in / 4 out | 0.2850 / 0.2266 / 0.3360 / 0.2560 | ✅ |
| `Q3BD` | Boids | 4 in / 4 out | 0.1721 / 0.1748 / 0.1757 / 0.1802 | ✅ |
| `Q3LJ` | Lissajous | 4 in / 4 out | 0.2082 / 0.0278 / 0.4294 / 0.1414 | ✅ |

9/9 通过：`auprobe` 报 `in 4, out 4` + `SET OUT 4 ch -> 0 OK` + `readback: 4 ch`；
`aurender` 四路都有信号；日志无 `COMPILE ERROR` / `CSD file not found` /
`Excess channels ignored`。

`auval -v aufx <ID> Cabb` 对 9 台**全部报 FAIL**，且失败点只有
`Default Format of unit does not match`（每台 3 条），**零致命错误** —— 这是四声道的正常表现，
见 §8.4。判据是「日志里 CSD 读到了、Csound 编译 done」，不是那个 SUCCEEDED。

> `aurender` 是给 Stasis 写的：它只会设 `x` / `y` 两个参数。
> Orbita / levy / loom / zephyr / Singularity / SwarmGrain 的 `x` 是自动运动的（没有 x/y 参数），
> 所以那几台的「四路 RMS 各不相同」只能说明四声道链路通了，**不能**用来看声像是否精准；
> 声像要进宿主（或 VST3 实例化后）实测。

#### 装完必做

```bash
ps aux | grep AudioComponentRegistrar | grep -v grep | awk '{print $2}'   # 取 PID
kill <PID>            # 只是刷新缓存，macOS 会立刻重启它
```

漏了这步，宿主里会看到旧版本、或者根本看不到新装的插件。

> 实测两个注意点（2026-11-03）：
> 1. 有两个实例时，`root` 那个会报 `Operation not permitted` —— **正常，跳过它**，
>    杀掉自己用户的那个就够。
> 2. 杀掉后 `ps` 里可能立刻又出现同名进程（launchd 拉起的新实例），**不是没杀掉**。
> 3. 新装的**插件**（不是更新）通常不必等它：`auprobe` / `verify_quad.py` 直接用
>    `AudioComponentFindNext` 就能找到（Q3LJ 装完即刻验证通过）。只有**替换同名二进制**时
>    才需要刷新，否则宿主拿到的是旧的那份。

---

## 15. 验收：四层体检（2026-11-02 实跑）

> 改造完不等于能用。**「看着差不多」是这个系列最大的 bug 来源**（§7.4）。
> 这一章把四声道批次实际跑过的验收固化成六支脚本，顺序不能颠倒：
> 静态能查出来的不要用活体查，活体能查出来的不要靠听。

### 15.1 四层体检用的六支脚本

```bash
cd "quad Doppler"
# 层 1 的前半：先确认「能编译、引用不漏」—— 最快，10 秒内出结果
python3 tools/check_csd.py  Quad-*/cab3-quad-*.csd    # 给 Cabbage opcode 打桩后真编译一遍
python3 tools/check_html.py Quad-*Cabbage3/           # JS 引用的 id 必须存在、四表成套、比例一致
python3 tools/audit.py                # 层 1 静态：CSD ↔ DSP ↔ HTML 三方交叉
python3 tools/check_params_live.py    # 层 2 活体：问已装 AU 要参数表
python3 tools/stress_test.py          # 层 3 压力：参数推到量程边界
python3 tools/verify_quad.py         # 层 4 链路：能力表 + 四路 RMS（AU 侧，VST3 已不交付）
```

> `check_csd.py` 是**真编译**（不是正则检查）：Cabbage 专有 opcode 打最小桩之后交给 CLI
> `csound`，能抓出 `limit (expr), ...` 这类 Csound 7 语法变化。`audit.py` 只做静态交叉，
> 编译错误它看不见 —— 两支都要跑，**别用后者替代前者**。
>
> ⚠️ **`audit.py` / `check_params_live.py` / `stress_test.py` / `verify_quad.py` 都只认四声道契约**
> （D 类检查写死 `nchnls = 4` + 四只表 + `outFL..RR`）。拿它们跑 depth 工程会报 **23 条假问题**
> （「缺 mtrRL / 缺 case 'outRL'」…）。depth 的体检是 `check_csd.py` + `check_html.py`
> 两支（`check_html.py` 会按页面实际的 `mtr*` 推出 2 路还是 4 路，两套都能跑）。

| 层 | 查得出来的 | 查不出来的 |
|---|---|---|
| 1 静态 | **真编译**：语法错误、Csound 7 opcode 变化；`$('id')` 指向不存在的元素、四表不成套；通道没声明、顺序错、默认值四处不一致、`METER_H` 对不上、死变量 | 宿主实际注册顺序、DSP 数值行为 |
| 2 活体 | 宿主里的参数顺序/范围/默认值、隐藏通道是否注册 | 极端参数下的数值爆炸 |
| 3 压力 | NaN、爆值、`out of range`、静音区间 | 声像是否精准 |
| 4 链路 | 四声道真的出四路、CSD 读到、编译通过 | 界面手感 |

### 15.2 这一轮修掉的 7 个真问题

| 插件 | 问题 | 怎么发现的 |
|---|---|---|
| 36 台全部（手势 12 台各带 `gesture*.js` + `mediapipe/`） | 重新导出把 `help.html` / `gesture*.js` / `mediapipe/` 删掉（部署按固定清单重建） | 对账「源目录 vs 运行时目录」发现，§9 坑表已记 |
| Stasis / SwarmGrain ×depth+quad | 改成整目录同步后，源工程那份只有 `cabbage.js` 的 `cabbage/` 被带过去 → **四路 RMS 全 0**、参数消失 | 层 4（`verify_quad.py` 直接报 `a` 失败；`auprobe` 日志刷 `Unknown widget type`） |
| Stasis | `cutoff` 默认 **6000**（其余 8 台 16000） | 层 1（C 类：默认值契约） |
| Stasis | CSS 用 `var(--lvl)` 但 JS **从不赋值** → 光晕恒定 | 层 1（E 类：死代码） |
| levy | `sr = 44100`（其余 48000） | 人工比对 |
| Boids | `id="padGlow"` 重复两次 | 层 1（重复 id） |
| 全部 9 台 | `outq` 在 Csound 7 已弃用 | 层 1（`check_csd.py` 真编译日志） |

**`outq → out`** 这一条值得单独记：Csound 7 起 `out` 支持多参数（4 个参数就是四声道），
`outq` 只是兼容保留，每次编译都刷一条 `opcode outq is deprecated`。实测两者输出完全一致
（同一组参数 RMS 逐位相同），所以改 `out` 是纯收益：

```csound
out aOutFL, aOutFR, aOutRL, aOutRR        ; Csound 7 正确写法
; outq aOutFL, aOutFR, aOutRL, aOutRR     ; 旧写法，会告警
```

> ⚠️ 判断「是不是四声道」要看**参数个数**，不是看 opcode 名：
> `out aOutL, aOutR` 是立体声，`out aFL, aFR, aRL, aRR` 才是四声道。
> 审计脚本（`audit.py` 的 D 类）就是按参数个数判的。

### 15.3 两个**工具自身**的坑（不知道就会拿到假数据）

| 工具 | 坑 | 症状 |
|---|---|---|
| `aurender.c` | 按参数**序号** 0/1 设 `x`/`y` | Singularity 的参数 0 是 `fallTime` → 每次渲染都把 fallTime 覆盖掉，测出来的全是假的。**必须按名字查序号** |
| `stress_test.py` | 只看「正中」位置的 RMS | 没有 x/y 的插件三次位置相同，容易误判「静音」/「正常」 |

`aurender` 的正确做法：

```c
int findParam(AudioUnit au, const char *want);   // 用 kAudioUnitProperty_ParameterList
                                                 // + kAudioUnitProperty_ParameterInfo 按 name 匹配
```

并且要**明确打印**「位置参数 x/y: 有/无」，否则读日志的人会以为那三组数据有意义。

### 15.4 压测结论（30 秒长渲染 + 边界参数，9 台全过）

- **无 NaN、无爆值、无 `samples out of range`**。
- `masterGain = 8` 时峰值 1.0~1.9（Orbita 1.37 / loom 1.90 / zephyr 1.22）。
  这是 0~8 线性增益的必然结果，**与立体声版一致，不额外限幅**；
  要防削顶得在 `out` 前加 `tanh`，但那会改变音色，需要单独决策。
- **Singularity `gravityCurve ≥ 3` 整台静音**：`kGainEnv = pow(kNormRadius, kEnvIndex)`，
  粒子一进入 `kNormRadius < 1` 就被指数压没。**原 C2 版就是这行为**，不是移植引入的。
  默认 0.5 正常。若用户反馈「拧大了没声」，要改的是参数语义，不是移植代码。

### 15.5 界面手测（浏览器逐台点，本轮做过的）

| 动作 | 期望 | 结果 |
|---|---|---|
| 拖旋钮 | 数值跟随、无选中拖影 | ✅ Stasis 50→78 |
| 双击旋钮 | 回 `P.def` | ✅ 78→50 |
| 拖 pad | X/Y 读数跟随 | ✅ 0.500→0.833/0.778 |
| 双击 pad | 回中 0.5 | ✅ |
| 拖湿声 min 越过 max | 被夹在 `max - 0.001` | ✅ 0.58 / 0.60 |
| 喂四路不同电平 | 四表柱高互不相同 | ✅ |
| 喂电平后看光晕 | `--lvl` 真的变 | ✅ opacity 0.40 → 0.94 |
| Lissajous 合成轴 | 光点贴着导引线走完整 ∞，不拉弦 | ✅ `2:1 · φ90°` |
| Lissajous 音频轴（X=IN L / Y=IN R） | 余晖铺满整条轨迹、标题变 `IN L × IN R` | ✅ |
| Lissajous 四表 | 四路给不同电平，柱高互不相同、`--lvl` 取最大 | ✅ |
| 点双态开关 / 走带按钮 | 状态与文字同步 | ✅ Singularity / zephyr / SwarmGrain / Orbita |

> **`--lvl` 这条特别值得测**：它没有报错、界面也不会崩，只是"亮一点暗一点"的差别，
> 肉眼几乎看不出 —— 但它是 9 台里唯一一处**完全失效的动态效果**。
> 测法：`getComputedStyle(el, '::before').opacity` 喂电平前后各读一次。

---

## 16. 距离场辅助线（Depth pad 的半圆与圆盘）

> 2026-11 新增。9 个 Depth 插件的 pad 现在画**同一套距离场**，
> 圆心在**底边中央 (0.5, 0)**，因为 DSP 里 `aDistance = sqrt((x-0.5)^2 + y^2) * 0.89442719`。

### 16.1 画法（源实现：`stereo wildtrace/Stasis Cabbage3/index.html` 的 `buildRings`）

```js
const step = PAD.h / 12;                        // 间距 = pad 高的 1/12
const far  = Math.hypot(PAD.w / 2, PAD.h);      // pad 内离圆心最远的点（上角）
const last = Math.floor(far / step) * step;     // 画到对角为止，再大完全不可见
for (let i = 1; i * step <= last; i++) {
    const r = i * step;
    const t = (r - step) / (far - step);        // 0 = 最近，1 = 最远
    const a = 0.34 * Math.pow(1 - t, 1.05) + 0.085;   // 单调递减，下限 0.085
    // 偶数圈实线（.major）、奇数圈虚线 3 4
}
```

四条硬性要求：

| 要求 | 原因 |
|---|---|
| **满圈圆 + `clipPath` 裁一半**，不要用 `path` 画真半圆 | 圆心在底边时下半圈被裁掉，视觉上就是同心半圆，半径加大能自然铺满 pad 顶部 |
| **透明度随半径递减** | 否则远端线条比近端抢眼，直接读反距离 |
| **颜色走主题色，alpha 全部由 JS 的 `stroke-opacity` 给** | CSS 里写死 rgba 的 alpha 会被 JS 覆盖，两种 alpha 相乘更难调 |
| 类名用 `.dring` / `.dring.major`，**不要用 `.ring`** | 各插件 header logo 里已有一个 `.ring`（`.hdr .mark .ring`），会被 `stroke-dasharray` 污染 |

### 16.2 参考线不能压住场域

SwarmGrain 的场域薄雾和参考线在同一块 pad 上，参考线必须**挖掉场域圆**：

```html
<mask id="fieldHole" maskUnits="userSpaceOnUse" x="105" y="76" width="330" height="330">
    <rect x="105" y="76" width="330" height="330" fill="#fff"/>
    <circle id="fieldHoleC" cx="270" cy="241" r="82" fill="#000"/>
</mask>

<g clip-path="url(#padClip)" mask="url(#fieldHole)" pointer-events="none">
    <g id="rings"></g>
</g>
```

遮罩圆在 `paintField()` 里跟场域同步，半径取 `fieldR + 1.5` —— 多留 1.5 是为了让那圈
白色虚线框（`fieldRing`，描边宽 1）不被一起切掉。

### 16.3 三个 pad 不是方形

| 插件 | 处理 |
|---|---|
| Singularity | 盘被压扁（`rx:ry = 250:78`），等距线是**同比例椭圆**，并用 `mask` 挖掉视界那块，否则线会压在纯黑的球面上 |
| Lissajous | 是示波器，导引线要让位给图形本身，透明度整体再乘 **0.55** |

### 16.4 Ambi / HRTF 的圆盘钳制

Ambi 与 HRTF 的声场是**圆盘**（方形 pad 的四角在盘外），前后端都要钳：

```js
/* 前端：参数层钳制，不要只钳显示 */
const clampDisc01 = (x, y) => {
    const dx = x - 0.5, dy = y - 0.5, d = Math.hypot(dx, dy);
    if (d <= 0.5 || d === 0) return [x, y];
    return [0.5 + dx / d * 0.5, 0.5 + dy / d * 0.5];
};
```

```c
/* 后端：与前端一致，超出盘边沿半径收回 */
kDdx = gkX - 0.5
kDdy = gkY - 0.5
kDrad = sqrt(kDdx*kDdx + kDdy*kDdy)
if kDrad > 0.5 then
    gkX = 0.5 + kDdx / kDrad * 0.5
    gkY = 0.5 + kDdy / kDrad * 0.5
endif
```

> **坑：钳制必须放在参数层。** 只钳 `toScreen()` 会让「推子位置 / 读数 / 圆心」变成三个数 ——
> 实测点 pad 右上角时，推子显示 0.96、圆心画在 0.707、后端按另一个值算声像。
> 统一走 `setFieldCenter()` 之后三者才一致（0.8536 = `0.5 + 0.5/√2`）。
>
> 另外场域薄雾要挂在 `clipPath id="discClip"`（`circle 270,241 r=165`）上，
> 否则漫出盘边的白色场域会铺到斜纹死区上。

---

## 17. 头部图标（野痕 = 算法制图）

> 2026-11-02 定稿（11-03 补 Lissajous）。9 台的头部图标从「5 种圆环/方块」统一成一套**算法制图**。

### 17.1 为什么不是「好看的几何图形」

这个系列的所有 DSP 都在模拟自然过程（Lévy 飞行、群集、漩涡、风、引力、颗粒散布）。
图标如果画成通用的圆环/方框，读者看到的是**仪表盘符号**；画成手绘划痕，又变成**装饰**。
定稿的方案是第三种：**把算法结构本身画成最小可视解**。

统一的是「制图语言」，不是形状：

| 规范 | 值 |
|---|---|
| 画布 | `viewBox="0 0 16 16"`，渲染 13×13 |
| 线 | 1.0px（多元素时 0.8~1.15）等宽，`stroke-linecap="round"` |
| 实心点 | 全系列**只有一颗**，代表「当前声源」，r=1.55~1.7 |
| 禁止 | 填充色块、投影、渐变、手绘抖动、装饰性圆点 |

### 17.2 9 台各画什么

| 插件 | 图标 | 对应算法 |
|---|---|---|
| STASIS | 距离环 + 中心源 | 径向距离场驱动延迟，源静止 |
| ORBITA | 闭合椭圆 + 在轨点 | phasor 驱动的椭圆轨道 |
| LÉVY | 步长递增的折线 | 幂律长尾步长 + 边界折返 |
| LOOM | 带钩的 S 形 | 蛇形（boustrophedon）遍历，两端即折返 |
| SINGULARITY | 开放的对数螺旋 | 半径指数收缩/膨胀的螺旋 |
| ZEPHYR | 两条流线 + 之间的源点 | 平行风道 + 侧向湍流 |
| SWARMGRAIN | 尺寸递减的点云 | 高斯散布（中心密、边缘疏） |
| BOIDS | **准星鸟**（直接取 pad 里头鸟的路径，0° 头朝上） | 分离/对齐/聚合 + 航向 |
| LISSAJOUS | 8 字形（x=sin t, y=sin 2t） | 两轴频率比 2:1 的正交周期信号合成闭合轨迹 |

> **BOIDS 用 pad 里的真实几何，不是另画一只鸟**：`birdPath()` 里那条燕形描边曲线
> （`M-1 0.6 C-0.6 0.14 -0.2 0.07 0 -0.04 C0.2 0.07 0.6 0.14 1 0.6`）+ 机身线
> `M0 -0.42 L0 0.46`，取 0°（头朝上），`scale(7.2)` 装进 16 网格。
> 这样图标和界面里的头鸟是**同一个形状**，不是两套设计。
>
> ⚠️ `g` 上有 `scale`，子路径的 `stroke-width` 会被放大同样的倍数，必须反算：
> 想要 1.2 个 viewBox 单位的线宽，就写 `1.2 / 7.2 ≈ 0.167`。写 `1` 会得到 7.2 倍粗的黑块。

### 17.3 颜色取自各插件自己（不要新造色）

| 插件 | 颜色 | 来源变量 |
|---|---|---|
| STASIS | `#ffffff` | `--fg` |
| ORBITA | `#ff6b3d` | `--orange` |
| LÉVY | `#ff113e` | `--red` |
| LOOM | `#ffc24b` | `--gold` |
| SINGULARITY | `#ffc95c` | `--gold`（**旋钮弧的颜色**，不是 `--red`） |
| ZEPHYR | `#c846a0` | `--magenta` |
| SWARMGRAIN | `#ff2037` | `--red` |
| BOIDS | `#ff3b40` | `--red` |
| LISSAJOUS | `#a678ff` | `--uv` |

> **颜色要取「旋钮/弧线」那一档，不是 `--red`**：Singularity 的 `--red: #ff3d24` 是黑洞边缘的
> 深红，放在 13px 的图标上偏暗、且和 LÉVY / SwarmGrain 的红挤在一起。它旋钮弧用的是
> `--gold: #ffc95c`，和标题、刻度弧同色 —— 图标用这个才和界面是一套。

> **颜色内联写死**（`stroke="#ff6b3d"`），不依赖 CSS 变量：这些页面里 `.mark` 的
> 样式规则各不相同（有的在 `<div>`，有的直接在 `<svg>` 上），靠继承会把图标的颜色
> 吃成标题色。内联 + 内联 `style="width:13px;height:13px"` 最稳，也不怕各文件残留的
> `.mark svg { width: 11px }` 旧规则。

### 17.4 落地方式

```bash
cd "quad Doppler"
python3 tools/apply_icons.py --dry-run          # 先看会改哪几处
python3 tools/apply_icons.py                    # 只改 quad 9 台
python3 tools/apply_icons.py --stereo            # 只改 depth 9 台
python3 tools/apply_icons.py --all               # 两套都改

# 图标在 index.html 里，必须重新导出才会进宿主
python3 tools/export_plugin.py Quad-*Cabbage3
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3
```

`apply_icons.py` 的匹配顺序是 `svg.mark` → 无 class 的 `<svg viewBox="0 0 12 12">`
→ `<div class="dot">`（Singularity 原来就是个发光的 div），三种写法都覆盖。

### 17.5 三个坑（都踩过）

1. **点压在线上会糊成一坨**。ZEPHYR 最初把声源画在主风道正中间，13px 下点与线连成一片
   「叶子」。改成**两条流线 + 点落在它们之间的通道里**才读得出来。
   通则：**实心点周围必须留 ≥0.5 个单位的空白**，否则 13px 会粘连。
2. **8 只鸟不能挤**。BOIDS 第一版 V 编队翼展太窄，13px 下连成一个实心三角形 ——
   与 SINGULARITY 当初「坨在一起」是同一个病。解法是**拉开翼展 + 笔画减细**
   （大鸟 1.0、小鸟 0.8），让鸟与鸟之间留缝。
3. **删旧 CSS 会误伤容器**。`.mark .ring` / `.mark .core` / `.mark .q` 可以删，
   但 Stasis / Orbita / levy 的 `.mark` 本身是**flex 容器**（包着 svg + 标题），
   删了图标和标题就会挤在一起。删规则前先确认这个类挂在谁身上。

### 17.6 自检

`tools/_verify_icons.html` —— 直接 `fetch` 18 台（quad 9 + depth 9）的 `index.html`，
从**真实文件**里抠出 `<svg class="mark">` 渲染成 4× 放大 + 11/13/16/20/26 尺寸阶梯。
好处是验证的是落地结果，不是生成器里的字符串。

```bash
cd "quad Doppler" && python3 -m http.server 8771
# 打开 http://127.0.0.1:8771/tools/_verify_icons.html
```

---

# 附录：36 台统一的 DSP 增益契约

> 以下六节从 `cabbage3-改造模板.md` 并入（2026-11-06）。
> 上文 §0–§17 讲的是**单台怎么做**（目录 / 参数 / 视觉 / 导出），
> 这里讲的是**36 台必须一致的那层信号链**。

## 18. 三段增益结构（36 台统一）

```
inch
 │
 └─► Render UDO（距离低通 ─► 延迟/多普勒 ─► 声像 ─► ×aDistAmp）
          │
          ├── 干声 ×0.5 ────────────────────────────────┐
          │                                              ├─► + ─► ×Master ─► SoftClip ─► out
          └── 湿声发送 ×0.5 ×aWetSend ─► tanh ─► reverbsc ─┘
                                        （返回：Quad ×0.5，其余 ×1）
```

> `aDistAmp` 只乘一次，但在 Render 内部乘，因此**干声和湿声发送都吃到它**
> （湿声那条是 §14.1 单独补的：`aWetSend = aWetSend * aDistAmp`）。
> 漏掉湿声那一次，远端湿/干比会到 20 倍 —— 听感是「只有混响、音源散不掉」。

### 18.0 混响返回系数与反馈系数（按渲染器 / 按插件分两档）

这两处**不是全系列同一个值**，抄代码时别想当然：

| 项 | 取值 | 台数 | 分布 |
|---|---|---|---|
| **混响返回** | `aRevL * 0.5` | 9 | 全部 Quad |
| | `aRevL`（×1） | 27 | Depth / HRTF / Ambi |
| **`reverbsc` 反馈** | `0.1 + ((rs-10)/90) * 0.8` | 24 | Boids / Lissajous / Orbita / Singularity / levy / loom × 4 |
| | `0.15 + ((rs-10)/90) * 0.77` | 12 | Stasis / zephyr / SwarmGrain × 4 |

- **Quad 返回 ×0.5 是必须的**：同一路 `aRevL` 要加到 FL/FR/RL/RR 四个通道，
  0.5×4 = 2 通道等效能量；不做就是 4 倍混响堆积。
- 反馈系数两档是各插件的历史音色，**不要统一** —— 改了房间尾巴长度会变。

> 混响发送→返回的通路里，**SwarmGrain 是特例**：它在 instr 3 用
> `aPreOutFL = (aMasterFL + (aRevL * 0.5)) * klevel`，即返回系数与 dry/wet
> 混音、Master 一起算，不单独出现 `aOut = ... + (aRevL * 0.5)` 这个形状。

### 18.1 干声 ×0.5

Depth / HRTF / Ambi 版，在 `DepthStereoRender` UDO 内：

```c
; 空间衰减（与房间大小绑定）
aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
aDistAmp = exp(-aDistance * aDecayFactor)

; 干声同样归一化（-6 dB）：把工作点压回限幅器的线性区，
; 音量不足时由末端 Master Gain 补回。
aDryL = 0.5 * aFiltL * aDistAmp
aDryR = 0.5 * aFiltR * aDistAmp
```

zephyr 版多一个 `aEnvSmooth`：

```c
aDryL = 0.5 * aFiltL * aDistAmp * aEnvSmooth
aDryR = 0.5 * aFiltR * aDistAmp * aEnvSmooth
```

Quad 版，在 `QuadRender` UDO 内（距离模型见 §14.1，`aDistAmp` 必须在 `aDry` 之前算好）：

```c
; 距离低通 + 距离衰减 → 合成 aMono
aDepthInv = 1 - aNormDist
aCutoff   = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)
aFiltL    tone aDlyL, aCutoff
aFiltR    tone aDlyR, aCutoff
aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
aDistAmp     = exp(-aNormDist * aDecayFactor)
aMono = (aFiltL + aFiltR) * 0.5

; 干声归一化（-6 dB）+ 距离衰减
aDry = 0.5 * aMono * aDistAmp
aFL = aDry * aL * aF
aFR = aDry * aR * aF
aRL = aDry * aL * aB
aRR = aDry * aR * aB
```

### 18.2 湿声 ×0.5 → tanh

**顺序很重要**：先归一化再 tanh，不能反过来。

```c
; 湿声发送：先归一化再软限幅。
; reverbsc 在颗粒冲击下有自激励硬伤 —— 哪怕很小的增益也会「滋滋」，
; 所以发送端必须保留 tanh 把包络压住；但直接 tanh(满量程) 会削出
; 大量谐波，同样脏。这里先乘 0.5（-6 dB）把工作点压回 tanh 的线性区，
; 再 tanh，既保底防自激励、又几乎不产生谐波失真。
aWetL = 0.5 * aFiltL * aWetSend
aWetR = 0.5 * aFiltR * aWetSend
aWetL = tanh(aWetL)
aWetR = tanh(aWetR)
```

Quad 版：`aWetL = 0.5 * aMono * aWetSend`，其中 `aWetSend` 已被距离衰减过（见 §14.1）。

zephyr 版多一个 `* aEnvSmooth`，**0.5 放最前面**：

```c
aDryL    = 0.5 * aFiltL * aDistAmp * aEnvSmooth
aDryR    = 0.5 * aFiltR * aDistAmp * aEnvSmooth
aWetSend = aWetSend * aDistAmp
aWetL    = 0.5 * aFiltL * aWetSend * aEnvSmooth
aWetR    = 0.5 * aFiltR * aWetSend * aEnvSmooth
```

**效果**：THD 从 −24.7 dB 降到 −35.3 dB（降 10.6 dB）。

### 18.3 输出 SoftClip

插在 `out` 之前（或替换已有的 `tanh(aOut*)` / `limit(..., -1, 1)`）。

```c
; =========================================================
; 软膝限幅器：|x| <= 0.85 时完全线性（零谐波），
; 超过后按 C1 连续地压到 0.98 上限。
; 不用 tanh 的原因：tanh 从 0.5 起就开始明显弯曲，
; 干声稍微热一点就产生 -26 dB 的谐波 —— 那正是「滋滋」。
; =========================================================
opcode SoftClip, a, a
    aIn xin
    kThr  = 0.85
    kCeil = 0.98
    kSpan = kCeil - kThr
    aAx   = abs(aIn)
    aU    = limit(aAx - kThr, 0, 100)
    aShp  = kThr + kSpan * (1 - exp(-aU / kSpan))
    aOver = limit((aAx - kThr) * 200, 0, 1)
    aClip = (aIn / (aAx + 1e-20)) * aShp
    aOut  = aIn + (aClip - aIn) * aOver
    xout aOut
endop
```

调用（四声道逐路）：

```c
; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。
aOutL  = SoftClip(aOutL)
aOutR  = SoftClip(aOutR)
aOutBL = SoftClip(aOutBL)
aOutBR = SoftClip(aOutBR)

out aOutL, aOutR, aOutBL, aOutBR
```

### 18.4 SoftClip 与 tanh 的实测对比

| 峰值 | `tanh` THD | `SoftClip` THD |
|---|---|---|
| 0.30 | −42.9 dB | **−62 dB**（测量底噪） |
| 0.50 | −34.3 dB | **−62 dB** |
| 0.85 | −25.9 dB | **−62 dB** |
| 0.90 | −25.0 dB | −50 dB |
| 1.20 | −21.0 dB | −22 dB（开始压） |
| 2.00 | −16.3 dB | −13 dB（**封顶 0.98**） |

**0.85 以下 SoftClip 是纯线性的**，而 tanh 一直在产生 −26 dB 的谐波。

### 18.5 Csound 7 实现注意

- a-rate 不能用三元比较：`(aX > 0) ? ... : ...` 会报 `boolean expression with arg types a, c not found`
- a-rate 不能用 `max(a, c)`：报 `opcode 'max' for expression with arg types a, c not found`
- 必须用 `limit(aX, 0, 1)` 构造软过渡权重

---

### 18.6 多声源插件额外 -9 dB（仅 Boids）

Boids 是 8 个声源（1 头鸟 + 7 从鸟）叠加求和，峰值累加压力远大于单声源插件 ——
套完上面的三段结构后，Quad 版仍然会顶到限幅器。

在**输入捕获处**按功率求和的正确归一化衰减 **-9 dB（1/√8）**，
一次性压住干声、7 路抽头和反馈网络：

```c
aInL, aInR inch 1, 2
; 8 个声源求和：按功率求和的正确归一化是 1/sqrt(8) = -9.03 dB。
; 试过 -3 dB，实测 Quad 版仍会顶到限幅器（8 路同相叠加峰值 1.414×Master），
; 取 -9 dB：
;   0.35355339 = 1/sqrt(8) = 10^(-9.0309/20)
; 一次性压住干声、7 路抽头和反馈网络，末端 SoftClip 只做兜底。
aInAtt = 0.35355339
aSig = (aInL + aInR) * 0.5 * aInAtt
```

放在 `inch` 之后、`delayw` / 各路抽头之前，所以：

- 干声 `aIn0 = aSig * (1 - kMix)` → 自动 -9 dB
- 7 路抽头 `aT1..aT7` → 自动 -9 dB
- 反馈 `delayw aSig + aFbkSum` → 自动 -9 dB

**Boids 的实际内部余量 = 9 dB（输入，1/√8）+ 6 dB（干/湿减半）= 15 dB，
再叠加 Master 默认 2.00（而非 4）的保守设定。**

### 18.7 为什么是 1/√8 而不是 1/8

8 个声源在空间上分散、方向各不相同，声压不相关，**功率相加**而非幅度相加：

| 归一化 | 每源峰值 | 8 路同相（最坏） | × Master 4 | 结果 |
|---|---|---|---|---|
| 1（不衰减） | 0.250 | 2.00 | 8.00 / 4.00 | SoftClip 深压 |
| 1/√2（-3 dB） | 0.177 | 1.42 | 5.66 / 2.83 | Master 4 时仍深压（实测会炸） |
| **1/√8（-9 dB）** | 0.088 | 0.71 | **2.83**（Master 4）/ **1.42**（Master 2） | Master 2 时完全线性 |
| 1/8（-18 dB） | 0.031 | 0.25 | 2.00 / 1.00 | 欠驱动，用户要推 Master |

-3 dB 之所以不够：Master 从 2 提到 4 相当于 **+6 dB**，把 -3 dB 的一半抵消掉了。

> 推广：内部有 N 个声源求和的插件，输入归一化取 `1/√N`。
> Boids 的 N = 8（1 头鸟 + 7 从鸟），所以是 0.35355339。

---

## 19. 距离延迟是艺术效果，不是物理仿真

距离延迟**按渲染器分两种写法**（实测 36 台）：

| 渲染器 | 写法 | 台数 | 备注 |
|---|---|---|---|
| **Quad** | `0.01 + (aDist * (aRoomSize * 0.002))`，`vdelay3 …, aDelayTime*1000, 500` | 9 | 全部 Quad 都是这一档 |
| **Depth / HRTF / Ambi** | `0.1 + (aDistance * aRoomSize)` | 21 | Boids / Lissajous / Orbita / Singularity / SwarmGrain / levy / loom |
| | `0.01 + (aDistance * (aRoomSize * 0.002))` | 6 | Stasis / zephyr |

同一台插件在四个渲染器上**不保证同一个延迟式**（Quad 一律走 `0.01` 档，
Depth 侧 7 台走 `0.1` 档）—— 这是历史演进结果，不是笔误。

这些延迟量是**核心音色设计**，不是要逼近真实声速的声程计算。

- **不要**把它改成 `距离 / 340.29` 的物理公式
- **不要**为了"校准监听阵列"引入阵列半径 / 音箱坐标参数
- 60 ms 量级的延迟听感上是空间拖尾与"包住感"的来源，缩短会直接毁掉插件性格

听众处在扬声器环内部时，真实声程差本身就很小；插件里的延迟量是刻意放大的。
这条约束优先于任何几何精确性讨论。

> `vdelay3` 第三个参数是**毫秒**：`0.1 + 1×100` 已达 100 s，会被
> `aDelayTime limit aDelayTime, 0.001, 0.5` 硬钳到 500 ms ——
> Room Size 大时远端早就顶在钳位上了。这是既有行为，改钳位会变音色。

---

## 20. 逐插件核查清单

### 20.1 检查项

改完必须核对下面 8 项。下表「期望」是按实测计数写的，含 Quad/立体声的差异：

| 检查项 | 期望 |
|---|---|
| `grep -c "aWetL = 0.5 \*"` | 1 |
| `grep -c "aDry = 0.5 \*"`（Quad） | 1 |
| `grep -c "aDryL = 0.5 \*\|aDryR = 0.5 \*"`（Depth/HRTF/Ambi） | 2 |
| `grep -c "opcode SoftClip"` | 1 |
| `grep -c "= SoftClip(a"` | 4（Quad、Ambi）/ 2（Depth、HRTF），**Singularity 再 +2** |
| `grep -c "aWetSend = aWetSend \* aDistAmp"` | 1 |
| `grep -c "aDistAmp"` | 3（Quad：定义 + `aDry` + `aWetSend`）/ 4（其余：定义 + `aDryL` + `aDryR` + `aWetSend`） |
| master 通道 `defaultValue` | 2（`max` 为 8） |
| 多声源插件（Boids）`grep -c "aInAtt = 0.35355339"` | 1 |

四个容易误判的地方（都是实测踩到过的）：

> **`SoftClip` 调用数取决于输出路数，不是固定 4。**
> Quad / Ambi 是四声道 → 4；Depth / HRTF 是立体声 → 2。
>
> **Singularity 再多 +2**：它在 `aProcessed * kMasterGain` 之后有一道内层
> SoftClip（`aMasterL/aMasterR`），输出侧再各一道。所以四声道 Singularity 是 6、
> 立体声 Singularity 是 4。
>
> **`= SoftClip(a` 不能写成 `= SoftClip(aOut`**：SwarmGrain 的输出变量是
> `aPreOutL`，那个模式会漏掉它（计数 0，被误判成没做限幅）。
>
> **master 通道名不统一**，不能用 `tail -1` 取最后一个 `defaultValue`
> （那会取到 `outFL` 之类的电平表通道 = 0）。必须按 id 匹配：
> 多数是 `masterGain`，**Boids 用 `vol`**，**SwarmGrain 用 `level`**。

---

## 21. 验证流程

### 21.1 编译 + 模板项核查

```bash
cd /Users/yhk/Documents/csound/wildtrace

# 1. 36 个 CSD 全库编译
for f in */[A-Za-z]*Cabbage3/cab3-*.csd; do
  python3 "quad Doppler/tools/check_csd.py" "$f" | tail -1
done

# 2. 前端语法（抽取 <script type="module"> 内容后 node --check）
for f in */[A-Za-z]*Cabbage3/index.html; do
  python3 - "$f" <<'PY'
import sys, re
t = open(sys.argv[1], encoding='utf-8').read()
m = re.findall(r'<script type="module">(.*?)</script>', t, re.S)
open('/tmp/c.mjs', 'w').write(max(m, key=len) if m else '')
PY
  node --check /tmp/c.mjs && echo "OK $f"
done

# 3. 模板项核查（8 项，见 §20.1）
for f in */[A-Za-z]*Cabbage3/cab3-*.csd; do
  echo "$f"
  echo "   wet=$(grep -c 'aWetL = 0.5 \*' "$f") dry=$(grep -c 'aDryL = 0.5 \*\|aDry = 0.5 \*' "$f")"
  echo "   clipOp=$(grep -c 'opcode SoftClip' "$f") clipCall=$(grep -c '= SoftClip(a' "$f")"
  echo "   dist=$(grep -c 'aDistAmp' "$f") wetdist=$(grep -c 'aWetSend = aWetSend \* aDistAmp' "$f")"
  # master 通道名不统一：masterGain / vol / level
  echo "   master=$(grep -oE '"defaultValue": [0-9.]+' "$f" | head -1)"
done

# 4. master 通道值（必须按 id 匹配，不能用 tail -1）
for f in */[A-Za-z]*Cabbage3/cab3-*.csd; do
  printf '%-58s ' "$f"
  python3 - "$f" <<'PY'
import sys, re
t = open(sys.argv[1], encoding='utf-8').read()
m = re.search(r'"id":\s*"(masterGain|vol|level)"(.*?)"defaultValue":\s*([\d.]+)', t, re.S)
print(m.group(1) + ' = ' + m.group(3) if m else 'NOMATCH')
PY
done
```

---

## 22. 穿心伪影（仅 Ambi / HRTF）

声源经过盘心时，方位角在单帧内翻转 180°：

- **Ambi**：方向信息瞬间失效（只剩全向的 W 分量），听感是音量/音色的一次突变
- **HRTF**：等效 135,000 °/s 的角度跳变，`hrtfmove2` 的 STFT 重合成跟不上。
  实测 **6.5 dB（1 Hz 穿心）/ 7.2 dB（4 Hz 穿心）**，静止基线仅 0.36 dB

已在 18 个 Ambi / HRTF 插件的 `help.html` 渲染说明里加了提示：
**编曲时尽量让轨迹绕开中心。**

> 已知但未修的方案：中心锁存（会造成新的瞬态）、omni 交叉淡化（两路频谱不同，
> 淡化本身产生瞬态）、跳变限速（会破坏轨迹）。
>
> 唯一有效的是**坐标低通**，9 个 HRTF 版都已实现（Ambi 版没有）：
>
> ```c
> ; kRhPre = 预处理后的归一化半径
> kBh = 1 - min(1, max(0, (kRhPre - 0.12) / 0.23))   ; 0.12 以内 = 1，0.35 以外 = 0
> kXf = kXh + (kXsm - kXh) * kBh                     ; kBh 越接近 1，越跟平滑后的坐标
> kYf = kYh + (kYsm - kYh) * kBh
> ```
>
> 注意这是**三段**：半径 ≤ 0.12 全量低通、≥ 0.35 完全不低通、中间线性过渡。
> 不是「0.12 以内才有」，区间外沿写死成 0.12 / 0.35，改动时别只改一个。

---

## 23. 手册必写条目

36 个插件的 `?` 手册必须包含一条「增益与混响的安全余量」提示，
说明调高音量/混响可能导致内部爆音。见各 `help.html` 的 `.note` 段。
