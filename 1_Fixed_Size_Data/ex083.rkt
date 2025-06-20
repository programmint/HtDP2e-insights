; ex083

; 历史
; 5.10 节 图形编辑器，这一小节的题目，其实都比较难，从一开我就读不懂这题目。
; 借 Ai 之辅助，才得以理解题意，再次感谢 Ai

; 83 - 87 题合在一起，才是图形编辑器。
; 也即，题目之间上下关联，若没意识到这点，你会比较困惑。
; 例如 86 题，或许你会诧异，为什么只讲 pre，那 post 不提了吗？你只需要回看 85 题，秒懂。


; 题意分析---------------------------------------------------------------------------------

; 整体题意解析
; 83 - 86 题的核心，在于：数据存储与视觉显示，相互分离。
; 意识到这点，这一系列题目也就简单了。

; 83 题：编辑器渲染为图像，也就是视觉显示。
; 84 题：设计输入函数。
; 85 题：启动交互编辑器，这时，数据存储和视觉渲染，合为一体。
; 86 题：文本超出了编辑器范围，处理这一情况。
; 87 题：结构体的数据定义，发生了变化，但整体的题意依旧不变。


; 83 题分析
; 83 题重在视觉渲染效果，所以这题也最简单。
; 85 题，又会用到 83 题。

; 注意
; 题目是说使用 16 号字符串，可是示例代码中，又使用了 11 号字体。
; 估计是更新内容时，示例代码处忘了更新，所以，凡是涉及到字体大小，一律 16 号。

; ----------
; 思路订正
; ----------

; 问 ？
; 为什么必须得使用结构体，使用字符串不可以吗？

; 答：
; 因为题目有了明确暗示，使用结构体。
; Editor 就是这个明确暗示。
; htdp2e 中文版，P105 页，以 r3 与 R3 的方式，暗示了这里的用法。 
; 详见：https://github.com/programmint/HtDP2e-insights/blob/main/Notes/htdp2e%20%E5%AD%A6%E4%B9%A0%E9%9A%8F%E8%AE%B0%20-%20%E7%96%91%E9%97%AE%E9%87%8D%E7%82%B9%E5%BF%83%E5%BE%97-%E5%90%88%E9%9B%86.md#58%E7%BB%93%E6%9E%84%E4%BD%93%E7%9A%84%E8%AE%BE%E8%AE%A1designing-with-structures

; 使用字符串不可以吗？
; 使用字符串可以解决本题，但对比结构体，使用字符串的思路
; 1、需要频繁的字符串切割和拼接
; 2、光标位置的手动维护

; 结论：虽然使用字符串方法可行，但太麻烦，使用结构体才是更好的方法。

; ------------------------------代码部分 --------------------------------------------------------------
; ==========================================
; 缩写说明
; - IMG: image（图片）
; ==========================================

; =============
; 全局目的
; =============

; 设计函数 render，读入 editor (结构体)，渲染文本+光标。

; =============
; 常量定义
; =============

; 光标图像（红色竖线）
(define CURSOR-WIDTH 1)
(define CURSOR-HEIGHT 20)

(define CURSOR-IMG
  (rectangle CURSOR-WIDTH CURSOR-HEIGHT "solid" "red"))

; 编辑器场景
(define SCENE-WIDTH 200)
(define SCENE-HEIGHT 20)

(define SCENE
  (empty-scene SCENE-WIDTH SCENE-HEIGHT))

; 文本字号（单位：像素）
(define TEXT-SIZE 16)

; 文本颜色
(define CONTENT-COLOR "black")

; =============
; 结构体
; =============

; editor 是结构体，表示文本编辑器里的文字
(define-struct editor [pre post])
; 一个 editor 是：(make-editor String String)
; 解释：
; - pre  ：光标前文本（必须是字符串）
; - post ：光标后文本（必须是字符串）

; ----------
; 渲染函数
; ----------

; 目的：读入 editor-instance，渲染为图像。
; 不变式：(invariants)
;   光标置于 pre 与 post 之间
; editor -> image 

(define (render state)
  (overlay/align "left" "center"
                (beside
                 (text (editor-pre state) TEXT-SIZE CONTENT-COLOR)
                 CURSOR-IMG
                 (text (editor-post state) TEXT-SIZE CONTENT-COLOR))
                SCENE))


; ----------
; 测试案例
; ----------

; 测试 1：普通文本
(render (make-editor "Learning" "Htdp2e"))
; 显示 "Learning|Htdp2e"

; 测试 2：空编辑器
(render (make-editor "" ""))   
; 显示空白场景中的光标

; 测试3：光标居最左端
(render (make-editor "" "Hello"))   
; 显示 "|Hello"


