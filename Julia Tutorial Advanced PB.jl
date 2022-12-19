### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 4c788b44-77e1-11ed-0ce7-5914857ba421
md"""
## Calling Python from Julia

Julia has two packages for calling Python code from Julia: PyCall & PythonCall. PyCall has an easier learning curve, but has a few limitations. Whereas, PythonCall, being more complete and allowing for more control, has better performance.

"""

# ╔═╡ f0c6b09d-8b64-4175-aacd-6b3ac72078f6
md"""
### PyCall

    using PyCall

A simple example, calculate 1/√2 using Python. First, import the math module.

    math = pyimport("math")
    math.sin(math.pi /4)

Try it.
"""

# ╔═╡ 667e42f2-b6b5-4eb9-817f-57aee042d7ca


# ╔═╡ 06d63e41-f9b9-4c75-87d4-241beb454dc5
md"""
Here is another example using pyplot.

    plt = pyimport("matplotlib.pyplot")
    x = range(0; stop=2*pi, length=1000); y = sin.(3*x + 4*cos.(2*x));
    plt.plot(x, y, color="red", linewidth=2.0, linestyle="--")
    plt.show()

Note that `x` and `y` are calculated using Julia and the plotting uses Python.
"""

# ╔═╡ 20c226ca-44e6-4565-b601-07f5df7828ac


# ╔═╡ 7728f44a-93e1-4514-8964-6351a5ebff07
md"""
You can also just wrap Python code in `py"..."` or `py\"""...\"""` strings, which are equivalent to Python's `eval` and `exec` commands, respectively.

***Show example extracting data from a FITS file.***

"""

# ╔═╡ 5d883d2b-515f-4286-a2ab-15127ac6b5ea
md"""
#### Specifying the Python version

In Julia,

    ENV["PYTHON"] = path_of_python_executable
    # ENV["PYTHON"] = "/usr/bin/python3.10"
    Pkg.build("PyCall")

To use Julia's Python distribution, set the path to an empty string, i.e., `""`

!!! note
    Usually, the necessary libraries are installed along with Python, but pyenv on  MacOS requires you to install it with env PYTHON\_CONFIGURE\_OPTS="--enable-framework" pyenv install 3.4.3. The Enthought Canopy Python distribution is currently not supported. As a general rule, we tend to recommend the Anaconda Python distribution on MacOS and Windows, or using the Julia Conda package, in order to minimize headaches.
"""

# ╔═╡ 87b3ca0e-93d3-41d3-aa6d-e06ab0fbac26
md"""
### PythonCall & JuliaCall

Call Python code from Julia and Julia code from Python via a symmetric interface.

#### Getting Started

    using PythonCall

By default importing the module will initialize a conda environment in your Julia environment, install Python into it, load the corresponding Python library, and initialize an interpreter.

Here is an example using Python's "re" module.

    re = pyimport("re")
    words = re.findall("[a-zA-Z]+", "PythonCall.jl is great")
    sentence = Py(" ").join(words)
    pyconvert(String, sentence)  # convert Python string to Julia string

Try it.
"""

# ╔═╡ 0db12101-fcf9-48a3-a337-ad53a4713f6d


# ╔═╡ 56141542-b8eb-4139-8199-acea701449e2
md"""
#### Wrapper Types

A wrapper is a Julia type that wraps a Python object, but gives it Julia semantics. For example, the PyList type wraps Python's list object. 

    x = pylist([3,4,5])

    y = PyList{Union{Nothing, Int64}}(x)

    push!(y, Nothing)

    append!(y, 1:2)

    x

Try it.
"""

# ╔═╡ 966da8a4-6cee-47c3-bca1-a90460218f3f


# ╔═╡ 4adcd9bb-40dc-47dc-941d-66d34465b218
md"""
There are wrappers for other container types, such as PyDict and PySet.

    x = pyimport("array").array("i", [3,4,5])

    y = PyArray(x)

    sum(y)

    y[1] = 0

    x

Try this example too.
"""

