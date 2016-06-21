%% CLearing all the variables
clc;
clear all;
path(path,'C:\Users\Rachana\Documents\Rutgers-MBS\Analytics_Practicum\Assignment_1');
%% Loading the dataset
load('HW1Dataset (1).mat');


M= mean(data);  %% Calculating the mean of each column
S =std(data);   %% Calculating the standard deviation of each column  

%% Normallizing the data with the mean 0 and std 1
for i= 1: 23040
    for j= 1:8
        dataN(i,j)=(data(i,j) - M(1,j))/S(1,j);
    end
end

%% Looping over the range of cvind for 10 cross fold validation
for k = 1:10

    x= find(cvind~=k);
    y= find(cvind==k);

    %% Partioning the the data in training and test data (9:1) by keeping the data 
    %% with the having indices referring to the kth value of cvind in the test and rest in the 
    %% training data set

    dataTrain= dataN(x,:);
    dataTest= dataN(y,:);

    %% Partioning the labels as well

    labelsTrain = labels(x);
    labelsTest= labels(y);

    %% Converting it to Numeric Vector
    %% labelsTrain = labelsTrain +0;
    %%labelsTest= labelsTest+0;

    %% Fitting the Support vector machine with the fitcsvm command
   svm=fitcsvm(dataTrain,labelsTrain,'Standardize',false,'ClassNames',[0,1]);

   %%Predicting the Training Class
   trainPredict= predict(svm,dataTrain);
  
    
    %% Getting the class performance for the training data set
    cp = classperf(labelsTrain,'Positive',1, 'Negative', 0);
    cp= classperf(cp,trainPredict);

     %% Extracting the values of accuracy , Senstivity and Specificity  for each of the 10 folds and string in a vector of size 10
    accuracy(k)=cp.CorrectRate;
    sensitivity(k)= cp.Sensitivity;
    specificity(k)=cp.Specificity;

   
    %%Predicting the Test Class
    testPredict = predict(svm, dataTest);
    
    %% Evaluating the perdiction performance on the test set
    cpTest = classperf(labelsTest,'Positive',1, 'Negative', 0);
    cpTest= classperf(cpTest,testPredict);

    %% Extracting the values of accuracy , Senstivity and Specificity  for each of the 10 folds and storing in a vector of size 10
    accuracy2(k)=cpTest.CorrectRate;
    sensitivity2(k)= cpTest.Sensitivity;
    specificity2(k)=cpTest.Specificity;

end


%% Taking the mean of accuracy ,Senstivity and Specificity for the training set over all the 10 folds
accLR= mean(accuracy)
SensitivityLR= mean(sensitivity)
specificityLR = mean(specificity)

%% Taking the mean of accuracy ,Senstivity and Specificity for the training set over all the 10 folds
accLR2= mean(accuracy2)
SensitivityLR2= mean(sensitivity2)
specificityLR2 = mean(specificity2)
