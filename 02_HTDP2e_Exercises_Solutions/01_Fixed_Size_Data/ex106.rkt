#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

;;; ex106
;;
;; 设计 cat-cham 程序，输入一位置和一动物，然后穿过画布，注意各自的规则。
;;
;; 术语
;; - h-val: happiness-value (快乐指数数值)
;; - IMG / img : image (图片)
;; - MSG : message (信息)
;; - POS: position (位置)


;; === 常量定义 ===

;; 游戏场景
(define SCENE-WIDTH 300)
(define SCENE-HEIGHT 300)
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

;; 游戏结束信息
(define END-MSG (text "游戏已结束" 16 "red"))
(define END-MSG-X 155)
(define END-MSG-Y 20)

;; 猫及变色龙图像
(define CAT-IMG (bitmap "images/cat.png"))  
(define CHAM-IMG (bitmap "images/cham.png"))  

;; 快乐指数图像
(define HAPPINESS-BAR-WIDTH 8)
(define HAPPINESS-PANEL-WIDTH 10)
(define HAPPINESS-PANEL (empty-scene HAPPINESS-BAR-WIDTH SCENE-HEIGHT))

;; 动物行为常量
(define PADDING-BOTTOM 1)

(define CAT-Y-POS 
  (- SCENE-HEIGHT (/ (image-height CAT-IMG) 2) PADDING-BOTTOM))

(define CHAM-Y-POS 
  (- SCENE-HEIGHT (/ (image-height CHAM-IMG) 2) PADDING-BOTTOM))

(define CAT-MOVE-SPEED 3)
(define CHAM-MOVE-SPEED 1)
(define HAPPINESS-FALL-SPEED 0.5)
(define CAT-FEED-GAIN 1/5)
(define CAT-PET-GAIN 1/3)
(define CHAM-FEED-GAIN 2)


;; === VCat 数据定义 ===

;; VCat 是结构体，表示猫的 3 个状态
(define-struct vcat [x happiness direction])
;; 一个 VCat 是 (make-vcat number number direction)
;; - x: 猫在背景内的 x 坐标(y 坐标恒定为常量)
;; - happiness: 猫的快乐指数 [0-100]
;; - direction: 猫运动的方向，"right" 或 "left"

;; --- tests ---
(check-expect (make-vcat 0 100 "left") (make-vcat 0 100 "left"))
(check-expect (vcat-x (make-vcat 0 100 "right")) 0)
(check-expect (vcat-happiness (make-vcat 50 80 "right")) 80)
(check-expect (vcat-direction (make-vcat 50 80 "right")) "right")


;; === VCham 数据定义 ===

;; VCham 是结构体，表示变色龙的 3 个状态
(define-struct vcham [x happiness color])
;; 一个 VCham 是 (make-vcham number number string)
;; - x: 变色龙在画布中的 x 坐标(y 坐标恒定为常量)
;; - happiness: 变色龙的快乐值 [0,100]
;; - color: 变色龙的色彩，"red"，"green"，"blue"

;; --- tests ---
(check-expect (make-vcham 10 100 "red") (make-vcham 10 100 "red"))
(check-expect (make-vcham 0 0 "blue") (make-vcham 0 0 "blue"))
(check-expect (vcham-x (make-vcham 10 100 "red")) 10)
(check-expect (vcham-happiness (make-vcham 10 100 "red")) 100)
(check-expect (vcham-color (make-vcham 10 100 "red")) "red")


;; === VAnimal 数据定义 ===

;; VAnimal是两者之一:
;; -- VCat
;; -- VCham


;; === VAnimal 主程序 ===

;; VAnimal -> WorldState
(define (run-animal state)
  (big-bang state
    [on-tick dispatch-tick]
    [on-key dispatch-key]
    [on-draw dispatch-render]
    [stop-when game-over? dispatch-end-scene]))


;; === 状态更新函数(分发) ===

;; VAnimal -> VAnimal
(define (dispatch-tick state)
  (cond
    [(vcat? state) (update-vcat state)]
    [(vcham? state) (update-vcham state)]
    [else "请输入正确的数据格式"]))

;; --- tests ---
(check-expect
 (dispatch-tick (make-vcat 10 100 "right"))
 (update-vcat (make-vcat 10 100 "right")))

