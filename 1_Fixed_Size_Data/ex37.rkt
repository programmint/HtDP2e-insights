; 37

; 实现思路
; String represents text . 信息转为数据
; string -> string  函数签名
; Remove the last character and keep the rest 目的声明
; (define (string-remove-last str)) 函数头

; 函数示例
; given: 
    ; str 是 "How to design programs" 
; expected: 
    ; "ow to design programs" 

; 盘点（inventory）
; (define (sting-rest str)  
;            (... str ...))

(define (sting-rest str)  
        (substring str 1))

(sting-rest "How to design programs") 

