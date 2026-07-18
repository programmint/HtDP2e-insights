#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex112
;; 使用 or 来判断输入值是否有效？ 


;; === MissileOrNot 数据定义 ===

;; MissileOrNot 是下列之一：
;;  -- #false
;;  -- Posn
;; 解释：#false表示导弹还在坦克中，Posn 表示导弹所在的位置

;; 注：该定义位于 P117，6.1 再谈条目的设计 > 2. 设计诀窍



;; === 主程序 ===

;; Any ->  Boolean
(define (missile-or-not? v)
  (or (false? v)
      (posn? v)))


;; --- tests ---

;; 测试输入值为 #false
(check-expect (missile-or-not? #false) #true)

;; 测试输入值为 posn
(check-expect (missile-or-not? (make-posn 2 3)) #true)

;; 测试错误输入值
(check-expect (missile-or-not? "hello") #false)

;; --- tests - Done ---