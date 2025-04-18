; 53

; === 数据定义
; An LR (short for launching rocket) is one of:
; – "resting"
; – NonnegativeNumber
; interpretation: "resting" represents a grounded rocket
; a number denotes the height of a rocket in flight

; Notice
; 高度定义:画布顶部与火箭中心距离

; == 背景常量
; number image -> image
(define BG-W 100) 
(define BG-H 300)
(define BACKG (empty-scene BG-W BG-H))

; == 火箭常量
; number image -> image
(define RKT-W 5)
(define RKT-H 30)
(define RKT-CTR (/ RKT-H 2)) 
(define ROCKET (rectangle RKT-W RKT-H "solid" "red")) 

; == 火箭飞行常量
(define YDELTA 3)  
(define X-START-POS (/ BG-W 2))
(define Y-START-POS (- BG-H RKT-CTR))


; 按键函数
; 火箭静止,且只有按下空格键后,火箭才发射

; LR KeyEvent -> LR
(define (handle-key rkt-state a-key)
  (cond
   [(and (string? rkt-state) (key=? a-key " ")) Y-START-POS] 
   [else rkt-state])) 

; 时钟函数
; 时钟每滴答一次,火箭上升 3像素

; LR -> LR
(define (tock-y-h rkt-state)
  (cond
   [(and (number? rkt-state) (> rkt-state 0)) (- rkt-state YDELTA)] 
   [else rkt-state]))

; 火箭函数
; 时钟滴答一次,实时绘制火箭一次

; LR -> Image
(define (draw-rkt rkt-state)
  (place-image ROCKET
               X-START-POS
               (cond
                [(string? rkt-state) Y-START-POS]
                [(>= rkt-state 0) rkt-state])
               BACKG))

; 注,到了第 55 题,就会提醒你,place-image  可以单独定义为函数。

; 程序停止函数
; 火箭超出画布时停止飞行
; LR -> Boolean
(define (rkt-off-canvas? rkt-state)
  (cond 
    [(and (number? rkt-state) (< rkt-state 0)) #true]
    [else #false])) 

; 火箭主函数
(define (main rkt-state)
  (big-bang rkt-state
    (to-draw draw-rkt)
    (on-key handle-key)
    (on-tick tock-y-h)
    (stop-when rkt-off-canvas?)))

(main "resting")