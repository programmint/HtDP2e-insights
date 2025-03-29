; 20

(define (string-delete str i)
  (string-append (substring str 0 i) (substring str (+ i 1))))

(string-delete "htdp2e" 3)

; 16 ~ 20 题,都是加深你对函数的理解