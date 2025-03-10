; 79

; 注
; 这一题目，等于带着你复习了一次第4章，区间，枚举和条目的内容


"white"
 "yellow"
 "orange"

; 注
这里的数据定义方式，是枚举


; Is it a good idea to use a field name that looks like the name of a predicate?
; 不是好主意，容易产生误解


(define-struct dog [owner name age happiness])
; A Dog is a structure:
;    (make-dog Person String PositiveInteger H)
; where
; --- owner 是结构体，代表狗的主人
; --- name 是 string，代表狗的名字
; --- age 是正整数，代表狗的年龄
; --- H 是 number，代表快乐值，范围是 [0 100]

; 示例
(make-dog someone "Buddy" 3 80)
; 解释：这里的狗的主人是 `someone`，狗的名字是 "Buddy"，年龄是 3，快乐值是 80。


; A Weapon is one of: 
; — #false
; — Posn
; interpretation  #false means the missile hasn't 
; been fired yet; a Posn means it is in flight

; 注
; 这里的数据组成方式，也是条目数据，将“结构体”数据和“布尔值”进行了结合。