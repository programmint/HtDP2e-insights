; ex081

; 思路
; 80 题是对 5.8 节内容的模仿
; 81 题则是考察运用

; 定义结构体
(define-struct time[hour minute second])
; A time is a structure
    ; (make-time Number Number Number)
    ; 解释:某一时间点，由小时，分钟，秒构成，24 小时制方式表示这一具体时间

    ; where:
    ; - hour is a Number in [0, 23]
    ; - minute is a Number in [0, 59]
    ; - second is a Number in [0, 59]

    ; 示例 (Examples):
    (define example-time (make-time 14 30 15)) ; 表示下午2点30分15秒
    (define another-time (make-time 0 0 0))    ; 表示午夜0点整
    (define moring-time (make-time 09 0 0))    ; 表示上午9点整

; 增加测试案例
(check-expect (time->seconds(make-time 12 30 2)) 45002) 
(check-expect (time->seconds(make-time 0 0 0)) 0)
(check-expect (time->seconds (make-time 23 59 59)) 86399)  ; 验证一天的最后一刻
(check-expect (time->seconds (make-time 1 0 0)) 3600) ; 验证 1 小时整

; 定义结构体类型的函数
(define (time->seconds a-time)
    (+
        (* 3600 (time-hour a-time))  ; 小时转为秒
        (* 60 (time-minute a-time))  ; 分钟转为秒
        (time-second a-time)))         ; 直接获取秒

(time->seconds (make-time 14 30 15))

