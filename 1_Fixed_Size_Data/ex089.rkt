; ex089

; ====================
; 全局目的
; ====================

; 设计 happy-cat 世界程序，把猫于背景中运动，以及快乐指数结合在一起。
; 支持按键交互。
; 快乐指数为纵向。

; =====
; 问题？
; =====

; 快乐指数方向?
; 快乐指数，无论是横向，还是纵向，都可以，我选择了纵向。
; 如果快乐指数为横向，其变化效果，与猫的运动方向一致，造成部分视觉干扰，所以不选。
; 写好代码后，才发现：快乐指数为纵向也未必好。

; 限定条件？
; 第 89 题并没有提限定条件，所以代码中也没有设置限定条件，到了 90 - 91 题，才加上限定条件。 

; 下箭头：增加还是减少当前值的 1/5？
; 这里，纸质版图书，以及网络版内容，二者有区别
; 纸质版：增加
; 网络版：减少

; 详见：
; 47 题：增加与减少的区别 https://github.com/programmint/HtDP2e-insights/blob/main/Notes/htdp2e%20%E5%AD%A6%E4%B9%A0%E9%9A%8F%E8%AE%B0%20-%20%E7%96%91%E9%97%AE%E9%87%8D%E7%82%B9%E5%BF%83%E5%BE%97-%E5%90%88%E9%9B%86.md#47-%E9%A2%98%E5%A2%9E%E5%8A%A0%E4%B8%8E%E5%87%8F%E5%B0%91%E7%9A%84%E5%8C%BA%E5%88%AB

; ------------------------------代码部分 --------------------------------------------------------------

; =======
; 常量定义
; =======

; 猫图像
(define CAT-IMG (bitmap "images/cat.png"))  ; 运行代码时，记得把图片放置到代码中，或者添加正确的图片路径

; 猫运动背景
(define CAT-BG-WIDTH 
  (* 10 (image-width CAT-IMG))) 

(define CAT-BG-HEIGHT 
  (* 2 (image-height CAT-IMG)))

(define CAT-BG
  (empty-scene CAT-BG-WIDTH CAT-BG-HEIGHT))

; 快乐指数条宽度
(define HAPPINESS-BAR-WIDTH
  (* (image-width CAT-IMG) 0.1))

; 快乐指数面板（快乐指数条置于其中）
(define HAPPINESS-PANEL-BG-WIDTH
  (+ HAPPINESS-BAR-WIDTH 2))

(define HAPPINESS-PANEL-BG
  (empty-scene HAPPINESS-PANEL-BG-WIDTH CAT-BG-HEIGHT))


; ===========
; 结构体
; ===========

; vcat 是结构体，表示猫的状态
(define-struct vcat [x happiness])
; 一个 vcat 是 (make-vcat number number）
; 解释
; - x: 猫在背景内的x坐标
; - happiness: 猫的快乐指数 [0-100]

; 测试 vcat 的 x 和 happiness
(check-expect 
  (vcat-x (make-vcat 0 100)) 0)

(check-expect 
  (vcat-happiness (make-vcat 50 80)) 80)

; =====================
; 主函数
; =====================

; happy-cat 主函数
; vcat -> wordstate
(define (happy-cat state)
  (big-bang state 
   [on-tick update-tock]
   [on-key handle-key]
   [to-draw render]))

; =====================
; 辅函数
; ===================== 

; -----------
; 时钟滴答函数
; -----------

; 时钟滴答一次，更新一次猫的位置和快乐指数
; vcat -> vcat 
(define (update-tock state)
  (make-vcat
   (next-x state)
   (next-happiness state)))

; 测试 updata-tock 整体更新
(check-expect 
  (update-tock (make-vcat 20 57))
  (make-vcat 23 56.5))

; 计算下一帧猫的横坐标（猫向右运动 + 3 像素）
; vcat -> number 
(define (next-x state)
  (+ (vcat-x state) 3))

; 测试 next-x
(check-expect
  (next-x (make-vcat 10 57))
  13)

; 时钟每滴答一次，快乐指数都会相应降低 0.5
;   - 快乐指数，最低不等于 0
(define (next-happiness state) 
    (max 0 (- (vcat-happiness state) 0.5)))
 
;   注：题目要求是减少 0.1，但0.1 在视觉上变化太慢，用 0.5 加速视觉变化。

; 测试 next-happiness 
(check-expect
  (next-happiness (make-vcat 10 20))
  19.5)

(check-expect
  (next-happiness (make-vcat 10 0))
  0)

; -----------
; 按键函数
; -----------

; 依据按键，更新快乐指数
; - 上箭头：增加当前值的 1/3（最高 100）
; - 下箭头：增加当前值的 1/5（最低 0） （注意，纸质版：增加；网络版：减少）
; vcat key -> number
(define (handle-key state key)
  (cond
   [(key=? key "up") (make-vcat (vcat-x state)
                                (min 100 (* (vcat-happiness state) (+ 1 1/3))))]
   [(key=? key "down") (make-vcat (vcat-x state)
                                  (max 0 (* (vcat-happiness state) (+ 1 1/5))))]
   [else state]))

; 测试上箭头键
(check-expect
  (handle-key (make-vcat 10 9 ) "up")
  (make-vcat 10 12))

(check-expect
  (handle-key (make-vcat 10 102 ) "up")
  (make-vcat 10 100))

; 测试下箭头键
(check-expect
  (handle-key (make-vcat 10 10 ) "down")
  (make-vcat 10 12))

(check-expect
  (handle-key (make-vcat 10 -1 ) "down")
  (make-vcat 10 0))

; 测试其他键
(check-expect
  (handle-key (make-vcat 10 10 ) "left")
  (make-vcat 10 10))

; -----------
; 渲染图像函数
; -----------

;实时渲染快乐指数及猫行走的图像
; image vcat -> image 
(define (render state)
  (beside/align "bottom"
                (happiness-level state)
                (render-cat state)))

; --------------
; 快乐指数图像函数
; --------------

; 渲染快乐指数
; vcat -> image 
(define (happiness-level state)
  (place-image 
   (happiness-bar state)
   (/ HAPPINESS-PANEL-BG-WIDTH 2)
   (- CAT-BG-HEIGHT (/ (happiness-bar-height state) 2))
   HAPPINESS-PANEL-BG))

; 创建快乐指数条
; vcat -> image
(define (happiness-bar state)
  (rectangle HAPPINESS-BAR-WIDTH (happiness-bar-height state) "solid" "red"))

; 计算快乐指数条高度（高度不停变化）
; - 快乐指数高度 [0-100]
; vcat -> number
(define ( happiness-bar-height state)
  (* CAT-BG-HEIGHT (/ (vcat-happiness state) 100)))

; 测试快乐指数高度
(check-expect 
  (happiness-bar-height (make-vcat 0 0)) 
  0)

(check-expect 
  (happiness-bar-height (make-vcat 0 100))
  CAT-BG-HEIGHT)

; --------------
; 猫行走图像函数
; --------------

; 猫行走函数
; image number number image -> image 
(define (render-cat state)
  (place-image 
   CAT-IMG
   (vcat-x state) (- CAT-BG-HEIGHT (/ (image-height CAT-IMG) 2) 2) ;减去2，是为了猫的图片在背景底边之上，视觉上更好一些。
   CAT-BG))

; =====================
; 程序启动
; ===================== 
(happy-cat (make-vcat 0 100))