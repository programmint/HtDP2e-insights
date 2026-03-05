#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

;;; ex106

;; |------------------------------------------
;; | [需求提纲]
;; |------------------------------------------
;; | [全局目的]
;; | 设计 cat-cham 程序,输入一位置和一动物,然后穿过画布,注意各自的规则。
;; |
;; | [注]:
;; | 本题中文版翻译有严重失误,详见:[6.6 - 一只动物吗?] 
;; | 链接:https://github.com/programmint/HtDP2e-insights/blob/main/03_Archive_Translation_Notes/%E7%AC%AC6%E7%AB%A0-%E6%96%87%E5%8F%A5%E6%A0%A1%E5%AF%B9%E5%BD%95/6.6-P119-%E4%B8%80%E5%8F%AA%E5%8A%A8%E7%89%A9%E5%90%97.md      
;; | 106 题与 107 题,两结构体合一,条件略繁,难度则未胜之前。
;; |
;; |------------------------------------------


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; 术语
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; - h-val: happiness-value (快乐指数数值)
;; - IMG / img : image (图片)
;; - MSG : message (信息)
;; - POS: position (位置)


;; ===========================================
;; 常量定义
;; ===========================================

;; ------------------------------------------
;; 游戏场景图像

(define SCENE-WIDTH 300)
(define SCENE-HEIGHT 300) ; 场景唯一高(多处用)
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

;; 游戏结束提示文案及位置坐标
(define END-MSG
  (text "游戏已结束" 16 "red"))

(define END-MSG-X 155)
(define END-MSG-Y 20)

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
(define CAT-Y-POS 
  (- SCENE-HEIGHT (/ (image-height CAT-IMG) 2) PADDING-BOTTOM))

;; 变色龙位于背景 y 值
(define CHAM-Y-POS 
  (- SCENE-HEIGHT (/ (image-height CHAM-IMG) 2) PADDING-BOTTOM))

;; 猫移动速度
(define CAT-MOVE-SPEED 3)

;; 变色龙移动速度
(define CHAM-MOVE-SPEED 1)

;; 快乐指数下降速度
(define HAPPINESS-FALL-SPEED 0.5)

;; 喂食猫收益比例
(define CAT-FEED-GAIN 1/5)

;; 抚摸猫收益比例
(define CAT-PET-GAIN 1/3)

;; 喂食变色龙收益
(define CHAM-FEED-GAIN 2)


;; ===========================================
;; VCat 数据定义
;; ===========================================

;; VCat 是结构体,表示猫的 3 个状态
(define-struct vcat [x happiness direction])
;; 一个 VCat 是 (make-vcat number number direction)
;; 解释
;; - x: 猫在背景内的 x 坐标
;; - 注:猫的 y 坐标恒定为常量,本题中恒定不变
;; - happiness: 猫的快乐指数 [0-100]
;; - direction:猫运动的方向,"right" 或 "left"

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

;; VCham 是结构体,表示变色龙的 3 个状态
(define-struct vcham [x happiness color])
;; 一个 VCham 是 (make-vcham number number string)
;; 解释
;; - x:变色龙在画布中的 x 坐标
;; - 注:变色龙的 y 坐标恒定为常量,本题中恒定不变
;; - happiness:变色龙的快乐值的具体数据 [0,100]
;; - color:变色龙的具体色彩,分为:"red","green","blue"

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

;; VAnimal是两者之一:
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
    [stop-when game-over? dispatch-end-scene]))

;; ...........................................
;; 测试 VAnimal 主程序

;; Big-bang 启动的是交互世界,而非计算数值。
;; 故不可测,只能看是不是能跑通。 

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
;; 状态更新函数是分发函数,负责审核传入的数据格式是否正确,审核能否正确调用子函数。
;; 因此,仅仅是测试上述项,就足够了。
;; 状态更新函数,按键函数,渲染函数,均是如此。

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

;; 依据按键,控制猫或变色龙的行为及快乐指数
;; WorldState KyeEvent -> WorldState
(define (dispatch-key state key)
  (cond
    [(vcat? state) (handle-key-vcat state key)]
    [(vcham? state) (handle-key-vcham state key)]
    [else "请输入正确的数据格式"]))

;; ...........................................
;; 测试按键函数

(check-expect
 (dispatch-key (make-vcat 10 100 "right") "up")
 (handle-key-vcat (make-vcat 10 100 "right") "up"))

(check-expect
 (dispatch-key (make-vcham 100 80 "red") "r")
 (handle-key-vcham (make-vcham 100 80 "red") "r"))

