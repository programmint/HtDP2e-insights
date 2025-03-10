; 15

; 这个题目，很长一段时间，我都解不对。

; 思路推导
; 这题目看上去与第 7 题一致，实则不然。
; 第 7 题 清晰给了条件和结果，推导过程。
; 这题目给了模糊的条件，也给了模糊的结果，需要推导中间过程。
; 模糊与清晰，二者差异极大。
  
; 什么是模糊？

; 第1、条件模糊
; 函数用到两个布尔值，是 #ture 还是 #false，没有明确说明，条件模糊。

; 第2、结果模糊
; 题目讲，如果 sunny 是 #false 或者 friday 为 #ture ，那么结果是 #ture ，那么 sunny 是  #ture 或者 friday 为 #false，那么结果是什么？
; 没有讲，所以，我称之为结果也模糊。
; 只要是看到 “或者” 一词，就明确了，函数应该是使用 or 了。

; 参考思路
(define sunny #false)  
(define friday #true)

(define (==> sunny friday)
  (or (not sunny) friday))

(==> sunny friday)

; 这参考答案，不能说错，仅仅从解题来说，可以出最终的结果，但稍显狭隘。
; sunny 和 friday ，到底是怎么样的布尔值，没有明确讲，所以这里只使用了一种布尔值，狭隘了。
; 看题意：如果 sunny 是 #false 或者 friday 为 #ture ，那么结果是 #ture


; 推导表达式

; （#false #ture）; #ture 
; 那么肯定是用 or，即:
;（or #false #ture）; #ture 

; 既然如此，如下：
;（ or #ture #ture）; 肯定也是 #ture

; 这时函数的表达式，其实已经出来了
(or (not variable1) variable2)

; 当然了，这表达式，反过来也可以
(or variable1 (not variable2))

; 定义常量
; 前面已讲，sunny 和 Friday 到底是什么布尔值，并没有清晰告知，所以：
(define sunny #false)  
(define friday #true)

; 采用这种方式，不能把所有的布尔值都包含进去
; 也就是说，该题目，不必定义常量，而是把各个布尔值，直接引用就好了。

; 注:
; ==> 函数，本地不能运行
; 定义==>这个函数，本地不断报错，后面的 24 题也是这样。