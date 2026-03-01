# 随 HtDP2e ，领悟计算机科学

## 前言

之前，习题答案文件夹排序第一。如今，降了一格，位居第二。

先前，学习感悟类文章偏居一角。而今，置顶显示。

非不重解题，习题乃手段，一题又一题，题题为梯，渐次感悟计算机科学内涵，才是意图所在。

**没错，我重构了认知！**


## 1、仓库构成

本仓库由三大文件夹构成，排名愈前，愈要紧。

### 第 1 文件夹

**[01_My_HtDP2e_Thinking_Path (随想与感悟)](./01_My_HtDP2e_Thinking_Path/)**

**本仓库的灵魂**，学习过程中的心得、疑问点、程序设计方法，等等，均记录于此。

该文件夹又细分为三条路径：

* **[01_The_Rational_Path (理性思考)](./01_My_HtDP2e_Thinking_Path/01_The_Rational_Path/)**
跟随 HtDP2e 感悟计算机科学的核心产出。文章多以主题为旨（如架构、命名），有时亦以章节为径。
<br>

* **[02_The_Book_Path (理解 HtDP2e 之书)](./01_My_HtDP2e_Thinking_Path/02_The_Book_Path/)**
记录对书本内在逻辑、教学风格的理解与知识点梳理。
示例：[前面问题，后面会有对应提示](./01_My_HtDP2e_Thinking_Path/02_The_Book_Path/Ch04_P075_[Note]_前面问题，后面会有对应提示.md)
<br>

* **[03_The_Emotional_Path (学习心绪)](./01_My_HtDP2e_Thinking_Path/03_The_Emotional_Path/)**
记录学习过程中的真实心情与顿悟。
示例：[不着急开启抽象](./01_My_HtDP2e_Thinking_Path/03_The_Emotional_Path/003_P119_[Refl]_不着急开启抽象.md)

### 第 2 文件夹

**[02_HTDP2e_Exercises_Solutions (习题与实践)](./02_HTDP2e_Exercises_Solutions/)**

HtDP2e 习题代码，按照本书章节汇聚于此。

### 第 3 文件夹

**[03_Archive_Translation_Notes (历史归档)](./03_Archive_Translation_Notes/)**

之前阅读中文版，写下的翻译校对记录。现今改读英文版，此部分笔记封存留档，不再更新。

<br>

#### 另：为什么文件夹命名统一使用两位数 (01, 02)？
**一致性**：保持视觉整齐。
**隔离性**：每个文件夹都是独立作用域，规则统一，降低认知负担。

[**详见:00_About_This_Path**](./01_My_HtDP2e_Thinking_Path/00_About_This_Path.md)



## 2、心路历程 —— 学程序设计方法：当学其思想

### 2.1、暂时弃学 Python 

我工作的岗位，乃产品经理，以设计见长。

工作中，总和代码打照面，抬头不见低头见。时日久了，心底慢慢绕成一声音：代码 + 设计，岂非更妙？

心念既起，按捺不住，要不学学程序？

几番寻索，目光落于 Python，一上手，迅即喜欢。

写 “hello world”，C 语言用几行代码，Python 只 1 行，多方便 ！

这般开心继续学，学着学着，一丝怀疑悄悄爬了上来：学了 Python，就算会编程吗？

“好似……不能”。

“为什么”？

说不上来，直觉而已。

<Br>

### 2.2、转向程序设计

思念起一书：

