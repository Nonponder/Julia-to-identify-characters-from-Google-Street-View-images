function [train_ACC, p_label] = NB_train(  )

load train_data.mat
rw_data = imdb.images.data;
for id_sample = 1:size(imdb.images.labels,2)
   train_fea(id_sample,:) = reshape(rw_data(:,:,:,id_sample),1,400); 
end
train_label = imdb.images.labels';

IC_num_thr = 0.99;
[tmp_E, tmp_D]=pcamat(train_fea',1,size(train_fea',1),'off','off');
tmp_D = flipud(diag(tmp_D));
tmp_D = cumsum(tmp_D./sum(tmp_D));
tind = find(tmp_D>=IC_num_thr);
IC_num = tind(1);
train_fea = (tmp_E*train_fea')';
train_fea = train_fea(:,1:IC_num);

%% Ωª≤Ê≤‚ ‘
t_cv  = cvpartition(train_label, 'k', 10); % 10-fold cv
t_cp_lda = classperf(train_label);
for k=1:t_cv.NumTestSets
    train_ind = t_cv.training(k);
    test_ind = t_cv.test(k);
    % Naive Bayes
    Factor = NaiveBayes.fit(train_fea(train_ind,:), train_label(train_ind));
    [Scores, predict_label] = posterior(Factor, train_fea(test_ind,:));
    
    classperf(t_cp_lda,predict_label,test_ind);
end
train_ACC = t_cp_lda.correctrate;

%% ≤‚ ‘
Factor = NaiveBayes.fit(train_fea, train_label);

load test_data.mat
load train_data_label.mat
p_label = cell(size(test_sample,1),1);
p_score = zeros(size(test_sample,1),1);
t_fea = (tmp_E*test_sample')';
t_fea = t_fea(:,1:IC_num);
[Scores, predict_label] = posterior(Factor, t_fea);
for id_sample = 1:size(test_sample,1)
    p_label{id_sample} = dict{predict_label(id_sample)};
end

end

