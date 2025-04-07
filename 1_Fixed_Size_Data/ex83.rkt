; 83

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


; 代码---------------------------------------------------------------------------------

; ====================================================
; 全局目的
; 设计函数render，读入 editor (结构体)，并产生图像。
; ====================================================

; ---------- 
; 常量配置
; ----------

; 光标尺寸（宽*高）
(define CURSOR-WIDTH 1)
(define CURSOR-HEIGHT 20)

; 场景尺寸（宽*高）
(define SCENE-WIDTH 200)
(define SCENE-HEIGHT 20)

; 文本字号（单位：像素）
(define TEXT-SIZE 16)

; 文本颜色
(define CONTENT-COLOR "black")

; 光标图像（红色竖线）
(define cursor-image
  (rectangle CURSOR-WIDTH CURSOR-HEIGHT "solid" "red"))


; ----------
; 编辑器结构体
; ----------

; 目的：表示文本
; 文本分别是：
; - pre-text  ：光标前文本（必须是字符串）
; - post-text ：光标后文本（必须是字符串）

(define-struct editor [pre-text post-text])
; 一个 editor 是：(make-editor String String)


; ----------
; 渲染函数
; ----------

; 目的：读入 editor-instance，渲染为图像。
; 不变式：(invariants)
;   光标置于 pre-text 与 post-texts 之间
; editor -> image 

(define (render content)
  (overlay/align "left" "center"
                (beside
                 (text (editor-pre-text content) TEXT-SIZE CONTENT-COLOR)
                 cursor-image
                 (text (editor-post-text content) TEXT-SIZE CONTENT-COLOR))
                (empty-scene SCENE-WIDTH SCENE-HEIGHT)))


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


; ----------
; 思路订正
; ----------

; 问：为什么必须得使用结构体，使用字符串不可以吗？

; 答：结构体的题目，从代码来看，都是不算难，可背后的思考深度，往往很深。
; 
