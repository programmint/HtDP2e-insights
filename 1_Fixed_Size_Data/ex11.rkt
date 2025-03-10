; 11

(define (distance x y)
    (sqrt(+ (sqr x) (sqr y))))

(distance 3 4)
(distance 6 8)


; 需要记住函数定义方法

; 定义函数及变量，怎么样命名，颇有技巧。
; 所以 代码大全 2（纪念版） 第 11 章 《变量名称的威力》（The Power of Variable Names）专门讨论了这问题，可参考。
; Vscodium 或 vscode 有一插件 codelf ，可以从 github 上搜索对应的变量名，比对验证，以供参考。
; 选中函数名或变量名，右键单击，弹出菜单中选择 codelf 点击，自动打开浏览器，即可查看。