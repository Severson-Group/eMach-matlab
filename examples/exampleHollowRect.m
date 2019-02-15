clc
clear
[mn, doc] = mn_open();
set(mn, 'Visible', true);
mn_d_setDefaultLengthUnit(doc, 'millimeters', false);
    
  rect = compHollowRect('name', ['rect'], ...
        'dim_t', dimMillimeter(2), ...
        'dim_l_o', dimMillimeter(10), ...
        'material', matGeneric('name', 'Arnon7'), ...
        'location', compLocation('anchor_xyz', dimMillimeter([2,0,0])));
                    
    line_segs = mn_drawHollowRect(mn, rect);
    mn_dv_viewAll(mn);