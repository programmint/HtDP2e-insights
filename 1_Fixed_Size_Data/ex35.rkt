; 35

; 实现
; String represents text. 信息转为数据
; string -> 1string  函数签名
; extracts the last character from a non-empty string 目的声明
; (define (sting-last str)) 函数头

; 函数示例
; given: 
    ; str 是 "How to design programs" 
; expected: 
    ; "s"

; 盘点（inventory）
; (define (sting-last str)  盘点（inventory）
;            (... str ...))

(define (string-last str)
    (substring str (- (string-length str) 1)))

(string-last "How to design programs")
