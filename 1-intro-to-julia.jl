### A Pluto.jl notebook ###
# v0.19.17

using Markdown
using InteractiveUtils

# ╔═╡ 8f016c75-7768-4418-8c57-100db3073c85
using Measurements

# ╔═╡ 88ca2a73-6203-447c-afcc-9e370a82076b
using Unitful

# ╔═╡ 7ca0c1a6-2d3a-4ff3-80aa-a4e39b12828b
using SparseArrays

# ╔═╡ 1840579b-5067-45e1-ad3e-cae8775f0ce9
using CairoMakie

# ╔═╡ d1366a55-b4fc-4ddb-b5c2-5f3381c48b49
html"<button onclick='present()'>present</button>"

# ╔═╡ 09193424-25b9-45ce-840f-f24bbcc46c9d
md"""
## Introduction

### Historical Context

Twenty-six years ago at ADASS VI, Harrington and Barrett hosted a Birds-of-a-Feather session entitled "Interactive Data Analysis Environments". Based on their review of over a dozen interpreted programming languages such as Glish, GUILE, IDL, IRAF, Matlab, Perl, Python, and Tcl; they recommended that Python be considered the primary language for astronomical data analysis. The primary reasons were that the language was simple to learn, yet powerful; well supported by the programming community; and had FORTRAN-like arrays. However, for good performance, the multi-dimensional arrays needed to be written in a compiled language, namely C. So Numerical Python suffered from the "two language problem".

### Why Julia?

In about 2009, four faculty members at MIT, who were not satisfied with the state of scientific computing, decided to develop a high performance, scientific programming language. After ten years of development, they release Julia Version 1.0. Their aims were to create an open-source interpreted language that was concise, extensible, and high performance.

### What Differentiates Julia From Other Languages?

* Julia is **composable**.
* Julia is **concise**.
* Julia is **high performance**.
* Julia is **productive**.
* Julia is **easy to maintain**.
* Julia is **free and open-source**.

### Why Have I migrated to Julia?

Although an early advocate and developer of Numerical Python, I knew its limitations, namely, the two language problem. Therefore, once a better scientific programming language came along, I was prepared to migrate to it. Julia is that language.
"""

# ╔═╡ b1ed2c4e-f5fa-4e5e-87d8-7af6f80a83ca

md"""## Getting Started"""




# ╔═╡ 7f3357bc-4103-4a35-af21-9c86f5a0ec2f
md"""
**===================================================================================**

### Starting Julia

Enter `julia` at the terminal prompt. Set the number of threads to `auto`. Threads will be discussed later in Parallel Computing.

    > julia --threads=auto
    
                   _
       _       _ _(_)_     |  Documentation: https://docs.julialang.org
      (_)     | (_) (_)    |
       _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.    
      | | | | | | |/ _` |  |
      | | |_| | | | (_| |  |  Version 1.7.3 (2022-05-06)
     _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
    |__/                   |
    
    julia>

!!! tip

    The command line option "-q" can be used to remove the start-up banner.
"""

# ╔═╡ 7475c896-d1b1-4429-9ba8-8e78de41e0b0
md"""
**===================================================================================**

### Stopping Julia

To exit Julia, enter `<Ctl-D>` or `exit()`

    julia> <Ctl-D>

!!! tip
    Don't do this now!

"""

# ╔═╡ 5df8264e-6e37-4674-abdf-2b05c530787f
md"""
**===================================================================================**

### The command line  or  REPL (Read-Eval-Print-Loop)"""

# ╔═╡ f646ca14-c01e-47ee-8e2b-052d9db0985b
md"""
Our first command:

    println("Hello World")
"""

# ╔═╡ 4a404280-2845-4deb-8eee-2dcdcb9aed27
println("Hello World")

# ╔═╡ 7813824a-cae9-4b97-ac90-e542fbd630d5
md"""
!!! note
    Unlike Jupyter and the REPL, Pluto prints the result above the line, not below.

Our first calculation

    a = 4
"""

# ╔═╡ 6ac51e87-87a2-4ccc-9f08-0028700b3cda
a = 4

# ╔═╡ 27208179-35c3-43c1-9548-3620c8aa7680
md"    b = 2"

# ╔═╡ 40d8d18c-3713-4e77-812d-9d77a4e1ac50
b = 2

# ╔═╡ aa3e9db7-49d1-40f8-b745-6c4faa2197e1
md"    a + b"

# ╔═╡ 97b8b163-aef4-4dda-8079-2338d86c3d7a
a + b

# ╔═╡ 419a6dec-1db0-477f-911f-049223b5674f
md"""
**===================================================================================**

### Other REPL Modes

#### Help, '?'
For help mode,

    julia> ?
    help?> println
    search: println printstyled print sprint isprint

    println([io::IO], xs...)
    
    Print (using print) xs to io followed by a newline. If io is not supplied, prints to the default output stream stdout.
    
    See also printstyled to add colors etc
    
    Examples
    ≡≡≡≡≡≡≡≡≡≡
    
    julia> println("Hello, world")
    Hello, world
    
    julia> io = IOBuffer();
    
    julia> println(io, "Hello", ',', " world.")
    
    julia> String(take!(io))
    "Hello, world.\n"

Enter 'delete' or 'backspace' to exit help"""

# ╔═╡ 98340265-f51e-47a0-95d2-df179b87f54b
? add

# ╔═╡ 8ee7f43d-bf75-4975-ac64-54c2d5a0174a
md"""
#### Shell, ';'

For shell mode,

    julia> ;
    shell> pwd
    /Users/myhomedir

Enter 'delete' or 'backspace' to exit shell
"""


# ╔═╡ d4368e22-60c6-456a-94a5-56e6dfdb26d7
;pwd()

# ╔═╡ d1e9c51c-efb9-4dcb-9d28-8c54a235fbb4
md"""
#### Package Manager, `]`

    julia> ]
    pkg> 

For package manager help,

    pkg> ? `return`

Returns a brief summary of package commands

To add a package,

    pkg> add <package>
    pkg> add <package1>, <package2>

When adding a package, the Julia on-line repository will be searched. The package and its dependencies will then be downloaded, compiled, and installed. This may take anywhere from a few seconds to a few minutes depending on the size of the package and its dependencies.

To use or load a package (after it has been added),

    julia> using <package>
    julia> using <package1>, <package2>

A feature of the 'using' command is that it will add the package, if it hasn't alaredy been added.

The Measurements package enables variables to have both values and errors.
Let's add the Measurements package using the `using` statement.
"""


# ╔═╡ b27578b2-f5f5-4e46-82e6-0007be187ba6
md"""
To check the manifest:

    pkg> status

or

    pkg> st
"""

# ╔═╡ 1a95f9e5-77a3-46d0-9d4d-b28fbb0abf26


# ╔═╡ 065265a5-c9ad-4a39-b14d-f4e2e49d3f7a
md"""
To update a package in the manifest:

    pkg> update <package>

or

    pkg> up <package>

To update all packages in the manifest,

    pkg> up

    up

To garbage collect packages not used for a significant time,

    pkg> gc

Let's do some more calculations.

    m1 = measurement(4.5, 0.1)

"""

# ╔═╡ 84d272eb-115d-4d4e-8a54-7e204facf8e3
m1 = measurement(4.5, 0.1)

# ╔═╡ 094b6f30-cbd6-46b1-8e0c-3fdb1ef18261
md"""Typing 'measurements' is rather awkward. There must be a better way. How about the following?

    m2 = 15 ± 0.3

where the plus-minus character is entered using LaTex syntax followed by tab, i.e., \pm<tab>.
"""


# ╔═╡ 7ba8dc19-e0ca-40de-a778-7583ca70978d
m2 = 15 ± 0.3

# ╔═╡ 668abc35-fdc3-430f-8c90-de3c2c2cd77b
md"""
One of the features of Julia is that it understands unicode. For example, expressions in a printed document that contain greek characters can be entered as greek characters in your code. Let's calculate the following expression.

    α = m1 + m2
"""

# ╔═╡ 232cc444-03b7-442a-8737-8b7725b43421
α = m1 + m2

# ╔═╡ d2a2d0bc-e883-439f-8e34-166e2369caef
md"""
!!! note

    Notice that the error of the result α has been propogated correctly.

Let's add another package called Unitful, which enables attaching units to variables.
"""

# ╔═╡ c24f1ddd-5e31-4073-a627-86cedb1d44c2
md"""
Now let's create two new values m3 and m4 with units attached, and then multiply them together to create a third variable β.

    m3 = (32 ± 0.1)u"m/s"
    m4 = (9.8 ± 0.3)u"s"
    β = m3 * m4
"""

# ╔═╡ 26f1a52e-8cf9-4495-8922-61b5fbfd594d
m3 = (32 ± 0.2)u"m/s"

# ╔═╡ 63a4b27a-5361-4d95-8787-ae31ca7987fe
m4 = (9.8 ± 0.3)u"s"

# ╔═╡ 784afc89-ddd9-4461-bd4c-4f9c0197e11d
β = m3 * m4

# ╔═╡ cf4a0e8f-9210-4f1e-84d4-ee7ff09aaf61
md"""
The variable β's value now has an associated error and unit.

Let's see if this works with one dimensional arrays or vectors.

    γ = [10 ± 0.1, 20 ± 0.2, 30 ± 0.3]u"m/s" .* [15 ± 0.01, 25 ± 0.02, 25 ± 0.03]u"s"

Note the dot '.' before the multiplication character '*'. This means element-wise multiplication. This will be dicussed more in "Vectorized Operations".
"""

# ╔═╡ fdba7211-e480-4948-8435-76a7608e7e63
γ = [10 ± 0.1, 20 ± 0.2, 30 ± 0.3]u"m/s" .* [15 ± 0.01, 25 ± 0.02, 25 ± 0.03]u"s"

# ╔═╡ e00b826d-1bbb-4413-a907-eb181369526b
typeof(γ)

# ╔═╡ b56255c6-9d3b-4e2f-a9a0-c6fe69990f3d
md"""
!!! note

    What have we learned about the Julia command line and features?

    * Julia has four command line modes: **REPL**, **help**, **shell**, and **package manager**. 

    * Julia understands **unicode**.

    * Julia packages are **composable**. It means that independent packages are compatible and work together without modification, as demonstrated by the Measurements and Unitful packages. 
"""

# ╔═╡ 5cd072cb-5d71-4a08-8e41-4eaaa7faaa5c
md"""
**===================================================================================**

## Language Basics

Because of Julia's multiple dispatch, types and functions are loosely bound. Thus, it is not a true object-oriented language, where functions are selected for execution using single dispatch. Multi-dispatch will be explained later when we dicsuss functions.
"""

