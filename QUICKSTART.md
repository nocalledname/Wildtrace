# Quick Start · 零基础上手

**假设你从没用过 VS Code、没写过一行代码、也没装过 Csound。**
按顺序做完大约 20 分钟，你会看到第一个插件界面，并且能把它编译成 DAW 里能用的插件。

遇到卡住的地方，先跳到 [第 7 节 常见问题](#7-常见问题)。

---

## 0. 先认识 4 个词

| 词 | 一句话解释 |
|---|---|
| **Csound** | 一门专门写声音合成的编程语言。本项目的所有「声音算法」都是 Csound 代码 |
| **Cabbage** | 把 Csound 代码打包成 VST / AU 插件、并给它配一个界面的工具。Cabbage 3 是 **VS Code 的扩展**，不是独立软件 |
| **VS Code** | 微软的免费编辑器。在这里写代码、预览插件界面、导出插件 |
| **`.csd` 文件** | 一个文本文件，里面装着某台插件的全部内容：`<Cabbage>` 参数表 + Csound 程序 |

> ⚠️ 最容易混的一点：**Cabbage 2 是独立软件，Cabbage 3 是 VS Code 扩展**。
> 本项目全部是 Cabbage 3 + Csound 7，不要去找 Cabbage 2 的下载。

一个插件工程大概长这样，**你只需要关心前两个文件**：

```
Stasis Cabbage3/
├── cab3-depth-stasis.csd   ← 声音算法 + 参数表（Csound 代码）
├── index.html              ← 你看到的界面（网页）
├── cabbage.project.json    ← 一行配置，别动
├── cabbage/                ← 运行库，别动
├── help.html               ← 内置说明书
└── build/                  ← 编译出来的插件（自动生成）
```

---

## 1. 装 3 样东西（一次性，约 10 分钟）

### 1.1 VS Code

到 <https://code.visualstudio.com/> 下载，双击安装，一路「下一步」。
装完打开它，会看到一个欢迎页面 —— 这就是之后工作的地方。

### 1.2 Csound 7

到 <https://github.com/csound/csound/releases> 找最新的 **7.x** 版本
（写作时是 `7.0.0`，2026-10），在页面底部的 Assets 里选：

| 你的电脑 | 下载这个 |
|---|---|
| Mac（Apple 芯片或 Intel） | `csound-macos-7.0.0.zip` |
| Windows 普通电脑 | `csound-windows-7.0.0.zip`（或 `csound-windows-i386-installer-7.0.0.zip`） |
| Windows ARM 笔记本 | `csound-windows-arm64-installer-7.0.0.zip` |
| Linux | `csound-linux-minimal-x86_64-7.0.0.zip` |

**必须是 7.x**，6.x 打不开本项目的工程。

> **macOS 提示"无法打开，因为无法验证开发者"**：
> 打开「系统设置 → 隐私与安全性」，滚到最下面点「仍要打开」。
> **Windows 提示"Windows 已保护你的电脑"**：点「更多信息」→「仍要运行」。

装完可以验证一下：打开终端（VS Code 里按 `` Ctrl + ` ``），输入

```bash
csound --version
```

看到 `Csound version 7.x` 就对了。

> 如果显示的是 `6.18` 之类：说明终端里还有一个旧版 Csound（常见于以前装过 Cabbage 2）。
> Cabbage 3 用的是安装包装进去的 `CsoundLib64.framework`（7.0），旧 CLI 不一定影响它。
> 真正的判据是第 1.3 步的 **Cabbage: Validate Installation**。

### 1.3 Cabbage 3 扩展

到 <https://github.com/rorywalsh/vscabbage/releases> 下载**对应你系统**的 `.vsix` 文件：

| 你的电脑 | 下载哪个 |
|---|---|
| Mac（Apple 芯片 M1/M2/M3/M4，或 Intel） | `…-macos.vsix` |
| Windows 普通电脑 | `…-windows-x64.vsix` |
| Windows ARM 笔记本（骁龙 / Copilot+） | `…-windows-arm.vsix` |
| Linux | `…-linux.vsix` |

> `.vsix` 就是「VS Code 扩展的安装包」，不是双击安装的，要按下面步骤装进 VS Code。
> **Windows ARM 的用户注意**：Csound 和扩展必须都是 ARM 版，架构不一致会无法运行。

在 VS Code 里装它：

1. 按 `Cmd + Shift + P`（Mac）或 `Ctrl + Shift + P`（Windows / Linux）。
   屏幕顶部会弹出一个输入框 —— 这就是**命令面板**，后面所有「运行某命令」都是在这里。
2. 输入 `Install from VSIX`，选中 **Extensions: Install from VSIX…**，回车。
3. 在弹出的文件选择框里找到刚下载的 `.vsix`，打开。
4. 右下角提示安装完成后，再按 `Cmd/Ctrl + Shift + P`，输入 `Reload Window`，
   选 **Developer: Reload Window**，回车。窗口会刷新一下。
5. 再开一次命令面板，输入 `Cabbage: Validate Installation`，回车。
   如果显示一切正常，环境就装好了。

> 强烈建议再装一个 **Csound 语言扩展**：在 VS Code 左侧「扩展」图标里搜 `Csound`，
> 装 `Csound` 那个（作者 kunstmusik）。它会给 Csound 代码上色、报错。不装也能用。

---

## 2. 把代码拿到本地

**方法 A：不用 git（推荐给第一次用的人）**

1. 打开 <https://github.com/nocalledname/Wildtrace>
2. 点绿色的 **Code** 按钮 → **Download ZIP**
3. 解压到一个你记得住的位置，例如「桌面」。解压后文件夹叫 `Wildtrace-main`，
   可以改名成 `Wildtrace`（**不要放在中文路径或 OneDrive 同步目录里**，容易出问题）

**方法 B：会用 git 的话**

```bash
git clone https://github.com/nocalledname/Wildtrace.git
```

---

## 3. 跑起来（看到界面）

1. VS Code 菜单 **File → Open Folder…**（Mac 是 **File → Open…**），选中刚才那个
   `Wildtrace` 文件夹，点「打开」。
   > 如果问你「是否信任此文件夹的作者」，选 **Yes, I trust the authors**。
2. 看窗口**最下面一条状态栏**，右下角附近有一个 **Run Cabbage** 按钮，点它。
   状态栏会显示 Cabbage 服务器已启动。
   > 找不到按钮？按 `Cmd/Ctrl + Shift + P`，输入 `Start Cabbage Server`，选 **Cabbage: Start Cabbage Server** 也行。
   > **必须先点这个**，否则最后保存时不会出现界面。
3. 在左侧文件树里依次展开 `stereo wildtrace` → `Stasis Cabbage3`，
   双击打开 `cab3-depth-stasis.csd`。
4. 按 `Cmd + S`（Mac）或 `Ctrl + S`（Windows）保存。
   插件界面会出现在代码旁边，可以拖动中央的圆点、拧旋钮。

> **界面没出现 / 一片空白？** 命令面板 → `Cabbage: Reset CabbageApp (not vscode) settings file`，
> 然后再按一次保存。这是第一次使用最常见的坑。

---

## 4. 为什么没有声音？（重要）

**这 36 台都是「效果器」（2 in / 2 out），不是合成器。**
它们不自己发声，而是处理**送进来的音频**：你给一段鼓，它把鼓在空间里甩来甩去。

所以预览时 Cabbage 会把**你的音频输入设备**（默认是系统默认输入设备，通常是麦克风）送进插件：

- 想快速验证：对着麦克风说话 / 敲桌子，同时拖动界面里的圆点，能听出空间变化就对了。
- 想让它们处理音乐：**导出成插件，放进 DAW**（第 6 节）。
- 四声道版本还需要 4 声道声卡；没有的话先用立体声（`stereo wildtrace/`）那 9 台。

**还是没声音？** 检查 Cabbage 用的设备。打开命令面板（`Cmd/Ctrl + Shift + P`），
依次输入下面这 4 条命令并回车（**是在 VS Code 顶部的命令面板里，不是终端**）：

| 命令 | 选什么 |
|---|---|
| `Cabbage: Select Audio Driver` | Mac 选 CoreAudio；Windows 选 WASAPI 或 ASIO |
| `Cabbage: Select Audio Input Device` | 你真在用的麦克风 / 声卡输入 |
| `Cabbage: Select Audio Output Device` | 你正在听的耳机 / 音箱 |
| `Cabbage: Select Sampling Rate` | 首选 48000 |

选完再按一次保存（`Cmd/Ctrl + S`）让插件重启。若输入设备选的是"无"，插件收到的是静音。

---

## 5. 改它（改坏了也不用怕）

- **只想改外观**：编辑 `index.html`（网页 / CSS / JS）。保存 `.csd` 就会重载界面。
  > 在 VS Code 里打开 `index.html` 后，按 `Cmd/Ctrl + K` 再按 `V`，可以在旁边看渲染效果。
- **想改声音**：编辑 `.csd` 里的 Csound 代码；参数范围在同一个文件顶部的 `<Cabbage>` JSON 段。
- **改坏了怎么办**：重新下载 ZIP 覆盖，或者删掉改动重新解压。建议先复制一份工程目录再动手。

> 有一个坑必须知道：`.csd` 里参数的**书写顺序**和 `index.html` 里 `PARAM_IDX` 数组的顺序必须
> 完全一致。顺序错了不会报错，但 DAW 里拧 A 旋钮会动了 B 参数。详见
> [Cabbage3-改造模板.md](./Cabbage3-改造模板.md) §5.3。

---

## 6. 编译成插件，装进 DAW

先明确两种格式：

- **VST3**：Windows / macOS 通用，Ableton、Cubase、Reaper、Logic（部分）都认。
- **AU（Audio Unit）**：只有 macOS 用，Logic / GarageBand 必须用它。

### 6.1 最快试一下（界面会变成默认样式）

命令面板 → `Cabbage: Export as VST3 Effect`（macOS 也可以用 `Cabbage: Export as AUv2 Effect`），
选一个输出文件夹。

> 这条命令会用 Cabbage 的**默认控件界面**，覆盖掉作者设计的界面，也不会带说明书。
> 仅用于验证能出声。

### 6.2 正确做法：保留自定义界面（目前只有 macOS 脚本）

```bash
cd "quad Doppler"

# 想让插件带摄像头手势，先跑这一行（否则手势菜单会失效）
cd .. && python3 scripts/gesture-assets.py && cd "quad Doppler"

# 四声道 9 台：只出 AU
python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3

# 立体声 9 台：AU + VST3
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3

# 只编译、先不安装
python3 tools/export_plugin.py "Quad-Stasis Cabbage3" --no-install --no-vst3
```

- 命令要在 VS Code 的**终端**里执行：菜单 **Terminal → New Terminal**（Mac 也可以按 `` Ctrl + ` ``）。
- 路径里有空格，所以上面都带引号，**别把引号删掉**。
- Windows 用户把 `python3` 换成 `python`。
- 脚本会自动找到你装的 Cabbage 扩展，不用改任何路径。

编译产物与安装位置：

| 东西 | 位置 |
|---|---|
| `.component` / `.vst3`（插件本体） | 工程目录下的 `build/`，脚本会顺手装到 `~/Library/Audio/Plug-Ins/` |
| 运行时资源（CSD + 界面 + 全部依赖） | `~/Library/CabbageAudio/<插件名>/` |

### 6.3 在 DAW 里找到它

1. 重启 DAW（或让它重新扫描插件）。
2. 新建一条音频轨，在插件列表里搜 `Cab3-`，例如 `Cab3-Depth-Stasis`、`Cab3-Quad-Boids`。
3. **四声道插件**：还要在 DAW 里把这条轨的输出配置成 4.0（Ableton：轨道输出选 `Ext. Out`，
   并确保音频接口有 4 个输出）。

> **装完 DAW 里还是找不到？** 说明系统缓存没刷新。在终端执行：
>
> ```bash
> ps aux | grep AudioComponentRegistrar | grep -v grep | awk '{print $2}'
> kill 上面查到的那个数字
> ```
>
> 然后重启 DAW。

#### 用 Max 的看这里

Max 里**不要用普通的 `vst~`** —— 它只有立体声，四声道插件会被压成 2 路。要用 **`mcs.vst~`**（Max 9 起提供）：

```
4 路信号 → mc.pack~ 4 → mcs.vst~ 4 4 → mc.unpack~ 4 → dac~ 1 2 3 4
```

- 前两个参数是**输入/输出声道数**，必须写 `4 4`。
- 第 3 个参数写 AU 的**显示名**（不带 `.component`）：`mcs.vst~ 4 4 Cab3-Quad-Stasis`。
- 双击对象打开的是插件自己的界面。
- Max 菜单 **Options → Audio Status** 里把输出声道数设成 4。

示例 patch：[`examples/max/mcs-vst-4ch.maxpat`](./examples/max/mcs-vst-4ch.maxpat)（打开即可用）。

### 6.4 Windows / Linux 怎么办

上面的脚本是 macOS 专用的（用了 AU、`codesign`）。Windows / Linux 请：

1. 用命令面板的 `Cabbage: Export as VST3 Effect` 导出；
2. 手动把**整个工程目录**里的这些文件复制到运行时目录：
   `cab3-xxx.csd`、`index.html`、`cabbage/`（整个文件夹，12 个文件）、`help.html`、
   `help-ui.js`、`cabbage.css`，以及 `gesture*.js`（若使用手势）。

   目标位置：
   - Windows：`C:/ProgramData/CabbageAudio/<插件名>/`
   - Linux：`~/.config/CabbageAudio/<插件名>/`

   其中 `.csd` 的**文件名必须改成和插件同名**，例如 `Cab3-Depth-Stasis.csd`。

---

## 7. 常见问题

### 环境 / VS Code

| 现象 | 怎么办 |
|---|---|
| 找不到状态栏的 `Run Cabbage` | 命令面板输入 `Run Cabbage` 直接运行；或检查扩展是否装成功（左侧扩展图标里能看到 Cabbage） |
| 命令面板调不出来 | Mac 是 `Cmd + Shift + P`；Windows/Linux 是 `Ctrl + Shift + P`。不是 `Cmd + P` |
| 终端里 `python3` 不存在（Windows） | 改用 `python` |
| 终端里 `csound` 找不到 | Csound 没装好，或没加进 PATH。重装一次 Csound，安装时勾选「Add to PATH」 |
| 提示 `无法验证开发者` | macOS 到「隐私与安全性」里点「仍要打开」 |
| 打开文件夹后满屏红波浪线 | 正常，缺语言扩展而已。装 Csound 扩展即可 |

### 编译 / 插件

| 现象 | 原因 / 解法 |
|---|---|
| 保存后界面是空白 | 命令面板 → `Cabbage: Reset CabbageApp (not vscode) settings file`，再保存 |
| 有界面但没声音 | 它们是效果器，需要输入音频。先用 `Cabbage: Select Audio Input Device` 选对麦克风，对着它说话试试；或直接装进 DAW |
| 控件拖了没反应 | 看命令面板里的 developer tools 面板的 Console；多半是 `index.html` 改出了语法错误 |
| 插件打开是默认灰色界面 | 用了 6.1 的快速导出。改用 6.2 的脚本 |
| DAW 里找不到插件 | 刷新系统缓存（6.3 的 `kill` 命令），重启 DAW |
| DAW 里参数全丢 / 完全没声 | 运行时目录里的 `cabbage/` 不完整，必须 12 个文件 |
| 拧一个旋钮动了另一个参数 | `PARAM_IDX` 顺序和 `.csd` 里的参数顺序不一致 |
| 四声道插件 `auval` 报 FAIL | 正常现象，不影响在 DAW 里使用；判定方法见 `quad Doppler/tools/README.md` |
| 四声道 VST3 打不开 | Cabbage 3 的 VST3 不支持多总线，四声道只交付 AU |
| Max 里只有 2 路出声 | 用了 `vst~`。改用 `mcs.vst~ 4 4`（需 Max 9+），见 6.3 |

### 还是不行

- Cabbage 官方文档：<https://cabbageaudio.com/docs/>
- 官方论坛（作者 Rory Walsh 常在）：<https://forum.cabbageaudio.com/>
- 提问时请附上：系统版本、Csound 版本、`Cabbage: Validate Installation` 的结果、报错截图

---

## 8. 接下来读什么

| 想做的事 | 读这个 |
|---|---|
| 系统学 Cabbage 3 开发（参数、界面、缩放、导出、踩坑） | [Cabbage3-改造模板.md](./Cabbage3-改造模板.md)，从 **§A 上手准备** 开始 |
| 了解算法为什么这么设计 | [`paper/`](./paper/) 两篇论文 |
| 看每台插件的完整说明书 | 插件界面右上角的 `?` 按钮（就是 `help.html`） |
| 修改后怎么自检 | [Cabbage3-改造模板.md](./Cabbage3-改造模板.md) §7 和 §15 |
