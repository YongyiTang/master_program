function fix_prob(model,prob_estimates,type)
label = model.Label;

if(type == 1) % pose
    temp = prob_estimates;
    for i = 1:8
        num = find(label == i);
        prob_estimates(:,8-i+1) = temp(:,num);
        
    end
    save('new_prob_set3_pose.mat','prob_estimates');
end

if(type == 2) % action
    temp = prob_estimates;
    for i = 1:3
        num = find(label == i);
        prob_estimates(:,3-i+1) = temp(:,num);
        
    end
    save('new_prob_set4_action.mat','prob_estimates');
    
end