; 8

  (define (image-classify img)  
    (cond
      [(>= (image-height img) (image-width img)) "tall"]
      [(= (image-height img) (image-width img)) "square"]
      [(<= (image-height img) (image-width img)) "wide"]))

  (image-classify img) 

; 开篇中首次提到了cond 条件句：

(cond
  [ConditionExpression1 ResultExpression1]
  [ConditionExpression2 ResultExpression2]
  ...
  [ConditionExpressionN ResultExpressionN])

; ResultExpression 就是展示对应的表达式。
