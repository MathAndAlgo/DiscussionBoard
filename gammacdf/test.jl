
using Distributions
using Cubature
D = Gamma(1)
f = x ->begin cdf(D,x);end
reps = 1E4
@time for j in 1:reps 
    b = quadgk(f,0,1)
    end
@time for j in 1:reps 
    b = hquadrature(f,0,1)
    end
b = quadgk(f,0,1)
println(b)
