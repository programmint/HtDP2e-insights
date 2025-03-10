; 22

  (define (distance-to-origin x y)
      (sqrt (+ (sqr x) (sqr y))))
    
  (distance-to-origin 3 4)
  ==; (sqrt (+ (* 3 3) (sqr y)))
  ==; (sqrt (+ 9 (sqr y)))
  ==; (sqrt (+ 9 (* 4 4)))
  ==; (sqrt (+ 9 16))
  ==; (sqrt 25)
  ==
  5

