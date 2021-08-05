# Predicting housing prices in Boston based on several factors.
# The features of the training data are such factors. The targets are the prices of homes in thousands of dollars.
# We're tracking mean absolute error as our metric. This tells us how far off +/- our predictions will be from the
# actual price given the features, in thousands of dollars. i.e. a mse of 2.5 = +-$2500

library(keras)

dataset <- dataset_boston_housing()
c(c(train_data, train_targets), c(test_data, test_targets)) %<-% dataset
str(train_data)

# Apply th mean function column-wise (per the 2nd arg)
mean <- apply(train_data, 2, mean)
std <- apply(train_data, 2, sd)

train_data <- scale(train_data, center = mean, scale = std)
test_data <- scale(test_data, center = mean , scale = std)

# This time we'll use a function to construct our model so we don't have to keep deleting it to try again

build_model <- function() {
  model <- keras_model_sequential() %>%
    layer_dense(units = 64, activation = "relu", input_shape = dim(train_data)[[2]]) %>%
    layer_dense(units = 64, activation = "relu") %>%
    layer_dense(units = 1)
  
  model %>% compile(
    optimizer = "rmsprop",
    loss = "mse",
    metrics = c("mae") # Mean Absolute Error
  )
  
}

##
# implementation of K-Fold Validation
##

# Number of partitions
k <- 4

# a random sample of indices from 1 to the num rows of our training data
indices <- sample(1:nrow(train_data))

# cut our indices into K separate "folds"
folds <- cut(indices, breaks = k, labels = FALSE)
folds
num_epochs <- 100
all_scores <- c()
all_mae_histories <- NULL

for (i in 1:k) {
  cat("processing fold #", i, "\n")
  
  # This one denotes our validation set, fold[i] is our validation data for this round
  val_indices <- which(folds == i, arr.ind = TRUE)
  
  # Get the validation data from our training data
  val_data <- train_data[val_indices,]
  
  # Validation targets
  val_targets <- train_targets[val_indices]
  
  # Training set and targets
  partial_train_data <- train_data[-val_indices,]
  partial_train_targets <- train_targets[-val_indices]
  
  # Builds and compiles the model
  model <- build_model()
  history <- model %>% fit(
    partial_train_data, 
    partial_train_targets,
    epochs = num_epochs,
    batch_size = 1,
    verbose = 1
  )
  
  # Evaluate the model on our validation data
  #results <- model %>% evaluate(val_data, val_targets, verbose = 0)
  #all_scores <- c(all_scores, results)
  
  mae_history <- history$metrics$mae
  all_mae_histories <- rbind(all_mae_histories, mae_history)
}

average_mae_history <- data.frame(
  epoch = seq(1:ncol(all_mae_histories)),
  validation_mae = apply(all_mae_histories, 2, mean)
)

model %>% predict(test_data)
test_targets

library(ggplot2)
ggplot(average_mae_history, aes(x=epoch, y=validation_mae)) + geom_line() + geom_smooth()


