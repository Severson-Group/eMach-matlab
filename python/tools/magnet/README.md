# Problems Encountered 

- In order for Python to send commands to MAGNET , we need to import the pywin32 to call ActiveX compliant programs as COM automation servers. pywin32 module comes installed when you install Anaconda3, however for Python to Import the module, the path of the module has to be defined in the system`Environment variables` for Windows (or the file we create has to be in the same directory as that of the file we are importing). 
[This link goes through the steps of adding the PYTHONPATH for different platforms](https://bic-berkeley.github.io/psych-214-fall-2016/using_pythonpath.html)
 - Return procedure for MAGNET differs for different functions as far as Python is concerned. For some functions such as `makeSimpleCoil` it can be as simple as `coil=Doc.makeSimpleCoil(ProblemID, ArrayOfValues)`, for others we need to put in more effort. For the `getParameter` for example, the return value can be extracted from MAGNET by employing the below code:
```python
    MN.processCommand("REDIM strArray(0)")
    MN.processCommand("DIM pType")
    MN.processCommand("pType = getDocument.getParameter(\"{}\", \"{}\", strArray)".format(path,parameter))
    MN.processCommand('Call setVariant(0, strArray,"PYTHON")')    
    param = MN.getVariant(0,"PYTHON")
    MN.processCommand('Call setVariant(0, pType,"PYTHON")')    
    param_type = MN.getVariant(0,"PYTHON")
    return param, param_type
```
The rule of thumb for knowing when to employ which syntax is that if a MAGNET specific API has an output argument then you need to use processCommand( ) and send the actual VBS command using python. The arguments of a MAGNET API can be obtained from MAGNET's Help Topics.