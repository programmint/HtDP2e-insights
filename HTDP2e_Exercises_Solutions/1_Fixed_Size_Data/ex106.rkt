#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

;;; ex106

;; |------------------------------------------
;; | [需求提纲]
;; |------------------------------------------
;; | [全局目的]
;; | 设计 cat-cham 程序，输入一位置和一动物，然后穿过画布，注意各自的规则。
;; |
;; | [注]
;; | 本题中文版翻译有严重失误，详见：[6.6 - 一只动物吗？](https://github.com/programmint/HtDP2e-insights/blob/main/Translation%20Proofreading%20Notes/%E7%AC%AC%206%20%E7%AB%A0-%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95/6.6%20-%20P119%20-%20%E4%B8%80%E5%8F%AA%E5%8A%A8%E7%89%A9%E5%90%97%EF%BC%9F.md)      
;; |
;; | 106 题与 107 题，两结构体合一，条件略繁，难度则未胜之前。
;; |------------------------------------------


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; 术语
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; - IMG / img : image(图片)
;; - POS: position (位置)


;; ===========================================
;; 常量定义
;; ===========================================

;; ------------------------------------------
;; 游戏场景图像

(define SCENE-WIDTH 300)
(define SCENE-HEIGHT 300) ; 场景唯一高（多处用）
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))


;; ------------------------------------------
;; 猫及变色龙图像

(define CAT-IMG (bitmap "images/cat.png"))  
(define CHAM-IMG (bitmap "images/cham.png"))  


;; ------------------------------------------
;; 快乐指数图像
;; 快乐指数 = 快乐指数条 + 快乐指数面板

(define HAPPINESS-BAR-WIDTH 8)
(define HAPPINESS-PANEL-WIDTH 10)
(define HAPPINESS-PANEL (empty-scene HAPPINESS-BAR-WIDTH SCENE-HEIGHT))


;; ------------------------------------------
;; 动物行为常量

;; 动物底部内边距
(define PADDING-BOTTOM 1)

;; 猫位于背景 y 值
(define CAT-Y-POS (+ (- SCENE-HEIGHT ( / (image-height CAT-IMG) 2) PADDING-BOTTOM)))

;; 变色龙位于背景 y 值
(define CHAM-Y-POS (+ (- SCENE-HEIGHT ( / (image-height CHAM-IMG) 2) PADDING-BOTTOM)))


;; 猫移动速度
(define CAT-MOVE-SPEED 3)

;; 变色龙移动速度
(define CHAM-MOVE-SPEED 1)

;; 快乐指数下降速度
(define HAPPINESS-FALL-SPEED 0.5)


;; ===========================================
;; VCat 数据定义
;; ===========================================

