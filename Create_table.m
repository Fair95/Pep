pep_data = importdata('feature/tcell_homo_HLA-A_02_01_9_0.8_aaCompo.tsv');
aa_data = importdata('aaindex1.matrix');
aa_com = aa_data.data;
pep_perc = pep_data.data;

% get peptide-by-feature table
pep_fea = pep_perc*transpose(aa_com);
pep_feature = pep_fea;
[pep_feature,mu,sigma] = featureNormalize(pep_fea);
%%
[pep_perc,mu1,sigma1] = featureNormalize(pep_perc);
pep_feature = [pep_feature pep_perc];
%%
feature = aa_data.textdata(2:end,1);
pep = pep_data.textdata(2:end,3);
Label = pep_data.textdata(2:end,1);
aa = aa_data.textdata(1,2:end);

% convert cell to double
for i = 1:length(Label)
    label(i,1) = str2double(Label(i));
end
learner = [pep_feature label];
% shuffle the dataset
combine = [pep_feature label];
shuffle = combine(randperm(size(combine,1)),:);
pep_feature = shuffle(:,1:end-1);
label = shuffle(:,end);

% divide the dataset into training and testing (8:2)
train_data = pep_feature(1:8*size(pep_feature,1)/10,:);
train_label = label(1:8*size(label,1)/10,:);
test_data = pep_feature(9*size(pep_feature,1)/10:end,:);
test_label = label(9*size(label,1)/10:end,:);

%for i = 1:length(label)
%    if label(i) == -1
%        label(i) = 1;
%    else
%        label(i) = 2 ;
%    end
%end

% save the variables
save('pep_feature.mat');
