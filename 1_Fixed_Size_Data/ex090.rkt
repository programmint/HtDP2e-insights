; ex090

; ====================
; 全局目的
; ====================

; 设计 happy-cat 世界程序，把猫于背景中运动，以及快乐指数结合在一起。
; 支持按键交互。
; 快乐指数为纵向，当快乐指数为 0 时，猫会停止运动。
; 程序停止了，会有对应的提示文案出现。（这个是我自己加的，因为这一条件，代码确实变复杂了）

; =======
; 问题？
; =======

; 快乐指数能否为 0 ？
; 根据我的测试，特别是多次按键，快乐指数不太容易为 0 
; 这也是测试时发现的。

; 因为题目中采用的数值，会有一些矛盾，例如：
; - 时钟每滴答一次减少快乐度0.5
; - 按下向上键增加当前值的1/3
;  -按下向下键增加当前值的1/5
; 正因如此，代码中的判断条件，多了好多限制。

; ========================
; 怎么样出停止文案的思路变化
; ========================

; 思路经历了 3 次变化。
; 首先，必须得先出现停止文案，而后才能停止函数。（也是测试出来的）
; - 先停止函数，不会出文案，这涉及到 big-bang 的内在机制原理。

; 第 1 次，限制范围值：
; 快乐指数 = 0 时，出现停止文案
; 快乐指数 < 0 时，则停止函数
; 结果，不可行，因为：
; 据定义上不可行，快乐指数不会小于 0 
; 虽然 ui 上可行，快乐指数即便是降为 0 ，视觉上也不容易分辨出来，因为函数迅速停止了运行。
; 这样子，数据定义就没有什么意义了。

; 第 2 次，接受 Ai 建议：
; 快乐指数 <= 0 时，出停止文案
; 快乐指数 = 0 时，停止函数
; 结果，依旧不可行
; 测试时发现：只要是 = 0 ，文案未出，函数迅速停止了运行。
; 无奈，只能使用第 1 次的思路
; 可测试时发现，只要增加了按键，快乐指数不太会等于 0 

; 第 3 次，测试得出数据：
; 通过无规律连续按键，发现考虑了指数的高度，大多数是位于 [0.1 1] 之间
; 这才把出现文案的条件，设置在这个范围内。
; 停止函数，在此数据基础之上，稍稍增大了一点范围，即 < 0.01
; 这种方案，
; 优点：是快乐指数不必降为 0 ，免得与题目要求冲突。
; 缺点：只能是取一个逼近 0 的数字，不算是完全符合题目要求。

; ------------------------------代码部分 --------------------------------------------------------------

; =======
; 常量定义
; =======

; 猫图像
(define CAT-IMG (bitmap "images/cat.png"))  ; 运行代码时,记得把图片放置到代码中,或者添加正确的图片路径

; 猫运动背景
(define CAT-BG-WIDTH 
  (* 8 (image-width CAT-IMG))) 

(define CAT-BG-HEIGHT 
  (* 2 (image-height CAT-IMG)))

(define CAT-BG
  (empty-scene CAT-BG-WIDTH CAT-BG-HEIGHT))

; 快乐指数条宽度
(define HAPPINESS-BAR-WIDTH
  (* (image-width CAT-IMG) 0.1))

; 快乐指数面板(快乐指数条置于其中)
(define HAPPINESS-PANEL-BG-WIDTH
  (+ HAPPINESS-BAR-WIDTH 2))

(define HAPPINESS-PANEL-BG
  (empty-scene HAPPINESS-PANEL-BG-WIDTH CAT-BG-HEIGHT))

; 停止文案图像
(define TEXT-FONT-SIZE 14)

(define STOP-MSG-X
  (/ CAT-BG-WIDTH 2))

(define STOP-MSG-Y
  (/ CAT-BG-HEIGHT 2))

(define STOP-MSG 
  (text "猫已经停止行走" TEXT-FONT-SIZE "red"))

; ===========
; 结构体
; ===========

; vcat 是结构体,表示猫的状态
(define-struct vcat [x happiness])
; 一个 vcat 是 (make-vcat number number)
; 解释
; - x: 猫在背景内的x坐标
; - happiness: 猫的快乐指数 [0-100]

; 测试 vcat 的 x 
(check-expect 
  (vcat-x (make-vcat 0 100)) 0)

; 测试 vcat 的 happiness
(check-expect 
  (vcat-happiness (make-vcat 50 80 )) 80)


; =====================
; 主函数
; =====================

; happy-cat 主函数
; vcat -> wordstate
(define (happy-cat state)
  (big-bang state 
   [on-tick update-tock]
   [on-key handle-key]
   [to-draw render]
   [stop-when end?])) ; 相对 89 题,这里增加了 stop-when 函数

; =====================
; 辅助函数
; ===================== 

; -----------
; 时钟滴答函数
; -----------

; 时钟滴答一次,更新一次猫的位置和快乐指数
; vcat -> vcat 
(define (update-tock state)
  (make-vcat
   (next-x state)
   (next-happiness state)))

; 计算下一帧猫的横坐标(猫向右运动 + 3 像素)
; vcat -> number 
(define (next-x state)
  (+ (vcat-x state) 3))

