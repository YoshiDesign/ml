library(keras)
reuters <- dataset_reuters(num_words=10000)
reuters
c(c(train_data, train_labels),c(test_data,test_labels)) %<-% reuters

# Reverse the word index to sniff it a little
word_index <- dataset_reuters_word_index()
reverse_word_index <- names(word_index)
reverse_word_index
names(reverse_word_index) <- word_index
decoded_newswire <- sapply(train_data[[1]], function(index){
  word <- if (index >= 3) reverse_word_index[[as.character(index - 3)]]
  if (!is.null(word)) word else "?"
})
