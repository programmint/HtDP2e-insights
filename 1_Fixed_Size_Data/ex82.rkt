; 82

; 思考点
; 本题承接自 78 题，word 是结构体。
; 所以，82 题输入是结构体，输出必然是结构体。

; 之前犯了一错误，以为输出的是字符串。需求没有搞清楚，急于写代码。
; 之前的第 1 版代码写复杂了，现在优化为第 2 版。

; 第 2 版代码 -----------------------------------------------------------------------------------------

; 全局目的
; 比较两个单词（结构体），每个字母是否相同
; 单词由3个小写字母组成，字母"a"到"z"的 1 string 外加 #false 表示
; -比较规则
;  -- 相同位置字母相同 → 保留该字母
;  -- 不同 → 该字母替换为 #false


; word 是结构体
(define-struct word [1st 2nd 3rd])
;   (make-word string string string )
; 解释:由3个字母构成，小写字母（ ”a“ 至 ”z“ ）构成，每个字符串长度为1
; ex：(make-word "c" "a" "t")

; 辅函数
; 为主函数比较字母是否相同
; 相同，返回该字母
; 不相同，返回 #false
; 1string or #false -> 1string or #false
(define (compare-letter letter1 letter2)
    (cond
        [(equal? letter1 letter2) letter1]
        [else #false]))
    
    ; 测试辅函数
    (check-expect (compare-letter "a" "b") #false)
    (check-expect (compare-letter "a" "a") "a")

; 主函数
; 生成比较结果的结构体
; word word -> word 
(define (compare-word word1 word2)
    (make-word
        (compare-letter (word-1st word1)(word-1st word2))
        (compare-letter (word-2nd word1)(word-2nd word2))
        (compare-letter (word-3rd word1)(word-3rd word2))))

    ; 测试主函数
    (check-expect
        (compare-word (make-word "o" "n" "e") (make-word "t" "w" "o"))
        (make-word #false #false #false))

    (check-expect
        (compare-word (make-word "a" "r" "t") (make-word "a" "r" "t"))
        (make-word "a" "r" "t"))

    (check-expect
        (compare-word (make-word #false #false #false) (make-word #false #false #false))
        (make-word #false #false #false))