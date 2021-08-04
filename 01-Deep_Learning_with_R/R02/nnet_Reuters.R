library(keras)
reuters <- dataset_reuters(num_words=10000)

c(c(train_data, train_labels),c(test_data,test_labels)) %<-% reuters

# Reverse the word index just to inspect things. Not being fed into the network
word_index <- dataset_reuters_word_index()
reverse_word_index <- names(word_index)
names(reverse_word_index) <- word_index
reverse_word_index[3]
decoded_newswire <- sapply(train_data[[2]], function(index){
  word <- if (index >= 3) reverse_word_index[[as.character(index - 3)]]
  if (!is.null(word)) word else "?"
})

# This data is pretty dumb
decoded_newswire

# One Hot encoding function
vectorize_sequences <- function(sequences, dimension = 10000) {
  
  # Empty matrix ( length(sequences) x dimension )
  results <- matrix(0, nrow = length(sequences), ncol = dimension)
  
  for (i in 1:length(sequences)) {
    # Sets specific indices of results[i] to 1s
    results[i, sequences[[i]]] <- 1
  }
  
  results
}

x_train <- vectorize_sequences(train_data)
x_test <- vectorize_sequences(test_data)
x_train[,7124]

max(train_labels)
max(test_labels)

# Unused, this was before i switched to sparse_categorical_crossentropy
one_hot_train_labels <- to_categorical(train_labels)
one_hot_test_labels <- to_categorical(test_labels)

model <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = c(10000)) %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 46, activation = "softmax")

model %>% compile(
  optimizer = "rmsprop",
  loss = "sparse_categorical_crossentropy",
  metrics = c("accuracy")
)

val_indices <- 1:1000

# Set aside a validation set from the training set
x_val <- x_train[val_indices,]

# The rest will be our training data
partial_x_train <- x_train[-val_indices,]

# Split our labels in an identical manner
y_val <- train_labels[val_indices]
partial_y_train = train_labels[-val_indices]

# Commence the training loop
history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 9,
  batch_size = 256,
  validation_data = list(x_val, y_val)
)

plot(history)
rm(model)
