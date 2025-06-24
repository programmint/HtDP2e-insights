;;; ex101-102

;; 全局目的：完成太空游戏 
;; 主要功能：
;; - 实时渲染游戏图像
;; - TANK 发射 MISSILE ，打击 UFO
;; - UFO 触地或击中 UFO，游戏结束，并渲染游戏结束画面

;;; ==========================================
;;; 说明
;;; ==========================================

;; 数据定义不同
;; 前面 98、99、100 题，与 101-102 题的区别，是数据定义不同。
;; 前者是分为 aim 和 fired 状态，后者只有一种状态。
;; 对比，前者代码麻烦，后者代码简单。

;; 嵌套 place-image，place-images
;; 渲染图像时，htdp2e 采用的方法是嵌套 place-image
;; 我采用的方法，则是 place-images，嵌套 place-image 理解起来比较麻烦

;; 渲染次序
;; 无论是嵌套 place-image，还是利用 place-images，都要注意渲染次序

;;; ==========================================
;;; 术语
;;; ==========================================
;; - IMG / img : Image(图片)


;;; ==========================================
;;; 常量定义
;;; ==========================================

;; ------------------------------------------
;; 场景与图像常量

;; 场景尺寸
(define SCENE-WIDTH 300)
(define SCENE-HEIGHT 300)
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

;; MISSILE 图像
(define MISSILE-IMG
  (triangle 8 "solid" "black"))

;; UFO 图像
(define UFO-IMG
  (overlay (rectangle 22 4 "solid" "gray")
           (circle 6 "solid" "gray")))

;; TANK 图像
(define TANK-IMG
  (rectangle 30 8 "solid" "black"))


;; ------------------------------------------
;; 游戏物理常量

;; UFO 下降速度
(define UFO-SPEED 3)

;; MISSILE 上升速度
(define MISSILE-SPEED (* 2.5 UFO-SPEED))

;; MISSILE与 UFO 图像之间的安全距离
(define SAFE-DISTANCE
  (/ (image-width UFO-IMG) 2))

;; UFO 触地距离
(define UFO-LANDED-DISTANCE
  (- SCENE-HEIGHT (/ (image-height UFO-IMG) 2)))

;; UFO 跳动距离
(define JUMP-RANGE 21)

;; UFO 左右随机跳动距离(偏移距离)
(define JUMP-OFFSET 10)

;; TANK 位于地面高度
(define TANK-HEIGHT
  (- SCENE-HEIGHT (/ (image-height TANK-IMG) 2)))

;; TANK 一半宽度
(define HALF-TANK-WIDTH (/ (image-width TANK-IMG) 2))

;; UFO 一半宽度
(define HALF-UFO-WIDTH (/ (image-width UFO-IMG) 2))

;; MISSILE 一半高度
(define HALF-MISSILE-HEIGHT (/ (image-height MISSILE-IMG) 2))

;; 场景一半宽度
(define HALF-SCENE-WIDTH (/ SCENE-WIDTH 2))


;; ------------------------------------------
;; 界面展示元素常量

;; 游戏结束提示文案
(define END-MSG
  (text "游戏已结束" 16 "red"))

;; 通用结束画面
(define GLOBAL-IMG
  (place-image END-MSG
               (/ SCENE-WIDTH 2)
               (/ SCENE-HEIGHT 2)
               SCENE))


;;; ==========================================
;;; UFO 数据定义
;;; ==========================================

;; UFO 是结构体，表示 UFO 在背景中的位置
(define-struct ufo [x y])
;; 一个 UFO 是(make-ufo number number)
;; 解释:
;; - x 是 UFO 从左到右的位置
;; - y 是 UFO 从上到下的位置

;; 测试 UFO 结构体
(check-expect (ufo-x (make-ufo 50 20)) 50)
(check-expect (ufo-y (make-ufo 50 20)) 20)


;;; ==========================================
;;; TANK 数据定义
;;; ==========================================


