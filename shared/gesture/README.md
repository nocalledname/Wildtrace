# shared/gesture/ — 手势资源（唯一的仓库副本）

这三个文件是 **MediaPipe Tasks Vision** 的运行时，供 `gesture.js` / `gesture-ui.js` 使用：

| 文件 | 来源 | 大小 |
| --- | --- | --- |
| `vision_bundle.js` | npm `@mediapipe/tasks-vision` | 134 KB |
| `wasm/vision_wasm_internal.{js,wasm}` | 同上 | 9.2 MB |
| `hand_landmarker.task` | MediaPipe 官方手部关键点模型（float16） | 7.5 MB |

插件运行时从 `<插件目录>/mediapipe/` 读取它们（`gesture.js` 里是相对路径常量），
所以**每个工程需要一份副本**。仓库里只保存这一份，避免 12 个项目各存 16.8 MB
（那样仓库会多出 200 MB）。

需要手势功能时，在仓库根目录运行：

```bash
python3 scripts/gesture-assets.py          # 复制到 12 个接了手势的工程
python3 scripts/gesture-assets.py --check  # 只检查不缺
python3 scripts/gesture-assets.py --clean  # 用完删掉副本
```

复制出来的 `mediapipe/` 已被 `.gitignore` 排除，不会误提交。

缺少这些文件时，插件其余功能完全正常，只有手势菜单（CAMERA）静默失效。

## 许可

MediaPipe 由 Google 开发，以 **Apache License 2.0** 发布。
模型下载页：<https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker>。
分发时请保留本说明与 Apache-2.0 许可声明。
