; 92

; ====================
; 全局目的
; ====================
; 设计 happy-cham 程序，包含以下部分：
; 1、变色龙从左至右，穿过画布，到达画布右端，立即出现在画布左侧。
; 2、变色龙随着行走，快乐指数值会下降。
; 3、按下向下键键，变色龙开心指数值 + 2，按其他键无效。
; 4、按下“r”，“g”，“b”键，变色龙会变成对应色彩。


; =====================
; 缩写说明
; - BG: background（背景）
; - IMG: image（图片）
; ======================

; =============
; 常量定义
; =============

; -------------
; 变色龙常量
; -------------

; 创建变色龙
(define CHAM-IMG  (bitmap "images/cat.png") )
;  注：运行代码时，记得把图片放置到代码中，或者添加正确的图片路径

; -------------
; 画布常量
; -------------

; 画布尺寸
(define CANVAS-WIDTH
  (* 3 (image-height CHAM-IMG)))

(define CANVAS-HEIGHT
  (* 2 (image-height CHAM-IMG)))

(define CANVAS
  (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))

; -------------
; 快乐指数常量
; -------------
; 快乐指数 = 快乐指数条 + 快乐指数面板

; 快乐指数宽度
(define HAPPINESS-BAR-WIDTH 
  ( * 0.1 (image-width CHAM-IMG)))

; happiness-bar-height 是一动态值，见下方

; 快乐指数面板宽度与高度
(define HAPPINESS-PANEL-WIDTH
  (+ 2 HAPPINESS-BAR-WIDTH))

(define HAPPINESS-PANEL-HEIGHT 
  CANVAS-HEIGHT)

; 快乐指数面板
(define HAPPINESS-PANEL 
  (empty-scene HAPPINESS-PANEL-WIDTH HAPPINESS-PANEL-HEIGHT))

; -------------
; 数值常量
; -------------

; 变色龙移动速度
(define MOVE-SPEED 3)

; 快乐指数增加幅度
(define HAPPINESS-FEED-INCREMENT 2)

; 变色龙在画布中行走时的高度
(define CHAM-Y-POSITION
  (- CANVAS-HEIGHT (image-height CHAM-IMG)))

; 快乐指数条在快乐指数面板中的位置
(define HAPPINESS-BAR-X-POSITION
  (/ HAPPINESS-PANEL-WIDTH 2))

; 注，happiness-bar-y-position 是一动态值，见下方

; ======
; 结构体
; ======

; VCham 是结构体，表示变色龙的各个状态
(define-struct vcham [x happiness color])
; 一个 VCham 是 (make-vcham number number string)
; 解释
; - x：变色龙在画布中的横坐标 [0,CANVAS-WIDTH]
; - happiness：变色龙的快乐值的具体数据 [0,CANVAS-HEIGHT]
; - color：变色龙的具体色彩，分为："red","green","blue"

; 注：
; 看到 VCham 的单词写法，马上就要知道，这是一结构体
; htdp2e 中文版，P105 页，以 r3 与 R3 的方式，暗示了这里的用法。 
; 详见：https://github.com/programmint/HtDP2e-insights/blob/main/Notes/htdp2e%20%E5%AD%A6%E4%B9%A0%E9%9A%8F%E8%AE%B0%20-%20%E7%96%91%E9%97%AE%E9%87%8D%E7%82%B9%E5%BF%83%E5%BE%97-%E5%90%88%E9%9B%86.md#58%E7%BB%93%E6%9E%84%E4%BD%93%E7%9A%84%E8%AE%BE%E8%AE%A1designing-with-structures

; 测试 VCham 结构体
(check-expect (make-vcham 10 100 "red") (make-vcham 10 100 "red"))
(check-expect (make-vcham 0 0 "blue") (make-vcham 0 0 "blue"))
(check-expect (vcham-x (make-vcham 10 100 "red")) 10)
(check-expect (vcham-happiness (make-vcham 10 100 "red")) 100)
(check-expect (vcham-color (make-vcham 10 100 "red")) "red")

; ================
; 主函数
; ================

; happy-cham 主函数
; vcham -> worldstate
(define (happy-cham state)
  (big-bang state
   [on-tick update-state]
   [on-key handle-key]
   [on-draw render]))

; ================
; 辅助函数
; ================

; ============
; 更新状态函数
; ============

; 实时更新变色龙的各个状态
; vcham -> number number string
(define (update-state state)
 (make-vcham
  (next-x state)
  (next-happiness state)
  (next-color state))) 

; 测试 update-state 函数
(check-expect (update-state (make-vcham 10 100 "red"))
              (make-vcham 
               (next-x (make-vcham 10 100 "red"))
               (next-happiness (make-vcham 10 100 "red"))
               (next-color (make-vcham 10 100 "red"))))


; ----------------
; 计算下一个 x 坐标
; ----------------

; vcham -> number
(define (next-x state)
  (modulo
   (+ (vcham-x state) MOVE-SPEED)
   CANVAS-WIDTH))

; 测试 next-x 函数
(check-expect (next-x (make-vcham 10 100 "red"))
              (modulo (+ 10 MOVE-SPEED) CANVAS-WIDTH)) 

(check-expect (next-x (make-vcham (- CANVAS-WIDTH 1) 100 "red"))
              (modulo (+ (- CANVAS-WIDTH 1) MOVE-SPEED) CANVAS-WIDTH))

(check-expect (next-x (make-vcham (- CANVAS-WIDTH 2) 100 "red"))
              (modulo (+ (- CANVAS-WIDTH 2) MOVE-SPEED) CANVAS-WIDTH))

