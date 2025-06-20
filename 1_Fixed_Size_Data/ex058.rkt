; ex058

; 计算不同价格的销售税 
; Price -> Number

(define LOW 0.05)
(define LUX 0.08)

(define (sales-tax p)
  (cond
    [(and (<= 0 p) (< p 1000)) 0]
    [(and (<= 1000 p) (< p 10000)) (* LOW p)]
    [(>= p 10000) (* LUX p)]))

(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000) (* LOW 1000))
(check-expect (sales-tax 1282) (* LOW 1282))
(check-expect (sales-tax 10000) (* LUX 10000))
(check-expect (sales-tax 12017) (* LUX 12017))