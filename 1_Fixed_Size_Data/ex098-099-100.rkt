;;; ex098-099-100

;; 全局目的：完成太空游戏 

;; 主要功能：
;; - 实时渲染游戏图像
;; - TANK 发射 MISSILE ，打击 UFO
;; - UFO 触地或击中 UFO，游戏结束，并渲染游戏结束画面


;;; ==========================================
;;; 说明
;;; ==========================================
;; htdp2e 中，98、99、100 题都是独立的题目，起初我也是独立去解题。
;; 解题时发现，分开解题只考虑当前模块，而不管全局，不好。
;; 所以合在一起，利于整体思考。

;; TODO
;; tank-move-left 和 tank-move-right 有很多重复代码
;; 待到抽象那一章，再回来修正（其实是现在没有思路）

;; 陷阱
;; 这里暗含了一个问题，即：火箭只能发射一次吗？
;; 详细论述:
;; https://github.com/programmint/HtDP2e-insights/blob/main/Translation%20Proofreading%20Notes/%E7%AC%AC%206%20%E7%AB%A0-%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95/6.2%20-%20P111%20-%20%E7%81%AB%E7%AE%AD%E5%8F%AA%E5%8F%91%E5%B0%84%E4%B8%80%E6%AC%A1%EF%BC%9F.md


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
(define JUMP-OFFSET 10 )

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

;; 修改结构体定义
;; TANK 是结构体，表示坦克在背景中的位置
(define-struct tank [x vel])
;; 一个 TANK 是 (make-tank number number)
;; 解释:
;; - x 是 TANK 从左到右的位置（高度固定为 TANK-HEIGHT)
;; - vel 是 TANK 的运动速度，+ 表示向右，- 表示向左

;; 测试 TANK 结构体
(check-expect (tank-x (make-tank 50 20)) 50)
(check-expect (tank-vel (make-tank 50 20)) 20)


;;; ==========================================
;;; MISSILE 数据定义
;;; ==========================================

;; MISSILE 是结构体，表示导弹在背景中的位置
(define-struct missile [x y])
;; 一个 MISSILE 是(make-missile number number)
;; 解释:
;; - x 是 MISSILE 从左到右的位置
;; - y 是 MISSILE 从上到下的位置

;; 测试 MISSILE 结构体
(check-expect (missile-x (make-missile 50 60)) 50)
(check-expect (missile-y (make-missile 50 60)) 60)


;;; ==========================================
;;; 游戏数据定义
;;; ==========================================

;; SIGS 是下列之一
;; - (make-aim UFO Tank)
;; - (make-fired MISSILE UFO TANK)
(define-struct aim [ufo tank])
(define-struct fired [missile ufo tank])
;; 解释:表示空间入侵者游戏的完整状态
;; 其中:
;; - 第一种表示还没有发射导弹的状态
;; - 第二种表示已发射导弹的状态


;;; ==========================================
;;; 游戏主程序
;;; ==========================================

;; SIGS -> SIGS
;; 太空入侵者游戏主函数
(define (si-game state)
  (big-bang state
    [on-tick si-move]                        ; 第 99 题
    [on-key si-control]                      ; 第 100 题
    [to-draw si-render]                      ; 第 99 题
    [stop-when si-game-over? end-scene]))    ; 第 98 题


;;; ===========================================
;;; 位置接口函数
;;; ===========================================

;; 时钟滴答一次，更新一次状态
;; SIGS -> SIGS
(define (si-move state)
  (si-move-proper state (- (random JUMP-RANGE) JUMP-OFFSET)))

;; 注
;; 该函数无法测试


;; ===========================================
;; 新位置接口函数
;; ===========================================
;; SIGS Number -> SIGS
(define (si-move-proper state delta)
  (cond
    [(aim? state) (aim-next-posn state delta)]
    [(fired? state) (fired-next-posn state delta)]))

;; 测试 si-move-proper 函数
(check-expect 
  (si-move-proper (make-aim (make-ufo 50 50) (make-tank 100 5)) 10)
  (make-aim (make-ufo 60 53) (make-tank 105 5)))

(check-expect 
  (si-move-proper (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)) 10)
  (make-fired (make-missile 100 192.5) (make-ufo 60 53) (make-tank 105 5)))

;; ===========================================
;; 两种状态下，计算新位置函数
;; ===========================================

;; 瞄准状态下，实时更新 SIGS 的位置
;; SIGS -> SIGS
(define (aim-next-posn state delta) 
  (make-aim
   (aim-ufo-next-posn state delta)
   (aim-tank-next-posn state)))

;; 发射火箭状态下，实时更新 SIGS 的位置
;; SIGS -> SIGS
(define (fired-next-posn state delta)
  (make-fired
   (fired-missile-next-posn state)
   (fired-ufo-next-posn state delta)
   (fired-tank-next-posn state)))

