function test_data(  )

datadir = 'F:\wangfeichi\test\char\testResized';
imgfiles=dir(datadir);
load('train_data_label');
p_label = cell(length(imgfiles)-2,1);
p_score = zeros(length(imgfiles)-2,1);
for id_img=3:length(imgfiles)
    img=imread(fullfile(datadir,[num2str(6283+id_img-2),'.Bmp']));
    [~,~,d]=size(img);
    if d==3
%         img = mean(img,3);
        img=rgb2gray(img);
    end
    img=single(img);
    img=imresize(img,[20,20] );
        % 二值化
    t_max = max(max(img));
    t_min = min(min(img));
    img = (img-t_min)/(t_max-t_min);
    img(img>0.5) = 1;
    img(img<=0.5) = 0;
    marg = [img(1,:),img(end,:),img(2:end-1,1)',img(2:end-1,end)'];
    % 强制黑背景
    if sum(marg==0)<sum(marg==1)
        img = 1-img;
    end
    test_sample(id_img-2,:) = reshape(img, 1, 400); 
end
save test_data test_sample
end