# ╔═╡ adb77392-c109-4e90-917e-75a23e7f21a9


# ╔═╡ aa641087-0617-45ce-9ad1-69128fd155e9
md"""
PyArray directly wraps the underlying data buffer, so array operations such as indexing are about as fast as an ordinary Array.

#### Configuration

By default, PythonCall uses CondaPkg.jl to manage its dependencies. This will install Conda and use it to create a Conda environment specific to your current Julia project.

#### Using your current Python installation

    ENV["JULIA_CONDAPKG_BACKEND"] = "Null"
    END["JULIA_PYTHONCALL_EXE"] = "/path/to/python"   # optional
    END["JULIA_PYTHONCALL_EXE"] = "@PyCall"   # optional

By setting the CondaPkg backend to Null, no Conda packages will be installed. PythonCall will use your current Python installation.

If Python is not in your `PATH`, you will need to send the `JULIA_PYHTHONCALL_EXE` environment variable to include it in your path.

If you also use PyCall, you can set the `JULIA_PYTHONCALL_EXE` environment variable to use the same interpreter.

#### Using your current Conda environment

    ENV["JULIA_CONDAPKG_BACKEND"] = "Current"
    ENV["JULIA_CONDAPKG_EXE"] = "/path/to/conda"   # optional

Note that this configuration will still install any required Conda packages into your Conda envirnment.

If `conda`, `mamba`, and `micromamba` are not in your `PATH` you will need to set `JULIA_CONDAPKG_EXE` to include them.

#### Using your current Conda, Mamba, and MicroMamba environment

    ENV["JULIA_CONDAPKG_BACKEND"] = "System"
    ENV["JULIA_CONDAPKG_EXE"] = "/path/to/conda"   # optional

The System backend will use your preinstalled Conda environment.

#### Installing Python packages

Assuming you are using `CondaPkg.jl`, PythonCall uses it to automatically install any Python packages. For example,

    using CondaPkg
    # enter package manager
    conda add some_package

"""

# ╔═╡ 07c96535-102c-4581-bba7-50f37bd766f9
md"""
## Using Macros

Unlike Matlab, Python, and R, Julia has macros. They are a very powerful programming construct. Macros change existing source code or generate entirely new code. In essence, they simplify programming by automating mundane coding tasks.

Preprocessor "macro" systems, like that of C/C++, work at the source code level by perform textual manipulation and substitution before any parsing or interpretation is done. Whereas, Julia macros work at the level of the abstract syntax tree after parsing, but before compilation is done.

### The Abstract Syntax Tree

    str1 = "3 * 4 + 5"
    ex1 = Meta.parse(str1)
    typeof(ex1)

Try it.
"""

# ╔═╡ 9c45b534-cd6c-4b3d-9ff4-d035347c87e5


# ╔═╡ 6bc277f1-3ab6-4e12-92fc-65e6288af2c1
md"""
Note that the parsed expression is an `Expr` type.

    dump(ex1)

Show or dump the abstract syntax tree (AST) of the expression.
"""

# ╔═╡ f09d458f-7846-46a5-a814-b51771bf91b7


# ╔═╡ 41a9007c-e9a1-4228-be45-55becfffa944
md"""
The `Expr` type has two fields, a `head` and an `args`. The `head` declares the item is a function `call` of type `Symbol` and the `args` is an `Array` of function arguments, namely the `+` operator of type `Symbol` and the two values to be added. The first value is another `Expr` type and the second is a 64-bit integer. The second nested `Expr` is also composed of a `Symbol` call. Its arguments are the multiplication `*` operation of type `Symbol` and two 64-bit integers. Note that the multiplication operation is nested in the addition operation, since multiplication has precedence over addition.

Note that the expression `ex1` can be written directly in AST syntax.

    ex2 = Expr(:call, :+, Expr(:call, :*, 3, 4), 5)
    ex1 == ex2

Try it.
"""

