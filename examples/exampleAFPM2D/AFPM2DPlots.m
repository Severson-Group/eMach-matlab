clear all;
close all;
clc;
load('AFPMSolution.mat')

figure(1)
plot(solutiondata.time,-solutiondata.torque,'color','r','linewidth',2.0);
ylim([0,13])
xlabel('Time [ms]');
ylabel('Torque [Nm]');
title('Torque from 2D-Equivalent Model');

figure(2)
plot(solutiondata.time,-solutiondata.flux_A,'color','r','linewidth',2.0);
hold on
plot(solutiondata.time,-solutiondata.flux_B,'color','m','linewidth',2.0);
plot(solutiondata.time,-solutiondata.flux_C,'color','b','linewidth',2.0);
xlabel('Time [ms]');
ylabel('Flux linkage [Wb]');
title('Flux linkage');
legend(['Phase A'],['Phase B'],['Phase C']);

figure(3)
plot(solutiondata.time,solutiondata.voltage_A,'color','r','linewidth',2.0);
hold on
plot(solutiondata.time,solutiondata.voltage_B,'color','m','linewidth',2.0);
plot(solutiondata.time,solutiondata.voltage_C,'color','b','linewidth',2.0);
xlabel('Time [ms]');
ylabel('Back EMF [V]');
title('Back EMF');
legend(['Phase A'],['Phase B'],['Phase C']);
ylim([-75,75]);


