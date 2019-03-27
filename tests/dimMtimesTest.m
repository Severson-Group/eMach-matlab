% Test the DimLinear * operator

oneInch   = DimInch(1);
twoInches = DimInch(2);

oneMillimeter  = DimMillimeter(1);
twoMillimeters = DimMillimeter(2);

tol = 1e-5;

%% Test 1: mtimes of scalar on LHS

val = 2 * oneInch;
expected = DimInch(2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = 2 * oneMillimeter;
expected = DimMillimeter(2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = 0 * oneMillimeter;
expected = DimMillimeter(0);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = -2 * oneMillimeter;
expected = DimMillimeter(-2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


%% Test 2: mtimes of scalar on RHS

val = oneInch * 2;
expected = DimInch(2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = oneMillimeter * 2;
expected = DimMillimeter(2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = oneMillimeter * 0;
expected = DimMillimeter(0);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = oneMillimeter * -2;
expected = DimMillimeter(-2);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);
