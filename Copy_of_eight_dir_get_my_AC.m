function get_my_AC(set)
radius = 240;
pose_num = 8;
action_num = 3;
int_pose_num = 1;      %����ֵ��ݱ��ø�����ݵ�acc�кܴ����
int_action_num = 1;
total_num = pose_num+action_num;
int_total_num = int_pose_num + int_action_num;
lumda = 1;
center_time_length =3;%3
stl_time_length = 2;%2
region_num = 8;
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
ac_name = ['ac01.mat';'ac02.mat';'ac03.mat';'ac04.mat';'ac05.mat';'ac06.mat';'ac07.mat';'ac08.mat';'ac09.mat'; ...
    'ac10.mat';'ac11.mat';'ac12.mat';'ac13.mat';'ac14.mat';'ac15.mat';'ac16.mat';'ac17.mat';'ac18.mat';'ac19.mat'; ...
    'ac20.mat';'ac21.mat';'ac22.mat';'ac23.mat';'ac24.mat';'ac25.mat';'ac26.mat';'ac27.mat';'ac28.mat';'ac29.mat'; ...
    'ac30.mat';'ac31.mat';'ac32.mat';'ac33.mat'];
anno_dir = ['/home/yongyi/data/eccv_data/annotations/'];
B_LB_view = [0;3;4;5;6;7;8;1;2;9];
L_LF_view = [0;5;6;7;8;1;2;3;4;9];
F_FR_view = [0;7;8;1;2;3;4;5;6;9];
for k = 1:33
    %% read the anno data
    %     this_anno_dir = [anno_dir,anno_name(k,:)];
    %     load(this_anno_dir);
    %     load(hog_anno_pose_name(k,:));
    %     load(hog_anno_action_name(k,:));
    this_anno_dir = [anno_dir,anno_name(k,:)];
    this_action_dir = ['data/',hog_anno_action_name(k,:)];
    this_pose_dir = ['data/',hog_anno_pose_name(k,:)];
    load(this_anno_dir);
    load(this_pose_dir);
    load(this_action_dir);
    frames = anno.nframe;
    ac_feature_cell = cell(length(anno.people),frames);
    stl_cell = cell(length(anno.people),frames);
    for t = 1: min(frames,size(hog_anno_action,2))
        for i = 1:length(anno.people)
            %% no such people
            if (isempty(anno.people(i).time))
                continue;
            
            end
            
            ac_feature = zeros((center_time_length+region_num)*total_num,1);%center + 8 region
            time = find(anno.people(i).time == t);
            %% no such time
            if (isempty(time))
                continue;
                else if (anno.people(i).attr(1,time)<=0 || anno.people(i).attr(1,time)  > 8 || ...
                        anno.people(i).attr(2,time)<=0 || anno.people(i).attr(2,time)  > 3   )
                    continue;
                end
            end
            %% get the center person descriptor
            feature_center = [hog_anno_pose{i,t},hog_anno_action{i,t}];
