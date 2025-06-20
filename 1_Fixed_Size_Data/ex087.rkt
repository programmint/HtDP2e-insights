; ex087

; =============
; 全局目的
; =============
; 使用字符串和索引，建立单行编辑器。

; =============
; 该选择那种方案？
; =============
; 本小节，建立的单行编辑器，对于编辑器内的数据结构体，共有两种定义
; 第 1、所有的文本，以及光标位置索引（也就是 87 题采用的数据定义）
; 第 2、分为光标前文本，光标后文字（83 - 86 题采用这方法）

; 这两种方法，哪种更好一些？

; 构思第 87 题，已经察觉出：第 2 种定义法比较好。
; 因为使用第 1 种方法，需要时时刻刻更新索引的位置，不停检查索引边界，整体上要比前面的题目麻烦。

; ==========================================
; 缩写说明
; - IMG / img : image（图片）
; ==========================================

; =============
; 常量定义
; =============

; 文本字号
(define TEXT-SIZE 16)

; 文本色彩
(define CONTENT-COLOR "black")

; 光标（红色竖线）
(define CURSOR-WIDTH 1)
(define CURSOR-HEIGHT 20)
(define CURSOR-IMG
  (rectangle CURSOR-WIDTH CURSOR-HEIGHT "solid" "red"))

; 单行编辑器（宽高）
(define SCENE-WIDTH 200)
(define SCENE-HEIGHT 20)
(define SCENE
  (empty-scene SCENE-WIDTH SCENE-HEIGHT))

; =============
; 结构体
; =============

; 测试结构体 words
(check-expect (editor-words (make-editor "Learning HTDP2e" 5)) "Learning HTDP2e")
(check-expect (editor-words (make-editor "Learning HTDP2e" 0)) "Learning HTDP2e")

; 测试结构体 index
(check-expect (editor-index (make-editor "Learning HTDP2e" 1)) 1)
(check-expect (editor-index (make-editor "Learning HTDP2e" 0)) 0)

; EDITOR 是结构体，表示文本状态及文本左侧到光标之间的字符数
(define-struct editor [words index])
; 一个 EDITOR 是：(make-editor String Number)
; 解释：
; - words ：输入的文本（必须是字符串）
; - index ：输入的文本左侧到光标之间的字符数（必须是数字）

; =====================
; 主函数
; =====================
; editor -> editor
(define (run state)
  (big-bang state
   [on-key handle-key]
   [to-draw render]))

; --------------------
; 按键函数
; --------------------

; 满足限定条件，实时返回编辑器状态（光标前后字符串更新，索引更新）
; editor sting keyevent -> editor 
(define (handle-key state key)
  (cond
   [(and (valid-index? state) (single-char? key) (acceptable-char? key) (would-fit? state key)) 
    (insert-char state key)]

   [(and (valid-index? state) (key=? key "left") (can-move-left? state)) 
    (move-cursor-left state)]

   [(and (valid-index? state) (key=? key "right") (can-move-right? state)) 
    (move-cursor-right state)]

   [(and (valid-index? state) (key=? key "\b") (can-delete? state)) 
    (delete-char-left state)]

   [else state]))

; ~~~~~~~~~~~~~~~~~~
; 判断索引函数？
; ~~~~~~~~~~~~~~~~~~

