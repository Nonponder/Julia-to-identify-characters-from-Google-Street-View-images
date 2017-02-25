function [p_label, p_score] = cnn_predict( )

run(fullfile(vl_rootnn, 'matlab', 'vl_setupnn.m')) ;
datadir = 'F:\wangfeichi\test\char\testResized';
imgfiles=dir(datadir);
load('train_data_label');
load('F:\wangfeichi\test\program\data\exp\net-epoch-163.mat')
opts.batchNormalization = false ;
% net.layers{end} = [];
net.layers{end}.type = 'softmax';
p_label = cell(length(imgfiles)-2,1);
p_score = zeros(length(imgfiles)-2,1);
for id_img=3:length(imgfiles)
    img=imread(fullfile(datadir,[num2str(6283+id_img-2),'.Bmp']));
    [~,~,d]=size(img);
    if d==3
        img=rgb2gray(img);
    end
    img=single(img);
    img=imresize(img,net.meta.inputSize(1:2));
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
    
%     img=img - net.meta.normalization.averageImage;
    res=vl_simplenn(net,img);
    scores=squeeze(gather(res(end).x));
    [bestScore,best]=max(scores);
%     p_label{id_img-2} = dict{res}
    p_label{id_img-2} = dict{best};
    p_score(id_img-2) = bestScore;
end

end

