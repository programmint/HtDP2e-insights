; ex009

; 用 cond 实现
(define in ... )
(cond
        [(string? in)(string-length in)]
        [(image? in)(* (image-width in)(image-height in))]
        [(number? in)
        (cond
                [(> in 1)(- in 1)]      
                [(= in 0) 0]
                [(< in 0) in])]

        [(boolean? in #true) 10]
        [(boolean? in #false) 20])