# ╔═╡ f37bc13e-fa91-4166-983b-fd13a8493435
md"""
**===================================================================================**

### Comments

A comment string begins with a "#" and extends to the end of the line.

A comment block begins and ends with "###".
"""

# ╔═╡ 0d0c11c0-d39f-462c-9fb6-ab90ca98d230
md"""
**===================================================================================**

### Types

The optional type operator "::" is used to specify a type to expressions and variables, especially when writing functions. If no type is specified, Julia will infer the type based on context.

There are two primary reasons for type annotation:

1. As an assertion to confirm that the code is working properly, and
2. To provide extra type information to the compiler to improve performance.
"""

# ╔═╡ a02bbbbb-6b3f-47ef-a11f-1db9b802db6f
md"""
	(1+2)::Float32
    (1+2)::Int

Let's see how this works. Try the above examples.
"""

# ╔═╡ 2262c860-c06c-4293-8e6d-b616228cb301
(1+2)::Float32

# ╔═╡ 68e64f74-8a6b-403e-a404-52fb9cdea54b
(1+2)::Int

# ╔═╡ 0887eca0-6760-4d9b-b44e-d1a14059aede
md"""Julia has various categories of types within a type-hierarchy. The following are some of the more common types.

!!! note
    Types should be capitalized.
"""

# ╔═╡ 0ad9aa76-f6c7-4368-8ae4-58daa548e065
md"""#### Abstract Types

"abstract type" declares a type that cannot be instantiated, and serves only as a node in the type graph, thereby describing sets of related concrete types.

Let's create an abstract type.

    abstract type Widget end
"""

# ╔═╡ 1bc3da9e-143c-489c-b8de-a29dc48f17cb
abstract type Widget end

# ╔═╡ f00dd72a-8705-426b-9eb4-b91cf1ea95d4
md"""
And some Widget subtypes using the subtype operator "<:".

    abstract type Round <: Widget end
    abstract type Square <: Widget end
"""

# ╔═╡ d308df6b-14ec-49ec-8270-a3b9efd88517
abstract type Round <: Widget end

# ╔═╡ 01805f02-f9f6-4e3e-8e93-a0628753130f
abstract type Square <: Widget end

# ╔═╡ a90b9011-714e-41d1-b7a3-fb3eb9dc56da
md"""
The subtype and supertype of a type can be shown using the functions "subtype" and "supertype".

Show the supertype and subtypes of Widget.
"""

# ╔═╡ b8325403-9744-4a9d-ae64-be88671da89b
supertype(Widget)

# ╔═╡ 4879dae5-442e-4dc6-90c9-366ff76912bb
subtypes(Widget)

# ╔═╡ 4c278c5a-3324-4245-8ddf-f5390167168f
md"""
!!! note
    The "Any" type is at the top of the hierarchy. It is the union of all types. In other words, it is the root node.
    
    When the type of an expression or variable cannot be inferred from the context, the type defaults to "Any".
"""

# ╔═╡ 3772a828-561d-4600-8e67-49a28cc6cf09
md"""#### Primitive Types

A primitive type is a concrete type whose data consists of plain old bits. Classic examples of primitive types are integers and floating-point values. Unlike most languages, Julia lets you declare your own primitive types, rather than providing only a fixed set of built-in ones.

Let's see what primitive types Integer and AbstractFloat contain.

    subtypes(Integer)
"""

# ╔═╡ aa4a7ec0-a270-482b-abeb-7168de767938
subtypes(Integer)

# ╔═╡ b8e3b72a-e501-4164-b06c-cbb3282d9d11
md"    subtypes(Signed)"

# ╔═╡ d9aa9f5e-31b6-49a3-bae8-a9b149e6ab91
subtypes(Signed)

# ╔═╡ 15b0159b-9c8c-4327-b73d-d7e19decde2a
md"    subtypes(AbstractFloat)"

# ╔═╡ 5d5b1283-043b-437a-afda-75801808acc9
subtypes(AbstractFloat)

# ╔═╡ 6a6b2a0a-6bb6-4a67-b4c1-46631503918d
md"""Theoretically, a primitive type can have any number of bits, e.g., 5 or 17. Practically, the number of bits is constrained to multiples of 8. This is a limitation of the LLVM compiler, not Julia. So the Bool type is 8 bits, not 1 bit.
"""

# ╔═╡ 877faa74-7490-44a3-9e97-b36b36050796
md"""#### Characters (' ') vs. Strings (" ")

Unlike Python, single and double quotes have different meanings. Single quotes create characters. Double quotes create strings. The reason for this is Unicode.

    'j'
"""

# ╔═╡ bba18435-d355-4fca-a6f5-10dacde17413
'j'

# ╔═╡ d9e911a8-13f9-41e5-ac36-4aee3ec24c59
md"""
    Char(167)

Or

    '\u00A7'
"""

# ╔═╡ 5f72777b-a174-453c-8b18-ebf1f4bebe0d
Char(167)

# ╔═╡ 734a4185-4001-410f-affc-71b33e339339
'\u00A7'

# ╔═╡ c349f7b8-bdf0-4b94-b412-06c5e7f3cbc5
md"""    "This is a string" """

# ╔═╡ d8be9383-fb60-4938-9376-f91d59f21559
"This is a string"

# ╔═╡ 31dfb05b-ed87-48f9-a74c-0055e46de160
md"""
Triple quotes work the same as in Python.

    \"""
    This is line 1.
    This is line 2.
    \"""

Try it.
"""

# ╔═╡ d2ada743-b82d-47c8-9b1d-4bd56de76e62


# ╔═╡ ea15815e-0ae3-4f22-9dce-a17cb3a0560b
md"""#### Composite Types

Composite types are called records, structs, or objects in various languages. A composite type is a collection of named fields, an instance of which can be treated as a single value.

In mainstream object oriented languages, such as C++, Java, Python and Ruby, composite types also have named functions associated with them, and the combination is called an "object". In Julia, all types are objects, but the objects have no bound functions. This is necessary because Julia selects the function/method using multiple dispatch, meaning that all argument types of a function are used to select the method, not just the first argument type.

Composite types are defined using the "struct" keyword followed by a block of field names. They are immutable (for performance reasons), unless modified by the "mutable" keyword.

    struct Longday
        day::Int64
        frac::Float64
    end

An instance of Longday is created as follows.

    day1 = Longday(1, 0.5)

Let's create a Longday type and an instance of it.

"""

# ╔═╡ be09f5d0-daea-4f47-8dc8-33c875fca843
struct Longday
    day::Int64
    frac::Float64
end

# ╔═╡ 10ec3b0d-1add-4f92-8f4c-b594ab3f0e68
day1 = Longday(1, 0.5)

# ╔═╡ 6ee4665d-c5b9-4881-ad65-15c6a8229f3f
md"""
The field can be access using "dot" notation as follows:

    day1.day
    day1.frac
"""

# ╔═╡ f5596a05-04de-4955-9575-4c035e0f1495
day1.day

# ╔═╡ a1b4f7bb-8238-40d6-81cb-6d5e6c737134
day1.frac

# ╔═╡ 3b8e773f-df6e-4b59-9f5d-e14366d02754
md"""#### Type Union

A type union is an abstract type that includes all instances of any of its argument types. The empty union Union{} is the leaf node of all Julia types.

    Union{Int, Nothing}

The variable "nothing" is the singleton instance of the type "Nothing".

Try it.
"""

# ╔═╡ 91f35db2-6a17-42aa-8580-1dea220b8c11


# ╔═╡ a631464d-e08a-4a89-8c47-fd5a7b2dee16
md"""#### Symbol Type

A type used to represent identifiers in parsed Julia code, namely the Abstract Syntax Trees (ASTs). Also often used as a name or label to identify an entity (e.g., as a dictionary key). Symbols are created using the colon prefix operator ":".

Symbols can be confusing when you first meet them in Julia code.

    :symbol
    typeof(:symbol)
"""

# ╔═╡ 7a8faa02-34b1-4416-beab-2909fb56c767
:symbol

# ╔═╡ 6e1a3b46-05f0-487d-933a-6ff0d9d43a2b
typeof(:symbol)

# ╔═╡ 05adfd23-c809-4706-9bf2-1a0a2445748b
md"""#### Using Types

The type hierarchy allows variables and functions to be constrained to a particular set of types. Let's try a simple example.

Enter the following expressions.

    arg1::Float32 = 12.3
"""

# ╔═╡ 67a4ff9f-c75f-444c-9091-e9b5c17ee773
arg1::Float32 = 12

# ╔═╡ 67ad1d30-498e-414a-83d5-12e020c92741
md"""    typeof(arg1) <: Integer"""

# ╔═╡ cfd93268-174f-4a7e-9f98-3d5787c9392c
typeof(arg1) <: Integer

# ╔═╡ 73be3ec3-2668-44a0-bed9-242796bf5f08
md"""    typeof(arg1) <: ABstractFloat"""

# ╔═╡ a96dd069-09aa-4add-baba-99ffae36bfe8
typeof(arg1) <: AbstractFloat

# ╔═╡ 8a3aa0d3-1ade-4961-975d-b39899731ffe
md"""
!!! note

    What new things have we learned about Julia?

    * Julia has a type hierarchy with the type "Any" at the top.

    * Julia defines characters and strings using single and double quotes, respectively.

    * Julia defines composite types using the "struct" keyword.

    * Julia allows a set of types to be defined using the "Union" type.
"""

