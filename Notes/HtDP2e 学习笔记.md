# htdp2e 学习笔记（更新 ing）

学习过程中，记录的一些知识点，以页码为序，一一记录。   

页码以该书为准：[《程序设计方法（第2版）》](https://book.douban.com/subject/35222513/)   
<br><br>

## 第 4 章：区间、枚举和条目（Intervals, Enumerations, and Itemizations）   

###  P75 / 4.4 区间（Intervals） 

图 4-5  显示状态行，修改后的版本   

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
这里的代码， 是 P59 第 39 题的解题思路。   

**本书特点之一，前面的问题，后面的章节会有提示。**   
<br><br>


### P75 / 4.5 条目（Itemizations）

NorF ：number or false 缩写     
<br><br>


### bigbang 基本语法规则 ?   
待补充   

<br><br>

## 第 5 章：添加结构体 Adding Structure

### P97 / 5.6 结构体编程（Programming with Structures）

这一小节的内容，直至 72 题之前的数据定义部分，可以直接和后面的 **5.7 节数据的空间**联合起来读，然后再跳回来解题。 

这一节谈到了结构体数据定义。   

这里还要参考另外一定义，即：结构体类型定义（Defining Structure Types） 

位于 P91  

<br><br>

### P102 / 5.7 数据的空间（The Universe of Data）

本小节第 1- 3 段话的意义，会在 78 题和 79 题得以体现，讲明了数据定义的重要原因所在。

#### check-expect 的语法
( check-expect **actual-value**  **expected-value** )   
<br><br>


## 第 6 章 条目和结构体
### P111 / 本章第一段话，语句难解   

中文   
由于数据表示的开发是正确的程序设计的起点，**因此程序员经常需要使涉及结构体的数据定义条目化或使用结构体来组合条目化数据，** 这并不令人惊讶。

粗文体部分，翻译后的中文，不易懂，这个长句需要意译。

难解的语句，另有文档记录，请参阅 [HtDP2e 文句校对录 - 明晰难解之句](https://github.com/programint/HtDP2e-insights/blob/main/Notes/HtDP2e%20%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95%20-%20%E6%98%8E%E6%99%B0%E9%9A%BE%E8%A7%A3%E4%B9%8B%E5%8F%A5.md)


