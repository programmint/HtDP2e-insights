; ex080

; 解题思路
; 1、创建结构体
; 2、创建另外的功能函数，引用该结构体

(define-struct movie [title director year])

; movie 类型函数模板
(define fn-for-movie a-movie)
    (... (movie-title a-movie)
        (movie-director a-movie)
        (movie-year a-movie)))

; 注：
    ; a-movie 传递的数据格式，就是 movie 格式，下同

(define-struct pet [name number])

; pet 类型的函数模板：
(define (fn-for-pet a-pet)
  (... (pet-name a-pet)      
       (pet-number a-pet)))  


(define-struct CD [artist title price])

; CD 类型的函数模板：
(define (fn-for-CD a-CD)
  (... (CD-artist a-CD) 
       (CD-title a-CD) 
       (CD-price a-CD)))

(define-struct sweater [material size color]) 

; sweater 类型的函数模板：
(define (fn-for-sweater a-sweater)
  (... (sweater-material a-sweater)
       (sweater-size a-sweater) 
       (sweater-color a-sweater))) 