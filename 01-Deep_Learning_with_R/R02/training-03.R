# Demonstrating the sweep function

# Using sweep() we can perform tensor operations between 2 tensors with different dimensions
x <- array(round(runif(1000, 0, 9)), dim = c(64, 3, 32, 10)) 
y <- array(5, dim = c(3, 32))

# There will be no integer less than 5 in z
z <- sweep(x, c(2,3), y, pmax)

# Z has the same dimensions as x
dim(z)