# ╔═╡ 06f3afb2-869a-4e2b-af58-4366b27d0a65


# ╔═╡ 3f2aef09-55c0-40c3-a50d-7081e66c60ed
md"""
### The `:` character

The `:` character has two syntatic purposes in Julia. It signifies a `Symbol` or a `Quote`.

#### Symbols

A `Symbol` is an interned string used as a building-block of an expression.

    sym = :foo
    typeof(sym)
    sym == Symbol("foo")

Try it.
"""

# ╔═╡ bc5709bd-8c44-4d58-82cc-e14eef20cfe6


# ╔═╡ c1e446d9-63e9-4b9d-a0da-c1321c7f0a38
md"""
The `Symbol` constructor takes a variable number of arguments and concatenates them together to create a `Symbol` string.

    Symbol("func", 10)

Try this.
"""

# ╔═╡ d7ef1705-4fb0-4adf-b678-c993d9192899


# ╔═╡ 90538e89-e592-4536-99cb-7378ec320b8d
md"""
In the context of expressions, symbols are used to indicate access to variables. When an expression is evaluated, a symbol is replaced with the value bound to that symbol in the appropriate scope.

#### Quoting

The second purpose of the `:` character is to create expression objects without using the explicit `Expr` constructor. This is referred to as *quoting*.

    ex3 = :(3 * 4 + 5)
    ex1 == ex2 == ex3

Try this example.
"""

# ╔═╡ 611e0640-dc39-4846-89c9-172bc001e994


# ╔═╡ e7934544-0344-48d3-8046-c3796874e5b3
md"""
So, there are three ways to construct an expression allowing the programmer to use whichever one is most convenient.

There is a second syntatic form of quoting, called a `quote` block (i.e. `quote ... end`), that is commonly used for multiple expressions.

Try the following example.

    ex4 = quote
        x = 1
        y = 2
        x + y
    end
    typeof(ex4)
"""

# ╔═╡ c47eb25e-ff42-47a0-9949-11228e3c0535


# ╔═╡ 53ce9042-6f97-4a6e-bfaf-19aa7e313ba2
md"""
#### Interpolation

Julia allows *interpolation* of literals or expressions into quoted expressions by prefixing a variable with the `$` character. For example.

    a = 1;
    ex5 = :($a + b)

Try it.
"""

# ╔═╡ 24368ee3-43e1-44c0-8293-75cc1e8f4f6c


# ╔═╡ 12b97064-d8da-49cc-92aa-f5155b5c1b52
md"""
Splatting is also possible.

    args = [:x, :y, :x];
    :(f(1, $(args...)))

And this too.
"""

# ╔═╡ 9de33d97-b08d-4a5a-b53a-862c0bfd2cb0


# ╔═╡ 2e45c794-62f0-4a1b-a346-da291e4c8469
md"""
#### Expression evaluation

Julia will evalution an expression in the global scope using `eval`.

    eval(ex1)
"""

# ╔═╡ ade3dfbb-23bb-4ca6-8a33-3ec16dbed523


# ╔═╡ c8c898a7-7ec5-4b3f-8875-5901e0ef12fc
md"""
### Macros

#### Basics

Defining a macro is like defining a function. For example,

    macro sayhello(name)
        return :( println("Hello", $name))
    end
"""

# ╔═╡ f1ba0108-fbb7-4128-98f7-89c4f1e25790


# ╔═╡ 8bbe63e8-6a6e-4f96-8025-bbae25983a7e
md"""
Now invoke the `@sayhello` macro.

    @sayhello("world")
"""

# ╔═╡ 6e6829b6-1d2a-46e8-bee2-dd4e116d4b3d


# ╔═╡ 2494a756-0b40-4b6e-b79f-deb616183384
md"""
Parentheses around the arguments are optional.

    @sayhello "world"
"""

