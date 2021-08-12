arr4d <- array(round(runif(10*2*3*4, 0, 1200)), dim=c(10,2,3,4))
arr3d <- array(round(runif(10*2*3, 0, 1200)), dim=c(10,2,3))

arr4d[3]   # First column of the third row of the first axis
arr4d[3,,,] # Every first column of the third row of every axis upon each axis, column values are listed as rows

arr3d[,2,] # Rows and columns corresponding to the 2nd column of down every axis
arr3d[,0,] # Extracts lists of indices
arr3d[1,2,3] # 1st row 2nd column 3rd axis

dim(arr3d)
dim(arr4d)
