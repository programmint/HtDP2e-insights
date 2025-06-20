; ex030

; Constants
(define BASE-ATTENDES 120) ;基准人数
(define MARGINAL-ATTENDES 15) ;边际人数，指人数受价格影响，增加或减少的人数，这词汇来源于经济学

(define CURRENT-PRICE 5) ;定义当前票价
(define MARGINAL-PRICE 0.10) ;定义边际票价，1美元 = 100 美分，所以小数点后两位数字。

(define PRICE-SENSITIVITY (/ MARGINAL-ATTENDES MARGINAL-PRICE)) ;定义价格敏感度。

(define FIXED-COSTS 180) ;定义固定成本
(define MARGINAL-COST 0.04) ;定义边际成本，1美元 = 100 美分，所以小数点后两位数字。

; functions
(define (attendees ticket-price) ;定义到场人数
  (- BASE-ATTENDES (* (- ticket-price CURRENT-PRICE) PRICE-SENSITIVITY)))

(define (revenue ticket-price) ;定义收入
  (* ticket-price (attendees ticket-price)))

(define (cost ticket-price) ;定义成本
  (+ FIXED-COSTS (* MARGINAL-COST (attendees ticket-price))))

(define (profit ticket-price) ;定义利润（收入 - 成本）
  (- (revenue ticket-price)
    (cost ticket-price)))

;examples
(profit 1.0) ;511.2
(profit 2.0);937.2
(profit 3.0);1063.2 显然3美元是最佳价格
(profit 4.0);889.2
(profit 5.0);415.2

; difference
(define (attendees ticket-price) ;定义到场人数函数
  (- BASE-ATTENDES (* (- ticket-price CURRENT-PRICE) (/ MARGINAL-ATTENDES MARGINAL-PRICE))))

(define (attendees ticket-price) ;定义到场人数函数
  (- BASE-ATTENDES (* (- ticket-price CURRENT-PRICE) PRICE-SENSITIVITY)))

;对比发现，定义了价格敏感度常量，子函数更容易理解，居然还可以这样子使用。