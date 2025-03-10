; 14

(define (string-last str)
    (substring str (- (string-length str ) 1 )))

(string-last "abc")

; 还是题目要求，非空字符串。