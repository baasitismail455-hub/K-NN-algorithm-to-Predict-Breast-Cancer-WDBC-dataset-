This project applies the K-Nearest Neighbors (K-NN) machine learning algorithm to predict breast cancer diagnosis (Benign vs Malignant) using the Wisconsin Diagnostic Breast Cancer (WDBC) dataset.

The goal is to demonstrate how a distance-based, lazy learning algorithm can be effectively used in a real-world healthcare problem, while carefully addressing data preprocessing, normalization, model tuning, and evaluation.

Early and accurate detection of breast cancer significantly improves patient outcomes.
Using clinical features extracted from digitized images of breast mass biopsies, this project builds a binary classification model to predict whether a tumor is Benign or Malignant.

Dataset description 
glimpse(wdbc) # to check structure of a dataset
Rows: 569
Columns: 31. 
Simply the dataset contains 30 numeric prediction that contain tumor data such as radius, texture, symmmetry and others, also it contains a targeted variable Diagnosis, B = Bening, M = Malignat. 

K-NN algorith is then implemented in just 5 steps.
Step 1: Data cleaning and Normalization (function(x) { return((x-min(x)) / (max(x) - min(x))) }). 
Step2: Spliting the data into traing and test data in 4:1 
Step 3: Selecting the right K using k = sqrt(n) n is number of row in train. 
Step 4: knn() funtion which takes four arguments i. train, ii. test, iii. class (cl), iv. k (closet), 
Step 5: Evaluation by using using CrossTable() function to create a confusion metrix 

And so finaly interpretation of confusion metrix 
True Positive 21, True Negative = 77, False Positive (type 1 error) = 0, and False Negative (type 2 error) = 2. 
accuracy is 98% ( TP + TN / Total) 
sensitivity is 91% (TP/ TP - FP) 
specificity is 100%
precision is also 100% 
