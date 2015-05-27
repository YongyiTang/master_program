function acc = get_frame_acc(pre_label,test_label)
anno_name = ['anno01.mat';'anno02.mat';'anno03.mat';'anno04.mat';'anno05.mat';'anno06.mat';'anno07.mat';'anno08.mat';'anno09.mat'; ...
    'anno10.mat';'anno11.mat';'anno12.mat';'anno13.mat';'anno14.mat';'anno15.mat';'anno16.mat';'anno17.mat';'anno18.mat';'anno19.mat'; ...
    'anno20.mat';'anno21.mat';'anno22.mat';'anno23.mat';'anno24.mat';'anno25.mat';'anno26.mat';'anno27.mat';'anno28.mat';'anno29.mat'; ...
    'anno30.mat';'anno31.mat';'anno32.mat';'anno33.mat'];
predict_name = ['predict01.mat';'predict02.mat';'predict03.mat';'predict04.mat';'predict05.mat';'predict06.mat';'predict07.mat';'predict08.mat';'predict09.mat'; ...
    'predict10.mat';'predict11.mat';'predict12.mat';'predict13.mat';'predict14.mat';'predict15.mat';'predict16.mat';'predict17.mat';'predict18.mat';'predict19.mat'; ...
    'predict20.mat';'predict21.mat';'predict22.mat';'predict23.mat';'predict24.mat';'predict25.mat';'predict26.mat';'predict27.mat';'predict28.mat';'predict29.mat'; ...
    'predict30.mat';'predict31.mat';'predict32.mat';'predict33.mat'];
anno_dir = ['/home/yongyi/data/eccv_data/annotations/'];
count = 0;
total = 0;
frames = 0;
for k = 1:33
    this_anno_dir = [anno_dir,anno_name(k,:)];
    load(this_anno_dir);
    seq = find(test_label(2,:)==k);
    if (isempty(seq))
        continue;
    end
    frame = anno.nframe;
    predict_cell = cell(length(anno.people),frame);
    this_seq = test_label(:,seq);
    this_pre_label_seq = pre_label(seq);
    this_count = 0;
    for i = 1:frame
        frame_app = find(this_seq(3,:) == i);
        this_frame = this_seq(:,frame_app);
        this_pre_label_seq(frame_app);
        this_frame_label = mode(this_pre_label_seq(frame_app));
        anno_label = anno.collective(i);
        if anno_label == 1 
            continue;
        end
        count = count + (anno_label == this_frame_label);
        this_count = this_count + (anno_label == this_frame_label);
        total = total + 1;
        
    end
    acc = count/total
%       acc = this_count/frame
end