# ╔═╡ f6c44dbf-2801-4523-b6cc-2632b9e87fb8
md"""
**===================================================================================**

### Mathematical Operations and Elementary Functions

#### Arithmetic Operators

The following arithmetic operators are supported on all primitive numeric types:

| Expression | Name           | Description                            |
|:----------:|:---------------|:---------------------------------------|
| `+x`       | unary plus     | the identity operation                 |
| `-x`       | unary minus    | maps values to their additive inverses |
| `x + y`    | binary plus    | performs addition                      |
| `x - y`    | binary minus   | performs subtraction                   |
| `x * y`    | times          | performs multiplication                |
| `x / y`    | divide         | performs division                      |
| `x ÷ y`    | integer        | divide x / y, truncated to an integer  |
| `x \ y`    | inverse divide | equivalent to y / x                    |
| `x ^ y`    | power          | raises x to the yth power              |
| `x % y`    | remainder      | equivalent to rem(x,y)                 |

A numeric literal placed directly before an identifier or parentheses, e.g. `2x` or `2(x+y)`, is treated as a multiplication, except with higher precedence than other binary operations. This is why Unitful doesn't need a multiplication operator between the value and the unit.

#### Arithmetic Comparisons

Standard comparison operations are defined for all the primitive numeric types:

| Expression | Name                     | Description                    |
|:----------:|:-------------------------|:-------------------------------|
|     ==     | equality                 | |
|   !=, ≠    | inequality               | |
|     <      | less than                | |
|   <=, ≤    | less than or equal to    | |
|     >      | greater than             | |
|   >=, ≥    | greater than or equal to | |

#### Chaining Comparisons

Unlike most languages, comparisons can be arbitrarily chained:

    1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5

The middle expression is only evaluated once, rather than twice as it would be if the expression were written as `v(1) < v(2) && v(2) <= v(3)`. However, the order of evaluations in a chained comparison is undefined.

#### Boolean Operators

Boolean operators are supported on Bool types.

| Expression | Name              | Description                    |
|:----------:|:------------------|:-------------------------------|
|   `!x`     | negation          | true -> false or false -> true |
|  `x && y`  | short-circuit and | boolean and                    |
| `x \|\| y` | short-circuit or  | boolean or                     |

#### Bitwise Operators

The following bitwise operators are supported on all primitive integer types:

| Expression | Name        | Description                   |
|:----------:|:------------|:------------------------------|
|    `~x`    | not         | bitwise not                   |
|  `x & y`   | and         | bitwise and                   |
|  `x \| y`  | or          | bitwise or                    |
|  `x ⊻ y`   | xor         | bitwise exclusive or          |
|  `x ⊼ y`   | nand        | bitwise nand (not and)        |
|  `x ⊽ y`   | nor         | bitwise nor (not or)          |
| `x >>> y`	 | shift right | logical shift right           |
|  `x >> y`  | shift right | arithmetic shift right        |
|  `x << y`  | shift left  | logical/arithmetic shift left |

#### Updating Operators

Every binary arithmetic and bitwise operator also has an updating version that assigns the result of the operation back into its left operand. The updating version of the binary operator is formed by placing an `=` immediately after the operator.

Here are the operators.

`+=  -=  *=  /=  \=  ÷=  %=  ^=  &=  |=  ⊻=  >>>=  >>=  <<=`

#### Vectorize Operators (Dot Operators)

For every binary operation, there is a corresponding `.` (dot) operation that performs broadcasting, i.e., an element-wise operation.

Moreover, all vectorized "dot calls" are *fusing*. In other words, if you compute `2 .* A.^2 .+ sin.(A)` for an array `A`, it performs a single loop over `A`, computing `2a^2 + sin(a)` for each element `a` of `A`. So no intermediate arrays are created, which can significantly improve performance.

!!! note
    The vectorize operator `.` is prefixed to operators and postfixed to functions.

!!! note
    What have we learned about Julia's operators?
    * Julia has all of the usual arithmetic, boolean, bitwise, and updating operators, plus a few more.
    * Julia allows chaining of comparison operators for conciseness and performance.
    * Julia has unicode aliases for some operators.
    * Julia has a vectorize operator that can fuse array operations, eliminating the need for intermediate arrays.
"""

# ╔═╡ d4c1a6b5-41e0-4f00-9240-ae68bfd30407
A = rand(10)

# ╔═╡ 94b60423-b3ac-44aa-8b0b-f00cd42f407a
2 .* A.^2 .+ sin.(A)

# ╔═╡ eda84481-7f84-4598-931f-f4021f135407
md"""
**===================================================================================**

### Control Flow

Julia has the usual control flow suspects:

* Compound expressions

* Conditional evaluation

* Short-circuit evaluation

* Repeated evaluation or loops

* Exception handling

* Task or coroutines

#### Compound expressions

Two ways to create compound expressions: "begin-end" block and semicolon ";" list.

    z = begin
        x = 1
        y = 2
        x + y
    end

    z = (x = 1; y = 2; x + y)

Try the compound list version.
"""

# ╔═╡ 5d6b5ec7-7502-4eaa-978d-b2e86d7967dc
z = (x = 1; y = 2; x + y)

# ╔═╡ f27186dd-6ca3-410f-9926-fd51222cf077
md"""#### Conditional evaluation

Two ways to perform conditional evaluation: the "if-elseif-else-end" blocks and the tenary expression "?:". (If you have not encountered the ternary expression before, `x ? y : z` means if `x` is true, then `y`, else `z`.) 

    zz = typeof(z) <: Int ? 1 : 1.0

Try it.
"""

# ╔═╡ ff568320-e769-4148-b2cc-083e484596e5
zz = typeof(z) <: Int ? 1 : 1.0

# ╔═╡ 5db58df9-10dc-48ba-a156-57cb1c3afef5
md"""#### Short-circuit evaluation

`&&` and `||` are logical "and" and "or".

Short circuit evaluation means that:

* In the expression `a && b`, the subexpression `b` is only evaluated if `a` evaluates to true.
* In the expression `a || b`, the subexpression `b` is only evaluated if `a` evaluates to false.

"""

# ╔═╡ 3e08e0ce-cf9f-4705-91f1-9314c2d3b34b
md"""#### Repeated evaluation

Two ways to create loops: "while-end" and "for-end".

    i = 1

    while i <= 5
        println(i)
        global i += 1
    end

!!! note
    Variables inside a block stay within the block, as in "what happens in Vegas ...". Hence, `global` variables are visible outside the loop and are discouraged.

Try the above while loop.
"""

# ╔═╡ 8f145da3-435c-4a15-bf56-45692e969a70
begin
i = 1

while i <= 5
    println(i)
    global i += 1
end
end

# ╔═╡ 9bb10bc2-9eb1-4db1-b951-4d7e57fce8d8
md"""
    for i = 1:5
        println(i)
    end

The "1:5" expression is a "range" operator. Its general form is "begin:step:end". There are various types of range operators depending on the type.

The above code can also be written as a one-liner using the "in" or "∈" (\in<tab>) operator to iterate through the list or vector.

    for i ∈ [1,2,3,4,5] println(i) end

Try either "for" loops.
"""

# ╔═╡ 87a56a3c-badf-452a-8218-62fc564533ab
for i ∈ [1,2,3,4,5] println(i) end

# ╔═╡ c0e03bd0-e754-4026-9bae-c9a7b0b5d022
md"""
The "break" and "continue" keywords are also available for unusual loop logic.

Nested loops are also possible.

    for i = 1:2, j = 3:4
        println((i, j))
        i = 0
    end

"zip" can be used to combine lists.

    for (j, k) in zip([1 2 3], [4 5 6 7])
        println((j,k))
    end

Try either one of these constructs.
"""

# ╔═╡ ab8994a0-dda6-494a-96d6-c6fb538c35f3
for (j, k) in zip([1 2 3], [4 5 6 7])
    println((j,k))
end

# ╔═╡ 1f04474e-d265-4b6b-939f-85d342dda804
md"""#### Exception handling

Julia contains a large number of built-in exceptions, e.g., ArgumentError and BoundsError.

Exceptions can be created with the "throw" keyword.

Try the following example.

    f(x) = x>=0 ? exp(-x) : throw(DomainError(x, "argument must be nonnegative"))

    f(1)

    f(-1)
"""

# ╔═╡ 94e7c927-5310-4a0d-a6ef-2e7fc86e797a
f(x) = x>=0 ? exp(-x) : throw(DomainError(x, "argument must be nonnegative"))

# ╔═╡ eb864a44-de90-4b06-a0a1-91dec2cd092c
f(-1)

# ╔═╡ b6a81092-639d-4cdf-a1dc-3a847b25b4ff
md"""

Exceptions can be checked for and handled using the "try-catch" block. The synatax `catch e`, where `e` is any variable, assigns the exception to `e`, which can then be used later.

    try
        sqrt("ten")
    catch e
        println("You should have entered a numeric value: e = ", e)
    end

A variation of the "try-catch" block is the "try-finally" block.

    f = open("file")
    try
        # operate on file f
    finally
        close(f)
    end
"""

# ╔═╡ e0fbcf4f-8b46-4d63-8469-61e427761c7f
md"""#### Coroutines

Coroutines or tasks are a control flow feature that allows computations to be suspended and resumed in a flexible manner. They allow asynchronous programming. That is all we will say about them at this point.

!!! note

    What have we learned about control flow?

    * Julia has the usal control features of conditional, short-circuit, and repeat evaluation.
    * Julia has compound expressions.
    * Julia has exception handling.
    * Julia has coroutines or tasks for asynchronous programming.

"""

# ╔═╡ 62edc512-89e6-4b29-b96e-f43b253654b9
md"""
**===================================================================================**

### Functions

In Julia, a function is an object that maps a tuple of argument values to a return value.

There are three syntaxes for defining a function. The first two are named functions and the third is an anonymous function. If the return value is the last statement, then the "return" keyword is optional.

Standard function definition:

    function myadd(x::Int, y::Int)
        x + y
    end

One-line function definition:

    myadd(x::Float64, y::Float64) = x + y

Anonymous function definition:

    x, y -> x + y

Anonymous functions are often used when a function argument expects a function, e.g., the filter method that expects a Boolean comparison function.

Let's define the above three functions.
"""

# ╔═╡ 771dee9c-1615-435a-884f-7d274172191c
function myadd(x::Int, y::Int)
    x + y
end

# ╔═╡ c0c8fde0-1526-4e8a-896a-67c226b0badf
myadd(x::Float64, y::Float64) = x + y

# ╔═╡ c3b1713c-1207-427f-bc2b-7ff973f5e35e
md"""Notice that the function "myadd" now has two methods; one for Ints and one for Float64s.

Try adding an Int and Float64 using the "myadd" function.
"""

# ╔═╡ cc19d021-1f25-4469-8239-9924cc01f883
md"""The compiler returns a MethodError because their is no method that adds a Int and Float64. We can fix this by defining a generic "myadd" function.
"""

# ╔═╡ e967114e-14ef-42e4-a1cd-dcfda5f19ca3
myadd(x, y) = x + y

# ╔═╡ c7b43469-232a-46a0-8bb6-c7a928e6d2f2
myadd(5, 6.0e32)

