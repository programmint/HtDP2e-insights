; 5

(define (tree3 standard-height)
    (above
        (triangle standard-height "solid" "green")
        (rectangle (* standard-height (/ 1 4) ) (* standard-height (/ (sqrt 3) 3))"solid" "gray")))

(tree3 50) 

; 等边三角形为树冠
; 树干的比例，要固定下来，树冠与树干的比例关系是 √3 / 2 : √3 / 3
; 树干是矩形，宽 : 高 = 1 : 4 

; 注意审题，创建简单的船或树，重点是简单。







