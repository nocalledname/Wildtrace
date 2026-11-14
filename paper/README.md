# paper/ — 论文原文

本仓库随源码附带两篇论文，都是本项目（Wildtrace / 野痕）的配套发表物。

| 文件 | 会议 | 语言 / 篇幅 | 题目 |
| --- | --- | --- | --- |
| [`ICSC2026-Wildtrace.pdf`](./ICSC2026-Wildtrace.pdf) | ICSC 2026（第 8 届国际 Csound 会议，特拉帕尼） | 英文，4 页 | Immersive Engagement: Building the "Wildtrace" Sonic World with AI Assistance |
| [`CSMT2026-Wildtrace-long-zh.pdf`](./CSMT2026-Wildtrace-long-zh.pdf) | CSMT 2026 | 中文，42 页（长论文） | 「野痕」系列空间音效插件的算法设计与 AI 协同开发 |

两篇分工不同：

- **ICSC 短论文**讲开发范式 —— Csound + LLM 的协作流程、以「可替换的全局渲染器」为核心的分层
  架构、自设计的前端交互；结论是定性证据（一个月内零 API 成本完成 8 台插件并测试），
  不是系统基准测试。
- **CSMT 长论文**是算法说明书 —— `QuadRender` 四声道等功率渲染、`DepthStereoRender`
  双声道深度渲染、HRTF 双耳与一阶 Ambisonics、9 套生成式算法逐条推导。

两篇与 [`Cabbage3-改造模板.md`](../Cabbage3-改造模板.md) 互为对照：论文讲「为什么这么设计」，
模板讲「代码怎么写」。

## 作者

Haokun Yang（杨昊昆）、Wanjun Yang（杨万钧），四川音乐学院，成都。

## 引用

```bibtex
@inproceedings{yang2026wildtrace,
  title     = {Immersive Engagement: Building the ``Wildtrace'' Sonic World with AI Assistance},
  author    = {Yang, Haokun and Yang, Wanjun},
  booktitle = {Proceedings of the 8th International Csound Conference (ICSC 2026)},
  address   = {Trapani, Sicily},
  year      = {2026}
}
```

```bibtex
@inproceedings{yang2026yhen,
  title     = {「野痕」系列空间音效插件的算法设计与 AI 协同开发},
  author    = {杨昊昆 and 杨万钧},
  booktitle = {CSMT 2026},
  year      = {2026}
}
```

> 版权归各会议出版方所有，此处仅作学术存档。
