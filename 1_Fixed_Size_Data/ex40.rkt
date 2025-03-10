; 40

; 时钟滴答一次，汽车移动 3 像素，从画布左侧算起，注意：使用 check-expect 引入错误,查看效果
; worldstae -> worldstae
; examples:
    ; given : 20 , expect:23
    ; given : 27 , expect:30
(define (tock cw)
    (+ cw 3))

(check-expect(tock 20) 23)
(check-expect(tock 27) 30)
(check-expect(tock 30) 36) ;错误的结果

; 仅以 Racket 的 check-expect 来看，似乎并不怎么“智能”。
; 其实程序 bug 多，不仅是代码质量问题，也是管理问题。