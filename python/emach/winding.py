class Coil:
    def __init__(self, **kwargs):
        self._create_attr(kwargs)

    @property
    def name(self):
        return self._name

    @property
    def slot1(self):
        return self._slot1

    @property
    def slot2(self):
        return self._slot2

    @property
    def slot1_layer(self):
        return self._slot1_layer

    @property
    def slot2_layer(self):
        return self._slot2_layer

    @property
    def material(self):
        return self._material

    @property
    def zQ(self):
        return self._zQ

    def _create_attr(self, dictionary: dict):
        for name, value in dictionary.items():
            setattr(self, '_' + name, value)


class CoilGroup:
    def __init__(self, **kwargs):
        self._create_attr(kwargs)

    @property
    def name(self):
        return self._name

    @property
    def coils(self):
        return self._coils

    def _create_attr(self, dictionary: dict):
        for name, value in dictionary.items():
            setattr(self, '_' + name, value)


class Winding:
    def __init__(self, **kwargs):
        self._create_attr(kwargs)

    @property
    def coil_groups(self):
        return self._coil_groups

    @property
    def winding_nodes(self):
        return self._winding_nodes

    @property
    def slots(self):
        return self._slots

    @property
    def num_of_layers(self):
        return self._num_of_layers

    def make_coil_sides(self, coil_cross, coil_comp, tool):
        winding = []
        for coil_group in self._coil_groups:
            coil_group_list = []
            for coil in coil_group.coils:
                coil_side1 = coil_cross.clone(name=coil.name+'_'+str(coil.slot1), Q=self.slots, slot=coil.slot1,
                                              layer=coil.slot1_layer, num_of_layers=self.num_of_layers)
                coil_side2 = coil_cross.clone(name=coil.name+'_'+str(coil.slot2), Q=self.slots, slot=coil.slot2,
                                              layer=coil.slot2_layer, num_of_layers=self.num_of_layers)

                coil_side1_comp = coil_comp.clone(name=coil.name+'_'+str(coil.slot1), cross_sections=[coil_side1])
                coil_side2_comp = coil_comp.clone(name=coil.name+'_'+str(coil.slot2), cross_sections=[coil_side2])

                coil_side1_handle = coil_side1_comp.make(tool, tool)
                coil_side2_handle = coil_side2_comp.make(tool, tool)
                coil_handle = [coil_side1_handle, coil_side2_handle]
                coil_group_list.append(coil_handle)
            winding.append(coil_group_list)
        return winding

    def wind(self, coil_cross, coil_comp, tool):
        coil_handles = self.make_coil_sides(coil_cross, coil_comp, tool)
        winding_coils = []
        for i in range(len(coil_handles)):
            coil = tool.create_coil(self._coil_groups[i], coil_handles[i])
            winding_coils.append(coil)
        return winding_coils

    def _create_attr(self, dictionary: dict):
        for name, value in dictionary.items():
            setattr(self, '_' + name, value)