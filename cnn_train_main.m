function [net, info] = cnn_train_main(varargin)
run(fullfile(vl_rootnn, 'matlab', 'vl_setupnn.m')) ;
% imdb = read_img();
load train_data.mat
net=cnn_design();
net.meta.normalization.averageImage =imdb.images.data_mean ;

[net, info] = cnn_train(net, imdb, @getBatch) ;
  
save('model.mat','net','info');
end

function [im, labels] = getBatch(imdb, batch)
im = imdb.images.data(:,:,:,batch);
% im = 256 * reshape(im, 20, 20, 1, []) ;
labels = imdb.images.labels(1,batch) ;
end

