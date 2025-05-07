; 93

; ====================
; 全局目的
; ====================
; 设计 happy-cham 程序，包含以下部分：
; 1、变色龙从左至右，穿过画布，到达画布右端，立即出现在画布左侧。
; 2、画布背景，由 3 种不同色彩构成。
; 3、变色龙随着行走，快乐指数值会下降。
; 4、按下向下键键，变色龙开心指数值 + 2，按其他键无效。


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
(define CANVAS
  (beside (empty-scene (image-height CHAM-IMG) (image-height CHAM-IMG) "green") 
          (empty-scene (image-height CHAM-IMG) (image-height CHAM-IMG) "white")
          (empty-scene (image-height CHAM-IMG) (image-height CHAM-IMG) "red")))

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
  (image-height CANVAS))

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
  (/ (image-height CHAM-IMG) 2))

; 快乐指数条在快乐指数面板中的位置
(define HAPPINESS-BAR-X-POSITION
  (/ HAPPINESS-PANEL-WIDTH 2))

; 注，happiness-bar-y-position 是一动态值，见下方

; ======
; 结构体
; ======

; VCham 是结构体，表示变色龙的各个状态
(define-struct vcham [x happiness])
; 一个 VCham 是 (make-vcham number number)
; 解释
; - x：变色龙在画布中的横坐标 [0,CANVAS-WIDTH]
; - happiness：变色龙的快乐值的具体数据 [0,CANVAS-HEIGHT]

; 测试 VCham 结构体
(check-expect (make-vcham 10 100) (make-vcham 10 100))
(check-expect (make-vcham 0 0) (make-vcham 0 0))
(check-expect (vcham-x (make-vcham 10 100)) 10)
(check-expect (vcham-happiness (make-vcham 10 100)) 100)

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
  (next-happiness state))) 

; 测试 update-state 函数
(check-expect (update-state (make-vcham 10 100))
              (make-vcham 
               (next-x (make-vcham 10 100))
               (next-happiness (make-vcham 10 100))))

; ----------------
; 计算下一个 x 坐标
; ----------------

; vcham -> number
(define (next-x state)
  (modulo
   (+ (vcham-x state) MOVE-SPEED)
   (image-width CANVAS)))

; 测试 next-x 函数
(check-expect (next-x (make-vcham 10 100))
              (modulo (+ 10 MOVE-SPEED) (image-width CANVAS)))

(check-expect (next-x (make-vcham (- (image-width CANVAS) 1) 100))
              (modulo (+ (- (image-width CANVAS) 1) MOVE-SPEED) (image-width CANVAS)))

(check-expect (next-x (make-vcham (- (image-width CANVAS) 2) 100))
              (modulo (+ (- (image-width CANVAS) 2) MOVE-SPEED) (image-width CANVAS)))

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
(check-expect (next-happiness (make-vcham 10 100)) 99.5)
(check-expect (next-happiness (make-vcham 10 0.4)) 0)
(check-expect (next-happiness (make-vcham 10 0)) 0)

; ================
; 按键函数
; ================

; 依据按键，更新不同数值
; - 按向下键，快乐指数值 + 2，按其他键无效
; vcham keyevent -> vcham 
(define (handle-key state key)
  (cond
   [(key=? key "down") (make-vcham (vcham-x state)
                                   (+ (vcham-happiness state) HAPPINESS-FEED-INCREMENT))]
   [else state]))

; 测试 handle-key 函数
(check-expect (handle-key (make-vcham 10 100) "down")
              (make-vcham 10 (+ 100 HAPPINESS-FEED-INCREMENT)))

(check-expect (handle-key (make-vcham 10 100) "up")
              (make-vcham 10 100))

(check-expect (handle-key (make-vcham 10 100) "r")
              (make-vcham 10 100))

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
  (min (image-height CANVAS) (vcham-happiness state)))

; 计算快乐指数条在快乐指数面板中的高度
; vcham -> number
(define (happiness-bar-y-position state)
  (- HAPPINESS-PANEL-HEIGHT (/ (happiness-bar-height state) 2)))

; 测试 happiness-bar-height 函数
(check-expect (happiness-bar-height (make-vcham 10 50)) 50)
(check-expect (happiness-bar-height (make-vcham 10 (image-height CANVAS))) (image-height CANVAS))
(check-expect (happiness-bar-height (make-vcham 10 (+ (image-height CANVAS) 10))) (image-height CANVAS))

; 测试 happiness-bar-y-position 函数
(check-expect (happiness-bar-y-position (make-vcham 10 50))
              (- HAPPINESS-PANEL-HEIGHT (/ (happiness-bar-height (make-vcham 10 50)) 2)))

(check-expect (happiness-bar-y-position (make-vcham 10 0))
              (- HAPPINESS-PANEL-HEIGHT (/ (happiness-bar-height (make-vcham 10 0)) 2)))

; 测试 happiness-bar 函数
(check-expect (happiness-bar (make-vcham 10 50))
              (rectangle HAPPINESS-BAR-WIDTH 50 "solid" "Medium Orange"))
              
(check-expect (happiness-bar (make-vcham 10 0))
              (rectangle HAPPINESS-BAR-WIDTH 0 "solid" "Medium Orange"))

; ----------------
; 渲染变色龙图像
; ----------------
; 依据实时信息，渲染某一种变色龙行走图像
; vcham -> image
(define (render-cham state)
  (place-image 
   CHAM-IMG
   (vcham-x state)
   CHAM-Y-POSITION
   CANVAS))

; =====================
; 程序启动
; ===================== 
(happy-cham (make-vcham 0 100))