% get Q statistic
function data=getQStatistic(data)

% data.Q = []; % [1, nsample] - Q statistic

Ns=size(data.D,1);

data.Q = zeros(1,Ns);

for j=1:Ns
    data.Q(j)=dot( data.res(:,j), data.res(:,j) );
end


