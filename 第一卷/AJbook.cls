% ----------------------------------------------------------------------
% 基本信息与选项声明
% ----------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AJbook}[2026/02/22 Class for the book project Methods of Algebra]

% 使用 kvoptions 宏包处理键值对 (key-val) 格式的选项
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}

% 设定选项的家族和前缀，所有内部选项变量将以 @AJ@ 开头
\SetupKeyvalOptions{
    family = @AJ,
    prefix = @AJ@
}

% 声明类选项
\DeclareBoolOption[false]{draftmark}    % 是否在页脚打上“未定稿”标记
\DeclareBoolOption[true]{colors}        % 是否让超链接带颜色 (否则隐藏颜色)
\DeclareBoolOption[true]{CJKthechapter} % 是否让天眉中的各章编号使用中文数字 (如“第一章”)
\DeclareStringOption[]{coverpage}       % 封面 PDF 或 TeX 文件的文件名，默认为空
\DeclareStringOption{fontsetup}         % 字体设定文件的文件名
\DeclareStringOption{titlesetup}        % 章节标题设定文件的文件名
\DeclareStringOption[b5]{geometry}      % 版面尺寸选项，默认为 b5

% 让后续载入的 xcolor 宏包自动带有 dvipsnames 选项 (TikZ 会依赖此选项)
\PassOptionsToPackage{dvipsnames}{xcolor}

% 执行并处理所有传递给类的选项
\ProcessKeyvalOptions*
\relax

% ----------------------------------------------------------------------
% 宏包加载
% ----------------------------------------------------------------------
% 基于标准的 book 文档类，基础字号设为 10pt，并继承向此类传递的其他选项
\LoadClass[10pt]{book}

% 字体与中文支持
\RequirePackage{fontspec}               % 提供 XeLaTeX 下的字体配置功能
\RequirePackage[CJKchecksingle]{xeCJK}  % 提供 XeLaTeX 下的中文排版支持，并检查单字占行
\RequirePackage{zhnumber}               % 提供将阿拉伯数字转换为中文数字的功能

% 数学公式与符号支持
\RequirePackage[nointlimits]{amsmath}   % 核心数学环境；积分上下限默认置于积分号右侧
\RequirePackage{amssymb}                % 扩展数学符号库
\RequirePackage{yhmath}
\RequirePackage[centercolon]{mathtools} % 增强 amsmath，提供更多数学工具 (冒号垂直居中)

% 实用工具宏包
\RequirePackage{pdfpages}               % 支持直接将外部 PDF 页面插入文档
\RequirePackage{pgfplots}
\pgfplotsset{compat=newest}
\RequirePackage{xstring}                % 提供高级的字符串处理和判断功能
\RequirePackage{emptypage}              % 确保空白页 (如章末) 上没有页眉页脚
\RequirePackage[many]{tcolorbox}        % 用于制作各种精美的带边框文本框
\RequirePackage{setspace}               % 用于设定适合中文排版的行距
\RequirePackage{tikz}                   % 强大的矢量绘图宏包
\usetikzlibrary{positioning, patterns, calc, matrix, shapes.arrows, shapes.symbols}
\RequirePackage{paralist}               % 提供紧凑型列表环境
\RequirePackage{wrapfig} 				% 支持文字环绕图片

% 参考文献支持 (使用 BibLaTeX + Biber)
\RequirePackage[
    backend=biber,                      % 使用 biber 作为后端编译
    sorting=nyt,                        % 按姓名、年份、标题排序
    hyperref=auto,                      % 自动处理超链接
    backref=true,                       % 启用反向引用 (在文献处显示引用页码)
    backrefstyle=three                  % 反向引用压缩风格
]{biblatex}


% ----------------------------------------------------------------------
% 全局排版与通用设置
% ----------------------------------------------------------------------
% 若开启 draftmark 选项，则利用 isodate 宏包在页脚输出当前日期的“未定稿”提示
\RequirePackage[iso, english]{isodate}  % 设置 \today 输出格式为 yyyy-mm-dd
\providecommand{\@AJ@draftstring}{{\color{gray!40}\heiti 未定稿: \today}}

