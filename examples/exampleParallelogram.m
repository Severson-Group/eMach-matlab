clc
clear

%This example draws a parallelogram.

DRAW_MAGNET = 1;
DRAW_TIKZ   = 0;

%% Define cross sections
parallelogram = CrossSectParallelogram( ...
        'name', 'parallelogram', ...
        'dim_l', DimMillimeter(40), ...
        'dim_t', DimMillimeter(8), ...
        'dim_theta', DimDegree(45), ...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree(0).toRadians() ...
        ) ...
        );
%% Define components

cs = parallelogram;

comp1 = Component( ...
        'name', 'comp1', ...
        'crossSections', cs, ...
'material', MaterialGeneric('name', 'M19: USS Transformer 72 -- 29 Gage'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(15)) ...
        );

%% Draw via MagNet
path = pwd;
fileName = 'test1.mn';

if (DRAW_MAGNET)
    toolMn = MagNet();
    toolMn.setVisibility(1);
    toolMn.open(0);
    comp1.make(toolMn,toolMn);
    toolMn.viewAll();
    toolMn.save(path, fileName);
    toolMn.close();
    if isvalid(toolMn)
        fprintf('Pre-destructor: toolMn exists\n');
    else
        fprintf('Pre-destructor: toolMn does not exist\n');
    end
    
    delete(toolMn);
    
    if isvalid(toolMn)
        fprintf('Failure: toolMn exists\n');
    else
        fprintf('Success: toolMn is destroyed\n');
    end
end

%% Draw via TikZ

if (DRAW_TIKZ)
    toolTikz = TikZ();
    toolTikz.open('output.txt');

    comp1.make(toolTikz);

    toolTikz.close();
end
