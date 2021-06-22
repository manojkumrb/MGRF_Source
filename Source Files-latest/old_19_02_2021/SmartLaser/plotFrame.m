function plotFrame(R, p0, L)

p1=p0+L*R(:,1)';
p2=p0+L*R(:,2)';
p3=p0+L*R(:,3)';

p=[p0
   p1];
plot3(p(:,1),p(:,2),p(:,3),'r-','linewidth',4)

p=[p0
   p2];
plot3(p(:,1),p(:,2),p(:,3),'g-','linewidth',4)

p=[p0
   p3];
plot3(p(:,1),p(:,2),p(:,3),'b-','linewidth',4)