[作者评论：](https://blog.lucida.me/blog/developer-reading-list/)
>现代编程语言的语法大多很繁杂，初学者使用这些语言学习编程会导致花大量的时间在编程语言语法（诸如指针，引用和类型定义）而不是程序设计方法（诸如数据抽象和过程抽象）之上。 程序设计方法 解决了这个问题——它专注于程序设计方法，使得读者无需把大量时间花在编程语言上。这本书还有一个与之配套的教学开发环境 DrScheme，这个环境会根据读者的程度变换编程语言的深度，使得读者可以始终把注意力集中在程序设计方法上。
>
>我个人很奇怪 程序设计方法 这样的佳作为什么会绝版，而谭浩强C语言这样的垃圾却大行其道——好在是程序设计方法 第二版 已经被免费发布在网上。

文中提到的书，正是[《How to Design Programs， Second Edition》](https://htdp.org/2019-02-24/index.html)  （中文版已出，后面有链接）

言之有理，登此船，出航一试。

<Br>

### 2.3、思想 vs 工具

仅读 HTDP2e《开篇：如何编程》，心间乌云随即散去。

之前学 Python，被教程拽着走，人傻傻的。

如今读 HTDP2e，时刻需思考，心神稍松懈，立马上跟不上书中知识点。

没错！HTDP2e 授人思想，Python 无非一工具。明理与习器，气象自不同。 

坦然搁置 Python，转身步入 HTDP2e 的世界，静心细学。 

<Br>

### 2.4、仓库名称演变

2021 年，纸质书入手。

2021 年 - 2022 年，时学、时断、时续，潦草得很。

2023年，习题的答案上传至 github 上，仓库命名为**HtDP2e_exercises_solutions** ，那时深信：解出题目 = 学会。

转折之年，2024年。

慢看书，细思考，人终于静下来，问题一个个冒出来：变量名该怎么样命名？不同层级的函数该怎么样组合？测试案例到底该怎么样写？

看来，每一页纸背后的知识点，我并未抓牢。

此时此刻，再观仓库之名，刺眼。

实在记不得，具体是 2024 年几月份，仓库名由 **HtDP2e_exercises_solutions** 改为 **HtDP2e-insights** 
（期间电脑出问题，我删了提交历史，所以无法查知）

仓库名称变化，映衬内心思路转变。

之前重解题，无异于丢西瓜捡芝麻。洞察每一知识点背后的思想，才是正当路。

是以，所有答案、思路，连同我蹚过的弯路，一并奉上，愿 **你 - 我 - 他（她）** 共同进步。

<br>

### 2.5、AI 好用，可别锈了脑瓜

Github 上 HtDP2e 的资料不多，纵遇答案，难窥背后之思。想请教，该扣谁家门？

幸有 Ai 之助，概念不解，问。题目不懂，聊。

真好！

只是，Ai 已能写代码。人呢，还有必要苦哈哈学吗？

2023 年，拿不准。

2024年，高频使用 Ai ，令 Ai 理清解题思路，叫 Ai 给出关键代码，烦 Ai 修 bug ，学习突然变得简单了。

心花怒发之时，冷不防，一记耳光抽了过来。

有次 DrRacket 提示有 bug，对着一片红色报错处，不知如何下手。

往昔，每一次贪图 Ai 之便利，脑子生锈速度则快一分，学坏当真一出溜啊!

2025年，初步结论：**一味依赖 Ai，人会变蠢。**

老老实实退回来，解完题才接入 Ai ，请它指点代码，询问优化意见。

学习一事，不可骗自己。

2025 一整年，Ai 依然高速发展。不懂编程之人，辅以 Ai 之力，似亦可胜任编程之职？难道 Ai 可以代替人？

此事尚无定论，且行，且看，且思。

<br>

### 2.6、理解计算机科学

2024年底，心底又涌不安：学好 HTDP2e，一通百通吗？

“恐不能。”

为什么？又是说不清。

直至看到 **[TeachYourselfCS-CN](https://github.com/izackwu/TeachYourselfCS-CN)** ，内心一怔，计算机科学版图，竟如此广袤。HTDP2e、SICP ，属编程之基本功。其后还有：计算机系统结构，算法与数据结构，数学知识，操作系统……

一叶障目，已许久，今日见森林。步入其中，风景万千，不急，慢慢看！

<正文终>



## 3、推荐软件

### 3.1、编辑器：DrRacket 和 VSCodium

用 DrRacket 写代码效率慢，换成了 VSCodium ，VSCodium  是 VSCode 的开源版本，可以较好保护自己的隐私，看你选择。（二者的设置大体相同）

### 3.2、DrRacket 必要设置

VSCodium 和 DrRacket 相互配合使用，但有些设置需要完成。

* **首先：DrRacket 安装路径，加入环境变量。**
没填写，vscodium 会不停报错，加了之后，就不报错了。

<br>

* **其次：DrRactket 安装 racket-langserver**
DrRacket 中，点击 File -> package manager ，打开包管理器。
输入框中输入 racket-langserver，点击 install 或 update 进行安装或更新。
有时因为网络问题，可能安装不成功，多试几次。

### 3.3、VSCodium 插件

需要安装一些插件，如下：

* **Magic Racket** 
必须安装。
不安装，VSCodium 无法识别文件，会不停报错。
但有时运行，部分效果可能不支持，得返回 DrRacket 中。
 <br>

* **Markdown Preview Enhanced**
推荐安装。
markdown 插件，可以即时预览写作效果。
 <br>

* **One Dark Pro** 
 推荐安装。
 编辑器界面美化插件，打造沉浸式环境。
 <br>

* **Bookmarks**
 推荐安装。
 受限于 racket 语言，无论是 vscode 还是 vscodium，代码的 outline 效果并不好，所以采用了这个插件，手动给代码添加书签，便于快速浏览。
 <br>

* **中文标点符号转英文**
推荐安装。
这插件，适合中文环境。将中文的一些标点，转化为英文格式标点。
注意，该插件的名字是中文，就叫：中文标点符号转英文


## 4、参考资料

### 4.1、必须推荐

**[TeachYourselfCS-CN](https://github.com/izackwu/TeachYourselfCS-CN)**

见一木，更须见森林。HtDP2e 隶属编程领域，而这份文档展示了计算机科学的全景森林。

### 4.2、直接参考书籍

**英文版**：[《How to Design Programs， Second Edition》](https://htdp.org/2019-02-24/index.html)

**中文版**：[《程序设计方法（第2版）》](https://book.douban.com/subject/35222513/)

推荐阅读英文版，中文版部分翻译会有歧义。

<br>

**另一参考书**：[《代码大全2（纪念版）》](https://book.douban.com/subject/35972849/)

觉得这书真不错，稍加阅读，该书可以与书中习题结合起来用。

<br>

**进阶阅读**：[《计算机程序的构造和解释（原书第 2 版）》](https://book.douban.com/subject/1148282/) （简写为：SICP）

本书 python 版 ：[CS61A: Online Textbook](https://wizardforcel.gitbooks.io/sicp-py/content/)

本书大名鼎鼎，[TeachYourselfCS-CN](https://github.com/izackwu/TeachYourselfCS-CN) 也极力推荐阅读。

本书出了名得难，它默认阅读者已经精通代码，**不适合新手阅读**。

HTPD2e 原本就是 SICP 的前奏版，学完 HTPD2e 再读 SICP 也不迟。

### 4.3、设计编程语言

解题过程中，实在好奇，一门编程语言，该怎么设计？问了 AI，推荐了 3 本书，分别是：

[入门之选：程序设计语言概念](https://book.douban.com/subject/1699662/)

[进阶阅读：程序设计语言：设计与实现](https://book.douban.com/subject/1246842/)

[深入研究：类型和程序设计语言](https://book.douban.com/subject/1318672/)



## 5、公众号
之前，解题思路，公布至自己的公众号。

而今，github 为主，上传自己的解题思路，参考答案，随时更新；

公众号为辅，侧重发布学习笔记类，更新速度真得挺慢；

公众号二维码如下，是否关注，随意。

![公众号二维码](https://mp.weixin.qq.com/mp/qrcode?scene=10000004&size=102&__biz=Mzg2NDYxMTA4NQ==&mid=2247484136&idx=2&sn=e67efe3d83c19b6afba6bae57e3c7056&send_time=)