# ╔═╡ 3f9fcacd-05e6-4dd7-ba01-491750f3940d


# ╔═╡ f7fffc76-3607-4d90-ba75-d521366f7fb1
md"""
!!! note
    When using the parenthesized form, there should be no space between the macro name and the parentheses. Otherwise the argument list will be interpreted as a single argument containing a tuple.
"""

# ╔═╡ 9064ec91-4ddf-4f7b-890d-2e59265483a1
md"""
#### Usage

Macros can be used for many tasks such as performing operations on blocks of code, e.g. timing expressions (`@time`), threading `for` loops (`@threads`), and converting expressions to broadcast form (`@.`). Another use is to generate code. When a significant amount of repetitive boilerplate code is required, it is common to generate it programmatically to avoid redundancy.

Consider the following example.

    struct MyNumber
        x::Float64
    end
"""

# ╔═╡ bcce9741-7e63-4609-9529-0e9323b8eb21


# ╔═╡ a278e94d-1f4c-422c-9ac7-c950750a6ef9
md"""
We want to add a various methods to it. This can be done programmatically using a loop.

    for op = (:sin, :tan, :log, :exp)
        eval(quote
            Base.$op(a::MyNumber) = MyNumber($op(a.x))
        end)
    end

Try this example.
"""

# ╔═╡ 386c7942-700d-4486-bede-853a6c2ef811


# ╔═╡ 1751fb54-938c-4222-a41a-17ce97f800bc
md"""
A slightly shorter version of the above code generator that use the `:` prefix is:

    for op = (:sin, :cos, :tan, :log, :exp)
        eval(:(Base.$op(a::MyNumber) = MyNumber($op(a.x))))
    end

An even shorter version of the code uses the `@eval` macro.

    for op = (:sin, :cos, :tan, :log, :exp)
        @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
    end

For longer blocks of generated code, the `@eval` macro can proceed a code `block`:

    @eval begin
        # multiple lines
    end

### Generated Functions

A special macro is `@generated`. It defines so-called *generated functions*. They have the capability to generate specialized code depending on the types of their arguments with more flexibility and/or less code than what can be done with multiple dispatch. Macros work with expressions at the AST level and cannot acces the input types. Whereas, generated functions are expanded at the time when the argument types are known, but before the function is compiled.

Here is an example.

    @generated function foo(x)
        Core.println(x)
        return :(x * x)
    end
"""

# ╔═╡ 1fbdea1e-ef3a-4ace-ae76-1ccda2273087


# ╔═╡ 1522314b-4982-439e-ab97-933869a5f307
md"""
    x = foo(2)

    x

!!! note
    The result of the function call is the return type, not the return value.
"""

# ╔═╡ 63ed8db8-2104-4370-8a75-e9348c50cdf8


# ╔═╡ 3de9644d-b66a-45b8-945d-6e000319f2b9
md"""
    y = foo("bar")

    y
"""

# ╔═╡ 28487c59-7df4-41b9-859a-79438b1d3b06


