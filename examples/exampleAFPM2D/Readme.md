## AFPM 2D Example

This example draws and solves an equivalent 2D model of a coreless axial flux machine. Details about the 2D modeling technique can be found in [1].

The parameterized geometry is available [here](AFPM2DDrawing.pdf)

## Steps
- Add the `model_obj` folder and the `tools` folder, along with their sub folders to your Matlab path.
- Run [TransientSolveAFPM2DExample.m](./TransientSolveAFPM2DExample.m). This creates the geometry, assigns materials, and runs the FEA solve. The FEA results are saved into a `.mat` file.
- Run [AFPM2DPlots.m](./AFPM2DPlots.m) to generate plots from the saved FEA results.

## Reference

[1] F. Nishanth, G. Bohach, J. V. de Ven and E. L. Severson, "Design of a Highly Integrated Electric-Hydraulic Machine for Electrifying Off-Highway Vehicles," 2019 IEEE Energy Conversion Congress and Exposition (ECCE), Baltimore, MD, USA, 2019, pp. 3983-3990, doi: 10.1109/ECCE.2019.8912685.
