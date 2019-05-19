clc
clear
%%
w = 16.5;
w_c = 61.6;
t_m = 17.6;
t_y = 7.9;
h = 28;
g = 1;
w_m = 46.2;
p = 2;
Q = 3;
%%
timeStep = 0.005; %ms
elecFreq = 1000; %Hz
elecPeriod = 1/elecFreq*1e3; %ms
currentAmplitude = 167.3; %Amp

  
%% Call the function to construct the model
    
    [toolMn,coil_A,coil_B,coil_C] = ConstructAFPM2DExample(t_y, t_m, g, h, w_m, w_c, w, p, Q);

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
    endTime = 1;
    
    timeSettings = [0, timeStep, endTime];
    mn_d_setparameter(toolMn.doc, '', 'TimeSteps', ...
        sprintf('[%g %%ms, %g %%ms, %g %%ms]', timeSettings), ...
        get(toolMn.consts,'infoArrayParameter'));
    
    solData = invoke(toolMn.doc, 'solveTransient2dwithmotion');


