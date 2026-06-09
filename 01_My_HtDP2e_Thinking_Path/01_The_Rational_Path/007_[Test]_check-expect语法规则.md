# check-expect 语法规则

( check-expect ***actual-value***  ***expected-value*** )  

翻译为中文：

( check-expect 实际值 期望值)  

经常忘记 check-expect 用法，特意查了一下。 

几个要点:

1、左侧是待验品，右侧是标准答案

2、右侧写业务函数会导致循环论证

3、右侧可以用构造器和简单数学，不能用业务函数