;; 测试 aim-next-posn 函数
(check-expect 
  (aim-next-posn (make-aim (make-ufo 50 50) (make-tank 100 5)) 10)
  (make-aim (make-ufo 60 53) (make-tank 105 5)))

;; 测试 fired-next-posn 函数
(check-expect 
  (fired-next-posn (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)) 10)
  (make-fired (make-missile 100 192.5) (make-ufo 60 53) (make-tank 105 5)))

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

;; 测试坦克边界处理
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

;; 测试 UFO 边界处理
(check-expect (ufo-x-in-boundary 5) 150)
(check-expect (ufo-x-in-boundary 295) 150)
(check-expect (ufo-x-in-boundary 100) 100)


;; ===========================================
;; 瞄准状态，计算 UFO、TANK 位置函数
;; ===========================================

;; 瞄准状态下，计算 UFO 的位置
;; SIGS -> UFO
(define (aim-ufo-next-posn state delta)
  (make-ufo
    (ufo-x-in-boundary (+ (ufo-x (aim-ufo state)) delta))
    (+ (ufo-y (aim-ufo state)) UFO-SPEED)))

;; 瞄准状态下，计算 TANK 新位置
;; SIGS -> TANK
(define (aim-tank-next-posn state)
  (make-tank
    (tank-x-in-boundary (+ (tank-x (aim-tank state)) (tank-vel (aim-tank state))))
   (tank-vel (aim-tank state))))

;; 测试 aim-tank-next-posn 函数
(check-expect 
  (aim-tank-next-posn (make-aim (make-ufo 50 50) (make-tank 100 5)))
  (make-tank 105 5))

;; 测试坦克边界循环
(check-expect 
  (aim-tank-next-posn (make-aim (make-ufo 50 50) (make-tank 310 5)))
  (make-tank 315 5))


;; ===========================================
;; 发射火箭状态，计算 MISSILE 、UFO、TANK 新位置
;; ===========================================

;; 发射火箭状态，计算 MISSILE 新位置
;; SIGS -> MISSILE
(define (fired-missile-next-posn state)
  (make-missile
   (missile-x (fired-missile state))
   (- (missile-y (fired-missile state))
      MISSILE-SPEED)))

;; 发射火箭状态，计算 UFO 新位置
;; SIGS -> UFO
(define (fired-ufo-next-posn state delta)
  (make-ufo
    (ufo-x-in-boundary (+ (ufo-x (fired-ufo state)) delta))
    (+ (ufo-y (fired-ufo state)) UFO-SPEED)))

;; 发射火箭状态，计算 TANK 新位置
;; SIGS -> TANK
(define (fired-tank-next-posn state)
  (make-tank
    (tank-x-in-boundary (+ (tank-x (fired-tank state)) (tank-vel (fired-tank state))))
    (tank-vel (fired-tank state))))

;; 测试 fired-missile-next-posn 函数
(check-expect 
  (fired-missile-next-posn (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-missile 100 192.5))

;; 测试 fired-ufo-next-posn 函数
(check-expect 
  (fired-ufo-next-posn (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)) 10)
  (make-ufo 60 53))

;; 测试 fired-tank-next-posn 函数
(check-expect 
  (fired-tank-next-posn (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-tank 105 5))


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
    [(and (aim? state) (key=? key " ")) (aim-to-fired state)]
    [else state]))

;; 测试 si-control 函数
(check-expect 
  (si-control (make-aim (make-ufo 50 50) (make-tank 100 5)) "left")
  (make-aim (make-ufo 50 50) (make-tank 100 -5)))

