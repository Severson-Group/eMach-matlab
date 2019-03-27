% Test ability to cast dimensions via constructors

tol = 1e-5;

%% Test 1: casting via constructor

val = DimMillimeter(DimInch(1));
expected = DimMillimeter(25.4);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = DimMillimeter(DimMillimeter(DimMillimeter(25.4)));
expected = DimMillimeter(25.4);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);


val = DimInch(DimMillimeter(DimInch(25.4)));
expected = DimInch(25.4);
assert(strcmp(class(val), class(expected)));
assert(abs(val - expected) < tol);
