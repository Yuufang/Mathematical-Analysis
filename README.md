# 《微积分学教程》LaTeX 重排版

本项目以菲赫金戈尔茨《微积分学教程》为底稿，进行现代中文 LaTeX 重排。保留原书的内容次序、例题脉络和主要论证方法，调整陈旧术语、翻译腔和过长句子，由整理者逐批校对、审核。

## PDF 下载与发布进度

**[下载第一卷 PDF（最新发布版）](https://github.com/Yuufang/Mathematical-Analysis/raw/refs/heads/main/%E7%AC%AC%E4%B8%80%E5%8D%B7/main.pdf?download=1)**

截至 **2026-10-05**，第一卷已连续精校、审核并发布第 **1—54 小节**，发布 PDF 共 **100 页**。下载入口指向 main 分支中的发布文件，与同次提交的已审核源码对应；详细发布记录见 [CHANGELOG.md](CHANGELOG.md)。

| 已发布范围 | 内容 |
| --- | --- |
| 绪论第 1—21 小节 | 实数 |
| 第一章第 22—42 小节 | 数列与极限论 |
| 第二章第 43—54 小节 | 函数概念、重要函数、反函数、函数复合、函数极限及其数列判据、极限求法例题 |

第一卷后续内容及其他卷册仍在本地整理，未经本批审核或发布。第二卷第八至十二章已有本地初稿，尚未载入正式主文件，也未作为发布源码上传。工作目录中的额外修改和工作 PDF 不一定与上述发布版一致。

## 整理方式

- 参照原书逐节整理，沿用已确认的中文表达和证明节奏；原书旧称“整序变量”原则上改用“数列”，必要的历史术语说明保留在脚注中。
- 数学家姓名使用国际通行外文形式；用交叉引用连接小节、公式和例题，便于在 PDF 中阅读。
- 排版基于[李文威《代数学方法》的 AJbook 模板](https://github.com/wenweili/AlJabr-1)，并按本项目需要调整。各卷保留本地模板文件，以便独立编译。

这本著作本人在大一时开始阅读，现在也借整理工作重读。排版与识图使用 AI 辅助，文字和数学内容由本人审核；这是一个持续推进的长期项目。

## 发布源码结构

```text
第一卷/
├── main.tex                 # 编译入口
├── main.pdf                 # Git 中的发布成品；本地工作文件可能不同
├── AJbook.cls               # 文档类
├── font-setup-open.tex      # 字体配置
├── titles-setup.tex         # 标题样式
├── coverpage.tex            # 封面
├── mycommand.sty            # 数学宏与正文编号
├── myarrows.sty             # TikZ 箭头
└── text/
    ├── intro.tex            # 绪论
    ├── chapter1.tex         # 第一章
    └── chapter2.tex         # 第二章已发布部分
```

上述目录描述公开发布源码。本地还保存其他章节、卷册及原书资料；原书扫描本不随发布源码提供。

## 编译

使用安装了项目所需宏包的 TeX Live／MacTeX，进入相应卷册目录。先运行 XeLaTeX 生成索引数据，再处理索引并编译两遍，使目录和交叉引用稳定：

```bash
cd 第一卷
xelatex main.tex
texindy main.idx
xelatex main.tex
xelatex main.tex
```

启用人名索引输出时，还需处理 `names.idx`；涉及书目时按主文件的 biblatex 配置运行 biber。检查日志中的错误、未定义引用及重复标签，不能只以生成 PDF 作为验证通过的依据。

标题与证明字体默认使用 `Noto Sans CJK SC`。读者可安装相应字体；维护验证时若本机无法载入，使用命令行临时回退为 Fandol 黑体，不因此修改项目字体文件：

```bash
xelatex -jobname=main -interaction=nonstopmode -halt-on-error \
  '\AtBeginDocument{\setCJKfamilyfont{hei2}{FandolHei-Regular.otf}\setCJKfamilyfont{sectionfont}{FandolHei-Regular.otf}\setCJKfamilyfont{pffont}{FandolHei-Regular.otf}}\input{main.tex}'
```

该命令替代上述流程中的 XeLaTeX 步骤；索引处理和后续稳定编译仍须完成。第二卷本地稿沿用同类流程，但未审核章节保持注释，普通主文件编译不代表这些章节已经验证。

## 日常整理与审核

每日任务按原书顺序实际精校 1—2 节，完成索引、稳定编译和页面抽查，生成审核 PDF 与校对说明。用户审核、修改后说“本批已审核，上传”，即可由发布任务完成记录更新、复验及定向提交，并直接推送 main。每日任务本身不提交或上传。

[AGENTS.md](AGENTS.md) 规定长期规则；[PROJECT_STATUS.md](PROJECT_STATUS.md) 区分已发布范围、待审队列和下一起点；[PROMPTS.md](PROMPTS.md) 提供简短指令；[历史里程碑](docs/history.md) 保存必要的历史结论。这些管理文档随仓库维护，原书和待审产物保留本地。

## 更新与反馈

实质内容进展和工程变更见 [CHANGELOG.md](CHANGELOG.md)。欢迎通过 Issue 反馈问题。

Email: huanghunku@gmail.com, 1520364403@qq.com.

Typeset with ❤️ by Yuufang
