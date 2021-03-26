clc
clear
close all

%% Dimensions
    w = 16.5;   % Conductor width [mm]
    w_c = 61.6; % Coil pitch [mm]
    t_m = 17.6; % Magnet thickness (axial)[mm]
    t_y = 7.9;  % Rotor Back Iron thickness (axial)[mm]
    h = 28;     % Stator thickness (axial)[mm]
    g = 1;      % Air gap thickness [mm]
    w_m = 46.2; % Magnet width [mm]
    p = 2;      % No. of pole pairs being modeled
    Q = 3;      % No. of stator coils being modeled
    R_avg = 58.8e-3; % Avg radius at which model is made [m]
    RPM = 15000; % Machine speed in [Rev/min]
    linspeed = (RPM*2*pi/60)*R_avg; %Equivalent Linear speed at Avg. Magnet radius [m/s]

%% Transient solve parameters
    timeStep = 0.05; % ms
    endTime = 1; % ms
    elecFreq = 1000; % Hz
    elecPeriod = 1/elecFreq*1e3; % ms
    currentAmplitude = 167.3; % Amp

%% Call the function to construct the model
    [toolMn,coil_A,coil_B,coil_C] = ConstructAFPM2DExample(t_y, t_m, g, ...
        h, w_m, w_c, w, p, Q,linspeed);

%% Set up the excitation
    mn_d_setparameter(toolMn.doc, coil_A, 'WaveFormType', 'SIN', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil_A, 'WaveFormValues', ...
        sprintf('[0, %g, %g, 0, 0, 0]', currentAmplitude, elecFreq), ...
        get(toolMn.consts,'InfoArrayParameter'));
    mn_d_setparameter(toolMn.doc, coil_B, 'WaveFormType', 'SIN', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil_B, 'WaveFormValues', ...
        sprintf('[0, %g, %g, 0, 0, -120]', currentAmplitude, elecFreq), ...
        get(toolMn.consts,'InfoArrayParameter'));
    mn_d_setparameter(toolMn.doc, coil_C, 'WaveFormType', 'SIN', ...
        get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, coil_C, 'WaveFormValues', ...
        sprintf('[0, %g, %g, 0, 0, 120]', currentAmplitude, elecFreq), ...
        get(toolMn.consts,'InfoArrayParameter'));

 %% Set transient solver options and solve
    timeSettings = [0, timeStep, endTime];
    mn_d_setparameter(toolMn.doc, '', 'TimeSteps', ...
        sprintf('[%g %%ms, %g %%ms, %g %%ms]', timeSettings), ...
        get(toolMn.consts,'infoArrayParameter'));
    
    solData = invoke(toolMn.doc, 'solveTransient2dwithmotion');
    
 %% Post Processing
    time = mn_getTimeInstants(toolMn.mn, 1, true);
    
 % Forces on moving components 
    bodyID = mn_findBody(toolMn.mn, toolMn.doc, 'compStatorVA', 1);
    Forces_X = mn_readForceOnBody(toolMn.mn, toolMn.doc, bodyID, 0, 1);

 % Flux waveforms
    flux_A = mn_readCoilFluxLinkage(toolMn.mn, toolMn.doc, coil_A, 1);
    flux_B = mn_readCoilFluxLinkage(toolMn.mn, toolMn.doc, coil_B, 1);
    flux_C = mn_readCoilFluxLinkage(toolMn.mn, toolMn.doc, coil_C, 1);
    
 % Voltage waveforms
    voltage_A = mn_readCoilVoltage(toolMn.mn, toolMn.doc, coil_A, 1);
    voltage_B = mn_readCoilVoltage(toolMn.mn, toolMn.doc, coil_B, 1);
    voltage_C = mn_readCoilVoltage(toolMn.mn, toolMn.doc, coil_C, 1);
    
%% Scale and store data
    solutiondata.time=time;
    solutiondata.force = 2*Forces_X(:,2);
    solutiondata.flux_A = 2*flux_A(:,2);
    solutiondata.flux_B = 2*flux_B(:,2);
    solutiondata.flux_C = 2*flux_C(:,2);
    solutiondata.voltage_A = 2*voltage_A(:,2);
    solutiondata.voltage_B = 2*voltage_B(:,2);
    solutiondata.voltage_C = 2*voltage_C(:,2);
    save('AFPMSolution.mat','solutiondata');

%% Close MagNet
toolMn.close();
delete(toolMn);
