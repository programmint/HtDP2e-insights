; 84

; =========
; 明辨题意
; =========

; 本题的各个要点，作者刻意拆开来，分别阐述。
; 相互之间的关系，需要你自己梳理，方能明辨题意。
; 这过程，实在像产品经理获取需求，整理，梳理，而后才能给出产品设计方案。

; 一、题目要求
; 第 1、增加单字符
; 主要目的：ed 结构体 pre 字段末尾，单击单字符按键，输入单个字符。
; 校对：单击按键，是否为单字符按键？
; 忽略：退格键（单个字符），左键（单个字符），右键（单个字符），这三个按键。

; 第 2、移动方向键，左右键
; 单按一次，光标向对应方向，移动一次。
; 校对：单击左键右键时，光标移动方向前面是否有字符？

; 第 3、单击退格按键
; 单击一次，删除 pre 字段左侧一个字符。
; 校对：左侧是否有字符。


; 二、难懂句
; 该函数只关注两种长于单个字母的 KeyEvent："left"和"right"。
; 这话令人费解。

; 单击键盘上的按键，不都是一个字符吗，为什么这里讲：left 和 right 是长于单字符？
; 回到 big-bang 函数中
; 左移动键，big-bang 中用 “left” 表示，每一个按键，其实就是一字符串，所以左移动键就是 “left” ，“left” 长度 > 1
; 向上的按键，用 “up” 表示，长度也是 > 1，依本题，这种按键忽略。
; 这话就是这意思。

; 另,函数签名时,按键都是用 string 来表示


; 三、主辅函数书写顺序
; 该题一主函数，多个辅函数组成，主辅函数，该先写哪个？
; 个人方式：先写主函数，后写辅函数。

; 先写主函数，假设辅函数已经存在，写下来。
; 后写辅函数。
; 主函数是扣住思路，防止函数的思路走歪了。
; 辅函数为主函数服务，有些辅函数，构思时，未必意识到有其存在，实际写代码时，方发现缺了部分辅函数。

; 反之，先写辅函数，没有主思路引导，有时确实会写歪了，有时则是完全无用。（别问我怎么知道的）

; 解该题，有些地方，耗费了好久时间纠缠。
; 详见：https://github.com/programmint/HtDP2e-insights/blob/main/Notes/%E8%A7%82%2084%20%E9%A2%98%EF%BC%8C%E9%9D%9E%E7%BA%A0%E7%BC%A0%E7%9A%84%E9%97%AE%E9%A2%98%20%E2%80%94%20%E5%87%BD%E6%95%B0%E6%8F%8F%E8%BF%B0%E5%90%8D%E3%80%81%E6%B3%A8%E9%87%8A%E8%AF%A6%E7%BB%86%E7%A8%8B%E5%BA%A6%E3%80%81%E5%8F%98%E9%87%8F%E5%90%8D%E7%9A%84%E8%AF%AD%E4%B9%89.md


; ====================
; 全局目的
; ====================
; 单行文本编辑器程序。使用 editor 结构体表示编辑器状态：
; - pre：光标左侧文本
; - post：光标右侧文本
; - 光标位置：位于 pre 和 post 之间

; 支持以下功能：
; 1. 光标位置输入单字符（忽略制表符和回车）
; 2. 使用左右方向键移动光标
; 3. 使用退格键删除光标前的字符

; =======
; 结构体
; =======

; editor 是编辑器结构体
(define-struct editor [pre post])
; editor 是 (make-editor String String)
; 解释
; - pre: 光标前的文字
; - post：光标后的文字

; 测试 editor 结构体选择函数
(check-expect (editor-pre (make-editor "learning " "HTDP2e")) "learning ")
(check-expect (editor-post (make-editor "learning " "HTDP2e")) "HTDP2e")


; =====================
; 主函数
; =====================

