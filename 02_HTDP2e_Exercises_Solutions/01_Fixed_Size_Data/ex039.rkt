; ex039

; 说明
; 改了书里的思路，具体来讲：目的声明写在最前面，其他的依次向后推。
; 目的声明链接需求和程序，形成思路的 checklist ，用来检验程序设计思路，是不是符合需求。
; 后面围绕这个 checklist 展开，也就变成了 To-Do-List 。


; WISH LIST （同时也是 checklist ）
; WorldState：current world (cw) 由多类型 data 表示   

; 生成世界状态的图像 （目的声明都写在最前面，下同）
; WorldState -> Image
(define (render cw) ...)

; 时钟跳动，获取下一个世界状态
; WorldState -> WorldState
(define (clock-tick-handler cw) ...)

; 按键事件，获取下一个状态;
; WorldState，String -> WorldState 
(define (keystroke-handler cw ke) ...) ; ke 代表按键

; 鼠标手势，获取下一个状态;
; Number Number String -> WorldState 
(define (mouse-event-handler cw x y me) ...)     ;x 和 y 是事件的坐标，me 是事件描述 

; 每次事件后，检查 end？ 的值
; WorldState -> Boolean
(define (end? cw) ...)

; 实现过程
; 生成车轮
; number -> image 
(define WHEEL-RADIUS 5)  ;车轮半径为单一控制点
(define WHEEL (circle WHEEL-RADIUS "solid" "black")) 

; 生成车身底部
; number -> image
(define UNDERBODAY-SPACE 
(rectangle ( * WHEEL-RADIUS 14)(* WHEEL-RADIUS 2) "outline" (make-color 0 0 0 0)))

; Notice
; 这里用 rectangle，其实当时忘了empty-scene 这函数，无奈改用了 rectangle ，后面都延续了 rectangle。
; 视觉效果虽说差不多，但还是 empty-scene 比较好。

;outline 是透明的
; 书里给的变量 space 
; (define SPACE (rectangle ... WHEEL-RADIUS ... "white"))
; space 这变量，从命名来说，不知道用在那里
; 看代码才知道是怎么回事，所以不用 space 这命名了。 

; 汽车设计中一概念，轴距，指两车轮之间的距离，这个参数对车实体设计非常重要
; 但在虚拟程序里，这个参数用不上

(define CAR-UNDERBODY
(overlay/offset 
    (overlay/offset UNDERBODAY-SPACE
                            (- 0 (* WHEEL-RADIUS 3.5)) 0   ; 第 1 个车轮向左平移3.5倍车轮半径像素 
                            WHEEL)
    (* WHEEL-RADIUS 3.5) 0     ; 第 2 个车轮向右平移3.5倍车轮半径像素
    WHEEL))

;综上，只是简单定义车身。
;现实中，车辆底部空间包含：前悬，轴距，后悬，最小离地间隙等参数，并非那么简单。

; 生成车身
; number -> image
; 车身有两部分组成，上半部分，下半部分
; 车身上半部分，宽:高 = 7 倍 WHEEL-RADIUS ：1 倍 WHEEL-RADIUS
; 车身下半部分，宽:高 = 14 倍 WHEEL-RADIUS ：2 倍 WHEEL-RADIUS

(define CAR-BODY
    (above (rectangle (* WHEEL-RADIUS 7) (* WHEEL-RADIUS 1)"solid" "red")
            (rectangle (* WHEEL-RADIUS 14) (* WHEEL-RADIUS 2) "solid" "red")))

; 生成整车
; image -> image
(define CAR
    (overlay/offset CAR-UNDERBODY
                        0  (- 0 (* WHEEL-RADIUS 1.5))     ; CAR-BODY 向上移动
                        CAR-BODY ))

; 起初用 above，效果不佳，才转用 overlay/offset

CAR

; 反思
; 用一简单的题目，来模仿复杂的程序，如果只解决该题，不必如此啰嗦。
; 同时，代码里有瑕疵，例如，里面的比例系数，应该定义为常量，而非直接写在里面，不然改动时不好改。
; 书里示例代码，也犯了这个毛病
; 这一章，重在掌握设计思路，这些小瑕疵，不必在意。