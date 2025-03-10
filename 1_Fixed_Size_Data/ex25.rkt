; 25

; 按照题目的代码，放入了一正方形图片，运行结果却是 tall，肯定有问题。

; github上有人这样子调节：
  (define (image-classify img)
    (cond
      [(= (image-height img) (image-width img)) "square"]
      [(>= (image-height img) (image-width img)) "tall"]
      [(<= (image-height img) (image-width img)) "wide"]))

; 确实是避开了这个问题，代码的顺序看来能影响最终的结果。

; 继续修改了一下：
  (define (image-classify img)
    (cond
      [(= (image-height img) (image-width img)) "square"]
      [(> (image-height img) (image-width img)) "tall"]  ;去掉了 = 
      [(< (image-height img) (image-width img)) "wide"])) ;去掉了 = 

  (image-classify img) ;插入对应的图片，试了一下，这样子，逻辑上更严谨一些。
