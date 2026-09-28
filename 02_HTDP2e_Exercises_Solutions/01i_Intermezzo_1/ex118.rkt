#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex118

(define (f x) x)
;; （ ）括号的运用，代表了是复合表达式
;; define 是内置关键字，表示要定义一个函数
;; （f x）就是被定义函数的名字和参数列表，f 是函数名，x 是参数
;; x 是合理的函数体

;; 所以，合理的函数定义语句。


(define (f x) y)
;; 合理的函数定义语句
;; 理由同上


(define (f x y) 3)
;; 也是合理的函数定义语句
;; 区别在于，定义的函数，其函数体是一常量 3