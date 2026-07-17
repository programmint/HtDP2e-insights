#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex111
;; 设计 checked-make-vec 确保输入值都是正数，错误则返回对应提示

;; === Vec 数据定义 ===
(define-struct vec [x y])
; A vec is (make-vec PositiveNumber PositiveNumber)
; interpretation represents a velocity vector


;; === 主程序 ===
;; Any Any -> Vec 
;; 检查 x 与 y 是 函数 make-vec 的有效输入（均是正数）
(define (checked-make-vec x y)
  (cond
    [(and
      (and (number? x) (positive? x))
      (and (number? y) (positive? y)))
    (make-vec x y)]
    [else (error "x 和 y 都必须是正数")]))

;; --- tests checked-make-vec ---

;; 正确输入值
(check-expect (checked-make-vec 2 6) (make-vec 2 6))

;; 错误输入值
(check-error (checked-make-vec"hello" "htdp2e") "x 和 y 都必须是正数")
(check-error (checked-make-vec"hello" 2) "x 和 y 都必须是正数")
(check-error (checked-make-vec 1 "htdp2e") "x 和 y 都必须是正数")
(check-error (checked-make-vec 0 2) "x 和 y 都必须是正数")

;; --- tests Done - checked-make-vec ---

;; === 程序启动 ===
(checked-make-vec 2 9)