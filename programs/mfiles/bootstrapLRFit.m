function [MSE, RMSE] = bootstrapLRFit(coeffs,features,age)

	%calculate residuals
	%bootstrap residuals to compute MSE estimates / RMSE estimates

	%assume features are already augmented with bias column of ones
	preds=sum(repmat(coeffs',size(features,1),1).*features,2);
	residuals=age-preds;
	squaredErr=residuals.^2;
	

