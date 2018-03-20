Matlab 在数值计算方面有很大的优势，用 Matlab 和 python 分别解一个带参数的
积分方程结果非常出乎意料。

F(p; b, k) 是 f(x, p) 从 0 到 1 的积分，从而是一个 p 的函数。b, k 为参数。
这里 f 是一个和威布尔分布相关的函数，而 F 则是两个威布尔随机变量和的
cdf。其中 b 是两个变量共同的形状参数，k 是它们尺度参数的比值。由于位置参数
不影响 F 的取值，因此无需纳入考虑。

问题的背景及 F 的推导不作具体讨论。现在只需知道：

> F(p; b, k) = int_0^1 f(x, p; b, k) dx

而我们关心的是，函数 F 的不动点，即：

> F(p) = p

的根 rp。

因为 0 和 1 是函数 f 的瑕点，因此我们只关心 rp 在 (0,1) 之间的情况。b, k 是 F
的参数，因此最终 rp 是 b, k 的函数，记为 rp(b, k) 下面编程对 rp 的值进行数值
求解。

python:
``` python
import pandas as pd
pd.set_option("display.precision", 5)

import numpy as np

from scipy.stats import weibull_min
from scipy.integrate import quad
from scipy.optimize import brentq

rv = weibull_min


def f(x, p, b=1, k=1):
    return rv.cdf((1+k)*rv.ppf(p, b) - k*rv.ppf(x, b), b)


def F(p, b=1, k=1, eps=1e-8):
    return quad(f, 0, 1, args=(p, b, k), epsabs=eps, epsrel=eps)[0]


def root_p(b=1, k=1, eps=1e-8, xtol=1e-6):
    return brentq(lambda p: F(p, b, k, eps=eps)-p, 0.01, 0.99, xtol=xtol, rtol=xtol)


v = np.vectorize(root_p)
eps = 1e-8
xtol = 1e-6

if __name__ == '__main__':
    from time import clock
    start = clock()

    k = np.linspace(0.01, 0.99, 6)
    b = [0.5, 1, 2.5, 4, 10]
    R = pd.DataFrame(index=k, columns=b)

    for ib in b:
        R.loc[:, ib] = v(ib, k, eps=eps, xtol=xtol)
    print(R)

    print("elapsed: {:.2f} s".format(clock() - start))
```

matlab：
```matlab
start_tic = tic;

rv = prob.WeibullDistribution();

k = linspace(0.01, 0.99, 6);
b = [0.5 1 2.5 4 10];
R = zeros(length(k), length(b));

eps = 1e-8;
opt = optimset('TolX', 1e-6);

% matlab can't defines functions in script, use func handles instead
% note, the parameter b is passed as a property of rv.
f = @(x, p, k, rv) rv.cdf((1+k).*rv.icdf(p) - k.*rv.icdf(x));
F = @(p, k, rv)integral(@(x)f(x, p, k, rv), 0, 1, 'abstol', eps, 'reltol', eps);
root_p = @(k, rv)fzero(@(p)F(p, k, rv)-p, [0.01, 0.99], opt);


for j = 1:length(b)
    rv.B = b(j);
    for i = 1:length(k)
        R(i,j) = root_p(k(i), rv);
    end
end

R

fprintf('%s elapsed: %f s\n', mfilename, toc(start_tic));
```

执行耗时如下：
> matlab: 0.941343 s
>
> python: 111.63 s

matlab 的计算效率大约是 python 的 120 倍！！
