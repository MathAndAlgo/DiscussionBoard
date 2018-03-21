
main <- function(){
    f = function(x){pgamma(x,1)}
    reps = 1E4
    for (j in 1:reps){
        b = integrate(f,0,1)
    }
    b
}
system.time({b <- main()})
print(b)

