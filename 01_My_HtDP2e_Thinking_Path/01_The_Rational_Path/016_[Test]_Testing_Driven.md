# 怎么样使用测试代码？(Testing_Driven)

## 1、为何测试先行？

HTDP2e 第三章，就在强调一个观点，设计函数时，不要急着写函数，而是要优先写测试案例。

**可以称之为测试先行。**

初学时感觉：很糟糕的思路。

有些题目，其函数一眼就看出来了，为什么还要先写测试函数，啰里啰唆，多此一举。

这问题，需要等到后面章节才会有答案。

<br>

## 2、测试代码书写顺序

htdp2e 固定数据部分，结构体与函数，各自的测试代码书写顺序不同：

**结构体 → 直接写完，直接测**

**函数 → 先写测试，再写存根，再填代码**

<br>

## 3、结构体怎么样写测试代码？

结构体的测试函数，包含两部分

**构造测试**：看看结构体的结构，是不是对？所以，测试案例，1 个就好了。

**访问各字段**：看看能不能准备访问各个字段。有多少个字段，就测试多少个字段。

例如，107 题的结构体测试

(define-struct zoo [vcat vcham focus-key])

;; --- tests ---
;; 构造（仅1个）
(check-expect 
 (make-zoo (make-vcat 20 100 "right")
           (make-vcham 50 100 "red")
           "k")
 (make-zoo (make-vcat 20 100 "right")
           (make-vcham 50 100 "red")
           "k"))

;; 访问各字段（需要3个）
(check-expect
 (zoo-vcat (make-zoo (make-vcat 20 100 "right")
                     (make-vcham 50 100 "red")
                     "k"))
 (make-vcat 20 100 "right"))

(check-expect
 (zoo-vcham (make-zoo (make-vcat 20 100 "right")
                      (make-vcham 50 100 "red")
                      "k"))
 (make-vcham 50 100 "red"))

(check-expect
 (zoo-focus-key (make-zoo (make-vcat 20 100 "right")
                          (make-vcham 50 100 "red")
                          "k"))
 "k")

注意：Zoo 的测试只需要验证 Zoo 这一层的访问器。

即：**每一层只测自己这一层的事。**

<br>

## 4、函数怎么样运用测试代码？

 用 107 题 update-zoo 完整演示一遍

### 第 1 步：签名 + 目的

先想清楚这个函数**输入什么、输出什么**：

```racket
;; 每个 tick，同时更新猫和变色龙的状态
;; Zoo -> Zoo
(define (update-zoo state)    ← 函数头
...)
```
目的、签名、函数头，一口气写完，到这里停下来。

不要急着写后面剩下的代码。

<br>

### 第 2 步：想一个具体的场景

在脑子里（或纸上）想一个具体的输入：

```
猫在 20，快乐值 100，向右走
变色龙在 50，快乐值 100，红色
焦点键是 "k"
```

然后问自己：**过了一个 tick，世界应该变成什么样？**

```
猫：20 + 3 = 23，快乐值 100 - 0.5 = 99.5，方向不变
变色龙：(modulo (50 + 1) 300) = 51，快乐值 100 - 0.5 = 99.5，颜色不变
焦点键：不变，还是 "k"
```

<br>

### 第 3 步：把这个场景写成 check-expect

```racket
(check-expect
 (update-zoo (make-zoo (make-vcat 20 100 "right")
                       (make-vcham 50 100 "red")
                       "k"))
 (make-zoo (make-vcat 23 99.5 "right")
           (make-vcham 51 99.5 "red")
           "k"))
```

**这一步的关键：你不需要知道代码怎么写，你只需要知道输入什么、应该输出什么。**

<br>

### 第 4 步：再想几个场景

问自己：还有什么特殊情况？

```
猫到边界了怎么办？
变色龙到边界了怎么办？
快乐值已经是 0 了怎么办？
```

一个一个写：

```racket
;; 猫到右边界，转向
(check-expect
 (update-zoo (make-zoo (make-vcat 300 100 "right")
                       (make-vcham 50 100 "red")
                       "k"))
 (make-zoo (make-vcat 303 99.5 "left")
           (make-vcham 51 99.5 "red")
           "k"))

;; 变色龙到右边界，循环
(check-expect
 (update-zoo (make-zoo (make-vcat 20 100 "right")
                       (make-vcham 299 100 "red")
                       "k"))
 (make-zoo (make-vcat 23 99.5 "right")
           (make-vcham 0 99.5 "red")
           "k"))

;; 快乐值为 0
(check-expect
 (update-zoo (make-zoo (make-vcat 20 0 "right")
                       (make-vcham 50 0 "red")
                       "k"))
 (make-zoo (make-vcat 23 0 "right")
           (make-vcham 51 0 "red")
           "k"))
```

