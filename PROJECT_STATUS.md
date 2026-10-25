# 项目当前状态

最后更新：2026-10-25

## 已审核发布

第一卷连续第 **1—95 小节**已由用户审核并发布，包含第 107 页异常空白修复。2026-10-25 续入第 92“导数的定义”、第 93“求导数的例题”、第 94“反函数的导数”、第 95“导数公式一览表”，以及第 77 例 5 的定向引用。发布 PDF **163 页、1421233 字节**；[公开下载](https://github.com/Yuufang/Mathematical-Analysis/raw/refs/heads/main/%E7%AC%AC%E4%B8%80%E5%8D%B7/main.pdf?download=1)。源码、PDF 与进度提交 `98b3ced02832e8caeb73c30df9878be594631886` 已推送并核验 origin/main。

本批原书印刷 155—162／物理 171—178；源码标签 `subsec:92`、`def:derivative`、`subsec:93`、`subsec:94`、`thm:inverse_function_derivative`、`fig:inverse_function_derivative`、`subsec:95`、`tab:elementary_derivatives`。用户在发布期间保存的第 93 分数字号调整已保留并另行完整复验。

发布副本四遍原字体 XeLaTeX、main/names texindy 各两轮，最后两遍 12 个关键辅助文件稳定；163 页、1421233 字节，431 活动标签、561 次显式引用、922 内部链接及 711 命名目标有效，Noto Regular/Black/Medium 实际嵌入。正文 147—154／物理 153—160、第 77 补链页、交界、目录及三页索引已独立渲染看图。无致命错误、未定义引用／命令、重复标签／目标、Overfull、缺字、引用不稳定或 wrapfig 警告；保留 48 条 Underfull（47 条在正文 142 及以前，另在 147）及索引／locale 提示。

发布第三章 SHA-256 `15af4de7ef71445ec0e8d7566b7d5203f69d76aa50aa1642178d67818cd9a756`，第二章 `3c7209db27814f6682e7a83dce47354e6b1cad87ac92fe99c4104a3562606fcf`，PDF `3c1ecac19c43796ef1060dd9bf3c756b79fb3098ad4cc41545c88d33d86c394f`。发布第三章第 92—95 逐字节取自用户当前保存稿；第 90、91 沿用此前已发布版本，第二章仅增加第 77 例 5 指向第 93 的引用，入口、宏与模板均不改。 临时基线、差异、日志与图像记录后清理，历史验证边界见 CHANGELOG。

## 正式工程与本地存稿

入口为 [第一卷/main.tex](第一卷/main.tex)，当前正文见 [第一卷/text/chapter3.tex](第一卷/text/chapter3.tex)，工作 PDF 为 [第一卷/main.pdf](第一卷/main.pdf)。本地启用至第 95，第 96 起保持 comment；第四至七章及其他卷册未载入、不上传。完整本地第三章 SHA-256 `421bb8401d7af5085237735bab26d56cb3cf1a1dddc9516484ef9459ec1128fb`，第 96 起存稿原样保留。

未以发布 PDF 覆盖用户工作文件。期间检测到第 93 平方根例题新保存的三处 `\dfrac` 调整及工作 PDF 外部更新，已保留并按新源码重新完整复验；最后观察工作 PDF 1420566 字节、SHA-256 `2ee699c4d16ef0c20dadcb9fde04ff2acb2c7f88f5239f98ee571ebdba5f6988`，它与本次发布 PDF 分别保留。第 89 的两句本地删除和第 91 两处后续措辞改动不属本批发布范围，继续留在本地；本地第二章 SHA-256 `24cff87acc59c7e649a41637b5b1c7355f399c0652811ae94c6b920317f0550b`。

## 稿件范围

| 范围 | 状态与位置 |
| --- | --- |
| 第一卷第 1—95 小节及第 77 配套引用 | 已审核发布 |
| 第一卷第 96—256 小节 | 第三章第 96 起仍注释；第四至七章仍注释且未载入 |
| 第一卷第 257—262 小节 | 尚未起草 |
| 第二卷第 263—469 小节 | 第八至十二章初稿，五个 text/chapter 文件；comment 且未载入 |
| 第二卷第 470—542 小节 | 尚未起草 |
| 第三卷 | 保存旧稿，主文件未载入；不计作正式精校队列 |

## 下一次自动精校起点

第一卷第三章第 **96 小节“函数增量的公式”**，原书印刷第 162 页／PDF 物理页 178 起，对应 `第一卷/text/chapter3.tex` 的 `subsec:96` 现有注释初稿。下轮只精校第 96，保留第 97 起注释；第 1—95 已审核发布，不重复重写。

## 当前待处理问题

- 每轮精校按 AGENTS.md 回查前文暂缓引用，目标启用后再核对并补链：第 55、79 小节未定式一般方法指第四章 `sec:indeterminate_forms`（未载入且 comment）；第 63 小节主部系统方法指 `subsec:104`、`subsec:124`（第三章已载入，但这两处仍在 comment 中）；第 81 小节脚注的更有效求根方法指第四章第五节 `sec:approximate_solution_equations`（未载入且 comment）。第 85 小节关于实际求极值点方法的前瞻指第四章第一节 `sec:function_variation`（未载入且 comment），暂保留普通文字。不因补引用启用存稿或恢复删稿。
- 第 92 的两条脚注分别前瞻第 101“无穷导数”和第 104 的 Leibniz 记号解释；对应 `subsec:101`、`subsec:104` 仍在 comment 中，暂保留普通文字，目标启用后再补正式引用。
- Codex 直接打开 `main.pdf` 时中文缺失的具体原因仍未确认，倾向应用内显示／缓存兼容问题。2026-10-24 对当前工作 PDF（159 页、1399696 字节，SHA-256 `58ed7f221d2d6bcf8ee8e36153490e32a33bf3e895cdf12cb55068fbe7dd0651`）独立渲染，正文中文正常；已核验 PDF 字体嵌入，不据此更换书稿字体。另行调用内置 TeX 编译器诊断，Tectonic 读取系统 Times New Roman 被拒（`Operation not permitted`），在 `template/coverpage.tex:2` 编译失败；这是内置编译环境的独立问题，不能用来解释直接 PDF 显示异常，也不撤销本机原字体 XeLaTeX 的验证结果。

## 审核与发布

用户明确授权上传后按 [AGENTS.md](AGENTS.md) 复验、定向提交并直接推送 main；本地工作模板与历史发布模板、工作 PDF 与发布 PDF 分别核实。多批“本批”不明时仅澄清范围。常用指令见 [维护者常用指令](AGENTS.md#八维护者常用指令)，公开入口与编译方法见 [README.md](README.md)。
