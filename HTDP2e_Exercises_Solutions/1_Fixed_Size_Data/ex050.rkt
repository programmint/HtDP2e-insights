; ex050

; yields the next state given current states
; TrafficLight -> TrafficLight

(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")  ; 补增测试案例
(check-expect (traffic-light-next "yellow") "red")      ; 补增测试案例

(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))

; All 3 tests passed!