; 测试索引是否有效？
(check-expect (valid-index? (make-editor "Learn HTDP2e" 100)) #false)
(check-expect (valid-index? (make-editor "Learn HTDP2e" 5)) #true)

; 判断输入或更新状态后的索引，是否有效？
; ediotr key -> boolean
(define (valid-index? state)
  (and 
   (>= (editor-index state) 0)
   (<= (editor-index state) (string-length (editor-words state)))))

; ~~~~~~~~~~~~~~~~~~
; 添加单个字符函数
; ~~~~~~~~~~~~~~~~~~

; 测试插入字符，单字符为真
(check-expect (single-char? "a") #true)

; 测试插入字符，单字符为假
(check-expect (single-char? "abc") #false)

; 按键是否为单字符？
; string -> boolean
(define (single-char? key)
  (= (string-length key) 1))

; 测试忽略字符，为假
(check-expect (acceptable-char? "m") #true)

; 测试忽略制表符键，为真
(check-expect (acceptable-char? "\t") #false)

; 测试忽略回车键，为真
(check-expect (acceptable-char? "\r") #false)

; 测试忽略退格键，为真
(check-expect (acceptable-char? "\b") #false)

; 单击按键时，需忽略的字符？
; string -> boolean
(define (acceptable-char? key)
  (and
   (not (key=? key "\t"))
   (not (key=? key "\r"))
   (not (key=? key "\b"))))

; 测试输入字符宽度是否超出编辑器宽度，为真
(check-expect (would-fit? (make-editor "Learn HTDP2e" 6) "a") #true)

; 测试输入字符宽度是否超出编辑器宽度，为假
(check-expect (would-fit? (make-editor "Learn HTDP2e" 6) "11111111111111111111111111111") #false)

; 判断插入字符后是否超出编辑器宽度？(文字+光标)
; editor string -> boolean
(define (would-fit? state key)
  (< (content-width state key) SCENE-WIDTH))

; 计算内容总宽度
; editor string -> number
(define (content-width state key)
  (+
   (image-width (text (editor-words state) TEXT-SIZE CONTENT-COLOR))
   (image-width (text key TEXT-SIZE CONTENT-COLOR))
   CURSOR-WIDTH))

; 测试插入单个字符
(check-expect 
  (insert-char (make-editor "Learn HTDP2e" 1) "A")
  (make-editor "LAearn HTDP2e" 2))

; 插入单字符，返回编辑器新状态
; editor string -> editor
(define (insert-char state key)
  (make-editor
   (string-append
    (substring (editor-words state) 0 (editor-index state))
    key
    (substring (editor-words state) (editor-index state)))
   (+ 1 (editor-index state))))

; ~~~~~~~~~~~~~~~~~~~~~~~
; 光标左移函数
; ~~~~~~~~~~~~~~~~~~~~~~~

; 测试光标可以左移
(check-expect
  (can-move-left? (make-editor "Learn HTDP2e" 6)) 
  #true)

; 测试光标不能左移
(check-expect 
  (can-move-left? (make-editor "Learn HTDP2e" 0)) 
  #false)

; 判断光标是否可以左移？
; editor -> boolean
(define (can-move-left? state)
  (> (editor-index state) 0))

; 测试光标左移后，更新的编辑器状态
(check-expect
  (move-cursor-left (make-editor "Learn HTDP2e" 6))
  (make-editor "Learn HTDP2e" 5))

; 光标左移，返回新状态编辑器
; editor -> editor
(define (move-cursor-left state)
  (make-editor
   (editor-words state)
   (- (editor-index state) 1)))

; ~~~~~~~~~~~~~~~~~~~~~~~
; 光标右移函数
; ~~~~~~~~~~~~~~~~~~~~~~~

; 测试光标可以右移
(check-expect
  (can-move-right? (make-editor "Learn HTDP2e" 6)) 
  #true)

; 测试光标不能右移
(check-expect 
  (can-move-left? (make-editor "Learn HTDP2e" 12)) 
  #true)

; 判断光标是否可以右移？
; editor -> boolean
(define (can-move-right? state)
  (< (editor-index state) (string-length (editor-words state))))

; 测试光标右后，更新状态后的编辑器
(check-expect
  (move-cursor-right (make-editor "Learn HTDP2e" 6))
  (make-editor "Learn HTDP2e" 7))

; 光标右移，返回新状态编辑器
; editor -> editor
(define (move-cursor-right state)
  (make-editor
   (editor-words state)
   (+ (editor-index state) 1)))

; ~~~~~~~~~~~~~~~~~~~~~~~
; 删除字符函数
; ~~~~~~~~~~~~~~~~~~~~~~~

; 测试删除光标前字符
(check-expect
  (can-delete? (make-editor "Learn HTDP2e" 6))
  #true)

; 测试不可以删除光标前字符
(check-expect
  (can-delete? (make-editor "Learn HTDP2e" 0))
  #false)

; 判断是否可以删除字符？
; editor -> boolean
(define (can-delete? state)
 (> (editor-index state) 0))

; 测试删除光标前一个字符
(check-expect
  (delete-char-left (make-editor "Learn HTDP2e" 7))
  (make-editor "Learn TDP2e" 6))

; 删除光标前的一个字符
; editor -> editor
(define (delete-char-left state)
  (make-editor 
   (string-append
    (substring
     (editor-words state) 0 ( - (editor-index state) 1))
    (substring
     (editor-words state) (editor-index state)))
   (- (editor-index state) 1)))


; ----------------------------------
; 渲染函数
; ----------------------------------

; 依据输入，渲染整体图像
; editor image  -> image 

(define (render state)
  (cond
   [(valid-index? state) (editor-img state)]
   [else "索引数字有误，请重新输入"]))

; ~~~~~~~~~~~~~~~~~~~~~~
; 渲染编辑器图片函数
; ~~~~~~~~~~~~~~~~~~~~~~
(define (editor-img state)
  (overlay/align "left" "center"
   (beside
    (text (substring (editor-words state) 0 (editor-index state)) TEXT-SIZE CONTENT-COLOR )
    CURSOR-IMG
    (text (substring (editor-words state) (editor-index state)) TEXT-SIZE CONTENT-COLOR))
   SCENE))

; =====================
; 程序启动
; ===================== 
(run (make-editor "Learning HTDP2e" 6))