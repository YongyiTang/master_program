function collect_person_hog_data(type,set)


if (type == 0)
    if(set == 1)
        feature_save_name = ['hog03.mat';'hog04.mat';'hog05.mat';'hog06.mat';'hog08.mat';'hog09.mat'; ...
            'hog10.mat';'hog11.mat';'hog14.mat';'hog15.mat';'hog16.mat';'hog17.mat';'hog18.mat'; ...
            'hog22.mat';'hog23.mat';'hog24.mat';'hog25.mat';'hog28.mat';'hog29.mat'; ...
            'hog31.mat';'hog32.mat';'hog33.mat'];
        label_save_name = ['PA_label03.mat';'PA_label04.mat';'PA_label05.mat';'PA_label06.mat';'PA_label08.mat';'PA_label09.mat'; ...
            'PA_label10.mat';'PA_label11.mat';'PA_label14.mat';'PA_label15.mat';'PA_label16.mat';'PA_label17.mat';'PA_label18.mat'; ...
            'PA_label22.mat';'PA_label23.mat';'PA_label24.mat';'PA_label25.mat';'PA_label28.mat';'PA_label29.mat'; ...
            'PA_label31.mat';'PA_label32.mat';'PA_label33.mat'];
    end
    if(set == 2)
        feature_save_name = ['hog01.mat';'hog02.mat';'hog04.mat';'hog06.mat';'hog07.mat';'hog08.mat';'hog09.mat'; ...
            'hog12.mat';'hog13.mat';'hog14.mat';'hog19.mat'; ...
            'hog20.mat';'hog21.mat';'hog22.mat';'hog23.mat';'hog26.mat';'hog27.mat';'hog28.mat';'hog29.mat'; ...
            'hog30.mat';'hog32.mat';'hog33.mat'];
        label_save_name = ['PA_label01.mat';'PA_label02.mat';'PA_label04.mat';'PA_label06.mat';'PA_label07.mat';'PA_label08.mat';'PA_label09.mat'; ...
            'PA_label12.mat';'PA_label13.mat';'PA_label14.mat';'PA_label19.mat'; ...
            'PA_label20.mat';'PA_label21.mat';'PA_label22.mat';'PA_label23.mat';'PA_label26.mat';'PA_label27.mat';'PA_label28.mat';'PA_label29.mat'; ...
            'PA_label30.mat';'PA_label32.mat';'PA_label33.mat'];
    end
    if(set == 3)
        feature_save_name = ['hog01.mat';'hog02.mat';'hog03.mat';'hog05.mat';'hog07.mat'; ...
            'hog10.mat';'hog11.mat';'hog12.mat';'hog13.mat';'hog15.mat';'hog16.mat';'hog17.mat';'hog18.mat';'hog19.mat'; ...
            'hog20.mat';'hog21.mat';'hog24.mat';'hog25.mat';'hog26.mat';'hog27.mat'; ...
            'hog30.mat';'hog31.mat'];
        label_save_name = ['PA_label01.mat';'PA_label02.mat';'PA_label03.mat';'PA_label05.mat';'PA_label07.mat'; ...
            'PA_label10.mat';'PA_label11.mat';'PA_label12.mat';'PA_label13.mat';'PA_label15.mat';'PA_label16.mat';'PA_label17.mat';'PA_label18.mat';'PA_label19.mat'; ...
            'PA_label20.mat';'PA_label21.mat';'PA_label24.mat';'PA_label25.mat';'PA_label26.mat';'PA_label27.mat'; ...
            'PA_label30.mat';'PA_label31.mat'];
    end
    dir_name = '/home/yongyi/data/eccv_data/';
    person_hog_feature = [];
    person_hog_label = [];
    for i = 1:22
        featuredir = [dir_name,feature_save_name(i,:)];
        labeldir = [dir_name,label_save_name(i,:)];
        load(featuredir);
        load(labeldir);
        [f_m,f_n] = size(feature_cell);
        [l_m,l_n] = size(label_cell);
        for j = 1:f_m
            for k = 1:9:f_n-9
                if (isempty(feature_cell{j,k}) == 0)
                if (isempty(feature_cell{j,k+9}) == 0)
                    temp_feature = mean([feature_cell{j,k},feature_cell{j,k+1},feature_cell{j,k+2},feature_cell{j,k+3}, ...
                        feature_cell{j,k+4},feature_cell{j,k+5},feature_cell{j,k+6},feature_cell{j,k+7}, ...
                        feature_cell{j,k+8},feature_cell{j,k+9}],2);
                    person_hog_feature = [person_hog_feature,temp_feature];
                end
                end
            end
        end
        for j = 1:l_m
            for k = 1:9:l_n-9
                if (isempty(label_cell{j,k}) == 0)
                    if (isempty(label_cell{j,k+9}) == 0)
                        temp_label = mode([label_cell{j,k},label_cell{j,k+1},label_cell{j,k+2},label_cell{j,k+3}, ...
                            label_cell{j,k+4},label_cell{j,k+5},label_cell{j,k+6}, ...
                            label_cell{j,k+7} label_cell{j,k+8},label_cell{j,k+9}],2);
                    person_hog_label = [person_hog_label,temp_label];
                    end
                end
            end
        end
        
    end
    save_hog_feature_dir = [dir_name,['person_hog_feature_train.mat']];
    save_hog_label_dir = [dir_name,['person_hog_label_train.mat']];
    save(save_hog_feature_dir,'person_hog_feature');
    save(save_hog_label_dir,'person_hog_label');
