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

%tsne plot and pca need to use full dataset not reduced
hfullFifties=featuresWithAge(((50<=featuresWithAge(:,1)) & (featuresWithAge(:,1)<=59)),:);
hfullSixties=featuresWithAge(((60<=featuresWithAge(:,1)) & (featuresWithAge(:,1)<=69)),:);
hfullSeventies=featuresWithAge(((70<=featuresWithAge(:,1)) & (featuresWithAge(:,1)<=79)),:);
hfullEighties=featuresWithAge(((80<=featuresWithAge(:,1)) & (featuresWithAge(:,1)<=89)),:);
mappedX=tsne([hfullFifties(:,2:end);hfullSixties(:,2:end);hfullSeventies(:,2:end);hfullEighties(:,2:end)],[],2,30,30);
gscatter(mappedX(:,1),mappedX(:,2),hgroup','bgrcmyk','.');
axis off;
print('htsneplot.eps','-depsc2');

varLabels={'delta','theta','alpha','beta1','beta2','gamma'};
[healthypc,healthyscore,healthylatent] = princomp([hFifties(:,2:end);hSixties(:,2:end);hSeventies(:,2:end);hEighties(:,2:end)]);
healthyVariance=cumsum(healthylatent)./sum(healthylatent);
%mfig('Bi-Plot: Standardized Data');
hbi = biplot(healthypc(:,1:2), ...
    'Scores', healthyscore(:,1:2), ...
    'VarLabels', varLabels, ...
    'ObsLabels', hgroup', ...
    'markersize', 15 ...
);
title('PCA Plot: Components explain 86.76% of variance');
%xlabel('Bi-Plot: Standardized Data');
xlabel('PCA1');
ylabel('PCA2');
 
% Manipulate plot colors
for ii = 1:length(hbi)-length([hFifties(:,2:end);hSixties(:,2:end);hSeventies(:,2:end);hEighties(:,2:end)])
    set(hbi(ii), 'Color', [0.2 0.2 0.2]);
end
for ii = length(hbi)-length([hFifties(:,2:end);hSixties(:,2:end);hSeventies(:,2:end);hEighties(:,2:end)]):length(hbi)
    userdata = get(hbi(ii), 'UserData');
    if ~isempty(userdata)
        if strcmp(hgroup{userdata},'Fifties') == 1
            set(hbi(ii), 'Color', 'g');
        elseif strcmp(hgroup{userdata},'Sixties') == 1
            set(hbi(ii), 'Color', 'b');
        elseif strcmp(hgroup{userdata},'Seventies') == 1
            set(hbi(ii), 'Color', 'r');
        elseif strcmp(hgroup{userdata},'Eighties') == 1
            set(hbi(ii), 'Color', 'm');
        end
    else
        set(hbi(ii), 'Color', 'k');
    end
end
print('pcahealthyplot.eps','-depsc2');



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

alzfullFifties=alzFeaturesWithAge(((50<=alzFeaturesWithAge(:,1)) & (alzFeaturesWithAge(:,1)<=59)),:);
alzfullSixties=alzFeaturesWithAge(((60<=alzFeaturesWithAge(:,1)) & (alzFeaturesWithAge(:,1)<=69)),:);
alzfullSeventies=alzFeaturesWithAge(((70<=alzFeaturesWithAge(:,1)) & (alzFeaturesWithAge(:,1)<=79)),:);
alzfullEighties=alzFeaturesWithAge(((80<=alzFeaturesWithAge(:,1)) & (alzFeaturesWithAge(:,1)<=89)),:);
alzmappedX=tsne([alzfullFifties(:,2:end);alzfullSixties(:,2:end);alzfullSeventies(:,2:end);alzfullEighties(:,2:end)],[],2,30,30);
hold off;
gscatter(alzmappedX(:,1),alzmappedX(:,2),alzgroup','bgrcmyk','.');
axis off;
print('alztsneplot.eps','-depsc2');












mciFV = load('mciFeatureVector.mat');
mciFeatureVector=mciFV.featureVector;
mciFeaturesWithAge = cell2mat([mciFeatureVector(:,2) mciFeatureVector(:,5:end) ]);
mciReducedFeaturesWithAge= [mciFeaturesWithAge(:,1) mean(mciFeaturesWithAge(:,2:6:end),2) mean(mciFeaturesWithAge(:,3:6:end),2) mean(mciFeaturesWithAge(:,4:6:end),2) mean(mciFeaturesWithAge(:,5:6:end),2) mean(mciFeaturesWithAge(:,6:6:end),2) mean(mciFeaturesWithAge(:,7:6:end),2)];
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
%gammarp - Vertical position of eyes


%mcifullFifties=mciFeaturesWithAge(((50<=mciFeaturesWithAge(:,1)) & (mciFeaturesWithAge(:,1)<=59)),:);
mcifullSixties=mciFeaturesWithAge(((60<=mciFeaturesWithAge(:,1)) & (mciFeaturesWithAge(:,1)<=69)),:);
mcifullSeventies=mciFeaturesWithAge(((70<=mciFeaturesWithAge(:,1)) & (mciFeaturesWithAge(:,1)<=79)),:);
mcifullEighties=mciFeaturesWithAge(((80<=mciFeaturesWithAge(:,1)) & (mciFeaturesWithAge(:,1)<=89)),:);
mcimappedX=tsne([mcifullSixties(:,2:end);mcifullSeventies(:,2:end);mcifullEighties(:,2:end)],[],2,18,30);
hold off;
gscatter(mcimappedX(:,1),mcimappedX(:,2),mcigroup','bgrcmyk','.');
axis off;
print('pmciPCAtsneplot.eps','-depsc2');




%total tsne
[totGroup{1:size(hgroup,2)}]=deal('Healthy');
[totGroup{size(hgroup,2)+1:size(hgroup,2)+size(alzgroup,2)}]=deal('Alzheimers');
[totGroup{size(hgroup,2)+size(alzgroup,2)+1:size(hgroup,2)+size(alzgroup,2)+size(mcigroup,2)}]=deal('MCI');
totmappedX=tsne([hfullFifties(:,2:end);hfullSixties(:,2:end);hfullSeventies(:,2:end);hfullEighties(:,2:end);alzfullFifties(:,2:end);alzfullSixties(:,2:end);alzfullSeventies(:,2:end);alzfullEighties(:,2:end);mcifullSixties(:,2:end);mcifullSeventies(:,2:end);mcifullEighties(:,2:end)],[],2,30,30);
hold off;
gscatter(totmappedX(:,1),totmappedX(:,2),totGroup','bgrcmyk','.');
axis off;
print('tottsneplot.eps','-depsc2');

[seventiesGroup{1:size(hfullSeventies,1)}]=deal('Healthy');
[seventiesGroup{size(hfullSeventies,1)+1:size(hfullSeventies,1)+size(alzfullSeventies,1)}]=deal('Alzheimers');
[seventiesGroup{size(hfullSeventies,1)+size(alzfullSeventies,1)+1:size(hfullSeventies,1)+size(alzfullSeventies,1)+size(mcifullSeventies,1)}]=deal('MCI');
seventiesMappedX=tsne([hfullSeventies(:,2:end);alzfullSeventies(:,2:end);mcifullSeventies(:,2:end)],[],2,30,30);
hold off;
gscatter(seventiesMappedX(:,1),seventiesMappedX(:,2),seventiesGroup','bgrcmyk','.');
axis off;
print('seventiestsneplot.eps','-depsc2');


totdata=[hFifties(:,2:end);hSixties(:,2:end);hSeventies(:,2:end);hEighties(:,2:end);alzFifties(:,2:end);alzSixties(:,2:end);alzSeventies(:,2:end);alzEighties(:,2:end);mciSixties(:,2:end);mciSeventies(:,2:end);mciEighties(:,2:end)];
varLabels={'delta','theta','alpha','beta1','beta2','gamma'};
[totalpc,totalscore,totallatent] = princomp([totdata]);
totalVariance=cumsum(totallatent)./sum(totallatent);
%mfig('Bi-Plot: Standardized Data');
hbi = biplot(totalpc(:,1:2), ...
    'Scores', totalscore(:,1:2), ...
    'VarLabels', varLabels, ...
    'ObsLabels', totGroup', ...
    'markersize', 15 ...
);
title('PCA Plot: components explain 86.51% of variance');
%xlabel('Bi-Plot: Standardized Data');
xlabel('PCA1');
ylabel('PCA2');
 
% Manipulate plot colors
for ii = 1:length(hbi)-length([totdata])
    set(hbi(ii), 'Color', [0.2 0.2 0.2]);
end
for ii = length(hbi)-length([totdata]):length(hbi)
    userdata = get(hbi(ii), 'UserData');
    if ~isempty(userdata)
        if strcmp(totGroup{userdata},'Healthy') == 1
            set(hbi(ii), 'Color', 'g');
        elseif strcmp(totGroup{userdata},'Alzheimers') == 1
            set(hbi(ii), 'Color', 'r');
        elseif strcmp(totGroup{userdata},'MCI') == 1
            set(hbi(ii), 'Color', 'y');
        end
    else
        set(hbi(ii), 'Color', 'k');
    end
end
print('pcatotalplot.eps','-depsc2');