; ----------------
; 计算下一快乐指数
; ----------------
; 时钟每滴答一次，快乐指数都会相应降低 0.5
;   - 快乐指数，最低不能小于 0
;   注:题目要求是减少 0.1，但0.1 在视觉上变化太慢，用 0.5 加速视觉变化。
; VCham -> number 
(define (next-happiness state) 
  (max 0 (- (vcham-happiness state) 0.5)))

; 测试 next-happiness 函数
(check-expect (next-happiness (make-vcham 10 100 "red")) 99.5)
(check-expect (next-happiness (make-vcham 10 0.4 "red")) 0)
(check-expect (next-happiness (make-vcham 10 0 "red")) 0)

; ----------------
; 获取下一种色彩
; ----------------
; 实时获取下一种色彩信息
; vcham -> string
(define (next-color state)
  (vcham-color state))

; 测试 next-color 函数
(check-expect (next-color (make-vcham 10 100 "red")) "red")
(check-expect (next-color (make-vcham 10 100 "green")) "green")
(check-expect (next-color (make-vcham 10 100 "blue")) "blue")

; ================
; 按键函数
; ================

; 依据按键，更新不同数值
; - 按向下键，快乐指数值 + 2，按其他键无效
; - 按“r”键，渲染出 red 变色龙
; - 按“g”键，渲染出 green 变色龙
; - 按“b”键，渲染出 blue 变色龙
; vcham keyevent -> vcham 
(define (handle-key state key)
  (cond
   [(key=? key "down") (make-vcham (vcham-x state)
                                   (+ (vcham-happiness state) HAPPINESS-FEED-INCREMENT)
                                   (vcham-color state))]

   [(key=? key "r") (make-vcham (vcham-x state)
                                (vcham-happiness state)
                                "red")]

   [(key=? key "g") (make-vcham (vcham-x state)
                                (vcham-happiness state)
                                "green")]

   [(key=? key "b") (make-vcham (vcham-x state)
                                (vcham-happiness state)
                                "blue")]
   [else state]))

; 测试 handle-key 函数
(check-expect (handle-key (make-vcham 10 100 "red") "down")
              (make-vcham 10 (+ 100 HAPPINESS-FEED-INCREMENT) "red"))

(check-expect (handle-key (make-vcham 10 100 "red") "r")
              (make-vcham 10 100 "red"))

(check-expect (handle-key (make-vcham 10 100 "red") "g")
              (make-vcham 10 100 "green"))

(check-expect (handle-key (make-vcham 10 100 "red") "b")
              (make-vcham 10 100 "blue"))

(check-expect (handle-key (make-vcham 10 100 "red") "up")
              (make-vcham 10 100 "red"))

; ================
; 渲染图像函数
; ================
; 实时渲染快乐指数、变色龙图片
; vcham -> image
(define (render state)
  (beside/align "bottom"
   (render-happiness-level state)
   (render-cham state)))

; ----------------
; 渲染快乐指数图像
; ----------------
; 依据实时信息，渲染快乐指数图像(快乐指数条+快乐面板)
; 快乐指数条的高度，不断动态变化
; vcham -> image
(define (render-happiness-level state)
  (place-image
   (happiness-bar state) 
   HAPPINESS-BAR-X-POSITION
   (happiness-bar-y-position state)
   HAPPINESS-PANEL))

; 创建快乐指数条图像
; vcham -> image
(define (happiness-bar state)
  (rectangle HAPPINESS-BAR-WIDTH (happiness-bar-height state) "solid" "Medium Orange"))

; 计算快乐指数条高度
; - 快乐指数条高度 [0 CANVAS-HEIGHT]
; vcham -> number
(define (happiness-bar-height state)
  (min CANVAS-HEIGHT (vcham-happiness state)))

; 计算快乐指数条在快乐指数面板中的高度
; vcham -> number
(define (happiness-bar-y-position state)
  (- HAPPINESS-PANEL-HEIGHT (/ (happiness-bar-height state) 2)))

; 测试 happiness-bar-height 函数
(check-expect (happiness-bar-height (make-vcham 10 50 "red")) 50)
(check-expect (happiness-bar-height (make-vcham 10 CANVAS-HEIGHT "red")) CANVAS-HEIGHT)
(check-expect (happiness-bar-height (make-vcham 10 (+ CANVAS-HEIGHT 10) "red")) CANVAS-HEIGHT)

; 测试 happiness-bar-y-position 函数
(check-expect (happiness-bar-y-position (make-vcham 10 50 "red"))
              (- HAPPINESS-PANEL-HEIGHT (/ (happiness-bar-height (make-vcham 10 50 "red")) 2)))

(check-expect (happiness-bar-y-position (make-vcham 10 0 "red"))
              (- HAPPINESS-PANEL-HEIGHT (/ (happiness-bar-height (make-vcham 10 0 "red")) 2)))



; ----------------
; 渲染变色龙图像
; ----------------
; 依据实时信息，渲染某一种变色龙行走图像
; vcham -> image
(define (render-cham state)
  (place-image 
   (overlay
    CHAM-IMG
    (color-bg-img state))
   (vcham-x state)
   CHAM-Y-POSITION
   CANVAS))

; 依据实时信息，渲染对应的色彩背景
; vcham -> image
(define (color-bg-img state)
  (rectangle
   (image-width CHAM-IMG)
   (image-height CHAM-IMG)
   "solid"
   (vcham-color state)))


; 测试 color-bg-img 函数
(check-expect (color-bg-img (make-vcham 10 100 "red"))
              (rectangle
               (image-width CHAM-IMG)
               (image-height CHAM-IMG)
               "solid"
               "red"))

(check-expect (color-bg-img (make-vcham 10 100 "blue"))
              (rectangle
               (image-width CHAM-IMG)
               (image-height CHAM-IMG)
               "solid"
               "blue"))

; =====================
; 程序启动
; ===================== 
(happy-cham (make-vcham 0 100 "red"))