%healthyRegressionScript.m

load('featureVector.mat');
%remember to save workspace because randomness means it'll be different each time
features=cell2mat([featureVector(:,4:end)]);
age=cell2mat(featureVector(:,2));
%augment featurevector with column of ones to calculate bias term (intercept)
features = [ones(size(features,1),1) features];
%calculate mean squared error and rmse, check residual values first... they might be studentized

[RMSE,MSE,coeffs]=kfoldcvLinearRegression(age,features);
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

preds=sum(repmat(wavgcoeffs',size(features,1),1).*features,2);

residuals=age-preds;



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


hold off;

plot((-1.*alzResiduals),[alzFeatureVector{:,4}],'r.');
hold on;
plot((-1.*mciResiduals),[mciFeatureVector{:,4}],'b.');
alzp=polyfit((-1.*alzResiduals),[alzFeatureVector{:,4}]',1);
alzfit=polyval(alzp,(-1.*alzResiduals));
alzfit2=polyval(alzp,-60:20);
alzcogresiduals=[alzFeatureVector{:,4}]'-alzfit;
alzssresid=sum(alzcogresiduals.^2)
alzsstotal=(length([alzFeatureVector{:,4}])-1)*var([alzFeatureVector{:,4}]);
alzrsq=1-(alzssresid/alzsstotal);
plot(-60:20,alzfit2,'r-');

mcip=polyfit((-1.*mciResiduals),[mciFeatureVector{:,4}]',1);
mcifit=polyval(mcip,(-1.*mciResiduals));
mcifit2=polyval(mcip,-60:20);
mcicogresiduals=[mciFeatureVector{:,4}]'-mcifit;
mcissresid=sum(mcicogresiduals.^2)
mcisstotal=(length([mciFeatureVector{:,4}])-1)*var([mciFeatureVector{:,4}]);
mcirsq=1-(mcissresid/mcisstotal);
plot(-60:20,mcifit2,'b-');
hold off;
hold on;
ytot=[alzFeatureVector{:,4} mciFeatureVector{:,4}]';
xtot=[(-1*alzResiduals);(-1.*mciResiduals)];
totp=polyfit(xtot,ytot,1);
totfit=polyval(totp,xtot);
totfit2=polyval(totp,-60:20);
totcogresiduals=ytot-totfit;
totssresid=sum(totcogresiduals.^2)
totsstotal=(length(ytot)-1)*var(ytot);
totrsq=1-(totssresid/totsstotal);
plot(-60:20,totfit2,'k-');
hold off;
ylabel('MMSE score');
xlabel('Predicted Age - Actual Age');
legend('Alzheimers','MCI','Location','SouthWest');
print('cogscorecorrel.eps','-depsc2');

%alzRMSE=sqrt(alzMSE);
%plot(alzRMSE);

%Classification
%generate class labels
hold off;
[Y{1:size(featureVector,1)}]=deal('Healthy');
[Y{size(featureVector,1)+1:size(featureVector,1)+size(alzFeatureVector,1)}]=deal('Alz');
[Y{size(featureVector,1)+size(alzFeatureVector,1)+1:size(featureVector,1)+size(alzFeatureVector,1)+size(mciFeatureVector,1)}]=deal('MCI');
Y=Y';
X=[residuals;alzResiduals;mciResiduals];
tic
cv = fitensemble(X,Y,'RUSBoost',1500,'Tree','kfold',10,'nprint',100,'LearnRate',0.1);
toc
plot(kfoldLoss(cv,'mode','cumulative'),'r-');

xlabel('Number of trees');
ylabel('Classification error');
print('resid1500treesCVerror.eps','-depsc2');
[Yfit,Sfit] = kfoldPredict(cv); % 
confusionmat(cv.Y,Yfit,'order',{'Healthy','Alz','MCI'})

L = kfoldLoss(cv)

hold off;
X2=[features(:,2:end);alzFeatures(:,2:end);mciFeatures(:,2:end)];
tic
cv2 = fitensemble(X2,Y,'RUSBoost',1500,'Tree','kfold',10,'nprint',100,'LearnRate',0.1);
toc
plot(kfoldLoss(cv2,'mode','cumulative'),'r-');

xlabel('Number of trees');
ylabel('Classification error');
print('full1500treesCVerror.eps','-depsc2');
[Yfit2,Sfit2] = kfoldPredict(cv2); % 
confusionmat(cv2.Y,Yfit2,'order',{'Healthy','Alz','MCI'})

















