; 67

(define SPEED 3)  ; 定义了常量速度是 3
(define-struct balld [location direction]) ; 定义了balld 结构体，location 表示距离顶部的距离，direction 表示向某个方向运动
(make-balld 10 "up") ; 距离顶部 10 像素，向上运动

(make-balld 20 "down")