# tools/ — 多声道验证工具

Cabbage 3 的 AUv2 包装器把**默认**总线格式固定成 2 声道，所以 `auval` 对四声道插件必然报
`Default Format of unit does not match reported Channel handling capabilities`。
但宿主（Live / Reaper / Logic）会主动按 `SupportedNumChannels` 配置格式，所以
**auval 失败 ≠ 插件不能用**。

这两个工具直接调 AudioUnit API，不看 auval 的脸色。

## 构建

```bash
clang -o auprobe  auprobe.c  -framework AudioToolbox -framework AudioUnit -framework CoreAudio
clang -o aurender aurender.c -framework AudioToolbox -framework AudioUnit -framework CoreAudio -lm
```

## `auprobe` — 查能力、试配置

```bash
./auprobe Q3ST 4
```

期望输出：

```
caps[0]: in 4, out 4          ← 关键：宿主就是看这个决定给几路
default OUT bus0: 2 ch        ← 包装器写死的默认值（auval 因此报错）
SET OUT 4 ch -> 0 OK          ← 宿主配置时能成功
  readback: 4 ch
```

只要 `caps` 的 `out` 是 4 且 `SET OUT 4 ch` 返回 OK，宿主就能拿到四声道。

> `in` 也是 4（不是 2），因为 CSD **只写 `nchnls = 4`、不写 `nchnls_i`**（模板 §9.0），
> Csound 令 `nchnls_i = nchnls`。DSP 里 `inch 1, 2` 仍只读前两路，多余输入不影响声音。
> 早先写过 `nchnls_i = 2`，`caps` 就是 `in 2, out 4` —— 那是 Live 里 VST3 加载失败的直接原因。

## `aurender` — 真渲染一遍

```bash
./aurender Q3ST 4            # quad：4 出，输入自动按 4
./aurender C3ST 2 1 2        # depth：2 出 2 入
#             ↑ID  ↑出 ↑秒数 ↑输入声道
```

> 第 4 个参数是**输入声道**，默认 `outs>=4 ? 4 : 2`。
> depth 版是 2 in / 2 out，不给这个参数会报 `SET IN 4 ch FAILED (-10868)`。

把 x/y 参数设到三个位置各渲染一段，打印四路 RMS：

```
左前  x=0.05 y=0.95
   FL   = 0.5365      ← 主导
   FR   = 0.0566
   RL   = 0.0954
   RR   = 0.0427
右后  x=0.95 y=0.05
   RR   = 0.4563      ← 主导
正中  x=0.50 y=0.50
   四路均 ≈ 0.25       ← 均衡
```

声像分布正确 = DSP 四声道链路真的通了（不是只有声明）。

## 给 9 台 quad 插件用

把 `<subtype>` 换成各自的 4 字符 ID 即可（见 §8.0 的 ID 表）。

## 注意

- `OSType` 是**大端**四字符码。C 里要用字节移位拼，不能 `memcpy`，
  否则 x86/ARM 上会得到反序值，`AudioComponentFindNext` 永远找不到组件。
- 组件刚重新安装后，记得重启 `AudioComponentRegistrar`，否则新二进制不会被加载：

  ```bash
  for p in $(pgrep -f AudioComponentRegistrar); do kill "$p"; done; sleep 5
  ```

---

# 批次改造脚本（stereo → quad）

这三支脚本把「立体声 C3 插件 → 四声道 C3 插件」的机械动作固定下来，
每条规则都带**断言**：模式没命中就直接报错，不会静默生成半成品。

```bash
python3 tools/make_quad_csd.py <源 CSD> <目标 CSD> <pluginId> "<Caption>"
python3 tools/quadify_html.py "<插件目录>" <key>      # 改 markup / CSS / 顶栏 tag
python3 tools/finish_html.py <key> [key ...]          # 改电平表 JS（4 路）
```

key 见 `quadify_html.py` / `finish_html.py` 里的 `CFG`（orbita / levy / loom / zephyr /
singularity / swarmgrain / boids / lissajous）。

## 导出与验证（改完 → 装机）

```bash
# 四声道：只出 AU。Cabbage 3 的 VST3 包装器处理不了多总线（模板 §9.1 末「决定」）
python3 tools/export_plugin.py Quad-*Cabbage3 --no-vst3

# 立体声（2 in 2 out）：AU + VST3 照旧，不加 --no-vst3
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3

python3 tools/verify_quad.py                          # 一次验 9 台：能力表 + 四路 RMS + 报错扫描
```

