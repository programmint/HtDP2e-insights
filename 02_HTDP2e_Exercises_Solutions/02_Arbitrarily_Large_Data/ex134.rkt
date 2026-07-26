#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex134

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


;; === List-of-strings 数据定义 ===
;; A List-of-strings 是如下：
;; -- '()
;; -- (cons String List-of-strings)
;; 解释：List-of-strings 是输入字符串的链表


;; --- 常量 ---
(define LIST-EMPTY '())
(define LIST-THREE (cons "A" (cons "B" (cons "C" '()))))


;; === 比较函数 ===
;; String List-of-strings -> Boolean
;; 检验某个字符串，是不是在某个 List 中
(define (contains? a-string a-list)
  (cond
    [(empty? a-list) #false]
    [(cons? a-list) 
     (or (string=? a-string (first a-list))
         (contains? a-string (rest a-list)))]))


;; --- tests ---

;; 测试字符串位于 List 中
(check-expect (contains? "A" LIST-THREE) #true)

;; 测试字符串不在 List 中
(check-expect (contains? "A" LIST-EMPTY) #false)
(check-expect (contains? "X" LIST-THREE) #false)

;; --- tests Done ---


;; === 程序启动 ===
(contains? "A" LIST-EMPTY)  ; #false
(contains? "A" LIST-THREE)  ; #true