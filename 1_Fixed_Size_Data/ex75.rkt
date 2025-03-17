; 75

; 该题是考察“愿望清单”的运用
; 即：考察复杂函数的“构思-实现”过程


; vel 是结构体 (x/y 方向的各自速度)
(define-struct vel [deltax deltay])

; UFO 是结构体 (位置 + 速度)
(define-struct ufo [loc vel])
; A UFO is a structure: 
;   (make-ufo Posn Vel)
; interpretation (make-ufo p v) is at location
; p moving at velocity v

; 常量
; 测试用数据
(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))
 
(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

; wish list 思考过程
    ; 复杂程序，不可能一次性完成，而是多次思考，多次完善而成。
    ; HtDP2e 是用记录愿望（making a wish）的方式来完成。

    ; 所谓愿望，就是分步编程的思路，先写高层函数，再写底层函数。
    ; 某个底层函数，如果是一辅助函数，暂时用占位符表示。

    ; (define (ufo-move-1 u) u)  初始主函数（占位符）
    ; (define (posn+ p v) p)  初始辅助函数。

    ; 也即，思考题目时，先把思考过程写下来，后面再去完善。


; wish list

; 主函数
; 每次时钟滴答后，计算 u 会移动到哪里？
; UFO -> UFO
; 保持速度不变
(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2)
              (make-ufo (make-posn 17 77) v2))

(define (ufo-move-1 u)
    (make-ufo
        (posn+ (ufo-loc u) (ufo-vel u)) ; 调用辅助函数，将 loc 及 vel 传递给辅函数，辅函数会计算出新位置      
        (ufo-vel u)))  ; 速度保持不变 

; 辅函数
; 将 v 加到 p 上，主函数会调用这个值
; 依据速度，求出新位置，即：位置 + 速度 = 新位置
; Posn Vel -> Posn
(check-expect (posn+ p1 v1) p2)
(check-expect (posn+ p1 v2) (make-posn 17 77))

(define (posn+ p v)
    (make-posn
        (+ (posn-x p) (vel-deltax v))
        (+ (posn-y p) (vel-deltay v))))

