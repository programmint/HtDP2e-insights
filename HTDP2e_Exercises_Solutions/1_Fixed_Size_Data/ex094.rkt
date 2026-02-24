; ex094

; =============
; 全局目的
; =============
; 为太空游戏，建立常量和变量。

; =====
; 注意
; =====
; 题目是建议你使用图像来辅助思考，确实是一个好的辅助手段。
; 另，94 题 - 100 题是一整体，勿着急解题，一直看到 100 题，再返回来解题。


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
