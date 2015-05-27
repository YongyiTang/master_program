function get_person_hog_feature()
anno_name = ['anno01.mat';'anno02.mat';'anno03.mat';'anno04.mat';'anno05.mat';'anno06.mat';'anno07.mat';'anno08.mat';'anno09.mat'; ...
    'anno10.mat';'anno11.mat';'anno12.mat';'anno13.mat';'anno14.mat';'anno15.mat';'anno16.mat';'anno17.mat';'anno18.mat';'anno19.mat'; ...
    'anno20.mat';'anno21.mat';'anno22.mat';'anno23.mat';'anno24.mat';'anno25.mat';'anno26.mat';'anno27.mat';'anno28.mat';'anno29.mat'; ...
    'anno30.mat';'anno31.mat';'anno32.mat';'anno33.mat'];
dir_name = 'home/yongyi/data/eccv_data/';
seq_num = ['seq01';'seq02';'seq03';'seq04';'seq05';'seq06';'seq07';'seq08';'seq09'; ...
    'seq10';'seq11';'seq12';'seq13';'seq14';'seq15';'seq16';'seq17';'seq18';'seq19'; ...
    'seq20';'seq21';'seq22';'seq23';'seq24';'seq25';'seq26';'seq27';'seq28';'seq29'; ...
    'seq30';'seq31';'seq32';'seq33'];
feature_save_name = ['hog01.mat';'hog02.mat';'hog03.mat';'hog04.mat';'hog05.mat';'hog06.mat';'hog07.mat';'hog08.mat';'hog09.mat'; ...
    'hog10.mat';'hog11.mat';'hog12.mat';'hog13.mat';'hog14.mat';'hog15.mat';'hog16.mat';'hog17.mat';'hog18.mat';'hog19.mat'; ...
    'hog20.mat';'hog21.mat';'hog22.mat';'hog23.mat';'hog24.mat';'hog25.mat';'hog26.mat';'hog27.mat';'hog28.mat';'hog29.mat'; ...
    'hog30.mat';'hog31.mat';'hog32.mat';'hog33.mat'];
label_save_name = ['PA_label01.mat';'PA_label02.mat';'PA_label03.mat';'PA_label04.mat';'PA_label05.mat';'PA_label06.mat';'PA_label07.mat';'PA_label08.mat';'PA_label09.mat'; ...
    'PA_label10.mat';'PA_label11.mat';'PA_label12.mat';'PA_label13.mat';'PA_label14.mat';'PA_label15.mat';'PA_label16.mat';'PA_label17.mat';'PA_label18.mat';'PA_label19.mat'; ...
    'PA_label20.mat';'PA_label21.mat';'PA_label22.mat';'PA_label23.mat';'PA_label24.mat';'PA_label25.mat';'PA_label26.mat';'PA_label27.mat';'PA_label28.mat';'PA_label29.mat'; ...
    'PA_label30.mat';'PA_label31.mat';'PA_label32.mat';'PA_label33.mat'];

run('/home/yongyi/vlfeat-0.9.20-bin/vlfeat-0.9.20/toolbox/vl_setup');

for i = 1:33
    imdir = [dir_name,'images/',seq_num(i,:)];
    annodir =[dir_name,'annotations/',anno_name(i,:)];
    featuredir = [dir_name,feature_save_name(i,:)];
    labeldir = [dir_name,label_save_name(i,:)];
    imfiles = dir(fullfile(imdir, '*.jpg'));
    load(annodir);
    feature_cell = cell (length(anno.people),anno.nframe);
    label_cell = cell(length(anno.people),anno.nframe);
    for j = 1:length(anno.people)
        for k = 1:length(anno.people(j).time)
            fr = anno.people(j).time(k);
            if(anno.people(j).attr(1,k) <= 0 || anno.people(j).attr(1,k) > 8)
                continue;
            end
            if(anno.people(j).attr(2,k) <= 0 || anno.people(j).attr(2,k) > 3)
                continue;
            end
            im = rgb2gray(imread(fullfile(imdir,imfiles(fr).name)));
            [m,n] = size(im);
            %bbox : x,y,w,h
            bbox = [anno.people(j).sbbs(1,k),anno.people(j).sbbs(2,k), ...
                    anno.people(j).sbbs(3,k),anno.people(j).sbbs(4,k)];
            bb_x1 = min(m,max(1,bbox(2)));bb_x2 = min(m,bbox(2)+bbox(4));
            bb_y1 = min(n,max(1,bbox(1)));bb_y2 = min(n,bbox(1)+bbox(3));
            if (bb_y1==n || bb_x1==m)
                continue;
            end
            person_bbox_im = im(bb_x1:bb_x2,bb_y1:bb_y2);
            resize_bbox = imresize(person_bbox_im,[128,64]);
            resize_bbox = single(resize_bbox);
            hog = vl_hog(resize_bbox,8,'verbose');
            hog = hog(:);
            feature_cell{j,fr} = hog;
            
            label_cell{j,fr} = [anno.people(j).attr(1,k);anno.people(j).attr(2,k);i;j;fr;k];
        end
    end
   save(featuredir,'feature_cell');
    save(labeldir,'label_cell');
end
    