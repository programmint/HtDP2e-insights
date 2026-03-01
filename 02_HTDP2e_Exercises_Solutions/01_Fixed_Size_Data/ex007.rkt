; ex007

(define sunny #true)
(define friday #false)

(or (not sunny) friday) 

; 思路解析
; 题目条件
; 第1、不是晴天，可以去商场。
; 第2、是星期五，可以去商场。
; 满足任一条件，都可以去商场，显然使用 or 
; （注：若两个条件同时满足，用 and ）

; 结果
; 题目的最终答案是 #false
; 使用 or ，最终结果是 #false，那么两个给定的条件，都需要是 #false，最终的结果才是 #false

; 再看题目条件
(define sunny #true)    ; 结果是 ture ，需要运用否定值，也即 not 
(define friday #false)   ; 结果是 false ，可以直接用

; 表达式
; 两个条件结合起来，布尔值的嵌套，如下：
(define sunny #true)
(define friday #false)

(or (not sunny) friday) 

    