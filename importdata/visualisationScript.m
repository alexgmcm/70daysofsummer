load('featureVector.mat');

featuresWithAge= cell2mat([featureVector(:,2) featureVector(:,4:end)]);
reducedFeaturesWithAge= [featuresWithAge(:,1) mean(featuresWithAge(:,2:6:end),2) mean(featuresWithAge(:,3:6:end),2) mean(featuresWithAge(:,4:6:end),2) mean(featuresWithAge(:,5:6:end),2) mean(featuresWithAge(:,6:6:end),2) mean(featuresWithAge(:,7:6:end),2)];
hFifties=reducedFeaturesWithAge(((50<=reducedFeaturesWithAge(:,1)) & (reducedFeaturesWithAge(:,1)<=59)),:);
hSixties=reducedFeaturesWithAge(((60<=reducedFeaturesWithAge(:,1)) & (reducedFeaturesWithAge(:,1)<=69)),:);
hSeventies=reducedFeaturesWithAge(((70<=reducedFeaturesWithAge(:,1)) & (reducedFeaturesWithAge(:,1)<=79)),:);
hEighties=reducedFeaturesWithAge(((80<=reducedFeaturesWithAge(:,1)) & (reducedFeaturesWithAge(:,1)<=89)),:);
glyphplot([mean(hFifties(:,2:end),1);mean(hSixties(:,2:end),1);mean(hSeventies(:,2:end),1);mean(hEighties(:,2:end),1)],'glyph','face');
print('hChernoffFaces50607080.eps','-depsc2');

labels = {'delta','theta', 'alpha','beta1','beta2','gamma'};
[hgroup{1:size(hFifties,1)}]=deal('Fifties');
[hgroup{size(hFifties,1)+1:size(hFifties,1)+size(hSixties,1)}]=deal('Sixties');
[hgroup{size(hFifties,1)+size(hSixties)+1:size(hFifties,1)+size(hSixties,1)+size(hSeventies,1)}]=deal('Seventies');
[hgroup{size(hFifties,1)+size(hSixties,1)+size(hSeventies,1)+1:size(hFifties,1)+size(hSixties,1)+size(hSeventies,1)+size(hEighties)}]=deal('Eighties');
parallelcoords([hFifties(:,2:end);hSixties(:,2:end);hSeventies(:,2:end);hEighties(:,2:end);],'group',hgroup,'labels',labels);
print('hparacoords.eps','-depsc2');


alzFV = load('alzFeatureVector.mat');
alzFeatureVector=alzFV.featureVector;
alzFeaturesWithAge = cell2mat([alzFeatureVector(:,2) alzFeatureVector(:,5:end) ]);
alzReducedFeaturesWithAge= [alzFeaturesWithAge(:,1) mean(alzFeaturesWithAge(:,2:6:end),2) mean(alzFeaturesWithAge(:,3:6:end),2) mean(alzFeaturesWithAge(:,4:6:end),2) mean(alzFeaturesWithAge(:,5:6:end),2) mean(alzFeaturesWithAge(:,6:6:end),2) mean(alzFeaturesWithAge(:,7:6:end),2)];
alzFifties=alzReducedFeaturesWithAge(((50<=alzReducedFeaturesWithAge(:,1)) & (alzReducedFeaturesWithAge(:,1)<=59)),:);
alzSixties=alzReducedFeaturesWithAge(((60<=alzReducedFeaturesWithAge(:,1)) & (alzReducedFeaturesWithAge(:,1)<=69)),:);
alzSeventies=alzReducedFeaturesWithAge(((70<=alzReducedFeaturesWithAge(:,1)) & (alzReducedFeaturesWithAge(:,1)<=79)),:);
alzEighties=alzReducedFeaturesWithAge(((80<=alzReducedFeaturesWithAge(:,1)) & (alzReducedFeaturesWithAge(:,1)<=89)),:);
glyphplot([mean(alzFifties(:,2:end),1);mean(alzSixties(:,2:end),1);mean(alzSeventies(:,2:end),1);mean(alzEighties(:,2:end),1)],'glyph','face');
print('alzChernoffFaces50607080.eps','-depsc2');

labels = {'delta','theta', 'alpha','beta1','beta2','gamma'};
[alzgroup{1:size(alzFifties,1)}]=deal('Fifties');
[alzgroup{size(alzFifties,1)+1:size(alzFifties,1)+size(alzSixties,1)}]=deal('Sixties');
[alzgroup{size(alzFifties,1)+size(alzSixties)+1:size(alzFifties,1)+size(alzSixties,1)+size(alzSeventies,1)}]=deal('Seventies');
[alzgroup{size(alzFifties,1)+size(alzSixties,1)+size(alzSeventies,1)+1:size(alzFifties,1)+size(alzSixties,1)+size(alzSeventies,1)+size(alzEighties)}]=deal('Eighties');
parallelcoords([alzFifties(:,2:end);alzSixties(:,2:end);alzSeventies(:,2:end);alzEighties(:,2:end);],'group',alzgroup,'labels',labels);
print('alzparacoords.eps','-depsc2');


mciFV = load('mciFeatureVector.mat');
mciFeatureVector=mciFV.featureVector;
mciFeaturesWithAge = cell2mat([mciFeatureVector(:,2) mciFeatureVector(:,5:end) ]);
mciReducedFeaturesWithAge= [featuresWithAge(:,1) mean(featuresWithAge(:,2:6:end),2) mean(featuresWithAge(:,3:6:end),2) mean(featuresWithAge(:,4:6:end),2) mean(featuresWithAge(:,5:6:end),2) mean(featuresWithAge(:,6:6:end),2) mean(featuresWithAge(:,7:6:end),2)];
%mciFifties=mciReducedFeaturesWithAge(((50<=mciReducedFeaturesWithAge(:,1)) & (mciReducedFeaturesWithAge(:,1)<=59)),:); NO PPL
mciSixties=mciReducedFeaturesWithAge(((60<=mciReducedFeaturesWithAge(:,1)) & (mciReducedFeaturesWithAge(:,1)<=69)),:);
mciSeventies=mciReducedFeaturesWithAge(((70<=mciReducedFeaturesWithAge(:,1)) & (mciReducedFeaturesWithAge(:,1)<=79)),:);
mciEighties=mciReducedFeaturesWithAge(((80<=mciReducedFeaturesWithAge(:,1)) & (mciReducedFeaturesWithAge(:,1)<=89)),:);
glyphplot([mean(mciSixties(:,2:end),1);mean(mciSeventies(:,2:end),1);mean(mciEighties(:,2:end),1)],'glyph','face');
print('mciChernoffFaces607080.eps','-depsc2');


labels = {'delta','theta', 'alpha','beta1','beta2','gamma'};
%[mcigroup{1:size(mciFifties,1)}]=deal('Fifties');
[mcigroup{1:size(mciSixties,1)}]=deal('Sixties');
[mcigroup{size(mciSixties)+1:size(mciSixties,1)+size(mciSeventies,1)}]=deal('Seventies');
[mcigroup{size(mciSixties,1)+size(mciSeventies,1)+1:size(mciSixties,1)+size(mciSeventies,1)+size(mciEighties)}]=deal('Eighties');
parallelcoords([mciSixties(:,2:end);mciSeventies(:,2:end);mciEighties(:,2:end);],'group',mcigroup,'labels',labels);
print('mciparacoords.eps','-depsc2');
%deltarp - Size of face
%thetarp - Forehead/jaw relative arc length
%alpharp - Shape of forehead
%beta1rp - Shape of jaw
%beta2rp - Width between eyes
%beta3rp - Vertical position of eyes