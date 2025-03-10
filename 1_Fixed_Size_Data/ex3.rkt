; 3

(define str "helloworld")
(define i 5)
(define begin (substring str 0 i))
(define end (substring str i))

(string-append begin "_" end)

; 需要去查 substring 的用法

; Drracket -> help -> help desk 中，查 substring
; 或 https://docs.racket-lang.org/reference/index.html 去查
; substring 的用法有好多，目前所学是初级，选 beginner