(check-expect
 (dispatch-key "hello_HTDP2e" "a")
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
 (render-vcat (make-vcat 10 100 "right")))

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
    [(and (vcat? state) (<= (limit-happiness (vcat-happiness state)) 0)) #true]
    [(and (vcham? state) (<= (limit-happiness (vcham-happiness state)) 0)) #true]
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
;; 游戏停止后的图像
;; ===========================================

;; 游戏停止后,额外显示最后一帧图像
;; 快乐指数为0,游戏停止
;; VAnimal -> Image 
(define (dispatch-end-scene state)
  (cond
    [(vcat? state) (end-scene-vcat state)]
    [(vcham? state) (end-scene-vcham state)]
    [else (error "end-scene: unknown animal state")]))

;; ...........................................
;; 测试游戏停止后图像

(check-expect 
 (dispatch-end-scene (make-vcat 20 0 "right"))
 (end-scene-vcat (make-vcat 20 0 "right")))

(check-expect 
 (dispatch-end-scene (make-vcham 20 0 "red"))
 (end-scene-vcham (make-vcham 20 0 "red")))

(check-error
 (dispatch-end-scene "hello")
 "end-scene: unknown animal state")

;; End of Tests ..............................


;; ===========================================
;; 猫状态更新函数
;; ===========================================

;; 注
;; 猫来回折返时,猫会“穿墙”,即猫图片中心点到达边界才转向。
;; 算是视觉瑕疵,但不影响核心逻辑,所以没有进一步修改。
;; 本题的意图,是考察不同类型的数据怎么样联合,不是考验视觉完美。

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
   (limit-happiness (- (vcat-happiness state) HAPPINESS-FALL-SPEED))
   
   ;; 更新 direction 的数值
   (cond
     [(and (string=? (vcat-direction state) "right") (>= (vcat-x state) SCENE-WIDTH)) "left"]
     [(and (string=? (vcat-direction state) "left") (<= (vcat-x state) 0)) "right"]
     [else (vcat-direction state)])))

;; ...........................................
;; 测试猫状态更新函数

;; 1、正常行走
;; 继续向右走,x 与 happiness 值均变化
(check-expect
 (update-vcat (make-vcat 50 100 "right"))
 (make-vcat (+ 50 3) 99.5 "right")) 

;; 继续向左走,x 与 happiness 值均变化
(check-expect
 (update-vcat (make-vcat 50 100 "left"))
 (make-vcat (- 50 3) 99.5 "left"))

;; 2、行走转向
;; 至右边界,转左行走
(check-expect
 (update-vcat (make-vcat 300 100 "right"))
 (make-vcat (+ 300 3) 99.5 "left"))  

;; 至左边界,转右行走
(check-expect
 (update-vcat (make-vcat 0 100 "left"))
 (make-vcat (- 0 3) 99.5 "right")) 

;; 3、快乐值已经为零,仍为零
(check-expect
 (update-vcat (make-vcat 50 0 "right"))
 (make-vcat (+ 50 3) 0 "right"))

;; 4、快乐值小于零时
(check-expect
 (update-vcat (make-vcat 50 0.1 "right"))
 (make-vcat (+ 50 3) 0 "right"))

;; End of Tests ..............................


;; ===========================================
;; 猫按键函数
;; ===========================================

;; 根据按键,控制猫的快乐指数高度 
;; 快乐指数的变化值,采用第 47 题的设定
;; VCat Key -> VCat
(define (handle-key-vcat state key)
  (cond
    ;;抚摸猫    
    [(key=? key "up") (make-vcat (vcat-x state)
                                 (limit-happiness (* (vcat-happiness state) (+ 1 CAT-PET-GAIN)))
                                 (vcat-direction state))]

    ;;喂食猫    
    [(key=? key "down") (make-vcat (vcat-x state)
                                   (limit-happiness (* (vcat-happiness state) (+ 1 CAT-FEED-GAIN)))
                                   (vcat-direction state))]

    [else state]))

;; ...........................................
;; 测试猫按键函数
;; 注,测试猫按键函数时,对应的 x 值、direction 值不在测试之列

;; 1、测试 "up" 键  (快乐增加 1/3)
;; 正常增加
(check-expect
 (handle-key-vcat (make-vcat 10 90 "right") "up")
 (make-vcat 10 100 "right")) 

;; 封顶测试 (边界)
(check-expect
 (handle-key-vcat (make-vcat 10 99 "right") "up")
 (make-vcat 10 100 "right"))

;; 2、测试 "down" 键 (快乐增加 1/5)
(check-expect
 (handle-key-vcat (make-vcat 10 10 "right") "down")
 (make-vcat 10 12 "right"))

