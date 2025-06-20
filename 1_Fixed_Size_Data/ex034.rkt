; ex034

; 题目里讲，不要使用非空字符串，做练习时，恰恰忽略了这一点，偏偏要考虑空字符串的问题。
; 表面上思路考虑完备，实则审题不严格。

; 实现
; String represents text. 信息转为数据

; 注
; 单个函数，可以不写，和后面的“目的声明”（a statement of purpose），语意上有一点重复
; 复合函数，主函数和辅助函数分工，各有不同，这一步则要写。

; string -> string  函数签名
; 统计多少个输入、输出

; returns the first character from a non-empty string 目的声明，一行足矣！
; 注
; 从第39题开始，目的提到最开始的位置，形成思路大纲，同时也是 checklist

; (define (sting-first str))
; 函数头，也即函数的简单定义

;  函数示例
; given: 
    ; str 是 "How to design programs" 
; expected: 
    ; "H"
; 函数示例，为了说明“函数签名”和“目的声明”

; 盘点（inventory）
; (define (sting-first str)  
;            (... str ...))
; 有了函数头，有了输入输出，把函数组合起来，到了这一步，等于把函数写了出来；

(define (string-first str)
    (substring str 0 1))
    
(string-first "How to design programs")