`export_plugin.py` 从 CSD 里读 `pluginId` / `caption`，不靠手抄。
注意 **VST3 模板只有 `Cp47` 这一组补丁**（AU 是三组：另两个 CLAP/NSView 字符串在 VST3 模板里不存在），
照抄 AU 会在第一组断言失败；`Cp47` 在两个模板里都是 **3 次**，脚本里写 `== 3`。

落点：

```
<插件目录>/build/Cab3-Quad-X.component
<插件目录>/build/Cab3-Quad-X.vst3
~/Library/Audio/Plug-Ins/Components/
~/Library/Audio/Plug-Ins/VST3/          ← 四声道不装（--no-vst3）
~/Library/CabbageAudio/Cab3-Quad-X/     ← 整目录同步（跳过 build/）
                                          Cab3-Quad-X.csd / index.html / cabbage.project.json /
                                          cabbage/ / cabbage.css / help.html / gesture*.js / mediapipe/
```

`verify_quad.py` 的判定（缺一条算失败）：

1. `auprobe` 报 `caps[0]: in 4, out 4` + `SET OUT 4 ch -> 0 OK` + `readback: 4 ch`
   （2026-11-03 去掉 `nchnls_i` 之后输入也是 4；此前是 `in 2, out 4`）
2. `aurender` 四路 RMS 全 > 0
3. 日志无 `COMPILE ERROR` / `CSD file not found` / `Excess channels ignored`

`auval -v aufx <ID> Cabb` 对四声道插件**必然 FAIL**（默认总线被强制成 2ch），
只看「CSD 读到了 + Csound 编译 done」，别拿 SUCCEEDED 当判据。

## 两支自检脚本（改完必跑）

```bash
python3 tools/check_csd.py  Quad-*/cab3-quad-*.csd    # 打桩后真编译 orchestra
python3 tools/check_html.py *Cabbage3/                # id 引用 / 表 id 成套 / 尺寸比例 / METER_H
```

`check_csd.py` 用桩函数替代 `cabbageGetValue` / `cabbageSetValue` / `cabbageSet`，
再补一个 Csound 7 才有的 `maxk(a,k,i)` 重载桩，然后用 **PATH 里的 `csound`** 编译。

> ⚠️ 它用的是终端里的 `csound` 命令，不一定是 Cabbage 自己的 Csound 7。
> 若 `csound --version` 显示 6.x，检查结果只能当参考 ——
> 真实运行环境是 Cabbage 3 内嵌的 Csound 7。
本机 CLI 没有可用音频设备，解析完会卡在音频初始化，所以只取前 6 秒输出判断语法。

## 每台还要**人工**确认的三件事（脚本管不到）

1. **instr 1 尾部的立体声输出段**要换成总线发送 + 独立 `instr 2`（混响 / outq / 四表）。
2. **主增益接法不同**：`masterGain`（6 台）／`vol`（Boids）／`level`（SwarmGrain）；
   Singularity 的 master 在 instr 1 里就已经乘过，instr 2 不能再乘。
3. **排版**：电平表从 1 只变 2 只叠放，必须按各自 pad / 控制台的竖直空间重新算柱高
   （本批实测：Orbita 72、levy 70、Singularity 172、SwarmGrain 52、Boids 148，其余保持原高）。

---

# 全面体检（2026-11-02）

四台以上工具，按「静态 → 活体 → 压力」三层递进。**静态查不出的问题才需要活体，活体查不出的才需要压测。**

```bash
python3 tools/audit.py                 # 1. CSD ↔ DSP ↔ HTML 三方交叉核对
python3 tools/check_params_live.py     # 2. 问已安装的 AU 要参数表，与 HTML 逐项比对
python3 tools/stress_test.py           # 3. 参数推到量程边界，抓 NaN / 爆值 / 越界
python3 tools/verify_quad.py           # 4. 四声道全链路（能力表 + 四路 RMS）
```

## audit.py 查什么

