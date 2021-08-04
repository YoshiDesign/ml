# Overview: An overfitting NN
# The input data is vectors, the labels are scalars (0 or 1)
# The ideal NN for such an arrangement will be a densely connected network
# using the ReLU activation function
install.packages("keras")
library(keras)
imdb <- dataset_imdb(num_words=10000)
c(c(train_data, train_labels), c(test_data, test_labels)) %<-% imdb

# The multiassignment operator %<-% as used above is equivalent to:
# train_data <- imdb$train$x
# train_labels <- imdb$train$y
# test_data <- imdb$test$x
# test_labels <- imdb$test$y
# It is part of the zeallot package

# Random... Checking out the word index
word_index <- dataset_imdb_word_index()
word_index
reverse_word_index <- names(word_index)
reverse_word_index
names(reverse_word_index) <- word_index
reverse_word_index
word_index

# One Hot encoding our data before feeding it to the network.
vectorize_sequences <- function(sequences, dimension = 10000) {
  
  # Create an all-zero matrix of shape (length(sequences), dimension)
  results <- matrix(0, nrow = length(sequences), ncol = dimension)
  
  for (i in 1:length(sequences)) {
    # Sets specific indices of results[i] to 1s
    results[i, sequences[[i]]] <- 1
  }
  
  results
}

# Make our training and testing datasets
x_train <- vectorize_sequences(train_data)
x_test <- vectorize_sequences(test_data)

dim(x_train)
dim(x_test)

# Check out our new training samples
str(x_train[1,])

# Convert our labels from integer to numeric
y_train <- as.numeric(train_labels)
y_test <- as.numeric(test_labels)

length(y_train)
length(y_test)

# Building a 3 layer network 16 -> 16 -> 1
model <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu", input_shape = c(10000)) %>%
  layer_dense(units = 4, activation = "relu") %>%
  layer_dense(units = 4, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")
  
model %>% compile (
  optimizer = "rmsprop",
  loss = "mse",
  metrics = c("accuracy")
)

# Create a validation set
val_indices <- 1:10000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

history <- model %>% fit (
  partial_x_train,
  partial_y_train,
  epochs = 60,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)

str(history)
