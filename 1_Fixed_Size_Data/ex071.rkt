; ex071

; distances in terms of pixels:

(define HEIGHT 200)
(define MIDDLE (quotient HEIGHT 2))
(define WIDTH  400)
(define CENTER (quotient WIDTH 2))

(define-struct game [left-player right-player ball])

(define game0
    (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

(game-ball game0) 
; (make-posn 200 200)

(posn? (game-ball game0)) 
; #true

(game-left-player game0)
; 100


