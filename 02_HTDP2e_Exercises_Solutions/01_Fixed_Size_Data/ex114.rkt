#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex114
;; 计算过程中产生的数据，该怎么样来检测，利用 check-with 

;; 我直接化用了 108 题为例，错误代码位于 118 行
;; 之所以用 108 题，是因为这一题是固定数据部分，真正的设计题。


;; --- 常量 ---

;; 背景
(define SCENE-WIDTH 80)
(define SCENE-HEIGHT 80)
(define SCENE (empty-scene SCENE-WIDTH SCENE-HEIGHT))

;; 设定频率
(define TICK-INTERVAL 1)

;; 红灯、绿灯
(define RED-LIGHT-IMG .)
(define GREEN-LIGHT-IMG. )
; 实际测试时,请替换为对应的图片 

;; 计时时间
(define WALK-PHASE-START 19) 
(define WALK-PHASE-END 10)

; LAST-SECONDS-BEGIN,LAST-SECONDS-END,我最开始的变量名,Ai 建议如此修改,比我的好。


(define COUNTDOWN-PHASE-START 9) 
(define COUNTDOWN-PHASE-END 0) 

; COUNTDOWN-SECONDS-BEGIN,COUNTDOWN-SECONDS-EDN, 我最开始的变量名,Ai 建议如此修改,比我的好。
; 业务阶段(Phase)来命名

;; 倒计时数字大小
(define COUNTDOWN-FONT-SIZE 36)

;; === LightState 数据定义 ===

;; LightState 是三者之一:
;; -- “red”:默认状态
;; -- Number:绿灯状态,绿灯持续状态[10,19],及倒计时的数字,[0,9]

;; 数据定义,为什么不用结构体?
;; 请参阅:01_My_HtDP2e_Thinking_Path > 01_The_Rational_Path > 019_[Arch]_结构体,为什么偏偏在 108 题失效了?.md

;; === 主程序 ===

;; LightState -> LightState
(define (pedestrian-traffic-light state)
  (cond
    [(valid-lightstate? state) (big-bang state
                                 [check-with valid-lightstate?]
                                 [on-tick update-state TICK-INTERVAL]
                                 [on-key handle-key]
                                 [on-draw render-traffic-light])]
    [else (error "LightState 要求输入正确的数据格式")]))

; 主函数,不必有测试函数


;; === 数据有效性检测函数 ===
;; Any -> Boolean
;; 默认输入必须是 “red”，数字只能从 19 开始
(define (valid-lightstate? state)
  (or (and (string? state) (string=? state "red"))
      (and (number? state) (<= 0 state 19))))

;; --- tests - 数据有效性 ---

