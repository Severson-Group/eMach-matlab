% construct: adjust some parts to any number of slots and poles or use
% symmetry
% construct: XFEMM with pure components
% extract field values if needed (maybe for PM loss at post-processing)
% get results for different number of slots/poles
% try a different motor: single-sided or double-sided flat

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
num_iter = 30;

% params = [73.3282125684640,0.585679708175381,0.490939703883842,0.510995493884558,0.334803805164151,0.698325727773407,11.1902820494481,1.07027060534535,62.8885392079727,1.23142283575328,0.127156092792599,0.341968957871397,1,0.784733853086332];
params = [73.3282125684640,0.585679708175381,0.490939703883842,0.510995493884558,0.334803805164151,0.698325727773407,11.1902820494481,1.07027060534535,62.8885392079727,1.23142283575328,0.127156092792599,0.341968957871397,1,1];
params = round(params,2);

returnParameter = ConstructLinearMotorExample(1, 0, 0,params,source);
toolMn = returnParameter.toolMn;
coil1 = returnParameter.coilName.coil1;
coil2 = returnParameter.coilName.coil2;
slot_area1 = returnParameter.slot_area.slot_area1;
slot_area2 = returnParameter.slot_area.slot_area2;
motionComponent = returnParameter.motionComponent;
stroke = returnParameter.stroke;
current1 = 13.1; %source.J*source.coilfillfactor*slot_area1; %Amp
current2 = 13.1; %source.J*source.coilfillfactor*slot_area2; %Amp

solveStatic = 0; solveTransient = 1;

if solveStatic
    
    % Set up motion parameters
    PositionAtStartup = linspace(stroke/2,-stroke/2,num_iter);
    mn_d_setparameter(toolMn.doc, motionComponent, 'PositionAtStartup',...
        [sprintf('%g, ', PositionAtStartup(1:(end-1))) sprintf('%g', PositionAtStartup(end))], ...
    get(toolMn.consts,'infoNumberParameter'));

    % Set up the excitation
    mn_d_setparameter(toolMn.doc, coil1, 'WaveFormType', 'DC', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil2, 'WaveFormType', 'DC', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil1, 'Current', current1, ...
        get(toolMn.consts,'infoNumberParameter'));
    mn_d_setparameter(toolMn.doc, coil2, 'Current', current2, ...
        get(toolMn.consts,'infoNumberParameter'));
    
    % Solve static
    solData = invoke(toolMn.doc, 'solveStatic2d');
    
    
    
