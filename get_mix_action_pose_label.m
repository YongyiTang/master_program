function mix_label = get_mix_action_pose_label(pose_label,action_label)

mymat= [1,2,3;4,5,6;7,8,9;10,11,12;13,14,15;16,17,18;19,20,21;22,23,24];
mymat = mymat+1;
mix_label=[];
[m,n] = size(pose_label)
for i = 1:n
    if(pose_label(i)==0)
        mix_label = [mix_label,0];
        continue;
    end
    x = pose_label(i);
    y = action_label(i);
    label = mymat(x,y);
    mix_label = [mix_label,label];
    
    
end