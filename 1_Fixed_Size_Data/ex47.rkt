 ; 47

; 修改历史
; 修改了变量名的连线，由底部短横线，改为中间短横线。
; 之前我是用 python 的短横线用法，racket 的短横线，更喜欢用中间短横线。（2024.12）

; 补充（2025.4）
; 纸质版图书与网络版内容区别
; 中文版《程序设计方法》（第 2 版）应该是直接翻译的英文纸质版图书。
; 具体至 47 题，其中按下向上键
; 纸质版：其数值是增加了（increases）1/5
; 网络版：其数值是减少了(decreases) 1/5

; 显然，网络版采用的“减少”更容易理解，但对题目了来说，没有太大差异。
; 所以这里，依然采用增加的方法，来计算数值。
; 详见：https://github.com/programmint/HtDP2e-insights/blob/main/Notes/htdp2e%20%E5%AD%A6%E4%B9%A0%E9%9A%8F%E8%AE%B0%20-%20%E7%96%91%E9%97%AE%E9%87%8D%E7%82%B9%E5%BF%83%E5%BE%97-%E5%90%88%E9%9B%86.md

; ------------------------------代码部分---------------------------------------------


; 定义背景常量
; number -> image 
(define BACKGROUND-WIDTH 30)
(define  BACKGROUND-HEIGHT 200)
(define BACKGROUND
    (empty-scene BACKGROUND-WIDTH BACKGROUND-HEIGHT))

; 定义红色标识常量
; number -> image 
(define RED-SIGN-WIDTH (* BACKGROUND-WIDTH 0.9))
(define ( RED-SIGN-HEIGHT ws)
     (* BACKGROUND-HEIGHT (/ ws 100)))
(define (red-sign ws)
    (rectangle RED-SIGN-WIDTH (RED-SIGN-HEIGHT ws) "solid" "red"))

; ws 数值不断变化，取  (/ ws 100) 的比例，然后再与 BACKGROUND-HEIGHT 相乘，得出红色标识的高度
; 这一步比较重要

; 定义快乐指数函数
; image -> image 
(define (render ws)
    (place-image (red-sign ws)
     (/ BACKGROUND-WIDTH 2) (- BACKGROUND-HEIGHT (/ (RED-SIGN-HEIGHT ws) 2))
      BACKGROUND))

; 定义时钟滴答函数，每滴答一下，红色标识减 0.3
(define (tock ws) 
    (max 0 (- ws 0.3)))

; 题目要求是减少 0.1，但0.1 在视觉上变化太慢，用 0.3 加速视觉变化。

; 定义按键事件函数
(define  ( key-events ws a-key)
    (cond
        [(key=? a-key "up")( min 100 (* ws (+ 1 1/3)))]  
        [(key=? a-key "down")(max 0 (*  ws (+ 1 1/5)))]
        [else ws]))

; 定义停止函数
(define (end? ws)
    (= ws 0 ))

; 设计主函数
(define (main ws)
    (big-bang  ws
        [on-tick tock]
        [to-draw render]
        [on-key key-events]
        [stop-when end?]))

(main 100)
