; 97

; =============
; 背景说明
; =============

; 97 题误导性极强，该题的本质是渲染次序。

; 背景、坦克、UFO、导弹，共同构成了一幅图。这副图片，在计算机看来，依照先后次序渲染出来。

; 96 题，以及后面的内容，均已经暗示了图像渲染次序，97 题的关键，是“发射”状态下。

; =============
; 题目分析
; =============

; 表达式 1
(tank-render
  (fired-tank s)
  (ufo-render (fired-ufo s)
              (missile-render (fired-missile s)
                              BACKGROUND)))

; 要理解这个表达式的意思，我给你加一个空格，就看清楚了：

(tank-render
  (fired-tank s)
; （这里加了一空格）
  (ufo-render (fired-ufo s)
              (missile-render (fired-missile s)
                              BACKGROUND)))

; 表达式 1 的意思是：
; 第 1、渲染出 TANK 的图像，然后把坦克图像，叠加在第 2 图像上面。
; 第 2、渲染出 UFO 的图像，同时 UFO 的图像，也是叠加在 第 3 图像之上。 
; 第 3、渲染出 MISSILE 的图形，并把 MISSILE 图像叠加在背景图像上。

; 所以表达式 1 的先后渲染次序： 背景 -> 导弹 -> UFO -> TANK 

; 表达式 2
(ufo-render
  (fired-ufo s)
; （这里加了一空格）
  (tank-render (fired-tank s)
               (missile-render (fired-missile s)
                               BACKGROUND)))

; 同理
; 表达式 2 的渲染次序：背景 -> 导弹 -> TANK -> UFO

; 从渲染次序来说，二者的状态，只要导弹未击中 UFO ，TANK 与 UFO 图像未重合，二者图像都一致。
; 如果导弹的图像足够小，击中 UFO 时，导弹在表达式 1 与 2 都是给遮盖住，看不到。

; =============
; 结论
; =============

; 结论 1：
; 大部分时间内，二者图像一致。
; 一旦 TANK 与 UFO 图像重合了，这两个表达式视觉效果则不同：
; 表达式 1 ： UFO 会遮盖住 TANK 
; 表达式 2 ： TANK 会遮盖住 UFO 

; 结论 2：
; 对于太空游戏来说，97 题的两个表达式渲染次序都不对，正确的渲染次序是：
; 背景 -> TANK -> UFO -> 导弹 
; 只有这样子：
; - UFO 下落时，如果碰到了坦克，UFO 是位于 TANK 之上。
; - MISSILE 击中 UFO 时， MISSILE 是位于 UFO 之上。
; 也即游戏逻辑与视觉效果一致。

; 结论 3
; 太空游戏图像呈现，要格外注意渲染次序，同时还有一个条件，即 UFO 会随机跳动，99 题就是解决这个问题。