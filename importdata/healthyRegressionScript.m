%healthyRegressionScript.m

load('featureVector.mat');
%remember to save workspace because randomness means it'll be different each time
features=cell2mat([featureVector(:,4:end)]);
age=cell2mat(featureVector(:,2));
%augment featurevector with column of ones to calculate bias term (intercept)
features = [ones(size(features,1),1) features];
%calculate mean squared error and rmse, check residual values first... they might be studentized

[RMSE,MSE,coeffs]=kfoldcvLinearRegression(age,features,10);
%tests for assumptions - http://people.duke.edu/~rnau/testing.htm
%linearity test, appears to pass
 plot(age(indices==1),preds(:,1),'bx');
 axis equal;
 hold on;
 plot([0 100],[0 100],'r-');
 hold off;

%homoscedascity test
 %plot(age(indices==1), )

%construct reduced feature space averaging over all brain regions
reducedFeatures=[features(:,1) mean(features(:,2:6:end),2) mean(features(:,3:6:end),2) mean(features(:,4:6:end),2) mean(features(:,5:6:end),2) mean(features(:,6:6:end),2) mean(features(:,7:6:end),2)];
% reducedFeatures:
% biascolumn deltapowers thetapowers alphapowers beta1powers beta2powers gammapowers
[reducedRMSE,reducedMSE,~]=kfoldcvLinearRegression(age,reducedFeatures);
quadreducedFeatures=[reducedFeatures(:,1) reducedFeatures(:,2:end) reducedFeatures(:,2:end).^2];
[quadreducedRMSE,quadreducedMSE,~]=kfoldcvLinearRegression(age,quadreducedFeatures);


%The unreduced feature set does better on the test set (thus not overfitting), than the reduced set, or the quad reduced set, but still pretty bad...
%create weighted average of coefficients for alz data, weight by reciprocal of RMSE

weights = repmat((RMSE.^(-1)),size(coeffs,1),1);
wavgcoeffs=sum(coeffs.*weights,2)./sum(weights,2);

alzFV = load('alzFeatureVector.mat');
alzFeatureVector=alzFV.featureVector;
alzFeatures=cell2mat([alzFeatureVector(:,5:end)]);
alzAge=cell2mat(alzFeatureVector(:,2));
%augment featurevector with column of ones to calculate bias term (intercept)
alzFeatures = [ones(size(alzFeatures,1),1) alzFeatures];

%calculate residuals
%bootstrap residuals to compute MSE estimates / RMSE estimates

alzPreds=sum(repmat(wavgcoeffs',size(alzFeatures,1),1).*alzFeatures,2);
alzResiduals=alzAge-alzPreds;
alzSquaredErr=alzResiduals.^2;

alzMSE=cell(1500,1);
maxB=1500;
for i = 1:maxB
	if mod(i,15)==0
		(i/maxB)*100
	end

alzMSE{i}=bootstrp(i,@mean, alzSquaredErr);
end
alzRMSE=cellfun(@sqrt, alzMSE ,'UniformOutput', false);
meanMSE=cellfun(@mean, alzMSE ,'UniformOutput', false);
alzRMSEmean=mean(alzRMSE{1500});
alzRMSEstd=std(alzRMSE{1500});
plot(1:1500,cell2mat(meanMSE),'bx')
xlabel('Number of bootstrap iterations');
ylabel('Mean of MSE estimates');
print('alzbootstrapMSEplot.eps','-depsc2');


%MCI stats


mciFV = load('mciFeatureVector.mat');
mciFeatureVector=mciFV.featureVector;
mciFeatures=cell2mat([mciFeatureVector(:,5:end)]);
mciAge=cell2mat(mciFeatureVector(:,2));
%augment featurevector with column of ones to calculate bias term (intercept)
mciFeatures = [ones(size(mciFeatures,1),1) mciFeatures];

%calculate residuals
%bootstrap residuals to compute MSE estimates / RMSE estimates

mciPreds=sum(repmat(wavgcoeffs',size(mciFeatures,1),1).*mciFeatures,2);
mciResiduals=mciAge-mciPreds;
mciSquaredErr=mciResiduals.^2;

mciMSE=cell(1500,1);
maxB=1500;
for i = 1:maxB
	if mod(i,15)==0
		(i/maxB)*100
	end

mciMSE{i}=bootstrp(i,@mean, mciSquaredErr);
end
mciRMSE=cellfun(@sqrt, mciMSE ,'UniformOutput', false);
meanmciMSE=cellfun(@mean, mciMSE ,'UniformOutput', false);
mciRMSEmean=mean(mciRMSE{1500});
mciRMSEstd=std(mciRMSE{1500});
xlabel('Number of bootstrap iterations');
ylabel('Mean of MSE estimates');
print('mcibootstrapMSEplot.eps','-depsc2');
plot(1:1500,cell2mat(meanmciMSE),'bx')









%alzRMSE=sqrt(alzMSE);
%plot(alzRMSE);










