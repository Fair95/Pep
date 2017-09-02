load('pep.mat')
pep_feature = pep_feature(:,[1:544,544*2+1:544*5,544*6+1:end]);

[pep_feature, mu, sigma] = featureNormalize(pep_feature);
learner = [pep_feature label];