; ex073-074

; ====================
; 全局目的
; ====================

; 73 题创建更新器函数。
; 74 题设计一交互游戏，一红点移动，可以使用鼠标重置红点。
; 其实二者隶属一大的题目，所以代码放在一起了。
; 同时，增加了提示文案：游戏结束了。（新增这一条件，代码变复杂了）

; == 历史 == 
; 2025.3
; - 之前理解更新器函数的作用，有误，现在已经修正。
; - 请 Ai 给了一复杂函数，体会一下更新器。
; - 优化了数字的变量名。
; - 调整了鼠标事件的参数顺序。

; 2025.4
; - 依照先写主函数，再写辅函数的顺序，重新调整代码。

; ------------------------------代码部分 --------------------------------------------------------------

; ========
; 常量定义
; ========

; 运动场景
(define CANVAS-WIDTH 300)
(define CANVAS-HEIGHT 300)
(define MTS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))

; 停止文案图像
(define TEXT-FONT-SIZE 14)
(define STOP-MSG-X 150)
(define STOP-MSG-Y 150)
(define STOP-MSG 
  (place-image (text "程序已停止" TEXT-FONT-SIZE "red") STOP-MSG-X STOP-MSG-Y MTS))

; 红点图像
(define DOT-RADIUS 3)
(define DOT (circle DOT-RADIUS "solid" "red"))

; 红点运动宽度限制
(define MAX-DOT-X (- CANVAS-WIDTH DOT-RADIUS))  ; 红点运动最大宽度：297
(define STOP-X-THRESHOLD (+ 3 MAX-DOT-X)) ; 超出有效宽度 = 3 + 最大宽度
                                          ; 也即最大宽度基础之上，再经历一次时钟函数 

; =====================
; 主函数
; =====================
; main 主函数
; Posn -> Posn
(define (main p)
  (big-bang p
    [on-tick x+]
    [on-mouse reset-dot]
    [to-draw scene+dot]
    [stop-when end-condition?]))

; =====================
; 辅函数
; ===================== 

; -----------
; 时钟滴答函数
; -----------

; 时钟滴答一次，红点 x + 3，y 值不变
; Posn -> Posn
(define (x+ p)
  (posn-up-x p (+ (posn-x p) 3)))

; 更新器函数
; - 读入结构体 p，以及数字 n
; - 返回一新的结构体，类似 p，但结构体 x 的值是 n
; Posn Number -> Posn
(define (posn-up-x p n )
  (make-posn n (posn-y p)))

; 各自功能
; x+ 负责：计算新值（业务逻辑）
; posn-up-x 负责：结构更新（技术实现）
; 二者相互分离，各自承担单一任务，利于后期迭代代码。

; 这题目比较简单，引入更新器有点多余。题目的意图，是为了助你了解“更新器”这概念，留待以后复杂的程序用。
; 我请 Ai 补充了一案例，实际体会一下复杂代码是怎么样使用 “更新器"，见代码后面。

; -----------
; 鼠标事件函数
; -----------

; 鼠标点击，重置红点，其他鼠标事件保持原状
; poson number number mouseevent -> posn 
(define (reset-dot p x y me)
  (cond
    [(mouse=? "button-down" me) (make-posn x y)]
    [else p]))

; 验证按下鼠标
(check-expect
  (reset-dot (make-posn 10 20) 29 31 "button-down")
  (make-posn 29 31))

; 验证松开鼠标
(check-expect
  (reset-dot (make-posn 10 20) 29 31 "button-up")
  (make-posn 10 20))


  ; 注
  ; 什么是重置？题目并没有详细要求，从书中示例代码来看，重置即：鼠标点在那里，红点就出现在那里。

  ; 按下鼠标后，立即重置红点，不算太严谨
  ; 如果误触了鼠标左键，立即重置了红点。所以才说，按下鼠标左键，立即重置红点，并不严谨。

  ; 更为严谨的方式，按下鼠标，再松开鼠标，这时才重置红点。
  ; 但这样子，代码相对麻烦，而且这一点，也不是本题的重点，所以，还是采用书上的方法。

; -----------
; 渲染图像函数
; -----------
; 游戏核心逻辑
; 红点位于背景内，实时渲染，即：红点圆心所在位置 [0，MAX-DOT-X]，合理范围，即位于背景内
; 红点圆心位于 >= MAX-DOT-X，显示停止文案 
; 红点圆心 x 值 STOP-X-THRESHOLD > MAX-DOT-X + 3，也即 MAX-DOT-X 再需多一次时钟函数，则停止游戏

; 实时渲染游戏图像(红点+运动场景)
; posn -> image 
(define (scene+dot p)
  (cond
    [(about-to-stop? p) STOP-MSG]
    [else (place-dot p)]))

; 检验红点是否停止运动？
; posn -> boolean
(define (about-to-stop? p)
  (>= (posn-x p) MAX-DOT-X))

