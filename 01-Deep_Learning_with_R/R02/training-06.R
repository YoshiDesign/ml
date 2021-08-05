# Using fold() to partition data

a <- c(round(runif(100, 0,10)))
folds <- cut(a, breaks=3, labels=FALSE)

for (i in 1:3) {
  cat("i =", i, "\n")
  
  # Which indices of folds == i ? returns a list of indices
  inds <- which(folds == i, arr.ind = TRUE)
  
}
