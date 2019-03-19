% Test the DimLinear sub classes

negOneInch   = DimInch(-1);
negTwoInches = DimInch(-2);
neg11Inches  = DimInch(-11);

negOneMillimeter    = DimMillimeter(-1);
negTwoMillimeters   = DimMillimeter(-2);
negFiftyMillimeters = DimMillimeter(-50);
neg254Millimeters   = DimMillimeter(-254);

tol = 1e-5;

%% Test 1: unary plus operator

val = +negOneInch;
expected = DimInch(1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = +negTwoInches;
expected = DimInch(2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = +negOneMillimeter;
expected = DimMillimeter(1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = +neg254Millimeters;
expected = DimMillimeter(254);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);

