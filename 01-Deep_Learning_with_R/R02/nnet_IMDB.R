# Overview: An overfitting NN
# The input data is vectors, the labels are scalars (0 or 1)
# The ideal NN for such an arrangement will be a densely connected network
# using the ReLU activation function

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

# Create a validation set
val_indices <- 1:10000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]


# Building a 3 layer network 16 -> 16 -> 1
model <- keras_model_sequential() %>%
  layer_dense(units = 16, activation = "relu", input_shape = c(10000)) %>%
  layer_dense(units = 16, activation = "relu") %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")
  
model %>% compile (
  optimizer = "adam",
  loss = "mse",
  metrics = c("accuracy")
)

str(model$summary())

history <- model %>% fit (
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 1024,
  validation_data = list(x_val, y_val)
)

plot(history)

# Turn our history into a dataframe and extract datasets categorically
df <- as.data.frame(history)
df

##
# Exercise: turning our history into the initial plot from training
##

# Extract only the training data
trn <- df[df$data == "training",][0:3]
trn

# Just for reference - you can use conditions as index qualifiers in R
# trn_acc <- trn[trn$metric == "accuracy",][0:2]
# trn_loss <- trn[trn$metric == "loss",][0:2]

# Extract only the validation data
vld <- df[df$data == "validation",][0:3]
vld

# Just for reference - you can use conditions as index qualifiers in R
# Or if you're wasting your time on Twitter you can just close the fckin thing
# vld_accuracy <-vld[vld$metric == "accuracy",]
# vld_loss <- vld[vld$metric == "loss",]

ggplot(trn, aes(epoch, value, colour=metric)) + 
  geom_line() + 
  geom_point() +
  ylim(0,1)

ggplot(vld, aes(epoch, value, colour=metric)) + 
  geom_line() + 
  geom_point() +
  ylim(0,1)

df

p <- ggplot(df, aes(epoch, value, colour=metric)) + 
  geom_point() +
  geom_line()
p + facet_grid(rows = vars(data))

# Make predictions
model %>% predict(x_test[1:10,])
