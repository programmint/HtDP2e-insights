; 54

; =============
; 全局目的
; =============
; 基于 53 题,增加了倒计时功能
; 增加4种状态文案说明:火箭静止、火箭倒计时、火箭飞行、火箭结束飞行

; =========
; 缩写说明
; =========
; - BG: background（背景）
; - CTR：center (中心)
; - IMG / img : image（图片）
; - MSG: message（信息）
; - POS: position （位置）
; - RKT: rocket（火箭）

; =============
; 数据定义
; =============
; LR（launching rocket的缩写）是下列之一：
; - "resting"
; - NonnegativeNumber（非负数）
; 解释："resting"表示火箭停在地面
; 数值表示火箭飞行时的高度

; =============
; 常量定义
; =============

; 背景
(define BG-W 600) 
(define BG-H 300)
(define BG (empty-scene BG-W BG-H))

; 火箭图像、火箭中心点
(define RKT-W 5)
(define RKT-H 30)
(define ROCKET (rectangle RKT-W RKT-H "solid" "red")) 
(define RKT-CTR (/ RKT-H 2)) 

; 火箭速率
(define YDELTA 3)  

; 火箭静止位置、静止文案位置
(define X-START-POS (/ BG-W 2))
(define Y-START-POS (- BG-H RKT-CTR))
(define IDLE-MSG (text "按下空格,发射火箭" 16 "black"))
(define IDLE-MSG-POS (make-posn (- BG-W 470) (- BG-H 25)))
(define RKT-IDLE-POS (make-posn X-START-POS Y-START-POS))

 ; 注：
 ; 当时恰巧查到了 make-posn 而已，感觉两个数据放在一起，比较方便。
 ; 其实还没有进行到结构体的章节。

; 倒计时数字位置
(define COUNTDOWN-POS (make-posn X-START-POS ( - BG-H 35)))

; 飞行提示文案
(define FLYING-MSG (text "火箭正飞行" 16 "black"))
(define FLYING-MSG-POS (make-posn (- BG-W 470) ( - BG-H 230)))

; 结束飞行提示文案
(define END-MSG (text "火箭飞行已结束" 16 "red"))
(define END-MSG-X (- BG-W 470))
(define END-MSG-Y (- BG-H 230))
(define END-IMG (place-image END-MSG END-MSG-X END-MSG-Y BG))

; =====================
; 主函数
; =====================

; 世界主程序
; worldstate -> any
(define (main state)
  (big-bang state
   (to-draw draw-rkt)
   (on-tick tock-y-h)
   (on-key handle-key)
   (stop-when rkt-off-canvas? end-scene)))

; --------------------
; 渲染函数
; --------------------

; 测试渲染火箭函数
(check-expect 
 (draw-rkt "resting")
 (place-images
  (list IDLE-MSG ROCKET)
  (list IDLE-MSG-POS RKT-IDLE-POS )
  BG))

(check-expect 
 (draw-rkt -3)
 (place-images
  (list (text (number->string -3 ) 20 "red") ROCKET)
  (list COUNTDOWN-POS RKT-IDLE-POS)
  BG))

(check-expect 
 (draw-rkt -1)
 (place-images
  (list (text (number->string -1 ) 20 "red") ROCKET)
  (list COUNTDOWN-POS RKT-IDLE-POS)
  BG))

(check-expect 
 (draw-rkt 100)
 (place-images
  (list FLYING-MSG ROCKET)
  (list FLYING-MSG-POS (make-posn X-START-POS 100 )) 
  BG))

; 实时渲染火箭图像
; worldstate -> image
(define (draw-rkt state)
  (cond
   [(and (string? state )(string=? state "resting"))
    (place-images
     (list IDLE-MSG ROCKET )
     (list IDLE-MSG-POS RKT-IDLE-POS) 
     BG)]

    [(and (number? state) (<= -3 state -1))
     (place-images
      (list (text (number->string state) 20 "red") ROCKET)
      (list COUNTDOWN-POS RKT-IDLE-POS)
      BG)]

    [(and (number? state)(> state 0))
     (place-images
      (list FLYING-MSG ROCKET)
      (list FLYING-MSG-POS (make-posn X-START-POS state)) 
      BG)]))

; --------------------
; 时钟函数
; --------------------

; 测试时钟函数
(check-expect (tock-y-h "resting") "resting")
(check-expect (tock-y-h -1) 285)  
(check-expect (tock-y-h 30) 27)

; 时钟每滴答一次,火箭向上运动 3 像素
; worldstate -> worldstate
(define (tock-y-h state)
  (cond
   [(and (string? state) (string=? state "resting")) state]
   [(and  (number? state) (<= -3 state) ( < state -1)) (+ state 1)]
   [(and (number? state) (= state -1)) Y-START-POS]
   [(and (number? state) (> state 0)) (- state YDELTA)]
   [else state]))

; --------------------
; 按键函数
; --------------------

; 测试按键函数
(check-expect (handle-key "resting" " ") -3 )
(check-expect (handle-key "abc" " ") "abc" )
(check-expect (handle-key 27 " ") 27 )

; 按下空格键后,倒计时3个时钟滴答
; worldstate key -> worldstate
(define (handle-key state a-key)
  (cond
   [(and (string? state) (string=? state "resting") (key=? a-key " ")) -3]
   [else state]))

; --------------------
; 判断是否停止飞行？
; --------------------

; 测试火箭停止飞行函数
(check-expect (rkt-off-canvas? 0 ) #true)

; 火箭飞出背景，则停止飞行
; worldstate -> boolean
(define (rkt-off-canvas? state)
  (cond
   [(and (number? state) (= state 0)) #true]
   [else #false]))

; 停止飞行后，显示最后一帧图像
; worldstate -> image
(define (end-scene state)
  (place-images
   (list END-MSG ROCKET)
   (list (make-posn END-MSG-X END-MSG-Y)
         (make-posn X-START-POS 0))
   BG))

; 注
; end-scene 这个函数必须有 state 这个参数，否则 big-bang 调用它时就无法把终止时的 worldstate 传递进去。
; 也就无法根据最后的状态，渲染出你想要的终止画面。
; 所以，end-scene 的参数不能省，哪怕暂时用不到，也要保留。

; =====================
; 程序启动
; ===================== 
(main "resting")  ; 传入预设的状态 “resting”  