# Typehinting in Python



[Type hinting](https://www.python.org/dev/peps/pep-0484/) is a formal solution to statically indicate the type of a value within your Python code. [1]

Traditionally python is a [dynamically typed language](https://android.jlelse.eu/magic-lies-here-statically-typed-vs-dynamically-typed-languages-d151c7f95e2b); however, to improve project organization and inherit the advantages of static typed language, type hinting was introduced in Python 3.5. 

### Why Type hints? [2]
- Help the type checker
    - in a dynamic language, the flow of objects is hard to follow   
- Serve as additional documentation
    - replace existing docstring conventions   
- Help IDEs
    - improve suggestions
    - improve interactive code checks.

### Typehint implementation in Python
##### Example 1 


``` python
def spaceoddity(name):
   return "Ground Control to " + name
```

In the above example, `def spaceoddity` receives a string, concatenates it to another string, and returns the resultant string. Here type hinting can be implemented when receiving the string and returning the string. 

```python
def spaceoddity(name: str) -> str:
   return "Ground Control to " + name
```
`name:str` indicates that the input argument should be a string,  `->str` indicates the `spaceoddity` function will return string. 

### Type Checking in Python
Type checking is the process of verifying the constraint of types. 
- Most Modern IDE has inbuilt type checkers. 
- There are external static type checkers, and one of the most popular ones is [mypy](http://mypy-lang.org/).
- If a type hint is implemented in the code, the type checker can check for the violation before runtime. 

### Type Checking beyond datatype([JSON Schema](http://json-schema.org/understanding-json-schema/))
- As discussed above, Type hinting can be used to enforce the data type of the object. 
- Enforcement beyond datatype like the range of values, multiple of values(multiple of 2's and 3's), length of the string, length of the array, etc. can be done using [JSON Schema](https://pynative.com/python-json-validation/).

#### Example 2
```python
"""
JSON Schema Demo
"""
from jsonschema import validate
schema = {
# Schema is equivalent to specifying rules for the data.
    "type": "object",
    "properties": {
        "slots": {"type": "integer",
                  "multipleOf": 3,
                  "maximum": 48,
                  "minimum": 0},
        "poles": {"type": "integer",
                  "multipleOf": 2,
                  "maximum": 24,
                  "minimum": 2},
        "phase": {"type": "integer",
                  "maximum": 6,
                  "minimum": 3}
    },
}

def spp(dataum):
    print("Data Recieved")
    """
    Compute SPP
    """

toPass = {"slots": 12.0, "poles": 4.0, "phase": 3} #Data
try:
    validate(instance=toPass, schema=schema)  # Data type validation
    spp(toPass)
except Exception as e:
    print("Exception Occured")
    print(e)
```

In the above example, the function `spp` receives slots, poles, and phases data to compute slot per pole per phase. The Schema (rules) has been set to check whether the data is an integer, multiple of 3 in case of slots (2 in case of poles), and minimum and maximum limits. `validate` function will check for data violation based on rules specified in `schema`. 

If the data passed to the function is, 
```python
{"slots": 12.0, "poles": 4.0, "phase": 3}
```
The program will execute without errors. 

However, if the data passed to the function is 
```python
{"slots": 12.5, "poles": 4.0, "phase": 3}
```
or
```python
{"slots": "12.0", "poles": 4.0, "phase": 3}
```
or
```python
{"slots": 12.5, "poles": 4.0, "phase": 3}
```
or
```python
{"slots": 12.5, "poles": 5.0, "phase": 3}
```
or 
```python
{"slots": 52, "poles": 26, "phase": 7}
```
The program will throw an error as it violates the rules specified in `schema`. 

 
# Reference Materials
[1] : [Real Python Type Hinting](<https://realpython.com/lessons/type-hinting/>)
[2] : [Type Hints - Guido van Rossum - Pycon 2015](https://www.youtube.com/watch?v=2wDvzy6Hgxg&t=807s&ab_channel=PyCon2015) 

