my_list <- list(upper = c("a", "b","c", "d"), lower = c("x","y","z"))
my_list
my_list[["upper"]]
my_list["upper"]

my_mat = matrix(round(runif(20 * 20, 0, 9)), ncol=20, nrow=20)
my_mat[3,]
