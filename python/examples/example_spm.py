import sys

sys.path.append("..")

import emach.tools.jmag as jd
import emach.model_obj as mo
import time

##########################################################################################
############################## Create cross-sections #####################################
##########################################################################################

stator1 = mo.CrossSectInnerRotorStator(
    name='stator',
    dim_alpha_st=mo.DimDegree(44.5),
    dim_alpha_so=mo.DimDegree((44.5 / 2)),
    dim_r_si=mo.DimMillimeter(14.16),
    dim_d_sy=mo.DimMillimeter(13.54),
    dim_d_st=mo.DimMillimeter(16.94),
    dim_d_sp=mo.DimMillimeter(8.14),
    dim_d_so=mo.DimMillimeter(5.43),
    dim_w_st=mo.DimMillimeter(9.1),
    dim_r_st=mo.DimMillimeter(0),
    dim_r_sf=mo.DimMillimeter(0),
    dim_r_sb=mo.DimMillimeter(0),
    Q=6,
    location=mo.Location2D(anchor_xy=[mo.DimMillimeter(0), mo.DimMillimeter(0)]),
    theta=mo.DimDegree(0))

rotor1 = mo.CrossSectInnerNotchedRotor(name='rotor',
                                       location=mo.Location2D(),
                                       dim_alpha_rm=mo.DimDegree(180),
                                       dim_alpha_rs=mo.DimDegree(90),
                                       dim_d_ri=mo.DimMillimeter(3),
                                       dim_r_ri=mo.DimMillimeter(5),
                                       dim_d_rp=mo.DimMillimeter(5),
                                       dim_d_rs=mo.DimMillimeter(3),
                                       p=1, s=2)
magnets = []
for i in range(4):
    magnet = mo.CrossSectArc(name='magnet' + str(i), location=mo.Location2D(theta=mo.DimDegree(90*i)),
                             dim_d_a=mo.DimMillimeter(3.41), dim_r_o=mo.DimMillimeter(11.41),
                             dim_alpha=mo.DimDegree(90))
    magnets.append(magnet)

coils = []
for j in range(6):
    coil1 = mo.CrossSectInnerRotorStatorCoil(name='coil1_' + str(j),
                                             dim_r_si=mo.DimMillimeter(14.16),
                                             dim_d_st=mo.DimMillimeter(16.94),
                                             dim_d_sp=mo.DimMillimeter(8.14),
                                             dim_w_st=mo.DimMillimeter(9.1),
                                             dim_r_st=mo.DimMillimeter(0),
                                             dim_r_sf=mo.DimMillimeter(0),
                                             dim_r_sb=mo.DimMillimeter(0),
                                             Q=6,
                                             slot=j+1,
                                             layer=0,
                                             num_of_layers=2,
                                             location=mo.Location2D(
                                                 anchor_xy=[mo.DimMillimeter(0), mo.DimMillimeter(0)]),
                                                 theta=mo.DimDegree(0))
    coil2 = mo.CrossSectInnerRotorStatorCoil(name='coil2_' + str(j),
                                             dim_r_si=mo.DimMillimeter(14.16),
                                             dim_d_st=mo.DimMillimeter(16.94),
                                             dim_d_sp=mo.DimMillimeter(8.14),
                                             dim_w_st=mo.DimMillimeter(9.1),
                                             dim_r_st=mo.DimMillimeter(0),
                                             dim_r_sf=mo.DimMillimeter(0),
                                             dim_r_sb=mo.DimMillimeter(0),
                                             Q=6,
                                             slot=j+1,
                                             layer=1,
                                             num_of_layers=2,
                                             location=mo.Location2D(
                                                 anchor_xy=[mo.DimMillimeter(0), mo.DimMillimeter(0)]),
                                             theta=mo.DimDegree(0))
    coils.append(coil1)
    coils.append(coil2)

##########################################################################################
############################## Create components #########################################
##########################################################################################

StatorComp = mo.Component(
    name='Stator',
    cross_sections=[stator1, rotor1],
    material=mo.MaterialGeneric(name="10JNEX900", color=r'#808080'),
    make_solid=mo.MakeExtrude(location=mo.Location3D(),
                              dim_depth=mo.DimMillimeter(25)))

RotorComp = mo.Component(
    name='Rotor',
    cross_sections=[rotor1],
    material=mo.MaterialGeneric(name="10JNEX900", color=r'#808080'),
    make_solid=mo.MakeExtrude(location=mo.Location3D(),
                              dim_depth=mo.DimMillimeter(25)))

MagnetComps = []
for i in range(4):
    magnet_comp = mo.Component(
        name='Magnet' + str(i),
        cross_sections=[magnets[i]],
        material=mo.MaterialGeneric(name="Arnold/Reversible/N40H", color=r'#4d4b4f'),
        make_solid=mo.MakeExtrude(location=mo.Location3D(),
                                  dim_depth=mo.DimMillimeter(25)))
    MagnetComps.append(magnet_comp)

CoilComps = []
for j in range(12):
    coil_comp = mo.Component(name='Coil1', cross_sections=[coils[j]],
                             material=mo.MaterialGeneric(name="Copper", color=r'#b87333'),
                             make_solid=mo.MakeExtrude(location=mo.Location3D(),
                                                       dim_depth=mo.DimMillimeter(25)))
    CoilComps.append(coil_comp)

##########################################################################################
#################################### Draw components #####################################
##########################################################################################

file = r'full_SPM_4pole2D.jproj'

start_time = time.time()

tool_jmag = jd.JmagDesigner2D()
tool_jmag.open(comp_filepath=file, study_type='Transient2D')
tool_jmag.set_visibility(True)

stator_handle = StatorComp.make(tool_jmag, tool_jmag)
# rotor_handle = RotorComp.make(tool_jmag, tool_jmag)

# magnet_handles = []
# for i in range(4):
#     magnet_handle = MagnetComps[i].make(tool_jmag, tool_jmag)
#     magnet_handles.append(magnet_handle)
#
# magnet_handles[0].make_solid_token.SetValue("Temperature", 80)
# magnet_handles[0].make_solid_token.SetDirectionXYZ(1, 0, 0)
# magnet_handles[0].make_solid_token.SetPattern("ParallelCircular")
#
# coil_handles = []
# for j in range(12):
#     coil1_tool = CoilComps[j].make(tool_jmag, tool_jmag)
#     coil_handles.append(coil1_tool)

tool_jmag.save()

end_time = time.time()
print(end_time-start_time)