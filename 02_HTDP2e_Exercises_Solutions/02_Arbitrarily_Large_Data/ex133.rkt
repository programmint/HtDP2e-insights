#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex133

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


;; ===  第 1 版本函数（教科书的版本） ===

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


;; === 第 2 版本函数 ===

; List-of-names -> Boolean
; determines whether "Flatt" occurs on alon
(define (contains-flatt? alon)
  (cond
    [(empty? alon) #false]                    ; 第1层：先防守，拦截空链表
    [(cons? alon)                             ; 第2层：检验输入是否有效？
     (cond                                    ; <-- 133 题替换，从这里开始！
       [(string=? (first alon) "Flatt") #true]
       [else (contains-flatt? (rest alon))])]))

;; 对应测试案例，略


;; 结论
;; 1、二者功效一致
;; 2、第1版本函数：只有一个 cond ，使用了 or，语句上更加精炼，稍稍有点难读。
;; 3、第2版本函数：更加符合思考习惯，很符合直觉，但糟糕在，cond 里面居然又夹杂了一个 cond，我个人非常不喜欢这种写法，代码会越来越复杂。

;; 所以，我个人会倾向于第 1 版本函数。