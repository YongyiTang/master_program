function average_ac(ac_label,ac_feature)
data_dir = '/home/yongyi/master_program_data/max_ac_data';
feature = [];
label = [];
for i = 1:33
    seq = find(ac_label(2,:)==i);
    if isempty(seq)
        continue;
    end
    this_label = ac_label(:,seq);
    this_feature = ac_feature(:,seq);
    max_frame = max(this_label(3,:));
    for j = 1: max_frame
        this_seq = find(this_label(3,:)==j);
        if isempty(this_seq)
            continue;
        end
        temp_feature = this_feature(:,this_seq);
        temp_label = this_label(:,this_seq);
%         average_feature = mean(temp_feature,2);
average_feature = max(temp_feature,[],2);
        label = [label,temp_label(:,1)];
        feature = [feature,average_feature];
    end
end
save([data_dir,'max_ac_feature'],'feature');
save([data_dir,'max_ac_label'],'label');