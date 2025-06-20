; ex066

(define-struct movie [title producer year])
    ; title : string
    ; producer : string  
    ; year : string 
(make-movie "Inception" "Christopher Nolan" 2010)

(define-struct person [name hair eyes phone])
    ; name : string
    ; hair : string
    ; eyes : string
    ; phone : string
(make-person "Alice" "Brown" "Blue" "123-456-7890")

(define-struct pet [name number])
    ; name : string
    ; number : number
(make-pet "Buddy" 3)

(define-struct CD [artist title price])
    ; artist : string
    ; title : string
    ; price : string
(make-CD "The Beatles" "Abbey Road" 9.99)

(define-struct sweater [material size producer])
    ; material : string
    ; size : string
    ; producer : string
(make-sweater "Wool" "M" "Patagonia")