| 类别 | 判据 |
|---|---|
| A 通道契约 | DSP 里 `cabbageGetValue` / `cabbageSetValue` 用到的通道必须在 widget 表里声明（否则静默返回 0） |
| B 顺序契约 | `PARAM_IDX` 必须等于 widget 书写顺序 |
| C 默认值契约 | CSD `defaultValue` ↔ HTML `P.def` ↔ `WET_DEF` ↔ 写死的 `<input value>` ↔ JS 初值 |
| D 四声道 | `nchnls=4` / **不写 `nchnls_i`** / 无 `channelConfig` / 输出调用 4 参数 / 输出乐器在 score 里启动 |
| E 前端 | JS 引用的 id 必须存在（含 JS 动态创建的）、四表 id 成套、`METER_H` = 生效 `.bar` 高度、`--lvl` 必须有人赋值 |

> 写这个脚本本身踩了两个坑，改规则时注意：
> 1. `channelConfig` 只能查 `<Cabbage>` 段 —— 注释里提到它不算错。
> 2. 输出乐器**不要写死 instr 2**：SwarmGrain 用 instr 3。

## 四支脚本都只认四声道契约

`audit.py` / `check_params_live.py` / `stress_test.py` / `verify_quad.py` 的检查项写死了
**4 in / 4 out + 四只表 + `outFL..RR`**。拿它们跑 depth（2 in / 2 out）工程会报约 23 条假问题。
depth 那套只用 `check_csd.py` + `check_html.py` —— 后者按页面实际 `mtr*` 推断通道数，两套都能跑。

## check_params_live.py 为什么必须做

只读源码永远查不出「宿主里拧 cutoff 却动了 roomSize」。这个脚本解析
`auprobe` 启动时打印的 `Added parameter ... parameterIndex N`，拿到**运行时**注册顺序，
再和 `PARAM_IDX` / CSD 比对；同时校验 min/max/default 三方一致、隐藏通道是否都注册了。

## stress_test.py 的三条纪律

1. **改的是已部署的 CSD**（`~/Library/CabbageAudio/<NAME>/`），不是源码 —— 宿主读的是前者。
2. **必须按 sha1 精确还原**，脚本里用 `try/finally` + 断言兜底。忘了还原，下次打开插件默认值就变了。
3. **一次只改一组参数**，否则分不清是谁把声音掐掉的。

## 本轮查出并修掉的问题

| # | 插件 | 问题 | 性质 |
|---|---|---|---|
| 0 | **6 台**（Stasis / SwarmGrain / Boids 的 depth + quad） | `deploy_runtime()` 按**固定清单**重建运行时目录，把源工程里的 `help.html` / `help-ui.js` / `gesture*.js` / `mediapipe/` 删掉 | **部署缺陷**：宿主里 `?` 与 CAMERA 静默失效（`catch` 只 `console.warn`）。已改成「源目录整份同步，跳过 `build/`」，6 台全部重新导出复验 |
| 0b | **4 台**（Stasis / SwarmGrain ×depth+quad） | 改成整目录同步后，源工程里那份**只有 `cabbage.js`** 的 `cabbage/` 被原样带过去 → Cabbage 判定不是 C3 工程，退回 C2 解析：参数全消失、**四路 RMS 全 0**，宿主照样能加载 | **回归**，被 `verify_quad.py` 抓住（RMS `0.0000/0.0000/0.0000/0.0000`）。现在按「有没有 `main.js`」判完整，不完整就整份换成扩展内置的 12 文件运行时，并断言 `main.js` 存在。**部署目录的 `cabbage/` 必须是 12 个文件** |
| 1 | Stasis | `cutoff` 默认值 CSD/HTML 都是 **6000**，全系列其余 7 台是 16000 | 预设不一致，双版本听感不同 |
| 2 | Stasis | CSS 用 `var(--lvl)` 驱动顶部光晕，但 JS **从不赋值** → 光晕恒定 `.40` | 死代码，动态效果完全失效 |
| 3 | levy | `sr = 44100`，其余 7 台 `48000` | 采样率不一致 |
| 4 | Boids | `id="padGlow"` 用了两次（渐变 + 圆），`url(#padGlow)` 行为不确定 | 重复 id |
| 5 | 全部 9 台 | 用 `outq`，Csound 7 报 `opcode outq is deprecated` | 弃用告警，已改 `out` 四参数 |

### 顺带修掉的两个**工具**自身的坑（否则数据是假的）

