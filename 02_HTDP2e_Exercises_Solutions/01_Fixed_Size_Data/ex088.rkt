; ex088

; ====================
; 全局目的
; ====================

; 建立 vcat 结构体，将猫的 x 坐标和快乐指数融合在一起。
; 注意，88题 - 91 题是一体化的题目，需要联合起来看。


; vcat 是结构体 
(define-struct vcat [x happiness])
; 一个 vcat 是 (make-vcat number number）
; 解释
; - x: 猫在背景内的 x 坐标
; - happiness: 猫的快乐指数 [0-100]
