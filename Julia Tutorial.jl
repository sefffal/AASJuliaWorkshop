### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 8f016c75-7768-4418-8c57-100db3073c85
using Measurements

# ╔═╡ 88ca2a73-6203-447c-afcc-9e370a82076b
using Unitful

# ╔═╡ 7ca0c1a6-2d3a-4ff3-80aa-a4e39b12828b
using SparseArrays

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

    using GLMakie

!!! note
    `GLMakie` is a complex and feature rich plotting package. It therefore has many dependancies that take some time to compile, so be patient when installing it.
"""

# ╔═╡ 1840579b-5067-45e1-ad3e-cae8775f0ce9


# ╔═╡ eafa144b-0899-4220-8adb-b6da5631e2c5
md"""
A simple scatter plot.

    begin
    f = Figure()
    ax = Axis(f[1, 1])
    xx = range(0, 10, length=100)
    yy = sin.(xx)
    scatter!(ax, xx, yy)
    f
    end
"""

# ╔═╡ 9f914b0b-e5e3-4dce-ae4b-6bebab60bd20


# ╔═╡ 25587198-a1c1-427d-b83e-f31339eeaf9d
md"""

Here is a rather complex example that shows the features and performanc of Makie.

Cut and paste the following code into the node.

    begin
    Base.@kwdef mutable struct Lorenz
        dt::Float64 = 0.01
        σ::Float64 = 10
        ρ::Float64 = 28
        β::Float64 = 8/3
        x::Float64 = 1
        y::Float64 = 1
        z::Float64 = 1
    end
    
    function step!(l::Lorenz)
        dx = l.σ * (l.y - l.x)
        dy = l.x * (l.ρ - l.z) - l.y
        dz = l.x * l.y - l.β * l.z
        l.x += l.dt * dx
        l.y += l.dt * dy
        l.z += l.dt * dz
        Point3f(l.x, l.y, l.z)
    end
    
    attractor = Lorenz()
    
    points = Observable(Point3f[])
    colors = Observable(Int[])
    
    set_theme!(theme_black())
    
    fig, bx, l = lines(points, color = colors,
        colormap = :inferno, transparency = true,
        axis = (; type = Axis3, protrusions = (0, 0, 0, 0),
            viewmode = :fit, limits = (-30, 30, -30, 30, 0, 50)))

    record(fig, "lorenz.mp4", 1:120) do frame
        for i in 1:50
            push!(points[], step!(attractor))
            push!(colors[], frame)
        end
        bx.azimuth[] = 1.7pi + 0.3 * sin(2pi * frame / 120)
        notify.((points, colors))
        l.colorrange = (0, frame)
    end
    fig
    end
"""

# ╔═╡ 6c26406d-e540-4bea-851e-45d64c13ace8


# ╔═╡ 08d678e6-c2d3-4aac-b7e3-8edf23a0abeb
md"""
!!! note
    What have we learned about plotting?
    * Julia has several plotting packages with `Makie` having a wide range of features and high performance.
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
# ╠═9f914b0b-e5e3-4dce-ae4b-6bebab60bd20
# ╟─25587198-a1c1-427d-b83e-f31339eeaf9d
# ╠═6c26406d-e540-4bea-851e-45d64c13ace8
# ╟─08d678e6-c2d3-4aac-b7e3-8edf23a0abeb
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
