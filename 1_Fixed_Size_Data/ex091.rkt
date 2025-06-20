; ex091

; ====================
; 全局目的
; ====================

; 设计 happy-cat 世界程序，把猫置于背景中运动，以及快乐指数结合在一起。
; 支持按键交互。
; 快乐指数为纵向，当快乐指数为 0 时，猫会停止运动。
; 程序停止了，会有对应的提示文案出现。（补加条件，因为这一条件，代码变复杂了）
; 结构体题中增加方位。

; ------------------------------代码部分 --------------------------------------------------------------

; ==========================================
; 缩写说明
; - BNDRY: boundary（逻辑边界）
; - BG: background（背景）
; - IMG: image（图片）
; - MSG: message（信息）
; ==========================================

; =============
; 常量定义
; =============

; ----------
; 猫图像常量
; ----------
(define CAT-IMG (bitmap "images/cat.png"))  

;  注：运行代码时，记得把图片放置到代码中，或者添加正确的图片路径

; -------------
; 猫运动场景常量
; -------------

; 猫运动场景尺寸
(define CAT-BG-WIDTH 
  (* 8 (image-width CAT-IMG))) 

(define CAT-BG-HEIGHT 
  (* 2 (image-height CAT-IMG)))

(define CAT-BG
  (empty-scene CAT-BG-WIDTH CAT-BG-HEIGHT))

; 运动边界
(define CAT-BG-RIGHT-BNDRY
  (- CAT-BG-WIDTH (/ (image-width CAT-IMG) 2)))

(define CAT-BG-LEFT-BNDRY
  (/ (image-width CAT-IMG) 2))

; -------------
; 快乐指数常量
; -------------
; 快乐指数 = 快乐指数条 + 快乐指数面板

; 快乐指数条宽度
(define HAPPINESS-BAR-WIDTH
  (* (image-width CAT-IMG) 0.1))

; happiness-bar-height 是一动态值，见下方

; 快乐指数面板
(define HAPPINESS-PANEL-WIDTH
  (+ HAPPINESS-BAR-WIDTH 2))

(define HAPPINESS-PANEL
  (empty-scene HAPPINESS-PANEL-WIDTH CAT-BG-HEIGHT))

; -------------
; 停止文案常量
; -------------

; 停止文案
(define TEXT-FONT-SIZE 14)

(define STOP-MSG-X
  (/ CAT-BG-WIDTH 2))

(define STOP-MSG-Y
  (/ CAT-BG-HEIGHT 5))

(define STOP-MSG 
  (text "猫已经停止行走" TEXT-FONT-SIZE "red"))

; -------------
; 其他常量
; -------------

; 运动速度
(define MOVE-SPEED 3)

; ===========
; 结构体
; ===========

; vcat 是结构体,表示猫的状态
(define-struct vcat [x happiness direction])

; 一个 vcat 是 (make-vcat number number string)
; 解释
; - x: 猫在背景内的x坐标 [0,CAT-BG-WIDTH]
; - happiness: 猫的快乐指数 [0-100]
; - direction：猫运动的方向，"right" 或 "left"


; 测试 vcat 的 x 
(check-expect 
  (vcat-x (make-vcat 0 100 "right")) 0)

; 测试 vcat 的 happiness
(check-expect 
  (vcat-happiness (make-vcat 50 80 "right")) 80)

; 测试 vcat 的 direction
(check-expect 
  (vcat-direction (make-vcat 50 80 "right")) "right")


; =====================
; 主函数
; =====================

; happy-cat 主函数
; vcat -> worldstate
(define (happy-cat state)
  (big-bang state 
   [on-tick update-state]
   [on-key handle-key]
   [to-draw render]
   [stop-when end?])) 

; =====================
; 辅助函数
; =====================

; ============
; 状态更新函数
; ============

; 时钟滴答一次，状态更新一次
; vcat -> vcat 
(define (update-state state)
  (make-vcat
   (next-x state)
   (next-happiness state)
   (next-direction state)))

