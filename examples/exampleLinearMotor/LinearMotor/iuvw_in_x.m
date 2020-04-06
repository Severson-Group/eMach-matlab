% clear
f = 132;
w = 2*pi*f;
% t = linspace(0,1/132,1000);
Xm = 25;

% Mover position
x1 = linspace(-Xm,Xm,32);
dx = x1(2) - x1(1);
x2 = linspace(Xm - dx,-Xm,31);

% % First half-cycle
% Im = 1;
% iu1 = Im*sqrt(1-(x1/Xm).^2);
% iv1 = -1/2*iu1 + sqrt(3)/2*(x1/Xm);
% iw1 = -1/2*iu1 - sqrt(3)/2*(x1/Xm);
% 
% % Second half-cycle
% Im = 1;
% iu2 = -Im*sqrt(1-(x2/Xm).^2);
% iw2 = -1/2*iu2 + sqrt(3)/2*(x2/Xm);
% iv2 = -1/2*iu2 - sqrt(3)/2*(x2/Xm);

% First half-cycle
Im = 10;
iu1 = Im*(-x1/Xm);
iv1 = -1/2*iu1 + Im*sqrt(3)/2*sqrt(1-(x1/Xm).^2);
iw1 = -1/2*iu1 - Im*sqrt(3)/2*sqrt(1-(x1/Xm).^2);

% Second half-cycle
Im = 10;
iu2 = Im*(-x2/Xm);
iw2 = -1/2*iu2 - Im*sqrt(3)/2*sqrt(1-(x2/Xm).^2);
iv2 = -1/2*iu2 + Im*sqrt(3)/2*sqrt(1-(x2/Xm).^2);

% close all
plot([x1 x2],[iu1 iu2],[x1 x2],[iv1 iv2],[x1 x2],[iw1 iw2]);

t1 = 1/w*acos(x1/(-Xm));
t2 = 1/(2*f) + 1/(2*pi*f)*acos(x2/Xm);

figure
plot([t1 t2],[iu1 iu2],[t1 t2],[iv1 iv2],[t1 t2],[iw1 iw2])
legend('u','v','w')