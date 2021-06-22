% get T2 statistic
function data=getT2Statistic(data)

% data.T2 = []; % [1, nsample] - T2 statistic

Ns=size(data.D,1);
Nt=size(data.phi,2);

data.T2=zeros(1,Ns);

for j=1:Ns
       for i=1:Nt
         data.T2(j)=data.T2(j) + data.score(i,j)^2 / data.sigma(i);
       end
end


