; 85

; =============
; 全局目的
; =============

; 设计主函数 run，包含以下层面：
; - 启动交互式编辑器（来源 84 题）
; - 启动 to-draw 渲染功能（来源 83 题）
; - 启动 on-key 按键函数（来源 84 题）

; ------------------------------代码部分 --------------------------------------------------------------

; ==========================================
; 缩写说明
; - IMG: image（图片）
; ==========================================

; =============
; 常量定义
; =============

; 光标图像（红色竖线）
(define CURSOR-WIDTH 1)
(define CURSOR-HEIGHT 20)

(define CURSOR-IMG
  (rectangle CURSOR-WIDTH CURSOR-HEIGHT "solid" "red"))

; 编辑器场景
(define SCENE-WIDTH 200)
(define SCENE-HEIGHT 20)

(define SCENE
  (empty-scene SCENE-WIDTH SCENE-HEIGHT))

; 文本字号（单位：像素）
(define TEXT-SIZE 16)

; 文本颜色
(define CONTENT-COLOR "black")

; =============
; 结构体
; =============

; editor 是结构体，表示文本编辑器里的文字
(define-struct editor [pre post])
; 一个 editor 是：(make-editor String String)
; 解释：
; - pre  ：光标前文本（必须是字符串）
; - post ：光标后文本（必须是字符串）

; =====================
; 主函数
; =====================

; run 主函数
; string -> worldstate
(define (run pre)
  (big-bang (make-editor pre "")
   [on-key handle-key]
   [to-draw render]))

; 注意
; 主函数只是采用 editor 的 pre 字段，post 字段则没有采用。

; =====================
; 辅助函数
; =====================

; ========
; 按键函数
; ========

; 满足限定条件，按键函数返回新编辑器状态
; editor string -> editor
(define (handle-key state key)
  (cond
   [(and (single-char? key) (ignore-chars? key)) (insert-char state key)]
   [(and (key=? key "left") (can-move-left? state)) (move-cursor-left state)]
   [(and (key=? key "right") (can-move-right? state)) (move-cursor-right state)]
   [(and (key=? key "\b") (can-delete? state)) (delete-char-left state)]
   [else state]))

; 测试 handle-key 函数
(check-expect (handle-key (make-editor "learning " "HTDP2e") "a")
              (make-editor "learning a" "HTDP2e"))

(check-expect (handle-key (make-editor "learning " "HTDP2e") "left")
              (make-editor "learning" " HTDP2e"))

(check-expect (handle-key (make-editor "learning " "HTDP2e") "right")
              (make-editor "learning H" "TDP2e"))

(check-expect (handle-key (make-editor "learning " "HTDP2e") "\b")
              (make-editor "learning" "HTDP2e"))

(check-expect (handle-key (make-editor "" "HTDP2e") "\b")
              (make-editor "" "HTDP2e"))

(check-expect (handle-key (make-editor "learning " "") "right")
              (make-editor "learning " ""))

(check-expect (handle-key (make-editor "learning " "HTDP2e") "\t")
              (make-editor "learning " "HTDP2e"))

(check-expect (handle-key (make-editor "learning " "HTDP2e") "\r")
              (make-editor "learning " "HTDP2e"))

; ----------------
; 添加单个字符函数
; ----------------

; 按键是否为单字符？
; string -> boolean
(define (single-char? key)
  (= (string-length key) 1))

; 单击按键时，需忽略的字符？
; string -> boolean
(define (ignore-chars? key)
  (and
   (not (key=? key "\t"))
   (not (key=? key "\r"))
   (not (key=? key "\b"))))

; 增加单字符，位于光标前字符最后面
; editor string -> editor
(define (insert-char state key)
  (make-editor
   (string-append (editor-pre state) key)
   (editor-post state)))

