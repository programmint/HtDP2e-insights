# 前面问题，后面会有对应提示

## 1、P75页展示的代码

~~~
; WorldState -> Image
; adds a status line to the scene created by render  
    
(check-expect (render/status 42)
                (place-image (text "closing in" 11 "orange")
                            20 20
                            (render 42)))
    
(define (render/status y)
    (place-image
    (cond
        [(<= 0 y CLOSE)
        (text "descending" 11 "green")]
        [(and (< CLOSE y) (<= y HEIGHT))
        (text "closing in" 11 "orange")]
        [(> y HEIGHT)
        (text "landed" 11 "red")])
    20 20
    (render y)))

Figure 24: Rendering with a status line, revised

~~~   


## 2、暗暗回应 

这里的代码， 其实是回应 P59 第 39 题的解题思路。   

***本书特点之一，前面的问题，后面的章节会有提示。*** 


