function [best_acc,best_i,total_acc] = test_kmeans(set)
best_acc = 0;
best_i = 0;
total_acc = zeros(1,30);
for i = 31:60
   acc =  full_ac(i,set)
   total_acc(i) = acc;
   if acc >=best_acc
       best_acc = acc
       best_i = i
   end
end