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

'''    
Result
          0.5      1.0      2.5      4.0      10.0
0.010  0.76246  0.63397   0.5239  0.49067  0.45448
0.206  0.84415   0.6718  0.52915   0.4875  0.44145
0.402  0.86338  0.69725  0.53342  0.48473  0.43143
0.598  0.87042  0.70916   0.5364  0.48276   0.4254
0.794  0.87312  0.71406    0.538  0.48171  0.42256
0.990   0.8738  0.71533  0.53847  0.48141  0.42179
elapsed: 76.15 s    
'''