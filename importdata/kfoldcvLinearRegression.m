function [RMSE,MSE, coeffs]=kfoldcvLinearRegression(age,features)
rng(42); %set the random number generator to a predictable value so we can recreate values with each call of this script.
%loads healthy data into featureVector
%10-fold cross-validation
nFolds=10;
%FEATURES SHOULD INCLUDE AUGMENTED INITIAL BIAS COLUMN OF ONES
indices = crossvalind('Kfold', size(features,1), nFolds);

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
