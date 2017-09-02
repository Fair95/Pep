% -------------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% -------------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch);
im=reshape(im,[size(im) 1]); 
labels = imdb.images.labels(1,batch);

end