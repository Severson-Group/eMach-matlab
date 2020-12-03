# Specifications for `Crosssect` class implementation

The `Crosssect` class implements cross-sections of standard geometry shapes that are usually encountered when using eMach. This document specifies the rules to be followed to add a new cross-section to eMach.


## Creating a new cross-section

Although eMach currently supports several cross-sections and can draw most common geometries, there can be occassional need to add new cross-sections. 
The following guidelines must be adhered to when adding a new cross-section:

- **Naming:** The name of the cross-section should be self descriptive and always begin with `CrossSect`. The name should start with upper case and move to camel case. Eg: `CrossSectOuterRotor`.
- **Function description:** A short one line description should be provided at the beginning of the function to describe the cross-section being implemented.
- **Variable names:** Clear and self-descriptive variable names should be chosen for the input dimensions to the function. The variable names should not be too long. Use of underbar to denote subscripts is preferred. Eg: It is preferred to designate a variable that denotes the stator yoke thickness as `t_sy` rather than `t_syoke` or `t_statoryoke`. 
- **Drawings:** A vectorized (`.svg`) drawing of the geometry should be provided. This drawing should clearly indicate the location of the origin and coordinate axes. More details are provided [here](./#drawings).

## Location and expected content

All cross-sections should be housed in a folder of their own. The folder should reside in the following directory: [`eMach/model_obj/crosssects`](./). 
When adding a new cross-section, a new folder must be created in this path. The folder specifications are as follows:

- **Folder Name:** The folder name should be same as the cross-section name without the `CrossSect` prefix, and must follow camel case. Eg: `CrossSectOuterRotor` will be in a folder named `outerRotor`.
- **Folder Content:** The folder should contain the following files:
  - The function that implements the cross-section.
  - Vectorized drawing of the cross-section (`.svg`). 
   - Source code used to create the drawings if any (TikZ / Python etc).

## Drawings

Clear drawings are essential for the end user to understand how to use the cross-sections. The following guidelines must be adhered to:

- **Dimension names:** 
  - All dimensions that the function takes as an input, should be indicated in the drawings. 
  - The dimension names should be the same as the variable names in the function.
  - Italicized `Times New Roman` font should be used.
  - Subscripts should appear as subscripts, not just smaller font.
  - Greek characters should be used where appropriate. Eg: An angular dimension maybe called `alpha_m` in the function. However, it should be denoted as <img src="https://latex.codecogs.com/gif.latex?\alpha_\text{m}" title="\alpha_\text{m}" /> in the drawing.
  - Occassionally, some cross-sections may have variables that aren't dimensions. Eg: The `CrossSectInnerRotorStator` has `Q` - number of slots, as a variable. Such variables should also be indicated in the drawing.

- **Coordinate Axes:** The drawing origin and the coordinate axes should be clearly indicated in the drawing.

- **Drawing file name:** The drawing file should have the same name as the function name that implements the cross-section. It begins with `CrossSect` and follows camel case. Eg: `CrossSectOuterRotor.svg`.

