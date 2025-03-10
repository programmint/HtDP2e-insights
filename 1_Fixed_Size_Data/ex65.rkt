; 65

(define-struct movie [title producer year])
; 构造函数 ( Constructor) : make-movie
; 选择函数 ( Selectors): title ,  producer  , year
; 谓词 ( Predicate) : movie?

(define-struct person [name hair eyes phone])
; 构造函数 ( Constructor)  make-person
; 选择函数 ( Selectors): name, hair, eyes, phone
; 谓词 ( Predicate) : person?

(define-struct pet [name number])
; 构造函数 ( Constructor)  make-pet
; 选择函数 ( Selectors): name , number
; 谓词 ( Predicate) : pet?

(define-struct CD [artist title price])
; 构造函数 ( Constructor)  make-CD
; 选择函数 ( Selectors): artist , title , price
; 谓词 ( Predicate) : CD?

(define-struct sweater [material size producer])
; 构造函数 ( Constructor)  make-sweater
; 选择函数 ( Selectors): material,  size , producer
; 谓词 ( Predicate) : sweater?