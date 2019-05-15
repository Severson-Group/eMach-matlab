% Test the DimLinear sub classes

oneInch   = DimInch(1);
twoInches = DimInch(2);

oneMillimeter  = DimMillimeter(1);
twoMillimeters = DimMillimeter(2);

tol = 1e-5;

%% Test 1: sum of single dimension type

val = oneInch + oneInch;
expected = DimInch(2);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);


val = oneInch + twoInches;
expected = DimInch(3);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);


val = oneMillimeter + oneMillimeter;
expected = DimMillimeter(2);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);


val = oneMillimeter + twoMillimeters;
expected = DimMillimeter(3);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);



%% Test 2: sum of different dimension types

val = oneInch + oneMillimeter;
expected = DimInch(1.0393701);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);


val = oneInch + oneMillimeter + oneMillimeter;
expected = DimInch(1.0787402);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);


val = oneMillimeter + oneInch;
expected = DimMillimeter(26.4);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);


val = twoMillimeters + twoInches;
expected = DimMillimeter(52.8);
assert(strcmp(class(val), class(expected)));
assert(abs(double(val) - double(expected)) < tol);