# ╔═╡ 02296dd4-ddca-4acb-929f-61ef5d9f755f
md"""
!!! note
    Now look at the result above of adding an Int and a Float64 using "myadd".

    In many cases, a function with generic arguments is sufficiently performant. But in those cases where extreme performance is needed, defining methods with specific argument types may be necessary.

!!! note
    One-line functions are usually inlined by the compiler. So, there is usually no performance penalty for using them. Multi-lined functions may also be inlined.
"""

# ╔═╡ 197727b0-f566-4953-94fd-9062f8d4e828
md"""#### Optional Arguments

Functions can often take sensible default values. Julia allows the default values to be defined in the function definition.

    optargs(y::Int, m::Int=1, d::Int=1) = "$y-$m-$d"

Define the above function and execute it with a variable number of arguments.

Note how many methods are created when the function is defined.
""" 

# ╔═╡ 5639ea0c-c911-4e17-892d-2baf3613c682
optargs(y::Int, m::Int=1, d::Int=1) = "$y-$m-$d"

# ╔═╡ c463427e-1584-4eb7-aefe-0eb24a9c01ba
optargs(1)

# ╔═╡ 3ddf7fd7-9ebd-4f63-a4ac-c6cea8973478
md"""#### Keyword Arguments

Some functions have a large number of arguments or a large number of behaviors. Remembering how to call such functions can be annoying. Keyword arguments can make these functions easier to use and extend by allowing arguments to be identified by name instead of only by position.

Keyword arguments are listed after the required and optional arguments. They are delimited by a semicolon in the argument list.

    kwfunc(arg1, arg2=1; kwd1="blue", kwd2="red")

!!! note
    Don't confuse keyword arguments and optional arguments. Optional arguments are positional arguments with default values. Keyword arguments are positionless arguments with default values.
"""

# ╔═╡ f997567b-b403-4e21-a87f-063b59dcc5a6
md"""#### Functors

Functors are anonymous functions that are defined only by their argument signature. They are synonymous with callable objects in Python.

    struct Polynomial{R}
        coeffs::Vector{R}
    end
    
    function (p::Polynomial)(x)
        v = p.coeffs[end]
        for i = (length(p.coeffs)-1):-1:1
           v = v*x + p.coeffs[i]
        end
        return v
    end

    p = Polynomial([1,10,100])

    p(5)

Define the Polynomial type and the functor by placing the struct and function in a begin-end block.
"""

# ╔═╡ 802d9fbf-8a1c-4bb3-aa2d-cd9bab659115
begin
struct Polynomial{R}
    coeffs::Vector{R}
end
function (p::Polynomial)(x)
    v = p.coeffs[end]
    for i = (length(p.coeffs)-1):-1:1
       v = v*x + p.coeffs[i]
    end
    return v
end	
end

# ╔═╡ 679a571e-d866-4005-a047-028c426fb167
md"""Create a polynomial"""

# ╔═╡ 1e8b04e8-ea02-41d1-94e1-42b02bbafdcc
p = Polynomial([1,10,100])


# ╔═╡ 3ffc37d1-8fd2-4436-bb8d-4bd82291c174
md"""Evaluate the polynomial"""

# ╔═╡ fad1263d-6a0a-435e-a6b5-2e2d394307be
p(5)

# ╔═╡ 7a35a96c-be9e-4e6e-ba70-7fb9b84a609f
md"""
!!! note
    What have we learned about functions?

    * Julia uses the argument signature, called multiple dispatch, to select the executable function.
    * Julia has two syntaxes for defining functions: one is for many-line functions and the other for one-line functions.
    * Julia has named functions and anonymous functions.
    * Julia function signatures have arguments and keywords. Arguments are required and listed first, but can have optional default values. Whereas, keywords are listed last and are optional.
    * Julia has anonymous functions called "functors" that are defined by their argument signature. 

"""

# ╔═╡ 49c7c3ff-ba42-4810-bb07-24ac948fb868
md"""
**===================================================================================**

### Macros

Macros provide a mechanism to include generated code in the final body of a program. A macro maps a tuple of arguments to a returned expression, and the resulting expression is compiled directly rather than requiring a runtime "eval" call. Macro arguments may include expressions, literal values, and symbols. They are very powerful.

A commonly used macro is `@.`. It ensures that all element-wise functions and operations are dotted.

Try executing this expression.

    begin
    v1, v2 = ones(10), ones(10)
    v1 * v2 + 2
    end
"""

# ╔═╡ 96cb643a-9b6f-4c5d-9b04-8e1661e6abc2
begin
v1, v2 = ones(10), ones(10)
v1 * v2 + 2
end

# ╔═╡ ba4caae5-7662-43d0-b762-abba4d2c660b
md"""Let's see what the `v1 * v2 + 2` expression expands to by using the `@macroexpand`.
"""

# ╔═╡ 2d558581-5ad2-41ae-a156-857d509cd103
@macroexpand v1 * v2 + 2

# ╔═╡ e68597bd-7156-4d39-bfdf-674748895603
md"""
The `*` operator is for matrix multiplication. So we meant the expression to be `v1 .* v2 .+ 2` for element-wise multiplication. So, we need to use the `.*` operator. `@.` macro will transform the expression into an element-wise expression. Let's use the `@macroexpand` macro to see how the expression is transformed.

    @macroexpand @. v1 * v2 + 2
"""

# ╔═╡ d8567b76-158f-4f05-9470-df1c7d1d1539
@macroexpand @. v1 * v2 + 2

# ╔═╡ 8ae6b532-fb38-4438-8d0e-af3e7e2c3d29
md"""Go back to the begin-end block and prefix the `v1 * v2 + 2` expression with the `@.` macro"""

# ╔═╡ 35d0d25b-ca36-4f57-b5c8-5cf011c58907
md"""
Macros are defined using the "macro-end" block. They are applied using the `@` prefix. Here is a simple example.

    macro sayhello(name)
        return :( println("Hello, ", $name) )
    end

Note the colon before the parethetical expression. It defines the expression as a symbol.

Define the macro now.
"""

# ╔═╡ e53f85aa-4af0-4dd8-bad4-f40bb428098e
macro sayhello(name)
    return :( println("Hello, ", $name) )
end

# ╔═╡ dac7eb38-e475-415c-b221-8abc3e9c7705
md"""
Apply the macro.

    @sayhello("human")
"""

# ╔═╡ ecc71674-d274-4dea-b20a-c7f51472c110
@sayhello("human")

# ╔═╡ 85c109b7-1683-4b70-94a3-bd611e76624a
md"""
!!! note
    What have we learned about macros?
    * macros generate precompiled code.
    * macros work at the Abstract Syntax Tree (AST) level of compiliation.
    * macros are convenient and powerful way to automate tedious coding tasks.
"""

# ╔═╡ 03daacaa-5cfe-4677-89ca-47925e6e6921
md"""
!!! tip

    You should become familar with macros, because you will see and use them often in Julia programming.  Here are some of the more useful macros:
    * `assert`: to throw an assertion when a condition is not met,
    * `code_llvm`: to see the actual intermediate LLVM code,
    * `inbounds`: to inform the compiler not to do bounds checking on arrays.
    * `inline`: to ensure an expression or function is inlined for performance,
    * `macroexpand`: to see the symbolic output of an expression,
    * `show`: for debugging,
    * `simd`: for fast explicit SIMD without compile time overhead when you know that you aren't aliasing
    * `threads`: for easy multi-threading.
    * `time`: to time functions and expressions,
"""

# ╔═╡ 33105044-e651-40a5-b928-592032c68e42
md"""
**===================================================================================**

## Multi-dimensional Arrays

The array library is implemented almost completely in Julia itself, and derives its performance from the compiler. All arguments to functions are passed by sharing (i.e. by pointers). By convention, a function name ending with a "!" indicates that it will mutate or destroy the value of one or more of its arguments (compare, for example, "sort" and "sort!").

Two characteristics of Julia arrays are:

* Column-major indexing
* One-based indexing

Both column-major indexing and one-base indexing follow the matrix convention of vectors being column arrays and the first index being 1. This is the same as FORTRAN and Matlab, and, of course, unlike Python.

!!! tip
    Just remember that the first index varies fastest.
"""

# ╔═╡ b3c2831f-1de1-47f4-ba4a-1cc30c30d510
md"""
**===================================================================================**

### Array Construction and Initialization

There several ways to create and initialize a new array:


    Array{T}(undef, dims...)    # an unitialized dense array

    ones(T, dims...)            # an array of zeros

where `T` signifies the array type, and `dims...` is a list of array dimensions.

    [1, 2, 3]                   # an array literal

    [2*i + j for i=1:3, j=4:6]  # array comprehension

    (2*i + j for i=1:3, j=4:6)  # generator expression

!!! note

    A generator expression doesn't create an array, it produces a value on demand.

Let's create some arrays. Create:

    zeros(Int8, 2, 3)

"""

# ╔═╡ 579259ef-3b67-4497-a8a3-5e6bed5b2ce0
zeros(Int8, 2, 3)

# ╔═╡ 76afc0a5-5da0-446d-afbd-1f202d84cf9a
md"""Create 

    zeros(Int8, (2,3))
"""

# ╔═╡ c92272d7-8729-468d-8bc5-f80f12a53856
zeros(Int8, (2,3))

# ╔═╡ e87c1b53-da8e-4747-92ea-b8299b9107b7
md"""

The array dimensons can be either a list or tuple.

Now create an array without the type argument.

    zeros((2, 3)

"""

# ╔═╡ 13e6db9b-8b75-4f30-b174-ce3623148169
zeros((2, 3))

# ╔═╡ cd46d32e-84e0-4d29-892f-b30db3fdcf8a
md"""The type defaults to Float64"""

# ╔═╡ d41bcf68-f472-48d0-ad82-1883f1d8d8ae
md"""#### Indexing

Indexes may be a scalar integer, an array of integers, or any other supported index. This includes Colon (:) to select all indices within the entire dimension, ranges of the form `begin:end` or `begin:step:end` to select contiguous or strided subsections, and arrays of booleans to select elements at their true indices. Slices in Julia are inclusive, meaning the beginning and ending indices are included in the slice.

`begin` and `end` can be used to indicate the first and last index of a slice. So, `end-1` is the penultimate index.

!!! note
    Julia allows the beginning and ending indices to be any value. That is they can be positive, negative, or zero. For example, the indices can `-3:3`. This feature requires the OffsetArrays package.

One supported index that is commonly used is the "CartesianIndex". It is an index that represents a single multi-dimensional index.

    A = reshape(1:32, 4, 4, 2)
    A[3, 2, 1]
    A[CartesianIndex(3, 2, 1)] == A[3, 2, 1] == 7

Try the above example.
"""

