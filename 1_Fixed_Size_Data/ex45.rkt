; 45

; 修改历史
; 修改了变量名的连线，由底部短横线，改为中间短横线。
; 之前我是用 python 的短横线用法，racket 的短横线，更喜欢用中间短横线。（2024.12）

; 定义cat1
; image -> image
(define cat1  (bitmap "images/cat.png"))  ; 运行代码时，记得把图片放置到代码中，或者添加正确的图片路径 

; 定义背景环境
; wordldsate -> image
(define BACKGROUND-WIDTH 
    (* 6 (image-width cat1)))

(define BACKGROUND-HEIGHT 
    (* 2 (image-height cat1)))

(define BACKGROUND
    (empty-scene BACKGROUND-WIDTH BACKGROUND-HEIGHT))

; 时钟滴答一次，猫移动 3 像素
(define (tock ws) 
   (modulo (+ ws 3) BACKGROUND-WIDTH))
   
; 解题关键，在这一步
; 实现猫图像自左至右循环播放，要运用 modulo 函数
; modulo 函数功能，求余数，这里分 2 种情况
; 第 1，猫移动距离 小于 背景距离，小的数字除以大的数字，余数恰是小的数字，即猫移动距离，视觉上猫自左向右移动
; 第2，猫移动距离 大于 背景距离，大的数字除以小的数字，余数是从 1 逐步开始增大的数字
; 视觉上猫右边消失，又从左边出现，然后又开始第 1 条件下的图像展示
    
(check-expect (tock 17) 20 )
(check-expect (tock 100) 103 )
(check-expect (tock 0) 3 )

; 把猫放入到世界环境中
; wordldsate -> image
(define (render ws)
    (place-image cat1 
    ws (- BACKGROUND-HEIGHT (* 0.52 (image-height cat1)))BACKGROUND ))

; 0.52 是把猫的图片至于背景的底部位置

; 定义主函数
(define (main ws)
    (big-bang ws
        [on-tick tock] 
        [to-draw render]))

(main 0)