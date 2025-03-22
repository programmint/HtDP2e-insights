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

## 第 3 章：程序设计方法 （How to Design Programs）  

#### 重点：bigbang 语法规则   

bigbang 第 2 章就引入了，题目多集中在第 3 章，一系列练习题，都需要熟悉 bigbang 的语法规则，方可解题。   

这一章节，我是吃了大亏，若无 Ai 相助，无法顺利完成题目。

需要画图，待补充。

<br><br>

## 第 4 章：区间、枚举和条目（Intervals, Enumerations, and Itemizations）   

### 4.4 区间（Intervals）
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


### 4.5 条目（Itemizations）

#### 疑问：NorF 什么意思？

***p75*** 

NorF ：number or false 缩写     
<br><br>

## 第 5 章：添加结构体 Adding Structure

### 5.4 定义结构体类型（Defining Structure Types）

#### 疑问：ball1 or balll ？ 

***P93***   

这一部分，得截图上来，待补。   

<br><br>

### 5.6 结构体编程（Programming with Structures）

#### 心得：结构体-数据定义，结构体-类型定义

***P97***


这一小节的内容，直至 72 题之前的数据定义部分，可以直接和后面的 ***5.7 节数据的空间*** 联合起来读，然后再跳回来解题。 

另：这一节谈到了结构体数据定义。   

这里还要参考另外一定义，即：结构体类型定义（Defining Structure Types） 

结构体类型定义，位于 P91 。  

<br><br>


### 5.7 数据的空间（The Universe of Data）

#### 心得：结构体数据定义的意义

***P102***

本小节第 1- 3 段话的意义，会在 78 题和 79 题得以体现，讲明了数据定义的重要原因所在。   
<br><br>

心得：check-expect 的语法

( check-expect ***actual-value***  ***expected-value*** )  

经常忘记 check-expect 用法，特意查了一下。 

<br><br>  

### 5.8 结构体的设计（Designing with Structures）

#### 疑问：r3 与 R3 区别何在？

***P105***  
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


