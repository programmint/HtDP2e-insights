; ex077

; 结构体定义，回看 5.4 节：定义结构体类型 (Defining Structure Types)

(define-struct time[hour minute second])
; A time is a structure
    ; (make-time Number Number Number)
    ; 解释:某一时间点，由小时，分钟，秒构成，24 小时制方式表示这一具体时间

; where:
; - hour is a Number in [0, 23]
; - minute is a Number in [0, 59]
; - second is a Number in [0, 59]

; 示例 (Examples):
(define example-time (make-time 14 30 15)) ; 下午2点30分15秒
(define another-time (make-time 0 0 0))    ; 表示午夜0点整
(define moring-time (make-time 09 0 0))    ; 表示上午9点整


