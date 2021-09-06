library(keras)

# Convnet
model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, 
                kernel_size = c(3,3), 
                activation = "relu", 
                input_shape = c(28, 28, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2,2))  %>%
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = "relu")

# Adding the classification layers
model <- model %>%
  layer_flatten() %>%
  layer_dense(units = 64, activation = "relu") %>%
  layer_dense(units = 10, activation = "softmax")

# Get the data
mnist <- dataset_mnist()

# Destructuring into local variables
c(c(train_images, train_labels), c(test_images, test_labels)) %<-% mnist
train_images
train_labels

# Redundant - but we are ensuring the data exists as we expect it to. 60k images, 28x28, 1 channel 
train_images <- array_reshape(train_images, c(60000,28,28,1))
# Normalize 0:1. All values fall between 0 and 255
train_images <- train_images / 255

test_images <- array_reshape(test_images, c(10000,28,28,1))
test_images <- test_images / 255

# Translate annotations from literal representation to one-hot encoded vectors
train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)

model %>% compile(
  
  optimizer = "rmsprop",
  loss = "categorical_crossentropy",
  metrics = c("accuracy")
  
)

model %>% fit(
  
  train_images, train_labels,
  epochs = 5, batch_size = 64
  
)
# Evaluate our Neural Network
metrics <- model %>% evaluate(test_images, test_labels)
metrics # Output our metrics

network %>% predict_classes(test_images[1:10,])






