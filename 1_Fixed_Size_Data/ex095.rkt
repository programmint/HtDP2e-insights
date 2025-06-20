; ex095

; =============
; 全局目的
; =============
; 解释结构体数据定义


; ==========================================
; 缩写说明
; - IMG / img : image（图片）
; ==========================================

; =============
; 常量定义
; =============

; 太空游戏背景
(define SCENE-WIDTH 200)
(define SCENE-HEIGHT 200)
(define SCENE (empty-scene SCENE-WIDTH SCENE-WIDTH))

; UFO 图像
(define UFO-IMG (overlay (rectangle 22 4 "solid" "gray")
                         (circle 6 "solid" "gray")))

; 坦克图像
(define TANK-IMG (rectangle 30 8 "solid" "black"))

; 火箭图像
(define MISSILE-IMG (triangle 8 "solid" "black"))

; UFO下降速度
(define UFO-SPEED 5)

; 坦克移动速度
(define TANK-SPEED 7)

; 火箭上升速度
(define MISSILE-SPEED (* 2.5 UFO-SPEED))

; =============
; 结构体
; =============

; -------------
; 基础结构体
; -------------

; ~~~~~~~~~~~~~~
; UFO 结构体
; ~~~~~~~~~~~~~~

; 测试 UFO 结构体
(check-expect (ufo-x (make-ufo 50 20)) 50)
(check-expect (ufo-y (make-ufo 50 20)) 20)

; UFO 是结构体，表示 UFO 在背景中的位置
(define-struct ufo [x y])
; 一个 UFO 是（make-ufo number number)
; 解释：
; - x 是 UFO 从左到右的位置
; - y 是 UFO 从上到下的位置


; ~~~~~~~~~~~~~~
; TANK 结构体
; ~~~~~~~~~~~~~~

; 测试 TANK 结构体
(check-expect (tank-x (make-tank 50 HEIGHT 30)) 50)
(check-expect (tank-y (make-tank 50 HEIGHT 30)) HEIGHT)
(check-expect (tank-vel (make-tank 50 HEIGHT 30)) 30)

; TANK 是结构体，表示坦克在背景中的位置，及运动速度
(define-struct tank[x y vel])
; 一个 TANK 是 (make-tank number number number)
; 解释：
; - x 是 TANK 从左到右的位置
; - y 是 TANK 从上到下的位置(固定为 HEIGHT )
; - vel 是TANK 的水平速度（正值向右，负值向左）

; 注
; 这里没有采用教材中的结构体定义法，而是补充了速度作为结构体的一部分

; ~~~~~~~~~~~~~~
; MISSILE 结构体
; ~~~~~~~~~~~~~~

; 测试 MISSILE 结构体
(check-expect (missile-x (make-missile 50 30 -60)) 50)
(check-expect (missile-y (make-missile 50 30 -60)) 30)
(check-expect (missile-vel (make-missile 50 30 -60)) -60)

; MISSILE 是结构体，表示导弹在背景中的位置
(define-struct missile [x y vel])
; 一个 MISSILE 是（make-missile number number number)
; 解释：
; - x 是 MISSILE 从左到右的位置
; - y 是 MISSILE 从上到下的位置
; - vel 是 MISSILE 的速度（是负值，因为向上移动）

; 注
; 这里没有采用教材中的结构体定义法，而是补充了速度作为结构体的一部分

; ----------
; 复合结构体
; ----------
; SIGS 是下列之一
(make-aim UFO Tank)
(make-fired UFO TANK MISSILE)
; 解释：表示空间入侵者游戏的完整状态
; 其中：
; - 第一种表示还没有发射导弹的状态
; - 第二种表示已发射导弹的状态


; =============
; 95 题解释
; =============

(make-aim (make-posn 20 10) (make-tank 28 -3))
; 这里的数据，很明显就是采用了第一个字句的数据定义

(make-fired (make-posn 20 10)
            (make-tank 28 -3)
            (make-posn 28 (- HEIGHT TANK-HEIGHT)))
; 这里的数据，很明显就是采用了第二个字句的数据定义

(make-fired (make-posn 20 100)
            (make-tank 100 3)
            (make-posn 22 103))
; 这里的数据，很明显就是采用了第二个字句的数据定义

