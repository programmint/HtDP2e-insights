; 59

; tl : TrafficLight
; cs : current-state

; 交通灯三种状态
(define RED "red")
(define GREEN "green")
(define YELLOW "yellow")

; 单一交通灯图像
; nubmer -> image
(define TL-RED (circle  20 "solid" "red"))
(define TL-YELLOW (circle  20 "solid" "yellow"))
(define TL-GREEN (circle  20 "solid" "green"))
(define TL-OFF (circle  20 "outline" "black"))
(define TL-BACKG (empty-scene 160 50))

; 红灯函数
; image->iamge
(define RED-SCENE
    (place-images
        (list TL-RED TL-OFF TL-OFF)
        (list(make-posn 30 25) (make-posn 80 25) (make-posn 130 25))
        TL-BACKG))

; 黄灯函数
; image->iamge
(define YELLOW-SCENE
    (place-images
        (list TL-OFF TL-YELLOW TL-OFF)
        (list(make-posn 30 25) (make-posn 80 25) (make-posn 130 25))
        TL-BACKG))

; 绿灯函数
; image->iamge
(define GREEN-SCENE
    (place-images
        (list TL-OFF TL-OFF TL-GREEN)
        (list(make-posn 30 25) (make-posn 80 25) (make-posn 130 25))
        TL-BACKG))

; 时钟函数
; worldstate -> worldstate
(define (tl-next cs)
    (cond
        [(string=? cs RED) YELLOW]
        [(string=? cs YELLOW) GREEN]
        [(string=? cs GREEN) RED]))

; 渲染交通灯
; worldstate -> image
(define (tl-render cs)
    (cond
        [(string=? cs RED) YELLOW-SCENE]
        [(string=? cs YELLOW) GREEN-SCENE]
        [(string=? cs GREEN) RED-SCENE]
        [else RED-SCENE]))

(check-expect (tl-render YELLOW) GREEN-SCENE)
(check-expect (tl-render GREEN) RED-SCENE)

; 定义世界程序
; worldstate -> any
(define (main cs)
    (big-bang cs
        (to-draw tl-render)
        (on-tick tl-next 3)))

(main GREEN)

