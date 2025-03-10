; 73-74

; == 题目背景 == 
; 这两题目是一个题目，代码放在一起了。
; 游戏结束后，增加提示文案：游戏结束了。增加这一条件，代码变复杂了。

; A Posn represents the state of the world

; 图形常量

; number->image
(define MTS (empty-scene 300 300))
(define DOT (circle 3 "solid" "red"))

; 提醒文案常量
(define REMIND-MSG 
  (place-image (text "程序已停止 \n\n 注意:\n\n x 坐标值位于 [0,297] \n y 坐标值位于 [0,300]" 14 "black") 150 200 MTS))

; 时钟函数
; 时钟滴答一次，红点 x + 3，y 值不变

; Posn -> Posn
(define (x+ p)
  (posn-up-x p (+ (posn-x p) 3)))


; 更新器函数

; Posn Number -> Posn
(define (posn-up-x p n )
  (make-posn n (posn-y p)))


  ; 注
  ; 本题中
  ; 时钟函数：传递参数给更新器
  ; 更新器：承担计算数据任务
  ; 二者配合完成了任务

  ; 这题目比较简单，引入更新器有点多余。题目的意图，是引入更新器这概念，留待以后复杂的程序用。

; 鼠标事件函数
; 鼠标点击，重置红点
; poson number number mouseevent -> posn 

(check-expect
  (reset-dot (make-posn 10 20) 29 31 "button-down")
  (make-posn 29 31))

(check-expect
  (reset-dot (make-posn 10 20) 29 31 "button-up")
  (make-posn 10 20))

(define (reset-dot p x y me)
  (cond
    [(mouse=? me "button-down") (make-posn x y)]
    [else p]))

  ; 注
  ; 题目并没有详细解释什么是重置，从书中代码来看，所谓重置：鼠标点在那里，红点就出现在那里。

  ; 按下鼠标后，立即重置红点，不算太严谨
  ; 有时会误触鼠标左键，所以才说，按下鼠标左键，立即重置红点，并不严谨。
  ; 更为严谨的方式，按下鼠标，再松开鼠标，这时才重置红点。
  ; 但这样子，相对麻烦，而且这一点，也不是本题的重点，所以，还是采用书上的方法。

; 游戏核心逻辑
; 红点位于背景内，则实时渲染，即：红点圆心所在位置 [0，297]，合理范围，即位于背景内
; 
; 红点半径为 3，
; 红点圆心位于 (297，298] ，显示提示文案 
; 红点圆心 > 298 ，停止游戏

; posn-> image 
(check-expect (scene+dot (make-posn 30 20))
  (place-image DOT 30 20 MTS))

(define (draw-dot-on-scene p)
  (place-image DOT (posn-x p) (posn-y p) MTS)) 


(check-expect (in-bounds? (make-posn 0 0)) #true)
(check-expect (in-bounds? (make-posn 297  300)) #true)
(check-expect (in-bounds? (make-posn 298  300)) #false)
(check-expect (in-bounds? (make-posn 297  301)) #false)

(define (in-bounds? p)
  (and
    (>=(posn-x p) 0) (<= (posn-x p) 297)
    (>= (posn-y p) 0) (<= (posn-y p) 300)))

(check-expect (scene+dot (make-posn 0 0))
              (place-image DOT 0 0 MTS)) 

(check-expect (scene+dot (make-posn 298 301))
              REMIND-MSG)  

(define (scene+dot p)
  (cond
    [(in-bounds? p) (draw-dot-on-scene p)]
    [else REMIND-MSG]))


; 停止函数
; posn -> boolean 
(check-expect (end-condition? (make-posn 10 300)) #false)

(define (end-condition? p)
  (> (posn-x p) 298))

  ; 注
  ; 显示提醒文案之后，停止函数才停止程序。

; 定义世界程序
; Posn -> Posn
(define (main p)
  (big-bang p
    [on-tick x+]
    [on-mouse reset-dot]
    [to-draw scene+dot]
    [stop-when end-condition?]))

(main (make-posn 10 150))

