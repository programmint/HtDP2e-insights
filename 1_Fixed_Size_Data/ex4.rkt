; 4

(define str "ABCDEFGHI") ; 用 ABCDEFGHI，便于核对答案
(define natural-number 8)
    (define str-length (string-length str)) 

(define (delete-letter natural-number) 
    (cond
        [(= natural-number 0)
        (string-append "输入的整数要小于或等于" (number->string(string-length str )))]

        [(<= natural-number str-length)
        (string-append (substring str 0 (- natural-number 1))(substring str natural-number ))]

        [(> natural-number (string-length str))
        (string-append "输入的整数要小于或等于" (number->string(string-length str )))]))

(delete-letter natural-number) 

; 参考思路
(define str "hello-world")
(define i 5)
(define (string-del str i)
    (string-append (substring str 0 i ) (substring str i+1)))
        
; 假如定义 i = 100 ，结果显然不合理。

; 思路
; 题目问：哪些 i 的值合法？判断 i 值是不是合理，才是题目的重点。
; i 的值，大于、小于、等于字符串的长度，才合理。
; substing 的字符串顺序从 0 开始，不是从 1 开始，这里注意。

; 上述思路依然有缺陷，输入了 0.5，程序会报错，不过，暂时不考虑这一步。

