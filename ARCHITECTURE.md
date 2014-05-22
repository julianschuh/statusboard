## Architecture

The gem differntiates between the application layer and the DSL.

### The DSL
The DSL is located in the `dsl` directory. All DSL-related classes normally end with `Description` (e.g. `GraphDescription`) and inherite from the class DSLBase.

As the "Description" suffix already states, the DSL objects can be seen as a description of what the application layer should do - similar to a config file in a "normal" application, but in a dynamic fashion. The task of the DSL part is to take the user input (which is achieved by being a DSL), sanitizing it where required and passing it with a useful structure to the application layer.

### The application layer
The application layer uses the description it received by evaluating the DSL and uses the information to produce the desired output (in this case graph widgets).

### Discussion
It should be discussed if the separation expalined above is useful or not.