%                         feature_center = feature_center/norm(feature_center);
%                         feature_center = [hog_anno_action{i,t}];
            if (isempty(feature_center))
                continue;
            end
            feature_center = feature_center';
            %%
            sbb_center = anno.people(i).sbbs(:,time);
            %loc_center is the center of the person
            loc_center = [round(sbb_center(2)+0.5*sbb_center(4)), ...
                round(sbb_center(1)+0.5*sbb_center(3))];
            feature_previous_total = [];
            for pre_t = 1:(center_time_length-1)
                if(t-pre_t > size(hog_anno_pose,2) || t-pre_t <= 0)
                    %                     fusion_pose = zeros(size(hog_anno_pose{i,t}));
                    %                     for pose_dir = 1:8
                    %                         fusion_pose = fusion_pose + circshift(hog_anno_pose{i,t},[0 -(pose_dir-1)])* ...
                    %                             hog_anno_pose{i,t}(pose_dir);
                    %                     end
                    %                     fusion_pose = fusion_pose/norm(fusion_pose);
                    %                     feature_previous = [fusion_pose,hog_anno_action{i,t}];
                    feature_previous = [hog_anno_pose{i,t},hog_anno_action{i,t}];
                    feature_previous_total = [feature_previous_total,feature_previous];
                else
                    if(isempty(hog_anno_pose{i,t-pre_t}))
                        %                         fusion_pose = zeros(size(hog_anno_pose{i,t}));
                        %                         for pose_dir = 1:8
                        %                             fusion_pose = fusion_pose + circshift(hog_anno_pose{i,t},[0 -(pose_dir-1)])* ...
                        %                                 hog_anno_pose{i,t}(pose_dir);
                        %                         end
                        %                         fusion_pose = fusion_pose/norm(fusion_pose);
                        %                         feature_previous = [fusion_pose,hog_anno_action{i,t}];
                        feature_previous = [hog_anno_pose{i,t},hog_anno_action{i,t}];
                        feature_previous_total = [feature_previous_total,feature_previous];
                    else
                        %                         fusion_pose = zeros(size(hog_anno_pose{i,t-pre_t}));
                        %                         for pose_dir = 1:8
                        %                             fusion_pose = fusion_pose + circshift(hog_anno_pose{i,t-pre_t},[0 -(pose_dir-1)])* ...
                        %                                 hog_anno_pose{i,t}(pose_dir);
                        %                         end
                        %                         fusion_pose = fusion_pose/norm(fusion_pose);
                        %                         feature_previous = [fusion_pose,hog_anno_action{i,t-pre_t}];
                        feature_previous = [hog_anno_pose{i,t-pre_t},hog_anno_action{i,t-pre_t}];
                        feature_previous_total = [feature_previous_total,feature_previous];            
                    end
                end
            end
            feature_previous_total = feature_previous_total';
            %             feature_previous_total = feature_previous_total/norm(feature_previous_total);
            
            

            temp = max(ac_feature(1:center_time_length*total_num,1),[feature_previous_total;feature_center]);
            ac_feature(1:center_time_length*total_num,1) = temp;
            pose_count = zeros(region_num*pose_num,1);
            %% surrounding people
            for j = 1:length(anno.people)
                if (i == j || isempty(anno.people(j).time))
                    continue;
                end
                time = find(anno.people(j).time == t);
                %% no such time
                if (isempty(time))
                    continue;
                else if (anno.people(j).attr(1,time)<=0 || anno.people(j).attr(1,time)  > 8 || ...
                            anno.people(j).attr(2,time)<=0 || anno.people(j).attr(2,time)  > 3   )
                        continue;
                    end
                end
                sbb_this = anno.people(j).sbbs(:,time);
                loc_this = [round(sbb_this(2)+0.5*sbb_this(4)), ...
                    round(sbb_this(1)+0.5*sbb_this(3))];
                feature_this = [hog_anno_pose{j,t},hog_anno_action{j,t}];
%                                 feature_this = feature_this/norm(feature_this);
%                                 feature_this = [hog_anno_action{j,t}];
                if (isempty(feature_this))
                    continue;
                end
                
                fusion_pose = zeros(size(hog_anno_pose{j,t}));
                for pose_dir = 1:8
%                     fusion_pose = fusion_pose + circshift(hog_anno_pose{j,t},[0 -(pose_dir-1)])* ...
%                         hog_anno_pose{i,t}(pose_dir);
                      temp_shift = circshift(hog_anno_pose{j,t},[0 -(pose_dir-1)])* ...
                         hog_anno_pose{i,t}(pose_dir);
                      fusion_pose = max(fusion_pose,temp_shift);
                end
                fusion_pose = fusion_pose/norm(fusion_pose);
                feature_this = [fusion_pose,hog_anno_action{j,t}];
                
                
                feature_this = feature_this';
                %% 8 regions
