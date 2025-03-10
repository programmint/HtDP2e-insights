; 64
(define (manhattan-distance ap)
    (+ (posn-x ap) (posn-y ap)))

(manhattan-distance (make-posn 7 9))
16

; 结论
; 无论是那种策略都一致