# ╔═╡ 8aa1bee5-c3f3-425c-8c33-5fed56866342
begin
AA = reshape(1:32, 4, 4, 2)
AA[3, 2, 1]
AA[CartesianIndex(3, 2, 1)] == AA[3, 2, 1] == 7
end

# ╔═╡ c76b138f-feb1-41af-9bb2-ad045a3675ac
md"""
An array of CartesionIndex is also supported. They help simply manipulating arrays. For example, it enables accessing the diagonal elements from the first "page" of A from above:

    page = A[:,:,1]

    page[CartesianIndex(1,1),
         CartesianIndex(2,2),
         CartesianIndex(3,3),
         CartesianIndex(4,4)]

Try it.
"""

# ╔═╡ d98ad311-6bf5-4f39-8e92-167fb4eea9a5


# ╔═╡ cc9eae6f-4cef-4160-9d1d-08f53e0681f6
md"""
This is expressed more simply using dot broadcasting and combining it with a normal integer index (instead of extracting the first page from A as a separate step).

    A[CartesianIndex.(axes(A, 1), axes(A, 2)), 1]

Try this too.
"""

# ╔═╡ 2793ca45-024c-4289-8075-c48c02acb971


# ╔═╡ 5bcef859-8d06-4225-9c8b-21e039b55d42
md"""
#### Iteration

The preferred way of iterating over an array is:

    for a in A
        # Do something with the element a
    end

    for i in eachindex(A)
        # Do something with i and/or A[i]
    end

The first example returns the value and the second returns the index. These methods work with both dense and sparse arrays.

#### Vectors and Matrices

A vector and matrix are just aliases for one and two dimensional arrays. To perform matrix multiplication, use the matrix multiply operator `*`. 

#### Sparse Vectors and Arrays

The standard library has a SparseArrays module. Sparse matrices are stored in the Compressed Sparse Column (CSC) format. The sparse vector format is simnilar.

Let's create a sparse array B.

    using SparseArrays
    B = sparse([1, 1, 2, 3, 4], [1, 3, 2, 3, 4], [0, 1, 2, 0, 4])

!!! note
    The identity matrix is a special instance of a sparse matrix. It does not require allocating memory. Instead, operations on the identity matrix are translated into code, resulting in significantly better performance.
"""

# ╔═╡ 48877cf7-5c91-4754-aef2-99c98d5c096a
B = sparse([1, 1, 2, 3, 4], [1, 3, 2, 3, 4], [0, 1, 2, 0, 4])

# ╔═╡ 536a75ee-bfdf-48a1-8f28-1f24bf615ae7
md"""
Now, let's do an elementwise multiplication of the two arrays.

    A .* B
"""

# ╔═╡ 835a5d2d-c0ad-4e23-95c3-b9850300fe19
AA .* B

# ╔═╡ 6870ed53-3488-40c5-9092-e1d708b37199
md"""
Notice how multiplying a dense and sparse array just works in Julia. That's composability.

!!! note
    What have we learned about multi-dimensional arrays?
    * Julia's arrays use column-major format and one-based indexing.
    * Julia's arrays have several indexing schemes that are concise and high performant.
    * Julia has sparse vectors and arrays.    
"""

# ╔═╡ 1c1013c8-9707-44f8-ab87-93df08019517
md"""
**===================================================================================**

## Plotting

There are several plotting packages for Julia. We will look at one package called Makie.

Makie is a data visualization ecosystem for the Julia programming language, with high performance and extensibility. It is available for Windows, Mac and Linux.

Makie has a number of different backends. `CairoMakie` makes static, publication quality plots and PDFs. `GLMakie` uses your GPU for 3D and interactive plots. There are also backends for embededing interactive plots on websites and for raytracing.

    using CairoMakie

!!! note
    `Makie` is a complex and feature rich plotting package. It therefore has many dependancies that take some time to compile, so be patient when installing it.

	You may consider trying this example at a later date.



"""

# ╔═╡ eafa144b-0899-4220-8adb-b6da5631e2c5
md"""
A simple scatter plot:

    xx = range(0, 10, length=100)
    yy = sin.(xx)
    scatter(ax, xx, yy)
"""

# ╔═╡ 21ef1eaa-a124-4db2-8f9b-319203f7895f


# ╔═╡ 25587198-a1c1-427d-b83e-f31339eeaf9d
md"""


For more complicated examples, you can create Figures and Axes step by step. `Makie` uses a constraint solver to create great multi-axis layouts.
Cut and paste the following code into the node.

	let
		fig = Figure(resolution=(800,600))
	
		# Create an axis in the first cell of the Figure
		ax1 = Axis(fig[1,1], title="Axis 1")
	
		# Put two plots into this axis
		scatterlines!(ax1, randn(40))
		scatterlines!(ax1, randn(40))
	
		# Add another axis to the right
		ax2 = Axis(fig[1,2], title="Axis 2")
		x = -10:10
		lines!(ax2, x, x.^2)
	
		# And one below
		x = y = -5:0.5:5
		z = x .^ 2 .+ y' .^ 2
		
		ax3 = Axis(fig[2, :], title="Axis 3")
		cont = contour!(ax3, x, y, z; linewidth = 4, levels = 12,
		    transparency = true, colormap=:greys)
	
		Colorbar(fig[1:2,3], cont, label="Colorbar 1")
	
		# And finally adjust the sizes of the rows
		colsize!(fig.layout, 1, 500)
		
		
		fig
	end

"""

# ╔═╡ 6c26406d-e540-4bea-851e-45d64c13ace8
md"""
`Makie` also supports rich 3D, interactive, and animated plots with thousands of points. Here is an example from the [Makie documentation](https://docs.makie.org/dev/):
"""

# ╔═╡ 6e8ae7c9-b3ad-4531-ab67-32320c9295e8
html"""
<details>
	<summary>Click to view</summary>
<video src="https://docs.makie.org/dev/assets/index/code/output/lorenz.mp4" autoplay repeat controls/>

</details>
"""

# ╔═╡ ee7c2384-b9a6-4986-9de6-b76e06790a83


# ╔═╡ 08d678e6-c2d3-4aac-b7e3-8edf23a0abeb
md"""
!!! note
    What have we learned about plotting?
    * Julia has several plotting packages with `Makie` having a wide range of features and high performance.
"""

# ╔═╡ e56c5a2a-f648-41ee-a7d8-b24a1ea1311e
md"""
!!! tip "Tips"
	* [*Beautiful Makie*](https://beautiful.makie.org/dev/#feature-examples) presents a wide range of example plots
	* The package [AlgebraOfGraphics.jl](https://aog.makie.org/dev/) provides an alternative, table-driven, and declarative syntax for plotting with Makie.

	* The upcoming version of Julia, 1.9, will load packages like Makie up to $30\times$ faster

	* RPRMakie provides provides raytracing support, to allow rendering beautiful 3D plots like the following	
"""

# ╔═╡ 4430854f-9038-4ef0-97e5-29181734b3f7
html"""
<img src="https://github.com/lazarusA/RPRMakieNotes/raw/main/imgs/rrg.png" width=400/>
"""

# ╔═╡ 815333e0-7caa-4c24-a2b2-3cc10547dbc2
md"""
**===================================================================================**

## Parallel Computing

Julia supports four categories of parallel computation:

* Asynchronous "tasks" or coroutines
* Multi-threading
* Distributed computing
* GPU computing
"""

# ╔═╡ dec1df08-233c-47e9-866f-242e1c4f7340
md"""### Coroutines

Coroutines or tasks allow suspending and resuming computations, such as I/O, event handling, and producer-consumer processes.

#### Tasks

Tasks can be created using the `Task` constructor or `@task` macro.

    t = @task begin; sleep(3); println("slept"); end
"""

# ╔═╡ ae70f4a9-6d8b-41d6-bf3a-50541c5e9535
md"""Tasks can be scheduled using the `schedule` function

    schedule(t)
"""

# ╔═╡ 4da667c8-8532-408b-b707-802daa9fbbb2
md"""The `wait` function blocks execution until another task finishes.

    schedule(t); wait(t)
"""

# ╔═╡ 430e628b-5437-48d8-a33f-1fbb1ce75da8
md"""#### Channels

Communication between tasks is done with channels.

Here is an example using `put!` and `take!`:

    function producer(c::Channel)
        put!(c, "start")
        for n=1:4
            put!(c, 2n)
        end
        put!(c, "stop")
    end

Enter it below using `begin` and `end` blocks.
"""

# ╔═╡ 2c0e6dfe-5131-493d-81cc-413c2aee9058


# ╔═╡ fd02f3fa-3cac-4d3a-99af-9c92f3cf16ff
md"""
    chnl = Channel(producer)
"""

# ╔═╡ 1eebcc9d-fa8d-45b4-8306-188055a1f17e


# ╔═╡ c45a306d-0c9e-4e5c-b527-a19d4711e4be
md"""    take!(chnl)"""

# ╔═╡ 7b975277-e278-475f-93d5-ae6e208c7f83


# ╔═╡ ef6903f1-b833-455d-839b-ec36581060e3
md"""Repeat the `take!` five more times"""

# ╔═╡ e6f96e30-968e-400d-9fdd-94b2c9f03d7b


# ╔═╡ 7eaefb5d-5088-4c01-8736-a56f48e30f9c
md"""Channels have additions features, but they won't be discussed here. See the Julia documentation for more discussion."""

# ╔═╡ b2253c15-4336-45c8-843c-73d1d927cb19
md"""### Multi-threading

One way to improve performance on multi-core CPUs, which are the norm these days, is to use multi-threading. The memory is shared among the threads. The ability to use multi-threading must be invoked at start-up by appending the `--threads` option to the `julia` command. The maximum number of threads depends on your computer. The `--threads` option can either take a number, say 8, or the `auto` value.

Let's check the maximum possibly number of threads. Enter the following:

    Threads.nthreads()`
"""

# ╔═╡ e936a7e8-61bb-4329-83a8-8838855443c0


# ╔═╡ d01eaa09-55e1-4fac-bba3-6d98294ddf0f
md"""
The `Threads.@threads` macro allows independant loops to be executed in parallel.

Let's try a simple example.

    a = zeros(Int, 10)
    Threads.@threads for i=1:10
        a[i] = Threads.threadid()
    end
    a
"""

# ╔═╡ 7652de2e-20d8-4aa7-9a04-5830dcdd0fc1


