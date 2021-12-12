import sys

sys.path.append("..")

import emach.tools.jmag as jd
import emach.model_obj as mo
from emach.winding import Coil, CoilGroup, Winding

##########################################################################################
############################## Create cross-sections #####################################
##########################################################################################

# stator cross-section
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

# rotor cross-section
rotor1 = mo.CrossSectInnerNotchedRotor(name='rotor',
                                       location=mo.Location2D(),
                                       dim_alpha_rm=mo.DimDegree(180),
                                       dim_alpha_rs=mo.DimDegree(90),
                                       dim_d_ri=mo.DimMillimeter(3),
                                       dim_r_ri=mo.DimMillimeter(5),
                                       dim_d_rp=mo.DimMillimeter(5),
                                       dim_d_rs=mo.DimMillimeter(3),
                                       p=1, s=2)

# all magnet cross-sections
magnets = []
for i in range(4):
    magnet = mo.CrossSectArc(name='magnet' + str(i), location=mo.Location2D(theta=mo.DimDegree(90 * i)),
                             dim_d_a=mo.DimMillimeter(3.41), dim_r_o=mo.DimMillimeter(11.41),
                             dim_alpha=mo.DimDegree(90))
    magnets.append(magnet)

# example coil cross-section
coil1 = mo.CrossSectInnerRotorStatorCoil(name='coil1',
                                         dim_r_si=mo.DimMillimeter(14.16),
                                         dim_d_st=mo.DimMillimeter(16.94),
                                         dim_d_sp=mo.DimMillimeter(8.14),
                                         dim_w_st=mo.DimMillimeter(9.1),
                                         dim_r_st=mo.DimMillimeter(0),
                                         dim_r_sf=mo.DimMillimeter(0),
                                         dim_r_sb=mo.DimMillimeter(0),
                                         Q=6,
                                         slot= 1,
                                         layer=0,
                                         num_of_layers=2,
                                         location=mo.Location2D(anchor_xy=[mo.DimMillimeter(0), mo.DimMillimeter(0)]),
                                         theta=mo.DimDegree(0))

##########################################################################################
############################## Create components #########################################
##########################################################################################

StatorComp = mo.Component(
    name='Stator',
    cross_sections=[stator1],
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

coil1_comp = mo.Component(name='Coil', cross_sections=[coil1],
                          material=mo.MaterialGeneric(name="Copper", color=r'#b87333'),
                          make_solid=mo.MakeExtrude(location=mo.Location3D(),
                                                    dim_depth=mo.DimMillimeter(25)))

##########################################################################################
#################################### Draw components #####################################
##########################################################################################

# launch JMAG
file = r'4pole_machine.jproj'
tool_jmag = jd.JmagDesigner2D()
tool_jmag.open(comp_filepath=file, study_type='Transient2D')
tool_jmag.set_visibility(True)

# make stator and rotor in JMAG
stator_handle = StatorComp.make(tool_jmag, tool_jmag)
rotor_handle = RotorComp.make(tool_jmag, tool_jmag)

# make magnet components in JMAG
magnet_handles = []
for i in range(1):
    magnet_handle = MagnetComps[i].make(tool_jmag, tool_jmag)
    magnet_handles.append(magnet_handle)

# modify magnet material properties
magnet0_material = tool_jmag.study.GetMaterial(magnet_handles[0].make_solid_token)
magnet0_material.SetPattern("ParallelCircular")
magnet0_material.SetValue("Temperature", 80)
magnet0_material.SetDirectionXYZ(1, 0, 0)

# create machine winding
# create coil objects
coil_1 = Coil(name='Coil1', slot1=1, slot2=5, slot1_layer=0, slot2_layer=1,
              material=mo.MaterialGeneric(name="Copper", color=r'#b87333'), zQ=20)
coil_2 = Coil(name='Coil2', slot1=6, slot2=2, slot1_layer=0, slot2_layer=1,
              material=mo.MaterialGeneric(name="Copper", color=r'#b87333'), zQ=20)

# create coil groups from a set of coils
coil_group1 = CoilGroup(name='CoilUa', coils=[coil_1])
coil_group2 = CoilGroup(name='CoilVb', coils=[coil_2])

# create winding from a set of coil groups
winding = Winding(coil_groups=[coil_group1, coil_group2], winding_nodes=['Ut'], slots=6, num_of_layers=2)
# draw winding and create coil condition in JMAG
winding_handles = winding.wind(coil_cross=coil1, coil_comp=coil1_comp, tool=tool_jmag)

tool_jmag.save()
