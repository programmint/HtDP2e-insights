; 49

(define y 100)
(- 200
    (cond
        [(> y 200) 0]
        [else y]))

; 求值结果：100

(define y 210)
(- 200
    (cond
        [(> y 200) 0]
        [else y]))

; 求值结果：200

; Before 
(define WIDTH  100)
(define HEIGHT  60)
(define MTSCN  (empty-scene WIDTH HEIGHT)) ; short for empty scene 
(define ROCKET )
(define ROCKET-CENTER-TO-TOP
    (- HEIGHT (/ (image-height ROCKET) 2)))

(define (create-rocket-scene.v5 h)
    (cond
        [(<= h ROCKET-CENTER-TO-TOP)
            (place-image ROCKET 50 h MTSCN)]
        [(> h ROCKET-CENTER-TO-TOP)
            (place-image ROCKET 50 ROCKET-CENTER-TO-TOP MTSCN)]))

; After
(define WIDTH  100)
(define HEIGHT  60)
(define MTSCN  (empty-scene WIDTH HEIGHT)) ; short for empty scene 
(define ROCKET )
(define ROCKET-CENTER-TO-TOP
    (- HEIGHT (/ (image-height ROCKET) 2)))

(define (create-rocket-scene.v5 h)
    (place-image ROCKET 50
        ( cond
            [(<= h ROCKET-CENTER-TO-TOP) h]
            [(> h ROCKET-CENTER-TO-TOP) ROCKET-CENTER-TO-TOP])
    MTSCN)

; 这个方法看起来更简洁


