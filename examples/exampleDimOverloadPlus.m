clc
clear

%% Test adding dimensions

op1 = DimInch(1);
op2 = DimMillimeter(1);
res = op1 + op2;
notCorrectLinear( ...
    'Add dimensions of different types', ...
    DimInch(1.03937), ...
    res ...
);

op1 = DimInch(1);
op2 = DimMillimeter(1);
res = op2 + op1;
notCorrectLinear( ...
    'Add dimensions of different types', ...
    DimMillimeter(26.4), ...
    res ...
);

op1 = DimInch(1);
op2 = DimInch(2);
res = op1 + op2;
notCorrectLinear( ...
    'Add dimensions of different types', ...
    DimInch(3), ...
    res ...
);

op1 = DimMillimeter(1);
op2 = DimMillimeter(3);
res = op1 + op2;
notCorrectLinear( ...
    'Add dimensions of different types', ...
    DimMillimeter(4), ...
    res ...
);

op1 = DimMillimeter(DimInch(1));
op2 = DimInch(DimMillimeter(25.4));
res = op1 + op2;
notCorrectLinear( ...
    'Add dimensions of different types', ...
    DimMillimeter(50.8), ...
    res ...
);

op1 = DimMillimeter(DimInch(1));
op2 = DimMillimeter(DimMillimeter(DimMillimeter(25.4)));
res = op1 + op2;
notCorrectLinear( ...
    'Add dimensions of different types', ...
    DimMillimeter(50.8), ...
    res ...
);


%% Check for correctness function

function notCorrectLinear(title, expected, actual)
    out = true;

    % Check same class
    if (class(expected) ~= class(actual))
        out = false;
    end
    
    % Check same value    
    if (abs(expected.toMillimeter() - actual.toMillimeter()) > 0.00001)
       out = false;
    end
    
    if (out)
       % Pass 
       fprintf("PASS: %s\n", title);
    else
       % Fail 
       fprintf("FAIL: %s\n", title);
       fprintf("\tExpected: %6.10f, Actual: %6.10f\n", expected, actual);
    end
end