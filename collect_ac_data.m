function collect_ac_data(set,test)
if nargin <= 1
    test = 0;
end

if test == 0
    ac_data_dir = '/home/yongyi/master_program_data/origin_ac_data';
elseif test == 1
    ac_data_dir = '/home/yongyi/master_program_data/improved_ac_data';
end

anno_name = ['anno01.mat';'anno02.mat';'anno03.mat';'anno04.mat';'anno05.mat';'anno06.mat';'anno07.mat';'anno08.mat';'anno09.mat'; ...
    'anno10.mat';'anno11.mat';'anno12.mat';'anno13.mat';'anno14.mat';'anno15.mat';'anno16.mat';'anno17.mat';'anno18.mat';'anno19.mat'; ...
    'anno20.mat';'anno21.mat';'anno22.mat';'anno23.mat';'anno24.mat';'anno25.mat';'anno26.mat';'anno27.mat';'anno28.mat';'anno29.mat'; ...
    'anno30.mat';'anno31.mat';'anno32.mat';'anno33.mat'];
ac_name = ['ac01.mat';'ac02.mat';'ac03.mat';'ac04.mat';'ac05.mat';'ac06.mat';'ac07.mat';'ac08.mat';'ac09.mat'; ...
    'ac10.mat';'ac11.mat';'ac12.mat';'ac13.mat';'ac14.mat';'ac15.mat';'ac16.mat';'ac17.mat';'ac18.mat';'ac19.mat'; ...
    'ac20.mat';'ac21.mat';'ac22.mat';'ac23.mat';'ac24.mat';'ac25.mat';'ac26.mat';'ac27.mat';'ac28.mat';'ac29.mat'; ...
    'ac30.mat';'ac31.mat';'ac32.mat';'ac33.mat'];
anno_dir = '/home/yongyi/data/eccv_data/annotations/';
if (exist(ac_data_dir,'file')==0)
     error('ac files do not exist!');
end
%% get the set
if (set == 1)
    train_seq = [3,4,5,6,8,9,10,11,14,15,16,17,18,22,23,24,25,28,29,31,32];
    test_seq = [1,2,7,12,13,19,20,21,26,27,30];
elseif (set == 2)
    train_seq = [1,2,4,6,7,8,9,12,13,14,19,20,21,22,23,26,27,28,29,30,32];
    test_seq = [3,5,10,11,15,16,17,18,24,25,31];

elseif (set == 3)
%     train_seq = [1,2,3,5,7,10,11,12,13,15,16,17,18,19,20,21,24,25,26,27,30,31];
train_seq = [1,2,3,5,7,10,11,12,13,15,16,17,18,19,20,21,24,25,26,27,30,31];
    test_seq = [4,6,8,9,14,22,23,28,29,32];
end
train_ac_feature = [];
train_label = [];
for k = train_seq
    %% read the anno data
    this_anno_dir = [anno_dir,anno_name(k,:)];
    this_ac_dir = [ac_data_dir,ac_name(k,:)];
    load(this_anno_dir);
    load(this_ac_dir);
    for i = 1:length(anno.people)                                            %length(anno.people)�õ�����
%         for j = i+1:length(anno.people)                                      %�ѵõ���i���ٻ�õڶ�����j
%             frames = intersect(anno.people(i).time, anno.people(j).time);    %��i,j������ͬʱ���ֵ�֡�еĽ���ʱ��
%             iid = get_interaction_idx(i, j, length(anno.people));            %��������
            frames = anno.people(i).time;
            min_t = min(length(frames),size(ac_feature_cell,2));
            for t = 1:min_t
                fr = min(frames(t),size(ac_feature_cell,2));
               
                % if there is no content in these two structure, continue
%                 if(isempty(ac_feature_cell{i,fr})||isempty(ac_feature_cell{j,fr}))
                if(isempty(ac_feature_cell{i,fr}))
                    continue;
                end
                %% get the action feature for i and j
%                 if(anno.interaction(iid,fr) <= 1)
%                     interaction_label = [1;k;fr];
%                 else
%                     interaction_label = anno.interaction(iid,fr);
                    interaction_label = [anno.collective(fr);k;fr];
%                 end
                train_ac_feature = [train_ac_feature,ac_feature_cell{i,fr}];
                train_label = [train_label,interaction_label];
            end
%         end
    end
end
if set ==1
save([ac_data_dir,'train_ac_feature_set1.mat'],'train_ac_feature');
save([ac_data_dir,'train_label_set1.mat'],'train_label');
elseif set ==2
    save([ac_data_dir,'train_ac_feature_set2.mat'],'train_ac_feature');
save([ac_data_dir,'train_label_set2.mat'],'train_label');
elseif set ==3
    save([ac_data_dir,'train_ac_feature_set3.mat'],'train_ac_feature');
save([ac_data_dir,'train_label_set3.mat'],'train_label');
else
    save([ac_data_dir,'train_ac_feature.mat'],'train_ac_feature');
save([ac_data_dir,'train_label.mat'],'train_label');
end
test_ac_feature = [];
test_label = [];
for k = test_seq
    %% read the anno data
    this_anno_dir = [anno_dir,anno_name(k,:)];
    this_ac_dir = [ac_data_dir,ac_name(k,:)];
    load(this_anno_dir);
    load(this_ac_dir);
    for i = 1:length(anno.people)                                            %length(anno.people)�õ�����
%         for j = i+1:length(anno.people)                                      %�ѵõ���i���ٻ�õڶ�����j
%             frames = intersect(anno.people(i).time, anno.people(j).time);    %��i,j������ͬʱ���ֵ�֡�еĽ���ʱ��
%             iid = get_interaction_idx(i, j, length(anno.people));            %��������
            frames = anno.people(i).time;
            min_t = min(length(frames),size(ac_feature_cell,2));
            for t = 1:min_t
                fr = min(frames(t),size(ac_feature_cell,2));
                
                % if there is no content in these two structure, continue
%                 if(isempty(ac_feature_cell{i,fr})||isempty(ac_feature_cell{j,fr}))
                if(isempty(ac_feature_cell{i,fr}))
                    continue;
                end
                %% get the action feature for i and j
%                 if(anno.interaction(iid,fr) <= 1)
                    %interaction_label = [1;k;fr];
%                     continue;
%                 else
%                      interaction_label = anno.interaction(iid,fr);
                    interaction_label = [anno.collective(fr);k;fr];
%                 end
                test_ac_feature = [test_ac_feature,ac_feature_cell{i,fr}];
                test_label = [test_label,interaction_label];
            end
%         end
    end
end
if set ==1
save([ac_data_dir,'test_ac_feature_set1.mat'],'test_ac_feature');
save([ac_data_dir,'test_label_set1.mat'],'test_label');
elseif set ==2
    save([ac_data_dir,'test_ac_feature_set2.mat'],'test_ac_feature');
save([ac_data_dir,'test_label_set2.mat'],'test_label');
elseif set == 3
    save([ac_data_dir,'test_ac_feature_set3.mat'],'test_ac_feature');
save([ac_data_dir,'test_label_set3.mat'],'test_label');
else
    save([ac_data_dir,'test_ac_feature.mat'],'test_ac_feature');
save([ac_data_dir,'test_label.mat'],'test_label');
end









