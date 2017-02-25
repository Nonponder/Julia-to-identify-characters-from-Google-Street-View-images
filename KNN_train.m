function [train_ACC, p_label] = KNN_train(  )

load train_data.mat
rw_data = imdb.images.data;
for id_sample = 1:size(imdb.images.labels,2)
   train_fea(id_sample,:) = reshape(rw_data(:,:,:,id_sample),1,400); 
end
train_label = imdb.images.labels';
k_n = 3;
%% Ωª≤Ê≤‚ ‘
t_cv  = cvpartition(train_label, 'k', 10); % 10-fold cv
t_cp_lda = classperf(train_label);
for k=1:t_cv.NumTestSets
    train_ind = t_cv.training(k);
    test_ind = t_cv.test(k);
    % KNN
    Factor = fitcknn(train_fea(train_ind,:), train_label(train_ind), 'NumNeighbors', k_n); % number of nearest neighbors
    predict_label = predict(Factor,train_fea(test_ind,:));
    
    classperf(t_cp_lda,predict_label,test_ind);
end
train_ACC = t_cp_lda.correctrate;

%% ≤‚ ‘
Factor = fitcknn(train_fea, train_label, 'NumNeighbors', k_n);

load test_data.mat
load train_data_label.mat
p_label = cell(size(test_sample,1),1);
p_score = zeros(size(test_sample,1),1);
predict_label = predict(Factor,test_sample);
for id_sample = 1:size(test_sample,1)
%     [tP_label,Scores] = predict(Factor, test_sample(id_sample,:));
    p_label{id_sample} = dict{predict_label(id_sample)};
end
end

