; 17

(define (image-classify img)  
    (cond
      [(>= (image-height img) (image-width img)) "tall"]
      [(= (image-height img) (image-width img)) "square"]
      [(<= (image-height img) (image-width img)) "wide"]))

(image-classify img) 

; 考察 image-height 和 image-width , 以及 cond


