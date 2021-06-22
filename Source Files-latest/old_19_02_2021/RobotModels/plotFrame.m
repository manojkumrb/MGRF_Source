% plot frame
function plotFrame(R, p0, L, ax, tag)

p1=p0+L*R(:,1)';
p2=p0+L*R(:,2)';
p3=p0+L*R(:,3)';

p=[p0
   p1];
plot3(p(:,1),p(:,2),p(:,3),'r-','linewidth',2, 'parent', ax,'tag', tag)

p=[p0
   p2];
plot3(p(:,1),p(:,2),p(:,3),'g-','linewidth',2, 'parent', ax,'tag', tag)

p=[p0
   p3];
plot3(p(:,1),p(:,2),p(:,3),'b-','linewidth',2, 'parent', ax,'tag', tag)