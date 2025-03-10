; 82

; 解题
; 犯了一个错误，我以为输出的是字符串，其实输出的应该是结构体
; 题目中讲的是单词，这个单词的数据格式是什么？

; 第1、 这单词，其实由字符串和布尔值构成，所以，要么是条目，要么是结构体
; 第2、该题需要依据**字段名**来比较数据是否相同，既要根据位置，取出对应的比较对象，又要比较对应的语义，所以只能是结构体。

; 即：该题的输入和输出，都是结构体。

; -----------------------------------------------------------------------------------------------------------------------------------------------

; 定义输入结构体：给主函数输入数据
; 这里不必校验输入是否准确，因为第 75 题已经明确了是字符串
(define-struct input-word [1st-letter 2nd-letter 3rd-letter])

; word是结构体，由3个字母构成，小写字母（ ”a“ 至 ”z“ ）构成，每个字符串长度为1
; (make-input-word string string string)
; 示例
; (define a-word (make-input-word "a" "r" "t"))

; 定义输出结构体：主函数以该结构体格式，输出数据
(define-struct output-word [1st-letter 2nd-letter 3rd-letter])

; output-word 是结构体，由3个字母或 #false 构成，字母是小写字母（ ”a“ 至 ”z“ ）构成，每个字符串长度为1
; (make-output-word string string string)
; 示例
; (define a-word(make-output-word "a" "d" "d"))

; 定义字母比较函数：辅助函数，主函数用以比较2个字母是否相同
; 相同，返回该字母
; 不相同，则返回 #false
; string string -> string or boolean
(define (compare-letters 1st-letter 2nd-letter)
    (cond
        [(equal? 1st-letter 2nd-letter) 1st-letter]
        [else #false]))

; 测试字母比较函数
(check-expect (compare-letters "a" "b") #false)
(check-expect (compare-letters "a" "a") "a")

; 定义主函数 compare-word
; 读取 2 个输入结构体，比较，返回结构体
; 每一字段相同，则返回该结构体字段
; 不相同，返回的结构体字段中放入 #false 
; structure structure -> structure
(define (compare-word input-word1 input-word2 )
    (make-output-word
       (compare-letters (input-word-1st-letter input-word1) (input-word-1st-letter input-word2))
       (compare-letters (input-word-2nd-letter input-word1) (input-word-2nd-letter input-word2))
       (compare-letters (input-word-3rd-letter input-word1) (input-word-3rd-letter input-word2))))

; 测试主函数
(check-expect (compare-word (make-input-word "a" "r" "t")(make-input-word "a" "r" "t")) (make-output-word "a" "r" "t"))
(check-expect (compare-word (make-input-word "a" "d" "d")(make-input-word "a" "r" "t")) (make-output-word "a" #false #false))

(compare-word (make-input-word "a" "r" "t") (make-input-word "c" "a" "n"))
; 输出：(make-output-word #false #false #false)

(compare-word (make-input-word "a" "r" "t") (make-input-word "a" "r" "t"))
; 输出：(make-output-word  "a" "r" "t")