# ╔═╡ 78bb1e78-70ba-4f58-abb0-c0de3272eb50
md"""
Generated functions differ from regular functions in five ways. They:

1. are prefixed by `@generated`. This provides the AST with some additional information.
2. can only access the types of the arguments, not their values.
3. are nonexecuting. They return a quoted expression, not a value.
4. can only call previously defined functions. (Otherwise, `MethodErrors` may result.)
5. must not *mutate* or *observe* any non-constant global state. They can only read global constants, and cannot have side effects. IN other words, they must be complete pure.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─4c788b44-77e1-11ed-0ce7-5914857ba421
# ╟─f0c6b09d-8b64-4175-aacd-6b3ac72078f6
# ╠═667e42f2-b6b5-4eb9-817f-57aee042d7ca
# ╟─06d63e41-f9b9-4c75-87d4-241beb454dc5
# ╠═20c226ca-44e6-4565-b601-07f5df7828ac
# ╟─7728f44a-93e1-4514-8964-6351a5ebff07
# ╟─5d883d2b-515f-4286-a2ab-15127ac6b5ea
# ╟─87b3ca0e-93d3-41d3-aa6d-e06ab0fbac26
# ╠═0db12101-fcf9-48a3-a337-ad53a4713f6d
# ╟─56141542-b8eb-4139-8199-acea701449e2
# ╠═966da8a4-6cee-47c3-bca1-a90460218f3f
# ╟─4adcd9bb-40dc-47dc-941d-66d34465b218
# ╠═adb77392-c109-4e90-917e-75a23e7f21a9
# ╟─aa641087-0617-45ce-9ad1-69128fd155e9
# ╟─07c96535-102c-4581-bba7-50f37bd766f9
# ╠═9c45b534-cd6c-4b3d-9ff4-d035347c87e5
# ╟─6bc277f1-3ab6-4e12-92fc-65e6288af2c1
# ╠═f09d458f-7846-46a5-a814-b51771bf91b7
# ╟─41a9007c-e9a1-4228-be45-55becfffa944
# ╠═06f3afb2-869a-4e2b-af58-4366b27d0a65
# ╟─3f2aef09-55c0-40c3-a50d-7081e66c60ed
# ╠═bc5709bd-8c44-4d58-82cc-e14eef20cfe6
# ╟─c1e446d9-63e9-4b9d-a0da-c1321c7f0a38
# ╠═d7ef1705-4fb0-4adf-b678-c993d9192899
# ╟─90538e89-e592-4536-99cb-7378ec320b8d
# ╠═611e0640-dc39-4846-89c9-172bc001e994
# ╟─e7934544-0344-48d3-8046-c3796874e5b3
# ╠═c47eb25e-ff42-47a0-9949-11228e3c0535
# ╟─53ce9042-6f97-4a6e-bfaf-19aa7e313ba2
# ╠═24368ee3-43e1-44c0-8293-75cc1e8f4f6c
# ╟─12b97064-d8da-49cc-92aa-f5155b5c1b52
# ╠═9de33d97-b08d-4a5a-b53a-862c0bfd2cb0
# ╟─2e45c794-62f0-4a1b-a346-da291e4c8469
# ╠═ade3dfbb-23bb-4ca6-8a33-3ec16dbed523
# ╟─c8c898a7-7ec5-4b3f-8875-5901e0ef12fc
# ╠═f1ba0108-fbb7-4128-98f7-89c4f1e25790
# ╟─8bbe63e8-6a6e-4f96-8025-bbae25983a7e
# ╠═6e6829b6-1d2a-46e8-bee2-dd4e116d4b3d
# ╟─2494a756-0b40-4b6e-b79f-deb616183384
# ╠═3f9fcacd-05e6-4dd7-ba01-491750f3940d
# ╟─f7fffc76-3607-4d90-ba75-d521366f7fb1
# ╟─9064ec91-4ddf-4f7b-890d-2e59265483a1
# ╠═bcce9741-7e63-4609-9529-0e9323b8eb21
# ╟─a278e94d-1f4c-422c-9ac7-c950750a6ef9
# ╠═386c7942-700d-4486-bede-853a6c2ef811
# ╟─1751fb54-938c-4222-a41a-17ce97f800bc
# ╠═1fbdea1e-ef3a-4ace-ae76-1ccda2273087
# ╟─1522314b-4982-439e-ab97-933869a5f307
# ╠═63ed8db8-2104-4370-8a75-e9348c50cdf8
# ╟─3de9644d-b66a-45b8-945d-6e000319f2b9
# ╠═28487c59-7df4-41b9-859a-79438b1d3b06
# ╟─78bb1e78-70ba-4f58-abb0-c0de3272eb50
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
