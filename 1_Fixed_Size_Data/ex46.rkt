; 46

; 修改历史
; 修改了变量名的连线,由底部短横线,改为中间短横线。
; 之前我是用 python 的短横线用法,racket 的短横线,更喜欢用中间短横线。(2024.12)

; 定义cat
; image -> image
(define cat1  (bitmap "images/cat.png")) 
(define cat2  (bitmap "images/cat.png"))

; 运行代码时,记得把图片放置到代码中,或者添加正确的图片路径 

; 定义背景环境
; wordldsate -> image
(define BACKGROUND-WIDTH 
  (* 6 (image-width cat1)))

(define BACKGROUND-HEIGHT 
  (* 2 (image-height cat1)))

(define BACKGROUND
  (empty-scene BACKGROUND-WIDTH BACKGROUND-HEIGHT))

; 时钟滴答一次,猫移动 3 像素
(define (tock ws) 
  (modulo (+ ws 3) BACKGROUND-WIDTH))
    
(check-expect (tock 17) 20 )
(check-expect (tock 100) 103 )
(check-expect (tock 0) 3 )

; 根据x坐标是否为奇数,选 cat 照片
(define (WHICH-CAT ws)
  (cond
    [(odd? (tock ws))cat1]
    [else cat2]))

; 运行代码后,你会看到猫爪产生更多抖动

; 把猫放入到世界环境中
; wordldsate -> image
(define (render ws)
  (place-image (WHICH-CAT ws)
               ws (- BACKGROUND-HEIGHT (* 0.52 (image-height cat1)))BACKGROUND ))

; 0.52 是把猫的图片至于背景的底部位置

; 定义主函数
(define (main ws)
  (big-bang ws
    [on-tick tock] 
    [to-draw render]))

(main 0)