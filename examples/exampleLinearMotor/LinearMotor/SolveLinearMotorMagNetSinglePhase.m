% construct: adjust some parts to any number of slots and poles or use
% symmetry
% construct: XFEMM with pure components
% extract parameters: force, field values, losses
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

params = [73.3282125684640,0.585679708175381,0.490939703883842,0.510995493884558,0.334803805164151,0.698325727773407,11.1902820494481,1.07027060534535,62.8885392079727,1.23142283575328,0.127156092792599,0.341968957871397,1,0.784733853086332];
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
    endTime = Period; %ms
    timeSettings = [0, timeStep, endTime];
    
    mn_d_setparameter(toolMn.doc, '', 'TimeSteps', ...
        sprintf('[%g %%ms, %g %%ms, %g %%ms]', timeSettings), ...
        get(toolMn.consts,'infoArrayParameter'));
    % Solve transient with motion
    solData = invoke(toolMn.doc, 'solveTransient2dwithMotion');
end