; 验证游戏图像
(check-expect (scene+dot (make-posn 30 20))
  (place-image DOT 30 20 MTS))

(check-expect (scene+dot (make-posn 0 0))
              (place-image DOT 0 0 MTS)) 

(check-expect (scene+dot (make-posn STOP-X-THRESHOLD 301))
              STOP-MSG)  


; 实时渲染红点图像
; posn -> image 
(define (place-dot p)
  (place-image DOT (posn-x p) (posn-y p) MTS))

; --------------
;程序停止函数
; --------------
; 验证程序是否停止？
; posn -> boolean 
(define (end-condition? p)
  (> (posn-x p) STOP-X-THRESHOLD))

  ; 显示提醒文案之后，停止函数才停止程序。

; 验证程序停止条件
(check-expect (end-condition? (make-posn 10 300)) #false)

; =====================
; 程序启动
; ===================== 
(main (make-posn 10 150 ))


; ================================= 复杂代码示例（from deepseek） =======================================

; 场景设定
; 我们设计一个游戏角色系统，包含以下属性：
(struct character (name   ; 字符串
                   hp     ; 生命值（数值）
                   pos    ; 位置（Posn）
                   level)) ; 等级（数值）

; 需要实现以下功能：
; 1、角色移动（修改位置）
; 2、角色升级（提升等级并回满生命）
; 3、角色受伤（减少生命值）

; 第一阶段：没有更新器的写法

; 1. 角色移动函数
(define (move-character c dx dy)
  (make-character (character-name c)
                  (character-hp c)
                  (make-posn (+ (posn-x (character-pos c)) dx)
                             (+ (posn-y (character-pos c)) dy))
                  (character-level c)))

; 2. 角色升级函数
(define (level-up c)
  (make-character (character-name c)
                  100 ; 回满生命
                  (character-pos c)
                  (+ (character-level c) 1)))

; 3. 角色受伤函数
(define (take-damage c damage)
  (make-character (character-name c)
                  (- (character-hp c) damage)
                  (character-pos c)
                  (character-level c)))

; 痛点分析：
; 每次修改字段都要重新构造完整结构
; 大量重复的 (character-xxx c) 选择器
; 若增加新字段（如 mana 魔法值），需修改所有函数

; 第二阶段：使用更新器模式

; 1. 定义原子更新器

; 更新生命值
(define (update-hp c new-hp)
  (make-character (character-name c)
                  new-hp
                  (character-pos c)
                  (character-level c)))

; 更新位置
(define (update-pos c new-pos)
  (make-character (character-name c)
                  (character-hp c)
                  new-pos
                  (character-level c)))

; 更新等级
(define (update-level c new-level)
  (make-character (character-name c)
                  (character-hp c)
                  (character-pos c)
                  new-level))

; 2. 重构业务函数

; 移动角色
(define (move-character c dx dy)
  (update-pos c 
              (make-posn (+ (posn-x (character-pos c)) dx)
                         (+ (posn-y (character-pos c)) dy))))

; 升级角色
(define (level-up c)
  (update-level (update-hp c 100) ; 链式调用更新器
                (+ (character-level c) 1)))

; 角色受伤
(define (take-damage c damage)
  (update-hp c (- (character-hp c) damage)))

; 威力展现时刻
; 假设现在要增加 mana 字段到角色结构：
(struct character (name hp pos level mana))

; 传统写法：修改所有函数
; 需要修改 move-character、level-up、take-damage 等所有函数，
; 在每个 make-character 调用中添加 (character-mana c)。

; 更新器模式：仅修改更新器
; 只需修改更新器定义
(define (update-hp c new-hp)
  (make-character (character-name c)
                  new-hp
                  (character-pos c)
                  (character-level c)
                  (character-mana c))) ; 新增字段
    
  ; update-pos 和 update-level 同理

; 所有业务函数（move-character 等）自动获得 mana 支持，无需修改！

; 实际效果对比

; 修改前角色结构：
(define hero (character "Arthur" 100 (make-posn 0 0) 1))

; 执行移动操作：
> (move-character hero 5 3)
(character "Arthur" 100 (make-posn 5 3) 1)

; 新增 mana 字段后：
(define hero (character "Arthur" 100 (make-posn 0 0) 1 50))

; 原有业务函数仍然可用：
> (move-character hero 5 3) ; 自动保留 mana=50
(character "Arthur" 100 (make-posn 5 3) 1 50)

; 关键收获
; 隔离变化：字段增减只需修改更新器，业务逻辑不变
; 组合威力：可通过链式调用组合更新器（如 level-up 同时修改 hp 和 level）
; 错误防御：更新器强制保留未修改字段，避免遗漏
; 这种模式在游戏开发、GUI 组件、业务系统等 包含大量复杂状态 的场景中尤为重要。你现在体验的正是工业级函数式编程的核心思想！