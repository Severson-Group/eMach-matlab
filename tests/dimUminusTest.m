% Test the DimLinear sub classes

oneInch   = DimInch(1);
twoInches = DimInch(2);
elevenInches = DimInch(11);

oneMillimeter    = DimMillimeter(1);
twoMillimeters   = DimMillimeter(2);
fiftyMillimeters = DimMillimeter(50);
two54Millimeters = DimMillimeter(254);

tol = 1e-5;

%% Test 1: unary minus operator

val = -oneInch;
expected = DimInch(-1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = -twoInches;
expected = DimInch(-2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = -oneMillimeter;
expected = DimMillimeter(-1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = -two54Millimeters;
expected = DimMillimeter(-254);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);

