% This example shows you how to use eMach to build your own model and do
% 2D finite element analysis with JMAG. -Jiahao Chen 4/3/2019
close all
clear all
clc
DRAW_JMAG = 1;

%% STEP 1. Create your own cross-section class inherited from CrossSectBase.
% Specifically, copy the file named CrossSecArc.m to this directory, and
% rename it to CrossSectDropShapeRotorCore. After editing this file, now we
% are ready to build a CrossSect object:
rotorCore = CrossSectDropShapeRotorCore( ...
        'name', 'rotorCore', ...
        'dim_d_rs', DimMillimeter(25.757668424038076-17.40950965258518), ... % depth rotor slot
        'dim_d_ro', DimMillimeter(1.1348252075519367), ... % depth rotor open
        'dim_w_ro', DimMillimeter(1.1067883900384972), ... % width rotor open
        'dim_w_rs1', DimMillimeter(1.9075063684099876), ... % width rotor slot 1 (the outer one)
        'dim_w_rs2', DimMillimeter(0.2683492266976364), ... % width rotor slot 2 (the inner one)
        'dim_D_or', DimMillimeter(28.8*2), ... % Diameter outer rotor
        'dim_D_ir', DimMillimeter(2.633926*2), ... % Diameter inner rotor
        'Qr', 16, ... % Number of rotor slots
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );

%% Define components

%% Draw via JMAG

if (DRAW_JMAG)
    toolJd = JMAG();
    toolJd.open(0,0,true);

    toolJd.getSketch('RotorCore', '#FE840E');
    myToken = rotorCore.draw(toolJd)
    rotorCore % token is lost in CrossSect object here
    
    % Region
    toolJd.doc.GetSelection().Clear();
    for i = 1:length(myToken.token)
        %myToken.token(i).GetName()
        toolJd.doc.GetSelection().Add(toolJd.sketch.GetItem(myToken.token(i).GetName()));
    end
    toolJd.sketch.CreateRegions();
    region1 = toolJd.sketch.GetItem('Region');

    % Mirror
    toolJd.regionMirrorCopy(region1, myToken.token(end), [], true);

    % RotateCopy
    toolJd.regionCircularPattern360Origin(region1, rotorCore.Qr, true, false);
    
    %toolJd.sketch.CloseSketch();
    %toolJd.viewAll();
end
