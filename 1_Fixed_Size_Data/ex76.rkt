; 76

(define-struct movie [title producer year])
; A movie is a structure:
    ; (make-movie String String Number)
    ; or 
    ; (make-movie String String String)
; 解释：电影的标题，制片人，年份

; 示例：
(define inception (make-movie "Inception" "Christopher Nolan" 2010))
(define titanic (make-movie "Titanic" "James Cameron" "1997"))

    ; 注
    ; year 的数值类型，到底是 string or number，取决于实际需要
    ; 仅以这里的题目来说，string or number 都可以


(define-struct person [name hair eyes phone])
; A person is a structure:
;   (make-person String String String String)
; 解释：一个人，姓名，头发（颜色），眼睛（颜色），电话

; 示例：
(define alice (make-person "Alice" "blonde" "blue" "123-456-7890"))
(define bob (make-person "Bob" "brown" "green" "098-765-4321"))

    ; 注
    ; hair 和 eyes ，表意不算精准
    ; phone 应该是 string ，因为电话的数字，并不参与计算，而且电话中如果有国家代码，或者有分隔符，都是特殊符号，number 无法表述


(define-struct pet [name number])
; A pet is a structure:
;   (make-pet String String )
; 解释：宠物的名字，编号数字

(define rover (make-pet "Rover" "001"))
(define felix (make-pet "Felix" "002"))

    ; 注
    ; number 到底是什么类型数值，也要看实际需要


(define-struct CD [artist title price])
; A CD is a structure:
;   (make-CD String String String)
; 解释：CD的艺术家，标题，价格

(define thriller (make-CD "Michael Jackson" "Thriller" "15.99"))
(define darkside (make-CD "Pink Floyd" "The Dark Side of the Moon" "18.50"))

    ; 注
    ; price 到底是什么类型数值，也要看实际需要


(define-struct sweater [material size producer])
; A sweater is a structure:
;   (make-sweater String String String)
; 解释：毛衣的材料，大小，生产商

(define wool-sweater (make-sweater "wool" "M" "Nike"))
(define cotton-sweater (make-sweater "cotton" "L" "Adidas"))

; 注
; 添加实例，便于快速理解数据定义