elseif solveTransient
    
    Freq = source.f; %Hz
    
    % Set up motion parameters
    t = linspace(0,1/Freq,50);
    x = stroke/2*cos(2*pi*Freq*t);
    for i = 1:2:(2*length(t))
        tx(i) = t((i+1)/2);
        tx(i+1) = x((i+1)/2);
    end
    
    mn_d_setparameter(toolMn.doc, motionComponent, 'PositionVsTime',...
        ['[' sprintf('%g, ',tx(1:(end-2))) sprintf('%g',tx(end-1)) ']'],...
    get(toolMn.consts,'InfoArrayParameter'));    
    
    % Set up the excitation
    mn_d_setparameter(toolMn.doc, coil1, 'WaveFormType', 'PWL', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil1, 'WaveFormValues', ...
        sprintf('[0, %g, %g, %g, %g, %g, %g, %g, %g]', ...
        current1, 0.5/Freq, current1, 0.5/Freq+1e-7,...
        -current1, 1/Freq, -current1, 1/Freq+1e-7), ...
        get(toolMn.consts,'InfoArrayParameter'));
    mn_d_setparameter(toolMn.doc, coil2, 'WaveFormType', 'PWL', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil2, 'WaveFormValues', ...
        sprintf('[0, %g, %g, %g, %g, %g, %g, %g, %g]', ...
        current2, 0.5/Freq, current2, 0.5/Freq+1e-7,...
        -current2, 1/Freq, -current2, 1/Freq+1e-7), ...
        get(toolMn.consts,'InfoArrayParameter'));
    
    % Set up transient solver parameters
    Period = 1/Freq*1e3; %ms
    timeStep = Period/50; %ms
    startTime = 2*Period; %ms
    endTime = 3*Period; %ms
    timeSettings = [0, timeStep, endTime];
    
    mn_d_setparameter(toolMn.doc, '', 'TimeSteps', ...
        sprintf('[%g %%ms, %g %%ms, %g %%ms]', timeSettings), ...
        get(toolMn.consts,'infoArrayParameter'));
    
    % Set transient solver options and solve
    mn_d_setparameter(toolMn.doc,'','TransientAveragePowerLossStartTime', [sprintf("%d",startTime),'%ms'],...
        get(toolMn.consts,'InfoNumberParameter')); %Transient Power loss start time
    mn_d_setparameter(toolMn.doc,'','TransientAveragePowerLossStopTime', [sprintf("%d",endTime),'%ms'],...
        get(toolMn.consts,'InfoNumberParameter')); %Transient Power loss stop time
      
    % Solve transient with motion
    solData = invoke(toolMn.doc, 'solveTransient2dwithMotion');
    
    %% Post Processing
    time = mn_getTimeInstants(toolMn.mn, 1, true); %Get the time instants

    % Forces on moving components
    bodyID = mn_findBody(toolMn.mn, toolMn.doc, 'moverIronComp1', 1); %Find body ID of the mover
                                                                    
    forcesY = mn_readForceOnBody(toolMn.mn, toolMn.doc, bodyID, 1, 1); %Find x direction force on the mover
    
    % Ohmic losses (includes eddy current losses)
    StatorOhmicLosses = mn_readConductorOhmicLoss(toolMn.mn, toolMn.doc, 'statorIronComp1',1);
    StatorOhmicLosses = mean(StatorOhmicLosses(end-round(Period/timeStep):end,2));
    MoverOhmicLosses = mn_readConductorOhmicLoss(toolMn.mn, toolMn.doc, 'moverIronComp1',1);
    MoverOhmicLosses = mean(MoverOhmicLosses(end-round(Period/timeStep):end,2));
    coil11OhmicLosses = mn_readConductorOhmicLoss(toolMn.mn, toolMn.doc, 'coil11Comp1',1);
    coil11OhmicLosses = mean(coil11OhmicLosses(end-round(Period/timeStep):end,2)); 
    coil12OhmicLosses = mn_readConductorOhmicLoss(toolMn.mn, toolMn.doc, 'coil12Comp1',1);
    coil12OhmicLosses = mean(coil12OhmicLosses(end-round(Period/timeStep):end,2)); 
    coil21OhmicLosses = mn_readConductorOhmicLoss(toolMn.mn, toolMn.doc, 'coil21Comp1',1);
    coil21OhmicLosses = mean(coil21OhmicLosses(end-round(Period/timeStep):end,2)); 
    coil22OhmicLosses = mn_readConductorOhmicLoss(toolMn.mn, toolMn.doc, 'coil22Comp1',1);
    coil22OhmicLosses = mean(coil22OhmicLosses(end-round(Period/timeStep):end,2)); 
    coilOhmicLosses = coil11OhmicLosses+coil12OhmicLosses+coil21OhmicLosses+coil22OhmicLosses;
    
    % Iron losses using Steinmetz equations
    [hystLoss1, ecLoss1] = mn_ds_getIronLossInComponent(toolMn.mn, ...
                                'statorIronComp1', 1);
    [hystLoss2, ecLoss2] = mn_ds_getIronLossInComponent(toolMn.mn, ...
                                'moverIronComp1', 1);
    hystLoss = hystLoss1 + hystLoss2;
    ecLoss = ecLoss1+ecLoss2;
    
    % Magnet losses
    magnets =[{'magnet1Comp1'},{'magnet2Comp1'},{'magnet3Comp1'}];

    for i = 1:length(magnets)
         PMLosses = mn_readConductorOhmicLoss(toolMn.mn, ...
                                toolMn.doc, magnets{i}, 1);
         PMLoss(i) = mean(PMLosses(end-round(Period/timeStep):end,2)); %Compute Magnet loss starting from the avg transient power loss start time
    end
    totalPMLoss = sum(PMLoss);
    
    % Total loss
    allLossesECSolve = StatorOhmicLosses+MoverOhmicLosses+hystLoss+coilOhmicLosses+totalPMLoss;
    allLosses = ecLoss+hystLoss+coilOhmicLosses+totalPMLoss;
    
    % Output power
    force = -forcesY(end-round(Period/timeStep):end,2);
    speed = stroke/2*2*pi*Freq*sin(2*pi*Freq*time/1000);      
    speed = speed(end-round(Period/timeStep):end);    
    Pout = mean(force.*speed);
    
    % Efficiency
    EffECSolve = Pout/(Pout+allLossesECSolve);
    Eff = Pout/(Pout+allLosses);
    
    Output.Eff = Eff;
    Output.Pout = Pout;
    Output.force = force;
    Output.time = time(101:151);
    
% %%save('AFPMSolution.mat','solutiondata');
% %% dos('taskkill /F /IM MagNet.exe');
% invoke(toolMn.mn, 'processcommand','CALL close(False)'); %%Close MagNet
    
end