; 时钟每滴答一次,快乐指数都会相应降低 0.5
;   - 快乐指数,最低可以小于 0
(define (next-happiness state) 
    (max 0 (- (vcat-happiness state) 0.5)))
 
;   注:题目要求是减少 0.1，但0.1 在视觉上变化太慢，用 0.5 加速视觉变化。

; 测试 next-x，输入 10 ，下一次滴答 13
(check-expect
  (next-x (make-vcat 10 57))
  13)

; 测试 next-happiness，输入 20 ，下一次滴答 19.5
(check-expect
  (next-happiness (make-vcat 10 20))
  19.5)

; 测试停止状态 next-happiness，输入 0 ，下一次滴答 0 
(check-expect
  (next-happiness (make-vcat 10 0))
  0)


; -----------
; 按键函数
; -----------

; 依据按键,更新快乐指数
; - 上箭头:增加当前值的 1/3(最高 100)
; - 下箭头:减少当前值的 1/5(最低 0)
; vcat key -> number
(define (handle-key state key)
  (cond
   [(key=? key "up") (make-vcat (vcat-x state)
                                (min 100 (* (vcat-happiness state) (+ 1 1/3))))]
   [(key=? key "down") (make-vcat (vcat-x state)
                                (max 0 (* (vcat-happiness state) (+ 1 1/5))))]
   [else state]))

; 测试按上箭头键，快乐指数由 9 增至 12
(check-expect
  (handle-key (make-vcat 10 9 ) "up")
  (make-vcat 10 12))

; 测试按向上键，快乐指数输入值 102，实际快乐指数值是 100，并不会增长
(check-expect
  (handle-key (make-vcat 10 102 ) "up")
  (make-vcat 10 100))

; 测试按下箭头键，快乐指数由 10 增加为 12
(check-expect
  (handle-key (make-vcat 10 10 ) "down")
  (make-vcat 10 12))

; 测试按下箭头键，快乐指数输入值 -1，实为 0 ，不会增加
(check-expect
  (handle-key (make-vcat 10 -1 ) "down")
  (make-vcat 10 0))

; 测试按其他键，按左键，快乐指数值不变动
(check-expect
  (handle-key (make-vcat 10 10 ) "left")
  (make-vcat 10 10))

; -----------
; 渲染图像函数
; -----------

; 依据条件，实时渲染图像
; image vcat -> image 
(define (render state)
  (cond
   [(about-to-stop? state) (render-stop-scene state)]
   [else (render-normal-scene state)]))

; 检测猫是否即将停止行走？
; vcat -> boolean
(define (about-to-stop? state)
  (and
   (> (next-happiness state) 0.01)
   (< (next-happiness state) 1)))  ; 注：这里的数据条件，是依靠测试而得出

; 渲染停止场景(快乐指数+提示+猫)
; vcat -> image
(define (render-stop-scene state)
 (beside/align "bottom"
                (happiness-level state)
                (render-msg-cat state)))

; 渲染正常场景(快乐指数+猫)
; vcat -> image 
(define (render-normal-scene state)
  (beside/align "bottom"
                (happiness-level state)
                (render-cat state)))

; --------------
; 快乐指数函数
; --------------

; 渲染快乐指数
; vcat -> image 
(define (happiness-level state)
  (place-image 
   (happiness-bar state)
   (/ HAPPINESS-PANEL-BG-WIDTH 2)
   (- CAT-BG-HEIGHT (/ (happiness-bar-height state) 2))
   HAPPINESS-PANEL-BG))

; 创建快乐指数条图像
; vcat -> image
(define (happiness-bar state)
  (rectangle HAPPINESS-BAR-WIDTH (happiness-bar-height state) "solid" "red"))

; 计算快乐指数条高度(高度不停变化)
; - 快乐指数高度 [0-100]
; vcat -> number
(define (happiness-bar-height state)
  (* CAT-BG-HEIGHT (/ (vcat-happiness state) 100)))

; 测试快乐指数输入为 0，快乐指数高度输出为 0
(check-expect 
  (happiness-bar-height (make-vcat 0 0)) 
  0)

; 测试快乐指数输入为 100，快乐指数高度输出：与猫运动背景等高
(check-expect 
  (happiness-bar-height (make-vcat 0 100))
  CAT-BG-HEIGHT)

; --------------
; 猫行走图像函数
; --------------

; 猫停止运动图像（快乐指数+文案+猫）
; vcat-> image
(define (render-msg-cat state)
  (place-image
   STOP-MSG
   STOP-MSG-X
   STOP-MSG-Y
   (render-cat state)))

; 猫正常行走图像（快乐指数+猫）
; vcat-> image
(define (render-cat state)
  (place-image 
   CAT-IMG
   (vcat-x state) (- CAT-BG-HEIGHT (/ (image-height CAT-IMG) 2) 2) ;减去2,是为了猫的图片在背景底边之上,视觉上更好一些。
   CAT-BG))

; --------------
;程序停止函数
; --------------

; vcat -> vcat
(define (end? state)
  (< (next-happiness state) 0.01))

; 注：这里的数据条件，是依靠测试而得出

; =====================
; 程序启动
; ===================== 
(happy-cat (make-vcat 0 100))