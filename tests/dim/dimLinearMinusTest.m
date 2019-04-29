% Test the DimLinear sub classes

oneInch   = DimInch(1);
twoInches = DimInch(2);
elevenInches = DimInch(11);

oneMillimeter    = DimMillimeter(1);
twoMillimeters   = DimMillimeter(2);
fiftyMillimeters = DimMillimeter(50);
two54Millimeters = DimMillimeter(254);

tol = 1e-5;

%% Test 1: subtraction of single dimension type

val = oneInch - oneInch;
expected = DimInch(0);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = twoInches - oneInch;
expected = DimInch(1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = oneMillimeter - oneMillimeter;
expected = DimMillimeter(0);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = twoMillimeters - oneMillimeter;
expected = DimMillimeter(1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


%% Test 2: subtraction of different dimension types

val = elevenInches - two54Millimeters;
expected = DimInch(1);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = elevenInches - two54Millimeters - oneInch;
expected = DimInch(0);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = fiftyMillimeters - oneInch;
expected = DimMillimeter(24.6);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = fiftyMillimeters - twoInches;
expected = DimMillimeter(-0.8);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);

