; ex012

(define (cvolume x)
    (expt x 3))

(cvolume 3)

; x 作为变量名，合适吗？
; 不合适，x 到底表示什么意思，不明确
; 搜索可知，边长的英文名是：edge length，所以变量名应是 edge-length，

; 修改如下
(define (cvolume edge-lenth)
    (expt edge-length 3))

(cvolume 3)

