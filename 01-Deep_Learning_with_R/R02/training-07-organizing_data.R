# NOTE: partially pseudocode

data <- array(round(runif(1000, 0, 9)), dim=c(10,100))

###                   ###
# 1. Holdout Validation #
###                   ###

# take 80% of the data's indices and acquire indices in a shuffled order
indices <- sample(1:nrow(data), size = 0.80 * nrow(data))

# Everything but our designated indices as an evaluation set
evaluation_data <- data[-indices,]

# Every index we've designated
training_data <- data[indices,]

# One potential issue here is that you'll need enough data 
# to be able to statistically represent all of your data.
# You'll know you have too little data if training models 
# on different random samples yields very different results.

###                 ###
#  K-Fold Validation  # 
###                 ###

# Number of partitions
k <- 4

# A random shuffle of our available indices (axes)
indices <- sample(1:nrow(data))

# cut our indices into K separate "folds"
folds <- cut(indices, breaks = k, labels = FALSE)

validation_indices
for (i in 1:k) {

  validation_indices <- which(folds == i, arr.ind = TRUE) 
  validation_data <- data[validation_indices,]
  training_data <- data[-validation_indices,]

  # Train the model here
  # Then evaluate the model on the current validation set

}

###                          ###
#  Iterated K-Fold Validation  #
###                          ###

# Train i models over K partitions, repeated p times.
# This can be expensive.
# This applies K-Fold validation
# numerous times, shuffling the data every time before 
# splitting into K partitions. Obtain your score at the
# end of each K-fold validation and take the average.

iterative_k_fold <- function(data, iters = 10, k = 4) {

  # Defined here for term exec...
  k = 4
  
  # instantiate all validation scores list
  validation_scores <- c()
  
  for (p in 1:iters){
    
    # A random shuffle of our available indices (axes)
    indices <- sample(1:nrow(data))
    
    # cut our indices into K separate "folds"
    folds <- cut(indices, breaks = k, labels = FALSE)
    
    # Instantiate current iteration's validation scores list
    scores <- c()

    for (i in 1:k) {
      
      validation_indices <- which(folds == i, arr.ind = TRUE) 
      validation_data <- data[validation_indices,]
      training_data <- data[-validation_indices,]
      
      # Train the model here...
      # Then evaluate the model on the current validation set
      
      # Creates a list of scores
      scores <- c(scores, 9001)
      
    }
    
    # Collect the mean of the last iterations scores
    validation_scores <- c(validation_scores, round(mean(scores)))
    
  }
  
  # Finally take the average of all of our collected validation means
  final_score <- round(mean(validation_scores))
  final_score
  
}

