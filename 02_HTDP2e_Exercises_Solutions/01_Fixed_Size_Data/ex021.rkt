; ex021

(define (ff a)
    (* 10 a))

(+ (ff 1)(ff 1))
== ;(+ (* 10 1)(ff 1))
== ;(+ 10 (ff 1))
== ;(+ 10 (* 10 1))
== ;(+ 10 10)
== 
20


; 注意在 Dracket 中用，不要在 Vscode or Vscodium 中用

