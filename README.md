# 学程序设计方法：当学其思想

### 1、暂时弃学 Python 

我所从事的岗位，名为：产品经理。这职位擅长的技能，是设计。

工作中时时刻刻和代码打交道。时日久了，总觉得：若懂代码，定会获益良多。

是以，该学一学程序。

最终选了 Python，一上手，迅即喜欢。

写 “hello world”，C 语言用几行代码，Python 只 1 行，多方便 ！

伴随学习，一问题慢慢浮现：学了 Python ，可以写好程序吗？

“不能”。

“为什么”？

直觉而已，回答不出为什么。
<br><br> 

### 2、转向程序设计

思念起一本书：

[作者评论：](https://blog.lucida.me/blog/developer-reading-list/)
>现代编程语言的语法大多很繁杂，初学者使用这些语言学习编程会导致花大量的时间在编程语言语法（诸如指针，引用和类型定义）而不是程序设计方法（诸如数据抽象和过程抽象）之上。 程序设计方法 解决了这个问题——它专注于程序设计方法，使得读者无需把大量时间花在编程语言上。这本书还有一个与之配套的教学开发环境 DrScheme，这个环境会根据读者的程度变换编程语言的深度，使得读者可以始终把注意力集中在程序设计方法上。
>
>我个人很奇怪 程序设计方法 这样的佳作为什么会绝版，而谭浩强C语言这样的垃圾却大行其道——好在是程序设计方法 第二版 已经被免费发布在网上。

文中提到的书，正是[《How to Design Programs， Second Edition》](https://htdp.org/2019-02-24/index.html)  （中文版已出，后面有链接）

跟着此书，学学看？
<br><br> 

### 3、思路 vs 工具
之前跟着教程学 Python，你说什么，我做什么，人傻傻的。

可到了 Htdp2e ，时刻需思考，否则跟不上书里的知识点。

差异巨大 ！！！

程序背后的设计思想，才是重点所在。

编程语言，只是一工具。思想指导工具，才能写好代码。

是以，毫不犹豫，暂学 python，转向程序设计。
<br><br> 

### 4、仓库历史
2021 年购得《程序设计方法（第2版）》

2021 年 - 2022 年，其间学习状态，时学、时断、时续，往复循环，潦草得很。

2023年，开始把习题的答案，上传到 github 上，仓库名为：**HtDP2e_exercises_solutions** ，观名而知：那时重解题，认为：解出题目 = 掌握了知识点。

2024年，开始认真学习，发现有些题目，参考别人代码，还是理不出个头绪。

这是怎么回事，另外，仓库名字似乎也不对？

实在记不得，具体是 2024 年几月份，仓库名由：**HtDP2e_exercises_solutions --> HtDP2e-insights** 
（期间电脑出问题，我删了提交历史，所以无法查知）

仓库名称变化，映衬内心变化。 

每一题，重在洞察背后的设计思想。一味求快解题，无异于丢了西瓜捡芝麻。

有些题目解题思路，含错误思路，用注释写出来，包括笔记，都会同步上来，愿 **你 - 我 - 他（她）** 共同进步。
<br><br> 


### 5、AI 是好用，可别锈了脑瓜
讨论 HtDP2e 的资料不多，幸亏有 Ai 之助，不然，好多知识点不理解，好些题目也解不开。

Ai 几分钟内，写出一俄罗斯方块游戏，我却经常看不懂题目。

那，继续学程序设计，有此必要吗？

2023年时，拿不准这问题。

2024年，高频使用 Ai ，令 Ai 理清解题思路，叫 Ai 给出关键代码，烦 Ai 修 bug ，学习突然变得简单了。

有次 DrRacket 提示我有 bug，我看了半天，居然不知道为何犯错，人惊醒：不能偷懒。

2025年，初步结论：**一味依赖 Ai，人会变蠢。**

老老实实退回来，解题思路，一行行代码，自己来，不容 Ai 插手。

解完题，才接入 Ai ，请它指点代码，询问优化意见。
<br><br> 


### 6、理解计算机科学
2024年底，开始问自己：学完 Htdp2e ，一通百通吗？

不行。

为什么？又是说不清。

后来看到 **[TeachYourselfCS-CN](https://github.com/izackwu/TeachYourselfCS-CN)** ，震惊、诧异，计算机科学内容如此之多。

HtDP2e 也好，SICP 也罢，都隶属编程部分，计算机科学的组成部分之一，而非全部，当然不能一通百通。

仅学其一，不够不全面。

曾试着将 HtDP2e 与 SICP 并行，可惜，效果不好，SICP 确实有难度，我基础未牢，勿贪多。

2025年，心思又动，HtDP2e、《计算机系统要素》、数据库，试试三者并行，或许可以。

（注：SICP，即：《计算机程序的构造和解释（原书第 2 版），TeachYourselfCS-CN 有详细介绍）


>后补
>
>我问 Ai ：这三块结合起来，一起学，可以吗？
>
>Ai 答：现在最好集中精力学 HtDP2e ，其他先放一放。
>
>好，我听劝，不过有一点扎心。


### 7、所用软件
#### 7.1、编辑器：DrRacket 和 VSCodium 

用 DrRacket 写代码效率慢，换成了 VSCodium 

VSCodium  是 VSCode 的开源版本，可以较好保护自己的隐私，看你选择。（二者的设置大体相同）

VSCodium 和 DrRacket 相互配合使用，但 **DrRacket 有些设置，需要完成：**
>
>  #### 7.1.1、DrRacket 安装路径，加入环境变量
> 
>   没填写，vscodium 会不停报错，加了之后，就不报错了。
> 
>   #### 7.1.2、DrRact 安装 racket-langserver
> 
>   DrRacket 中，点击 File -> package manager ，打开包管理器。
> 
>   输入框中输入 racket-langserver，点击 install 或 update 进行安装或更新。
> 
>   有时因为网络问题，可能安装不成功，多试几次。
>

#### 7.2、VSCodium 插件

需要安装一些插件，如下：
> 
> #### 7.2.1、Magic Racket 
> 
> 必须安装。
> 
> 不安装，VSCodium 无法识别文件，会不停报错。
>
> #### 7.2.2 、Code Runner 
> 
> 推荐安装。
> 
> 运行代码用，但有些效果它运行不了，得返回 DrRacket 中。
> 
> #### 7.2.3 、MarKdown All in One 
> 
> 推荐安装。
> 
> markdown 插件，可以即时预览写作效果。看你选择。
> 
> #### 7.2.4 、One Dark Pro 
> 
> 推荐安装。
> 
> 编辑器界面美化插件，打造沉浸式环境。看你选择。
> 


### 8、参考资料及其他

#### 8.1、参考书籍

英文版：[《How to Design Programs， Second Edition》](https://htdp.org/2019-02-24/index.html)

中文版：[《程序设计方法（第2版）》](https://book.douban.com/subject/35222513/)

另外一参考书籍：[《代码大全2（纪念版）》](https://book.douban.com/subject/35972849/)

觉得这书真不错，稍加阅读，该书可以与书中习题结合起来用。

进阶阅读：大名鼎鼎的[《计算机程序的构造和解释（原书第 2 版）》](https://book.douban.com/subject/1148282/) （简写为：SICP）

本书 python 版 ：[CS61A: Online Textbook](https://wizardforcel.gitbooks.io/sicp-py/content/)

解题过程中，实在好奇，一门编程语言，该怎么设计？问了 AI，推荐了 3 本书，分别是：

[入门之选：程序设计语言概念](https://book.douban.com/subject/1699662/)

[进阶阅读：程序设计语言：设计与实现](https://book.douban.com/subject/1246842/)

[深入研究：类型和程序设计语言](https://book.douban.com/subject/1318672/)

学习程序设计，可不仅仅只是思想，编程语言，而是一堆东西，可以参考下面的资料：自学计算机科学

**[TeachYourselfCS-CN](https://github.com/izackwu/TeachYourselfCS-CN)**   

#### 8.2 、公众号
之前，解题思路，公布至自己的公众号。

而今，

github 为主，上传自己的解题思路，参考答案，随时更新；

公众号为辅，侧重发布学习笔记类，更新速度慢；

公众号二维码如下，是否关注，随意。

![公众号二维码](https://mp.weixin.qq.com/mp/qrcode?scene=10000004&size=102&__biz=Mzg2NDYxMTA4NQ==&mid=2247484136&idx=2&sn=e67efe3d83c19b6afba6bae57e3c7056&send_time=)