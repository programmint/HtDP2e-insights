#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

;;; ex136

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。

;; 注，该题部分环节，由 Ai 直接修正 bug，这个题目其实可以放弃，所以因引入了Ai 修改 bug


;; === 1. 数据定义 ===

(define-struct pair [left right])
;; 一个 ConsPair 是结构体：
;;   (make-pair Any Any)
;; 解释：保存头元素和剩余列表的二元组

;; 一个 ConsOrEmpty 是以下两者之一：
;; -- '()
;; -- (make-pair Any ConsOrEmpty)
;; 解释：用自制 pair 构成的链表结构


;; === 2. 函数定义 ===

;; Any Any -> ConsPair
;; 构造函数：校验第二个参数是否合法，并生成自制节点
(define (our-cons a-value a-list)
  (cond
    [(empty? a-list) (make-pair a-value a-list)]
    [(pair? a-list)  (make-pair a-value a-list)]
    [else (error "our-cons: second argument must be a list or '()")]))

;; ConsPair -> Any
;; 选择器：提取链表的第一个元素（相当于 first）
(define (our-first a-pair)
  (pair-left a-pair))

;; ConsPair -> ConsOrEmpty
;; 选择器：提取链表剩下的部分（相当于 rest）
(define (our-rest a-pair)
  (pair-right a-pair))


;; === 3. 自动化测试 (Tests) ===

(check-expect (our-first (our-cons "a" '())) "a")
(check-expect (our-rest (our-cons "a" '())) '())


;; === 4. 程序启动 / 手动验证 ===

(our-first (our-cons "a" '())) ; 展开为 (pair-left (make-pair "a" '())) -> "a"
(our-rest (our-cons "a" '()))  ; 展开为 (pair-right (make-pair "a" '())) -> '()