; 满足限定条件，按键函数返回新编辑器状态
; editor string -> editor
(define (handle-key state key)
  (cond
   [(and (single-char? key) (acceptable-char? key)) (insert-char state key)]
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

; =====================
; 辅助函数
; =====================
; ===============
; 添加单个字符函数
; ===============

; 按键是否为单字符？
; string -> boolean
(define (single-char? key)
  (= (string-length key) 1))

; 单击按键时，需忽略的字符？
; string -> boolean
(define (acceptable-char? key)
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

; 测试 acceptable-char? 函数
(check-expect (acceptable-char? "a") #true)
(check-expect (acceptable-char? "\t") #false)
(check-expect (acceptable-char? "\r") #false)
(check-expect (acceptable-char? "\b") #false)

; 测试 insert-char 函数
(check-expect (insert-char (make-editor "learning " "HTDP2e") "a")
              (make-editor "learning a" "HTDP2e"))
(check-expect (insert-char (make-editor "" "HTDP2e") "a")
              (make-editor "a" "HTDP2e"))
(check-expect (insert-char (make-editor "learning " "") "a")
              (make-editor "learning a" ""))


; =============
; 光标左移函数
; =============

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

; =============
; 光标右移函数
; =============

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


; ===============
; 退格删除字符函数
; ===============

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

; ===============
; 创建 20 个示例
; ===============

; 测试1：向空编辑器添加字符
(check-expect (handle-key (make-editor "" "") "a")
              (make-editor "a" ""))

; 测试2：向已有内容的编辑器添加字符
(check-expect (handle-key (make-editor "hello" "world") "a")
              (make-editor "helloa" "world"))

; 测试3：添加数字字符
(check-expect (handle-key (make-editor "test" "") "1")
              (make-editor "test1" ""))

; 测试4：添加空格
(check-expect (handle-key (make-editor "hello" "world") " ")
              (make-editor "hello " "world"))

; 测试5：添加特殊字符
(check-expect (handle-key (make-editor "test" "") "!")
              (make-editor "test!" ""))

; 测试6：光标左移 - 从中间位置
(check-expect (handle-key (make-editor "hel" "lo") "left")
              (make-editor "he" "llo"))

; 测试7：光标左移 - 从最左侧(无法左移)
(check-expect (handle-key (make-editor "" "hello") "left")
              (make-editor "" "hello"))

; 测试8：光标右移 - 从中间位置
(check-expect (handle-key (make-editor "hel" "lo") "right")
              (make-editor "hell" "o"))

; 测试9：光标右移 - 从最右侧(无法右移)
(check-expect (handle-key (make-editor "hello" "") "right")
              (make-editor "hello" ""))

; 测试10：删除字符 - 从中间位置
(check-expect (handle-key (make-editor "hel" "lo") "\b")
              (make-editor "he" "lo"))  ; 不是 (make-editor "he" "llo")

; 测试11：删除字符 - 从最左侧(无法删除)
(check-expect (handle-key (make-editor "" "hello") "\b")
              (make-editor "" "hello"))

; 测试12：忽略制表符
(check-expect (handle-key (make-editor "hello" "world") "\t")
              (make-editor "hello" "world"))

; 测试13：忽略回车符
(check-expect (handle-key (make-editor "hello" "world") "\r")
              (make-editor "hello" "world"))

; 测试14：忽略不支持的特殊键
(check-expect (handle-key (make-editor "hello" "world") "up")
              (make-editor "hello" "world"))

; 测试15：连续操作 - 添加字符后左移
(check-expect (handle-key 
               (handle-key (make-editor "he" "llo") "x") 
               "left")
              (make-editor "he" "xllo"))

; 测试16：连续操作 - 右移后删除
(check-expect (handle-key 
               (handle-key (make-editor "he" "llo") "right") 
               "\b")
              (make-editor "he" "lo"))

; 测试17：连续操作 - 左移后右移
(check-expect (handle-key 
               (handle-key (make-editor "hel" "lo") "left") 
               "right")
              (make-editor "hel" "lo"))

; 测试18：连续操作 - 添加多个字符
(check-expect (handle-key 
               (handle-key (make-editor "he" "llo") "x")
               "y")
              (make-editor "hexy" "llo"))

; 测试19：连续操作 - 删除后添加
(check-expect (handle-key 
               (handle-key (make-editor "hello" "") "\b")
               "x")
              (make-editor "hellx" ""))

; 测试20：复杂序列操作
(check-expect (handle-key 
               (handle-key 
                (handle-key 
                 (handle-key (make-editor "h" "ello") "right")
                 "x")
                "left")
               "\b")
              (make-editor "h" "xllo"))