function collect_prob(prob_pose,prob_action,person_hog_label)
%%��prob_estimates����Ż�����anno�ľ���
hog_anno_action_name = ['hog_anno_action01.mat';'hog_anno_action02.mat';'hog_anno_action03.mat';'hog_anno_action04.mat';'hog_anno_action05.mat';'hog_anno_action06.mat';'hog_anno_action07.mat';'hog_anno_action08.mat';'hog_anno_action09.mat'; ...
    'hog_anno_action10.mat';'hog_anno_action11.mat';'hog_anno_action12.mat';'hog_anno_action13.mat';'hog_anno_action14.mat';'hog_anno_action15.mat';'hog_anno_action16.mat';'hog_anno_action17.mat';'hog_anno_action18.mat';'hog_anno_action19.mat'; ...
    'hog_anno_action20.mat';'hog_anno_action21.mat';'hog_anno_action22.mat';'hog_anno_action23.mat';'hog_anno_action24.mat';'hog_anno_action25.mat';'hog_anno_action26.mat';'hog_anno_action27.mat';'hog_anno_action28.mat';'hog_anno_action29.mat'; ...
    'hog_anno_action30.mat';'hog_anno_action31.mat';'hog_anno_action32.mat';'hog_anno_action33.mat'];
hog_anno_pose_name = ['hog_anno_pose01.mat';'hog_anno_pose02.mat';'hog_anno_pose03.mat';'hog_anno_pose04.mat';'hog_anno_pose05.mat';'hog_anno_pose06.mat';'hog_anno_pose07.mat';'hog_anno_pose08.mat';'hog_anno_pose09.mat'; ...
    'hog_anno_pose10.mat';'hog_anno_pose11.mat';'hog_anno_pose12.mat';'hog_anno_pose13.mat';'hog_anno_pose14.mat';'hog_anno_pose15.mat';'hog_anno_pose16.mat';'hog_anno_pose17.mat';'hog_anno_pose18.mat';'hog_anno_pose19.mat'; ...
    'hog_anno_pose20.mat';'hog_anno_pose21.mat';'hog_anno_pose22.mat';'hog_anno_pose23.mat';'hog_anno_pose24.mat';'hog_anno_pose25.mat';'hog_anno_pose26.mat';'hog_anno_pose27.mat';'hog_anno_pose28.mat';'hog_anno_pose29.mat'; ...
    'hog_anno_pose30.mat';'hog_anno_pose31.mat';'hog_anno_pose32.mat';'hog_anno_pose33.mat'];
anno_name = ['anno01.mat';'anno02.mat';'anno03.mat';'anno04.mat';'anno05.mat';'anno06.mat';'anno07.mat';'anno08.mat';'anno09.mat'; ...
    'anno10.mat';'anno11.mat';'anno12.mat';'anno13.mat';'anno14.mat';'anno15.mat';'anno16.mat';'anno17.mat';'anno18.mat';'anno19.mat'; ...
    'anno20.mat';'anno21.mat';'anno22.mat';'anno23.mat';'anno24.mat';'anno25.mat';'anno26.mat';'anno27.mat';'anno28.mat';'anno29.mat'; ...
    'anno30.mat';'anno31.mat';'anno32.mat';'anno33.mat'];
anno_dir = ['/home/yongyi/data/eccv_data/annotations/'];
% vec_action = [0 0 0 1;0 0 1 0;0 1 0 0;1 0 0 0;];
vec_action = [0 0 1;0 1 0;1 0 0;];
% vec_pose = [0 0 0 0 0 0 0 0 1;0 0 0 0 0 0 0 1 0;0 0 0 0 0 0 1 0 0; ...
%     0 0 0 0 0 1 0 0 0;0 0 0 0 1 0 0 0 0;0 0 0 1 0 0 0 0 0; ...
%     0 0 1 0 0 0 0 0 0;0 1 0 0 0 0 0 0 0;1 0 0 0 0 0 0 0 0;];
vec_pose = [0 0 0 0 0 0 0 1;0 0 0 0 0 0 1 0;0 0 0 0 0 1 0 0; ...
            0 0 0 0 1 0 0 0;0 0 0 1 0 0 0 0;0 0 1 0 0 0 0 0; ...
            0 1 0 0 0 0 0 0;1 0 0 0 0 0 0 0;];
for i = 1:33
     seq = find(person_hog_label(3,:) == i);
       %   seq = [];
    if(isempty(seq))
        this_anno_dir = [anno_dir,anno_name(i,:)];
        load(this_anno_dir);
        num_person = length(anno.people);
        num_frame = anno.nframe;
        hog_anno_action = cell(num_person,num_frame);
        hog_anno_pose = cell(num_person,num_frame);
        for j = 1:num_person
            person_time = length(anno.people(j).time);
            for k = 1: person_time
                if(anno.people(j).attr(2,k)<=0)
                    %hog_anno_action{j,anno.people(j).time(k)} = vec_action(1,:);
                    continue;
                else
                    hog_anno_action{j,anno.people(j).time(k)} = vec_action(anno.people(j).attr(2,k),:);
                end
                if(anno.people(j).attr(1,k)<=0)
%                     hog_anno_pose{j,anno.people(j).time(k)} = vec_pose(1,:);
                    continue;
                else
                    hog_anno_pose{j,anno.people(j).time(k)} = vec_pose((anno.people(j).attr(1,k)),:);
                end
            end
        end
        save(['data/',hog_anno_action_name(i,:)],'hog_anno_action');
        save(['data/',hog_anno_pose_name(i,:)],'hog_anno_pose');
        %continue;
    else
        current_label = person_hog_label(:,seq);
        num_person = max(current_label(4,:));
        num_frame = max(current_label(5,:));
        hog_anno_action = cell(num_person,num_frame);
        hog_anno_pose = cell(num_person,num_frame);
        for j = seq
            for frame_subtitle = person_hog_label(5,j):min(person_hog_label(5,j)+9,num_frame)
                hog_anno_action{person_hog_label(4,j),frame_subtitle} = prob_action(j,:);
                hog_anno_pose{person_hog_label(4,j),frame_subtitle} = prob_pose(j,:);
            end
        end
        save(['data/',hog_anno_action_name(i,:)],'hog_anno_action');
        save(['data/',hog_anno_pose_name(i,:)],'hog_anno_pose');
    end
end