# ╔═╡ e72c2962-d70b-4163-8c3f-b8415a545c56
md"""
Note that the iterations are split among the threads.

The `@threads` macro also works for nested loops. Threads are a quick and easy way to get big performance improvements in your code. Once you have confirmed that a `for`-loop is correct, just prepend the `@threads` macro to the `for` statement and go.

The built-in `Threads` package provides more control over threading than shown in the above example. Check the Julia documentation for details. 
"""

# ╔═╡ 9fd7cf73-98e0-4b17-8900-6e1eae707b71
md"""### Distributed computing

Distributed computing runs multiple Julia processes with separate memory spaces. These can be on the same computer or separate computers. The `Distributed` standard library provides the capability for remote execution of a Julia function. Using `Distributed`, it is possible to implement various distributed computing schemes. An example is the `DistributedArrays` package to implement a *Global Array* interface. A `DArray` is distributed across a set of workers. Each worker can read and write from its local portion of the array and each worker has read-only access to the portions of the array held by other workers. On the other hand `MPI` and `Elemental` provide access to the existing MPI ecosystem of libraries.

Because distributed computing is more complex than multi-threading, it will not be discussed further in this tutorial. See the Julia documentation for details.
"""

# ╔═╡ c007871c-7979-4729-aab3-8a41812e1826
md"""
### GPU Computing

Julia has several packages and a software ecosystem for executing computations on GPUs. For NVIDIA GPUs, there is the well supported `CUDA` package; for Intel GPUs, the `OneAPI` package; and for AMD GPUs, the `AMDGPU` package. All of these packages allow Julia code to be run natively on the GPU.

The following code is an example of using the NVIDIA GPU to add two arrays using a GPU kernel `vadd`.

    using CUDA

    function vadd(a, b, c)
        i = (blockIdx().x-1i32) * blockDim().x + threadIdx().x
        c[i] = a[i] + b[i]
    end

    dims = (3, 4)
    a = round.(rand(Float32, dims) * 100)
    b = round.(radn(Float32, dims) * 100)
    c = similar(a)

    d_a = CuArray(a)
    d_b = CuArray(b)
    d_c = CuArray(c)

    len = prod(dims)
    @cuda threads=len vadd(d_a, d_b, d_c)
    c = Array(d_c)

The `@cuda` macro does all of the heavy lifting by generating and compiling the GPU code and then executing it. Note that there are two types of arrays, one for the CPU and the other for the GPU. `@cuda` will ensure that the CPU arrays are transfered to and from the GPU arrays for the computation.

For more details about computing with GPUs, see the JuliaGPU.org website.

GPU computing is another example of Julia solving the "two language problem". Although the `CUDA` package interfaces with the NVIDIA CUDA library written in C/C++, it allows the programmer to write dynamic programs in Julia and avoid using a second language.

!!! note
    What have we learned about parallel computing?
    * Julia allows asynchronous programming using coroutines or tasks.
    * Julia allows multi-threaded computation using the built-in `Threads` package.
    * Julia allows distributed computation using the `Distributed` and associated packages.
    * Julia allows GPU computation by translating Julia code into GPU instructions using various GPU packages.
"""

# ╔═╡ 9abd7c47-37c8-4d8d-bcc7-6ea1d3126969
md"""
**===================================================================================**

## Notable Packages

Here are a list of packages that the most Julia users should be aware of. The list is not exhaustive. However, it does give a feel for the breadth and depth of current Julia packages. 

**--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

### Packages All Julians Should Know About.

#### BenchmarkTools

BenchmarkTools makes performance tracking of Julia code easy by supplying a framework for writing and running groups of benchmarks as well as comparing benchmark results.

#### Cthulhu

Cthulhu can help you debug type inference issues by recursively showing the code_typed output until you find the exact point where inference gave up, messed up, or did something unexpected. Using the Cthulhu interface you can debug type inference problems faster.

#### Documenter

A package for building documentation from docstrings and markdown files.

#### JET

JET.jl employs Julia's type inference system to detect potential bugs.

#### LiveServer

LiveServer is a simple and lightweight development web-server written in Julia, based on HTTP.jl. It has live-reload capability, i.e. when changing files, every browser (tab) currently displaying a corresponding page is automatically refreshed.

#### MacroTools

MacroTools provides a library of tools for working with Julia code and expressions. This includes a powerful template-matching system and code-walking tools that let you do deep transformations of code in a few lines.

#### PackageTemplates

PkgTemplates is a Julia package for creating new Julia packages in an easy, repeatable, and customizable way.

#### Revise

Revise.jl may help you keep your Julia sessions running longer, reducing the need to restart when you make changes to code. With Revise, you can be in the middle of a session and then edit source code, update packages, switch git branches, and/or stash/unstash code; typically, the changes will be incorporated into the very next command you issue from the REPL. This can save you the overhead of restarting, loading packages, and waiting for code to JIT-compile.

#### TestItems

This package provides the @testitem macro for the test runner feature in VS Code.

#### TreeView

This is a small package to visualize a graph corresponding to an abstract syntax tree (AST) of a Julia expression. It uses the TikzGraphs.jl package to do the visualization.

"""

# ╔═╡ ca75d222-abb4-45e8-816f-39e0c448722b
md"""
**--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

### Packages for APIs

#### PyCall

This package provides the ability to directly call and fully interoperate with Python from the Julia language. You can import arbitrary Python modules from Julia, call Python functions (with automatic conversion of types between Julia and Python), define Python classes from Julia methods, and share large data structures between Julia and Python without copying them.

#### PythonCall & JuliaCall

Bringing Python® and Julia together in seamless harmony: (1) call Python code from Julia and Julia code from Python via a symmetric interface, (2) simple syntax, so the Python code looks like Python and the Julia code looks like Julia, (3) intuitive and flexible conversions between Julia and Python: anything can be converted, you are in control, (4) fast non-copying conversion of numeric arrays in either direction: modify Python arrays (e.g. bytes, array.array, numpy.ndarray) from Julia or Julia arrays from Python, (5) helpful wrappers: interpret Python sequences, dictionaries, arrays, dataframes and IO streams as their Julia counterparts, and vice versa, and
(6) beautiful stack-traces.

#### BinaryBuilder

The purpose of the BinaryBuilder.jl Julia package is to provide a system for compiling 3rd-party binary dependencies that should work anywhere the official Julia distribution does. In particular, using this package you will be able to compile your large pre-existing codebases of C, C++, Fortran, Rust, Go, etc... software into binaries that can be downloaded and loaded/run on a very wide range of machines. As it is difficult (and often expensive) to natively compile software packages across the growing number of platforms that this package will need to support, we focus on providing a set of Linux-hosted cross-compilers. This package will therefore set up an environment to perform cross-compilation for all of the major platforms, and will do its best to make the compilation process as painless as possible.

"""

# ╔═╡ 871ae10e-bc3f-49e3-bd30-1a875a1a41c2
md"""
**--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

### Packages for Performance

#### LoopVectorization

The loop vectorization macro can be prepended to a `for` loop or a broadcast statement to vectorize a loop. It can handle nested loops. It models the cost of evaluating the loop, and then unrolls either one or two loops.

!!! note
    The `@simd` macro provides a simpler, built-in implementation of loop vectorization, but only applies to the inner most loop.

#### Memoize and Memoization

Memoization is a simple trick in programming where you reduce the amount of computation required by remembering some intermittent results.

#### StaticArrays

StaticArrays provides a framework for implementing statically sized arrays in Julia, using the abstract type StaticArray{Size,T,N} <: AbstractArray{T,N}. Subtypes of StaticArray will provide fast implementations of common array and linear algebra operations. Note that here "statically sized" means that the size can be determined from the type, and "static" does not necessarily imply immutable.

"""

# ╔═╡ e40014d1-1ccc-445a-bba1-f6c37950ac81
md"""
**--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

### Packages for Mathematics and Science

#### Measurements

Measurements relieves you from the hassle of propagating uncertainties coming from physical measurements, when performing mathematical operations involving them. The linear error propagation theory is employed to propagate the errors.

#### Symbolics

Symbolics is a fast and modern Computer Algebra System (CAS) for a fast and modern programming language. The goal is to have a high-performance and parallelized symbolic algebra system that is directly extendable in the same language as the user's.

!!! note
    Symbolics is being developed for machine learning, primarily for auto-differention. It is about 100 times faster than SymPy.

#### Unitful

A Julia package for physical units.

"""

# ╔═╡ f09f3133-6613-4c86-99e4-535335a65192
md"""
**--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

### Packages for Astronomy

#### UnitfulAstro

UnitfulAstro is an extension of Unitful.jl to include units commonly encountered in astronomy.

#### NOVAS (Naval Observatory Vector Astrometry Software)

NOVAS is an integrated package of routines for computing various commonly needed quantities in positional astronomy.

"""

# ╔═╡ 609b8bdf-0ff4-4c9b-8934-983ebd1f9eea
md"""
**--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

### Machine Learning and Optimization

#### Flux

Flux is a 100% pure-Julia machine learning stack and provides lightweight abstractions on top of Julia's native GPU and AD support. It makes the easy things easy while remaining fully hackable.

#### JuMP

JuMP is a modeling language and collection of supporting packages for mathematical optimization in Julia. JuMP makes it easy to formulate and solve a range of problem classes, including linear programs, integer programs, conic programs, semidefinite programs, and constrained nonlinear programs.

#### Modeling Toolkit

ModelingToolkit is a modeling language for high-performance symbolic-numeric computation in scientific computing and scientific machine learning. It mixes ideas from symbolic computational algebra systems with causal and acausal equation-based modeling frameworks to give an extendable and parallel modeling system. It allows for users to give a high-level description of a model for symbolic preprocessing to analyze and enhance the model. Automatic transformations, such as index reduction, can be applied to the model before solving in order to make it easily handle equations would could not be solved when modeled without symbolic intervention.

#### Nonconvex

Nonconvex is an umbrella package over implementations and wrappers of a number of nonconvex constrained optimization algorithms and packages making use of automatic differentiation. Zero, first and second order methods are available. Nonlinear equality and inequality constraints as well as integer and nonlinear semidefinite constraints are supported.

"""