\onehalfspacing             % 设置全局行距为一倍半，更适合中文阅读
\setlength{\parindent}{2em} % 设置段落首行缩进为两个中文字符宽度

% ----------------------------------------------------------------------
% 章节编号逻辑自定义 (Section 和 Subsection)
% ----------------------------------------------------------------------
% 1. 修改 section 编号格式，仅显示 § 和自身数字，不带 chapter 编号
\renewcommand{\thesection}{\S\arabic{section}}

% 2. 让 subsection 解除与 section 的绑定，不再随之重置
\counterwithout{subsection}{section}

% 3. 修改 subsection 编号格式，仅显示自身数字，实现全文连续编号
\renewcommand{\thesubsection}{\arabic{subsection}}

% ----------------------------------------------------------------------
% 文档结构与目录重定义
% ----------------------------------------------------------------------
% 扩展 \frontmatter (前言部分)：添加封面处理与目录生成逻辑
\g@addto@macro\frontmatter{
    % 判断是否通过 coverpage 选项指定了封面
    \ifdefempty{\@AJ@coverpage}{%
        \relax % 若未指定，则跳过
    }{%
        \pagestyle{empty}                       % 封面页清空页眉页脚
        \renewcommand{\thepage}{C\arabic{page}} % 封面部分页码以 C 开头 (用于 PDF 逻辑页码)
        
        % 检查封面文件名后缀，若为 PDF 则直接插入，否则当作 TeX 源码 input
        \IfEndWith{\@AJ@coverpage}{.pdf}{%
            \includepdf{\@AJ@coverpage}
        }{%
            \IfEndWith{\@AJ@coverpage}{.PDF}{%
                \includepdf{\@AJ@coverpage}
            }{%
                \input{\@AJ@coverpage}
            }
        }%
        \pagestyle{fancy}       % 封面插入完毕后，恢复 fancy 页眉页脚风格
        \pagenumbering{roman}   % 前言部分页码恢复为小写罗马数字
    }

    % 重置页码和样式，确保目录从第1页开始，且第一页无页眉页脚
    \setcounter{page}{1}
    \thispagestyle{empty}
    \addtocontents{toc}{\protect\thispagestyle{empty}}

    % 汉化目录标题
    \renewcommand{\contentsname}{目录}
    \tableofcontents    % 生成并印出目录
}

