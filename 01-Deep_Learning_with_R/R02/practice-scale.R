x <- array(round(runif(2 * 10, 1, 10)), dim=c(10,2))
x

y <- matrix(1:10, ncol=2)
y

z <-matrix(101:500, ncol=5)
z

std = apply(z, 2, mean)
dev = apply(z, 2, sd)
scale(z, center=std, scale=dev)

(centered.y <- scale(y, scale = FALSE))

cov(centered.scaled.y <- scale(y))

scale(x)
?scale
?cov