; 测试 single-char? 函数
(check-expect (single-char? "a") #true)
(check-expect (single-char? "ab") #false)
(check-expect (single-char? "") #false)
(check-expect (single-char? "left") #false)

; 测试 ignore-chars? 函数
(check-expect (ignore-chars? "a") #true)
(check-expect (ignore-chars? "\t") #false)
(check-expect (ignore-chars? "\r") #false)
(check-expect (ignore-chars? "\b") #false)

; 测试 insert-char 函数
(check-expect (insert-char (make-editor "learning " "HTDP2e") "a")
              (make-editor "learning a" "HTDP2e"))

(check-expect (insert-char (make-editor "" "HTDP2e") "a")
              (make-editor "a" "HTDP2e"))
              
(check-expect (insert-char (make-editor "learning " "") "a")
              (make-editor "learning a" ""))

; ----------------
; 光标左移函数
; ----------------

; 光标是否可以左移？
; editor -> boolean
(define (can-move-left? state)
  (> (string-length (editor-pre state)) 0)) 

; 光标左移，返回新状态编辑器
; editor -> editor
(define (move-cursor-left state)
  (make-editor
   (pre-without-last state)
   (string-append (pre-last state) (editor-post state))))

; 光标前字符，移去最后一个字符，所剩字符
; editor -> string
(define (pre-without-last state)
  (substring (editor-pre state) 0 (- (string-length (editor-pre state)) 1)))

; 光标前字符的最后一个字符
; editor -> string
(define (pre-last state)
  (substring (editor-pre state) (- (string-length (editor-pre state)) 1)))

; 测试 move-cursor-left 函数
(check-expect (move-cursor-left (make-editor "learning " "HTDP2e"))
              (make-editor "learning" " HTDP2e"))

(check-expect (move-cursor-left (make-editor "a" ""))
              (make-editor "" "a"))

(check-expect (move-cursor-left (make-editor "a" "b"))
              (make-editor "" "ab"))

; 测试 pre-without-last 函数
(check-expect (pre-without-last (make-editor "learning " "HTDP2e")) "learning")
(check-expect (pre-without-last (make-editor "a" "")) "")
(check-expect (pre-without-last (make-editor "ab" "cd")) "a")

; 测试 pre-last 函数
(check-expect (pre-last (make-editor "learning " "HTDP2e")) " ")
(check-expect (pre-last (make-editor "a" "")) "a")
(check-expect (pre-last (make-editor "ab" "cd")) "b")

; ----------------
; 光标右移函数
; ----------------

; 光标是否可以右移？
; editor -> boolean
(define (can-move-right? state)
  (> (string-length (editor-post state)) 0))

; 光标右移，返回新状态编辑器
; editor -> editor
(define (move-cursor-right state)
  (make-editor
   (string-append (editor-pre state) (post-first state))
   (post-without-first state)))

; 光标后面字符，第一个字符
; editor -> string
(define (post-first state)
  (substring (editor-post state) 0 1))

; 光标后面字符，移走第一个字符，所剩字符
; editor -> string
(define (post-without-first state)
 (substring (editor-post state) 1 (string-length (editor-post state))))

; 测试 can-move-right? 函数
(check-expect (can-move-right? (make-editor "learning " "HTDP2e")) #true)
(check-expect (can-move-right? (make-editor "learning " "")) #false)
(check-expect (can-move-right? (make-editor "" "a")) #true)

; 测试 move-cursor-right 函数
(check-expect (move-cursor-right (make-editor "learning " "HTDP2e"))
              (make-editor "learning H" "TDP2e"))

(check-expect (move-cursor-right (make-editor "" "a"))
              (make-editor "a" ""))

(check-expect (move-cursor-right (make-editor "a" "b"))
              (make-editor "ab" ""))

; 测试 post-first 函数
(check-expect (post-first (make-editor "learning " "HTDP2e")) "H")
(check-expect (post-first (make-editor "" "a")) "a")
(check-expect (post-first (make-editor "ab" "cd")) "c")

; 测试 post-without-first 函数
(check-expect (post-without-first (make-editor "learning " "HTDP2e")) "TDP2e")
(check-expect (post-without-first (make-editor "" "a")) "")
(check-expect (post-without-first (make-editor "ab" "cd")) "d")

; ----------------
; 退格删除字符函数
; ----------------

; 是否可以删除字符？
; editor -> boolean
(define (can-delete? state)
  (> (string-length (editor-pre state)) 0))
  
; 删除光标前的一个字符
; editor -> editor
(define (delete-char-left state)
  (make-editor
   (pre-without-last state)
   (editor-post state)))

; 测试 can-delete? 函数
(check-expect (can-delete? (make-editor "learning " "HTDP2e")) #true)
(check-expect (can-delete? (make-editor "" "HTDP2e")) #false)
(check-expect (can-delete? (make-editor "a" "")) #true)

; 测试 delete-char-left 函数
(check-expect (delete-char-left (make-editor "learning " "HTDP2e"))
              (make-editor "learning" "HTDP2e"))

(check-expect (delete-char-left (make-editor "a" ""))
              (make-editor "" ""))

(check-expect (delete-char-left (make-editor "ab" "cd"))
              (make-editor "a" "cd"))

; ========
; 渲染函数
; ========

; 读入 editor，渲染为图像。
; - 光标置于 pre 与 post 之间
; editor -> image 

(define (render state)
  (overlay/align "left" "center"
                (beside
                 (text (editor-pre state) TEXT-SIZE CONTENT-COLOR)
                 CURSOR-IMG
                 (text (editor-post state) TEXT-SIZE CONTENT-COLOR))
                SCENE))


; =====================
; 程序启动
; ===================== 
(run "Learning")
