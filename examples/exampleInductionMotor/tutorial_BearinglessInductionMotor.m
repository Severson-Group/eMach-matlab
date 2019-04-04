% This example shows you how to use eMach to build your own model and do
% 2D finite element analysis with JMAG. -Jiahao Chen 4/3/2019
close all
clear
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

cs = [rotorCore];

comp1 = Component( ...
        'name', 'rotorCore', ...
        'crossSections', cs, ...
        'material', MaterialGeneric('name', 'M19: USS Transformer 72 -- 29 Gage'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(0)) ...
        );

%% Draw via JMAG

if (DRAW_JMAG)
    toolJd = JMAG();
    toolJd.open(0,0,true);

    toolJd.getSketch('RotorCore', '#FE840E');
    comp1.make(toolJd,toolJd);

    % At this point, I cannot create a region for my component in JMAG,
    % because the segments or token are lost, i.e., rotorCore.mySegments is
    % {}. This is not gonna happen in Python. Don't konw how to fix it.
    rotorCore

    %toolJd.viewAll();
end
