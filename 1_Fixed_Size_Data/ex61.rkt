; 61

; 这题目其实是一选择题

; 数字定义常量 
(define RED 0)
(define GREEN 1)
(define YELLOW 2)

; 字符串定义常量 
(define RED "red")
(define GREEN "green")
(define YELLOW "yellow")

; yields the next state, given current state cs
; S-TrafficLight -> S-TrafficLight
(check-expect (tl-next- ... RED) GREEN)
(check-expect (tl-next- ... YELLOW) RED)
    
; 方式 1
(define (tl-next-numeric cs)
  (modulo (+ cs 1) 3))
     
; 方式 2
(define (tl-next-symbolic cs)
  (cond
    [(equal? cs RED) GREEN]
    [(equal? cs GREEN) YELLOW]
    [(equal? cs YELLOW) RED]))

; 结论
; 不必使用 drracket 来验证，也可以推论出来，改变了常量的定义，方式 2 依旧可以继续运行
; 显然方式 2 更符合条目的设计思路。

