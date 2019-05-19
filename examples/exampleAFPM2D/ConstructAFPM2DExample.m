function [toolMn,coil_A,coil_B,coil_C] = ConstructAFPM2DExample(t_y, t_m, g, h, w_m, w_c, w, p, Q, linspeed)
MES_Remesh = 2; %Max element size for remesh region
toolMn = MagNet();
toolMn.open(0,0,true);
toolMn.setDefaultLengthUnit('millimeters', false);

%% Stator VA
CsStatorVA = CrossSectSolidRect( ...
        'name', 'csStatorVA', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(h + g/2),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + 3*g/4]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compStatorVA = Component( ...
        'name', 'compStatorVA', ...
        'crossSections', CsStatorVA, ...
        'material', MaterialGeneric('name', 'Virtual Air'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compStatorVA.make(toolMn, toolMn);
toolMn.viewAll();
%% Rotor 1 Air/Remesh

CsRotorAir1 = CrossSectSolidRect( ...
        'name', 'csRotorAir1', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(t_y + t_m + 1),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,-1]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compRotorAir1 = Component( ...
        'name', 'compRotorAir1', ...
        'crossSections', CsRotorAir1, ...
        'material', MaterialGeneric('name', 'AIR'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compRotorAir1.make(toolMn, toolMn);
toolMn.viewAll();

CsRotor1VA = CrossSectSolidRect( ...
        'name', 'csRotor1VA', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(g/4),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compRotor1VA = Component( ...
        'name', 'compRotor1VA', ...
        'crossSections', CsRotor1VA, ...
        'material', MaterialGeneric('name', 'Virtual Air'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compRotor1VA.make(toolMn, toolMn);
toolMn.viewAll();

CsRotor1Remesh = CrossSectSolidRect( ...
        'name', 'csRotor1Remesh', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(g/4),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + g/4]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compRotor1Remesh = Component( ...
        'name', 'compRotor1Remesh', ...
        'crossSections', CsRotor1Remesh, ...
        'material', MaterialGeneric('name', 'AIR'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compRotor1Remesh.make(toolMn, toolMn);
toolMn.viewAll();

%% Rotor 2 Air/Remesh

CsRotorAir2 = CrossSectSolidRect( ...
        'name', 'csRotorAir2', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(t_y + t_m + 1),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + 8*g/4 + h]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compRotorAir2 = Component( ...
        'name', 'compRotorAir2', ...
        'crossSections', CsRotorAir2, ...
        'material', MaterialGeneric('name', 'AIR'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compRotorAir2.make(toolMn, toolMn);
toolMn.viewAll();

CsRotor2VA = CrossSectSolidRect( ...
        'name', 'csRotor2VA', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(g/4),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + 7*g/4 + h]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compRotor2VA = Component( ...
        'name', 'compRotor2VA', ...
        'crossSections', CsRotor2VA, ...
        'material', MaterialGeneric('name', 'Virtual Air'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compRotor2VA.make(toolMn, toolMn);
toolMn.viewAll();

CsRotor2Remesh = CrossSectSolidRect( ...
        'name', 'csRotor2Remesh', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(g/4),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + 6*g/4 + h ]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compRotor2Remesh = Component( ...
        'name', 'compRotor2Remesh', ...
        'crossSections', CsRotor2Remesh, ...
        'material', MaterialGeneric('name', 'AIR'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compRotor2Remesh.make(toolMn, toolMn);
toolMn.viewAll();
%% Stator 1 Remesh

CsStator1Remesh = CrossSectSolidRect( ...
        'name', 'csStator1Remesh', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(g/4),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + g/2]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compStator1Remesh = Component( ...
        'name', 'compStator1Remesh', ...
        'crossSections', CsStator1Remesh, ...
        'material', MaterialGeneric('name', 'AIR'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compStator1Remesh.make(toolMn, toolMn);
toolMn.viewAll();

%% Stator 2 Remesh

CsStator2Remesh = CrossSectSolidRect( ...
        'name', 'csStator2Remesh', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(g/4),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,t_m + t_y + 5*g/4 + h]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
compStator2Remesh = Component( ...
        'name', 'compStator2Remesh', ...
        'crossSections', CsStator2Remesh, ...
        'material', MaterialGeneric('name', 'AIR'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
compStator2Remesh.make(toolMn, toolMn);
toolMn.viewAll();
%% Rotor Iron 1

CsRotorIron1 = CrossSectSolidRect( ...
        'name', 'RotorIron1', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(t_y),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([0,0]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
iron1 = Component( ...
        'name', 'iron1', ...
        'crossSections', CsRotorIron1, ...
        'material', MaterialGeneric('name', 'Arnon 5'), ...
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
iron1.make(toolMn, toolMn);
toolMn.viewAll();

%% Magnets 1

CSmagnet1s = CrossSectSolidRect( ...
        'name', 'csmag1s', ...
        'dim_w',DimMillimeter(w_m/2),....
        'dim_h',DimMillimeter(t_m),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([0,t_y]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compMag1s = Component( ...
        'name', 'mag1s', ...
        'crossSections', CSmagnet1s, ...
        'material', MaterialGeneric('name', 'Recoma 33E'), ... % Recoma 35 E 
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
    compMag1s.make(toolMn, toolMn);
    mn_d_setparameter(toolMn.doc, compMag1s.name,...
     'MaterialDirection','[0, 1, 0]',get(toolMn.consts,'InfoArrayParameter'));    
    toolMn.viewAll();

for i = 1:2*p - 1
    CSmagnet1(i) = CrossSectSolidRect( ...
        'name', ['csmag1' num2str(i)], ...
        'dim_w',DimMillimeter(w_m),....
        'dim_h',DimMillimeter(t_m),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([w_m/2 + w_m*(i-1),t_y]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compMag1(i) = Component( ...
        'name', ['mag1' num2str(i)], ...
        'crossSections', CSmagnet1(i), ...
        'material', MaterialGeneric('name', 'Recoma 33E'), ... % Recoma 35 E 
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
       dir = -2*mod(i,2) + 1;
       compMag1(i).make(toolMn, toolMn);
       mn_d_setparameter(toolMn.doc, compMag1(i).name, 'MaterialDirection',...
           sprintf('[0, %i, 0]',dir),get(toolMn.consts,'InfoArrayParameter'));
       toolMn.viewAll();
end

CSmagnet1e = CrossSectSolidRect( ...
        'name', 'csmag1e', ...
        'dim_w',DimMillimeter(w_m/2),....
        'dim_h',DimMillimeter(t_m),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([w_m/2 + w_m*(2*p-1),t_y]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compMag1e = Component( ...
        'name', 'mag1e', ...
        'crossSections', CSmagnet1e, ...
        'material', MaterialGeneric('name', 'Recoma 33E'), ... % Recoma 35 E 
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
    compMag1e.make(toolMn, toolMn)
    mn_d_setparameter(toolMn.doc, compMag1e.name, 'MaterialDirection',...
        sprintf('[0, 1, 0]'),get(toolMn.consts,'InfoArrayParameter'));
    toolMn.viewAll();
%% Rotor Iron 2

CsRotorIron2 = CrossSectSolidRect( ...
        'name', 'RotorIron2', ...
        'dim_w',DimMillimeter(w_m*2*p),....
        'dim_h',DimMillimeter(t_y),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([0,t_y + 2*t_m + 2*g + h]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
iron2 = Component( ...
        'name', 'iron2', ...
        'crossSections', CsRotorIron2, ...
        'material', MaterialGeneric('name', 'Arnon 5'), ...
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
iron2.make(toolMn, toolMn);
toolMn.viewAll();
%% Magnets 2
CSmagnet2s = CrossSectSolidRect( ...
        'name', 'csmag2s', ...
        'dim_w',DimMillimeter(w_m/2),....
        'dim_h',DimMillimeter(t_m),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([0,t_y + t_m + 2*g + h]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compMag2s = Component( ...
        'name', 'mag2s', ...
        'crossSections', CSmagnet2s, ...
        'material', MaterialGeneric('name', 'Recoma 33E'), ...  
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(16.6)) ...
        );
    compMag2s.make(toolMn, toolMn);
    mn_d_setparameter(toolMn.doc, compMag2s.name, 'MaterialDirection',...
        sprintf('[0, 1, 0]'),get(toolMn.consts,'InfoArrayParameter'));
    toolMn.viewAll();

for i = 1:2*p - 1
    CSmagnet2(i) = CrossSectSolidRect( ...
        'name', ['csmag2' num2str(i)], ...
        'dim_w',DimMillimeter(w_m),....
        'dim_h',DimMillimeter(t_m),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([w_m/2 + w_m*(i-1),t_y + t_m + 2*g + h]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compMag2(i) = Component( ...
        'name', ['mag2' num2str(i)], ...
        'crossSections', CSmagnet2(i), ...
        'material', MaterialGeneric('name', 'Recoma 33E'), ... 
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
    dir = -2*mod(i,2) + 1;
    compMag2(i).make(toolMn, toolMn);
    mn_d_setparameter(toolMn.doc, compMag2(i).name, 'MaterialDirection',...
            sprintf('[0, %i, 0]',dir),get(toolMn.consts,'InfoArrayParameter'));
    toolMn.viewAll();
end


CSmagnet2e = CrossSectSolidRect( ...
        'name', 'csmag2e', ...
        'dim_w',DimMillimeter(w_m/2),....
        'dim_h',DimMillimeter(t_m),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([w_m/2 + w_m*(2*p-1),t_y + t_m + 2*g + h]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compMag2e = Component( ...
        'name', 'mag2e', ...
        'crossSections', CSmagnet2e, ...
        'material', MaterialGeneric('name', 'Recoma 33E'), ... % Recoma 35 E 
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
    compMag2e.make(toolMn, toolMn);
    mn_d_setparameter(toolMn.doc, compMag2e.name, 'MaterialDirection',...
        sprintf('[0, 1, 0]'),get(toolMn.consts,'InfoArrayParameter'));
    toolMn.viewAll();


%% Inward Coils
for i = 1:Q
    CSCoilIn(i) = CrossSectSolidRect( ...
        'name', ['csCoilIn' num2str(i)], ...
        'dim_w',DimMillimeter(w),....
        'dim_h',DimMillimeter(h),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([w_c/2 - w + w_c*(i-1),t_y + t_m + g]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compCoilIn(i) = Component( ...
        'name', ['compCoilIn' num2str(i)], ...
        'crossSections', CSCoilIn(i), ...
        'material', MaterialGeneric('name', 'Copper: 5.77e7 Siemens/meter'), ...  
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
    compCoilIn(i).make(toolMn, toolMn);
    toolMn.viewAll();
end

%% Outward Coils
  for i = 1:Q
    CSCoilOut(i) = CrossSectSolidRect( ...
        'name', ['csCoilOut' num2str(i)], ...
        'dim_w',DimMillimeter(w),....
        'dim_h',DimMillimeter(h),...
        'location', Location2D( ...
        'anchor_xy', DimMillimeter([w_c/2+w_c*(i-1),t_y + t_m + g]), ...
        'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    compCoilOut(i) = Component( ...
        'name', ['compCoilOut' num2str(i)], ...
        'crossSections', CSCoilOut(i), ...
        'material', MaterialGeneric('name', 'Copper: 5.77e7 Siemens/meter'), ...  
        'makeSolid', MakeExtrude( ...
        'location', Location3D( ...
        'anchor_xyz', DimMillimeter([0,0,0]), ...
        'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
        'dim_depth', DimMillimeter(16.6)) ...
        );
    compCoilOut(i).make(toolMn, toolMn);
    toolMn.viewAll();
    
   end

%Make Coils
    coil_A = mn_d_makeSimpleCoil(toolMn.mn, 1, [{['compCoilIn' num2str(1)]}, {['compCoilOut' num2str(3)]}]);
    mn_d_setparameter(toolMn.doc, coil_A, 'NumberOfTurns', 20, ...
    get(toolMn.consts,'infoNumberParameter'));
    coil_B = mn_d_makeSimpleCoil(toolMn.mn, 1, [{['compCoilIn' num2str(3)]}, {['compCoilOut' num2str(2)]}]);
    mn_d_setparameter(toolMn.doc, coil_B, 'NumberOfTurns', 20, ...
    get(toolMn.consts,'infoNumberParameter'));
    coil_C = mn_d_makeSimpleCoil(toolMn.mn, 1, [{['compCoilIn' num2str(2)]}, {['compCoilOut' num2str(1)]}]);
    mn_d_setparameter(toolMn.doc, coil_C, 'NumberOfTurns', 20, ...
    get(toolMn.consts,'infoNumberParameter'));

%% Setup Mesh
    mn_d_setparameter(toolMn.doc, compRotor1Remesh.name, 'MaximumElementSize', ...
    sprintf('%g %%mm', MES_Remesh), ...
    get(toolMn.consts,'infoNumberParameter'));
    mn_d_setparameter(toolMn.doc, compRotor2Remesh.name, 'MaximumElementSize', ...
    sprintf('%g %%mm', MES_Remesh), ...
    get(toolMn.consts,'infoNumberParameter'));
    mn_d_setparameter(toolMn.doc, compStator1Remesh.name, 'MaximumElementSize', ...
    sprintf('%g %%mm', MES_Remesh), ...
    get(toolMn.consts,'infoNumberParameter'));
    mn_d_setparameter(toolMn.doc, compStator2Remesh.name, 'MaximumElementSize', ...
    sprintf('%g %%mm', MES_Remesh), ...
    get(toolMn.consts,'infoNumberParameter'));

%%Set up Periodic Boundary Conditions
    boundary = mn_d_createEvenPeriodicBoundaryCondition(toolMn.mn, 1, [{'compStatorVA'},{'compRotorAir1'},...
     {'compRotorAir2'},{'compRotor1Remesh'},{'compRotor1VA'},{'compRotor2VA'},{'compRotor2Remesh'},...
     {'compStator1Remesh'},{'compStator2Remesh'}], 4 , -2*p*w_m, 0, 0, 'Boundary1' )
 
%%Set up Motion
    motion = mn_d_makeMotionComponent(toolMn.mn, 1, [{'compCoilIn1'}, {'compCoilIn2'},{'compCoilIn3'}...
    {'compCoilOut1'},{'compCoilOut2'},{'compCoilOut3'},{'compStator2Remesh'},{'compStator1Remesh'},{'compStatorVA'}])
    PositionAtStartup = 0;
    SpeedAtStartup = 0;
    TimeArray = 0;
    SpeedArray = linspeed;
    direction = [-1,0,0];

%%set motion parameters
    mn_d_setparameter(toolMn.doc, motion, 'MotionSourceType','VelocityDriven', ...
    get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, motion, 'MotionType','Linear', ...
    get(toolMn.consts,'InfoStringParameter'));
    mn_d_setparameter(toolMn.doc, motion, 'PositionAtStartup',sprintf('%g %%mm', PositionAtStartup), ...
    get(toolMn.consts,'infoNumberParameter'));
    mn_d_setparameter(toolMn.doc, motion, 'SpeedAtStartup',SpeedAtStartup, ...
    get(toolMn.consts,'infoNumberParameter'));
    mn_d_setparameter(toolMn.doc, motion, 'SpeedVsTime',sprintf('[%g %%ms, %g]', TimeArray, SpeedArray), ...
    get(toolMn.consts,'InfoArrayParameter'));
    mn_d_setparameter(toolMn.doc, motion, 'MotionDirection',sprintf('[%g, %g, %g]', direction(1), direction(2),direction(3)), ...
    get(toolMn.consts,'InfoArrayParameter'));
end


