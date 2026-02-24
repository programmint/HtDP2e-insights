;;; ex106

;; 全局目的： 
;; 主要功能：





;;; ==========================================
;;; VCAT 数据定义
;;; ==========================================

;; VCAT 是结构体，表示猫的 2 个状态
(define-struct vcat [x happiness])
;; 一个 VCAT 是 (make-vcat number number）
;; 解释
;; - x: 猫在背景内的 x 坐标
;; - happiness: 猫的快乐指数 [0-100]

; 测试 VCAT 
(check-expect (vcat-x (make-vcat 0 100)) 0)
(check-expect (vcat-happiness (make-vcat 50 80 )) 80)



;;; ==========================================
;;; VCHAM 数据定义
;;; ==========================================

;; VCHAM 是结构体，表示变色龙的 3 个状态
(define-struct vcham [x happiness color])
;; 一个 VCHAM 是 (make-vcham number number string)
;; 解释
;; - x：变色龙在画布中的 x 坐标
;; - happiness：变色龙的快乐值的具体数据 [0,CANVAS-HEIGHT]
;; - color：变色龙的具体色彩，分为："red","green","blue"

; 测试 VCHAM 结构体
(check-expect (make-vcham 10 100 "red") (make-vcham 10 100 "red"))
(check-expect (make-vcham 0 0 "blue") (make-vcham 0 0 "blue"))
(check-expect (vcham-x (make-vcham 10 100 "red")) 10)
(check-expect (vcham-happiness (make-vcham 10 100 "red")) 100)
(check-expect (vcham-color (make-vcham 10 100 "red")) "red")