%                 if (region_num == 8)
%                     if (sqrt((loc_center(1)-loc_this(1))^2 +(loc_center(2)-loc_this(2))^2) > radius )
%                         if (loc_center(1)-loc_this(1) <= 0) %in region 7 or 8
%                             if (loc_center(2)-loc_this(2) <= 0)
%                                 region = 7;
%                             else
%                                 region = 8;
%                             end
%                         else  % in region 5 or 6
%                             if (loc_center(2)-loc_this(2) <= 0)
%                                 region = 5;
%                             else
%                                 region = 6;
%                             end
%                         end
%                         lumda = 0.5;
%                     else if (loc_center(1)-loc_this(1) <= 0) %in region 3 or 4
%                             if (loc_center(2)-loc_this(2) <= 0)
%                                 region = 4;
%                             else
%                                 region = 3;
%                             end
%                         else  % in region 1 or 2
%                             if (loc_center(2)-loc_this(2) <= 0)
%                                 region = 1;
%                             else
%                                 region = 2;
%                             end
%                         end
%                         lumda = 0.8;
%                     end
                 if (region_num == 8)
                     vec_x = (loc_this(1) -  loc_center(1)); vec_y = (loc_this(2) - loc_center(2));
                    if (sqrt((loc_center(1)-loc_this(1))^2 +(loc_center(2)-loc_this(2))^2) > radius )
                        
                        if (vec_x*cos(pi/2)-vec_y*sin(pi/2) <= 0) %in region 7 or 8
                            if (vec_x*sin(pi/2)+vec_y*cos(pi/2) <= 0)
                                region = 7;
                            else
                                region = 8;
                            end
                        else  % in region 5 or 6
                            if (vec_x*sin(pi/2)+vec_y*cos(pi/2) <= 0)
                                region = 5;
                            else
                                region = 6;
                            end
                        end
                        lumda = 0.8;%0.5;
                    else if (vec_x*cos(pi/2)-vec_y*sin(pi/2) <= 0) %in region 3 or 4
                            if (vec_x*sin(pi/2)+vec_y*cos(pi/2) <= 0)
                                region = 4;
                            else
                                region = 3;
                            end
                        else  % in region 1 or 2
                            if (vec_x*sin(pi/2)+vec_y*cos(pi/2) <= 0)
                                region = 1;
                            else
                                region = 2;
                            end
                        end
                        lumda = 0.8;
                    end                
                end
                
                temp = max(ac_feature((region+center_time_length-1)*total_num+1:(region+1+center_time_length-1)*total_num,1),feature_this);
                ac_feature((region+center_time_length-1)*total_num+1:(region+1+center_time_length-1)*total_num,1) = lumda*temp;
                this_pose =  find(hog_anno_pose{j,t} == max(hog_anno_pose{j,t}));
                pose_count((region-1)*pose_num+this_pose) = pose_count((region-1)*pose_num+this_pose)+1;
            end
            int_ac_feature = zeros((center_time_length+region_num)*int_total_num,1);
            %%collect the label of pose and action instead of prob
            for r = 0:center_time_length+(region_num-1)
                for num = 1: int_total_num
                    if num == 1  %pose
                        max_pose = find(ac_feature(r*total_num+1:r*total_num+pose_num,1) ...
                            == max(ac_feature(r*total_num+1:r*total_num+pose_num,1)));
                        if (size(max_pose,1) ~= 1)
                            continue;
                        end
                        int_ac_feature(r*int_total_num+num,1) = max_pose;
                    else
                        if num == 2 %action
                            max_action = find(ac_feature(r*total_num+pose_num+1:r*total_num+total_num,1) ...
                                == max(ac_feature(r*total_num+pose_num+1:r*total_num+total_num,1)));
                            if (size(max_action,1) ~= 1)
                                continue;
                            end
                            int_ac_feature(r*int_total_num+num,1) = max_action;
                        end
                    end
                end
            end
            
            pose_count_sum = zeros(pose_num,1);
            if(region_num == 8 )
                if (int_ac_feature((center_time_length-1)*int_total_num+1) == 7 || ...
                        int_ac_feature((center_time_length-1)*int_total_num+1) == 6)
                    pose_count(1:4*8) = circshift(pose_count(1:4*8),-8);
                    pose_count(1+4*8:8*8) = circshift(pose_count(1+4*8:8*8),-8);
%                     disp('B&LB');
                    for pose_shift_num = 1:8
                        pose_count((pose_shift_num-1)*8+1:pose_shift_num*8) = ...
                            circshift(pose_count((pose_shift_num-1)*8+1:pose_shift_num*8),6);
                        pose_count_sum = pose_count((pose_shift_num-1)*8+1:pose_shift_num*8);
                    end
                else
                    if (int_ac_feature((center_time_length-1)*int_total_num+1) == 5 || ...
                            int_ac_feature((center_time_length-1)*int_total_num+1) == 4)
                        pose_count(1:4*8) = circshift(pose_count(1:4*8),-16);
                        pose_count(1+4*8:8*8) = circshift(pose_count(1+4*8:8*8),-16);
                        %                     disp('L&LF');
                        for pose_shift_num = 1:8
                            pose_count((pose_shift_num-1)*8+1:pose_shift_num*8) = ...
                                circshift(pose_count((pose_shift_num-1)*8+1:pose_shift_num*8),4);
                            pose_count_sum = pose_count((pose_shift_num-1)*8+1:pose_shift_num*8);
                        end
                    else
                        if (int_ac_feature((center_time_length-1)*int_total_num+1) == 3 || ...
                                int_ac_feature((center_time_length-1)*int_total_num+1) == 2)
                            pose_count(1:4*8) = circshift(pose_count(1:4*8),-24);
                            pose_count(1+4*8:8*8) = circshift(pose_count(1+4*8:8*8),-24);
