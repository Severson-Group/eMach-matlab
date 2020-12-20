%% JMAG Tool

This document briefly explains how the component creation workflow is handled in JMAG.

### Background
The geometry creation workflow in eMach is as follows:

1. Draw a cross section geometry
2. Extrude the cross section - requires a coordinate that is inside the region to be extruded. 
3. Assign materials

Although this workflow is consistent with the workflow in Infolytica MagNet, the workflow in JMAG has some additional steps to be followed. The JMAG workflow is as follows:
1. Draw a cross section geometry
2. Create regions
3. If more than one regions are created in Step 2, delete unecessary regions
4. Extrude the region
5. Create a study
6. Add the geometry to the study
7. Assign materials

Among these, Step 2. and 3. are the ones that need to be suitably handled. This is because, the function to create regions simply converts any closed geometry (bounded by lines and arcs) into a JMAG geometry region. 
For example, if a stator cross-section of a radial flux electric machine is drawn, JMAG creates two regions - one the actual stator region comprising the teeth, yoke etc, and the other region comprising the stator bore and slots.
If working with the JMAG gui, one can select the region that is not required and delete it manually. However, this is hard to do programmatically because of the following reasons:

1. The `CreateRegions()` function in JMAG takes no arguments - i.e, there is no way to specify where to create JMAG geometry regions, and all closed geometries are converted to JMAG geometry regions.
2. The `CreateRegions()` function does not return names of created regions or any other information. 

However, the eMach workflow does provide a coordinate `innerCoord` inside the cross section to be extruded. This `innerCoord` will be inside a geometry region that must be retained and extruded in JMAG. 

So, the following workaround was adopted to address this issue:

1. In the `prepareSection()` function, after drawing the cross section, the number of geometry items in the JMAG drawing is obtained. This is done using the `NumItems()` function.
2. The JMAG geometry regions are created using the `CreateRegions()` function.
3. The number of geometry items are again obtained by calling `NumItems()`
4. The difference between the number of geometry items in Stpe 3 and Step 1 gives the total number of regions created in Step 2.
5. JMAG names regions in the format `region, region.2, region.3,......region.n` if there are `n` regions. So, knowing the number of regions created, an array of region names is populated.
6. Using the `innerCoord` information, the `SelectAtCoordinateDlg()` function is used to select the desired region to be kept.
7. The `GetSelection()` function is used to get the selected region object and its name is obtained.
8. The region name obtained in step 7 is compared with the array of region names in Step 5. All other regions except the one whose name was obtained in Step 7 are deleted.

These steps delete the undesired regions that JMAG creates and only leave the desired region in the geometry, which can then be extruded or revolved (if axi-symmetric) suitably.

**Note:** The steps listed above to delete the undesired regions heavily rely on JMAG's region naming convention. If there is a change in the way JMAG names geometry regions in future versions, this must be suitably updated.

