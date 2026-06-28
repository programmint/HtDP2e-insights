#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex107
;; 设计 zoo 程序，同时输入两只动物，各自穿过画布，注意各自的规则。


;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


;; 术语
;; - BG : background(背景)
;; - IMG / img : image (图片)
;; - MSG / msg : message (信息)
;; - POS/pos : position (位置)


;; === 常量 ===

; 注:
; 107题的常量该怎么样分组?并没有摸索出来。
; 和 Ai 聊了，Ai 前前后后给了 3 套方案，但各有其问题，暂时搁置，待后续解决。


;; --- 游戏基础 ---

;; 游戏场景
(define SCENE-WIDTH 700)
(define SCENE-HEIGHT 500)
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))


;; --- 动物 icon ---

;; icon 尺寸与色彩
(define ICON-MSG-SIZE 15)
(define ICON-MSG-COLOR "white")

(define ICON-SIZE 30)

(define ICON-CAT-BG-COLOR "dodgerblue")
(define ICON-CHAM-BG-COLOR "tomato")


;; 游戏动物 icon 图像
(define CAT-WORD (text "猫" ICON-MSG-SIZE ICON-MSG-COLOR))
(define CHAM-WORD (text "龙" ICON-MSG-SIZE ICON-MSG-COLOR))

(define CAT-ICON
  (overlay CAT-WORD
           (square ICON-SIZE "solid" ICON-CAT-BG-COLOR)))

(define CHAM-ICON
  (overlay CHAM-WORD
           (square ICON-SIZE "solid" ICON-CHAM-BG-COLOR)))


;; 边距
(define MARGIN-WIDTH 
  (- (/ ICON-SIZE 2)
     (/ (image-width CAT-WORD) 2)))

(define MARGIN 
  (rectangle MARGIN-WIDTH 1 "solid" "transparent"))


;; --- 受控动物信息 ---

;; 受控动物图像
(define FOCUS-ANIMAL-SIZE 18)
(define FOCUS-ANIMAL-COLOR "black")
(define FOCUS-MEASUREMENT-MSG (text "变色龙:受控" FOCUS-ANIMAL-SIZE FOCUS-ANIMAL-COLOR))

;; 受控动物图像最大尺寸
(define FOCUS-MEASUREMENT-WIDTH
  (image-width FOCUS-MEASUREMENT-MSG))


;; --- 快乐指数背景 ---

;; 快乐指数背景尺寸
(define HAPPINESS-BG-WIDTH 
  (/ 
    (- SCENE-WIDTH
      (+ FOCUS-MEASUREMENT-WIDTH
         (image-width CAT-ICON)
         (image-width CHAM-ICON)
         (* 6 MARGIN-WIDTH)))
  2))

(define HAPPINESS-BG-HEIGHT 16)

;; 快乐指数背景图片
(define HAPPINESS-BG
  (rectangle HAPPINESS-BG-WIDTH HAPPINESS-BG-HEIGHT "outline" "black")) 


;; --- 快乐指数条 ---

;; 快乐指数条色彩
(define HAPPINESS-BAR-HIGH-COLOR "forestgreen")   
(define HAPPINESS-BAR-LOW-COLOR "red")  

;; 快乐指数条边缘尺寸
(define HAPPINESS-BORDER-WIDTH 1)

;; 快乐指数条尺寸
(define HAPPINESS-BAR-WIDTH (-  HAPPINESS-BG-WIDTH (* 2 HAPPINESS-BORDER-WIDTH)))
(define HAPPINESS-BAR-HEIGHT (- HAPPINESS-BG-HEIGHT (* 2 HAPPINESS-BORDER-WIDTH)))

;; 快乐指数条下降速度
(define CAT-HAPPINESS-FALL-SPEED 0.2)
(define CHAM-HAPPINESS-FALL-SPEED 0.15)

;; 快乐指数条变色临界点
(define HAPPINESS-THRESHOLD 20) 


;; --- 快乐指数行 ---

;; 快乐指数行顶部边距
(define STATUS-TOP-MARGIN 10) 

;; 快乐指数行位置
(define HAPPINESS-ROW-X (/ SCENE-WIDTH 2))

(define HAPPINESS-ROW-Y 
  (+ STATUS-TOP-MARGIN 
     (/ ICON-SIZE 2)))


;; --- 游戏指南 ---

;; 游戏指南行距
(define LINE-SPACING (square 4 "solid" "transparent"))

;; 游戏指南边距
(define GUIDE-MARGIN (square (* 2 MARGIN-WIDTH) "solid" "transparent"))

;; 游戏指南文字尺寸与色彩
(define GUIDE-MSG-SIZE 16)
(define GUIDE-MSG-COLOR "black")

