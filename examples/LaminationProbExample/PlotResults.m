close all
n=[1:20, 50]; lw = 3;
% 50 laminations results:
% M19: 
lossesTrM19_50 = 0.0096; peakBTrM19_50 = 0.7727; 
lossesTHM19_50 = 0.0316; peakBTHM19_50 = 0.4158;
% Hiperco: 
lossesTrHip_50 = 0.0075; peakBTrHip_50 = 0.6460;
lossesTHHip_50 = 0.0252; peakBTHHip_50 = 0.3453;
%% M-19

load('solDataStaticM19.mat')
for i=1:length(solutionData)
    ByStM19(i)=solutionData(i).ByAvg;
end

load('solDataTHM19.mat')
for i=1:length(solutionData)
    IronOhmicLossesTHM19(i)=solutionData(i).TotalOhmicLosses;
    ByTHM19(i)=solutionData(i).ByAvg*sqrt(2);
end

load('solDataTransientM19.mat')
for i=1:length(solutionData)
    IronOhmicLossesTrM19(i)=solutionData(i).TotalOhmicLosses;
    ByTrM19(i)=solutionData(i).Bypeak;
end


figure
plot(n,[IronOhmicLossesTHM19,lossesTHM19_50],n,[IronOhmicLossesTrM19,lossesTrM19_50],'Linewidth',lw)
xlabel('Number of laminations'); ylabel('Iron ohmic losses (W)')
legend('Time-harmonic','Transient')

figure
plot(n,[ByStM19,1],n,[ByTHM19,peakBTHM19_50],n,[ByTrM19,peakBTrM19_50],'Linewidth',lw)
xlabel('Number of laminations'); ylabel('|By| (T)')
legend('Static','Time-harmonic','Transient')

%% Hiperco

load('solDataStaticHiperco.mat')
for i=1:length(solutionData)
    ByStHiperco(i)=solutionData(i).ByAvg;
end

load('solDataTHHiperco.mat')
for i=1:length(solutionData)
    IronOhmicLossesTHHiperco(i)=solutionData(i).TotalOhmicLosses;
    ByTHHiperco(i)=solutionData(i).ByAvg*sqrt(2);
end

load('solDataTransientHiperco.mat')
for i=1:length(solutionData)
    IronOhmicLossesTrHiperco(i)=solutionData(i).TotalOhmicLosses;
    ByTrHiperco(i)=solutionData(i).Bypeak;
end


figure
plot(n,[IronOhmicLossesTHHiperco,lossesTHHip_50],n,[IronOhmicLossesTrHiperco,lossesTrHip_50],'Linewidth',lw)
xlabel('Number of laminations'); ylabel('Iron ohmic losses (W)')
legend('Time-harmonic','Transient')
ylim([0 0.4])

figure
plot(n,[ByStHiperco,1],n,[ByTHHiperco,peakBTHHip_50],n,[ByTrHiperco,peakBTrHip_50],'Linewidth',lw)
xlabel('Number of laminations'); ylabel('|By| (T)')
legend('Static','Time-harmonic','Transient')

%% Both materials

figure
plot(n,[IronOhmicLossesTrM19,lossesTrM19_50],n,[IronOhmicLossesTrHiperco,lossesTrHip_50],'Linewidth',1.5)
xlabel('Number of laminations'); ylabel('Iron ohmic losses (W)')
legend('M-19, transient','Hiperco, transient')
% ylim([0 0.4])

figure
plot(n,[ByTrM19,peakBTrM19_50],n,[ByTrHiperco,peakBTrHip_50],'Linewidth',lw)
xlabel('Number of laminations'); ylabel('|By| (T)')
legend('M-19, transient','Hiperco, transient')

%% Iron conductivity = 0
k = ones(length(n),1); ByStCondZero = 1.05*k; ByTHCondZero = 0.71*k;
ByTrCondZero = 1.05*k;
figure
plot(n,ByStCondZero,n,ByTHCondZero,n,ByTrCondZero,'Linewidth',lw)
legend('Static','Time-harmonic','Transient')
xlabel('Number of laminations'); ylabel('|By| (T)')
ylim([0 1.2])
