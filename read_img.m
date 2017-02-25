function imdb = read_img(  )

datadir = 'F:\wangfeichi\test\char\trainResized';
inputSize =[20,20,1];
imdb.images.data=[];
imdb.images.labels=[];
imdb.images.set = [] ;
imdb.meta.sets = {'train', 'val', 'test'} ;
trainratio=0.8;

% label
load('train_data_label');
% char_label  dict  dict_ind

% image
imgfiles=dir(datadir);
sample_num = size(char_label,1);
imdb.images.set = ones(1,sample_num);
cat_num = size(dict,1);
cat_sum = zeros(cat_num,1);
for id_cat = 1:cat_num
    cat_sum(id_cat) = sum(dict_ind == id_cat);
    cat_ind = find(dict_ind == id_cat);
    tm_tnd = randperm(cat_sum(id_cat));
    tm_num = round(cat_sum(id_cat)*(1-trainratio));
    imdb.images.set(cat_ind(tm_tnd(1:tm_num))) = 2;
end
for id_img=1:sample_num
    img=imread(fullfile(datadir,[num2str(id_img),'.Bmp']));
    [~,~,d]=size(img);    
    if d==3
%         img = mean(img,3);
        img=rgb2gray(img);
    end
    img=imresize(img, inputSize(1:2));
    img=single(img);
    % 二值化
    t_max = max(max(img));
    t_min = min(min(img));
    img = (img-t_min)/(t_max-t_min);
    img(img>0.5) = 1;
    img(img<=0.5) = 0;
    marg = [img(1,:),img(end,:),img(2:end-1,1)',img(2:end-1,end)'];
    % 强制黑背景
    if sum(marg==0)<sum(marg==1) %|| sum(sum(img==0))<sum(sum(img==1))
        img = 1-img;
    end    
%     imshow(img);
%     imwrite(img,fullfile(datadir,['pro_', num2str(id_img),'.Bmp']));
    imdb.images.data(:,:,:,id_img)=single(img);
    imdb.images.labels(id_img)= dict_ind(id_img);
end
dataMean=mean(imdb.images.data,4);
% imdb.images.data = single(bsxfun(@minus,imdb.images.data, dataMean)) ;
imdb.images.data_mean = dataMean;
save('train_data.mat','imdb');
end


