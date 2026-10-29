# 《微积分学教程》LaTeX 重排版

本项目以菲赫金戈尔茨《微积分学教程》为底稿，进行现代中文 LaTeX 重排。保留原书次序、例题脉络和主要论证方法，调整陈旧术语、翻译腔和长句，由整理者逐批校对、审核。数学家姓名沿用国际通行外文形式，原书“整序变量”原则上改用“数列”。

## 阅读与进度

**[下载第一卷最新发布 PDF](https://github.com/Yuufang/Mathematical-Analysis/raw/refs/heads/main/%E7%AC%AC%E4%B8%80%E5%8D%B7/main.pdf?download=1)**

截至 **2026-10-29**，第一卷已审核发布第 **1—103 小节**，PDF 共 **178 页**，涵盖绪论“实数”、第一章“极限论”、第二章“一元函数”，以及第三章第一节“导数及其求法”的全部内容，包括单侧导数、无穷导数和特殊情形的例题，并新增第二节“微分”的第 103 小节“微分的定义”。后续内容仍在整理，原书扫描本不随源码提供。

## 源码结构

```text
第一卷/
├── main.tex              # 整卷编译入口
├── main.pdf              # PDF
├── AJbook.cls            # 文档类与基础依赖
├── mycommand.sty         # 数学宏与正文分项
├── myarrows.sty          # 可伸缩数学箭头
├── template/             # 字体、封面、标题、页面与定理设置
└── text/                 # 绪论及各章正文
```

编译入口为 [第一卷/main.tex](第一卷/main.tex)，请在卷册目录执行编译。各文件职责及模板修改方法见 [模板说明](模板说明.md)。

## 编译

### 环境与字体

使用 **XeLaTeX**，安装完整的 TeX Live 或 macOS 上的 MacTeX；索引处理需要 `texindy`（xindy）。模板依赖 xeCJK、fontspec、ntheorem、TikZ／PGFPlots、tcolorbox、biblatex 等宏包，完整发行版通常包含这些组件；使用精简发行版时需按缺包提示补装。

请确保已安装以下字体：

- **Fandol**：正文宋体、黑体、楷体及仿宋，通常随 TeX Live 提供。
- **TeX Gyre Heros**：西文无衬线字体，通常随 TeX Live 提供。
- **Noto Sans CJK SC**：中文标题及证明字体，需要 Regular、Black、Medium 字重。
- **Times New Roman**：封面俄文作者名使用。

具体字体名称与映射见 `第一卷/template/font-setup-open.tex` 和 `coverpage.tex`。若提示找不到字体，先安装对应字体并重新启动编译程序；自行替换字体可能改变字重、分页及最终版式。

### 构建第一卷

下载或克隆仓库后，在仓库根目录打开终端，执行：

```bash
cd 第一卷
xelatex -interaction=nonstopmode -halt-on-error main.tex
texindy -C utf8 -L english main.idx
texindy -C utf8 -L english names.idx
xelatex -interaction=nonstopmode -halt-on-error main.tex
texindy -C utf8 -L english main.idx
texindy -C utf8 -L english names.idx
xelatex -interaction=nonstopmode -halt-on-error main.tex
xelatex -interaction=nonstopmode -halt-on-error main.tex
```

输出为同目录的 `main.pdf`。两份索引数据均需处理，目前仅打印名词索引。若仍提示交叉引用变化，继续编译；索引页码变化时重新运行对应 `texindy`，再编译至稳定。

当前第一卷无需单独运行 Biber；添加参考文献数据及引用后，再按 biblatex 流程运行 Biber。也可使用编辑器调用以上命令，不依赖维护者的 VS Code 配置。

## 模板与反馈

模板基于[李文威《代数学方法》的 AJbook 模板](https://github.com/wenweili/AlJabr-1)。欢迎通过 Issue 反馈文字、数学或排版问题，最好附小节号和具体位置。

[模板说明](模板说明.md) 介绍模板维护；[CHANGELOG](CHANGELOG.md) 记录变更与发布。参与整理时可另阅 [协作规范](AGENTS.md) 与 [当前工作状态](PROJECT_STATUS.md)。

这本著作本人在大一时开始阅读，现在借整理工作重读。排版与识图使用 AI 辅助，文字和数学内容由本人审核。欢迎通过 Issue 或邮件反馈：huanghunku@gmail.com、1520364403@qq.com。

Typeset with ❤️ by Yuufang
