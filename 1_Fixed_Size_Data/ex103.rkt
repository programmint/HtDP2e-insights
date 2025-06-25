;;; ex103

;; 全局目的： 设计 fits 函数，判断笼子体积是否装下动物


;; TODO
;; fits? 函数有重复代码，后面回来解决


;;; ==========================================
;;; 术语
;;; ==========================================
;; - calc : calculate
;; - req : requirement
;; - vol : volume 


;;; ==========================================
;;; SPIDER 数据定义
;;; ==========================================

;; SPIDER 是结构体，表示蜘蛛剩余腿的数量，以及蜘蛛体积
(define-struct spider [remaining-legs space-req])
;; 一个 SPIDER 是 (make-spider number number)
;; 解释：
;;  - remaining-legs 是蜘蛛剩余腿的数量，单位条
;;  - space-req 是 蜘蛛所占空间大小，即蜘蛛的体积，单位是立方米

; 测试 SPIDER 
(check-expect (spider-remaining-legs (make-spider 8 0.2)) 8)
(check-expect (spider-space-req (make-spider 8 0.2)) 0.2)


;;; ==========================================
;;; ELEPHANT 数据定义
;;; ==========================================

;; ELEPHANT 是结构体，表示大象的体积
(define-struct elephant [space-req])
;; 一个 ELEPHANT 是 (make-elephant number)
;; 解释：
;;  - space-req 是大象所占空间大小，单位是立方米

; 测试 ELEPHANT
(check-expect (elephant-space-req (make-elephant 50)) 50)


;;; ==========================================
;;; BOA 数据定义
;;; ==========================================

;; BOA 是结构体，表示蟒蛇的长度和周长
(define-struct boa [length girth])
;; 一个 BOA 是 (make-boa number number)
;; 解释：
;;  - length 是蟒蛇的长度，单位米
;;  - girth 是蟒蛇的周长，单位是米

; 测试 BOA-CONSTRICTOR
(check-expect (boa-length (make-boa 3 0.1)) 3)
(check-expect (boa-girth (make-boa 3 0.1)) 0.1)


;;; ==========================================
;;; ARMADILLO 数据定义
;;; ==========================================

;; ARMADILLO 是结构体，表示犰狳长度和体积
(define-struct armadillo [length space-req])
;; 一个 ARMADILLO 是 (make-armadillo number number)
;; 解释：
;;  - length 是犰狳的身体长度，单位是米
;;  - space-req 是犰狳所占空间大小，即犰狳的体积，单位是立方米

; 测试 BOA-ARMADILLO
(check-expect (armadillo-length (make-armadillo 1.2 3)) 1.2)
(check-expect (armadillo-space-req (make-armadillo 1.2 3)) 3)


;;; ==========================================
;;; ANIMAL 数据定义
;;; ==========================================

;; ANIMAL 是下列之一
;; -- (make-spider number number)
;; -- (make-elephant number)
;; -- (make-boa number number)
;; -- (make-armadillo number number)


;;; ==========================================
;;; CAGE 数据定义
;;; ==========================================

;; CAGE 是结构体，表示笼子的体积
(define-struct cage [capacity])
;; 一个 CAGE 是 (make-cage number)
;; 解释：
;;  - number 是笼子的体积，单位是立方米

; 测试 CAGE 
(check-expect (cage-capacity (make-cage 10)) 10)


;;; ==========================================
;;; 主函数
;;; ==========================================

;; 判断笼子体积能否装下动物？
;; ANIMAL CAGE -> boolean
(define (fits? an-animal a-cage)
  (cond
    [(spider? an-animal) (>= (cage-capacity a-cage) (spider-space-req an-animal))]
    [(elephant? an-animal) (>= (cage-capacity a-cage) (elephant-space-req an-animal))]
    [(boa? an-animal) (>= (cage-capacity a-cage) (calc-boa-vol an-animal))]
    [(armadillo? an-animal) (>= (cage-capacity a-cage) (armadillo-space-req an-animal))]))

; 测试 (fits? an-animal a-cage)
(check-expect (fits? (make-spider 8 01) (make-cage 20)) #true)
(check-expect (fits? (make-spider 8 01) (make-cage 0.01)) #false)

(check-expect (fits? (make-elephant 30) (make-cage 50)) #true)
(check-expect (fits? (make-elephant 30) (make-cage 15)) #false)

(check-expect (fits? (make-boa 3 0.3) (make-cage 50)) #true)
(check-expect (fits? (make-boa 3 0.5) (make-cage 0.01)) #false)

(check-expect (fits? (make-armadillo 1.5 10) (make-cage 50)) #true)
(check-expect (fits? (make-armadillo 1.5 10) (make-cage 5)) #false)


;;; ==========================================
;;; 计算蟒蛇所占空间
;;; ==========================================

;; 根据蟒蛇长度和周长，计算出蟒蛇所占的体积
;; ANIMAL -> Number
(define (calc-boa-vol an-animal)
  (* (boa-length an-animal)
     (/ (sqr (boa-girth an-animal))
        (* 4 pi))))

; 测试 (calc-boa-vol an-animal)
(check-within (calc-boa-vol (make-boa 3 0.1)) 
              0.00239 0.00001)


;;; ===========================================
;;; 程序启动
;;; ===========================================

(fits? (make-spider 6 0.2) (make-cage 20))
