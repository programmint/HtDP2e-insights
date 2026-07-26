#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


;;; ex132

;; 声明
;; 以下代码均为手写，没有使用 Ai 生成的代码。
;; 如果使用了 Ai 生成的代码，会详细注明。


(contains-flatt? (cons "Fagan"
  (cons "Findler"
    (cons "Fisler"
      (cons "Flanagan"
        (cons "Flatt"   ; <-- 出现了这个，代表一定是 #true
          (cons "Felleisen"
            (cons "Friedman" '()))))))))

;; 结果是 #true      