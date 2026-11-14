# Wildtrace 野痕

**空间音频插件套件 · 9 套算法 × 4 种渲染器 = 36 台插件**

DSP 用 **Csound 7** 写，界面用 **HTML / CSS / JS** 写，插件封装交给 **Cabbage 3**（VS Code 扩展）。

> 本套件是以下两篇论文的配套开源实现：
> **ICSC 2026**（第 8 届国际 Csound 会议）*Immersive Engagement: Building the "Wildtrace" Sonic
> World with AI Assistance*；**CSMT 2026** 长论文《「野痕」系列空间音效插件的算法设计与 AI 协同开发》。
> 两篇 PDF 都在 [`paper/`](./paper/)。

**第一次接触 Csound / Cabbage / VS Code？先读 [`QUICKSTART.md`](./QUICKSTART.md)**
（零基础上手：装环境 → 看到界面 → 编译成插件，约 20 分钟）。

[English](#english) · [中文](#中文)

---

## English

A spatial audio plugin suite built with **Csound 7** and **Cabbage 3**. Nine spatialisation
algorithms are rendered four ways — stereo depth, quadraphonic, binaural HRTF and 4-channel
ambisonics — for 36 plugins in total. Every plugin ships as a complete Cabbage 3 project:
a `.csd` holding the DSP and the parameter contract, plus a hand-written `index.html` UI.

### What's inside

| Renderer | Folder | ID prefix | Channels | Notes |
| --- | --- | --- | --- | --- |
| Depth (stereo) | `stereo wildtrace/` | `C3xx` | 2 in / 2 out | The Y axis is reinterpreted as distance; dry/wet split into `reverbsc` |
| Quad | `quad Doppler/` | `Q3xx` | 4 in / 4 out (via `nchnls`) | Equal-power placement to four corners; **AU only** |
| HRTF | `hrtf wildtrace/` | `H3xx` | 2 in / 2 out | Binaural, `hrtfmove2` + HRTF datasets |
| Ambi | `ambi wildtrace/` | `A3xx` | 4 in / 4 out | First-order B-format, decoded in-plugin to a quad array |

Algorithms: STASIS, ORBITA, SINGULARITY, ZEPHYR, LÉVY-CHASE, LOOM, SWARM-GRAIN, BOIDS, LISSAJOUS.

### Requirements

| Component | Where to get it |
| --- | --- |
| VS Code | https://code.visualstudio.com/ |
| **Csound 7** | https://github.com/csound/csound/releases — Csound 7 only; 6.x cannot run these instruments |
| **Cabbage 3 extension** (`.vsix`) | https://github.com/rorywalsh/vscabbage/releases — pick `macos` / `windows-x64` / `windows-arm` / `linux` |
| Csound language extension (recommended) | https://marketplace.visualstudio.com/items?itemName=kunstmusik.csound-vscode-plugin |

Cabbage 3 is a **VS Code extension**, not a standalone IDE — the Cabbage 2 standalone app is
not involved. Install Csound 7 first, then in VS Code run
**Extensions: Install from VSIX…**, reload the window, click **Run Cabbage** in the status bar
and confirm with **Cabbage: Validate Installation**.

> macOS blocks the unsigned Csound installer: allow it under *System Settings → Privacy & Security*.
> On Windows, choose *More info → Run anyway*; on ARM64 install the ARM64 builds of **both**
> Csound and the extension.

The loose `.csd` files kept beside each `* Cabbage3/` folder are the older Cabbage 2 versions:
they need Csound 6.18 + Cabbage 2.9.0 and are **not** part of the Cabbage 3 build.

### Quick start

No git? Use **Code → Download ZIP** on the GitHub page and unzip it. Otherwise:

```bash
git clone https://github.com/nocalledname/Wildtrace.git
```

1. Open the folder in VS Code.
2. Click **Run Cabbage** in the status bar (without the server the preview panel stays empty).
3. Open `stereo wildtrace/Stasis Cabbage3/cab3-depth-stasis.csd` and press `Cmd/Ctrl + S`.
4. The custom UI loads from `index.html` beside the code; every save rebuilds it.

**These are effects, not instruments** (2 in / 2 out). They do not generate sound: in the
VS Code preview they process live audio input (usually the microphone), and in a DAW they
process the track. Nothing audible from the mic means nothing audible from the plugin.

A step-by-step walkthrough written for people who have never opened VS Code is in
[`QUICKSTART.md`](./QUICKSTART.md) (Chinese).

### Export

Do **not** use the extension's *Export as AUv2 Effect* / *Export as VST3 Effect* commands for a release build: it writes Cabbage's
default widget page into the bundle and overwrites the custom UI. Use the scripted flow instead
(macOS):

```bash
cd "quad Doppler"

# Quadraphonic: AU only (the Cabbage 3 VST3 wrapper cannot aggregate multiple buses)
python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3

# Stereo: AU + VST3
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3

# Build only, do not install
python3 tools/export_plugin.py "Quad-Stasis Cabbage3" --no-install --no-vst3
```

The script reads `pluginId` / `caption` from the CSD, patches the bundle, fixes the binary name
and permissions, updates `Info.plist`, deploys the **complete** runtime (CSD + `index.html` +
all 12 files of `cabbage/` + `help.html` + `gesture*.js` + `mediapipe/`) to
`~/Library/CabbageAudio/<NAME>/`, signs it, and installs to `~/Library/Audio/Plug-Ins/`.

After installing, refresh the AudioComponent cache if your host cannot see the plugin:

```bash
ps aux | grep AudioComponentRegistrar | grep -v grep | awk '{print $2}'   # take the PID
kill <PID>                                                               # macOS restarts it
```

On Windows / Linux, use the extension's export command and then copy the runtime folder
manually — the deploy step is the part that is easy to get wrong.

### Hosts and multichannel

The quadraphonic / ambisonic builds are 4 in / 4 out; the depth and HRTF builds are stereo.
Verified so far (2026-11):

| Host | Format | Notes |
| --- | --- | --- |
| Ableton Live 12 | AU | set the track output to 4.0 |
| **Max 9** | AU | use **`mcs.vst~ 4 4`** — plain `vst~` hosts stereo only |

Minimal Max 9 patch:

```
4 sources → mc.pack~ 4 → mcs.vst~ 4 4 → mc.unpack~ 4 → dac~ 1 2 3 4
```

- The first two arguments are **input / output channel counts** and must be written as `4 4`.
  Loading the plug-in in stereo first and editing the arguments afterwards does not renegotiate
  the format.
- Load the plug-in with a `plug` message, or as the third argument:
  `mcs.vst~ 4 4 Cab3-Quad-Stasis` — the AU's *display* name, **without** `.component`
  (quote it if the name contains spaces).
- Double-clicking the object opens the plug-in's own window (the custom UI), not a parameter panel.
- If the plug-in is missing, rescan AU plug-ins inside Max first.
- Logic / Cubase / Reaper are untested.

A ready-to-open patch is in [`examples/max/`](./examples/max/).

### Documentation

| Document | What it covers |
| --- | --- |
| [`QUICKSTART.md`](./QUICKSTART.md) | **零基础上手（20 分钟）**：装 VS Code / Csound 7 / Cabbage 3 → 看到界面 → 编译进 DAW，含 VS Code 基本操作与排错 |
| [`paper/`](./paper/) | 两篇论文的 PDF：ICSC 2026 短论文（英文 4 页）+ CSMT 2026 长论文（中文 42 页） |
| [`Cabbage3-改造模板.md`](./Cabbage3-改造模板.md) | The development handbook (Chinese, ~5.9k lines): setup §A, parameter contract §2–§5, visual rules §6, self-check §7, export §8, pitfalls §9, quadraphonic §14, gain structure §18 |
| [`quad Doppler/tools/README.md`](./quad%20Doppler/tools/README.md) | `auprobe` / `aurender` and why `auval` fails on 4-channel AUs |
| [`stereo wildtrace/摄像头手势模块.md`](./stereo%20wildtrace/摄像头手势模块.md) | Optional MediaPipe camera / hand-gesture control (12 plugins) |
| https://cabbageaudio.com/docs/ | Official Cabbage 3 docs |
| https://forum.cabbageaudio.com/ | Cabbage forum |

### License

Source code in this repository is released under the **MIT License** (see `LICENSE`).
Note that the Cabbage framework embedded in every **exported** plugin binary is **GPLv3** —
that is a property of Cabbage, not of this repository.

---

## 中文

### 项目简介

Wildtrace 把群体行为、非线性运动、混沌动力学这类复杂系统模型变成空间声像算法。它的设计前提是
反向的：不以「让声音对象在空间里运动」为目的，而是让**空间运动本身成为音效的引擎** ——
多普勒频移、粒子化、合唱都是从轨迹里长出来的。

每台插件都是一份完整的 Cabbage 3 工程：`.csd` 里装着 DSP 和参数契约，`index.html` 是真正的界面。
同一套算法在四种渲染器下各出一版，共 36 台。

### 36 台插件：9 算法 × 4 渲染器

| 算法 | 核心机制 | Depth | Quad | HRTF | Ambi | 自动化参数 |
| --- | --- | --- | --- | --- | --- | --- |
| **STASIS**（立定） | 手工摆位基准；距离场驱动延迟，源静止 | `C3ST` | `Q3ST` | `H3ST` | `A3ST` | 7 |
| **ORBITA**（旋星） | phasor 驱动的椭圆轨道，前后位移产生轻微多普勒 | `C3OB` | `Q3OB` | `H3OB` | `A3OB` | 9 |
| **SINGULARITY**（奇点） | 半径指数收缩/膨胀的对数螺旋 + 内置 `doppler` | `C3SG` | `Q3SG` | `H3SG` | `A3SG` | 14 |
| **ZEPHYR**（沐风） | 平行风道 + 侧向湍流；每次穿越即一个粒子包络 | `C3ZP` | `Q3ZP` | `H3ZP` | `A3ZP` | 13 |
| **LÉVY-CHASE**（驰猎） | 幂律长尾步长 + 边界折返，间歇性多普勒 | `C3LV` | `Q3LV` | `H3LV` | `A3LV` | 11 |
| **LOOM**（针织） | 蛇形（boustrophedon）遍历，每次巡行打散为 N 个点位 | `C3LM` | `Q3LM` | `H3LM` | `A3LM` | 12 |
| **SWARM-GRAIN**（迸粒） | McCurdy 延迟颗粒调度 + 高斯散布 | `C3SW` | `Q3SW` | `H3SW` | `A3SW` | 17 |
| **BOIDS**（群游） | 分离 / 对齐 / 聚合三规则，从鸟跟随头鸟 | `C3BD` | `Q3BD` | `H3BD` | `A3BD` | 23 |
| **LISSAJOUS**（李萨如） | 两轴正交正弦，`ratio` 量化 1/8、相位连续累加，可改用输入音频当坐标 | `C3LJ` | `Q3LJ` | `H3LJ` | `A3LJ` | 15 |

四种渲染器的差别只在**输出级**，前端与参数契约完全一致：

- **Depth**（`C3xx`，2 in / 2 out）：Y 轴由前后声像重释为**空间深度**，干/湿双路，湿声送入 `reverbsc`。
- **Quad**（`Q3xx`，`nchnls = 4`）：以盘心为原点算径向距离，X/Y 等功率分配到四角，`out` 输出四路。
  Cabbage 3 的 VST3 包装器处理不了多总线，**四声道只交付 AU**。
- **HRTF**（`H3xx`，2 in / 2 out）：`hrtfmove2` + HRTF 数据集做双耳渲染。
- **Ambi**（`A3xx`，4 声道）：干声先用 `bformenc1` 编码成一阶 B-format（W/X/Y/Z），
  再用 `bformdec1 2` 在插件内解码到四角阵列，输出 FL/FR/BL/BR 四路。

### 仓库结构

```
Wildtrace/
├── README.md              # 本文件
├── QUICKSTART.md          # 零基础上手：装环境 → 看到界面 → 编译进 DAW
├── LICENSE                # MIT
├── Cabbage3-改造模板.md    # 开发手册（本项目的"唯一权威"）
├── stereo wildtrace/      # Depth 立体声 9 台
├── quad Doppler/          # 四声道 9 台 + tools/（该系列的导出与验收脚本）
├── hrtf wildtrace/        # 双耳 9 台
├── ambi wildtrace/        # Ambisonics 9 台
├── shared/gesture/        # 手势资源唯一副本（MediaPipe，16.8 MB）
├── scripts/               # 仓库级脚本：gesture-assets.py 分发手势资源
├── examples/max/          # Max 9 四声道宿主示例（mcs.vst~ 4 4）
└── paper/                 # 两篇论文 PDF（ICSC 2026 / CSMT 2026）
```

**仓库里没有的东西，以及为什么**：

| 没有 | 原因 |
| --- | --- |
| `build/`（`.component` / `.vst3`） | 每台 4.3 MB × 36 ≈ 155 MB，是导出产物。下载后按 [QUICKSTART.md](./QUICKSTART.md) 第 6 节自己编译 |
| Cabbage 2 时代的旧 `.csd`、`wildtrace beta/` | 需要 Csound 6.18 + Cabbage 2.9.0，与本仓库的 Cabbage 3 工程无关 |
| 演示视频、DAW 工程、PPT / DOCX | 不是源码，体积大 |
| 各工程里的 `mediapipe/` | 只在 `shared/gesture/` 存一份，用 `scripts/gesture-assets.py` 按需复制 |

### 一个 Cabbage 3 工程长什么样

```
<插件名> Cabbage3/
├── cab3-xxx.csd          # <Cabbage> JSON 参数表 + Csound 引擎 —— 参数契约
├── index.html            # 自定义界面（真正的 UI）
├── cabbage.project.json  # {"entry": "index.html"}，告诉扩展加载哪个页面
├── cabbage/              # JS 运行时；导出时必须 12 个文件
├── help.html             # 内置使用手册（顶栏 ? 按钮，iframe 打开）
├── help-ui.js            # 手册模块
├── gesture.js            # 可选：摄像头手势（+ gesture-ui.js）
├── mediapipe/            # 可选：手势资源，用 scripts/gesture-assets.py 生成，不入库
└── build/                # 导出产物，不入库（.gitignore 已排除）
```

**关键认知**：`<Cabbage>` 里的 widget 不是界面，是「参数表 + 窗体描述」；
界面完全由 `index.html` 决定。三者靠 `cabbage.js` 这条消息桥连接。

### 环境与安装

Cabbage 3 和 Cabbage 2 不是一回事：**Cabbage 2 是独立 IDE，Cabbage 3 是 VS Code 扩展**，
引擎也从 Csound 6 换成 **Csound 7**。下面这些一个都不能少：

| 要装什么 | 在哪下载 | 说明 |
| --- | --- | --- |
| **VS Code** | https://code.visualstudio.com/ | 免费，Cabbage 3 以扩展形式装在里面 |
| **Csound 7** | https://github.com/csound/csound/releases | **只能装 7.x**（写作时 7.0.0）。Csound 6.x 跑不了这些工程 |
| **Cabbage 3 扩展** | https://github.com/rorywalsh/vscabbage/releases | 按平台下 `.vsix`：`…-macos` / `…-windows-x64` / `…-windows-arm` / `…-linux` |
| Csound 语言扩展（建议） | https://marketplace.visualstudio.com/items?itemName=kunstmusik.csound-vscode-plugin | 语法高亮、opcode 提示、报错 |
| 官方文档 | https://cabbageaudio.com/docs/ | 控件、自定义界面、导出流程 |
| Cabbage 论坛 | https://forum.cabbageaudio.com/ | 作者 Rory Walsh 常在 |

**装进 VS Code**：

1. 先装 Csound 7。
2. 命令面板 `Cmd/Ctrl + Shift + P` → **Extensions: Install from VSIX…** → 选 `.vsix`。
3. 命令面板 → **Developer: Reload Window**。
4. 点状态栏 **Run Cabbage** 启动服务器（没它预览面板就是空的）。
5. 命令面板 → **Cabbage: Validate Installation** 确认环境通。

平台注意：

- **macOS**：Csound 安装包尚未签名，被拦时去「系统设置 → 隐私与安全性 → 仍要打开」。
- **Windows**：SmartScreen 选「更多信息 → 仍要运行」；ARM64 机器（骁龙 / Copilot+）
  必须装 ARM64 版的 **Csound 和扩展**，两者架构要一致。
- **Linux**：用 `-linux.vsix`。

### 快速开始（在 VS Code 里改界面）

不会用 git 就在 GitHub 页面点 **Code → Download ZIP**，解压后直接用。

1. VS Code **File → Open Folder** 打开仓库，或直接打开单个 `<插件> Cabbage3/` 目录。
2. 状态栏点 **Run Cabbage**。
3. 打开 `cab3-*.csd`，`Cmd/Ctrl + S` 保存。界面按 `form.size` 的尺寸从 `index.html` 加载，
   出现在代码旁边的面板里。
4. 只改界面时动 `index.html` / JS / CSS 即可，保存 `.csd` 触发重载。

> ⚠️ **这 36 台都是效果器（2 in / 2 out），不自己发声。**
> VS Code 预览时处理的是**实时音频输入**（默认是系统默认输入设备，通常是麦克风），
> 所以对着麦克风说话 + 拖界面才能听出效果；处理音乐请按下面「编译导出」装进 DAW。
> 没有 4 声道声卡就先用 `stereo wildtrace/` 那 9 台。
>
> 没声音先查设备：命令面板 → `Cabbage: Select Audio Input Device` / `Select Audio Output Device`。
> 保存后界面空白：命令面板 → `Cabbage: Reset CabbageApp (not vscode) settings file`，再保存。

> 零基础逐步教程（含"命令面板在哪""怎么装 .vsix"）：[`QUICKSTART.md`](./QUICKSTART.md)。

**热更新速查**：

| 改了什么 | 要做什么 |
| --- | --- |
| `index.html` / CSS / JS | `cp index.html ~/Library/CabbageAudio/<名>/` → 重开插件窗口 |
| Csound 代码 | 覆盖运行时里的 `<名>.csd` → 重开插件 |
| `<Cabbage>` 增删参数 | 同上，且**必须重新核对 `PARAM_IDX`**（顺序错了不报错，自动化会绑错参数） |
| `form.size` | 覆盖 CSD 即可，不用重编 `.component`；宿主可能缓存窗口尺寸，需重启宿主 |
| `help.html` / `gesture*.js` / `mediapipe/` | 放回**源工程目录**，导出时自动同步进运行时 |

界面没变化时，重启宿主清 WebView 缓存。

### 编译导出与安装

> ⚠️ **不要用扩展的 `Export as AUv2 Effect` / `Export as VST3 Effect` 直接交付**：它往插件包里写的是扩展内置的默认控件页面，
> 会顶掉你的 `index.html`，而且不带 `help.html` / `mediapipe/` / 图片 / 字体。
> 它只适合快速验证 DSP。

正式流程走 `quad Doppler/tools/export_plugin.py`（macOS）：

```bash
cd "quad Doppler"

# 四声道：只出 AU
python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3

# 立体声：AU + VST3 照旧
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3

# 只构建不装
python3 tools/export_plugin.py "Quad-Stasis Cabbage3" --no-install --no-vst3
```

脚本做的事，和手册 §8.1 完全一致：

1. 从 CSD 的 `<Cabbage>` 读 `pluginId` / `caption`（不靠手抄）。
2. 复制模板 bundle，做**等长**替换（长度不等直接报错）。
3. 二进制改名 + `chmod 755`（模板是 644，缺执行位宿主看不到）。
4. 改 `Info.plist` 的 `CFBundle*` / `AudioComponents.subtype`。
5. **整目录同步**运行时到 `~/Library/CabbageAudio/<NAME>/`：
   CSD（**文件名必须等于二进制名**）+ `index.html` + 完整 `cabbage/` + `help.html` +
   `gesture*.js` + `mediapipe/`。源工程的 `cabbage/` 只有 `cabbage.js` 时，
   脚本会整份换成扩展内置的 12 个文件 —— 这一步漏了就是**参数全丢、四路 RMS = 0**。
6. `codesign -s -` 并校验。
7. 装到 `~/Library/Audio/Plug-Ins/{Components,VST3}`。

**装完刷新注册**（宿主看不到新插件时）：

```bash
ps aux | grep AudioComponentRegistrar | grep -v grep | awk '{print $2}'   # 取 PID
kill <PID>                                                               # macOS 会立刻重启它
```

系统级安装后请删掉用户级副本，否则宿主里会出现两个同名插件。
`export_plugin.py` 会自动在你的 VS Code 扩展目录里找已安装的 Cabbage（
`~/.vscode/extensions/cabbageaudio.vscabbage-*`，取版本最新的那个），**不用改任何路径**；
找不到时会直接告诉你扩展没装好。

> **Windows / Linux**：该脚本是 macOS 专用的（AUv2 / `plutil` / `codesign`）。
> 请用扩展自带的导出命令，再手工把**整份**运行时资源复制到
> `C:/ProgramData/CabbageAudio/<NAME>/`（Windows）或 `~/.config/CabbageAudio/<NAME>/`（Linux）。

### 验收：怎么知道改对了

手册 §7 / §15 的脚本都在 `quad Doppler/tools/`，改完至少要跑这几步
（需要 `python3`、`node` 和能在 PATH 里调到的 `csound`；`auprobe` / `aurender`
要先按 [tools/README](./quad%20Doppler/tools/README.md) 用 `clang` 编出来）：

```bash
cd "quad Doppler"
TOOLS=tools

# 1) 真编译：给 Cabbage 专有 opcode 打桩后用 CLI csound 编译
python3 $TOOLS/check_csd.py "../stereo wildtrace/Stasis Cabbage3/cab3-depth-stasis.csd"

# 2) 前端静态检查：$('id') 引用、电平表 id 成套、canvas 与 form.size 比例
python3 $TOOLS/check_html.py "../stereo wildtrace/Stasis Cabbage3"

# 3) CSD ↔ DSP ↔ HTML 三方交叉：通道声明、PARAM_IDX 顺序、默认值四处一致
python3 $TOOLS/audit.py "Quad-Stasis Cabbage3"

# 4) 导出后验证四声道真的通了（能力表 + 四路 RMS + 报错扫描）
python3 $TOOLS/verify_quad.py

# 5) 边界值压测（会临时改已部署的 CSD，跑完自动还原）
python3 $TOOLS/stress_test.py Q3ST
```

**已经验证过的状态**（截至 2026-11）：

- 36 份 CSD 可用上面第 1 条的命令批量编译（手册 §21 有整库循环的写法）。
- Depth 8 台的 `auval -v aufx <ID> Cabb` 全部 `SUCCEEDED`；Lissajous 是后补的第 9 台，
  `PARAM_IDX` 与 CSD 的 automatable 逐字一致。
- 四声道 9 台：`auval` **必然 FAIL**（包装器把默认总线写死成 2 声道），
  这是正常现象，别拿红灯当失败。判定要用 `auprobe` / `aurender`：
  `in 4, out 4` + `SET OUT 4 ch -> 0 OK` + 四路 RMS 全 > 0 + 日志无 `Excess channels ignored`。
- 四声道 9 台 30 秒长渲染 + 边界参数压测全过。

### 架构与约定（写新插件前必读）

手册 `Cabbage3-改造模板.md` 是唯一权威，这里只列最容易踩的几条。

**① CSD = 参数契约，`index.html` = 界面**

`<Cabbage>` 里的 widget 只负责注册参数与描述窗体，用户看到的全部由 HTML 画。

**② 通道分三种角色**

| 角色 | `automatable` | `visible` | 用途 |
| --- | --- | --- | --- |
| A. 宿主参数 | `true` | 真实参数 `true`，纯 UI 参数 `false` | 暴露给 DAW，可录自动化 |
| B. 内部状态 | `false` | `false` | HTML ↔ Csound 私有同步（如 `box_x`） |
| C. UI 反馈 | `false` | `false` | Csound 单向推给界面（电平表、动画位置） |

B / C 类**不要**设 `automatable: true`，否则会污染 DAW 的参数表。

**③ `PARAM_IDX` 顺序必须与 widget 书写顺序逐字一致**

后端按书写顺序分配 `parameterIndex`，`parameterChange` 只给序号。顺序错了不报错，
表现是「拧 cutoff 却动了 roomSize」。

**④ 五个硬性数值约定**

- `pluginId` 必须**正好 4 个字符**，否则 AU 导出直接失败。
- `form.size = CANVAS × BASE`，两个方向必须同比例；`BASE` 可以大于或小于 1。
- `range` 的 `min` / `max` / `defaultValue` / `increment` / `skew` 五个字段缺一不可。
- 输出级主增益统一 **0–8，默认 2**；通道名只有三个：`masterGain`（7 台）、
  `level`（SwarmGrain）、`vol`（Boids）。
- `html, body` 必须 `overflow: hidden`，缺了会滚 40px，指针坐标随之错位、控件全部失灵。

**⑤ 三段增益结构（36 台统一）**

```
inch → Render UDO（距离低通 → 延迟/多普勒 → 声像 → ×aDistAmp）
          ├── 干声 ×0.5 ─────────────────────────────┐
          └── 湿声 ×0.5 ×aWetSend → tanh → reverbsc ─┤→ ×Master → SoftClip → out
```

干声压到 −6 dB 是为了把工作点留在限幅器的线性区；`aDistAmp` 必须也乘到湿声发送上，
否则远端会出现「只剩混响、音源散不掉」（干湿比可差 20 倍）。混响返回系数 Quad 是 ×0.5，
其余 ×1；`reverbsc` 反馈系数按插件分两档，**不要统一**。

**⑥ 四声道：不写 `channelConfig`，不写 `nchnls_i`**

只写 `nchnls = 4`，让 Csound 令 `nchnls_i = nchnls`。写了 `channelConfig` 反而只出两路
（`2+2` 甚至会段错误）；写了 `nchnls_i = 2` 会让 VST3 在 Live 里加载失败。

**⑦ Csound 7 语法差异**

`outs` → `out`（四声道就是 `out aFL, aFR, aRL, aRR`）、`max_k` → `maxk`、
`x limit (...), ...` → `x = limit(...)`、反三角是 `taninv` / `taninv2`（没有 `atan2`）。

**⑧ 内置手册只能用 iframe**

插件 WebView 是 `choc::ui::WebView`，`window.open()` 会被静默丢弃 —— 那是个死按钮。
`help.html` 一律用内嵌 iframe 打开。

### 已知坑（精选，完整版见手册 §9）

| 现象 | 原因 / 解法 |
| --- | --- |
| 插件打开是默认控件界面 | 用了扩展自带导出，它覆盖了 `index.html`。走 §8.1 流程 |
| `CSD file not found` | 部署后的 CSD 文件名不等于二进制名 |
| 宿主看不到插件 | 二进制权限是 644，需要 755 |
| `pluginId must be exactly 4 characters` | `pluginId` 必须是 4 字符 |
| 宿主里参数全丢、四路 RMS = 0 | 运行时 `cabbage/` 不完整（只有 `cabbage.js`），必须 12 个文件 |
| 拧一个参数却动了另一个 | `PARAM_IDX` 与 widget 顺序不一致 |
| 窗口有滚动条 / 圆变椭圆 | `form.size` 与 `.canvas` 比例不一致 |
| 四声道 `auval` FAIL | 正常。判定用 `auprobe` / `aurender`，见上 |
| 四声道 VST3 加载失败 | Cabbage 3 包装器不支持多总线，四声道只出 AU |
| 摄像头手势开了关不掉 | 采集层与计算层是两套调度，只停 rAF 不会停摄像头 |
| HRTF / Ambi 穿心有爆音 | 声源过盘心时方位角单帧翻转 180°，编曲时让轨迹绕开中心 |

### 内置手册与手势

- 每台插件都带 `help.html`（顶栏 `?` 按钮），包含参数语义、键盘映射、手势用法与增益安全余量提示。
  改界面时别忘了同步更新它。
- **摄像头手势**（MediaPipe）已接入 **12 台**：Stasis / SwarmGrain / Boids × 四个渲染器。
  默认关闭，用户在下拉菜单选 `camera-left` / `camera-right` 才加载。
  实现与踩坑见 [摄像头手势模块.md](./stereo%20wildtrace/摄像头手势模块.md)。

**手势资源要单独启用**（仓库只保留一份，避免多出 200 MB）：

```bash
python3 scripts/gesture-assets.py            # 从 shared/gesture/ 复制到 12 个工程
python3 scripts/gesture-assets.py --check    # 检查缺不缺
python3 scripts/gesture-assets.py --clean    # 用完删掉副本
```

`shared/gesture/` 里是 MediaPipe 的 WASM 运行时与 `hand_landmarker.task` 模型（16.8 MB）。
插件运行时从**自己目录**下的 `mediapipe/` 读取，所以要复制。
没有副本时插件其余功能完全正常，只有手势菜单静默失效；
**导出前要先跑这一步**，否则部署到 `~/Library/CabbageAudio/<NAME>/` 的运行时里也不会带它。

### 文档索引

| 文档 | 内容 |
| --- | --- |
| [`QUICKSTART.md`](./QUICKSTART.md) | **零基础上手（20 分钟）**：装 VS Code / Csound 7 / Cabbage 3 → 看到界面 → 编译进 DAW，含 VS Code 基本操作与排错 |
| [`paper/`](./paper/) | 两篇论文的 PDF：ICSC 2026 短论文（英文 4 页）+ CSMT 2026 长论文（中文 42 页） |
| [`Cabbage3-改造模板.md`](./Cabbage3-改造模板.md) | **开发手册**。§A 上手准备 / §0–§1 架构与目录 / §2–§5 后端与前端骨架 / §6 视觉规范 / §7 自检 / §8 导出 / §9 已知坑 / §10 迁移顺序 / §11 热更新 / §12 参数契约 / §14 四声道 / §15 验收 / §16 距离场辅助线 / §17 头部图标 / §18 增益结构 |
| [`examples/max/`](./examples/max/) | Max 9 四声道宿主示例 patch 与 `mcs.vst~` / `vst~` 的区别 |
| [`quad Doppler/tools/README.md`](./quad%20Doppler/tools/README.md) | `auprobe` / `aurender` 的构建与判据，四声道 `auval` 为什么必然失败 |
| [`stereo wildtrace/摄像头手势模块.md`](./stereo%20wildtrace/摄像头手势模块.md) | 手势模块的映射规则、生命周期、接入方式 |

### 使用建议

- 四声道版需要 4 声道音频接口，并在宿主里配 4.0 总线。**已验证的宿主（2026-11）**：
  Ableton Live 12（AU，轨道输出配 4.0）、**Max 9（AU，必须用 `mcs.vst~ 4 4`，
  普通 `vst~` 只有立体声）**；Logic / Cubase / Reaper 未测试。

  Max 里的最小接法：

  ```
  4 路信号 → mc.pack~ 4 → mcs.vst~ 4 4 → mc.unpack~ 4 → dac~ 1 2 3 4
  ```

  - 前两个参数是**输入/输出声道数**，必须写 `4 4`；先按立体声装载再改参数，
    不会重新协商声道格式。
  - 装载插件用 `plug` 消息，或直接写第 3 个参数：`mcs.vst~ 4 4 Cab3-Quad-Stasis`
    （AU 的**显示名**，不带 `.component`；名字有空格要加引号）。
  - 双击对象打开的是**插件自己的窗口**（自定义界面），不是参数面板。
  - 列表里找不到插件时，先在 Max 里重扫一遍 AU。

  可直接打开的示例 patch：[`examples/max/mcs-vst-4ch.maxpat`](./examples/max/mcs-vst-4ch.maxpat)。
- 高粒子 / 高密度参数会升高 CPU。参考实测（Apple M2，620×760 @ 60 fps）：
  Boids 前端 15.6% + 后端 3.1%（单核）。
- 界面支持缩放：右下角三角拖动，双击复位；旋钮单击可输入数值，双击归位。缩放到 60–80% 时
  参数名仍应是纯白——灰字在那个尺寸下读不出来。

### 许可证

本仓库源码以 **MIT License** 发布，版权人 杨昊昆（见 [`LICENSE`](./LICENSE)）。

> 注意：**导出的插件二进制里内嵌的 Cabbage 框架是 GPLv3**。这是 Cabbage 本身的授权方式，
> 与本仓库源码的许可证无关。商用或需要保护 Csound 代码时，请联系 Cabbage 作者。

### 引用

如您在学术工作中使用 Wildtrace，请引用：

> Immersive Engagement: Building the "Wildtrace" Sonic World with AI Assistance.
> In: *Proceedings of the 8th International Csound Conference (ICSC 2026)*, Trapani, Sicily.
>
> 杨昊昆, 杨万钧. 「野痕」系列空间音效插件的算法设计与 AI 协同开发. CSMT 2026.

论文原文：

- [`paper/ICSC2026-Wildtrace.pdf`](./paper/ICSC2026-Wildtrace.pdf) —— ICSC 2026，英文，4 页
- [`paper/CSMT2026-Wildtrace-long-zh.pdf`](./paper/CSMT2026-Wildtrace-long-zh.pdf) —— CSMT 2026，中文，42 页
