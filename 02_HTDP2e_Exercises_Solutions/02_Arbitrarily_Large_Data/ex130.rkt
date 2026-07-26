#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex130

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


(cons "1" (cons "2" '()))  ; first 和 rest 完全符合数据定义
(cons 2 '())  ; first 是 2，数值，不是 string ，所以不是  List-of-names 的元素。


