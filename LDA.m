
holdoutCVP = cvpartition(label,'holdout',304)
dataTrain = pep_feature(holdoutCVP.training,:);
grpTrain = label(holdoutCVP.training);
dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
tenfoldCVP = cvpartition(grpTrain,'kfold',10)

classf = @(xtrain,ytrain,xtest,ytest) ...
            sum(predict(fitcdiscr(...
    xtrain, ...
    ytrain, ...
    'DiscrimType','diaglinear'),xtest) ~= ytest);


fsLocal = sequentialfs(classf,dataTrain,grpTrain,'cv',tenfoldCVP);

testMCELocal = crossval(classf,pep_feature(:,fsLocal),label,'partition',...
    holdoutCVP)/holdoutCVP.TestSize