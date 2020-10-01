# eMach
An open source framework for modeling [electric] machinery.

## MATLAB Style Guidelines

All contributors to eMach are asked to use specific MATLAB code style, use MATLAB's object oriented programming (OOP) capabilities, and follow the SOLIDD design principles&mdash;all of which are now outlined.

### Code Style
Using a consist writing style makes shared code more maintainable, useful, and understandable. Contributors to eMach should follow the guidelines provided [here](styleGuidelines/matlabStyle2book.pdf). 

A brief summary of guidelines for names includes:
- **Avoid using excessively short names:** instead, favor full words to convey meaning
- **Function and variable names:** start lower case and then move to camel case, i.e. `toInch()`
- **Class names:** start upper case and then move to camel case, i.e. `MaterialGeneric`


Follow the MATLAB editor's guidelines on maximum line length. Wrapping to multiple lines is preferred over code that has excessively wide lines. This is for readibility and printability reasons.

### Object-Oriented Programming
The reference manual for MATLAB OOP can be found [here](https://www.mathworks.com/help/pdf_doc/matlab/matlab_oop.pdf).

Those looking to quickly grasp the key concepts of Matlab's implementation of OOP are referred to Kevin Murphy's [Object Oriented Programming in Matlab: basics guide](https://www.cs.ubc.ca/~murphyk/Software/matlabTutorial/html/objectOriented.html) and the official MATLAB [class syntax guide](https://www.mathworks.com/help/matlab/class-syntax-guide.html). MATLAB's instructions for creating help documentation of classes can be found [here](https://www.mathworks.com/help/matlab/matlab_prog/create-help-for-classes.html).

### SOLIDD Approach to Object Oriented Code Design
SOLIDD is an acronymn for the following code design guidelines:

- [**Single responsibility principle**](https://web.archive.org/web/20150202200348/http://www.objectmentor.com/resources/articles/srp.pdf) _“a class should have only a single responsibility” or “a class should have only one reason to change”_
- [**Open/closed principle**](https://web.archive.org/web/20150905081105/http://www.objectmentor.com/resources/articles/ocp.pdf) _"software entities … should be open for extension, but closed for modification."_
- [**Liskov substitution principle**](https://web.archive.org/web/20150905081111/http://www.objectmentor.com/resources/articles/lsp.pdf) _"objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program."_
- [**Interface segregation principle**](https://web.archive.org/web/20150905081110/http://www.objectmentor.com/resources/articles/isp.pdf) _"Many client-specific interfaces are better than one general-purpose interface."_
- [**Dependency inversion principle**](https://web.archive.org/web/20150905081103/http://www.objectmentor.com/resources/articles/dip.pdf) _One should "depend upon abstractions, [not] concretions."_
- **Don't repeat yourself**

These guidelines come out of the [Agile](https://en.wikipedia.org/wiki/Agile_software_development) community (specifically, [Robert C. Martin](https://en.wikipedia.org/wiki/Robert_C._Martin)) and are intended to make code flexible and maintainable. They are subtle and require close study to grasp their full implications.  

Note that MATLAB is a dynamically typed language and therefore does not impose type restrictions on variables. This can make adherence to the SOLIDD princples challenging. eMach enforces typing manually enforced by calling `validateattributes` like this:
- `validateattributes(obj.dim_depth,{'dimLinear'},{'nonnegative', 'nonempty'})`
- `validateattributes(compArcObj,{'compArc'},{'nonempty'})`

For example, see the MATLAB [DimLinear class](https://github.com/Severson-Group/eMach/blob/73293d352750b54190ffbddf509158881f4d8c1f/model_obj/dimensions/DimLinear.m).

Several useful resources on the SOLIDD guidelines are assembled here:
- [Wikipedia article on SOLID](https://en.wikipedia.org/wiki/SOLID)
- [Matlab blog on open and closed principle](https://blogs.mathworks.com/developer/2015/12/18/open-and-extensible/)
- [Matlab blog on class design](https://blogs.mathworks.com/developer/2016/01/16/making-code-usable-useful-and-testable/)
- [Matlab blog on inversion of control](https://blogs.mathworks.com/developer/2016/02/16/inversion-of-control/)
- [Matlab blog on dependency inversion](https://blogs.mathworks.com/developer/2016/02/24/dependency-injection/)

### In Function Documentation
Providing clear and concise in-function documentation makes open source code easy to understand and hence more useful. Contributors to eMach should try to follow the Matlab function documentation style as closely as possible.
The salient features of the Matlab documentation style are as follows

- In the documentation, the function name is typed in upper case, i.e. `toInch()` as `TOINCH()`. If done so, Matlab renders the function name in bold face.
- The documentation first provides a concise description of the functionality.