(check-expect
 (dispatch-tick (make-vcham 100 80 "red"))
 (update-vcham (make-vcham 100 80 "red")))

(check-expect
 (dispatch-tick "hello HTDP2e")
 "请输入正确的数据格式")


;; === 按键函数(分发) ===

;; VAnimal KeyEvent -> VAnimal
(define (dispatch-key state key)
  (cond
    [(vcat? state) (handle-key-vcat state key)]
    [(vcham? state) (handle-key-vcham state key)]
    [else "请输入正确的数据格式"]))

;; --- tests ---
(check-expect
 (dispatch-key (make-vcat 10 100 "right") "up")
 (handle-key-vcat (make-vcat 10 100 "right") "up"))

(check-expect
 (dispatch-key (make-vcham 100 80 "red") "r")
 (handle-key-vcham (make-vcham 100 80 "red") "r"))

(check-expect
 (dispatch-key "hello_HTDP2e" "a")
 "请输入正确的数据格式")


;; === 渲染函数(分发) ===

;; VAnimal -> Image
(define (dispatch-render state)
  (cond
    [(vcat? state) (render-vcat state)]
    [(vcham? state) (render-vcham state)]
    [else "请输入正确的数据格式"]))

;; --- tests ---
(check-expect
 (dispatch-render (make-vcat 10 100 "right"))
 (render-vcat (make-vcat 10 100 "right")))

(check-expect
 (dispatch-render (make-vcham 100 80 "red"))
 (render-vcham (make-vcham 100 80 "red")))

(check-expect
 (dispatch-render "hello HTDP2e")
 "请输入正确的数据格式")


;; === 停止函数 ===

