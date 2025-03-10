; 29

; Constants
(define BASE-ATTENDES 120) ;基准人数
(define MARGINAL-ATTENDES 15) ;边际人数，指人数受价格影响，增加或减少的人数，这词汇来源于经济学

(define CURRENT-PRICE 5) ;定义当前票价
(define MARGINAL-PRICE 0.10) ;定义边际票价，1美元 = 100 美分，所以小数点后两位数字

(define FIXED-COSTS 0) 
; 定义固定成本为 0 ，顺接上面的题目，保留了这个值，好处是不会改动下面的函数
; 糟糕的地方，就是莫名其妙多了一个毫无意义的变量。
; 这里倾向于保留这个变量，万一后面又有了变化，例如要增加固定成本呢

(define MARGINAL-COST 1.50)
;定义边际成本，1美元 = 100 美分，所以小数点后两位数字

; functions
(define (attendees ticket-price) ;定义到场人数
  (- BASE-ATTENDES (* (- ticket-price CURRENT-PRICE) (/ MARGINAL-ATTENDES MARGINAL-PRICE))))

(define (revenue ticket-price) ;定义收入
  (* ticket-price (attendees ticket-price)))

(define (cost ticket-price) ;定义成本
  (+ FIXED-COSTS (* MARGINAL-COST (attendees ticket-price))))

(define (profit ticket-price) ;定义利润（收入 - 成本）
  (- (revenue ticket-price)
    (cost ticket-price)))

; examples
(profit 3.0) ; 630
(profit 4.0) ; 675 ，4美元是最佳价格
(profit 5.0) ; 420