% 扩展 \appendix (附录部分)：汉化标题并重置天眉格式
\g@addto@macro\appendix{
    \renewcommand{\appendixname}{附录}
    \renewcommand{\chaptermark}[1]{\markboth{附录 \thechapter \quad #1}{}}
    \renewcommand{\sectionmark}[1]{\markright{\S\thesection \quad #1}}
}

% 扩展 \backmatter (后记/参考文献部分)：设置文献标题与字体
\g@addto@macro\backmatter{
    \renewcommand{\em}{\itshape} % 书目部分以斜体表示强调
    \providecommand{\refname}{参考文献}
    \renewcommand{\refname}{参考文献}
    \renewcommand{\bibname}{参考文献}
}

% 汉化图、表及其索引的标题名称
\renewcommand{\figurename}{图}
\renewcommand{\tablename}{表}
\renewcommand{\listfigurename}{图片索引}
\renewcommand{\listtablename}{表格索引}

% 使用 etoolbox 的 pretocmd 将图片索引和表格索引自动加入到主目录中
\pretocmd{\listoffigures}{%
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listfigurename}
}{}{}
\pretocmd{\listoftables}{%
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listtablename}
}{}{}

% ----------------------------------------------------------------------
% 参考文献设置 (BibLaTeX)
% ----------------------------------------------------------------------
\DeclareFieldFormat{postnote}{#1}   % 设置 \cite[引注内容]{文献} 的输出格式

% 汉化 BibLaTeX 的内置本地化字符串
\DefineBibliographyStrings{english}{%
    in = {刊于},
    editor = {主编},
    byeditor = {编者为},
    backrefpage = {引用于 p.\!},
    backrefpages = {引用于 pp.\!},
}

% 动态修改参考文献数据源：当 DOI 和 URL 同时存在时，优先保留 DOI 并移除 URL
\DeclareSourcemap{
    \maps[datatype=bibtex]{
        \map{
            % 步骤1：如果 url 字段是以 http://dx.doi.org/ 开头，则将其内容复制给 doi 字段
            \step[
            fieldsource=url,
            match=\regexp{http://dx.doi.org/(.+)},
            fieldtarget=doi,
            ]
            % 步骤2：清理 doi 字段，只保留纯正的 DOI 号，移除前缀
            \step[
            fieldsource=doi,
            match=\regexp{http://dx.doi.org/(.+)},
            replace=\regexp{$1}
            ]
            \iffalse $ \fi  % 修复某些编辑器语法高亮的 bug
        }
        \map{ 
            % 步骤3：对于所有包含 doi 字段的文献条目，直接清空其 url 和 urldate 字段
            \step[fieldsource=doi, final]
            \step[fieldset=url, null]
            \step[fieldset=urldate, null]
        }
    }
}

% ----------------------------------------------------------------------
% 外部配置文件引入
% ----------------------------------------------------------------------
\input{\@AJ@fontsetup}   % 引入由 fontsetup 选项指定的字体设定文件
\input{\@AJ@titlesetup}  % 引入由 titlesetup 选项指定的章节标题设定文件

% ----------------------------------------------------------------------
% 自定义排版环境
% ----------------------------------------------------------------------
% 【章末习题环境】：置于每章最后，使用数字列表
\newenvironment{Exercises}{%
    \markright{习题}                           % 更新页眉
    \addcontentsline{toc}{section}{习题}       % 将习题作为一个 section 加入目录
    \vspace{1em}
    \begin{center}
        \Large\CJKfamily{sectionfont} 习题      % 居中打印大字号标题
    \end{center}
    \vspace{0.7em}
    \begin{small}
    \begin{enumerate}[\bfseries 1.]           % 缩小字号并使用粗体数字作为列表序号
}{
    \end{enumerate}
    \end{small}
}

% 【行内提示环境】：穿插在正文中，利用 TikZ 绘制一个带方向的小标签
\newenvironment{hint}{%
    \ifvmode            % 检测是否处于垂直模式（即是否另起新段）
        \ignorespaces   % 如果是新段落，消除行首横向空白
    \else
        \quad           % 如果是在行内，则加一个空格的距离
    \fi
    \begin{tikzpicture}[baseline=(H.base), every node/.style={signal, draw, very thin, signal to=east, signal from=nowhere, signal pointer angle=120, inner sep=2pt}]
        \node[anchor=mid west] (H) at (0,0) {\heiti\footnotesize 提示};
    \end{tikzpicture}
}{}

% 【解答环境】：重定义解答环境的字体和结束符
\newenvironment{solution}{
    \heiti 解             % "解"字使用黑体
    \normalfont\songti    % 正文内容恢复为常规宋体
}{\hfill$\blacksquare$}   % 结尾处在右侧打上黑色方块 QED 符号

% 【阅读提示框】：每章开头的精美提示框，使用 tcolorbox 制作
\newtcolorbox{wenxintishi}{
    breakable,                                 % 允许跨页断行
    enhanced,                                  % 启用高级绘图特性
    width = \textwidth,                        % 宽度与文本等宽
    colback = white, colbacktitle = white,     % 背景和标题背景设为白色
    colframe = gray!50, boxrule=0.2mm,         % 灰色极细边框
    coltitle = black,                          % 标题文字为黑色
    fonttitle = \sffamily,                     % 标题字体使用无衬线体
    % 设置标题框悬浮在左上角
    attach boxed title to top left = {yshift=-\tcboxedtitleheight/2,  xshift=\tcboxedtitlewidth/4},
    boxed title style = {boxrule=0pt, colframe=white},
    before skip = 0.5cm,
    top = 3mm,
    bottom = 3mm,
    title={阅读提示}
}

% 保留原注册顺序；以下文件在类文件的 @ 字符语境内读取。
\input{template/page-layout.tex}
\input{template/theorems.tex}
