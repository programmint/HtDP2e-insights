; 56

; Core ideas
; 这个题目可能会令你困惑，其实分 3 步走：
; 第1、题目中的 main1，缺了on-tick 函数，只能实现部分倒计时效果。
; 第2、main 2 函数，加入了on-tick 函数，以及停止函数，实现了全部题目的效果。
; 第3、提示你，最为关键一点，按键函数和时钟函数，可以采用相同函数结构。

; 高度定义：画布顶部与火箭中心距离

; 注，这一系列题目，解题时，都没有采用书中的函数名。书中的函数名，不易理解，所以更改了。

; ==背景
; nubmer,image -> iamge 
(define BG-W 600) 
(define BG-H 300)
(define BACKG (empty-scene BG-W BG-H))

; ==火箭图像、火箭中心点
; nubmer,image -> iamge 
(define RKT-W 5)
(define RKT-H 30)
(define ROCKET (rectangle RKT-W RKT-H "solid" "red")) 
(define RKT-CTR (/ RKT-H 2)) 

; ==火箭速率
; number -> number 
(define YDELTA 3)  

; ==火箭静止位置、静止文案位置
; number -> number 
; nubmer,string,image -> iamge 
(define X-START-POS (/ BG-W 2))
(define Y-START-POS (- BG-H RKT-CTR))
(define idle-msg (text "按下空格，发射火箭" 16 "black"))
(define idle-msg-pos (make-posn (- BG-W 470) (- BG-H 25)))
(define rkt-idle-pos (make-posn X-START-POS Y-START-POS))

; ==倒计时数字位置
; nubmer -> iamge 
(define countdown-pos (make-posn X-START-POS ( - BG-H 35)))

; ==飞行文案
; nubmer,string,image -> iamge 
(define flying-msg (text "火箭正飞行" 16 "black"))
(define flying-msg-pos (make-posn (- BG-W 470) ( - BG-H 230)))

; ==结束飞行文案
; nubmer,string,image -> iamge 
(define end-msg (text "火箭飞行已结束" 16 "red"))
(define end-msg-xpos (- BG-W 470))
(define end-msg-ypos (- BG-H 230))

; 按键函数
; worldstate key -> worldstate
(define (handle-key rkt-state a-key)
  (cond
    [(and (string? rkt-state) (string=? rkt-state "resting") (key=? a-key " ")) -3]
    [(<= -3 rkt-state -1 )  rkt-state ]
    [(and (number? rkt-state) (>= rkt-state 0)) rkt-state]
    [else rkt-state]))

; 测试按键函数
(check-expect (handle-key "resting" " ") -3 )
(check-expect (handle-key 33 "a") 33 )
(check-expect (handle-key 27 " ") 27 )

; 时钟函数
; worldstate -> worldstate
(define (tock-y-h rkt-state)
  (cond
    [(and (string? rkt-state) (string=? rkt-state "resting")) rkt-state]
    [(and  (number? rkt-state) (<= -3 rkt-state) ( < rkt-state -1)) (+ rkt-state 1)]
    [(and (number? rkt-state) (= rkt-state -1)) Y-START-POS]
    [(and (number? rkt-state) (> rkt-state 0)) (- rkt-state YDELTA)]
    [(and (number? rkt-state) (<= rkt-state 0)) (max -0.01 (- rkt-state YDELTA))]
    ; 依照题意，高度不能为负，可是高度为 0 时，如果立即停止程序，对应的提示文案则不会出现
    ; 加了这一条件， on-tick 函数会继续产生新状态，保证出现停止飞行的文案。
      [else rkt-state]))

; 测试时钟函数
(check-expect (tock-y-h "resting") "resting")
(check-expect (tock-y-h -1) 285)  
(check-expect (tock-y-h 30) 27)

; 静止图像函数
(define idle-img       
    (place-images
            (list idle-msg ROCKET )
            (list idle-msg-pos rkt-idle-pos) 
            BACKG))

; 倒计时图像函数
(define (countdown-img rkt-state)
    (place-images
        (list (text (number->string rkt-state) 20 "red") ROCKET)
        (list countdown-pos rkt-idle-pos)
        BACKG))

; 飞行图像函数
(define (flying-img rkt-state)
        (place-images
            (list flying-msg ROCKET)
            (list flying-msg-pos (make-posn X-START-POS rkt-state))
            BACKG))

; 结束飞行图像函数
(define end-img 
  (place-image 
    end-msg 
    end-msg-xpos end-msg-ypos 
    BACKG))


; 渲染火箭函数
; worldstate -> image
(define (draw-rkt rkt-state)
  (cond
    [(and (string? rkt-state )(string=? rkt-state "resting")) idle-img]
    [(and (number? rkt-state) (<= -3 rkt-state -1)) (countdown-img rkt-state)]
    [(and (number? rkt-state)(> rkt-state 0)) (flying-img rkt-state)]
    [(and (number? rkt-state) (= rkt-state 0)) end-img]))
      ; 如果  (= rkt-state 0) 函数立即停止运行，则 end-img 不会出现 

; 测试渲染火箭函数
(check-expect 
  (draw-rkt "resting")
    (place-images
      (list idle-msg ROCKET)
      (list idle-msg-pos rkt-idle-pos )
      BACKG))

(check-expect 
  (draw-rkt -3)
    (place-images
              (list (text (number->string -3 ) 20 "red") ROCKET)
              (list countdown-pos rkt-idle-pos)
              BACKG))

(check-expect 
  (draw-rkt -1)
    (place-images
              (list (text (number->string -1 ) 20 "red") ROCKET)
              (list countdown-pos rkt-idle-pos)
              BACKG))

(check-expect 
  (draw-rkt 100)
    (place-images
      (list flying-msg ROCKET)
      (list flying-msg-pos (make-posn X-START-POS 100 )) 
      BACKG))

(check-expect 
  (draw-rkt 0) end-img)


; 火箭停止飞行函数
(define (rkt-off-canvas? rkt-state)
  (cond
    [(and (number? rkt-state) (< rkt-state 0) (not (<= -3 rkt-state -1)))  #true]
    [else #false]))
    ; 火箭高度刚刚为负数时，立即停止函数运行。

; 测试火箭停止飞行函数
(check-expect (rkt-off-canvas? -0.01 ) #true)

; 定义世界程序
; worldstate -> any
(define (main1 rkt-state)
  (big-bang rkt-state
            (to-draw draw-rkt)
            (on-key handle-key)
            ; (on-tick tock-y-h)
            (stop-when rkt-off-canvas?)))

(define (main2 rkt-state)
  (big-bang rkt-state
            (to-draw draw-rkt)
            (on-key handle-key)
            (on-tick tock-y-h 0.3)
            (stop-when rkt-off-canvas?)))

(main1 "resting")  ; 传入预设的状态 “resting”  

(main2 "resting")  ; 传入预设的状态 “resting”  