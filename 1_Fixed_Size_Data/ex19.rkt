; 19

(define (string-insert str i)
  (string-append
    (substring str 0 i)
    "_"
    (substring str i)))

(string-insert "Htdp2e" 4)

; 考察 substring 用法