(check-expect 
  (si-control (make-aim (make-ufo 50 50) (make-tank 100 -5)) "right")
  (make-aim (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
  (si-control (make-aim (make-ufo 50 50) (make-tank 100 5)) " ")
  (make-fired (make-missile 100 292.5) (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
  (si-control (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)) " ")
  (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
  (si-control (make-aim (make-ufo 50 50) (make-tank 100 5)) "a")
  (make-aim (make-ufo 50 50) (make-tank 100 5)))


;; ===========================================
;; 坦克左移函数
;; ===========================================

;; 按左键，坦克向左移动
;; SIGS -> SIGS
(define (tank-move-left state)
  (cond
    [(aim? state) (make-aim
                   (aim-ufo state)
                   (make-tank (tank-x (aim-tank state))
                              (- (abs (tank-vel (aim-tank state))))))]

    [(fired? state) (make-fired
                     (fired-missile state)
                     (fired-ufo state)
                     (make-tank (tank-x (fired-tank state))
                                (- (abs (tank-vel (fired-tank state))))))]))

;; 测试 tank-move-left 函数
(check-expect 
  (tank-move-left (make-aim (make-ufo 50 50) (make-tank 100 5)))
  (make-aim (make-ufo 50 50) (make-tank 100 -5)))

(check-expect 
  (tank-move-left (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 -5)))


;; ===========================================
;; 坦克右移函数
;; ===========================================

;; 按右键，坦克向右移动
;; SIGS -> SIGS
(define (tank-move-right state)
  (cond
    [(aim? state) (make-aim
                   (aim-ufo state)
                   (make-tank (tank-x (aim-tank state))
                              (abs (tank-vel (aim-tank state)))))]

    [(fired? state) (make-fired
                     (fired-missile state)
                     (fired-ufo state)
                     (make-tank (tank-x (fired-tank state))
                                (abs (tank-vel (fired-tank state)))))]))

;; 测试 tank-move-right 函数
(check-expect 
  (tank-move-right (make-aim (make-ufo 50 50) (make-tank 100 -5)))
  (make-aim (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
  (tank-move-right (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 -5)))
  (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))



;; ===========================================
;; 发射火箭函数
;; ===========================================

;; 按下空格，发射火箭
;; SIGS -> UFO 
(define (aim-to-fired state)
  (cond
    [(aim? state) (make-fired
                   (make-missile
                    (tank-x (aim-tank state))
                    (- TANK-HEIGHT HALF-MISSILE-HEIGHT))
                   (aim-ufo state)
                   (aim-tank state))]
    [else state]))

;; 测试 aim-to-fired 函数
(check-expect 
  (aim-to-fired (make-aim (make-ufo 50 50) (make-tank 100 5)))
  (make-fired (make-missile 100 292.5) (make-ufo 50 50) (make-tank 100 5)))

(check-expect 
  (aim-to-fired (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))


;;; ===========================================
;;; 渲染游戏图像函数
;;; ===========================================

;; 依据不同状态，实时渲染图像
;; SIGS -> Image
(define (si-render state)
  (cond
    [(aim? state) (aim-render state)]
    [(fired? state) (fired-render state)]))


;; ===========================================
;; 瞄准状态，实时渲染图像
;; ===========================================
;; SIGS -> Image
(define (aim-render state)
  (place-images
   (list UFO-IMG TANK-IMG)
   (list (make-posn 
          (ufo-x (aim-ufo state))
          (ufo-y (aim-ufo state)))
         (make-posn
          (tank-x (aim-tank state))
          TANK-HEIGHT))
   SCENE))


;; ===========================================
;; 发射火箭状态，实时渲染图像
;; ===========================================
;; SIGS -> Image
(define (fired-render state)
  (place-images
   (list MISSILE-IMG UFO-IMG TANK-IMG)
   (list (make-posn 
          (missile-x (fired-missile state))
          (missile-y (fired-missile state)))
         (make-posn 
          (ufo-x (fired-ufo state))
          (ufo-y (fired-ufo state)))
         (make-posn
          (tank-x (fired-tank state))
          TANK-HEIGHT))
   SCENE))


;;; ===========================================
;;; 游戏停止逻辑函数
;;; ===========================================

;; 判断游戏是否停止?
;; - UFO 触地，游戏立即结束(全局条件)
;; - 发射状态，导弹击中 UFO 时游戏结束
;; SIGS -> Boolean
(define (si-game-over? state)
  (cond
    [(ufo-landed? state) #true] ;结构体定义，无论怎么样都有 UFO
    [(and (fired? state) (missile-hit-ufo? state)) #true]
    [else #false]))

;; 测试 si-game-over? 函数
(check-expect 
  (si-game-over? (make-aim (make-ufo 50 50) (make-tank 100 5)))
  #false)

(check-expect 
  (si-game-over? (make-aim (make-ufo 50 297) (make-tank 100 5)))
  #true)

(check-expect 
  (si-game-over? (make-fired (make-missile 30 160) (make-ufo 30 159) (make-tank 100 5)))
  #true)


;; ===========================================
;; UFO 着陆检测函数
;; ===========================================

;; UFO 着陆检测?
;; SIGS -> Boolean
(define (ufo-landed? state)
  (>= (ufo-y (current-ufo state))
      UFO-LANDED-DISTANCE))

;; 测试 UFO 是否触地 - aim 状态
(check-expect
 (ufo-landed?
  (make-aim
   (make-ufo 30 297) (make-tank 50 196)))
 #true)

;; 测试 UFO 是否触地 - fired 状态
(check-expect
 (ufo-landed?
  (make-fired
   (make-missile 50 30) (make-ufo 30 297) (make-tank 50 196)))
 #true)

;; 测试 UFO 未触地情况
(check-expect
 (ufo-landed?
  (make-aim
   (make-ufo 30 100) (make-tank 50 5)))
 #false)


;; ===========================================
;; 导弹击中 UFO 检测函数
;; ===========================================

;; 判断导弹是否击中了 UFO ?
;; - 导弹中心点与 UFO 中心点的距离，小于 1/2 UFO 宽度
;; SIGS -> Boolean
(define (missile-hit-ufo? state)
  (and
   (fired? state)
   (<= (hit-distance state) HALF-UFO-WIDTH)))

;; 注
;; ufo-x 或 missile-x ，这里的 x 值，就是图片中心 x 值，place-image or place-images 的机制决定的
;; 这里已体现出来：
;; 把太空游戏划分为两种数据类型，有点麻烦，因为需要不停判断是处在那种状态下。

;; 测试 MISSILE 是否击中 UFO - 击中
(check-expect
 (missile-hit-ufo?
  (make-fired
   (make-missile 30 160)
   (make-ufo 30 159)
   (make-tank 20 196)))
 #true)

;; 测试 MISSILE 是否击中 UFO - 未击中
(check-expect
 (missile-hit-ufo?
  (make-fired
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
  (sqrt (+ (sqr (- (ufo-x (fired-ufo state)) (missile-x (fired-missile state))))
           (sqr (- (ufo-y (fired-ufo state)) (missile-y (fired-missile state)))))))

;; 测试 hit-distance 函数
(check-expect 
  (hit-distance (make-fired (make-missile 30 160) (make-ufo 30 159) (make-tank 100 5)))
  1)

(check-expect 
  (hit-distance (make-fired (make-missile 0 0) (make-ufo 3 4) (make-tank 100 5)))
  5)


;; ===========================================
;; 游戏状态访问函数
;; ===========================================

;; 获取当前 UFO 状态
;; 注：此函数也被 end-scene 调用
;; SIGS -> UFO
(define (current-ufo state)
  (cond
    [(aim? state) (aim-ufo state)]
    [(fired? state) (fired-ufo state)]))

;; 获取当前 TANK 状态
;; 注：此函数也被 end-scene 调用
;; SIGS -> TANK
(define (current-tank state)
  (cond
    [(aim? state) (aim-tank state)]
    [(fired? state) (fired-tank state)]))

;; 获取当前 MISSILE 状态
;; SIGS -> MISSILE
(define (current-missile state)
  (cond
    [(fired? state) (fired-missile state)]))

;; 测试 current-ufo 函数
(check-expect 
  (current-ufo (make-aim (make-ufo 50 50) (make-tank 100 5)))
  (make-ufo 50 50))

(check-expect 
  (current-ufo (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-ufo 50 50))

;; 测试 current-tank 函数
(check-expect 
  (current-tank (make-aim (make-ufo 50 50) (make-tank 100 5)))
  (make-tank 100 5))

(check-expect 
  (current-tank (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-tank 100 5))

;; 测试 current-missile 函数
(check-expect 
  (current-missile (make-fired (make-missile 100 200) (make-ufo 50 50) (make-tank 100 5)))
  (make-missile 100 200))


;; ===========================================
;; 游戏结束画面渲染
;; ===========================================

;; 游戏停止后，最后一帧图像(3种情况)
;; SIGS -> Image
(define (end-scene state)
  (cond
    ; 第1、发射导弹状态，导弹击中 UFO，显示坦克和提示
    [(missile-hit-ufo? state) (after-hit-render state)]

    ; 第2、无论瞄准 or 发射状态，UFO降落到地面，显示提示、UFO、坦克
    [(ufo-landed? state) (after-landed-render state)]

    ; 第3、其它情况，默认显示通用结束画面
    ; 此情况理论上不应发生，为稳健起见，显示一个通用结束画面。
    [else GLOBAL-IMG]))

;; 以下是渲染函数专用辅助函数

;; 导弹击中 UFO 之后的图像
;; SIGS -> Image
(define (after-hit-render state)
  (place-images
   (list END-MSG TANK-IMG)
   (list (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2))
         (make-posn (tank-x (current-tank state)) TANK-HEIGHT))
   SCENE))

;; 瞄准或发射状态，UFO 触地之后的图像
;; SIGS -> Image
(define (after-landed-render state)
  (place-images
   (list END-MSG UFO-IMG TANK-IMG)
   (list (make-posn (/ SCENE-WIDTH 2) (/ SCENE-HEIGHT 2))
         (make-posn (ufo-x (current-ufo state)) (ufo-y (current-ufo state)))
         (make-posn (tank-x (current-tank state)) TANK-HEIGHT))
   SCENE))



;;; ===========================================
;;; 程序启动
;;; ===========================================

(si-game (make-aim (make-ufo 120 2) (make-tank 100 3)))