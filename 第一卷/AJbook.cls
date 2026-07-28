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
\RequirePackage[nointlimits]{amsmath}   % 核心数学环境 (积分上下限置于积分号上下)
\RequirePackage{amssymb}                % 扩展数学符号库
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

% ----------------------------------------------------------------------
% 钩子函数：导言区末尾执行 (配置页面与链接等)
% ----------------------------------------------------------------------
\AtEndPreamble{
    % 载入定理宏包，需等待前面必要的数学和字体设置完成
    \RequirePackage[thmmarks, amsmath, hyperref]{ntheorem}
    
    % 检测是否载入了 hyperref 宏包，并根据 colors 选项决定超链接颜色配置
    \@ifpackageloaded{hyperref}{
        \if@AJ@colors
            \hypersetup{
                colorlinks = true,
                linkcolor = blue,
                citecolor = red,
                urlcolor = teal
            }
        \else
            \hypersetup{hidelinks} % 隐藏超链接颜色和边框
        \fi
    }{}
    
    % 页面尺寸配置
    \RequirePackage{geometry}
    \IfStrEq{\@AJ@geometry}{b5}{% 如果选项为 b5
        \geometry{
            paper=b5paper,
            headheight=5ex, headsep=5ex,
            textwidth=132mm, textheight=198mm,
            twoside,
            asymmetric  % 单双数页边距不区分对称
        }
    }{}

    \IfStrEq{\@AJ@geometry}{a4}{% 如果选项为 a4
        \geometry{
            paper=a4paper,
            top=3cm, bottom=3cm,
            inner=2.54cm, outer=2.54cm,
            headheight=6ex, headsep=6ex,
            twoside,
            asymmetric
        }
    }{}

    % 页眉页脚 (天眉地脚) 设置
    \RequirePackage{fancyhdr}
    
    % 重新定义 plain 样式，使每章首页的页眉保持为空
    \fancypagestyle{plain}{
        \fancyhead{}
        \renewcommand{\headrulewidth}{0pt}
    }
    
    % 设置 fancy 全局页眉页脚样式
    \pagestyle{fancy}
    
    % 设定左页眉的章名格式 (支持中文数字或阿拉伯数字)
    \if@AJ@CJKthechapter
        \renewcommand{\chaptermark}[1]{\markboth{第\zhnumber{\thechapter}章\quad #1}{}}
    \else
        \renewcommand{\chaptermark}[1]{\markboth{第 \thechapter 章\quad #1}{}}
    \fi
    
    % 设定右页眉的节名格式，直接调用新定义的 \thesection
    \renewcommand{\sectionmark}[1]{\markright{\thesection \quad #1}}
    
    \fancyhf{} % 清空当前所有页眉页脚设置
    
    % 具体位置设置: E(偶数页), O(奇数页), C(中), L(左), R(右)
    \fancyhead[EC]{\CJKfamily{hei2}\footnotesize{\leftmark}\vspace{1mm}}
    \fancyhead[OC]{\CJKfamily{hei2}\footnotesize{\rightmark}\vspace{1mm}}
    \fancyhead[LE,RO]{{\footnotesize \thepage}\vspace{1mm}} 
    \fancyhead[RE,LO]{}
    
    % 如果开启了 draftmark 选项，在页脚居中位置打印版本信息
    \if@AJ@draftmark
        \fancyfoot[C]{\@AJ@draftstring} 
    \fi
    
    \renewcommand{\headrulewidth}{0pt}  % 去掉页眉下方的装饰横线
    \renewcommand{\footrulewidth}{0pt}  % 去掉页脚上方的装饰横线
    \addtolength{\headheight}{0.5pt}    % 略微增加页眉高度防止溢出警告
}

% ----------------------------------------------------------------------
% 钩子函数：正文开始时执行 (配置数学符号与定理环境)
% ----------------------------------------------------------------------
\AtBeginDocument{
    % 重置特定数学符号。为了兼容 unicode-math，必须在正文开始时进行
    \renewcommand{\Re}{\operatorname{Re}}       % 实部符号
    \renewcommand{\Im}{\operatorname{Im}}       % 虚部符号
    \renewcommand{\emptyset}{\ensuremath{\varnothing}} % 空集符号
    
    % 定义证明结束符：空心方格 (模拟 amsthm 的表现)
    \newcommand{\openbox}{\leavevmode   
    \hbox to.77778em{%
        \hfil\vrule
        \vbox to.675em{\hrule width.6em\vfil\hrule}%
        \vrule\hfil}}
        
    % ntheorem 基础配置
    \theorembodyfont{\fangsong}                          % 定理内容默认字体为仿宋
    \theoremheaderfont{\sffamily\bfseries\thmheiti}      % 定理标题字体
    \theoremseparator{\ }                                % 标题与正文间距符号
    \setlength{\theorempreskipamount}{2mm}               % 定理上方留白
    \setlength{\theorempostskipamount}{2mm}              % 定理下方留白
    
    % 核心定理环境定义 (简体中文体系)
    \theorembodyfont{\kaishu}                    % 核心定理内容使用楷体
    \newtheorem{lemma}{引理}
    \counterwithin{lemma}{chapter}
    \renewcommand{\thelemma}{\arabic{lemma}}
    \newtheorem{proposition}{命题}
    \theoremstyle{nonumberplain}   
    \newtheorem{definition}{定义}
    \newtheorem{theorem}{定理}              
    \newtheorem{corollary}{推论}

    % --- 定义“仅显示标题”的定理环境 ---
    \theoremstyle{empty}                         % 关键：使用 empty 样式，不显示“定理”字样
    \theoremheaderfont{\sffamily\bfseries\thmheiti} % 保持与其他定理一致的标题字体
    \theorembodyfont{\kaishu}                    % 内容依然使用楷体
    \theoremseparator{\ }                        % 标题后的间距
    \newtheorem{namedtheorem}{定理}               % 环境名设为 namedtheorem

    % --- 恢复正常的带编号样式 ---
    \theoremstyle{plain}                         % <====== 加上这一行！切回带编号模式
    \theorembodyfont{\songti}                    % 辅助说明环境内容使用宋体
    \newtheorem{example}{例}                     % 现在的“例”就会有编号 1, 2, 3 了

    % --- 插入以下代码来实现无编号注记 ---
    \theoremstyle{nonumberplain}                 % 切换为无编号样式
    \newtheorem{remark}{注记}                    % 定义无编号的注记
    \newtheorem{convention}[theorem]{约定}
    \newtheorem{exercise}[theorem]{练习}
    
    % 证明环境定义
    \theorembodyfont{}                           % 证明内容使用正文默认字体
    \theoremstyle{nonumberplain}                 % 证明环境不编号
    \theoremheaderfont{\sffamily\bfseries\CJKfamily{pffont}}
    \theoremseparator{\enspace}
    \theoremsymbol{\openbox}                     % 结尾处自动添加空心方块
    \newtheorem{proof}{证明}
}

\AtEndDocument{
    % 此处当前为空，可根据后续需要添加文档结束时的清理工作
}