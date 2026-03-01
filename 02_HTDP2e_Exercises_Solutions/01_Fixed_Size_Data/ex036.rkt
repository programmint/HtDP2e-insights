; ex036

; image represents the number of pixels in a given image . 信息转为数据
; image -> number  函数签名
; counts the number of pixels in a given image 目的声明,第 1 点和第 3 点语意有重复
; (define (image-area img)) 函数头

; 注
; 这里的图片，可以直接插入一张图片，也可以生成一张图片，来使用
; 这里采取插入一副图片的方式

; 函数示例
; given: 
  ; image  是 (rectangle 20 40 "solid" "blue")
; expected: 
  ; 800

; 盘点（inventory）
; (define (sting-last str)
;            (... img ...))

(define (image-area img)
  (* (image-height img) (image-width img)))

(image-area (rectangle 20 40 "solid" "blue"))