;; 3、忽略无关按键 (保持原样)
(check-expect
 (handle-key-vcat (make-vcat 10 50 "left") "left") 
 (make-vcat 10 50 "left"))

(check-expect
 (handle-key-vcat (make-vcat 10 50 "left") "a") 
 (make-vcat 10 50 "left"))

;; End of Tests ..............................


;; ===========================================
;; 渲染猫整体图像函数
;; ===========================================

;; 依据条件,实时渲染猫(行走+开心指数)图像
;; Image VCat -> Image 
(define (render-vcat state)
  (beside/align "bottom"
                (render-happiness-bar (vcat-happiness state))
                (render-cat (vcat-x state)))) 

;; ...........................................
;; 测试猫+快乐指数渲染函数

;; 注:
;; render-vcat 函数是组合函数,主要功能是把两个子函数拼接在一起。
;; 是以,测试用例能证明拼接成功就可以了,不必追求测试案例全面。

;; 猫向右,向左移动,都可以渲染图像
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
;; 猫行走图像
;; ===========================================

;; 依据条件,实时渲染猫行走图像
;; Number -> Image 
(define (render-cat cat-x)
  (place-image
   ;; 猫图像  
   CAT-IMG

   ;; x 值
   cat-x 

   ;; y 值
   CAT-Y-POS

   ;; 运动背景
   SCENE))

;; ...........................................
;; 测试猫行走渲染函数

(check-expect
 (render-cat 20)
 (place-image CAT-IMG 20 CAT-Y-POS SCENE))

;; End of Tests ..............................


;; ===========================================
;; 猫停止行走后的图像
;; ===========================================

;; 猫运动停止后,额外显示最后一帧图像
;; VCat -> Image 
(define (end-scene-vcat state)
  (place-image
   END-MSG
   END-MSG-X END-MSG-Y
   (render-vcat state)))

;; ...........................................
;; 测试猫停止行走

(check-expect 
 (end-scene-vcat (make-vcat 20 0 "right"))
 (place-image
  END-MSG
  END-MSG-X END-MSG-Y
  (render-vcat (make-vcat 20 0 "right"))))

;; End of Tests ..............................


;; ===========================================
;; 变色龙状态更新函数
;; ===========================================

;; 实时更新变色龙的状态
;; VCham -> VCham
(define (update-vcham state)
  (make-vcham
   ;; 更新 x 的数值(向右移动)
   (modulo (+ (vcham-x state) CHAM-MOVE-SPEED) SCENE-WIDTH)

   ;; 更新 happiness 的数值
   (limit-happiness (- (vcham-happiness state) HAPPINESS-FALL-SPEED))

   ;; 更新 color 的数值
   (vcham-color state)))

;; ...........................................
;; 测试变色龙状态更新函数

;; 1、正常行走
;; 向右走,x 与 happiness 值均变化
(check-expect
 (update-vcham (make-vcham 50 100 "red"))
 (make-vcham 51 99.5 "red")) 

;; 2、循环行走,从左向右
;; 至左边界,循环回左侧
(check-expect
 (update-vcham (make-vcham 300 100 "green"))
 (make-vcham 1 99.5 "green")) 

;; 3、快乐值已经为零,仍为零
(check-expect
 (update-vcham (make-vcham 50 0 "blue"))
 (make-vcham 51 0 "blue"))

;; 4、快乐值小于零时
(check-expect
 (update-vcham (make-vcham 50 0.1 "red"))
 (make-vcham 51 0 "red"))

;; End of Tests ..............................


;; ===========================================
;; 变色龙按键函数
;; ===========================================

;; 根据不同按键,改变变色龙颜色、及喂食变色龙
;; VCham key -> VCham
(define (handle-key-vcham state key)
  (cond
    ;; 喂食变色龙    
    [(key=? key "down") (make-vcham (vcham-x state)
                                    (limit-happiness (+ (vcham-happiness state) CHAM-FEED-GAIN))
                                    (vcham-color state))]

    ;; 按 r 键    
    [(key=? key "r") (make-vcham (vcham-x state)
                                 (vcham-happiness state)
                                 "red")]

    ;; 按 g 键
    [(key=? key "g") (make-vcham (vcham-x state)
                                 (vcham-happiness state)
                                 "green")]

    ;; 按 b 键
    [(key=? key "b") (make-vcham (vcham-x state)
                                 (vcham-happiness state)
                                 "blue")]
    [else state]))

;; ...........................................
;; 测试变色龙按键函数
;; 注,测试变色龙按键函数时,对应的 x 值、color 值不在测试之列