;; 测试正确默认输入
(check-expect (valid-lightstate? "red") #true)

;; 测试错误默认输入
(check-expect (valid-lightstate? "well") #false)

;; 测试正确数字输入
(check-expect (valid-lightstate? 19) #true)
(check-expect (valid-lightstate? 0) #true)

;; 测试错误数字输入
(check-expect (valid-lightstate? 20) #false)

;; --- tests - Done - 数据有效性 ---


;; === 状态更新函数 ===
;; LightState -> LightState
;; 红灯状态,则一直保持。
(define (update-state state)
  (cond
    [(string? state) "red"]
    [(number? state) (update-timer state)]))

;; --- tests - 状态更新函数 ---

;; 测试红灯状态
(check-expect (update-state "red") "red")

;; 测试分发绿灯状态
(check-expect (update-state 16) 
              15)

;; --- tests Done- 状态更新函数 ---


;; === 计时器函数 ===
;; Number -> LightState
;; 绿灯状态,维持10秒钟,而后倒计时开始于 9 -> 0,小于 0,转为红灯状态
(define (update-timer state-number)
  (cond
    [(> state-number 0) (- state-number 1)]
    [(= state-number 0) #false]))  ; <--- 错误代码位于此

;; --- tests - 计时器函数 ---

;; 计时器由 19 开始,每秒减 1 
(check-expect (update-timer 19) 18)

;; 计时器处在 11 时,依然减 1 秒 
(check-expect (update-timer 11) 10)

;; 计时器减少至 9 时,依然减 1 秒
(check-expect (update-timer 9) 8)

;; 计时器小于 0 ,返回默认状态
(check-expect (update-timer 0) "red")

;; --- tests Done - 计时器函数 ---


;; === 按键函数 ===
;; LightState keyEvent -> LightState
;; 按下空格,红灯状态变为绿灯状态
(define (handle-key state key)
  (cond 
    ;; 合理按下空格键                 
    [(and (string? state) 
          (key=? key " ")) 
     19]

    ;; 其他时按键无效                    
    [else state]))

;; --- tests - 按键函数 ---

;; 状态是 “red” 时,按下空格键,状态变为 19
(check-expect (handle-key "red" " ") 19)

;; 状态是数字时,按下空格无效
(check-expect (handle-key 17 " ") 17)

;; --- tests Done - 按键函数 ---


;; === 渲染函数 ===
;; LightState -> Image
;; 实时渲染图片
(define (render-traffic-light state)
  (overlay
   (cond
     [(string? state) RED-LIGHT-IMG]
     [(number? state) (render-active-phase state)])
   SCENE))

;; --- tests - 渲染函数 ---

;; 测试文本状态分发
(check-expect (render-traffic-light "red")
              (overlay
               RED-LIGHT-IMG
               SCENE))

;; 测试数字状态分发
(check-expect (render-traffic-light 17)
              (overlay (render-active-phase 17) SCENE))

;; --- tests Done - 渲染函数 ---


;; Number -> Image
;; 渲染绿灯及倒计时图片
(define (render-active-phase state)
  (cond
    [(<= WALK-PHASE-END state WALK-PHASE-START) GREEN-LIGHT-IMG]
    [(<= COUNTDOWN-PHASE-END state COUNTDOWN-PHASE-START) 
     (text (number->string state) COUNTDOWN-FONT-SIZE (countdown-number-color state))]))

;; --- tests - 渲染绿灯及倒计时图片 ---

;; 测试渲染绿灯状态(开始)
(check-expect (render-active-phase 19) GREEN-LIGHT-IMG)

;; 测试渲染绿灯状态(完结时)
(check-expect (render-active-phase 10) GREEN-LIGHT-IMG)

;; 渲染渲染倒计时状态(开始)
(check-expect (render-active-phase 9) (text "9" COUNTDOWN-FONT-SIZE "orange"))

;; 渲染渲染倒计时状态(完结时)
(check-expect (render-active-phase 0) (text "0" COUNTDOWN-FONT-SIZE "green"))


;; --- tests Done - 渲染绿灯及倒计时图片 ---


;; Number -> String
;; 倒计时数字颜色,奇数桔色,偶数为绿色
(define (countdown-number-color state)
  (cond
    [(= (modulo state 2) 1)"orange"]
    [else "green"]))

;; --- tests 倒计时数字颜色 ---

;; 偶数为绿色 
(check-expect (countdown-number-color 18) "green")
(check-expect (countdown-number-color 0) "green")

;; 奇数为桔色 
(check-expect (countdown-number-color 17) "orange")

;; --- tests -Done - 倒计时数字颜色 ---


;; === 程序启动 ===
(pedestrian-traffic-light "red")


;; === 运行结果 ===

;; 倒计时为 0 时
;; DrRacket 提示：
;; 0 tests passed.check-with: update-state returned #false, which fails to pass check-with's valid-lightstate? test

;; 可以推测：

;; 第1
;; 这个提示，可以这样子理解：
;; check-with 发现了问题，update-state 函数返回了 #false，未能通过 valid-lightstate? 的安全检查！

;; 显然，check-with 也有问题，那就是到底是哪个函数粗错了，它不知道，还得自己去排查。
;; 但不管怎么样，输入值需要检测，函数的计算后结果，也需要检测。


;; 第2
;; 看 check-with 的位置，马上就知道，check-with 是运行在主函数里。
;; 毫无疑问，每次产生新状态，check-with 都会检测一次，其实是拉低了运行效率。


;; 第3
;; 如果检测每一个子函数，该怎么样处理？
;; check-with 其实做不到，它只能跑在子函数里。
;; 其实，每一个测试函数，都是在检测每一个子函数，输入值是什么，输出值是什么
;; 每一处测试案例，都需要认真对待


;; 第4
;; 检测输入值：谓词的作用
;; 检测函数计算后的结果，分为 2 种情况
;; -- 第 1 种：整体检测，也就是 check-with
;; -- 第 2 种：局部检测，单独检测每一函数的输出值，也就是 htdp2e 提倡的测试案例。测试函数的好处，不必添加额外的代码，挂在函数上，每一函数只专心完成自己的任务。

;; 注意，测试并不能替代谓词的作用，所以，输入值该怎么样检测，还得怎么样检测。