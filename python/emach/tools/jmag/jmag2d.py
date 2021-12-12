from .jmag import JmagDesigner
from ...model_obj.dimensions import *

__all__ = []
__all__ += ["JmagDesigner2D"]


class JmagDesigner2D(JmagDesigner):

    def extrude(self, name, material, depth: float, token=None) -> any:
        """ Extrudes a cross-section by extending the model

        Args:
            name: name of the newly extruded component.
            depth: Depth of extrusion. Should be defined with eMach Dimensions.
            material : Material applied to the extruded component.

        Returns:
            Function will return the handle to the new extruded part
        """

        depth = eval(self.default_length)(depth)

        self.sketch.SetProperty('Name', name)
        self.sketch.SetProperty('Color', material.color)
        part = self.sketch.GetProperty('Name')
        self.sketch = None
        self.doc.SaveModel(True)
        model_name = name + '_model'
        self.model = self.create_model(model_name)

        study_name = name + '_study'
        self.study = self.create_study(study_name, self.study_type, self.model)
        self.study.GetStudyProperties().SetValue("ModelThickness", depth)

        self.set_default_length_unit(self.default_length)
        self.set_default_angle_unit(self.default_angle)
        self.study.SetMaterialByName(name, material.name)
        return part

    def revolve(self, name, material: str, center: 'Location2D', axis: 'Location2D', angle: float) -> any:
        pass

    def create_coil(self, coil_group, coil_group_handle):
        self.study.CreateCondition("FEMCoil", coil_group.name)
        condition = self.study.GetCondition(coil_group.name)
        condition.RemoveSubCondition("untitled")

        for i in range(len(coil_group.coils)):
            condition.CreateSubCondition("FEMCoilData", "Coil_Up_"+str(i))
            subcondition = condition.GetSubCondition("Coil_Up_"+str(i))
            subcondition.ClearParts()
            subcondition.AddPart(coil_group_handle[i][0].make_solid_token)
            subcondition.SetValue("Direction2D", 1)

            condition.CreateSubCondition("FEMCoilData", "Coil_Down_"+str(i))
            subcondition = condition.GetSubCondition("Coil_Down_"+str(i))
            subcondition.ClearParts()
            subcondition.AddPart(coil_group_handle[i][1].make_solid_token)
            subcondition.SetValue("Direction2D", 0)

        return condition