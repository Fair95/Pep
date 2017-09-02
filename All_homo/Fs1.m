close all
clear
load('All_homo/pep.mat')
%load('pep_feature.mat');
holdoutCVP = cvpartition(label,'holdout',874)
dataTrain = pep_feature(holdoutCVP.training,:);
grpTrain = label(holdoutCVP.training);
dataTrainG1 = pep_feature(grp2idx(label)==1,:);
dataTrainG2 = pep_feature(grp2idx(label)==2,:);
[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');
ecdf(p);
xlabel('P value');
ylabel('CDF value')
fs1 = featureIdxSortbyP(1:0.55*size(pep_feature,2));
pep_feature = pep_feature(:,fs1);

learner = [pep_feature label];