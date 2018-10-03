
\iffalse
## From [Bishop 2004 slides](https://slideplayer.com/slide/234500/)

![](https://player.slideplayer.com/1/234500/data/images/img166.png) 

![](https://player.slideplayer.com/1/234500/data/images/img173.png)

![](https://player.slideplayer.com/1/234500/data/images/img189.png)

![](https://player.slideplayer.com/1/234500/data/images/img167.jpg)

![](https://player.slideplayer.com/1/234500/data/images/img169.jpg)

![](https://player.slideplayer.com/1/234500/data/images/img172.png)

![](https://player.slideplayer.com/1/234500/data/images/img171.jpg)
\fi

最近在看[Bishop 2004 slides](https://slideplayer.com/slide/234500/), [Tipping 2006 paper](https://www.miketipping.com/papers/met-mppca.pdf))对经典PCA推广得出的概率型PCA(PPCA,probabilistic PCA)。出于某些原因并没有仔细研读Bishop的推导，而是发现自己对连续变量的混合模型(mixture model)并不是很熟悉。在经过两天的阅读和思考后，意识到混合模型的本质就是概率分布函数的卷积(convolution)。以下根据Bishop2004对PPCA稍作分解(exposition)。令隐变量$z$服从单位高斯分布:

$$
p(z) = \mathcal{N}(z|0,I)
$$

然后考虑给定隐变量$z$后，观测变量$x$的条件概率分布

$$
p(x|z) = \mathcal{N}(x|Wz + \mu, \sigma^2 I)
$$

考虑变换

$$\begin{align}
x &= Wz + \mu + \phi\\
\psi &=Wz + \mu 
\end{align}$$

则有

$$\begin{align}
\phi &= x - Wz - \mu  \\
     &= x -\psi \\ 
p(\phi | \psi) &= p(\phi | z) 
\\ &= \mathcal{N}(\phi|0,\sigma^2 I ) \\
p(\psi) &=  \frac{1}{|\psi'(z)|} p(z) 
\end{align}$$

其中 $|\psi'（z）|$是线性变换$z\rightarrow Wz + \mu$的雅克比矩阵的行列式,对于非方阵，其行列式推广为$\sqrt{W^TW}$。但是直接考虑利用高斯变量的性质可得

$$\begin{align}
\psi_i &= \mu_i + \sum_j w_{ij} z_j \\
\text{Cov}(\psi_a,\psi_b) &= \text{Cov}( \sum_i w_{ai}z_i, \sum_j w_{bj}z_j) \\
&= (\sum_{i=j} + \sum_{i\neq j}) \text{Cov} (w_{ai}z_i ,w_{bj} z_j)
\\ &= [\sum_{i=j}\text{Cov} (w_{ai}z_i ,w_{bj} z_j) + 0 ]
\\ &= \sum_i w_{ai}w_{bi} \text{Cov}(z_i,z_i)
\\ &= \sum_i w_{ai}w_{ib} \cdot 1
\\ \text{Var}[\psi] &= W W ^ T
\end{align}$$




求边际密度即是求卷积

$$
p（\phi） = \int p(\phi | \psi) p(\psi) d\psi
$$

又由于高斯分布的卷积仍然是高斯分布，因此可以直接写出其形式

$$\begin{align}
\mathbb{E}[\phi] 
&= E[\psi] + E[\phi | \psi] \\
&= \mu + 0 \\
\text{Var}[\phi] &= \text{Var}[\psi] + \text{Var}[\phi| \psi ] \\
&= WW^T + \sigma^2 I \\
p(\phi) &=\mathcal{N}(\psi | \mu, WW^T + \sigma^2 I)
\end{align}$$

从某种角度讲，卷积是比边际化更为直观的一个操作。对比高斯混合模型（GMM），我们可以看出GMM对应的$p(\psi)$写作

$$
p(\psi) = \sum_k \pi_k \delta(\psi - \psi_k)
$$

如果使用完整的协方差矩阵，那么每一个脉冲$\delta（\psi - \psi_k）$都会对自己的高斯组分$p(\phi|\psi=\psi_k)$进行卷积。而如果考虑一个共享的协方差矩阵给定的$p(\phi|\psi)$，则可以直接求卷积

$$
p（\phi） = \int p(\phi | \psi) p(\psi) d\psi
$$

另:Bishop2004的公式发现原公式是有误的。

![](https://player.slideplayer.com/1/234500/data/images/img172.png)

![](https://player.slideplayer.com/1/234500/data/images/img171.jpg)
