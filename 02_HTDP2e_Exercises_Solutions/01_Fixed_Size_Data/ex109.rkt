#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex109
;; 设计一个简单的有限状态机

;; 题意解析
;; 这个题目，我没有读懂，靠 Ai 的引导，慢慢才理解题意。
;; 状态机的概念，确实有点难以理解。

;; --- 常量 ---

;; 图形
(define WHITE-RECTANGLE-IMG (square 100 "solid" "white"))
(define YELLOW-RECTANGLE-IMG (square 100 "solid" "yellow"))
(define GREEN-RECTANGLE-IMG (square 100 "solid" "green"))
(define RED-RECTANGLE-IMG (square 100 "solid" "red"))

;; 系统标识常量
(define AA "start, a")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")


;; === 数据定义 ===

;; ExpectsToSee 是下列之一，每一个都是系统的状态标识（正确按键之后，由下面的状态来标识）
;;  – AA：默认状态标识
;;  – BB：循环阶段标识
;;  – DD：完成阶段标识
;;  – ER：错误输入标识


;; === 主程序 ===

;; ExpectsToSee -> ExpectsToSe
(define (recognize-pattern state)
  (big-bang state
    [on-key handle-key]
    [on-draw render-rectangle]))


;; === 按键函数 ===
;; ExpectsToSee key -> ExpectsToSe
(define (handle-key state key)
  (cond
    ;; 处于 AA 状态
    [(string=? state AA)
     (cond
       [(key=? key "a") BB]  
       [else ER])]          

    ;; 处于 BB 状态
    [(string=? state BB)
     (cond
       [(or (key=? key "b") (key=? key "c")) BB] 
       [(key=? key "d") DD]                     
       [else ER])]                               

    ;; 处于 DD 状态
    [(string=? state DD) DD] 

    ;; 处于 ER 状态
    [(string=? state ER) ER]))

;; 刻意缺测试案例。
;; 先写测试案例，后写函数，但在这题目上，我先写了函数，所以这次缺了测试案例，视为警戒


;; === 渲染函数 ===
;; ExpectsToSee -> Image
(define (render-rectangle state)
  (cond
    [(string=? state AA) WHITE-RECTANGLE-IMG]
    [(string=? state BB) YELLOW-RECTANGLE-IMG]
    [(string=? state DD) GREEN-RECTANGLE-IMG]
    [(string=? state ER) RED-RECTANGLE-IMG]))

;; 刻意缺测试案例。
;; 先写测试案例，后写函数，但在这题目上，我先写了函数，所以这次缺了测试案例，视为警戒


;; === 程序启动 ===

(recognize-pattern AA)
; 正则式就是一种 pattern，这里听了 Ai 的建议，我最初的命名是 recognize-keyevent
; 整个题目都是在识别一种模式，也就是正则式，可不是只去识别按键了，所以我最初的命名不好。