;; VCat 是结构体，表示猫的 3 个状态
(define-struct vcat [x happiness direction])
;; 一个 VCat 是 (make-vcat number number direction）
;; 解释
;; - x: 猫在背景内的 x 坐标
;; - 注：猫的 y 坐标恒定为常量，本题中恒定不变
;; - happiness: 猫的快乐指数 [0-100]
;; - direction：猫运动的方向，"right" 或 "left"

;; ...........................................
;; 测试 VCat 

(check-expect (make-vcat 0 100 "left") (make-vcat 0 100 "left"))
(check-expect (vcat-x (make-vcat 0 100 "right")) 0)
(check-expect (vcat-happiness (make-vcat 50 80 "right")) 80)
(check-expect (vcat-direction (make-vcat 50 80 "right")) "right")

;; End of Tests ..............................


;; ===========================================
;; VCham 数据定义
;; ===========================================

;; VCham 是结构体，表示变色龙的 3 个状态
(define-struct vcham [x happiness color])
;; 一个 VCham 是 (make-vcham number number string)
;; 解释
;; - x：变色龙在画布中的 x 坐标
;; - 注：变色龙的 y 坐标恒定为常量，本题中恒定不变
;; - happiness：变色龙的快乐值的具体数据 [0,CANVAS-HEIGHT]
;; - color：变色龙的具体色彩，分为："red","green","blue"

;; ...........................................
;; 测试 VCham 

(check-expect (make-vcham 10 100 "red") (make-vcham 10 100 "red"))
(check-expect (make-vcham 0 0 "blue") (make-vcham 0 0 "blue"))
(check-expect (vcham-x (make-vcham 10 100 "red")) 10)
(check-expect (vcham-happiness (make-vcham 10 100 "red")) 100)
(check-expect (vcham-color (make-vcham 10 100 "red")) "red")

;; End of Tests ..............................


;; ===========================================
;; VAnimal 数据定义
;; ===========================================

;; VAnimal是两者之一：
;; -- VCat
;; -- VCham
;; 解释
;; - VCat 是结构体
;; - VCham 是结构体


;; ===========================================
;; VAnimal 主程序
;; ===========================================

;; VAnimal -> WorldState
(define (run-animal state)
  (big-bang state
   [on-tick dispatch-tick]
   [on-key dispatch-key]
   [on-draw dispatch-render]
   [stop-when game-over? end-scene]))

;; ...........................................
;; 测试 VAnimal 主程序

;; Big-bang 启动的是交互世界，而非计算数值。
;; 故不可测，只能看是不是能跑通。 

;; End of Tests ..............................


;; ===========================================
;; 状态更新函数
;; ===========================================

;; 实时更新猫或变色龙的各个状态
;; VAnimal -> VAnimal
(define (dispatch-tick state)
  (cond
   [(vcat? state) (update-vcat state)]
   [(vcham? state) (update-vcham state)]
   [else "请输入正确的数据格式"]))

;; ...........................................
;; 测试状态更新函数

;; 注
;; 状态更新函数是分发函数，负责审核传入的数据格式是否正确，审核能否正确调用子函数。
;; 因此，仅仅是测试上述项，就足够了。
;; 状态更新函数，按键函数，渲染函数，均是如此。

(check-expect
  (dispatch-tick (make-vcat 10 100 "right"))
  (update-vcat (make-vcat 10 100 "right")))

(check-expect
  (dispatch-tick (make-vcham 100 80 "red"))
  (update-vcham (make-vcham 100 80 "red")))

(check-expect
  (dispatch-tick "hello HTDP2e")
  "请输入正确的数据格式")

;; End of Tests ..............................


;; ===========================================
;; 按键函数
;; ===========================================

;; 依据按键，控制猫或变色龙的行为及快乐指数
;; WorldState KyeEvent -> WorldState
(define (dispatch-key state)
  (cond
   [(vcat? state) (handle-key-vcat state)]
   [(vcham? state) (handle-key-vcham state)]
   [else "请输入正确的数据格式"]))

;; ...........................................
;; 测试按键函数

(check-expect
  (dispatch-key (make-vcat 10 100 "right"))
  (handle-key-vcat (make-vcat 10 100 "right")))

(check-expect
  (dispatch-key (make-vcham 100 80 "red"))
  (update-vcat (make-vcham 100 80 "red")))

(check-expect
  (dispatch-key "hello HTDP2e")
  "请输入正确的数据格式")

;; End of Tests ..............................


;; ===========================================
;; 渲染函数
;; ===========================================

;; 实时渲染猫或变色龙的图像
;; WorldState -> Image
(define (dispatch-render state)
  (cond
   [(vcat? state) (render-vcat state)]
   [(vcham? state) (render-vcham state)]
   [else "请输入正确的数据格式"]))

;; ...........................................
;; 测试渲染函数

(check-expect
  (dispatch-render (make-vcat 10 100 "right"))
  (render-cat-vcat (make-vcat 10 100 "right")))

(check-expect
  (dispatch-render (make-vcham 100 80 "red"))
  (render-vcham (make-vcham 100 80 "red")))

(check-expect
  (dispatch-render "hello HTDP2e")
  "请输入正确的数据格式")

;; End of Tests ..............................


;; ===========================================
;; 停止函数
;; ===========================================

;; 判断游戏是否停止?
;; VAnimal -> Boolean
(define (game-over? state)
  (cond
   [(and (vcat? state) (<= (happiness-bar-height state) 0)) #true]
   [(and (vcham? state) (<= (happiness-bar-height state) 0)) #true]
   [else #false]))

;; ...........................................
;; 测试停止函数

(check-expect
  (game-over? (make-vcat 10 100 "right"))
  #false)

(check-expect
  (game-over? (make-vcham 100 80 "red"))
  #false)

(check-expect
  (game-over? (make-vcat 10 0 "right"))
  #true)

(check-expect
  (game-over? (make-vcham 100 0 "red"))
  #true)

;; End of Tests ..............................


;; ===========================================
;; 猫状态更新函数
;; ===========================================

;; 定义猫状态函数
;; VAnimal -> VCat
(define (update-vcat state)
  (make-vcat
   ;; 更新 x 的数值
   (cond
    [(string=? (vcat-direction state) "right") (+ (vcat-x state) CAT-MOVE-SPEED)]
    [(string=? (vcat-direction state) "left") (- (vcat-x state) CAT-MOVE-SPEED)]
    [else (vcat-x state)])

   ;; 更新 happiness 数值
   (max 0 (- (vcat-happiness state) HAPPINESS-FALL-SPEED))
   
   ;; 更新 direction 的数值
   (cond
    [(and (string=? (vcat-direction state) "right") (>= (vcat-x state) SCENE-WIDTH)) "left"]
    [(and (string=? (vcat-direction state) "left") (<= (vcat-x state) 0)) "right"]
    [else (vcat-direction state)])))

;; ...........................................
;; 测试猫状态更新函数

;; 测试 x 数值
(check-expect
  (update-vcat (make-vcat 180 100 "left"))
  (make-vcat 177 99.5 "left"))

(check-expect
  (update-vcat (make-vcat 10 100 "right"))
  (make-vcat 13 99.5 "right"))

;; 测试 happiness 数值
(check-expect
  (make-vcat 299 100 "right")
  (make-vcat 299 99 "left"))

(check-expect
  (make-vcat 3 100 "left")
  (make-vcat 3 99 "right"))

;; 测试 direction 的数值
(check-expect
  (make-vcham 10 100 "red")
  (make-vcham 11 99.5 "red"))

;; End of Tests ..............................


;; ===========================================
;; 猫按键函数
;; ===========================================

;; 根据按键，控制猫的快乐指数高度 
;; VCat Key -> Number
(define (handle-key-vcat state)
  (cond
   [(key=? key "up") (make-vcat (vcat-x state)
                                (min 100 (* (vcat-happiness state) (+ 1 1/3)))
                                (vcat-direction state))]
   [(key=? key "down") (make-vcat (vcat-x state)
                                (max 0 (* (vcat-happiness state) (+ 1 1/5)))
                                (vcat-direction state))]
   [else state]))

;; ...........................................
;; 测试猫按键函数

;; 测试按向上键，快乐指数由 9 增至 12
(check-expect
  (handle-key (make-vcat 10 9 "right") "up")
  (make-vcat 10 12 "right"))

;; 测试按向上键，快乐指数输入值 102，实际快乐指数值是 100，并不会增长
(check-expect
  (handle-key (make-vcat 10 102 "right" ) "up")
  (make-vcat 10 100 "right"))

;; 测试按下箭头键，快乐指数由 10 增加为 12
(check-expect
  (handle-key (make-vcat 10 10 "right") "down")
  (make-vcat 10 12 "right"))

;; 测试按下箭头键，快乐指数输入值 -1，实为 0 ，不会增加
(check-expect
  (handle-key (make-vcat 10 -1 "right") "down")
  (make-vcat 10 0 "right"))

;; 测试右行，且位于背景内，按左键不改变前行方向
(check-expect
  (handle-key (make-vcat 10 10 "right") "left")
  (make-vcat 10 10 "right"))

;; 测试其他按键不改变状态
(check-expect
  (handle-key (make-vcat 10 10 "right") "a")
  (make-vcat 10 10 "right"))

;; End of Tests ..............................


;; ===========================================
;; 猫+快乐指数渲染函数
;; ===========================================

;; 依据条件，实时渲猫行走+开心指数图像
;; Image VCat -> Image 
(define (render-vcat state)
  (beside/align "bottom"
                (render-happiness-bar (vcat-happiness state))
                (render-cat (vcat-x state)))) 

;; ...........................................
;; 测试猫+快乐指数渲染函数

;; 注：
;; render-vcat 函数是拼接函数，主要功能是把两个子函数拼接在一起。
;; 是以，测试用例能证明拼接成功就可以了，不必追求测试案例全面。

;; 猫向右，向左移动，都可以渲染图像
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

;; End of Tests ..............................


;; ===========================================
;; 猫行走渲染函数
;; ===========================================

;; 依据条件，实时渲猫行走图像
;; Image VCat -> Image 
(define (render-cat (vcat-x state))
  (place-image
   ;; 猫图像  
   CAT-IMG

   ;; x 值
   (vcat-x state)  

   ;; y 值
   (CAT-Y-POS

   ;; 运动背景
   SCENE))

;; ...........................................
;; 测试猫行走渲染函数





;; End of Tests ..............................


;; ===========================================
;; 变色龙状态更新函数
;; ===========================================

;; 实时更新变色龙的状态
;; VCham -> VCham
(define (update-vcham state)
  (make-vcham
  ;; 更新 x 的数值
  (modulo
   (+ (vcham-x state) CHAM-MOVE-SPEED) SCENE-WIDTH)

  ;; 更新 happiness 的数值
  (max 0(- (vcham-happiness state) HAPPINESS-FALL-SPEED))

  ;; 更新 color 的数值
  (vcham-color state)))

;; ...........................................
;; 测试变色龙状态更新函数

;; 测试 x 数值
(check-expect (vcham-x (make-vcham 11 100 "red"))
              (modulo (+ 10 CHAM-MOVE-SPEED) SCENE-WIDTH))

;; 测试 happiness 数值

;; 测试 color 数值

;; End of Tests ..............................


;; ===========================================
;; 通用辅助函数
;; ===========================================

;; 渲染快乐指数函数
;; Number -> Image
(define (render-happiness-bar happiness-level)
  (place-image
   ;; 快乐指数条高度图像
   (rectangle HAPPINESS-BAR-WIDTH
              (* SCENE-HEIGHT (/ happiness-level 100))
              "solid" "red")
   
   ;; x 的值
   (/ HAPPINESS-PANEL-WIDTH 2)

   ;; y 的值
   (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ happiness-level 100)) 2))

   ;; 快乐指数面板图像
   HAPPINESS-PANEL))

;; ...........................................
;; 测试快乐指数函数

;; 测试快乐指数大于 0
(check-expect (render-happiness-bar 20)
              (place-image
               (rectangle HAPPINESS-BAR-WIDTH
               (* SCENE-HEIGHT (/ 20 100))
               "solid" "red")
   
               (/ HAPPINESS-PANEL-WIDTH 2)

               (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ 20 100)) 2))

               HAPPINESS-PANEL)))

;; 测试快乐指数等于 0
(check-expect (render-happiness-bar 20)
              (place-image
               (rectangle HAPPINESS-BAR-WIDTH
               (* SCENE-HEIGHT (/ 20 100))
               "solid" "red")
   
               (/ HAPPINESS-PANEL-WIDTH 2)

               (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ 20 100)) 2))

               HAPPINESS-PANEL))

;; End of Tests ..............................


;; ===========================================
;; 程序启动
;; ===========================================
(make-vcat 20 100 "right")