%                             %                     disp('F&FR');
                            for pose_shift_num = 1:8
                                pose_count((pose_shift_num-1)*8+1:pose_shift_num*8) = ...
                                    circshift(pose_count((pose_shift_num-1)*8+1:pose_shift_num*8),2);
                                pose_count_sum = pose_count((pose_shift_num-1)*8+1:pose_shift_num*8);
                            end
                        else
                            for pose_shift_num = 1:8
                                
                                pose_count_sum = pose_count((pose_shift_num-1)*8+1:pose_shift_num*8);
                            end
                        end
                    end
                end
            end
                   
            
            
            
            
            
            %             %%shift according to the center person pose
            %             if (int_ac_feature(1) == 7 || int_ac_feature(1) == 6)
            %                 temp = circshift(int_ac_feature(center_time_length*int_total_num+1:(center_time_length+4)*int_total_num,1),2);
            %                 int_ac_feature(center_time_length*int_total_num+1:(center_time_length+4)*int_total_num,1) = temp;
            %
            %                 temp_view = int_ac_feature(center_time_length*int_total_num+1:(center_time_length+5)*int_total_num,1);
            %                 for feature_dim = 1:int_total_num:size(temp_view,1)
            %                     temp_view(feature_dim) = B_LB_view(temp_view(feature_dim)+1);
            %                 end
            %                 int_ac_feature(center_time_length*int_total_num+1:(center_time_length+5)*int_total_num,1) = temp_view;
            %             else
            %                 if (int_ac_feature(1) == 5 || int_ac_feature(1) == 4)
            %                     temp = circshift(int_ac_feature(center_time_length*int_total_num+1:(center_time_length+4)*int_total_num,1),2);
            %                     int_ac_feature(center_time_length*int_total_num+1:(center_time_length+4)*int_total_num,1) = temp;
            %
            %                     temp_view = int_ac_feature(center_time_length*int_total_num+1:(center_time_length+5)*int_total_num,1);
            %                     for feature_dim = 1:int_total_num:size(temp_view,1)
            %                         temp_view(feature_dim) = L_LF_view(temp_view(feature_dim)+1);
            %                     end
            %                     int_ac_feature(center_time_length*int_total_num+1:(center_time_length+5)*int_total_num,1) = temp_view;
            %                 else
            %                     if (int_ac_feature(1) == 3 || int_ac_feature(1) == 2)
            %                         temp = circshift(int_ac_feature(center_time_length*int_total_num+1:(center_time_length+4)*int_total_num,1),2);
            %                         int_ac_feature(center_time_length*int_total_num+1:(center_time_length+4)*int_total_num,1) = temp;
            %
            %                         temp_view = int_ac_feature(center_time_length*int_total_num+1:(center_time_length+5)*int_total_num,1);
            %                         for feature_dim = 1:int_total_num:size(temp_view,1)
            %                             temp_view(feature_dim) = F_FR_view(temp_view(feature_dim)+1);
            %                         end
            %                         int_ac_feature(center_time_length*int_total_num+1:(center_time_length+5)*int_total_num,1) = temp_view;
            %                     end
            %                 end
            %             end
            
            stl_cell{i,t} = pose_count;
            stl_total = [];
            for stl_t = 1 : stl_time_length
                if (t-stl_t <= 0 )
                    stl_total = [stl_total;pose_count];
                else
                    if (isempty(stl_cell{i,t-stl_t}))
                        stl_total = [stl_total;pose_count];
                    else
                        stl_total = [stl_total;stl_cell{i,t-stl_t}];
                    end
                end
            end
%              pose_count_sum = pose_count_sum/norm(pose_count_sum);
%              stl_cell{i,t} = pose_count_sum;
%             stl_total = zeros(size(pose_count_sum));
%             for stl_t = 1 : stl_time_length
%                 if (t-stl_t <= 0 )
% %                     stl_total = [stl_total;pose_count_sum];
%                      stl_total = stl_total + pose_count_sum;
%                 else
%                     if (isempty(stl_cell{i,t-stl_t}))
% %                         stl_total = [stl_total;pose_count_sum];
%                      stl_total = stl_total + pose_count_sum;
%                     else
% %                         stl_total = [stl_total;stl_cell{i,t-stl_t}];
%                      stl_total = stl_total + stl_cell{i,t-stl_t};
%                     end
%                 end
%             end

            
            ac_feature = ac_feature/norm(ac_feature);
            ac_feature_cell{i,t} =  [stl_total ;ac_feature];
            %             ac_feature_cell{i,t} =  [pose_count;int_ac_feature];
%                         ac_feature_cell{i,t} =  stl_total;
        end
    end
    save(['data/',ac_name(k,:)],'ac_feature_cell');
end

