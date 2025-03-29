; 19

(define (string-insert str i)
  (string-append
   (substring str 0 i)
   "_"
   (substring str i)))

(string-insert "LearningHtdp2e" 8)

; 考察 substring 用法
