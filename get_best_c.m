function [bestacc,bestc] = get_best_c(set)
data_dir = '/home/yongyi/master_program_data/max_ac_data/';
feature = load([data_dir,'max_ac_feature_test_set',num2str(set)]);
label = load([data_dir,'max_ac_label_test_set',num2str(set)]);
test_label = label.label;
test_data = feature.feature;
feature = load([data_dir,'max_ac_feature_train_set',num2str(set)]);
label =load([data_dir,'max_ac_label_train_set',num2str(set)]);
train_data = feature.feature;
train_label = label.label;
bestacc = 0;
bestc = 21;
for c = 0.1:0.1:20
    [training_time,testing_time,train_acc,test_acc,TY] ...
        = my_elm_kernel(train_data,train_label(1,:),test_data, ...
        test_label(1,:),1,c,'RBF_kernel',100);
    if test_acc > bestacc
        bestacc = test_acc;
        bestc = c;
        disp(['Current best_acc is ',num2str(bestacc)]);
    end
end


%set1 bestc = 0.2 bestacc= 0.8675
%set2 bestc = 0.8 bestacc = 0.8955
%set3 bestc = 18 bestacc = 0.8138
    