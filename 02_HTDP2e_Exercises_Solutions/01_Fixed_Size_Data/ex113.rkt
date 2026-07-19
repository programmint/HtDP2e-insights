#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex113
;; 给3个数据定义设计谓词

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


;; 题意解析
;; 113 题看起来很无聊，之前的题目，我早就使用谓词了，来验证输入值是否有效。
;; 何必多此一举？

;; 113 题和 114 题连起来看，才能发现端倪：
;; 113 题要求的谓词，从数据定义角度出发，114 题则是从计算之后的结果来入手
;; 二者配合，确保程序合格。

;; 下面的题目，之前解题，都是利用单独的函数，单独验证输入值是否有效。
;; 更为合理的做法，是整体检测输入值。

;; 愿每一题，皆化为程序设计之起点！


;; === SIGS 谓词 ===

;; UFO 数据定义
;; UFO 是结构体，表示 UFO 在背景中的位置
(define-struct ufo [x y])
;; 一个 UFO 是(make-ufo number number)
;; 解释:
;; - x 是 UFO 从左到右的位置
;; - y 是 UFO 从上到下的位置


;; TANK 数据定义
;; TANK 是结构体，表示坦克在背景中的位置
(define-struct tank [x vel])
;; 一个 TANK 是 (make-tank number number)
;; 解释:
;; - x 是 TANK 从左到右的位置（高度固定为 TANK-HEIGHT)
;; - vel 是 TANK 的运动速度，+ 表示向右，- 表示向左


;; MISSILE 数据定义
;; MISSILE 是结构体，表示导弹在背景中的位置
(define-struct missile [x y])
;; 一个 MISSILE 是(make-missile number number)
;; 解释:
;; - x 是 MISSILE 从左到右的位置
;; - y 是 MISSILE 从上到下的位置


;; SIGS 数据定义
;; SIGS 是下列之一
;; - (make-aim UFO Tank)
;; - (make-fired MISSILE UFO TANK)
(define-struct aim [ufo tank])
(define-struct fired [missile ufo tank])
;; 解释:表示空间入侵者游戏的完整状态
;; 其中:
;; - 第一种表示还没有发射导弹的状态
;; - 第二种表示已发射导弹的状态


;; Any -> Boolean
;; 验证输入值是不是符合数据定义？
(define (sigs? input-value)
  (or (aim? input-value)
      (fired? input-value)))

;; --- tests-sigs?---

;; 测试输入值符合 SIGS 
(check-expect (sigs? (make-aim (make-ufo 50 50) (make-tank 100 5))) #true)
(check-expect (sigs? (make-fired (make-missile 50 60) (make-ufo 50 50) (make-tank 100 5))) #true)

;; 测试输入值不符合 SIGS 
(check-expect (sigs? "abc") #false)

;; --- tests-Done-sigs? ---


;; === Coordinate 谓词 ===

; Exercise 105. Some program contains the following data definition:
; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point

;; Any -> Boolean
;; 检验输入值是不是符合数据定义
(define (coordinate? input-value)
      ;; 检验是不是负数？ 
  (or (and (number? input-value)
           (negative? input-value))

      ;; 检验是不是正数？ 
      (and (number? input-value)
           (positive? input-value))

      ;; 检验是不是posn？ 
      (posn? input-value)))

;; --- tests-coordinate? ---

;; 测试符合数据定义的输入值
(check-expect (coordinate? -3) #true)
(check-expect (coordinate? 2) #true)
(check-expect (coordinate? (make-posn 5 6)) #true)

;; 测试不符合数据定义的输入值
(check-expect (coordinate? "a") #false)
(check-expect (coordinate? #true) #false)
(check-expect (coordinate? "hi") #false)

;; --- tests-Done-coordinate? ---


;; === VAnimal 谓词 ===

;; VCat 是结构体，表示猫的 3 个状态
(define-struct vcat [x happiness direction])
;; 一个 VCat 是 (make-vcat number number direction)
;; - x: 猫在背景内的 x 坐标(y 坐标恒定为常量)
;; - happiness: 猫的快乐指数 [0-100]
;; - direction: 猫运动的方向，"right" 或 "left"


;; VCham 是结构体，表示变色龙的 3 个状态
(define-struct vcham [x happiness color])
;; 一个 VCham 是 (make-vcham number number string)
;; - x: 变色龙在画布中的 x 坐标(y 坐标恒定为常量)
;; - happiness: 变色龙的快乐值 [0,100]
;; - color: 变色龙的色彩，"red"，"green"，"blue"

;; VAnimal 是两者之一:
;; -- VCat
;; -- VCham

;; Any -> Boolean
;; 检测输入值是不是符合数据定义
(define (vanimal? input-value)
  (or (vcat? input-value)
      (vcham? input-value)))


;; --- tests-vanimal? ---

;; 测试符合数据定义的输入值
(check-expect (vanimal? (make-vcat 0 100 "left")) #true)
(check-expect (vanimal? (make-vcham 10 100 "red")) #true)

;; 测试不符合数据定义的输入值
(check-expect (vanimal? 2) #false)
(check-expect (vanimal? "hi") #false)

;; --- tests-Done-vanimal? ---