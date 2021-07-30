library(keras)
mnist <- dataset_mnist()
train_images <- mnist$train$x
train_labels <- mnist$train$y
test_images <- mnist$test$x
test_labels <- mnist$test$y

# Inspect
length(dim(train_images))
dim(train_images)
typeof(train_images)

# Plot
digit <- train_images[15831,,]
digit
plot(as.raster(digit, max = 255))