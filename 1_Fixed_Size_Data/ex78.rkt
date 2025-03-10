; 78

; 396 题位于 363 页

; 本题是一猜谜游戏，猜单词中的每一个字母
; 猜中，则显示该字母
; 没有猜中，则用 #false 代表
; 正是因为有了这两种状态，结构体定义，数据定义，都变得复杂了。
; 所以，这一题的复杂度，远远超过第 76 题

; 结论：结构体定义，特别是数据定义，根据实际需求而变，并非一成不变。


(define-struct word [first-letter second-letter last-letter])

; A letter is one of:
    ; --- 长度为 1 的字符串，表示小写字母（ ”a“ 至 ”z“ ） 
    ; ---  #false (Boolean)， 表示未被猜中的字母：即玩家还未猜到这个字母，字母未知

; A word is a structure.
; (make-word Letter Letter Letter)
; 解释
; 猜单词字母游戏，单词由3个字母组成，字母按顺序存储在 first-letter、second-letter 和 last-letter 中
; 每一字母定义参考 letter，要么是一小写字母（ ”a“ 至 ”z“），要么是 #false 
; #false 代表该该字母没有被猜中


；示例
; 示例 1、没有猜中单词字母
(define word1 (make-word #false #false #false))

; 示例 2: 猜到了第一个字母
(define word2 (make-word "c" #false #false))

; 示例 3: 猜到了整个单词
(define word3 (make-word "c" "a" "t"))


; ---------------------------------------------------------------------------------------------------------------
; 问了Ai 一个问题，这里的字段的具体解释，为什么不用 where？

; Ai 答复如下：

; 如果使用 where 的话，可能是这样：
(define-struct word [first-letter second-letter last-letter])

  ; where:
  ; - first-letter is a Letter
  ; - second-letter is a Letter
  ; - last-letter is a Letter
  ; A Letter is one of:
  ; - A 1-character string representing a lowercase letter ("a" to "z")
  ; - #false, representing an unknown (not yet guessed) letter

; 这段代码虽然没有错，但实际上会显得有些重复，因为你已经在 Letter 数据定义部分说明了字母的含义。
; 通常情况下，where 适用于需要进一步阐明字段含义的情况，例如结构体比较复杂，字段类型不够清晰或需要额外的约束时。

; 总结：

; 何时使用 where：如果结构体字段比较复杂，或者字段类型不直观，需要进一步解释，可以使用 where 来说明字段的意义。
; 比如，如果字段是嵌套结构体或复杂的类型，可以通过 where 进一步阐明。

; 何时不使用 where：如果字段的数据格式已经通过类型定义和注释清楚地表达了，那么就不需要额外使用 where。
; 过度使用 where 可能会导致代码冗余，降低可读性。

; 在这个题目中，结构体 word 的字段类型已经通过 Letter 定义得很清晰，所以不需要使用 where 来重复描述。
; 注释已经足够，代码也保持了简洁性。
