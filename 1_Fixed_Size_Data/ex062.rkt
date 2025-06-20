; ex062
	
; A DoorState is one of:
; – OPEN
; – CLOSED
; – LOCKED

; ==门各状态常量
(define OPEN "open")
(define CLOSED "closed")
(define LOCKED "locked")

; ==基础数据常量
(define RADIUS 10)
(define DOOR-WIDTH 150)
(define DOOR-LENGTH 300)
(define TEXT-SIZE 14)
(define DOORKNOB-X-POS 120)
(define DOORKNOB-Y-POS 155)
(define DOORMSG-X-POS 75)
(define DOORMSG-Y-POS 200)

; 单一状态门拉手图像函数
(define DOORKNOB-OPEN (circle  RADIUS "solid" "green"))
(define DOORKNOB-CLOSED (circle  RADIUS "solid" "yellow"))
(define DOORKNOB-LOCKED (circle  RADIUS "solid" "red"))

; 门框图像函数
(define DOOR-FRAME (empty-scene DOOR-WIDTH DOOR-LENGTH))

; 门状态说明
(define DOOR-OPEN-MSG (text "门已打开\n3秒钟后,自动关门" TEXT-SIZE "black"))
(define DOOR-CLOSED-MSG (text "门已关闭\n按下 L 键，锁门\n按下空格，键推开门" TEXT-SIZE "Light Brown"))
(define DOOR-LOCKED-MSG (text "门已锁\n按下 U 键，开门" TEXT-SIZE "black"))

; 门已开图像函数
(define DOOR-OPEN 
    (place-images
        (list DOORKNOB-OPEN DOOR-OPEN-MSG) 
        (list (make-posn DOORKNOB-X-POS DOORKNOB-Y-POS)(make-posn DOORMSG-X-POS DOORMSG-Y-POS))
        DOOR-FRAME))

; 门关闭图像函数
(define DOOR-CLOSED  
    (place-images
        (list DOORKNOB-CLOSED DOOR-CLOSED-MSG) 
        (list (make-posn DOORKNOB-X-POS DOORKNOB-Y-POS)(make-posn DOORMSG-X-POS DOORMSG-Y-POS))
        DOOR-FRAME))

; 门已锁定图像函数
(define DOOR-LOCKED  
    (place-images
        (list DOORKNOB-LOCKED  DOOR-LOCKED-MSG) 
        (list (make-posn DOORKNOB-X-POS DOORKNOB-Y-POS)(make-posn DOORMSG-X-POS DOORMSG-Y-POS))
        DOOR-FRAME))

; door-closer，door-action，door-render
; 教材中给的这 3 个变量名，其实都不够好，修改如下
; tick-close-door,handle-door-action,render-door

; 时钟函数
; worldstate -> worldstate
(define (tick-close-door door-state)
    (cond
        [(string=? OPEN door-state) CLOSED]
        [(string=? CLOSED door-state) CLOSED]
        [(string=? LOCKED door-state) LOCKED]
        [else door-state]))

; 测试时钟函数
(check-expect (tick-close-door OPEN) CLOSED)
(check-expect (tick-close-door CLOSED) CLOSED) 
(check-expect (tick-close-door LOCKED) LOCKED)


; 按键函数
; worldstate -> worldstate
(define (handle-door-action door-state a-key)
    (cond
        [(and (string=? CLOSED door-state ) (string=? "l" a-key)) LOCKED ]
        [(and (string=? LOCKED door-state ) (string=? "u" a-key)) CLOSED]
        [(and (string=? CLOSED door-state ) (string=? " " a-key)) OPEN]
        [else door-state]))

; 测试按键函数
(check-expect (handle-door-action CLOSED "l") LOCKED)
(check-expect (handle-door-action LOCKED "u") CLOSED)
(check-expect (handle-door-action CLOSED " ") OPEN)
(check-expect (handle-door-action OPEN "x") OPEN)  

; 渲染各状态门图像函数
(define (render-door door-state)
    (cond
        [(string=? OPEN door-state )DOOR-OPEN ]
        [(string=? CLOSED door-state )DOOR-CLOSED ]
        [(string=? LOCKED door-state )DOOR-LOCKED ]))

; 测试渲染各状态的门图像
(check-expect (render-door OPEN) DOOR-OPEN)
(check-expect (render-door CLOSED) DOOR-CLOSED)
(check-expect (render-door LOCKED) DOOR-LOCKED)

; 主函数
; worldstate -> any
(define (main door-state)
    (big-bang door-state
        [on-tick tick-close-door 3]
        [on-key handle-door-action]
        [to-draw render-door]))

(main OPEN)