; ex063

(define (distance-to-0 ap)
    (sqrt
       ( + (sqr (posn-x ap))
            (sqr (posn-y ap)))))

(distance-to-0 (make-posn 3 4))
5

(distance-to-0 (make-posn 6 (* 2 4)))
10

(+ (distance-to-0 (make-posn 12 5)) 10)
23