<br>

### 第 5 步：写存根

```racket
;; 每个 tick，同时更新猫和变色龙的状态
;; Zoo -> Zoo
(define (update-zoo state)           ← 函数头
  (make-zoo (make-vcat 0 0 "right")  ← stub（存根）
            (make-vcham 0 0 "red")
            "k"))
```

**加上存根，这一步极其重要。**

<br>

**问题 1：存根是什么？**

函数存根，function stub，它在中文里通常翻译为 “桩” 或 “存根”。

"桩"一词，很形象。像打地基时先打一根桩，标记位置，以后再建上面的结构。

存根就是一个**假的函数体**。它的作用只有一个：**让程序能运行，让测试能跑起来。**

```racket
;; 真正的代码还没想好，先占个位
(define (update-zoo state)
  (make-zoo (make-vcat 0 0 "right")
            (make-vcham 0 0 "red")
            "k"))
```

要求只有一条：**返回值的类型要对。**

函数签名说返回 Zoo，存根就返回一个 Zoo。值是什么无所谓，全填 0 都行。

<br>

**问题 2：为什么需要它？**

因为如果没有存根：

```
测试里调用了 update-zoo
    ↓
update-zoo 不存在
    ↓
DrRacket 直接崩溃：undefined
    ↓
测试一条都跑不了
```
<br>

有了存根：

```
测试里调用了 update-zoo
    ↓
update-zoo 存在，返回了假数据
    ↓
测试正常运行，结果不对，红灯
    ↓
但路通了，你知道测试本身没写错
```

**存根就是一座临时的桥，让你先确认路的方向是对的，然后再把桥修成真的。**

<br>

**问题3：存根的方法是 racket 语言专有吗？**

存根是一思维方法，非特有的功能。 任何语言都能写假函数占位，任何语言都能先写测试再填代码。

HtDP2e 提倡使用存根，目的是促使初学者从一开始养成这习惯。

<br>

### 第 6 步：运行

```
✗ 四个测试全部失败
  期望：(make-zoo (make-vcat 23 99.5 "right") ...)
  实际：(make-zoo (make-vcat 0 0 "right") ...)
```

**红灯，但程序没崩溃。路通了，答案不对而已。**

<br>

### 第 7 步：写真正的代码

现在你看着这些测试，代码就很容易写了：

```racket
(define (update-zoo state)
  (make-zoo
   (update-vcat (zoo-vcat state))
   (update-vcham (zoo-vcham state))
   (zoo-focus-key state)))
```

<br>

### 第 8 步：运行

```
四个测试全部通过 ✓
```

**踏实了，写下一个函数。**

<br>

## 5、两层保障

非常明显，测试先行分为两个阶段，其实也是两层保障。

**存根阶段 → 保证测试的结构没问题（能跑起来）**

**真代码阶段 → 保证测试的数值没问题（手动验算）**

通过这两阶段，确保测试代码、函数，均正确。

## 6、测试先行的内涵

之前，我困惑于：测试先行明明麻烦，为何还要用？

其 1、htpd2e 上来助你建立习惯，初期的题目简单，但习惯先建立。其实就算不建立，也无所谓，后面的题目，也会逼你建立。

其 2、到第 6 章，有些题目开始复杂了，事先考虑完善，考虑清楚任何一细节，不现实了。

题目开始复杂，函数出现层级，相互之间调用，要保证每一函数都准确，还要保障每一函数覆盖的范围都要完备。

一口气考虑清楚，一口气写正确了，不现实了。

**正确的办法：边想，边写，边检验。写一函数，确保对一函数。**

无论怎么样的程序，归根结底，都是一循环：

信息 --> 数据
数据 --> 信息。

复杂的信息，不可能一下完美转为数据，期间有疏漏，有丢失，都是常态，所以采用测试先行，目的是保障：信息 --> 数据，这一步顺畅自然。


可以总结为：**先确定终点在哪里（测试），再想怎么走过去（代码）。**

---

注：本文在 Ai 协助之下完成。但大部分都是我自己写的。