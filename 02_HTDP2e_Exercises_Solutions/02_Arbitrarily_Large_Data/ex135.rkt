#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex135

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


;; === 数据定义 ===
; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name


;; === 函数定义 ===
; List-of-names -> Boolean
; determines whether "Flatt" occurs on alon
(define (contains-flatt? alon)
  (cond
    [(empty? alon) #false]
    [(cons? alon)
     (or (string=? (first alon) "Flatt")
         (contains-flatt? (rest alon)))]))

;; --- tests ---
(check-expect
  (contains-flatt? (cons "X" (cons "Y"  (cons "Z" '()))))
  #false)
(check-expect
  (contains-flatt? (cons "A" (cons "Flatt" (cons "C" '()))))
  #true)

;; --- tests Done ---


;; === 程序启动 ===
(contains-flatt?
  (cons "Flatt" (cons "C" '())))  ; #true

(contains-flatt?
  (cons "A" (cons "Flatt" (cons "C" '()))))   ; #true

(contains-flatt?
  (cons "B" (cons "Flatt" (cons "C" '()))))   ; #true