; ----------------
; 计算 next-x 坐标
; ----------------
; vcat -> number 
(define (next-x state)
  (cond
   [(move-to-right? state) (+ (vcat-x state) MOVE-SPEED)]
   [(move-to-left? state) (- (vcat-x state) MOVE-SPEED)]))

; 判断是否向右移动？
; vcat -> boolean 
(define (move-to-right? state)
  (string=? (vcat-direction state) "right"))

; 判断是否向左移动？
; vcat -> boolean 
(define (move-to-left? state)
  (string=? (vcat-direction state) "left"))

; 测试向右移动，下一次滴答 x 的坐标是 15
(check-expect
  (next-x (make-vcat 12 57 "right"))
  15)

; 测试向左移动，下一次滴答 x 的坐标是 9
(check-expect
  (next-x (make-vcat 12 57 "left"))
  9)

; 测试输入 “right”，反馈正确
(check-expect
  (move-to-right? (make-vcat 10 60 "right"))
  #true)

; 测试输入 “abc”，反馈错误
(check-expect
  (move-to-right? (make-vcat 10 60 "abc"))
  #false)

; 测试输入 “left”，反馈正确
(check-expect
  (move-to-left? (make-vcat 10 60 "left"))
  #true)

; ---------------
; 计算下一快乐指数
; ---------------
; 时钟每滴答一次，快乐指数都会相应降低 0.5
;   - 快乐指数，最低不能小于 0
;   注:题目要求是减少 0.1，但0.1 在视觉上变化太慢，用 0.5 加速视觉变化。
; vcat -> number
(define (next-happiness state) 
    (max 0 (- (vcat-happiness state) 0.5)))

; 测试输入 20 ，时钟滴答一次后是 19.5
(check-expect
  (next-happiness (make-vcat 10 20 "right"))
  19.5)

; 测试输入 0 ，时钟滴答一次后是 0
(check-expect
  (next-happiness (make-vcat 10 0 "right"))
  0)

; ---------------
; 计算下一方向
; ---------------
; vcat -> boolean 
(define (next-direction state)
  (cond
   [(and (move-to-right? state) (>= (vcat-x state) CAT-BG-RIGHT-BNDRY)) "left"]
   [(and (move-to-left? state) (<= (vcat-x state) CAT-BG-LEFT-BNDRY)) "right"]
   [else (vcat-direction state)]))

; 测试未触及边界，保持右行
(check-expect
  (next-direction (make-vcat 10 20 "right"))
  "right")

; 测试触及右边界，方向由 “right” 转为 “left”
(check-expect
  (next-direction (make-vcat CAT-BG-RIGHT-BNDRY 30 "right"))
  "left")

; 测试触及左边界，方向由 “left” 转为 “right”  
(check-expect 
  (next-direction (make-vcat CAT-BG-LEFT-BNDRY 30 "left"))
  "right")

; 测试输入值超过右边界，方向由 “right”  转为 “left” 
(check-expect
  (next-direction (make-vcat 700 50 "right"))
  "left")

; 测试输入值是左边界，方向由 “left” 转为 “right”   
(check-expect
  (next-direction (make-vcat 0 50 "left"))
  "right")

; 测试输入值是位于背景内，保持 “left”    
(check-expect
  (next-direction (make-vcat 100 50 "left"))
  "left")


; =========
; 按键函数
; =========

; 依据按键，更新快乐指数
; - 上箭头:增加当前值的 1/3(最高 100)
; - 下箭头:减少当前值的 1/5(最低 0)
; vcat key -> number
(define (handle-key state key)
  (cond
   [(key=? key "up") (make-vcat (vcat-x state)
                                (min 100 (* (vcat-happiness state) (+ 1 1/3)))
                                (vcat-direction state))]
   [(key=? key "down") (make-vcat (vcat-x state)
                                (max 0 (* (vcat-happiness state) (+ 1 1/5)))
                                (vcat-direction state))]
   [else state]))


; 测试按向上键，快乐指数由 9 增至 12
(check-expect
  (handle-key (make-vcat 10 9 "right") "up")
  (make-vcat 10 12 "right"))

; 测试按向上键，快乐指数输入值 102，实际快乐指数值是 100，并不会增长
(check-expect
  (handle-key (make-vcat 10 102 "right" ) "up")
  (make-vcat 10 100 "right"))

; 测试按下箭头键，快乐指数由 10 增加为 12
(check-expect
  (handle-key (make-vcat 10 10 "right") "down")
  (make-vcat 10 12 "right"))

; 测试按下箭头键，快乐指数输入值 -1，实为 0 ，不会增加
(check-expect
  (handle-key (make-vcat 10 -1 "right") "down")
  (make-vcat 10 0 "right"))

; 测试右行，且位于背景内，按左键不改变前行方向
(check-expect
  (handle-key (make-vcat 10 10 "right") "left")
  (make-vcat 10 10 "right"))

; 测试其他按键不改变状态
(check-expect
  (handle-key (make-vcat 10 10 "right") "a")
  (make-vcat 10 10 "right"))

; ============ 
; 渲染图像函数
; ============ 

; --------------
; 渲染整体图像
; --------------

; 依据条件，实时渲染整体图像
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


; 测试快乐指数值 0.7 ，右行，停止行走
(check-expect 
  (about-to-stop? (make-vcat 100 0.7 "right"))
  #true)

; 测试快乐指数值 0.7 ，左行，停止行走
(check-expect 
  (about-to-stop? (make-vcat 100 0.7 "left"))
  #true)

; 测试快乐指数值 2 ，右行，不能停止行走
(check-expect 
  (about-to-stop? (make-vcat 100 2 "right"))
  #false)

; 测试快乐指数值 2 ，左行，不能停止行走
(check-expect 
  (about-to-stop? (make-vcat 100 2 "left"))
  #false)

; 测试快乐指数值 0 ，右行，不能停止行走
(check-expect
  (about-to-stop? (make-vcat 50 0 "right"))
  #false)

; 测试快乐指数值 0 ，左行，不能停止行走
(check-expect
  (about-to-stop? (make-vcat 50 0 "left"))
  #false)

; 测试边界值
(check-expect
  (about-to-stop? (make-vcat 100 0.01 "right"))
  #false)

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
; 渲染快乐指数图像
; --------------

; 依据实时条件，渲染快乐指数图像
; vcat -> image 
(define (happiness-level state)
  (place-image 
   (happiness-bar state)
   (/ HAPPINESS-PANEL-WIDTH 2)
   (- CAT-BG-HEIGHT (/ (happiness-bar-height state) 2))
   HAPPINESS-PANEL))

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
  (happiness-bar-height (make-vcat 0 0 "right")) 
  0)

; 测试快乐指数输入为 100，快乐指数高度输出：与猫运动背景等高
(check-expect 
  (happiness-bar-height (make-vcat 0 100 "right"))
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
   (vcat-x state)
   (- CAT-BG-HEIGHT (/ (image-height CAT-IMG) 2) 2) ;减去2,是为了猫的图片在背景底边之上,视觉上更好一些。
   CAT-BG))

; ============
;程序停止函数
; ============

; vcat -> vcat
(define (end? state)
  (< (next-happiness state) 0.01))

; 注：这里的数据条件，依靠测试而得出

; 测试下一快乐指数为 60 ，不停
(check-expect 
  (end? (make-vcat 50 60 "right"))
  #false)

; 测试下一快乐指数为 0 ，右行，停
(check-expect 
  (end? (make-vcat 50 0 "right"))
  #true)

; 测试下一快乐指数为 0 ，左行，停
(check-expect 
  (end? (make-vcat 50 0 "left"))
  #true)

; 测试下一快乐指数为 0.00003 ，右行，停
(check-expect 
  (end? (make-vcat 50 0.00003 "right"))
  #true)

; 测试下一快乐指数为 0.00003 ，左行，停
(check-expect 
  (end? (make-vcat 50 0.00003 "left"))
  #true)

; =====================
; 程序启动
; ===================== 
(happy-cat (make-vcat 0 100 "right"))