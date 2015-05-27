function acc = full_ac(set,test)
if nargin <= 1
    test = 0;
end
addpath('/home/yongyi/libsvm-3.20/matlab');
addpath('/home/yongyi/data/eccv_data/version_0416/multilayer_supervised');
addpath('/home/yongyi/data/eccv_data/version_0416/NN');
run('/home/yongyi/vlfeat-0.9.20-bin/vlfeat-0.9.20/toolbox/vl_setup');
% ac_data_dir = '/home/yongyi/master_program_data/origin_ac_data';
if test == 0
    ac_data_dir = '/home/yongyi/master_program_data/origin_ac_data';
elseif test == 1
    ac_data_dir = '/home/yongyi/master_program_data/improved_ac_data';
end
predict_data_dir = '/home/yongyi/master_program_data/predict_data';
if (exist(predict_data_dir,'file')==0)
    mkdir predict_data_dir
end
if (exist(ac_data_dir,'file')==0)
    error('ac files do not exist!');
end
% addpath('E:\master program\UFLDL\stanford_dl_ex-master\multilayer_supervised_copy');
% addpath('E:\master program\UFLDL\stanford_dl_ex-master\common\minFunc_2012');
% load('new_prob_set3_pose.mat');
% prob_pose = prob_estimates;
% load('new_prob_set4_action.mat');
% prob_action = prob_estimates;
% load('person_hog_label_test_set3.mat');
% collect_prob(prob_pose,prob_action,person_hog_label);
% Copy_of_sixteen_dir_get_my_AC(set);
%  collect_ac_data(set,test);
if set == 1
    load([ac_data_dir,'train_label_set1.mat']);
    load([ac_data_dir,'train_ac_feature_set1.mat']);
    load([ac_data_dir,'test_label_set1.mat']);
    load([ac_data_dir,'test_ac_feature_set1.mat']);
    elseif set ==2
        load([ac_data_dir,'train_label_set2.mat']);
    load([ac_data_dir,'train_ac_feature_set2.mat']);
    load([ac_data_dir,'test_label_set2.mat']);
    load([ac_data_dir,'test_ac_feature_set2.mat']);
    elseif set == 3
        load([ac_data_dir,'train_label_set3.mat']);
    load([ac_data_dir,'train_ac_feature_set3.mat']);
    load([ac_data_dir,'test_label_set3.mat']);
    load([ac_data_dir,'test_ac_feature_set3.mat']);
    else
        load([ac_data_dir,'train_label.mat']);
    load([ac_data_dir,'train_ac_feature.mat']);
    load([ac_data_dir,'test_label.mat']);
    load([ac_data_dir,'test_ac_feature.mat']);
end
% [center,assignments] = vl_kmeans(train_ac_feature,num_c,'Initialization','plusplus');
% train_kmeans_ac_feature = zeros(size(train_ac_feature));
% test_kmeans_ac_feature = zeros(size(test_ac_feature));
% train_size = size(train_ac_feature,2);
% for i = 1:train_size
%     train_kmeans_ac_feature(:,i) = center(:,assignments(i));
% end
% test_size = size(test_ac_feature,2);
% for i = 1:test_size
%     [~,k] = min(vl_alldist(test_ac_feature(:,i),center));
%     test_kmeans_ac_feature(:,i) = center(:,k);
% end
% train_data = train_kmeans_ac_feature;
% test_data = test_kmeans_ac_feature;
% size_data = size(train_data,2);
% r = randi(size_data,[1,round(size_data*0.5)]);


% [best_acc,best_c,best_g] = temp_SVMcg(train_label(1,:)',train_data')
% train_data = train_ac_feature;
test_data = test_ac_feature;
% 
train_data_num = size(train_ac_feature,1);
max_train_ac_temp = max(train_ac_feature,[],1);
min_train_ac_temp = min(train_ac_feature,[],1);
max_train_ac = repmat(max_train_ac_temp,[train_data_num,1]);
min_train_ac = repmat(min_train_ac_temp,[train_data_num,1]);

train_data = (train_ac_feature-min_train_ac)./(max_train_ac-min_train_ac);

% test_data_num = size(test_ac_feature,1);
% max_test_ac_temp = max(test_ac_feature,[],1);
% min_test_ac_temp = min(test_ac_feature,[],1);
% max_test_ac = repmat(max_test_ac_temp,[test_data_num,1]);
% min_test_ac = repmat(min_test_ac_temp,[test_data_num,1]);



% test_data = (test_ac_feature-min_test_ac)./(max_test_ac-min_test_ac);
% size_data = size(train_data,2);
% r = randi(size_data,[1,round(size_data*0.5)]);
% %%SVM only
% model = svmtrain(train_label(1,:)',train_data','-v 5');
% pre_label = svmpredict(test_label(1,:)',test_data',model);
%NN and SVM
% my_run_train;
% mid_test_data = hAct_test{1,1};
% mid_train_data = hAct_train{1,1};
% model = svmtrain(train_label(1,:)',mid_train_data');
% pre_label = svmpredict(test_label(1,:)',mid_test_data',model);
[training_time,testing_time,train_acc,test_acc,TY] = my_elm_kernel(train_data,train_label(1,:),test_data,test_label(1,:),1,1,'RBF_kernel',100);
% size(TY)
% save('TY.mat','TY');
[X,pre_label] = max(TY,[],1);
acc = get_frame_acc(pre_label,test_label)
% if set == 1
%     save([predict_data_dir,'pre_label_set1'],'pre_label');
%     elseif set ==2
%     save([predict_data_dir,'pre_label_set2'],'pre_label');
%     elseif set == 3
%      save([predict_data_dir,'pre_label_set3'],'pre_label');
%     else
%     save([predict_data_dir,'pre_label'],'pre_label');
%     end
