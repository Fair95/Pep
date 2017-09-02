close all
clear
load('All_homo/pep.mat')
%load('pep_feature.mat');
holdoutCVP = cvpartition(label,'holdout',874)
dataTrain = pep_feature(holdoutCVP.training,:);
grpTrain = label(holdoutCVP.training);
dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');
ecdf(p);
xlabel('P value');
ylabel('CDF value')

classf = @(xtrain,ytrain,xtest,ytest) ...
            sum(predict(fitcsvm(...
    xtrain, ...
    ytrain, ...
    'KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], ...
    'KernelScale', 5.8, ...
    'BoxConstraint', 11, ...
    'Standardize', true, ...
    'ClassNames', [-1; 1]),xtest) ~= ytest);
  [~,featureIdxSortbyP] = sort(p,2);       
tenfoldCVP = cvpartition(grpTrain,'kfold',10)

fs1 = featureIdxSortbyP(1:250);
testMCELocal1 = crossval(classf,pep_feature(:,fs1),label,'partition',...
    holdoutCVP)/holdoutCVP.TestSize
fsLocal = sequentialfs(classf,dataTrain(:,fs1),grpTrain,'cv',tenfoldCVP);
fs1(fsLocal)

testMCELocal2 = crossval(classf,pep_feature(:,fs1(fsLocal)),label,'partition',...
    holdoutCVP)/holdoutCVP.TestSize

[fsCVfor50,historyCV] = sequentialfs(classf,dataTrain(:,fs1),grpTrain,...
    'cv',tenfoldCVP,'Nf',100);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with cross-validation');