;; 游戏指南文字
(define GUIDE-CAT
  (above/align "left"
    LINE-SPACING
    (text "按 K 控制猫" GUIDE-MSG-SIZE GUIDE-MSG-COLOR)
    LINE-SPACING
    (text "按 ↓ 喂猫 / ↑ 摸猫，猫开心" GUIDE-MSG-SIZE GUIDE-MSG-COLOR)))

(define GUIDE-CHAM
  (above/align "right"
    LINE-SPACING
    (text "按 L 控制变色龙" GUIDE-MSG-SIZE GUIDE-MSG-COLOR)
    LINE-SPACING
    (text "按 ↓ 喂食，按 r/g/b 键，变色龙会变色" GUIDE-MSG-SIZE GUIDE-MSG-COLOR)))

;; 游戏指南透明间隔
(define GUIDE-GAP-WIDTH
  (- SCENE-WIDTH 
     (* 2 (image-width GUIDE-MARGIN))
     (image-width GUIDE-CAT)
     (image-width GUIDE-CHAM)))

(define GUIDE-GAP
  (rectangle GUIDE-GAP-WIDTH 1 "solid" "transparent"))  

; 高度为 1，不必精确计算
; beside/align "bottom" 会根据两个文字块的高度来对齐，间隔的高度会被自动拉伸匹配。


;; 游戏指南行图像
(define GUIDE-ROW
  (beside/align "bottom"
    GUIDE-MARGIN
    GUIDE-CAT
    GUIDE-GAP
    GUIDE-CHAM
    GUIDE-MARGIN))

;; 游戏指南位置
(define GUIDE-X (/ SCENE-WIDTH 2))
(define GUIDE-Y 
  (+ STATUS-TOP-MARGIN
     ICON-SIZE 
     (/ (image-height GUIDE-ROW) 2)))


;; --- 游戏状态栏 ---

;; 状态栏边缘距离
(define STATUS-BORDER-WIDTH 1)

;; 状态栏宽度与高度
(define STATUS-SCENE-WIDTH
  (- SCENE-WIDTH 
     (* 2 STATUS-BORDER-WIDTH)))

(define STATUS-SCENE-HEIGHT
 (+ STATUS-TOP-MARGIN
    ICON-SIZE
    (image-height GUIDE-ROW)))

(define STATUS-SCENE
  (rectangle STATUS-SCENE-WIDTH STATUS-SCENE-HEIGHT "solid" "transparent"))

;; 游戏状态栏位置
(define STATUS-POS
  (make-posn (/ SCENE-WIDTH 2) (/ STATUS-SCENE-HEIGHT 2)))


;; --- 游戏图像 ---

;; 游戏图像
(define CAT-IMG (bitmap "images/cat.png"))  
(define CHAM-IMG (bitmap "images/cham.png"))    

;; 动物距地距离
(define PADDING-BOTTOM 1)

;; 动物实际 Y 轴位置
(define CAT-Y-POS 
  (- SCENE-HEIGHT (/ (image-height CAT-IMG) 2) PADDING-BOTTOM)) 

(define CHAM-Y-POS 
  (/ SCENE-HEIGHT 2))

;; 动物移动速度
(define CAT-MOVE-SPEED 3)
(define CHAM-MOVE-SPEED 1)

;; 动物受控时数值
(define CAT-FEED-GAIN 1/2) ;这里的1/2 是根据视觉及按键效果调整，而采取的数字。
(define CAT-PET-GAIN 1/3)

(define CHAM-FEED-GAIN 2)


;; --- 游戏结束 ---

;; 游戏结束信息
(define END-MSG (text "游戏已结束" 16 "red"))
(define END-MSG-X (/ SCENE-WIDTH 2))
(define END-MSG-Y (/ SCENE-HEIGHT 2))


;; === 快乐指数限定值 ===

;; Number -> Number
;; 限制快乐值范围位于[0，100]
(define (limit-happiness current-happiness)
  (min 100 (max 0 current-happiness)))

;; --- tests - 快乐值 ---
(check-expect (limit-happiness 0) 0)
(check-expect (limit-happiness 100) 100)
(check-expect (limit-happiness -1) 0)
(check-expect (limit-happiness 120) 100)

;; --- tests Done - 快乐值 ---


;; === VCat 数据定义 ===

;; VCat 是结构体，表示猫的 3 个状态
(define-struct vcat [x happiness direction])
;; 一个 VCat 是 (make-vcat number number direction)
;; - x: 猫在背景内的 x 坐标 (y 坐标恒定为常量)
;; - happiness: 猫的快乐指数 [0-100]
;; - direction: 猫运动的方向，"right" 或 "left"

