# @YoLyristis 100DaysOfCode
# Demonstrating the sweep function

# Using sweep() we can compute a function between 2 tensors
# and and choose which axes we want to compute against

# runif() will generate a uniform distribution of values between 0 and 9.
# Its first argument is the number of values to generate. Notice how it happens to describe the dimensions.
# Since they will be float values by default, round() will turn them into plain int's

# Create 2 arrays with different dimensionality. x has 4 axes, y has 2
x <- array(round(runif(64*3*32*10, 0, 9)), dim = c(5, 3, 1, 10))
y <- array(round(runif(3*32, 0, 9)), dim = c(1, 10))

# "Sweep" the pmax function over y using the 3rd and 4th axes of x.
# The number of elements spanning each axis must match in length.
# Notice how the axes 1 and 2 of y, are the same size as axes 3 and 4 of x, allowing the sweep.
z <- sweep(x, c(3,4), y, pmax)

# Z has the same dimensions as x. 
# pmax() has been applied to every element of its 3rd and 4th axes.

dim(z)          # 5 3 1 10
length(dim(z))  # 4
