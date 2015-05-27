function beta = auto_elm(data)
data = data'/255;
%data n is examples numbers,k is feature length
[n,k] = size(data);
m=1000;
omega = rand(k,m);
bias = rand(1,m);
bias = repmat(bias,n,1);
H = sigmoid(data*omega+bias);

beta = rand([m,k]);
grad_p =cal_grad(H,data,beta);

% gamma = abs(max(max(grad_p)));
gamma = 2*norm(H'*H)^2;
t = 1;
y = beta;
delta = 0 ;
for i = 1:5000
    
    t_pre = t;
    beta_pi = beta;
    grad_p = cal_grad(H,data,y);
%     r = beta_pi-1/gamma*cal_grad(H,data,beta_pi);
     r = y-1/gamma*grad_p;
    u = 1/gamma;
    [beta_m,beta_n] = size(beta);
    beta = beta(:);
    greater = find(r>u);
    middle = find(abs(r)<=abs(u));
    smaller = find(r<-u);
    beta(greater) = r(greater)-u;
    beta(middle) = 0;
    beta(smaller) = r(smaller)+u;
    
    beta = beta(:);
    beta = reshape(beta,beta_m,beta_n);
    %delta = norm(beta-beta_pi);
    delta_pre = delta;
    delta = 0.5*norm(H*beta-data) + sum(sum(abs(beta)));
%     gamma = abs(max(max(grad_p)));
    if abs(delta_pre-delta) < 0.0001
        break;
    end    
    disp(['iterate: i=',num2str(i),'distant: ',num2str(delta)]);
    t = (1+sqrt(1+4*t_pre^2))/2;
    y = beta+((t_pre-1)/t)*(beta-beta_pi);
end
%end of training
%start testing
% H = sigmoid(test'*omega+bias);
% test_pi = H*beta;


end

function result = sigmoid(x)
result = 1./(1+exp(-x));
end

function grad_p = cal_grad(H,X,beta)
grad_p = -H'*X+H'*H*beta;
end