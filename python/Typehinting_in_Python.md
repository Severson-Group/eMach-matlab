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

 
# Reference Materials
[1] : [Real Python Type Hinting](<https://realpython.com/lessons/type-hinting/>)
[2] : [Type Hints - Guido van Rossum - Pycon 2015](https://www.youtube.com/watch?v=2wDvzy6Hgxg&t=807s&ab_channel=PyCon2015) 

