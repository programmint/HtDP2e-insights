#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex115

;; === 常量 ===

;; 各个错误提示
(define ERROR-MSG-1 "第一个输入值，不符合数据定义")
(define ERROR-MSG-2 "第二个输入值，不符合数据定义")
(define ERROR-MSG-3 "两个输入值，都不符合数据定义")


;; === TrafficLight 数据定义 ===

; A TrafficLight is one of the following Strings:
; – "red"
; – "green"
; – "yellow"
; interpretation the three strings represent the three 
; possible states that a traffic light may assume 

; 注，该定义位于P69，第4章 区间、枚举和条目 > 4.3 枚举


;; Any -> Boolean
;; is the given value an element of TrafficLight
(define (light? x)
  (cond
    [(string? x) (or (string=? "red" x)
                     (string=? "green" x)
                     (string=? "yellow" x))]
    [else #false]))



;; Any Any -> Boolean
;; 检测两个输入值是不是符合数据定义，两个输入值是不是一致？
(define (light=? a-value another-value)
  (cond

    ;; 相同 TrafficLight  
    [(and (light? a-value) (light? another-value))
     (string=? a-value another-value)]

    ;; 第 1 个输入值不是 TrafficLight  
    [(and (not (light? a-value)) (light? another-value))
     (error ERROR-MSG-1)]

    ;; 第 2 个输入值不是 TrafficLight  
    [(and (light? a-value) (not (light? another-value)))
     (error ERROR-MSG-2)]

    ;; 两个输入值都不是 TrafficLight  
    [else (error ERROR-MSG-3)]))

;; --- tests ---

;; 测试相同的 TrafficLight
(check-expect (light=? "red" "red") #true)
(check-expect (light=? "green" "green") #true)
(check-expect (light=? "yellow" "yellow") #true)


;; 测试不相同的 TrafficLight
(check-expect (light=? "red" "green") #false)
(check-expect (light=? "green" "red") #false)
(check-expect (light=? "yellow" "green") #false)

;; 测试第 1 个值不是 TrafficLight
(check-error (light=? 2 "green") ERROR-MSG-1)

;; 测试第 2 个值不是 TrafficLight
(check-error (light=? "red" #true) ERROR-MSG-2)

;; 测试两个值都不是 TrafficLight
(check-error (light=? 2 #true) ERROR-MSG-3)

;; --- tests - Done ---


;; === 程序启动 ===
(light=? "red" "red")
;; (light=? "green" "green")
;; (light=? "yellow" "yellow")
;; 
;; (light=? "red" "yellow")
;; (light=? "green" "red")
;; (light=? "yellow" "red")
;; 
;; (light=? "2" "red")
;; (light=? "green" "blue")
;; (light=? "sliver" "blue")