;; TANK 是结构体，表示坦克在背景中的位置
(define-struct tank [x vel])
;; 一个 TANK 是 (make-tank number number)
;; 解释:
;; - x 是 TANK 从左到右的位置（高度固定为 TANK-HEIGHT)
;; - vel 是 TANK 的运动速度，+ 表示向右，- 表示向左

; 测试 TANK 结构体
(check-expect (tank-x (make-tank 50 20)) 50)
(check-expect (tank-vel (make-tank 50 20)) 20)


;;; ==========================================
;;; MISSILE 数据定义
;;; ==========================================

;; MISSILE 是下列之一
;; -- #false
;; -- （make-missile x y）
;; 解释:
;; #false 表示导弹还在坦克中
;; (make-missile x y) 表示导弹在背景中的位置

;; 其中需要以下结构体定义
(define-struct missile [x y])
;; 一个 MISSILE 是 (make-missile number number)
;; 结构体解释：
;;  - x 是 MISSILE 从左到右的位置
;;  - y 是 MISSILE 从上到下的位置

; 测试 MISSILE
(check-expect #false #false)
(check-expect (missile-x (make-missile 50 60)) 50)
(check-expect (missile-y (make-missile 50 60)) 60)


;;; ==========================================
;;; 游戏数据定义
;;; ==========================================

;; SIGS.v2 是结构体，表示MISSILE、UFO、TANK 位于背景中
(define-struct sigs [missile ufo tank])
;; (make-sigs MissileOrNot UFO TANK) ; 数据定义顺序 = 渲染次序
;; 解释:表示空间入侵者游戏的完整状态


;;; ==========================================
;;; 游戏主程序
;;; ==========================================

;; SIGS -> SIGS
;; 太空入侵者游戏主函数
(define (si-game state)
  (big-bang state
    [on-tick si-move]                        ; 第 99 题
    [on-key si-control]                      ; 第 100 题
    [to-draw si-render.v2]                   ; 第 99 题
    [stop-when si-game-over? end-scene]))    ; 第 98 题


;;; ===========================================
;;; 位置接口函数
;;; ===========================================

;; 时钟滴答一次，更新一次状态
;; SIGS -> SIGS
(define (si-move state)
  (si-move-proper state (- (random JUMP-RANGE) JUMP-OFFSET)))

; 注
; 该函数无法测试


;; ===========================================
;; 新位置接口函数
;; ===========================================
;; SIGS Number -> SIGS
(define (si-move-proper state delta)
  (sigs-next-posn state delta))


;; ===========================================
;; 计算新位置函数
;; ===========================================

;; 实时更新 SIGS 的位置
;; SIGS -> SIGS
(define (sigs-next-posn state delta)
  (make-sigs
   (missile-next-posn state)
   (ufo-next-posn state delta) 
   (tank-next-posn state)))

;; 测试 sigs-next-posn 函数
(check-expect 
 (sigs-next-posn 
  (make-sigs #false (make-ufo 50 50) (make-tank 100 5)) 
  10)
 (make-sigs #false (make-ufo 60 53) (make-tank 105 5)))

(check-expect 
 (sigs-next-posn 
  (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)) 
  10)
 (make-sigs (make-missile 100 192.5) (make-ufo 60 53) (make-tank 105 5)))


;; ===========================================
;; 计算 MISSILE、UFO、TANK 新位置
;; ===========================================

;; 计算 MISSILE 新位置
;; SIGS -> MISSILE
(define (missile-next-posn state)
  (cond
    [(boolean? (sigs-missile state)) #false]
    [(missile? (sigs-missile state))
     (make-missile 
      (missile-x (sigs-missile state))
      (- (missile-y (sigs-missile state)) MISSILE-SPEED))]))
  

;; 计算 UFO 新位置
;; SIGS -> UFO
(define (ufo-next-posn state delta)
  (make-ufo
   (ufo-x-in-boundary (+ (ufo-x (sigs-ufo state)) delta))
   (+ (ufo-y (sigs-ufo state)) UFO-SPEED)))

;; 发射火箭状态，计算 TANK 新位置
;; SIGS -> TANK
(define (tank-next-posn state)
  (make-tank
   (tank-x-in-boundary (+ (tank-x (sigs-tank state)) (tank-vel (sigs-tank state))))
   (tank-vel (sigs-tank state))))

; 测试 missile-next-posn 函数
(check-expect 
 (missile-next-posn (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))
 #false)

(check-expect 
 (missile-next-posn (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
 (make-missile 100 192.5))

; 测试 ufo-next-posn 函数
(check-expect 
 (ufo-next-posn (make-sigs #false (make-ufo 50 50) (make-tank 100 5)) 10)
 (make-ufo 60 53))

(check-expect 
 (ufo-next-posn (make-sigs #false (make-ufo 290 50) (make-tank 100 5)) 10)
 (make-ufo 150 53))  ; UFO 触边界，回到中心

; 测试 tank-next-posn 函数
(check-expect 
 (tank-next-posn (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))
 (make-tank 105 5))

(check-expect 
 (tank-next-posn (make-sigs #false (make-ufo 50 50) (make-tank 310 5)))
 (make-tank 315 5)) 


;; ===========================================
;; 边界处理函数
;; ===========================================

;; TANK 边界，一侧出，另一侧进
;; Number -> Number
(define (tank-x-in-boundary x)
  (cond
    ; TANK 位于左边界，从右边界进入
    [(< x (- HALF-TANK-WIDTH)) (+ SCENE-WIDTH HALF-TANK-WIDTH)]
  
    ; TANK 位于右边界，从左边界进入
    [(> x ( + SCENE-WIDTH HALF-TANK-WIDTH)) (- HALF-TANK-WIDTH)]
  
    [else x])) 

; 测试坦克边界处理
(check-expect (tank-x-in-boundary -20) 315)
(check-expect (tank-x-in-boundary 320) -15)
(check-expect (tank-x-in-boundary 150) 150)


;; UFO 边界，超出边界，则跳返回背景中间
;; SIGS -> Number
(define (ufo-x-in-boundary x)
  (cond
    ; UFO 位于左边界，返回中间
    [(<= x HALF-UFO-WIDTH) HALF-SCENE-WIDTH]
  
    ; UFO 位于右边界，返回中间
    [(>= x (- SCENE-WIDTH HALF-UFO-WIDTH)) HALF-SCENE-WIDTH]
  
    [else x]))

; 测试 UFO 边界处理
(check-expect (ufo-x-in-boundary 5) 150)
(check-expect (ufo-x-in-boundary 295) 150)
(check-expect (ufo-x-in-boundary 100) 100)


;;; ===========================================
;;; 游戏按键事件函数
;;; ===========================================

;; 按键控制游戏元素
;; - 按左箭头，坦克向左移动
;; - 按右箭头，坦克向右移动
;; - 按空格，发射火箭
;; SIGS Keyevent -> SIGS 
(define (si-control state key)
  (cond
    [(key=? key "left") (tank-move-left state)]
    [(key=? key "right") (tank-move-right state)]
    [(and (boolean? (sigs-missile state)) (key=? key " ")) (missile-to-fired state)]
    [else state]))

; 测试 si-control 函数
(check-expect 
 (si-control (make-sigs #false (make-ufo 50 50) (make-tank 100 5)) "left")
 (make-sigs #false (make-ufo 50 50) (make-tank 100 -5)))

(check-expect 
 (si-control (make-sigs #false (make-ufo 50 50) (make-tank 100 -5)) "right")
 (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
 (si-control (make-sigs #false (make-ufo 50 50) (make-tank 100 5)) " ")
 (make-sigs (make-missile 100 292.5) (make-ufo 50 50) (make-tank 100 5)))

; 测试已有导弹时按空格无效
(check-expect 
 (si-control (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)) " ")
 (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))

; 测试无效按键
(check-expect 
 (si-control (make-sigs #false (make-ufo 50 50) (make-tank 100 5)) "a")
 (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))


;; ===========================================
;; 坦克左移函数
;; ===========================================

;; 按左键，坦克向左移动
;; SIGS -> SIGS
(define (tank-move-left state)
  (make-sigs
   (sigs-missile state)
   (sigs-ufo state)
   (make-tank
    (tank-x (sigs-tank state))
    (- (abs (tank-vel (sigs-tank state)))))))

; 测试 tank-move-left 函数
(check-expect 
 (tank-move-left (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))
 (make-sigs #false (make-ufo 50 50) (make-tank 100 -5)))

(check-expect 
 (tank-move-left (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
 (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 -5)))


;; ===========================================
;; 坦克右移函数
;; ===========================================

;; 按右键，坦克向右移动
;; SIGS -> SIGS
(define (tank-move-right state)
  (make-sigs
   (sigs-missile state)
   (sigs-ufo state)
   (make-tank
    (tank-x (sigs-tank state))
    (abs (tank-vel (sigs-tank state))))))

; 测试 tank-move-right 函数
(check-expect 
 (tank-move-right (make-sigs #false (make-ufo 50 50) (make-tank 100 -5)))
 (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
 (tank-move-right (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 -5)))
 (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))


;; ===========================================
;; 发射火箭函数
;; ===========================================

;; 按下空格，发射火箭
;; SIGS -> UFO 
(define (missile-to-fired state)
  (cond
    [(boolean? (sigs-missile state)) 
     (make-sigs
      (make-missile
       (tank-x (sigs-tank state))
       (- TANK-HEIGHT HALF-MISSILE-HEIGHT))
      (sigs-ufo state)
      (sigs-tank state))]
    [else state]))

; 测试 missile-to-fired 函数
(check-expect 
 (missile-to-fired (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))
 (make-sigs (make-missile 100 292.5) (make-ufo 50 50) (make-tank 100 5)))

; 测试已有导弹时发射无效
(check-expect 
 (missile-to-fired (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
 (make-sigs (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))


;;; ===========================================
;;; 渲染游戏图像函数
;;; ===========================================

;; 依据不同状态，实时渲染图像
;; SIGS -> Image
(define (si-render.v2 state)
  (cond
    [(boolean? (sigs-missile state)) (aim-render state)]
    [(missile? (sigs-missile state)) (fired-render state)]))


;; ===========================================
;; 实时渲染瞄准图像
;; ===========================================
;; SIGS -> Image
(define (aim-render state)
  (place-images
   (list UFO-IMG TANK-IMG)
   (list (make-posn 
          (ufo-x (sigs-ufo state))
          (ufo-y (sigs-ufo state)))
         (make-posn
          (tank-x (sigs-tank state))
          TANK-HEIGHT))
   SCENE))


;; ===========================================
;; 实时渲染发射火箭图像
;; ===========================================
;; SIGS -> Image
(define (fired-render state)
  (place-images
   (list MISSILE-IMG UFO-IMG TANK-IMG)
   (list (make-posn 
          (missile-x (sigs-missile state))
          (missile-y (sigs-missile state)))
         (make-posn 
          (ufo-x (sigs-ufo state))
          (ufo-y (sigs-ufo state)))
         (make-posn
          (tank-x (sigs-tank state))
          TANK-HEIGHT))
   SCENE))


;;; ===========================================
;;; 游戏停止逻辑函数
;;; ===========================================

;; 判断游戏是否停止?
;; - UFO 触地，游戏立即结束(全局条件)
;; - 导弹击中 UFO 时游戏结束
;; SIGS -> Boolean
(define (si-game-over? state)
  (cond
    [(ufo-landed? state) #true] ;结构体定义，无论怎么样都有 UFO
    [(and (missile? (sigs-missile state)) (missile-hit-ufo? state)) #true]
    [else #false]))

; 测试 si-game-over? 函数
(check-expect 
 (si-game-over? (make-sigs #false (make-ufo 50 50) (make-tank 100 5)))
 #false)

(check-expect 
 (si-game-over? (make-sigs #false (make-ufo 50 297) (make-tank 100 5)))
 #true)


;; ===========================================
;; UFO 着陆检测函数
;; ===========================================

;; UFO 着陆检测?
;; SIGS -> Boolean
(define (ufo-landed? state)
  (>= (ufo-y (sigs-ufo state))
      UFO-LANDED-DISTANCE))

; 测试 ufo-landed? 函数
(check-expect
 (ufo-landed? (make-sigs #false (make-ufo 30 297) (make-tank 50 5)))
 #true)

(check-expect
 (ufo-landed? (make-sigs (make-missile 50 30) (make-ufo 30 297) (make-tank 50 5)))
 #true)

(check-expect
 (ufo-landed? (make-sigs #false (make-ufo 30 100) (make-tank 50 5)))
 #false)


;; ===========================================
;; 导弹击中 UFO 检测函数
;; ===========================================

;; 判断导弹是否击中了 UFO ?
;; - 导弹中心点与 UFO 中心点的距离，小于 1/2 UFO 宽度
;; SIGS -> Boolean
(define (missile-hit-ufo? state)
  (and
   (missile? (sigs-missile state))
   (<= (hit-distance state) HALF-UFO-WIDTH)))

; 注
; ufo-x 或 missile-x ，这里的 x 值，就是图片中心 x 值，place-image or place-images 的机制决定的
; 这里已体现出来：
; 把太空游戏划分为两种数据类型，有点麻烦，因为需要不停判断是处在那种状态下。

; 测试 MISSILE 是否击中 UFO - 击中
(check-expect
 (missile-hit-ufo?
  (make-sigs
   (make-missile 30 160)
   (make-ufo 30 159)
   (make-tank 20 196)))
 #true)

; 测试 MISSILE 是否击中 UFO - 未击中
(check-expect
 (missile-hit-ufo?
  (make-sigs
   (make-missile 100 80)
   (make-ufo 30 159)
   (make-tank 20 196)))
 #false)


;; ===========================================
;; 导弹击中 UFO 距离函数
;; ===========================================

;; 计算导弹与 UFO 中心点之间的距离
;; SIGS -> Number
(define (hit-distance state)
  (sqrt (+ (sqr (- (ufo-x (sigs-ufo state)) (missile-x (sigs-missile state))))
           (sqr (- (ufo-y (sigs-ufo state)) (missile-y (sigs-missile state)))))))

; 测试 hit-distance 函数
(check-expect 
 (hit-distance (make-sigs (make-missile 30 160) (make-ufo 30 159) (make-tank 100 5)))
 1)

(check-expect 
 (hit-distance (make-sigs (make-missile 0 0) (make-ufo 3 4) (make-tank 100 5)))
 5)


;; ===========================================
;; 游戏结束画面渲染
;; ===========================================

;; 游戏停止后，最后一帧图像(3种情况)
;; SIGS -> Image
(define (end-scene state)
  (cond
    ; 第1、导弹击中 UFO，显示TANK、提示
    [(and (missile? (sigs-missile state)) (missile-hit-ufo? state)) (after-hit-render state)]

    ; 第2、UFO 触地，显示提示、UFO、坦克
    [(ufo-landed? state) (after-landed-render state)]

    ; 第3、其它情况，默认显示通用结束画面
    ; 此情况理论上不应发生，为稳健起见，显示一个通用结束画面。
    [else GLOBAL-IMG]))

; 以下是渲染函数专用辅助函数

;; 导弹击中 UFO ，显示TANK，提示
;; SIGS -> Image
(define (after-hit-render state)
  (place-images
   (list END-MSG TANK-IMG)
   (list (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2))
         (make-posn (tank-x (sigs-tank state)) TANK-HEIGHT))
   SCENE))

;; 第2、UFO 触地，显示提示、UFO、坦克
;; SIGS -> Image
(define (after-landed-render state)
  (place-images
   (list END-MSG UFO-IMG TANK-IMG)
   (list (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2))
         (make-posn (ufo-x (sigs-ufo state)) (ufo-y (sigs-ufo state)))
         (make-posn (tank-x (sigs-tank state)) TANK-HEIGHT))
   SCENE))


;;; ===========================================
;;; 程序启动
;;; ===========================================

(si-game (make-sigs #false (make-ufo 120 2) (make-tank 100 3)))

