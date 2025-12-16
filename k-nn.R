set.seed(123)
# importing the dataset
wdbc <- wdbc # has dataset
glimpse(wdbc)

# data preparation 
colnames(wdbc) <- c('diagnosis', 'radius_mean', 'texture_mean', 'perimeter_mean', 
                    'area_mean', 'smoothness_mean', 'compactness_mean', 'concavity_mean', 
                    'concave_points_mean', 'symmetry_mean', 'fractal_dimension_mean', 
                    'radius_se', 'texture_se', 'perimetr_se', 'area_se', 'smoothness_se', 
                    'compactness_se', 'concavity_se', 'concave_point_se', 'symmetry_se', 
                    'fractal_dimmension_se', 'radius_worst', 'texture_worst', 'perimeter_worst', 
                    'area_worst', 'smoothness_worst', 'compactness_worst', 'concavity_worst', 
                    'concave_points_worst', 'symmetry_worst', 'fractal_dimension_worst')
# saving the dataset. 
sum(is.na(wdbc))
write.csv(wdbc, 'wdbc.csv')

#EDA
summary(wdbc)
table(wdbc$diagnosis)
wdbc <- wdbc [-1]
glimpse(wdbc) # to check structure of a dataset

#factorise the diagnosis 
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c('B','M'), 
                         labels = c('Benign', 'Malignant')) # to make diagnosis a lebel colunm 
is.factor(wdbc$diagnosis)
round(prop.table(table(wdbc$diagnosis)) * 100, 1)

# normalize numeric data 
normalize <- function(x) {
  return((x-min(x)) / (max(x) - min(x)))
}

wdbc_n <- as.data.frame(lapply(wdbc[2:31], normalize))

# creating training and testing data in 82 17
wdbc_train <- wdbc_n[1:469, ]
wdbc_test <- wdbc_n[470:569, ]
glimpse(wdbc_test)
glimpse(wdbc_train)
(nrow(wdbc_test)/569) * 100
(nrow(wdbc_train)/569) * 100

# creating label training and testing 
wdbc_train_labels <- wdbc[1:469, 1]
wdbc_test_labels <- wdbc[470:569, 1]

# training a model on the data 
library(class)
#choosing right k
k <- floor(sqrt(nrow(wdbc_train)))
k

# knn 
wdbc_test_pred <- knn(train = wdbc_train, test = wdbc_test, 
                      cl = wdbc_train_labels, k)

# evaluation 
library(gmodels) # for evaluation 
CrossTable (x = wdbc_test_labels, y = wdbc_test_pred, 
            prop.chiq = F)

#improving model 
wdbc_z <- as.data.frame(scale(wdbc[-1]))
summary(wdbc_z)
wdbc_train <- wdbc_z[1:469, ]
wdbc_test <- wdbc_z[470:569, ] 

# knn 
wdbc_test_pred <- knn(train = wdbc_train, test = wdbc_test, 
                      cl = wdbc_train_labels, k = 21)

# evaluation 
CrossTable (x = wdbc_test_labels, y = wdbc_test_pred, 
            prop.chiq = F)

#testing alternative value of k 
k_value <- c(1, 5, 11, 15, 21, 27)
for(k_val in k_value) {
  wdbc_test_pred <- knn(train = wdbc_train, test = wdbc_test, 
                        cl = wdbc_train_labels, k = 21)
  CrossTable (x = wdbc_test_labels, y = wdbc_test_pred, 
              prop.chiq = F)
}


# accuracy 
(21 + 77) / 100

# sensitifity 
21 / (21 + 2)

# specificity 
77 / (77 + 0)

# precision 
21 / (21 + 0)

# tune k value 
k_values <- seq(3, 25, by = 2)  # odd values avoid ties

# Train and evaluate KNN for each k
results <- data.frame(k = integer(),
                      accuracy = numeric(),
                      sensitivity = numeric(),
                      specificity = numeric())

for (k in k_values) {
  
  pred <- knn(train = wdbc_train,
              test  = wdbc_test,
              cl    = wdbc_train_labels,
              k     = k)
  
  tab <- table(wdbc_test_labels, pred)
  
  TP <- tab["Malignant", "Malignant"]
  TN <- tab["Benign", "Benign"]
  FP <- tab["Benign", "Malignant"]
  FN <- tab["Malignant", "Benign"]
  
  acc <- (TP + TN) / sum(tab)
  sens <- TP / (TP + FN)        # very important
  spec <- TN / (TN + FP)
  
  results <- rbind(results,
                   data.frame(k, acc, sens, spec))
}

# visualization 
library(ggplot2)
ggplot(results, aes(x = k)) +
  geom_line(aes(y = acc, color = "Accuracy")) +
  geom_line(aes(y = sens, color = "Sensitivity")) +
  geom_line(aes(y = spec, color = "Specificity")) +
  labs(title = "KNN Performance vs k WDBC Dataset",
       y = "Metric Value") +
  theme_minimal()


