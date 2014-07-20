%healthyRegressionScript.m

load('featureVector.mat');
%remember to save workspace because randomness means it'll be different each time
rng(42); %set the random number generator to a predictable value so we can recreate values with each call of this script.
%loads healthy data into featureVector
%10-fold cross-validation
nFolds=10;
features=cell2mat([featureVector(:,4:end)]);
age=cell2mat(featureVector(:,2));
indices = crossvalind('Kfold', size(features,1), nFolds);
%augment featurevector with column of ones to calculate bias term (intercept)
features = [ones(size(features,1),1) features];
coeffs=zeros(size(features,2), nFolds); %create array to store coefficient vectors
residuals=zeros(size(features,1)./nFolds,nFolds);
preds=zeros(size(features,1)./nFolds,nFolds);
MSE=zeros(1,nFolds);
RMSE=zeros(1,nFolds);
for i = 1:nFolds
    test = (indices == i); train = ~test;
    [coeffs(:,i)]  = regress(age(train,:),features(train,:));
    preds(:,i)=sum(repmat(coeffs(:,i)',size(features(test,:),1),1).*features(test,:),2);
    residuals(:,i)=age(test,:) - preds(:,i);
    MSE(i)=sum(residuals(:,i).^2)./(size(residuals,1));
    RMSE(i) = sqrt(MSE(i));

end

%calculate mean squared error and rmse, check residual values first... they might be studentized

%tests for assumptions - http://people.duke.edu/~rnau/testing.htm
%linearity test, appears to pass
 plot(age(indices==1),preds(:,1),'bx');
 axis equal;
 hold on;
 plot([0 100],[0 100],'r-');
 hold off;

%homoscedascity test
 %plot(age(indices==1), )