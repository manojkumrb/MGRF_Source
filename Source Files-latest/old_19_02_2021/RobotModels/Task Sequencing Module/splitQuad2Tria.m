function tria=splitQuad2Tria(quad)

n=size(quad,1);

tria=zeros(2*n,3);
c=1;
for i=1:n
    quadi=quad(i,:);
    
    tria(c,:)=quadi([1 2 3]);
    tria(c+1,:)=quadi([3 4 1]);
    
    c=c+2;
end