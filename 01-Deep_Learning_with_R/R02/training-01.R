# Install the keras package
# install.packages("keras")

library(keras)

mnist <- dataset_mnist()

# Training Set
train_images <- mnist$train$x
train_labels <- mnist$train$y

# Testing Set
test_images <-mnist$test$x
test_labels <-mnist$test$y

# Checking stuff out
str(train_images)
str(train_labels)

str(test_images)

# Build the NN (%>% is known as the "pipe operator" and signifies in place modification of our network)
network <- keras_model_sequential() %>%
  layer_dense(units = 512, activation = "relu", input_shape = c(28 * 28)) %>%
  layer_dense(units = 10, activation = "softmax")

# Compile the NN
network %>% compile(
  optimizer = "rmsprop",
  loss = "categorical_crossentropy",
  metrics = c("accuracy")
)

# Reshape our data to fit the model's input structure
train_images <- array_reshape(train_images, c(60000, 28 * 28))
train_images <- train_images / 255
test_images <- array_reshape(test_images, c(10000, 28 * 28))
test_images <- test_images / 255

#Categorically encode labels
train_labels<-to_categorical(train_labels)
test_labels<-to_categorical(test_labels)

# Train the model on our test data
network %>% fit(train_images, train_labels, epochs = 5, batch_size = 128)

# Evaluate our Neural Network
metrics <- network %>% evaluate(test_images, test_labels)
metrics # Output our metrics

network %>% predict_classes(test_images[1:10,])
