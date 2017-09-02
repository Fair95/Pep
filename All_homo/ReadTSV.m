%% Read file and extract dataset
files = dir('*.tsv');
numfiles = length(files);
mydata = cell(1,numfiles);
for k = 1:numfiles 
  mydata{k} = importdata(files(k).name); 
end

aaindex = importdata('aaindex1.matrix');


%% format the data and remove duplicates

pep_com_dup = [];
for i = 1:size(mydata,2)
    for j = 1:size(mydata{i}.data,1)
        pep_com_dup = [pep_com_dup; mydata{i}.textdata(j+1,2) mydata{i}.data(j,1)];
    end
end
[~,idx]=unique(pep_com_dup(:,1),'stable');
pep_com=pep_com_dup(idx,:);

%% shuffle the data
pep_com = pep_com(randperm(size(pep_com,1)),:);

%% Construct feature by amino acid matrix for each peptide
pep = zeros(size(pep_com,1),544*9);
label = zeros(size(pep_com,1),1);
for i = 1:size(pep_com,1)
    pep_fea = zeros(544,9);
    for j = 1:size(aaindex.data,2)
        same_idx = char(aaindex.textdata(1,j+1)) == char(pep_com(i,1));
        dup = size(pep_fea(:,same_idx),2);
        pep_fea(:,same_idx) = repmat(aaindex.data(:,j),[1 dup]);
    end
    pep_fea = reshape(pep_fea,[1 544*9]);
    pep(i,:) = pep_fea;
    label(i,:) = pep_com{i,2};
end

%% Feature Normalisation ??
[pep_feature,mu,sigma]  = featureNormalize(pep);

learner = [pep_feature label];
%% Save the matrix 
save('pep.mat');
         