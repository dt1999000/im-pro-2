x = -2*pi:0.001:2*pi;
y1 = rectangularPulse(-pi/2, pi/2, x);
y2 = 0.25*ones([1,length(x)]);
y = y1./(y1+0.25);
plot(x,y,x,y1,x,y2);
set(gca,'ylim',([-1 2]));

set(gca,'xlim',([-2*pi 2*pi]));

legend('Hopt','Cxx','Cvv','Location','northeast');