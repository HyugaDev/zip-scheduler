## Usage
Run the `main.jl` script from the `/julia` directory.

### Command line usage
```
> julia --project=. main.jl
```

### Julia REPL usage
```
# Press `]` to enter Pkg mode of the REPL
(@v1.7)> activate .

# Press `backspace` to return to the standard REPL prompt
julia> include("main.jl")
```

## Language-Specific Instructions
There are some areas where this implementation differs from the other language implmementations in this repo:

- It is a strong convention in Julia to name functions that mutate their arguments with a `!` at the end, so the `queue_order` function is instead named `queue_order!`, `launch_flights` → `launch_flights!`, and `run` → `run!` here
- APIs in Julia are implemented by adding methods to a function for new argument types rather than adding methods to a class for new functions. Instead of implementing a `ZipScheduler` class, you will be implementing a `ZipScheduler` type and adding methods `queue_order!(::ZipScheduler, ::Order)` and `launch_flights!(::ZipScheduler, ::Int)` to dispatch on it.

## Version Compatibility
This project is compatible with Julia versions `>= v1.7`. If changes you make require features from later versions, update the `[compat]` entry for `julia` in the `Project.toml` to the new lower bound.

## Adding Project Dependencies
If you need to add project dependencies, you can do so with the following steps:

1. Open up the Julia REPL at the `/julia` directory
2. Press `]` to enter Pkg mode of the REPL
3. Enter `activate .` (you should see the prompt change to `(julia) pkg>`)
4. Enter `add <package[s] you want to add>`
