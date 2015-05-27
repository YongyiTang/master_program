function pic_data = auto_elm_new_CAD()

pic_data = [];

for i = 1:100
seq_r = randi(32);
imdir = ['/home/yongyi/data/eccv_data/images/seq',num2str(seq_r,'%02d')];
imfiles = dir(fullfile(imdir, '*.jpg'));
annodir = ['/home/yongyi/data/eccv_data/annotations/anno',num2str(seq_r,'%02d'),'.mat'];
load(annodir);

for j = 1:100
frame_r = randi(anno.nframe);
im = imread(fullfile(imdir,imfiles(frame_r).name));
im = rgb2gray(im);
people_r = randi(length(anno.people));
time = find(anno.people(people_r).time == frame_r);
if isempty(time)
    continue;
end
sbbs = anno.people(people_r).sbbs(:,time);
if (sbbs(2)<=0 || sbbs(1)<=0 || sbbs(2)+sbbs(4)>=size(im,1)||sbbs(1)+sbbs(3)>=size(im,2))
    continue;
end
roi = im(round(sbbs(2)):round(sbbs(2)+sbbs(4)),round(sbbs(1)):round(sbbs(1)+sbbs(3)));
resize_roi = imresize(roi,[128,64]);
pic_data = [pic_data,resize_roi(:)];

end

end