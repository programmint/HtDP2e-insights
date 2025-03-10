; Sample Question

;文中一示例题，作者悄无声息设下陷阱：

(and (or (= (string-length "hello world")
        (string->number "11"))
        (string=? "hello world" "good morning"))
    (>= (+ (string-length "hello world") 60) 80))

; string=? 什么意思？书里并没有明确讲，而是叫你去查;

本书一特色，逼你学会“自我探索”。

; DrRacket 中，点击 Help，再点击 Help desk，打开你的默认浏览器，输入并搜索 string=?，选择lang/htdp-beginner，然后点击
; string=?  的功能很简单，就是比较两个字符串，是不是完全一致。（注意，racket 区分大小写）















