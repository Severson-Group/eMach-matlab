% close all; clc; clear

source.J=10; % A/mm^2
source.coilfillfactor=0.3523;
source.number_of_dups=1;
source.wire_cond=58; % MS/m;
% source.WindingTemp=0;
source.f = 132;
% source.num_iter = 31;
source.Pout_des = 1125;
source.P_des = 2.7*10^6;
source.NS = 2;
source.np = 1;

params = [73.3282125684640,0.585679708175381,0.490939703883842,0.510995493884558,0.334803805164151,0.698325727773407,11.1902820494481,1.07027060534535,62.8885392079727,1.23142283575328,0.127156092792599,0.341968957871397,1,0.784733853086332];
params = round(params,2);

[FemmProblem,otherParams] = ConstructLinearMotorExample([0 0 1],params,source);

plotfemmproblem(FemmProblem);


% Plot the geometry
%     toolXFEMM.plot(FemmProblem);

% % Solve and extract force vs. mover position
% filename = 'exampleLinearMotor.fem';
% stroke = 12.6; dx = 0.5;
% moverPosition = -stroke/2:dx:stroke/2;
% myfpproc = fpproc();
% FemmProblem = translategroups_mfemm(FemmProblem, 2, 0, stroke/2);
% for i=1:length(moverPosition)
%         fprintf('Mover position %i of %i\n',i,length(moverPosition));
%         writefemmfile(filename, FemmProblem);
%         ansfile = analyse_mfemm(filename);
%         myfpproc.opendocument(ansfile);
%         myfpproc.groupselectblock(2);
%         Force(i) = -myfpproc.blockintegral(19);
%         FemmProblem = translategroups_mfemm(FemmProblem, 2, 0, -dx);
% end
%     
% % Plot results
% figure
% plot(moverPosition,Force,'Linewidth',3)
% ylabel('Force (N)'); xlabel('Mover position (mm)');
%     ylim([0 1000]);