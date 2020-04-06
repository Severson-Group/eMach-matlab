% close all; 
clc; clear

source.J = 10; % A/mm^2
source.coilfillfactor = 0.5;
source.wire_cond = 58; % MS/m;
source.f = 132;
% source.num_iter = 31;
source.Pout_des = 1125;
source.P_des = 2.7*10^6;
source.phases = 3;
source.winding.slots.zQ = [-1, 1, -1, 1, -1, 1];
source.winding.slots.circuit = [{'U'}, {'W'}, {'V'},{'U'}, {'W'}, {'V'}];
% source.winding.slots.circuit = [{'U'}, {'W'}, {'V'},{'V'}, {'W'}, {'U'}];

if source.phases == 1
    source.Q = 2;
    source.p = 1;
elseif source.phases == 3
    source.Q = 6;
    source.p = 1;
end


params = [62.89*2/source.Q 15.44*2/source.Q 8.18*2/source.Q 12.74 13.78 1.32 3.86 2.48 11.19 21.06/source.p 1.07 1];

% params = [62.89 15.44 8.18 12.74 13.78 1.32 3.86 2.48 11.19 21.06*source.Q/2 1.07 1];
params = round(params,2);

returnParameter = ConstructLinearMotor(0,0,1,params,source);
FemmProblem = returnParameter.FemmProblem;
slot_area = returnParameter.slot_area;

plotfemmproblem(FemmProblem);


% Plot the geometry
%     toolXFEMM.plot(FemmProblem);

% Solve and extract force vs. mover position
filename = 'exampleLinearMotor.fem';
stroke = 62.89/2;
Xm = stroke/2;
x1 = linspace(-Xm,Xm,32);
dx = x1(2) - x1(1);
x2 = linspace(Xm - dx,-Xm,31);
x = [x1 x2];
Dx = [x(2:end) - x(1:(end-1)), 0];

myfpproc = fpproc();

FemmProblem = translategroups_mfemm(FemmProblem, 1, 0, stroke/2);
FemmProblem = translategroups_mfemm(FemmProblem, 2, 0, stroke/2);
for m = 11:(10+3*source.p)
    FemmProblem = translategroups_mfemm(FemmProblem, m, 0, stroke/2);
end

Im = abs(source.J*source.coilfillfactor*slot_area);

% Sine
% iu1 = Im*sqrt(1-(x1/Xm).^2);
% iv1 = -1/2*iu1 + Im*sqrt(3)/2*(x1/Xm);
% iw1 = -1/2*iu1 - Im*sqrt(3)/2*(x1/Xm);
% t = 1/(2*pi*source.f)*acos(x1/(-Xm));
% iu1 = Im*sin(2*pi*source.f*t);
% iv1 = Im*sin(2*pi*source.f*t - 2*pi/3);
% iw1 = Im*sin(2*pi*source.f*t - 4*pi/3);

% Cosine
t1 = 1/(2*pi*source.f)*acos(x1/(-Xm));
alpha = pi/6;
iu1 = Im*cos(2*pi*source.f*t1 - alpha);
iv1 = Im*cos(2*pi*source.f*t1 - 2*pi/3 - alpha);
iw1 = Im*cos(2*pi*source.f*t1 - 4*pi/3 - alpha);

t2 = 1/(2*source.f) + 1/(2*pi*source.f)*acos(x2/Xm);
iv2 = Im*cos(2*pi*source.f*t2 - alpha);
iu2 = Im*cos(2*pi*source.f*t2 - 2*pi/3 - alpha);
iw2 = Im*cos(2*pi*source.f*t2 - 4*pi/3 - alpha);
iu = [iu1 iu2];
iv = [iv1 iv2];
iw = [iw1 iw2];

% Cosine wrt x
Xm0 = 62.89/4;
% iu1 = Im*cos((x1+Xm0)/(2*Xm0)*pi - pi/6);
% iv1 = Im*cos((x1+Xm0)/(2*Xm0)*pi - 2*pi/3 - pi/6);
% iw1 = Im*cos((x1+Xm0)/(2*Xm0)*pi - 4*pi/3 - pi/6);

% Square waves
% iub = sin(2*pi*source.f*t);
% ivb = sin(2*pi*source.f*t - 2*pi/3);
% iwb = sin(2*pi*source.f*t - 4*pi/3);
% iu1 = Im*sign(iub);
% iv1 = Im*sign(ivb);
% iw1 = Im*sign(iwb);

for i=1:length(x)
        fprintf('Mover position %i of %i\n',i,length(x));
        
        if source.phases == 1
%             FemmProblem = setcircuitcurrent(FemmProblem, 'Circuit 1', iu1(i));
            FemmProblem = setcircuitcurrent(FemmProblem, 'Circuit 1', Im);
        end
        
        if source.phases == 3
            FemmProblem = setcircuitcurrent(FemmProblem, 'U', iu(i));
            FemmProblem = setcircuitcurrent(FemmProblem, 'V', iv(i));
            FemmProblem = setcircuitcurrent(FemmProblem, 'W', iw(i));
%             FemmProblem = setcircuitcurrent(FemmProblem, 'U', Im);
%             FemmProblem = setcircuitcurrent(FemmProblem, 'V', -Im/2);
%             FemmProblem = setcircuitcurrent(FemmProblem, 'W', -Im/2);
        end
        
        writefemmfile(filename, FemmProblem);
        ansfile = analyse_mfemm(filename);
        myfpproc.opendocument(ansfile);
        myfpproc.groupselectblock(1)
        for m = 11:(10+3*source.p)
            myfpproc.groupselectblock(m)
        end
        Force(i) = -myfpproc.blockintegral(19);
        
        circuitprops = myfpproc.getcircuitprops('U');
        LinkageU(i) = circuitprops(3);
        circuitprops = myfpproc.getcircuitprops('V');
        LinkageV(i) = circuitprops(3);        
        circuitprops = myfpproc.getcircuitprops('W');
        LinkageW(i) = circuitprops(3);
        
        FemmProblem = translategroups_mfemm(FemmProblem, 1, 0, -Dx(i));
        FemmProblem = translategroups_mfemm(FemmProblem, 2, 0, -Dx(i));
        for m = 11:(10+3*source.p)
            FemmProblem = translategroups_mfemm(FemmProblem, m, 0, -Dx(i));
        end
end



% Plot results
figure
plot([t1 t2],Force,'Linewidth',3)
ylabel('Force (N)'); xlabel('Mover position (mm)');

% figure,plot(xx,Fsq/sqrt(2),xx,F1ph,xx,F3ph,x1,F3ph_1,x1,Force);