end

if (type == 1)
    if(set == 1)
        feature_save_name = ['hog01.mat';'hog02.mat';'hog07.mat'; ...
            'hog12.mat';'hog13.mat';'hog19.mat'; ...
            'hog20.mat';'hog21.mat';'hog26.mat';'hog27.mat'; ...
            'hog30.mat'];
        label_save_name = ['PA_label01.mat';'PA_label02.mat';'PA_label07.mat'; ...
            'PA_label12.mat';'PA_label13.mat';'PA_label19.mat'; ...
            'PA_label20.mat';'PA_label21.mat';'PA_label26.mat';'PA_label27.mat'; ...
            'PA_label30.mat'];
    end
    if(set == 2)
        feature_save_name = ['hog03.mat';'hog05.mat'; ...
            'hog10.mat';'hog11.mat';'hog15.mat';'hog16.mat';'hog17.mat';'hog18.mat'; ...
            'hog24.mat';'hog25.mat'; ...
            'hog31.mat'];
        label_save_name = ['PA_label03.mat';'PA_label05.mat'; ...
            'PA_label10.mat';'PA_label11.mat';'PA_label15.mat';'PA_label16.mat';'PA_label17.mat';'PA_label18.mat'; ...
            'PA_label24.mat';'PA_label25.mat'; ...
            'PA_label31.mat'];
    end
    if(set == 3)
        feature_save_name = ['hog04.mat';'hog06.mat';'hog08.mat';'hog09.mat'; ...
            'hog14.mat'; ...
            'hog22.mat';'hog23.mat';'hog28.mat';'hog29.mat'; ...
            'hog32.mat';'hog33.mat'];
        label_save_name = ['PA_label04.mat';'PA_label06.mat';'PA_label08.mat';'PA_label09.mat'; ...
            'PA_label14.mat'; ...
            'PA_label22.mat';'PA_label23.mat';'PA_label28.mat';'PA_label29.mat'; ...
            'PA_label32.mat';'PA_label33.mat'];
    end
    dir_name = ['/home/yongyi/data/eccv_data/'];
    person_hog_feature = [];
    person_hog_label = [];
    for i = 1:11
        featuredir = [dir_name,feature_save_name(i,:)];
        labeldir = [dir_name,label_save_name(i,:)];
        load(featuredir);
        load(labeldir);
        [f_m,f_n] = size(feature_cell);
        [l_m,l_n] = size(label_cell);
        for j = 1:f_m
            for k = 1:9:f_n-9
                if (isempty(feature_cell{j,k}) == 0)
                if (isempty(feature_cell{j,k+9}) == 0)
                    temp_feature = mean([feature_cell{j,k},feature_cell{j,k+1},feature_cell{j,k+2},feature_cell{j,k+3}, ...
                        feature_cell{j,k+4},feature_cell{j,k+5},feature_cell{j,k+6},feature_cell{j,k+7}, ...
                        feature_cell{j,k+8},feature_cell{j,k+9}],2);
                    person_hog_feature = [person_hog_feature,temp_feature];
                end
                end
            end
        end
        for j = 1:l_m
            for k = 1:9:l_n-9
                if (isempty(label_cell{j,k}) == 0)
                    if (isempty(label_cell{j,k+9}) == 0)
                        temp_label = mode([label_cell{j,k},label_cell{j,k+1},label_cell{j,k+2},label_cell{j,k+3}, ...
                            label_cell{j,k+4},label_cell{j,k+5},label_cell{j,k+6}, ...
                            label_cell{j,k+7} label_cell{j,k+8},label_cell{j,k+9}],2);
                    person_hog_label = [person_hog_label,temp_label];
                    end
                end
            end
        end
        
    end
    save_hog_feature_dir = [dir_name,['person_hog_feature_test.mat']];
    save_hog_label_dir = [dir_name,['person_hog_label_test.mat']];
    save(save_hog_feature_dir,'person_hog_feature');
    save(save_hog_label_dir,'person_hog_label');
end
