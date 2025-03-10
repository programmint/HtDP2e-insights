; 70

(define-struct centry (name home office cell))
    ; (centry-name    (make-centry n0 h0 o0 c0)) == n0
    ; (centry-home    (make-centry n0 h0 o0 c0)) == h0
    ; (centry-office  (make-centry n0 h0 o0 c0)) == o0
    ; (centry-cell    (make-centry n0 h0 o0 c0)) == c0

(define-struct phone  (area number))
    ; (phone-area (make-phone a0 n0)) == a0
    ; (phone-number (make-phone a0 n0)) == n0

(define-struct centry (name home office cell))
(define-struct phone  (area number))

(phone-area
    (centry-office
        (make-centry "Shriram Fisler"
            (make-phone 207 "363-2421")
            (make-phone 101 "776-1099")
            (make-phone 208 "112-9981"))))


; 添加测试案例
(check-expect
    (phone-area
        (centry-office
            (make-centry "Shriram Fisler"
                (make-phone 207 "363-2421")
                (make-phone 101 "776-1099")
                (make-phone 208 "112-9981")))) 
    101)



