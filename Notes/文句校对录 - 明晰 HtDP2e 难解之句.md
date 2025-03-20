# 文句校对录 - 明晰 HtDP2e 难解之句 

**说明**

htdp2e 的中文版，即：程序设计方法(第 2 版) ，里面某些词，或语句，阅读时，别扭，难以理解。

通常，比对英文原文，看中文之意，是否符合英文原意。

所遇问题，一一记录于此。结合原文，或加以修正，或请英文专业朋友指正，或请教 Ai 指正。

另：我非英文专业，以下记录，可能还会有问题。（本文持续更新）

**若有瑕，敬请指正。**   

\------   

### P93 ball1 or balll ？

这一部分，得截图上来，否则，不容易理解。后面补。

\------   

### P94 in two ways 翻译有误 

>中文  
> 
>5.5 结构体的计算   
>
>结构体类型**在两种意义上**是笛卡儿坐标点的一般化。首先，结构体类型可以指定任意数量的字段：0个、1个、2个、3个等。其次，结构体类型为字段命名，而不是为字段编号。这有助于程序员阅读代码，因为要记住姓氏在名为last-name的字段中，比记住它在第7个字段中要容易得多。
>
>English 
>  
>5.5 Computing with Structures 
>
>Structure types generalize Cartesian points **in two ways.** First, a structure type may specify an arbitrary number of fields: zero, one, two, three, and so forth. Second, structure types name fields, they don’t number them.This helps programmers read code because it is much easier to remember that a family name is available in a field called last-name than in the 7th field.

**修改: in two ways 应该翻译为：用两种方式 or 以两种方式**

一是，句意对接不上后面的 First ，Second

二是， 结构类型以两种方式泛化笛卡尔坐标点 ……，这样子更容易理解。 

\------   



### P100：怎么理解长句？
>中文
>   
>示例问题：你的团队正在设计一个游戏程序，**它跟踪以变化的速度在画布上移动的物体.**
>
>English
>   
>Sample Problem Your team is designing a game program **that keeps track of an object that moves across the canvas at changing speed.**

这句子，读一次,实在不解其意。

看英文，其实是一复合句，英文文法之下，各子句，各负其责，丝毫不乱。

但不能直接译为中文，中文，特别是古汉语，没有英文那种形式语法，英文长复合句，硬译为一句话，观者往往不易懂。

传统汉语，依靠语意串句，所以上述复合句，拆成几个短句即可。

**修改：追踪一物体，该物体正移动穿越画布，其速度则不断变化** (意译法)

\------   



### P102 须删一多余词：我们

>中文 
>  
>因为 ufo-move-1 和 posn+ 都是完整的定义，**我们我们**甚至可以单击“运行”按钮，以检查DrRacket是否会抱怨我们到目前为止所做的工作中有语法问题。
>
>Englsih
>
>Because ufo-move-1 and posn+ are complete definitions,**we can even click RUN,** which checks that DrRacket doesn’t complain about grammatical problems with our work so far. 
>
**修改：删除一“我们”**
\------   

### P104 ”语用“一词：该加注释

>中文
>
>就数据定义的**语用**而言，结构体类型的数据定义通过组合现有数据定义与实例来描述大数据集合。
>
>English   
>
>As far as the **pragmatics** of data definitions is concerned, a data definition for structure types describes large collections of data via combinations of existing data definitions with instances.
>
“语用”一词，实在不知道讲什么。

结合本句来理解：   

它讨论的 **不是** 数据定义应该是什么（语义层），而是 **如何通过结构体组合现有数据类型** 来 **实际操作**（比如创建实例、约束函数输入输出），从而在代码中 **具体实现** 对复杂数据集合的描述。（from deepseek）

也就是说，"语用"（pragmatics） 强调数据定义，在实际编程中的 **具体应用方式**，而非单纯的理论描述。
\------   



### P111 长句难解   

>第一段第一句  
>
>中文
>  
>由于数据表示的开发是正确的程序设计的起点，**因此程序员经常需要使涉及结构体的数据定义条目化或使用结构体来组合条目化数据，** 这并不令人惊讶。
>
>英文   
>
>Since the development of data representations is the starting point for proper program design, it cannot surprise you that **programmers frequently want to itemize data definitions that involve structures or to use structures to combine itemized data.**
>
粗文体部分，翻译后的中文，不易懂，这个长句需要意译。

而这段话，恰恰又是第 6 章的中心思路，所以这一段文字，想表述的意思：

**条目和结构体可以相互转化** 

（这话，deepseek 认为表述不精准，而是：数据抽象的双向构建过程。暂时还没有学到抽象，留此，待验证）

即：**把结构体当成元素，转换为条目** 。或者 **组合多个条目，转化为结构体。**

毫无疑问，到了第 6 章，数据开始变复杂了。   

\------   