; ex041

; 修改历史
; 修改了变量名的连线，由底部短横线，改为中间短横线。
; 之前我是用 python 的短横线用法，racket 的短横线，更喜欢用中间短横线。（2024.12）

; Notice 
; 该书网站，函数用蓝色表示，均可点击，直接跳入对应函数介绍页面。

; 生成车轮
; number -> image 
(define WHEEL-RADIUS 5)  ;车轮半径为单一控制点
(define WHEEL (circle WHEEL-RADIUS "solid" "black")) 

; 生成车身底部
; number -> image
(define UNDERBODAY-SPACE 
    (rectangle ( * WHEEL-RADIUS 14)(* WHEEL-RADIUS 2) "outline" (make-color 0 0 0 0)))

; outline 是透明的
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

; 综上，我们是简单定义车身。
; 现实中，车辆底部空间包含：前悬，轴距，后悬，最小离地间隙等参数，并非那么简单。

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

; 生成树
; number -> image 
(define tree
    (underlay/xy (circle 10 "solid" "green")
                        9 15
                        (rectangle 2 20 "solid" "brown")))
            
; Notice 
; 这样子定义树，没问题，也有问题。
; 没问题，指这位样子定义树，可以准确生成一棵树。
; 有问题，指树和背景结合在一起，树的整体高度，宽度，放置在背景中什么位置，不容易估算出来；
; 所以，树的高度、宽度，和单一控制点结合起来，会更好。
; 不过，这里暂用书里提供的数据。

; 生成背景
; number -> image 
(define WIDTH-OF-WORLD 200)  ; 定义了一个常量。这常量，可以使用车轮半径来定义，暂用书里提供的 200 。
(define BACKGROUD 
    (empty-scene ( * WIDTH-OF-WORLD 3) ( / WIDTH-OF-WORLD 2)))

; 背景与树结合在一起，形成新背景
; image -> image 
(define BACKGROUD-WITH-TREE
    (place-image tree 500 82.5 BACKGROUD))  

; Notice 
; 到了这里，树与背景合起来，出现了小数点，问题也出来了，即前面所讲，不容易估算位置数值。

; 500 , 82.5  根据树和背景的长宽，设置为摆放的位置，这样子设置数值，显然也不利于后期修改。
; 不过，现在的编辑器都提供替换功能，可以稍微弥补一下。

; 时钟滴答一次，汽车移动 3 像素
; 注：场景左边界和汽车之间的距离。
; worldstate  -> number 
    (define (tock ws)
        (+ ws 3))    

; 将车放置于新背景中
; image -> image 
(define Y-CAR 89)
(define  (render ws)
    (place-image CAR ws  Y-CAR BACKGROUD-WITH-TREE) )

; 代码这样子写，就代表了车的中心处，距离边界左侧的 x 坐标

; Y-CAR = 89 ，car 图片好位于地面上，取 89 ，是根据新背景高度，车身高度，结合视觉效果，推算出来的。

; 每一事件后，对（end? cw）求值，若图片消失在新背景中，则停止动画；
; number -> image 
(define (end? ws) 
    ( >  ws  (+ (* WIDTH-OF-WORLD 3) 35 )))

; 增加注释
(check-expect (end? 1) #false )
(check-expect (end? 10) #false )

; 数字 35 是车身宽度一半。
; 停止动画，采用：左侧车尾消失于场景右边界，取此时的值。
; 同时，为了告诉你车辆停了，特意留了 1 像素的车尾（红色），告诉你车已经停在了那里。（交互设计的思路）

; 设计主函数
; number -> image 
(define (main ws)
    (big-bang ws
        [on-tick tock]
        [to-draw render]
        [stop-when end?]))  

(main 0)