| 工具 | 坑 | 后果 |
|---|---|---|
| `aurender.c` | 按**参数序号** 0/1 设 `x`/`y` | Singularity 参数 0 是 `fallTime`，等于每次渲染都把 fallTime 覆盖成 0.05/0.95 —— 之前那组数据全是假的。已改成按**名字**查参数序号（`kAudioUnitProperty_ParameterList` + `ParameterInfo`） |
| `stress_test.py` | 拿 `aurender` 的「正中」RMS 判静音 | 那些插件没有 x/y，三次位置结果相同；现在会打印「位置由 DSP 自己运动」，并取三次峰值的最大值 |

## 压测结论

- **无 NaN、无爆值、无 `samples out of range`**，30 秒长渲染四路 RMS 全部稳定。
- **`masterGain = 8` 时峰值会到 1.0~1.9**（Orbita 1.37、loom 1.90、zephyr 1.22）。
  这是设计使然（0~8 增益直接相乘，宿主里靠后级限幅），不是 bug；
  但如果要在插件内防削顶，得在 `out` 之前加一路 `tanh` 或限幅 —— **目前没加，保持与立体声版一致**。
- **Singularity `gravityCurve ≥ 3` 会整台静音**：`kGainEnv = pow(kNormRadius, kEnvIndex)`，
  粒子一旦落到 `kNormRadius < 1` 就被指数压到听不见。这是原 C2 版就有的行为
  （`gravityCurve` 的语义是「重力曲线指数」），不是这次改造引入的。
  默认 0.5 下正常；如果用户觉得「拧大了没声」像 bug，要改的是参数语义而不是移植代码。

---

# 头部图标（2026-11-02）

```bash
python3 tools/apply_icons.py --dry-run        # 看会改哪几处
python3 tools/apply_icons.py                  # quad 9 台
python3 tools/apply_icons.py --stereo          # depth 9 台
python3 tools/apply_icons.py --all             # 两套都改

# 图标在 index.html 里，必须重新导出才会进宿主
python3 tools/export_plugin.py Quad-*Cabbage3
python3 tools/export_plugin.py "../stereo wildtrace/"*Cabbage3
```

`apply_icons.py` 的匹配顺序：`svg.mark` → 无 class 的 `<svg viewBox="0 0 12 12">`
→ `<div class="dot">`（Singularity 原来是个发光 div）。三种历史写法都覆盖。

## 图标背后的规则（改图标前先读模板 §16）

- 画布 16×16，渲染 13×13；线 1.0px 圆头；**全系列只有一颗实心点**代表当前声源。
- 各台画的是**自己的算法结构**，不是装饰：等距场 / 椭圆轨道 / 长尾步长 / 蛇形遍历 /
  对数螺旋 / 流线场 / 高斯散布 / **准星鸟** / 李萨如 8 字。
- **BOIDS 用 pad 里 `birdPath()` 的真实路径**（0° 头朝上，`scale(7.2)`），
  和界面里的头鸟是同一个形状。注意 `g` 上的 scale 会放大 `stroke-width`，
  要写 `1.2/7.2 ≈ 0.167` 才是 1.2 个 viewBox 单位。
- 颜色内联写死（取各自 `--orange` / `--red` / `--gold` / `--magenta`），
  不走 CSS 变量 —— 8 个页面的 `.mark` 结构不同，靠继承会把图标颜色吃成标题色。

## 验证

```bash
python3 -m http.server 8771          # 在 quad Doppler 目录
# 打开 http://127.0.0.1:8771/tools/_verify_icons.html
```

那个页面会 `fetch` 9 台真实的 `index.html`、抠出 `<svg class="mark">`、
按 4× 放大和 11/13/16/20/26 五个尺寸并排渲染 —— 验的是落地结果，不是生成器里的字符串。

## 三个坑

1. 实心点压在线上，13px 会连成一坨（ZEPHYR 必须让点落在两条流线之间）。
2. 8 只鸟翼展太窄会在 13px 糊成实心三角形（拉开翼展 + 细分笔画）。
3. 删 `.mark .ring/.core/.q` 是安全的，但 Stasis / Orbita / levy 的 `.mark`
   **本身是 flex 容器**（包着 svg + 标题），删了图标和标题会挤在一起。