;; VAnimal -> Boolean
(define (game-over? state)
  (cond
    [(and (vcat? state) (<= (limit-happiness (vcat-happiness state)) 0)) #true]
    [(and (vcham? state) (<= (limit-happiness (vcham-happiness state)) 0)) #true]
    [else #false]))

;; --- tests ---
(check-expect (game-over? (make-vcat 10 100 "right")) #false)
(check-expect (game-over? (make-vcham 100 80 "red")) #false)
(check-expect (game-over? (make-vcat 10 0 "right")) #true)
(check-expect (game-over? (make-vcham 100 0 "red")) #true)


;; === 游戏停止后的图像(分发) ===

;; VAnimal -> Image 
(define (dispatch-end-scene state)
  (cond
    [(vcat? state) (end-scene-vcat state)]
    [(vcham? state) (end-scene-vcham state)]
    [else (error "end-scene: unknown animal state")]))

;; --- tests ---
(check-expect 
 (dispatch-end-scene (make-vcat 20 0 "right"))
 (end-scene-vcat (make-vcat 20 0 "right")))

(check-expect 
 (dispatch-end-scene (make-vcham 20 0 "red"))
 (end-scene-vcham (make-vcham 20 0 "red")))

(check-error
 (dispatch-end-scene "hello")
 "end-scene: unknown animal state")


;; === 猫状态更新 ===

;; 猫来回折返时会"穿墙"(中心点到达边界才转向)，
;; 算是视觉瑕疵，但不影响核心逻辑。

;; VCat -> VCat
(define (update-vcat state)
  (make-vcat
   (cond
     [(string=? (vcat-direction state) "right") (+ (vcat-x state) CAT-MOVE-SPEED)]
     [(string=? (vcat-direction state) "left") (- (vcat-x state) CAT-MOVE-SPEED)]
     [else (vcat-x state)])
   (limit-happiness (- (vcat-happiness state) HAPPINESS-FALL-SPEED))
   (cond
     [(and (string=? (vcat-direction state) "right") (>= (vcat-x state) SCENE-WIDTH)) "left"]
     [(and (string=? (vcat-direction state) "left") (<= (vcat-x state) 0)) "right"]
     [else (vcat-direction state)])))

;; --- tests ---
;; 正常行走
(check-expect
 (update-vcat (make-vcat 50 100 "right"))
 (make-vcat (+ 50 3) 99.5 "right")) 

(check-expect
 (update-vcat (make-vcat 50 100 "left"))
 (make-vcat (- 50 3) 99.5 "left"))

;; 行走转向
(check-expect
 (update-vcat (make-vcat 300 100 "right"))
 (make-vcat (+ 300 3) 99.5 "left"))  

(check-expect
 (update-vcat (make-vcat 0 100 "left"))
 (make-vcat (- 0 3) 99.5 "right")) 

;; 快乐值边界
(check-expect
 (update-vcat (make-vcat 50 0 "right"))
 (make-vcat (+ 50 3) 0 "right"))

(check-expect
 (update-vcat (make-vcat 50 0.1 "right"))
 (make-vcat (+ 50 3) 0 "right"))


;; === 猫按键 ===

;; 快乐指数的变化值，采用第 47 题的设定
;; VCat KeyEvent -> VCat
(define (handle-key-vcat state key)
  (cond
    [(key=? key "up") (make-vcat (vcat-x state)
                                 (limit-happiness (* (vcat-happiness state) (+ 1 CAT-PET-GAIN)))
                                 (vcat-direction state))]
    [(key=? key "down") (make-vcat (vcat-x state)
                                   (limit-happiness (* (vcat-happiness state) (+ 1 CAT-FEED-GAIN)))
                                   (vcat-direction state))]
    [else state]))

;; --- tests ---
(check-expect
 (handle-key-vcat (make-vcat 10 90 "right") "up")
 (make-vcat 10 100 "right")) 

(check-expect
 (handle-key-vcat (make-vcat 10 99 "right") "up")
 (make-vcat 10 100 "right"))

(check-expect
 (handle-key-vcat (make-vcat 10 10 "right") "down")
 (make-vcat 10 12 "right"))

(check-expect
 (handle-key-vcat (make-vcat 10 50 "left") "left") 
 (make-vcat 10 50 "left"))

(check-expect
 (handle-key-vcat (make-vcat 10 50 "left") "a") 
 (make-vcat 10 50 "left"))


;; === 猫渲染(整体) ===

;; VCat -> Image 
(define (render-vcat state)
  (beside/align "bottom"
                (render-happiness-bar (vcat-happiness state))
                (render-cat (vcat-x state)))) 

;; --- tests ---
(check-expect
 (render-vcat (make-vcat 10 100 "right")) 
 (beside/align "bottom"
               (render-happiness-bar 100)
               (render-cat 10))) 

(check-expect
 (render-vcat (make-vcat 10 100 "left")) 
 (beside/align "bottom"
               (render-happiness-bar 100)
               (render-cat 10))) 


;; === 猫行走图像 ===

;; Number -> Image 
(define (render-cat cat-x)
  (place-image CAT-IMG cat-x CAT-Y-POS SCENE))

;; --- tests ---
(check-expect
 (render-cat 20)
 (place-image CAT-IMG 20 CAT-Y-POS SCENE))


;; === 猫停止图像 ===

;; VCat -> Image 
(define (end-scene-vcat state)
  (place-image END-MSG END-MSG-X END-MSG-Y (render-vcat state)))

;; --- tests ---
(check-expect 
 (end-scene-vcat (make-vcat 20 0 "right"))
 (place-image END-MSG END-MSG-X END-MSG-Y
              (render-vcat (make-vcat 20 0 "right"))))


;; === 变色龙状态更新 ===

;; VCham -> VCham
(define (update-vcham state)
  (make-vcham
   (modulo (+ (vcham-x state) CHAM-MOVE-SPEED) SCENE-WIDTH)
   (limit-happiness (- (vcham-happiness state) HAPPINESS-FALL-SPEED))
   (vcham-color state)))

;; --- tests ---
(check-expect
 (update-vcham (make-vcham 50 100 "red"))
 (make-vcham 51 99.5 "red")) 

(check-expect
 (update-vcham (make-vcham 299 100 "green"))
 (make-vcham 0 99.5 "green")) 

(check-expect
 (update-vcham (make-vcham 50 0 "blue"))
 (make-vcham 51 0 "blue"))

(check-expect
 (update-vcham (make-vcham 50 0.1 "red"))
 (make-vcham 51 0 "red"))


;; === 变色龙按键 ===

;; VCham KeyEvent -> VCham
(define (handle-key-vcham state key)
  (cond
    [(key=? key "down") (make-vcham (vcham-x state)
                                    (limit-happiness (+ (vcham-happiness state) CHAM-FEED-GAIN))
                                    (vcham-color state))]
    [(key=? key "r") (make-vcham (vcham-x state) (vcham-happiness state) "red")]
    [(key=? key "g") (make-vcham (vcham-x state) (vcham-happiness state) "green")]
    [(key=? key "b") (make-vcham (vcham-x state) (vcham-happiness state) "blue")]
    [else state]))

;; --- tests ---
(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "down")
 (make-vcham 10 82 "red")) 

(check-expect
 (handle-key-vcham (make-vcham 10 99 "red") "down")
 (make-vcham 10 100 "red")) 

(check-expect
 (handle-key-vcham (make-vcham 10 80 "green") "r")
 (make-vcham 10 80 "red")) 

(check-expect
 (handle-key-vcham (make-vcham 10 80 "blue") "g")
 (make-vcham 10 80 "green")) 

(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "b")
 (make-vcham 10 80 "blue"))

(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "up")
 (make-vcham 10 80 "red"))

(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "a")
 (make-vcham 10 80 "red"))


;; === 变色龙渲染(整体) ===

;; VCham -> Image 
(define (render-vcham state)
  (beside/align "bottom"
                (render-happiness-bar (vcham-happiness state))
                (render-cham (vcham-x state) (vcham-color state)))) 

;; --- tests ---
(check-expect
 (render-vcham (make-vcham 10 100 "red")) 
 (beside/align "bottom"
               (render-happiness-bar 100)
               (render-cham 10 "red"))) 


;; === 变色龙行走图像 ===

;; Number String -> Image 
(define (render-cham cham-x cham-color)
  (place-image
   (overlay CHAM-IMG
            (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" cham-color))
   cham-x CHAM-Y-POS SCENE))

;; --- tests ---
(check-expect 
 (render-cham 20 "red")
 (place-image 
  (overlay CHAM-IMG
           (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" "red"))
  20 CHAM-Y-POS SCENE))


;; === 变色龙停止图像 ===

;; VCham -> Image 
(define (end-scene-vcham state)
  (place-image END-MSG END-MSG-X END-MSG-Y (render-vcham state)))

;; --- tests ---
(check-expect 
 (end-scene-vcham (make-vcham 20 0 "red"))
 (place-image END-MSG END-MSG-X END-MSG-Y
              (render-vcham (make-vcham 20 0 "red"))))


;; === 通用辅助函数 ===

;; 渲染快乐指数条
;; Number -> Image
(define (render-happiness-bar happiness-level)
  (place-image
   (rectangle HAPPINESS-BAR-WIDTH
              (* SCENE-HEIGHT (/ happiness-level 100))
              "solid" "red")
   (/ HAPPINESS-PANEL-WIDTH 2)
   (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ happiness-level 100)) 2))
   HAPPINESS-PANEL))

;; --- tests ---
(check-expect (render-happiness-bar 20)
              (place-image
               (rectangle HAPPINESS-BAR-WIDTH
                          (* SCENE-HEIGHT (/ 20 100))
                          "solid" "red")
               (/ HAPPINESS-PANEL-WIDTH 2)
               (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ 20 100)) 2))
               HAPPINESS-PANEL))

(check-expect (render-happiness-bar 0)
              (place-image
               (rectangle HAPPINESS-BAR-WIDTH
                          (* SCENE-HEIGHT (/ 0 100))
                          "solid" "red")
               (/ HAPPINESS-PANEL-WIDTH 2)
               (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ 0 100)) 2))
               HAPPINESS-PANEL))

;; 限制快乐指数值位于[0,100]
;; Number -> Number
(define (limit-happiness h-val)
  (min 100 (max 0 h-val)))

;; --- tests ---
(check-expect (limit-happiness 0) 0)
(check-expect (limit-happiness 100) 100)
(check-expect (limit-happiness -1) 0)
(check-expect (limit-happiness 120) 100)


;; === 程序启动 ===
(run-animal (make-vcat 20 100 "right"))
;; (run-animal (make-vcham 20 100 "red"))