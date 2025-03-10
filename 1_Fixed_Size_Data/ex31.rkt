; 31

(define (letter fst lst signature-name)
  (string-append
    (opening fst)
    "\n\n"
    (body fst lst)
    "\n\n"
    (closing signature-name)))
 
(define (opening fst)
  (string-append "Dear " fst ","))
 
(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", " "hurry and pick up your prize."))
 
(define (closing signature-name)
  (string-append
    "Sincerely,"
    "\n\n"
    signature-name
    "\n"))

(define (main in-fst in-lst in-signature out)
  (write-file out
              (letter (read-file in-fst)
                      (read-file in-lst)
                      (read-file in-signature))))

(write-file "in-first.dat" "Matt")
(write-file "in-last.dat" "Johnson")
(write-file "in-sig.dat" "Edward")

(main "in-first.dat" "in-last.dat" "in-sig.dat"  "letter.dat") 
(read-file "letter.dat")

; 解析
; 注意 out 这个参数，不必另行给定一个实际的参数， out 是 write-file 用后面 letter 函数创建的。


