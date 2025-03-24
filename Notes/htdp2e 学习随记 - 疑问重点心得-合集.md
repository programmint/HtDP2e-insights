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
<br><br>

## 第 3 章、程序设计方法 （How to Design Programs）  

#### 重点：bigbang 语法规则   

bigbang 第 2 章就引入了，题目多集中在第 3 章，一系列练习题，都需要熟悉 bigbang 的语法规则，方可解题。   

这一章节，我是吃了大亏，若无 Ai 相助，无法顺利完成题目。

需要画图，待补充。

<br><br>

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
<br><br>


### 4.5、条目（Itemizations）

#### 疑问：NorF 什么意思？

***p75*** 

NorF ：number or false 缩写     
<br><br>

## 第 5 章、添加结构体 Adding Structure

### 5.4、定义结构体类型（Defining Structure Types）

#### 疑问：ball1 or balll ？ 

***P93***   

这一部分，得截图上来，待补。   

<br><br>

### 5.6、结构体编程（Programming with Structures）

#### 心得：结构体的数据定义

***P97***


这一小节的内容，直至 72 题之前的数据定义部分，可以直接和后面的 ***5.7 节数据的空间*** 联合起来读，然后再跳回来解题。 

另：这一节谈到了结构体数据定义。   

这里还要参考另外一定义，即：结构体类型定义（Defining Structure Types） 

结构体类型定义，位于 P91 。  

<br><br>


### 5.7、数据的空间（The Universe of Data）

#### 心得：结构体数据定义的意义

***P102***

本小节第 1- 3 段话的意义，会在 78 题和 79 题得以体现，讲明了数据定义的重要原因所在。   
<br><br>

心得：check-expect 的语法

( check-expect ***actual-value***  ***expected-value*** )  

经常忘记 check-expect 用法，特意查了一下。 

<br><br>  

### 5.8、结构体的设计（Designing with Structures）

#### 疑问：r3 与 R3 区别何在？

***P105***  
<br><br>


### 5.9、总结：结构体的方方面面
#### 5.9.1、结构体之两个层面的定义

第1、结构体类型定义。  

    目的：机器可执行   

    主要是创建一种新的数据类型，告诉计算机如何构造和操作这种新型数据。
<br><br>
第2、结构体数据定义   

    目的：人类可理解。   

    主要是通过注释，解释该结构体的语义，告诉人类数据的含义是什么，以及如何正确使用

这两层面的定义，最后都整合到结构体程序设计中。
<br><br>

#### 5.9.2、结构体注释的作用
相比之前，结构体的注释，量多，还复杂。

注释的主要作用如下：
对机器约束：语法层，如何构造和处理数据。
对人约束：语义层，数据的意义和正确用法。

注释其实就是“设计契约”，把“语义描述”与“语法规则”进行了双向绑定。
<br><br>

#### 5.9.3、理解 HtDP2e 的思路
到了第 5 章，已经隐隐约约感觉出：HtDP2e 的核心，是数据驱动设计。   

***HtDP2e 核心理念：程序设计的本质，是数据设计。***

但从HtDP2e 的完整设计思路来说，总共包含 3 个层面:

第 1、数据定义：明确信息与数据之间的相互转化关系。

第 2、函数设计：模板化操作数据。（数据定义驱动了函数模板）

第 3、测试验证：确保数据和函数符合预期结果。（测试、验证数据和函数是不是一致）

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

<u>难解的语句，另有文档记录，请参阅 [HtDP2e 文句校对录 - 明晰难解之句](https://github.com/programint/HtDP2e-insights/blob/main/Notes/HtDP2e%20%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95%20-%20%E6%98%8E%E6%99%B0%E9%9A%BE%E8%A7%A3%E4%B9%8B%E5%8F%A5.md)</u>


