# htdp2e 学习随记 - 疑问/重点/心得-合集

学习过程中，所遇知识点，或疑问，或重点，或心得，逐一记录。

记录形式：   
>章节(章标题-子标题)
>
>知识点标题（或疑问，或重点，或心得，或其他）   
>
>页码   
>
>具体知识点   

页码以该书为准：[《程序设计方法（第2版）》](https://book.douban.com/subject/35222513/) 
  
<br>

## 第 3 章、程序设计方法 （How to Design Programs）  

#### 重点：bigbang 语法规则   

bigbang 第 2 章就引入了，题目多集中在第 3 章，一系列练习题，都需要熟悉 bigbang 的语法规则，方可解题。   

这一章节，我是吃了大亏，若无 Ai 相助，无法顺利完成题目。

需要画图，待补充。

<br>

#### 47 题：增加与减少的区别

按下向下箭头，其数值，到底是增加还是减少，纸质版与网络版有区别：

中文版   

>习题47 
>
>设计维护并显示“快乐指数”的世界程序，称其为 gauge-prog，并假设程序读入快乐的最大程度。度量显示从最大快乐指数开始，每次时钟滴答，快乐指数以 -0.1 降低，它永远不会低于最低的快乐指数 0。每按一次向下箭头键，快乐指数就 **增加 1/5**；每按一次向上箭头键，快乐指数就增加 1/3。
>

很清晰，这里讲的是：增加。

<br>

查证英文纸质版图书，内容则是：

>Exercise 47. 
>
>Design a world program that maintains and displays a “happiness gauge.” Let’s call it gauge-prog, and let’s agree that the pro-gram consumes the maximum level of happiness. The gauge display starts with the maximum score, and with each clock tick, happiness decreases by -0.1; it never falls below 0, the minimum happiness score. Every time the down arrow key is pressed, happiness **increases** by 1/5; every time the up arrow is pressed, happiness jumps by 1/3.
>

同样，也是很清晰，依旧是：增加（increases）

<br>

网络版 htdp2e，内容则有小小变化：

>Exercise 47. 
>
>Design a world program that maintains and displays a “happiness gauge.” Let’s call it gauge-prog, and let’s agree that happiness is a number between 0 and 100 (inclusive).
>
>The gauge-prog program consumes the current level of happiness. With each clock tick, the happiness level decreases by 0.1; it never falls below 0 though. Every time the down arrow key is pressed, happiness **decreases** by 1/5; every time the up arrow is pressed, happiness jumps by 1/3.
>

同样是按下向下箭头，网络版则变成了减少（decreases）   

<br>

**推论：**   

网络版内容，可以实时更新，期间估计是接受了建议，这里改为了减少。

采用减少更加容易理解，呈现出的图像也更加明显。

就题论题，47题这里，无论是增加还是减少，区别不大。

是以，我解该题时，依旧是采用了增加的计算方法。

<br>

## 第 4 章、区间、枚举和条目（Intervals, Enumerations, and Itemizations）   

### 4.4、区间（Intervals）
#### 心得：前面问题的提示答案
***P75***  
~~~
; WorldState -> Image
; adds a status line to the scene created by render  
    
(check-expect (render/status 42)
                (place-image (text "closing in" 11 "orange")
                            20 20
                            (render 42)))
    
(define (render/status y)
    (place-image
    (cond
        [(<= 0 y CLOSE)
        (text "descending" 11 "green")]
        [(and (< CLOSE y) (<= y HEIGHT))
        (text "closing in" 11 "orange")]
        [(> y HEIGHT)
        (text "landed" 11 "red")])
    20 20
    (render y)))

Figure 24: Rendering with a status line, revised

~~~   
图 4-5  显示状态行，修改后的版本   


这里的代码， 是 P59 第 39 题的解题思路。   

***本书特点之一，前面的问题，后面的章节会有提示。*** 

<br>


### 4.5、条目（Itemizations）

#### 疑问：NorF 什么意思？

***p75*** 

NorF ：number or false 缩写   

<br>

## 第 5 章、添加结构体 Adding Structure

### 5.4、定义结构体类型（Defining Structure Types）

#### 疑问：ball1 or balll ？ 

***P93***   

这一部分，得截图上来，待补。 

<br>

### 5.6、结构体编程（Programming with Structures）

#### 心得：结构体的数据定义
***P97***

这一小节的内容，直至 72 题之前的数据定义部分，可以直接和后面的 ***5.7 节数据的空间*** 联合起来读，然后再跳回来解题。 

另：这一节谈到了结构体数据定义。   

这里还要参考另外一定义，即：结构体类型定义（Defining Structure Types） 

结构体类型定义，位于 P91 。

<br>


### 5.7、数据的空间（The Universe of Data）

#### 心得：结构体数据定义的意义
***P102***

本小节第 1- 3 段话的意义，会在 78 题和 79 题得以体现，讲明了数据定义的重要原因所在。   
<br><br>

**心得：check-expect 的语法**

( check-expect ***actual-value***  ***expected-value*** )  

经常忘记 check-expect 用法，特意查了一下。 

<br>    

### 5.8、结构体的设计（Designing with Structures）

#### 疑问：r3 与 R3 区别何在？
***P105*** 

问了 deepseek ，答复如下：

<br>

**第 1、结构体名称 (r3，小写）**

**语法定义** ：(define-struct r3 [x y z])
这是结构体类型的构造函数名称，遵循 Racket 的命名惯例（通常小写+短横线分隔）。

**用途：** 用于创建具体的结构体实例，例如：

~~~
(make-r3 1 2 3)  ; 构造一个 r3 实例
(r3? some-value) ; 检查是否为 r3 结构体
(r3-x a-point)   ; 访问字段 x
~~~

**本质：** 这是代码中实际操作的“工具名”，与语法直接绑定。

<br>

**第 2. 数据定义名称 (R3，大写）**   

**数据定义注释：**
~~~
; An R3 is a structure:
;   (make-r3 Number Number Number)
~~~
这是程序员自定义的数据类型名称，表示“所有合法的三维点”的集合。它遵循 HTDP 的约定（首字母大写），目的是：

**语义清晰：** 明确这是一个“数据类型”，而不仅仅是一个结构体。

**抽象层级：** 数据定义可能包含更复杂的约束（例如“所有 r3 实例，且其字段均为数字”），而不仅仅是结构体本身的语法定义。

**本质：** 这是程序员对数据的逻辑描述，是设计文档的一部分，而非语法的一部分。

<br>

**为什么不能统一用小写？**  

**技术必要性：**

Racket 语法要求结构体构造函数（如 make-r3）和类型检查（如 r3?）必须用小写命名，这是语言规范。

数据定义（如 R3）是程序员自定义的注释名称，不受语法限制，但需遵循可读性约定。

**设计意图：**

**区分抽象与实现：**

**r3**（小写）是具体的结构体操作（代码实现）。

**R3**（大写）是抽象的数据类型（设计文档）。

**避免混淆：**

例如，当看到 R3 时，程序员知道它代表逻辑上的“三维点”概念；而 r3 是操作这个概念的语法工具。

<br>

**HTDP 的设计哲学**

HTDP 强调数据定义与代码实现的分离：

**第 1、数据定义**（如 R3）描述“合法数据是什么”。

**第 2、结构体定义**（如 r3）描述“如何构造和操作数据”。

这种分离让程序更易理解和维护。例如，若未来需要扩展 R3（如增加约束条件），只需修改数据定义，而不必重写结构体代码。

<br><br>

### 5.10、图形编辑器（A Graphical Editor）

#### 疑问：s 和 t 代表什么意思？
***P108***  
~~~
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t
~~~

其中 （make-editor s t）的 s 和 t 是两个单词的缩写吗？

问了 Ai （claude）：

~~~
在程序设计中，特别是函数式编程语言中，常常使用单个字母作为变量名，尤其是在描述数据类型和函数签名时。

在这里：

s 简单地代表"字符串1"（用于存储光标前的文本）
t 简单地代表"字符串2"（用于存储光标后的文本）

这些只是惯用的变量名选择，在计算机科学中使用单字母变量名（如 x, y, s, t 等）是很常见的。它们没有特定的全称或扩展含义，只是在定义数据类型时选择的参数名称。

如果要赋予它们更有意义的名称，可以将它们视为：

s = string before cursor (光标前的字符串)
t = text after cursor (光标后的字符串)
~~~

**结论：**  

 s 和 t 只是常见的惯用变量名选择，没有特殊的含义，主要是为了区分不同的参数。

<br>

#### 疑问：文字大小到底是 16 还是 11 ？
***P108***  

第 83 题是说使用 16 号字符串，可是示例代码中，又使用了 11 号字体。

**个人理解：**

估计是更新内容时，示例代码处忘了更新，所以第 83 题，凡是涉及到字体大小，一律 16 号。

<br>

### 总结：结构体的方方面面

#### 总结 1、结构体之两个层面定义

第1、结构体类型定义。  

    目的：机器可执行   

    主要是创建一种新的数据类型，告诉计算机如何构造和操作这种新型数据。


>*注：结构体定义，详见 HtDP2e 中文版，P91，5.4 定义结构体类型，这里讲解了结构体的类型定义。*   

<br>

第2、结构体数据定义   

    目的：人类可理解。   

    主要是通过注释，解释该结构体的语义，告诉人类数据的含义是什么，以及如何正确使用

>*注：HtDP2e 中文版 P97，5.6 结构体的编程，这里讲解了结构体的数据定义。* 

这两层面的定义，最后都整合到结构体程序设计中。

<br>

#### 总结 2、结构体注释的作用
相比之前，结构体的注释，量多，还复杂。

注释的主要作用如下：   

对机器约束：语法层，如何构造和处理数据。   

对人约束：语义层，数据的意义和正确用法。

注释其实就是“设计契约”，把“语义描述”与“语法规则”进行了双向绑定。

<br>

#### 总结 3、理解 HtDP2e 的思路

到了第 5 章，隐隐约约感觉出：HtDP2e 的核心，是数据驱动设计。   
***HtDP2e 核心理念：程序设计的本质，是数据设计。***   

但从HtDP2e 的完整设计思路来说，总共包含 3 个层面:

第 1、数据定义：明确信息与数据之间的相互转化关系。

第 2、函数设计：模板化操作数据。（数据定义驱动了函数模板）

第 3、测试验证：确保数据和函数符合预期结果。（测试、验证数据和函数是不是一致）
<br><br>

***HtDP2e 的完整设计思路***   

数据定义 → 函数签名/目的声明 → 示例/测试 → 函数模板 → 代码实现 → 测试验证
<br><br>


## 第 6 章：条目和结构体（Itemizations and Structures）

#### 文句校对：本章第一段话，语句难解   
***P111***
>中文
>   
>由于数据表示的开发是正确的程序设计的起点，***因此程序员经常需要使涉及结构体的数据定义条目化或使用结构体来组合条目化数据，*** 这并不令人惊讶。
>

粗文体部分，翻译后的中文，不易懂，这个长句需要意译。

想表述的意思是：

条目和结构体可以相互转化


即：把结构体当成元素，转换为条目 。或者 组合多个条目，转化为结构体。

毫无疑问，到了第 6 章，数据开始变复杂了。

<u>其他难解语句，另有文档记录，请参阅 [HtDP2e 文句校对录 - 明晰难解之句](https://github.com/programint/HtDP2e-insights/blob/main/Notes/HtDP2e%20%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95%20-%20%E6%98%8E%E6%99%B0%E9%9A%BE%E8%A7%A3%E4%B9%8B%E5%8F%A5.md)</u>

<br>

#### 疑问：SIGS 代表了什么?
***P112***   

Space Invaders Game State 太空入侵者游戏状态的缩写

看中文版图书的弱点，有时不容易获知某些缩写的意思。
