;;; ex104

;; 全局目的：为处理车辆函数，开发模板 


;; 注：该题对于函数、数据定义等，命名的大小写规范，详见《HTDP2e 命名规范总结（第1-6章）》
;; https://github.com/programmint/HtDP2e-insights/blob/main/Study%20Notes/%E7%AC%AC%206%20%E7%AB%A0%20-%20%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/6.7%E3%80%81HTDP2e%20%E5%91%BD%E5%90%8D%E8%A7%84%E8%8C%83%E6%80%BB%E7%BB%93%EF%BC%88%E7%AC%AC1-6%E7%AB%A0%EF%BC%89.md



;;; ==========================================
;;; 说明
;;; ==========================================
;; 这题目很简单，但翻译有问题
;; 正确的翻译：为处理车辆，设计一个函数模板。
;; 详见：https://github.com/programmint/HtDP2e-insights/blob/main/Translation%20Proofreading%20Notes/%E7%AC%AC%206%20%E7%AB%A0-%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95/6.5%20-%20P119%20-%20%E8%AF%BB%E5%85%A5%E4%B8%80%E8%AF%8D%EF%BC%8C%E7%BF%BB%E8%AF%91%E9%94%99%E8%AF%AF.md


;;; ==========================================
;;; 术语
;;; ==========================================
;; - mpg : miles per gallon


;;; ==========================================
;;; AUTO 数据定义
;;; ==========================================

;; AUTO 是结构体，表示可以运送的乘客数量，车牌号码，燃油消耗
(define-struct auto [passengers license-plate mpg])
;; 一个 AUTO（make-auto Number String Number）
;; 解释
;; - passengers：代表可运送乘客数量
;; - license-plate：代表车牌号码
;; - mpg：miles per gallon，代表燃油消耗，每加仑公里数


;;; ==========================================
;;; VAN 数据定义
;;; ==========================================

;; VAN 是结构体，表示可以运送的乘客数量，车牌号码，燃油消耗
(define-struct van [passengers license-plate mpg])
;; 一个 VAN（make-van Number String Number）
;; 解释
;; - passengers：代表可运送乘客数量
;; - license-plate：代表车牌号码
;; - mpg：miles per gallon，代表燃油消耗，每加仑公里数


;;; ==========================================
;;; BUS 数据定义
;;; ==========================================

;; BUS 是结构体，表示可以运送的乘客数量，车牌号码，燃油消耗
(define-struct bus [passengers license-plate mpg])
;; 一个 BUS （make-bus Number String Number）
;; 解释
;; - passengers：代表可运送乘客数量
;; - license-plate：代表车牌号码
;; - mpg：miles per gallon，代表燃油消耗，每加仑公里数


;;; ==========================================
;;; SUV 数据定义
;;; ==========================================

;; SUV 是结构体，表示可以运送的乘客数量，车牌号码，燃油消耗
(define-struct suv [passengers license-plate mpg])
;; 一个 SUV（make-suv Number String Number）
;; 解释
;; - passengers：代表可运送乘客数量
;; - license-plate：代表车牌号码
;; - mpg：miles per gallon，代表燃油消耗，每加仑英里数


;;; ==========================================
;;; vehicle 数据定义
;;; ==========================================

;; vehicle 是下列数据之一
;; - auto
;; - van
;; - bus
;; - suv
;; 解释，代表了一系列车队中的一俩车


;;; ==========================================
;;; 处理车辆函数模板
;;; ==========================================

;; 设计处理车辆数据的模板
;; vehicle -> ??
(define (vehicle-fn a-vehicle)
  (cond
    [(auto? a-vehicle) (...)]
    [(van? a-vehicle) (...)]
    [(bus? a-vehicle) (...)]
    [(suv? a-vehicle) (...)]))