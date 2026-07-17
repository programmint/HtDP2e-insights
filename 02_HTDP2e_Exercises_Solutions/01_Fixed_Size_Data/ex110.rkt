#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex110
;; 验证 checked-area-of-disk 的输入值是否为正数？


; Number -> Number
; computes the area of a disk with radius r
(define (area-of-disk r)
  (* 3.14 (* r r)))


; Any -> Number
; computes the area of a disk with radius v, 
; if v is a number and a positive number
(define (checked-area-of-disk v)
  (cond
    [(and (number? v) (positive? v)) (area-of-disk v)]
    [else (error "area-of-disk: positive number expected")]))

; 注
; (and (number? v) (positive? v)) 的次序，必须是先 (number? v)，然后才是 (positive? v) 

; 如果是 (and (positive? v) (number? v)) 会怎么样？
; 当输入是字符串时
; 第一步，先执行 (positive? v)，由于它只接受数字，这里会直接抛出错误提示
; 结果：程序当场死亡，and 机制跟着一起被炸毁，没有任何机会返回任何值。


;; --- tests ---

;; 正确测试案例
(check-expect (checked-area-of-disk 1) 3.14)
(check-expect (checked-area-of-disk 5) 78.5)

;; 错误测试案例
(check-error (checked-area-of-disk "my-disk") 
             "area-of-disk: positive number expected")
(check-error (checked-area-of-disk -1) 
             "area-of-disk: positive number expected")
(check-error (checked-area-of-disk 0) 
             "area-of-disk: positive number expected")

;; --- tests Done ---