;; 1、测试 "down" 键  (快乐增加 2)
;; 正常增加
(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "down")
 (make-vcham 10 82 "red")) 

;; 封顶测试 (边界)
(check-expect
 (handle-key-vcham (make-vcham 10 99 "red") "down")
 (make-vcham 10 100 "red")) 

;; 2、测试 "r" 键
(check-expect
 (handle-key-vcham (make-vcham 10 80 "green") "r")
 (make-vcham 10 80 "red")) 

;; 3、测试 "g" 键
(check-expect
 (handle-key-vcham (make-vcham 10 80 "blue") "g")
 (make-vcham 10 80 "green")) 

;; 4、测试 "b" 键
(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "b")
 (make-vcham 10 80 "blue"))

;; 5、忽略无关按键 (保持原样)
(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "up")
 (make-vcham 10 80 "red"))

(check-expect
 (handle-key-vcham (make-vcham 10 80 "red") "a")
 (make-vcham 10 80 "red"))

;; End of Tests ..............................


;; ===========================================
;; 渲染变色龙整体图像函数
;; ===========================================

;; 依据条件,实时渲染变色龙(行走+开心指数)图像
;; VCham -> Image 
(define (render-vcham state)
  (beside/align "bottom"
                (render-happiness-bar (vcham-happiness state))
                (render-cham (vcham-x state) (vcham-color state)))) 

;; ...........................................
;; 测试变色龙整体图像

;; 注:
;; render-vcham 函数是组合函数,主要功能是把两个子函数拼接在一起。
;; 是以,测试用例能证明拼接成功就可以了,不必追求测试案例全面。

(check-expect
 (render-vcham (make-vcham 10 100 "red")) 
 (beside/align "bottom"
               (render-happiness-bar 100)
               (render-cham 10 "red"))) 

;; End of Tests ..............................


;; ===========================================
;; 变色龙行走图像
;; ===========================================

;; 依据条件,实时渲染变色龙行走图像
;; Number  String -> Image 
(define (render-cham cham-x cham-color)
  (place-image
   ;; 变色龙图像  
   (overlay
    CHAM-IMG
    (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" cham-color))

   ;; x 值
   cham-x 

   ;; y 值
   CHAM-Y-POS

   ;; 运动背景
   SCENE))

;; ...........................................
;; 测试变色龙行走图像

(check-expect 
 (render-cham 20 "red")
 (place-image 
  (overlay
   CHAM-IMG
   (rectangle (image-width CHAM-IMG) (image-height CHAM-IMG) "solid" "red"))
  20
  CHAM-Y-POS
  SCENE))

;; End of Tests ..............................


;; ===========================================
;; 变色龙停止行走后的图像
;; ===========================================

;; 变色龙运动停止后,额外显示最后一帧图像
;; VCham -> Image 
(define (end-scene-vcham state)
  (place-image
   END-MSG
   END-MSG-X END-MSG-Y
   (render-vcham state)))

;; ...........................................
;; 测试变色龙停止行走的图像

(check-expect 
 (end-scene-vcham (make-vcham 20 0 "red"))
 (place-image
  END-MSG
  END-MSG-X END-MSG-Y
  (render-vcham (make-vcham 20 0 "red"))))

;; End of Tests ..............................


;; ===========================================
;; 通用辅助函数
;; ===========================================

;; --- 渲染快乐指数函数 ---
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

               HAPPINESS-PANEL))

;; 测试快乐指数等于 0
(check-expect (render-happiness-bar 0)
              (place-image
               (rectangle HAPPINESS-BAR-WIDTH
                          (* SCENE-HEIGHT (/ 0 100))
                          "solid" "red")
   
               (/ HAPPINESS-PANEL-WIDTH 2)

               (- SCENE-HEIGHT (/ (* SCENE-HEIGHT (/ 0 100)) 2))

               HAPPINESS-PANEL))

;; End of Tests ..............................


;; --- 快乐指数数值函数 ---
;; 限制快乐指数值位于[0,100]
;; Number -> Number
(define (limit-happiness h-val)
  (min 100 (max 0 h-val)))

;; ...........................................
;; 测试快乐指数数值函数

(check-expect
 (limit-happiness 0) 0)

(check-expect
 (limit-happiness 100) 100)

(check-expect
 (limit-happiness -1) 0)

(check-expect
 (limit-happiness 120) 100)

;; End of Tests ..............................


;; ===========================================
;; 程序启动
;; ===========================================
(run-animal (make-vcat 20 100 "right"))

;; or
;; (run-animal (make-vcham 20 100 "red"))