;; --- tests -VCat 数据定义 ---
;; 构造
(check-expect
  (make-vcat 0 100 "left")
  (make-vcat 0 100 "left"))

;; 访问各字段
(check-expect
  (vcat-x (make-vcat 0 100 "right")) 
  0)

(check-expect
  (vcat-happiness (make-vcat 50 80 "right")) 
  80)

(check-expect
  (vcat-direction (make-vcat 50 80 "right"))
  "right")

;; --- tests Done -VCat 数据定义 ---


;; Any -> Boolean 
;; 检测输入是否为合法 VCat?
(define (valid-vcat? state)
  (and (vcat? state)
       (number? (vcat-x state))
       (number? (vcat-happiness state))
       (<= 0 (vcat-happiness state) 100)
       (string? (vcat-direction state))
       (or (string=? (vcat-direction state) "right")
           (string=? (vcat-direction state) "left"))))

;; --- tests -合法 VCat?---
;; 正确数据
(check-expect
  (valid-vcat? (make-vcat 10 80 "right"))
  #true)

;; 错误数据
(check-expect
  (valid-vcat? (make-vcat "left" 80 "right"))
  #false)

(check-expect
  (valid-vcat? (make-vcat 10 "bac" "right"))
  #false)

(check-expect
  (valid-vcat? (make-vcat 10 80 100))
  #false)

;; --- tests Done - 合法 VCat?---


;; === VCham 数据定义 ===

;; VCham 是结构体，表示变色龙的 3 个状态
(define-struct vcham [x happiness color])
;; 一个 VCham 是 (make-vcham number number string)
;; - x: 变色龙在画布中的 x 坐标 ( y 坐标恒定为常量)
;; - happiness: 变色龙的快乐值 [0，100]
;; - color: 变色龙的色彩，"red"，"green"，"blue"

;; --- tests VCham 数据定义 ---
;; 构造
(check-expect
  (make-vcham 10 100 "red")
  (make-vcham 10 100 "red"))

;; 访问各字段
(check-expect
  (vcham-x (make-vcham 10 100 "red"))
  10)

(check-expect
 (vcham-happiness (make-vcham 10 100 "red"))
 100)

(check-expect
  (vcham-color (make-vcham 10 100 "red"))
  "red")

;; --- tests Done VCham 数据定义 ---


;; Any -> Boolean
;; 检验输入值是不是合法的 VCham 数据?
(define (valid-vcham? state)
  (and (vcham? state)
       (number? (vcham-x state))
       (number? (vcham-happiness state))
       (<= 0 (vcham-happiness state) 100)
       (string? (vcham-color state))
       (or (string=? (vcham-color state) "red")
           (string=? (vcham-color state) "green")
           (string=? (vcham-color state) "blue"))))

;; --- tests - 合法的 VCham?---
;; 正确数据
(check-expect
  (valid-vcham? (make-vcham 10 80 "red"))
  #true)

;; 错误数据
(check-expect
  (valid-vcham? (make-vcham "hi" 80 "red"))
  #false)

(check-expect
  (valid-vcham? (make-vcham 10 #true "red"))
  #false)

(check-expect
  (valid-vcham? (make-vcham 10 80 "hello"))
  #false)

;; --- tests Done - 合法 VCham?---


;; === Zoo 数据定义 ===

;; Zoo 是结构体，同时表示猫和变色龙，以及控制按钮
(define-struct zoo [vcat vcham focus-key])
;; 一个 zoo 是(make-zoo vcat vcham string)
;; - vcat:表示结构体 vcat
;; - vcham:表示结构体 vcham
;; - focus-key:表示焦点动物，“k” 代表 cat， “l” 代表 cham

;; --- tests - Zoo 数据---
;; 构造
(check-expect 
 (make-zoo (make-vcat 20 100 "right")
           (make-vcham 50 100 "red")
           "k")
 (make-zoo (make-vcat 20 100 "right")
           (make-vcham 50 100 "red")
           "k"))

;; 访问各字段
(check-expect
 (zoo-vcat (make-zoo (make-vcat 20 100 "right")
                     (make-vcham 50 100 "red")
                     "k"))
 (make-vcat 20 100 "right"))

(check-expect
 (zoo-vcham (make-zoo (make-vcat 20 100 "right")
                      (make-vcham 50 100 "red")
                      "k"))
 (make-vcham 50 100 "red"))

(check-expect
 (zoo-focus-key (make-zoo (make-vcat 20 100 "right")
                          (make-vcham 50 100 "red")
                          "k"))
 "k")

;; --- tests Done - Zoo 数据---


;; Any -> Boolean
;; 检查输入信息是否是 Zoo?
(define (valid-zoo? state)
  (and (zoo? state) 
       (valid-vcat? (zoo-vcat state))
       (valid-vcham? (zoo-vcham state))
       (string? (zoo-focus-key state))
       (or (string=? (zoo-focus-key state) "k")
           (string=? (zoo-focus-key state) "l"))))

;; --- tests -合法Zoo?---
;; 正确输入
(check-expect
  (valid-zoo? (make-zoo (make-vcat 10 100 "right") (make-vcham 10 100 "red") "k"))
  #true)

;; 错误输入 
(check-expect
  (valid-zoo? (make-zoo "hello" (make-vcham 10 100 "red") "k"))
  #false)

(check-expect
  (valid-zoo? (make-zoo (make-vcat 10 100 "right") "hi" "k"))
  #false)

(check-expect
  (valid-zoo? (make-zoo (make-vcat 10 100 "right") (make-vcham 10 100 "red") "m"))
  #false)

(check-expect
  (valid-zoo? "hello")
  #false)

;; --- tests Done -合法Zoo?---


;; === 主程序 ===

;; Zoo -> Zoo
(define (cham-and-cat state)
  (cond
    [(valid-zoo? state) (big-bang state
                          [on-tick update-zoo]
                          [on-key dispatch-key]
                          [on-draw render-zoo]
                          [stop-when game-over? compose-end-scene])]
    [else (error "cham-and-cat:期望输入 Zoo 格式数据，但收到未知格式数据")]))


;; === 状态更新函数 ===

;; Zoo -> Zoo
(define (update-zoo state)
  (make-zoo
   (update-vcat (zoo-vcat state))
   (update-vcham (zoo-vcham state))
   (zoo-focus-key state)))

;; --- tests ---
;; 同时更新 Zoo 的三项数据
(check-expect 
  (update-zoo (make-zoo (make-vcat 10 100 "right")
                        (make-vcham 10 100 "red")
                        "k"))
  (make-zoo (make-vcat 13 99.8 "right")
            (make-vcham 11 99.85 "red")
            "k"))

;; --- tests Done ---


;; === 按键函数 ===

;; Zoo KeyEvent -> Zoo
;; 接收焦点按键，控制动物焦点，动物数值不变;
;; 其他按键，分发至焦点动物去处理。
(define (dispatch-key state key)
  (cond
    ;; 按 k 键，控制 cat
    [(key=? key "k")
     (make-zoo (zoo-vcat state) (zoo-vcham state) "k")]
    
    ;; 按 l 键，控制 cham
    [(key=? key "l")
     (make-zoo (zoo-vcat state) (zoo-vcham state) "l")]

    ;; 后按对应键，控制对应效果
    [(string=? (zoo-focus-key state) "k")
     (make-zoo (handle-key-vcat (zoo-vcat state) key)
               (zoo-vcham state)
               (zoo-focus-key state))]

    [(string=? (zoo-focus-key state) "l")
     (make-zoo (zoo-vcat state)
               (handle-key-vcham (zoo-vcham state) key)
               (zoo-focus-key state))] 
    
    ;; 按错焦点键     
    [else state]))

;; --- Tests 按键函数 ---

;; [ 场景1、测试焦点键分发逻辑 ]

;; 测试按 “k” 键，焦点切换到猫
(check-expect (dispatch-key 
               (make-zoo (make-vcat 10 100 "right") 
                         (make-vcham 10 100 "red") 
                         "l")
                "k")
              (make-zoo (make-vcat 10 100 "right") 
                        (make-vcham 10 100 "red") 
                        "k"))


;; 测试焦点键在猫，多次按 “k” 键，焦点依旧在猫
(check-expect (dispatch-key 
               (make-zoo (make-vcat 10 100 "right") 
                         (make-vcham 10 100 "red") 
                         "k")
                "k")
              (make-zoo (make-vcat 10 100 "right") 
                        (make-vcham 10 100 "red") 
                        "k"))


;; 测试按 “l” 键，焦点切换到变色龙
(check-expect (dispatch-key 
               (make-zoo (make-vcat 20 80 "right")
                         (make-vcham 30 90 "blue") 
                         "k")
               "l") 
              (make-zoo (make-vcat 20 80 "right")
                        (make-vcham 30 90 "blue")
                        "l"))


;; 测试焦点键在变色龙，多次按 “l” 键，焦点依旧在变色龙
(check-expect (dispatch-key 
               (make-zoo (make-vcat 20 80 "right")
                         (make-vcham 30 90 "blue") 
                         "l")
               "l")
              (make-zoo (make-vcat 20 80 "right")
                        (make-vcham 30 90 "blue")
                        "l"))


;; [ 场景2、测试其他按键分发逻辑 ]

;; 焦点在猫，按抚摸键(上箭头)，抚摸键分发给猫
(check-expect (dispatch-key 
               (make-zoo (make-vcat 30 85 "right")
                         (make-vcham 30 85 "green")
                         "k") 
               "up")
              (make-zoo (make-vcat 30 (+ 85 1/3) "right")
                        (make-vcham 30 85 "green")
                        "k"))


;; 焦点在变色龙，按喂食键(下箭头)，喂食键分发给变色龙
(check-expect (dispatch-key 
               (make-zoo (make-vcat 30 60 "left")
                         (make-vcham 50 70 "blue")
                         "l")
               "down")
              (make-zoo (make-vcat 30 60 "left")
                        (make-vcham 50 (+ 70 2) "blue")
                        "l"))


;; [ 场景3、测试按错焦点键 ]
;; 防御性语句，该题按键函数中的 else 语句不必写测试案例。

;; --- Tests Done - 按键函数 ---


;; === 渲染函数 ===

;; Zoo -> Image
;; 实时渲染游戏图像
(define (render-zoo state)
  (place-images
    (list
      ;; 状态栏图片
      (render-zoo-status
        (vcat-happiness (zoo-vcat state))
        (vcham-happiness (zoo-vcham state))
        (zoo-focus-key state))

      ;; 猫图片
      CAT-IMG

      ;; 变色龙图片
      (render-cham-img (zoo-vcham state)))

    (list
      ;; 状态栏-位置
      STATUS-POS

      ;; 猫图片-位置
      (make-posn (vcat-x (zoo-vcat state)) CAT-Y-POS)

      ;; 变色龙图片-位置
      (make-posn (vcham-x (zoo-vcham state)) CHAM-Y-POS))

    SCENE))

;; --- Tests - 渲染函数 ---
;; 渲染函数只是一分发函数，不涉及计算
;; 其作用只是排版，需要用视觉去验证，这里面没有业务逻辑，所以不必添加测试案例。

;; --- Tests Done - 渲染函数 ---


;; === 渲染游戏状态栏 ===

;; Number Number String -> Image
;; 渲染游戏状态栏：快乐指数行和游戏指南，放置在透明底板上
(define (render-zoo-status cat-happiness cham-happiness focus-key)
  (place-images
    (list
      ;; 快乐指数行       
      (render-happiness-row cat-happiness cham-happiness focus-key)

      ;; 游戏指南      
      GUIDE-ROW)

    (list
      ;; 快乐指数行位置:顶部居中
      (make-posn HAPPINESS-ROW-X HAPPINESS-ROW-Y)

      ;; 游戏指南位置:紧贴快乐指数行下方
      (make-posn GUIDE-X GUIDE-Y))

    STATUS-SCENE))

;; --- Tests - 渲染游戏状态栏 ---
;; 同理，渲染游戏状态栏函数，也是一分发函数，不涉及计算。
;; 其作用也是排版，需要用视觉去验证，这里面没有业务逻辑，所以不必添加测试案例。

;; --- Tests Done - 渲染游戏状态栏 ---



;; === 渲染快乐指数行 ===

;; Number Number String -> Image
;; 渲染快乐指数行:猫图标+快乐值、焦点文字、变色龙快乐值+图标
(define (render-happiness-row cat-happiness cham-happiness focus-key)
  (beside/align "bottom"
    MARGIN
    (cat-status cat-happiness) 
    MARGIN        
    (focus-animal-status focus-key) 
    MARGIN  
    (cham-status cham-happiness)
    MARGIN)) 

;; --- tests - 渲染快乐指数行---
;; 同理，渲染快乐指数行函数，也是一分发函数，不涉及计算。
;; 其作用也是排版，需要用视觉去验证，这里面没有业务逻辑，所以不必添加测试案例。

;; --- tests Done - 渲染快乐指数行 ---


;; === 渲染猫快乐指数 ===

;; Number -> Image
;; 渲染猫具体快乐指数:猫图标 + 右对齐血条，底部对齐
(define (cat-status happiness)
  (beside/align "bottom"
    CAT-ICON
    MARGIN
    (render-bar happiness "right")))

;; --- tests - 渲染猫快乐指数---
;; 同理，渲染猫快乐指数函数，也是一分发函数，不涉及计算。
;; 其作用也是排版，需要用视觉去验证，这里面没有业务逻辑，所以不必添加测试案例。

;; --- tests Done - 渲染猫快乐指数 ---


;; === 渲染变色龙快乐指数 ===

;; Number -> Image
;; 渲染具体变色龙快乐指数:左对齐血条 + 变色龙图标，底部对齐
(define (cham-status happiness)
  (beside/align "bottom"
    (render-bar happiness "left")
    MARGIN
    CHAM-ICON))

;; --- tests - 渲染变色龙快乐指数---
;; 同理，渲染变色龙快乐指数函数，也是一分发函数，不涉及计算。
;; 其作用也是排版，需要用视觉去验证，这里面没有业务逻辑，所以不必添加测试案例。

;; --- tests Done - 渲染变色龙快乐指数 ---


;; === 快乐指数条 ===

;; Number String -> Image
;; 生成快乐指数条:固定宽度底框，实际血条按指定方向对齐
(define (render-bar happiness animal-align)
  (overlay/align animal-align "middle"
    (rectangle (* (/ happiness 100) HAPPINESS-BAR-WIDTH)
               HAPPINESS-BAR-HEIGHT
               "solid"
               (if (>= happiness HAPPINESS-THRESHOLD)
                   HAPPINESS-BAR-HIGH-COLOR
                   HAPPINESS-BAR-LOW-COLOR))
    HAPPINESS-BG))

;; --- tests -快乐指数条 ---

;; 快乐值 100，快乐指数满
(check-expect (render-bar 100 "right")
              (overlay/align "right" "middle"
                (rectangle HAPPINESS-BAR-WIDTH HAPPINESS-BAR-HEIGHT "solid" HAPPINESS-BAR-HIGH-COLOR)
                HAPPINESS-BG))

;; 快乐值 0，快乐指数空
(check-expect (render-bar 0 "left")
              (overlay/align "left" "middle"
                (rectangle 0 HAPPINESS-BAR-HEIGHT "solid" HAPPINESS-BAR-LOW-COLOR)
                HAPPINESS-BG))

;; --- tests Done - 快乐指数条 ---


;; === 渲染受控动物信息 ===

;; String -> Image
;; 根据焦点键动态生成焦点提示文字
(define (focus-animal-status focus-key)
  (overlay
    (render-focus-msg focus-key)
    (rectangle FOCUS-MEASUREMENT-WIDTH HAPPINESS-BG-HEIGHT "solid" "transparent")))


(define (render-focus-msg focus-key)
  (cond
    [(string=? focus-key "k") (text "猫:受控" FOCUS-ANIMAL-SIZE FOCUS-ANIMAL-COLOR)]
    [(string=? focus-key "l") (text "变色龙:受控" FOCUS-ANIMAL-SIZE FOCUS-ANIMAL-COLOR)]
    [else empty-image]))

;; --- tests -render-focus-msg ---

;; 测试焦点键
(check-expect (render-focus-msg "k")
              (text "猫:受控" FOCUS-ANIMAL-SIZE FOCUS-ANIMAL-COLOR))

(check-expect (render-focus-msg "l")
              (text "变色龙:受控" FOCUS-ANIMAL-SIZE FOCUS-ANIMAL-COLOR))

;; 测非焦点键
(check-expect (render-focus-msg "x") empty-image)

;; --- tests Done -render-focus-msg ---


;; === 停止函数 ===

;; Zoo -> Boolean
;; 实时判断游戏是不是停止?
(define (game-over? state)
  (cond
    [(and
      (<= (limit-happiness (vcat-happiness (zoo-vcat state))) 0) 
      (<= (limit-happiness (vcham-happiness (zoo-vcham state))) 0))
     #true]
    [else #false]))

;; --- tests - 停止函数---
;; 两方皆停
(check-expect 
  (game-over? (make-zoo (make-vcat 30 0 "right") (make-vcham 60 0 "red") "k"))
  #true)

;; 一方停，另一方未停
(check-expect 
  (game-over? (make-zoo (make-vcat 30 70 "right") (make-vcham 60 80 "red") "k"))
  #false)

(check-expect 
  (game-over? (make-zoo (make-vcat 30 0 "right") (make-vcham 60 80 "red") "k"))
  #false)

(check-expect 
  (game-over? (make-zoo (make-vcat 30 90 "right") (make-vcham 60 0 "red") "l"))
  #false)

;; --- tests Done - 停止函数---


;; === 游戏停止后的图像 ===

;; Zoo -> Image
;; 游戏结束后，显示结束画面
(define (compose-end-scene state)
  (place-image
    END-MSG
    END-MSG-X
    END-MSG-Y
    SCENE))

;; --- tests ---

(check-expect 
  (compose-end-scene (make-zoo (make-vcat 30 0 "right") (make-vcham 60 0 "red") "k"))
  (place-image END-MSG END-MSG-X END-MSG-Y SCENE))

;; --- tests Done---


;; === 猫状态更新函数 ===

;; VCat -> VCat
;; 实时更新猫下一位置、快乐值、方向的状态
(define (update-vcat vcat-state)
  (make-vcat (vcat-next-x vcat-state)
             (vcat-next-happiness vcat-state)
             (vcat-next-direction vcat-state)))

;; --- tests-猫状态更新 ---
;; 向右行走的猫(该函数为组合函数，只需测试一个案例就可以了。)
(check-expect
  (update-vcat (make-vcat 120 85 "right"))
  (make-vcat (+ 120 CAT-MOVE-SPEED)
             (- 85 CAT-HAPPINESS-FALL-SPEED)
             "right"))

;; --- tests Done - 猫状态更新 ---


;; === 猫状态更新函数 - 辅助函数 ===

;; VCat -> Number
;; 实时计算猫下一帧x坐标
(define (vcat-next-x vcat-state)
  (cond
    [(string=? (vcat-direction vcat-state) "right") (+ (vcat-x vcat-state) CAT-MOVE-SPEED)]
    [(string=? (vcat-direction vcat-state) "left") (- (vcat-x vcat-state) CAT-MOVE-SPEED)]
    [else (vcat-x vcat-state)]))

;; --- tests - 猫下一帧 X ---
;; 向右走，下一帧 X 值
(check-expect
  (vcat-next-x (make-vcat 10 80 "right"))
  (+ 10 3))

;; 向左走，下一帧 x 值
(check-expect
  (vcat-next-x (make-vcat 10 80 "left"))
  (- 10 3))

;; else 语句
;; 防御语句，不必测试

;; --- tests Done - 猫下一帧 X ---


;; VCat -> Number
;; 实时计算猫下一帧快乐值
(define (vcat-next-happiness vcat-state)
  (limit-happiness (- (vcat-happiness vcat-state) CAT-HAPPINESS-FALL-SPEED)))

;; --- tests - 猫下一帧快乐值 ---
;; 输出合理下一帧快乐值
(check-expect
  (vcat-next-happiness (make-vcat 50 100 "right"))
  99.8)

;; --- tests Done - 猫下一帧快乐值 ---


;; VCat -> String
;; 实时判断猫下一帧方向
(define (vcat-next-direction vcat-state)
  (cond
     [(and (string=? (vcat-direction vcat-state) "right") (>= (vcat-x vcat-state) SCENE-WIDTH)) "left"]
     [(and (string=? (vcat-direction vcat-state) "left") (<= (vcat-x vcat-state) 0)) "right"]
     [else (vcat-direction vcat-state)]))

;; 方向不变，继续向右
(check-expect
  (vcat-next-direction (make-vcat 50 100 "right"))
  "right")

;; 转向(右-->左)
(check-expect
 (vcat-next-direction (make-vcat 700 100 "right"))
 "left")

;; 方向不变，继续向左
(check-expect
 (vcat-next-direction (make-vcat 50 100 "left"))
 "left")

;; 转向(左-->右)
(check-expect
 (vcat-next-direction (make-vcat 0 100 "left"))
 "right")

;; else 语句
;; 防御语句，不必测试


;; === 猫按键函数  ===

;; VCat KeyEvent -> VCat
;; 正确按键，返回计算后新值;
;; 无关按键，返回输入的值。
(define (handle-key-vcat vcat-state key)
  (cond
    ;; 按抚摸键(上箭头)
    [(key=? key "up") (make-vcat (vcat-x vcat-state) 
                                 (limit-happiness (+ (vcat-happiness vcat-state) CAT-PET-GAIN)) 
                                 (vcat-direction vcat-state))]

    ;; 按喂食键(下箭头)
    [(key=? key "down") (make-vcat (vcat-x vcat-state) 
                                   (limit-happiness (+ (vcat-happiness vcat-state) CAT-FEED-GAIN)) 
                                   (vcat-direction vcat-state))]

    ;; 按其他无关按键
    [else vcat-state]))

;; --- tests ---

;; 焦点在猫，按抚摸键(上箭头)，猫快乐指数增加 1/3
(check-expect 
  (handle-key-vcat (make-vcat 20 60 "right") "up")
  (make-vcat 20 (+ 60 1/3) "right"))

(check-expect 
  (handle-key-vcat (make-vcat 20 100 "right") "up")
  (make-vcat 20 100 "right"))


;; 焦点在猫，按喂食键(下箭头)，猫快乐指数增加 1/2
(check-expect 
  (handle-key-vcat (make-vcat 30 70 "right") "down")
  (make-vcat 30 (+ 70 1/2) "right"))

(check-expect 
  (handle-key-vcat (make-vcat 30 100 "right") "down")
  (make-vcat 30 100 "right"))

;; 焦点在猫，非正规键，返回当前值
(check-expect 
  (handle-key-vcat (make-vcat 20 60 "right") "m")
  (make-vcat 20 60 "right"))

;; --- tests Done ---


;; === 变色龙状态更新函数  ===

;; VCham -> VCham
(define (update-vcham vcham-state)
  (make-vcham (vcham-next-x vcham-state)
              (vcham-next-happiness vcham-state)
              (vcham-color vcham-state)))


;; --- tests - 变色龙状态更新 ---
;; 向右行走的变色龙(该函数为组合函数，只需测试一个案例就可以了。)

(check-expect
  (update-vcham (make-vcham 20 70 "red"))
  (make-vcham 21 69.85 "red"))

;; --- tests Done - 变色龙状态更新 ---


;; === 变色龙状态更新函数 - 辅助函数 ===

;; VCham -> Number
;; 实时计算变色龙下一帧x坐标 
(define (vcham-next-x vcham-state)
  (modulo 
    (+ (vcham-x vcham-state) CHAM-MOVE-SPEED) SCENE-WIDTH))

;; --- tests - 下一帧x坐标 ---
;; x 值，顺原方向增加
(check-expect 
  (vcham-next-x (make-vcham 50 100 "red"))
  51)

;; x 值，顺原方向循环
(check-expect 
  (vcham-next-x (make-vcham 700 100 "red"))
  1)

;; --- tests Done - 下一帧x坐标 ---


;; VCham -> Number
;; 实时计算变色龙下一帧快乐值 
(define (vcham-next-happiness vcham-state)
  (limit-happiness (- (vcham-happiness vcham-state) CHAM-HAPPINESS-FALL-SPEED)))

;; --- tests - 下一帧快乐值 ---
(check-expect
  (vcham-next-happiness (make-vcham 20 80 "red"))
  79.85)

;; --- tests Done - 下一帧快乐值 ---


;; === 变色龙按键函数  ===
;; VCham KeyEvent -> VCham
;; 正确按键，返回计算后新值;
;; 无关按键，返回输入的值。
(define (handle-key-vcham vcham-state key)
  (cond
    [(key=? key "down") (make-vcham (vcham-x vcham-state)
                                    (limit-happiness (+ (vcham-happiness vcham-state) CHAM-FEED-GAIN))
                                    (vcham-color vcham-state))]
    [(key=? key "r") (make-vcham (vcham-x vcham-state) (vcham-happiness vcham-state) "red")]
    [(key=? key "g") (make-vcham (vcham-x vcham-state) (vcham-happiness vcham-state) "green")]
    [(key=? key "b") (make-vcham (vcham-x vcham-state) (vcham-happiness vcham-state) "blue")]
    [else vcham-state]))                                

;; --- tests -变色龙按键函数 ---

;; 按喂食键(下箭头)，变色龙快乐指数 +2
(check-expect
  (handle-key-vcham (make-vcham 60 70 "red") "down")
  (make-vcham 60 (+ 70 2) "red"))

(check-expect
  (handle-key-vcham (make-vcham 60 100 "red") "down")
  (make-vcham 60 100 "red"))

;; 按 r 键，变色龙变为红色
(check-expect
  (handle-key-vcham (make-vcham 60 70 "blue") "r")
  (make-vcham 60 70 "red"))

;; 按 g 键，变色龙变为绿色
(check-expect
  (handle-key-vcham (make-vcham 60 70 "red") "g")
  (make-vcham 60 70 "green"))

;; 按 b 键，变色龙变为蓝色
(check-expect
  (handle-key-vcham (make-vcham 60 70 "green") "b")
  (make-vcham 60 70 "blue"))

;; 按无关键，返回当前值
(check-expect
  (handle-key-vcham (make-vcham 60 70 "green") "x")
  (make-vcham 60 70 "green"))

;; --- tests Done -变色龙按键函数 ---


;; === 变色龙渲染函数  ===
;; VCham -> Image
(define (render-cham-img vcham-state)
  (overlay
    CHAM-IMG
    (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" (vcham-color vcham-state))))

;; --- tests -变色龙渲染函数 ---

;; 测试红色变色龙
(check-expect
  (render-cham-img (make-vcham 50 80 "red"))
  (overlay
    CHAM-IMG
    (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" "red")))

;; 测试绿色变色龙
(check-expect
  (render-cham-img (make-vcham 50 80 "green"))
  (overlay
    CHAM-IMG
    (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" "green")))

;; 测试蓝色变色龙
(check-expect
  (render-cham-img (make-vcham 50 80 "blue"))
  (overlay
    CHAM-IMG
    (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" "blue")))

;; --- tests Done -变色龙渲染函数 ---


;; === 程序启动 ===
(cham-and-cat (make-zoo (make-vcat 10 100 "right") (make-vcham 20 100 "red") "k"))