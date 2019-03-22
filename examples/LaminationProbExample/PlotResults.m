close all
n=1:20; lw = 3;

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
plot(n,IronOhmicLossesTHM19,n,IronOhmicLossesTrM19,'Linewidth',lw)
xlabel('Number of laminations'); ylabel('Iron ohmic losses (W)')
legend('Time-harmonic','Transient')

figure
plot(n,ByStM19,n,ByTHM19,n,ByTrM19,'Linewidth',lw)
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
plot(n,IronOhmicLossesTHHiperco,n,IronOhmicLossesTrHiperco,'Linewidth',lw)
xlabel('Number of laminations'); ylabel('Iron ohmic losses (W)')
legend('Time-harmonic','Transient')
ylim([0 0.4])

figure
plot(n,ByStHiperco,n,ByTHHiperco,n,ByTrHiperco,'Linewidth',lw)
xlabel('Number of laminations'); ylabel('|By| (T)')
legend('Static','Time-harmonic','Transient')

%% Both materials

figure
plot(n,IronOhmicLossesTrM19,n,IronOhmicLossesTrHiperco,'Linewidth',1.5)
xlabel('Number of laminations'); ylabel('Iron ohmic losses (W)')
legend('M-19, transient','Hiperco, transient')
% ylim([0 0.4])

figure
plot(n,ByTrM19,n,ByTrHiperco,'Linewidth',lw)
xlabel('Number of laminations'); ylabel('|By| (T)')
legend('M-19, transient','Hiperco, transient')