# ╔═╡ a1d42812-9cb1-440d-9efb-a4acf1376463
md"""
!!! note
    What have we learned about Julia packages?
    * Julia has a wide variety of packages for general, scientific, and high performance computing.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
CairoMakie = "~0.10.1"
Measurements = "~2.8.0"
Unitful = "~1.12.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "2c5e87162ce95df58e6850efc754c488415889d5"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractTrees]]
git-tree-sha1 = "52b3b436f8f73133d7bc3a6c71ee7ed6ab2ab754"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.3"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["Printf", "ScanByte", "TranscodingStreams"]
git-tree-sha1 = "d50976f217489ce799e366d9561d56a98a30d7fe"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "0.8.2"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "1dd4d9f5beebac0c03446918741b1a03dc5e5788"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.6"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.CairoMakie]]
deps = ["Base64", "Cairo", "Colors", "FFTW", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "SHA", "SnoopPrecompile"]
git-tree-sha1 = "439517f69683932a078b2976ca040e21dd18598c"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.10.1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "a7756d098cbabec6b3ac44f369f74915e8cfd70a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.79"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "90630efff0894f8142308e334473eba54c433549"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.5.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "9a0472ec2f5409db243160a8b030f94c380167a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "cabd77ab6a6fdff49bfd24af2ebe76e6e018a2b4"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.0.0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "38a92e40157100e796690421e34a11c107205c86"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "fb28b5dc239d0174d7297310ef7b84a11804dfab"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.0.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "fe9aea4ed3ec6afdfbeb5a4f39a2208909b162a6"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.5"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Observables"]
git-tree-sha1 = "678d136003ed5bceaab05cf64519e3f956ffa4ba"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.9.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "16c0cc91853084cb5f58a78bd209513900206ce6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "9816b296736292a80b9a3200eb7fbb57aaa3917a"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.5"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "946607f84feb96220f480e0422d3484c49c00239"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.19"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Makie]]
deps = ["Animations", "Base64", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG", "FileIO", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MakieCore", "Markdown", "Match", "MathTeXEngine", "MiniQhull", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "Printf", "Random", "RelocatableFolders", "Setfield", "Showoff", "SignedDistanceFields", "SnoopPrecompile", "SparseArrays", "StableHashTraits", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "20f42c8f4d70a795cb7927d7312b98a255209155"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.19.1"

[[deps.MakieCore]]
deps = ["Observables"]
git-tree-sha1 = "c5b3ce048ee73a08bbca1b9f4a776e64257611d5"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.6.1"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Match]]
git-tree-sha1 = "1d9bc5c1a6e7ee24effb93f175c9342f9154d97f"
uuid = "7eb4fadd-790c-5f42-8a69-bfa0b872bfbf"
version = "1.2.0"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "Test", "UnicodeFun"]
git-tree-sha1 = "f04120d9adf4f49be242db0b905bea0be32198d1"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.5.4"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measurements]]
deps = ["Calculus", "LinearAlgebra", "Printf", "RecipesBase", "Requires"]
git-tree-sha1 = "12950d646ce04fb2e89ba5bd890205882c3592d7"
uuid = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
version = "2.8.0"

[[deps.MiniQhull]]
deps = ["QhullMiniWrapper_jll"]
git-tree-sha1 = "9dc837d180ee49eeb7c8b77bb1c860452634b0d1"
uuid = "978d7f02-9e05-4691-894f-ae31a51d76ca"
version = "0.4.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "5ae7ca23e13855b3aba94550f26146c01d259267"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "f71d8950b724e9ff6110fc948dff5a329f901d64"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "f809158b27eba0c18c269cf2a2be6ed751d3e81d"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.17"

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "ec3edfe723df33528e085e632414499f26650501"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.5.0"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f6cf8e7944e50901594838951729a1861e668cb8"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.2"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "5b7690dd212e026bbab1860016a6601cb077ab66"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.2"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QhullMiniWrapper_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Qhull_jll"]
git-tree-sha1 = "607cf73c03f8a9f83b36db0b86a3a9c14179621f"
uuid = "460c41e3-6112-5d7f-b78c-b6823adb3f2d"
version = "1.0.0+1"

[[deps.Qhull_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "238dd7e2cc577281976b9681702174850f8d4cbc"
uuid = "784f63db-0788-585a-bace-daefebcd302b"
version = "8.0.1001+0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "97aa253e65b784fd13e83774cadc95b38011d734"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.6.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "18c35ed630d7229c5584b945641a73ca83fb5213"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "34edfe91375e5883875987e740c554b92c48fc41"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.4.3"

[[deps.ScanByte]]
deps = ["Libdl", "SIMD"]
git-tree-sha1 = "2436b15f376005e8790e318329560dcc67188e84"
uuid = "7b38b023-a4d7-4c5e-8d43-3f3097f304eb"
version = "0.3.3"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StableHashTraits]]
deps = ["CRC32c", "Compat", "Dates", "SHA", "Tables", "TupleTools", "UUIDs"]
git-tree-sha1 = "0b8b801b8f03a329a4e86b44c5e8a7d7f4fe10a3"
uuid = "c5dd0088-6c3f-4803-b00e-f31a60c170fa"
version = "0.3.1"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "6954a456979f23d05085727adb17c4551c19ecd1"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.12"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "ab6083f09b3e617e34a956b43e9d51b824206932"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.1.1"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "b03a3b745aa49b566f128977a7dd1be8711c5e71"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.14"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "7e6b0e3e571be0b4dd4d2a9a3a83b65c04351ccc"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.3"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "e4bdc63f5c6d62e80eb1c0043fcc0360d5950ff7"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.10"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.TupleTools]]
git-tree-sha1 = "3c712976c47707ff893cf6ba4354aa14db1d8938"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d670a70dd3cdbe1c1186f2f17c9a68a7ec24838c"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.12.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
"""

# ╔═╡ Cell order:
# ╟─d1366a55-b4fc-4ddb-b5c2-5f3381c48b49
# ╟─09193424-25b9-45ce-840f-f24bbcc46c9d
# ╟─b1ed2c4e-f5fa-4e5e-87d8-7af6f80a83ca
# ╟─7f3357bc-4103-4a35-af21-9c86f5a0ec2f
# ╟─7475c896-d1b1-4429-9ba8-8e78de41e0b0
# ╟─5df8264e-6e37-4674-abdf-2b05c530787f
# ╟─f646ca14-c01e-47ee-8e2b-052d9db0985b
# ╠═4a404280-2845-4deb-8eee-2dcdcb9aed27
# ╟─7813824a-cae9-4b97-ac90-e542fbd630d5
# ╠═6ac51e87-87a2-4ccc-9f08-0028700b3cda
# ╟─27208179-35c3-43c1-9548-3620c8aa7680
# ╠═40d8d18c-3713-4e77-812d-9d77a4e1ac50
# ╟─aa3e9db7-49d1-40f8-b745-6c4faa2197e1
# ╠═97b8b163-aef4-4dda-8079-2338d86c3d7a
# ╟─419a6dec-1db0-477f-911f-049223b5674f
# ╠═98340265-f51e-47a0-95d2-df179b87f54b
# ╟─8ee7f43d-bf75-4975-ac64-54c2d5a0174a
# ╠═d4368e22-60c6-456a-94a5-56e6dfdb26d7
# ╟─d1e9c51c-efb9-4dcb-9d28-8c54a235fbb4
# ╟─b27578b2-f5f5-4e46-82e6-0007be187ba6
# ╠═1a95f9e5-77a3-46d0-9d4d-b28fbb0abf26
# ╟─065265a5-c9ad-4a39-b14d-f4e2e49d3f7a
# ╠═8f016c75-7768-4418-8c57-100db3073c85
# ╠═84d272eb-115d-4d4e-8a54-7e204facf8e3
# ╟─094b6f30-cbd6-46b1-8e0c-3fdb1ef18261
# ╠═7ba8dc19-e0ca-40de-a778-7583ca70978d
# ╟─668abc35-fdc3-430f-8c90-de3c2c2cd77b
# ╠═232cc444-03b7-442a-8737-8b7725b43421
# ╟─d2a2d0bc-e883-439f-8e34-166e2369caef
# ╠═88ca2a73-6203-447c-afcc-9e370a82076b
# ╟─c24f1ddd-5e31-4073-a627-86cedb1d44c2
# ╠═26f1a52e-8cf9-4495-8922-61b5fbfd594d
# ╠═63a4b27a-5361-4d95-8787-ae31ca7987fe
# ╠═784afc89-ddd9-4461-bd4c-4f9c0197e11d
# ╟─cf4a0e8f-9210-4f1e-84d4-ee7ff09aaf61
# ╠═fdba7211-e480-4948-8435-76a7608e7e63
# ╠═e00b826d-1bbb-4413-a907-eb181369526b
# ╟─b56255c6-9d3b-4e2f-a9a0-c6fe69990f3d
# ╟─5cd072cb-5d71-4a08-8e41-4eaaa7faaa5c
# ╟─f37bc13e-fa91-4166-983b-fd13a8493435
# ╟─0d0c11c0-d39f-462c-9fb6-ab90ca98d230
# ╟─a02bbbbb-6b3f-47ef-a11f-1db9b802db6f
# ╠═2262c860-c06c-4293-8e6d-b616228cb301
# ╠═68e64f74-8a6b-403e-a404-52fb9cdea54b
# ╟─0887eca0-6760-4d9b-b44e-d1a14059aede
# ╟─0ad9aa76-f6c7-4368-8ae4-58daa548e065
# ╠═1bc3da9e-143c-489c-b8de-a29dc48f17cb
# ╟─f00dd72a-8705-426b-9eb4-b91cf1ea95d4
# ╠═d308df6b-14ec-49ec-8270-a3b9efd88517
# ╠═01805f02-f9f6-4e3e-8e93-a0628753130f
# ╟─a90b9011-714e-41d1-b7a3-fb3eb9dc56da
# ╠═b8325403-9744-4a9d-ae64-be88671da89b
# ╠═4879dae5-442e-4dc6-90c9-366ff76912bb
# ╟─4c278c5a-3324-4245-8ddf-f5390167168f
# ╟─3772a828-561d-4600-8e67-49a28cc6cf09
# ╠═aa4a7ec0-a270-482b-abeb-7168de767938
# ╟─b8e3b72a-e501-4164-b06c-cbb3282d9d11
# ╠═d9aa9f5e-31b6-49a3-bae8-a9b149e6ab91
# ╟─15b0159b-9c8c-4327-b73d-d7e19decde2a
# ╠═5d5b1283-043b-437a-afda-75801808acc9
# ╟─6a6b2a0a-6bb6-4a67-b4c1-46631503918d
# ╟─877faa74-7490-44a3-9e97-b36b36050796
# ╠═bba18435-d355-4fca-a6f5-10dacde17413
# ╟─d9e911a8-13f9-41e5-ac36-4aee3ec24c59
# ╠═5f72777b-a174-453c-8b18-ebf1f4bebe0d
# ╠═734a4185-4001-410f-affc-71b33e339339
# ╟─c349f7b8-bdf0-4b94-b412-06c5e7f3cbc5
# ╠═d8be9383-fb60-4938-9376-f91d59f21559
# ╟─31dfb05b-ed87-48f9-a74c-0055e46de160
# ╠═d2ada743-b82d-47c8-9b1d-4bd56de76e62
# ╟─ea15815e-0ae3-4f22-9dce-a17cb3a0560b
# ╠═be09f5d0-daea-4f47-8dc8-33c875fca843
# ╠═10ec3b0d-1add-4f92-8f4c-b594ab3f0e68
# ╟─6ee4665d-c5b9-4881-ad65-15c6a8229f3f
# ╠═f5596a05-04de-4955-9575-4c035e0f1495
# ╠═a1b4f7bb-8238-40d6-81cb-6d5e6c737134
# ╟─3b8e773f-df6e-4b59-9f5d-e14366d02754
# ╠═91f35db2-6a17-42aa-8580-1dea220b8c11
# ╟─a631464d-e08a-4a89-8c47-fd5a7b2dee16
# ╠═7a8faa02-34b1-4416-beab-2909fb56c767
# ╠═6e1a3b46-05f0-487d-933a-6ff0d9d43a2b
# ╟─05adfd23-c809-4706-9bf2-1a0a2445748b
# ╠═67a4ff9f-c75f-444c-9091-e9b5c17ee773
# ╟─67ad1d30-498e-414a-83d5-12e020c92741
# ╠═cfd93268-174f-4a7e-9f98-3d5787c9392c
# ╟─73be3ec3-2668-44a0-bed9-242796bf5f08
# ╠═a96dd069-09aa-4add-baba-99ffae36bfe8
# ╟─8a3aa0d3-1ade-4961-975d-b39899731ffe
# ╟─f6c44dbf-2801-4523-b6cc-2632b9e87fb8
# ╠═d4c1a6b5-41e0-4f00-9240-ae68bfd30407
# ╟─94b60423-b3ac-44aa-8b0b-f00cd42f407a
# ╟─eda84481-7f84-4598-931f-f4021f135407
# ╠═5d6b5ec7-7502-4eaa-978d-b2e86d7967dc
# ╟─f27186dd-6ca3-410f-9926-fd51222cf077
# ╠═ff568320-e769-4148-b2cc-083e484596e5
# ╟─5db58df9-10dc-48ba-a156-57cb1c3afef5
# ╟─3e08e0ce-cf9f-4705-91f1-9314c2d3b34b
# ╠═8f145da3-435c-4a15-bf56-45692e969a70
# ╟─9bb10bc2-9eb1-4db1-b951-4d7e57fce8d8
# ╠═87a56a3c-badf-452a-8218-62fc564533ab
# ╟─c0e03bd0-e754-4026-9bae-c9a7b0b5d022
# ╠═ab8994a0-dda6-494a-96d6-c6fb538c35f3
# ╟─1f04474e-d265-4b6b-939f-85d342dda804
# ╠═94e7c927-5310-4a0d-a6ef-2e7fc86e797a
# ╠═eb864a44-de90-4b06-a0a1-91dec2cd092c
# ╟─b6a81092-639d-4cdf-a1dc-3a847b25b4ff
# ╟─e0fbcf4f-8b46-4d63-8469-61e427761c7f
# ╟─62edc512-89e6-4b29-b96e-f43b253654b9
# ╠═771dee9c-1615-435a-884f-7d274172191c
# ╠═c0c8fde0-1526-4e8a-896a-67c226b0badf
# ╟─c3b1713c-1207-427f-bc2b-7ff973f5e35e
# ╠═c7b43469-232a-46a0-8bb6-c7a928e6d2f2
# ╟─cc19d021-1f25-4469-8239-9924cc01f883
# ╠═e967114e-14ef-42e4-a1cd-dcfda5f19ca3
# ╟─02296dd4-ddca-4acb-929f-61ef5d9f755f
# ╟─197727b0-f566-4953-94fd-9062f8d4e828
# ╠═5639ea0c-c911-4e17-892d-2baf3613c682
# ╠═c463427e-1584-4eb7-aefe-0eb24a9c01ba
# ╟─3ddf7fd7-9ebd-4f63-a4ac-c6cea8973478
# ╟─f997567b-b403-4e21-a87f-063b59dcc5a6
# ╠═802d9fbf-8a1c-4bb3-aa2d-cd9bab659115
# ╟─679a571e-d866-4005-a047-028c426fb167
# ╠═1e8b04e8-ea02-41d1-94e1-42b02bbafdcc
# ╟─3ffc37d1-8fd2-4436-bb8d-4bd82291c174
# ╠═fad1263d-6a0a-435e-a6b5-2e2d394307be
# ╟─7a35a96c-be9e-4e6e-ba70-7fb9b84a609f
# ╟─49c7c3ff-ba42-4810-bb07-24ac948fb868
# ╠═96cb643a-9b6f-4c5d-9b04-8e1661e6abc2
# ╟─ba4caae5-7662-43d0-b762-abba4d2c660b
# ╠═2d558581-5ad2-41ae-a156-857d509cd103
# ╟─e68597bd-7156-4d39-bfdf-674748895603
# ╠═d8567b76-158f-4f05-9470-df1c7d1d1539
# ╟─8ae6b532-fb38-4438-8d0e-af3e7e2c3d29
# ╟─35d0d25b-ca36-4f57-b5c8-5cf011c58907
# ╠═e53f85aa-4af0-4dd8-bad4-f40bb428098e
# ╟─dac7eb38-e475-415c-b221-8abc3e9c7705
# ╠═ecc71674-d274-4dea-b20a-c7f51472c110
# ╟─85c109b7-1683-4b70-94a3-bd611e76624a
# ╟─03daacaa-5cfe-4677-89ca-47925e6e6921
# ╟─33105044-e651-40a5-b928-592032c68e42
# ╟─b3c2831f-1de1-47f4-ba4a-1cc30c30d510
# ╠═579259ef-3b67-4497-a8a3-5e6bed5b2ce0
# ╟─76afc0a5-5da0-446d-afbd-1f202d84cf9a
# ╠═c92272d7-8729-468d-8bc5-f80f12a53856
# ╟─e87c1b53-da8e-4747-92ea-b8299b9107b7
# ╠═13e6db9b-8b75-4f30-b174-ce3623148169
# ╟─cd46d32e-84e0-4d29-892f-b30db3fdcf8a
# ╟─d41bcf68-f472-48d0-ad82-1883f1d8d8ae
# ╠═8aa1bee5-c3f3-425c-8c33-5fed56866342
# ╟─c76b138f-feb1-41af-9bb2-ad045a3675ac
# ╠═d98ad311-6bf5-4f39-8e92-167fb4eea9a5
# ╟─cc9eae6f-4cef-4160-9d1d-08f53e0681f6
# ╠═2793ca45-024c-4289-8075-c48c02acb971
# ╟─5bcef859-8d06-4225-9c8b-21e039b55d42
# ╠═7ca0c1a6-2d3a-4ff3-80aa-a4e39b12828b
# ╠═48877cf7-5c91-4754-aef2-99c98d5c096a
# ╟─536a75ee-bfdf-48a1-8f28-1f24bf615ae7
# ╠═835a5d2d-c0ad-4e23-95c3-b9850300fe19
# ╟─6870ed53-3488-40c5-9092-e1d708b37199
# ╟─1c1013c8-9707-44f8-ab87-93df08019517
# ╠═1840579b-5067-45e1-ad3e-cae8775f0ce9
# ╟─eafa144b-0899-4220-8adb-b6da5631e2c5
# ╠═21ef1eaa-a124-4db2-8f9b-319203f7895f
# ╟─25587198-a1c1-427d-b83e-f31339eeaf9d
# ╟─6c26406d-e540-4bea-851e-45d64c13ace8
# ╟─6e8ae7c9-b3ad-4531-ab67-32320c9295e8
# ╠═ee7c2384-b9a6-4986-9de6-b76e06790a83
# ╟─08d678e6-c2d3-4aac-b7e3-8edf23a0abeb
# ╟─e56c5a2a-f648-41ee-a7d8-b24a1ea1311e
# ╟─4430854f-9038-4ef0-97e5-29181734b3f7
# ╟─815333e0-7caa-4c24-a2b2-3cc10547dbc2
# ╟─dec1df08-233c-47e9-866f-242e1c4f7340
# ╟─ae70f4a9-6d8b-41d6-bf3a-50541c5e9535
# ╟─4da667c8-8532-408b-b707-802daa9fbbb2
# ╟─430e628b-5437-48d8-a33f-1fbb1ce75da8
# ╠═2c0e6dfe-5131-493d-81cc-413c2aee9058
# ╟─fd02f3fa-3cac-4d3a-99af-9c92f3cf16ff
# ╠═1eebcc9d-fa8d-45b4-8306-188055a1f17e
# ╟─c45a306d-0c9e-4e5c-b527-a19d4711e4be
# ╠═7b975277-e278-475f-93d5-ae6e208c7f83
# ╟─ef6903f1-b833-455d-839b-ec36581060e3
# ╠═e6f96e30-968e-400d-9fdd-94b2c9f03d7b
# ╟─7eaefb5d-5088-4c01-8736-a56f48e30f9c
# ╟─b2253c15-4336-45c8-843c-73d1d927cb19
# ╠═e936a7e8-61bb-4329-83a8-8838855443c0
# ╟─d01eaa09-55e1-4fac-bba3-6d98294ddf0f
# ╠═7652de2e-20d8-4aa7-9a04-5830dcdd0fc1
# ╟─e72c2962-d70b-4163-8c3f-b8415a545c56
# ╟─9fd7cf73-98e0-4b17-8900-6e1eae707b71
# ╟─c007871c-7979-4729-aab3-8a41812e1826
# ╟─9abd7c47-37c8-4d8d-bcc7-6ea1d3126969
# ╟─ca75d222-abb4-45e8-816f-39e0c448722b
# ╟─871ae10e-bc3f-49e3-bd30-1a875a1a41c2
# ╟─e40014d1-1ccc-445a-bba1-f6c37950ac81
# ╟─f09f3133-6613-4c86-99e4-535335a65192
# ╟─609b8bdf-0ff4-4c9b-8934-983ebd1f9eea
# ╟─a1d42812-9cb1-440d-9efb-a4acf1376463
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
