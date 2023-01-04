### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ 5d8d2585-5c04-4f33-b547-8f44b3336f96
using PlutoUI

# ╔═╡ f3d6edf3-f898-4772-80b7-f2aeb0f69216
using BenchmarkTools

# ╔═╡ cab50215-8895-4789-997f-589f017b2b84
using PyCall

# ╔═╡ c3bc0c44-b2e9-4e6a-862f-8ab5092459ea
using LinearAlgebra

# ╔═╡ b83ba8db-b9b3-4921-8a93-cf0733cec7aa
using CUDA

# ╔═╡ 5dbe9644-eb50-4204-b8c6-a1aac5fe3736
PlutoUI.TableOfContents()

# ╔═╡ a2680f00-7c9a-11ed-2dfe-d9cd445f2e57
md"""
# Optimization of Algorithms

Julia is a high-performance language. However, like any computer language, certain constructs are faster and will better take advantage of your computer's resources. This tutorial will overview how you can use Julia and some of its unique features to enable blazing-fast performance.

However, to achieve good performance, there are a couple of things to keep in mind.

## Global Variables and Type Instabilities

First global variables in Julia are almost always a bad idea. First, from a coding standpoint, they are very hard to reason about since they could change at any moment. However, for Julia, they are also a performance bottleneck. Let's consider a simple function that updates a global array to demonstrate the issue of global arrays.

```julia
begin
	gl = rand(1000)

	function global_update()
		for i in eachindex(gl)
			gl[i] += 1
		end
	end
end
```
"""

# ╔═╡ b90d6694-b170-4646-b5a0-e477d4fe6f50


# ╔═╡ 5ed407ea-4bba-4eaf-b47a-9ae95b28abba
md"""
Now let's check the performance of this function. To do this, we will use the excellent benchmarking package [`BenchmarTools.jl`](https://github.com/JuliaCI/BenchmarkTools.jl) and the macro `@benchmark`, which runs the function multiple times and outputs a histogram of the time it took to execute the function

```julia
@benchmark global_update()

BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):   96.743 μs …   8.838 ms  ┊ GC (min … max): 0.00% … 97.79%
 Time  (median):     105.987 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   123.252 μs ± 227.353 μs  ┊ GC (mean ± σ):  5.14% ±  2.76%

  ▄█▇█▇▅▄▃▄▅▃▂▃▅▆▅▅▄▃▃▂▂▂ ▁▁▁          ▁  ▁                     ▂
  ████████████████████████████▇██▇▇██▇███████▇▇█▇▇█▇▇▇▇▆▇▇▆▆▅▆▅ █
  96.7 μs       Histogram: log(frequency) by time        211 μs <

 Memory estimate: 77.77 KiB, allocs estimate: 3978.
```
** Note this was run on a Intel Core i7 i7-1185G7 processors so your benchmarks may differ **
"""

# ╔═╡ 76e3f9c8-4c39-4e7b-835b-2ba67435666a
md"""
**Try this benchmark below**
"""

# ╔═╡ 530368ec-ec33-4204-ac44-9dbabaca0dc4


# ╔═╡ 2310c578-95d8-4af0-a572-d7596750dfcc
md"""
Looking at the histogram, we see that the minimum time is 122 μs to update a vector! We can get an idea of why this is happening by looking at the total number of allocations we made while updating the vector. Since we are updating the array in place, there should be no allocations. 

To see what is happening here, Julia provides several code introspection tools.
Here we will use `@code_warntype`
```julia
@code_warntype global_update()
```
"""

# ╔═╡ 50b5500e-5ca8-4432-a5ac-01193a808232


# ╔═╡ 36a9656e-d09c-46b0-8dc4-b9a4de0ba3a8
md"""
which should give the following output


```julia
MethodInstance for Main.var"workspace#12".global_update()
  from global_update() in Main.var"workspace#12"
Arguments
  #self#::Core.Const(Main.var"workspace#12".global_update)
Locals
  @_2::Any
  i::Any
Body::Nothing
1 ─ %1  = Main.var"workspace#12".eachindex(Main.var"workspace#12".gl)::Any
│         (@_2 = Base.iterate(%1))
│   %3  = (@_2 === nothing)::Bool
│   %4  = Base.not_int(%3)::Bool
└──       goto #4 if not %4
2 ┄ %6  = @_2::Any
│         (i = Core.getfield(%6, 1))
│   %8  = Core.getfield(%6, 2)::Any
│   %9  = Base.getindex(Main.var"workspace#12".gl, i)::Any
│   %10 = (%9 + 1)::Any
│         Base.setindex!(Main.var"workspace#12".gl, %10, i)
│         (@_2 = Base.iterate(%1, %8))
│   %13 = (@_2 === nothing)::Bool
│   %14 = Base.not_int(%13)::Bool
└──       goto #4 if not %14
3 ─       goto #2
4 ┄       return nothing
```
"""

# ╔═╡ 8bc401d6-35f0-4722-8ac5-71ca34597b5f
md"""
`@code_warntype` tells us where the Julia compiler could not infer the variable type. If this happens, Julia cannot efficiently compile the function, and we end up with performance comparable to Python. The above example highlights the type instabilities in red and denotes accessing the global variable `gl`. These globals are a problem for Julia because their type could change anytime. As a result, Julia defaults to leaving the type to be the `Any` type.

Typically the standard way to fix this issue is to pass the offending variable as an argument to the function.

```julia
function better_update!(x)
	for i in eachindex(x)
		x[i] += 1
	end
end
```
"""

# ╔═╡ db9108c9-642f-4cb0-b1ba-08a76b505d2e


# ╔═╡ 29d231cf-131a-4907-aaf3-8ed4d8c1f181
md"""
Benchmarking this now

```julia
@benchmark better_update!(gl)
```
"""

# ╔═╡ d228e0f2-63f1-47aa-a0f2-ec4ede84fb3b


# ╔═╡ 934552be-59f8-4af4-86ad-711328035876
md"""
By passing the array as a function argument, Julia can infer the type and compile an efficient version of the function, achieving a 1000x speedup on my machine (Ryzen 7950x).

```julia
@code_warntype better_update!(gl)
```
"""

# ╔═╡ d5d35977-e8ef-4fd6-9573-5402616407d6


# ╔═╡ 1f3bfcc0-25f5-4c42-a989-0f3eb344eca8
md"""
we see that the red font is gone. This is a general thing to keep in mind when using Julia. Try not to use the global scope in performance-critical parts. Instead, place the computation inside a function.
"""

# ╔═╡ b89b329e-0dd1-4b0b-82a1-19d104dcf430
md"""
## Types

Julia is a typed but dynamic language. The use of types is part of the reason that Julia can produce fast code. If Julia can infer the types inside the body of a function, it will compile efficient machine code. However, if this is not the case, the function will become **type unstable**. We saw this above with our global example, but these type instabilities can also occur in other seemingly simple functions.

For example let's start with a simple sum
```julia
function my_sum(x)
	s = 0
	for xi in x
		s += xi
	end
	return
end
```

"""

# ╔═╡ 4f17c95e-8e0f-414d-ab62-413d7a848221


# ╔═╡ 946d91d1-7c37-4c35-b967-8b98856fb431
md"""
Analyzing this with `@code_warntype` shows a small type instability.

```julia
@code_warntype my_sum(gl)
```

!!! tip
	Remember to look for red-highlighted characters
"""

# ╔═╡ b050c5a4-3034-4a14-ae3a-b6eac433f275


# ╔═╡ 30e2be6c-f990-467a-85f9-a37f84f145ea
md"""
In this case, we see that Julia inserted a type instabilities since it could not determine the specific type of `s`. This is because when we initialized `s`, we used the value `0` which is an integer. Therefore, when we added xi to it, Julia determined that the type of `s` could either be an `Int` or `Float`. 

!!! note
	In Julia 1.8, the compiler is actually able to do something called [`union splitting`](https://julialang.org/blog/2018/08/union-splitting/), preventing this type instability from being a problem. However, it is still good practice to write more generic code.
"""

# ╔═╡ 32516afd-4d37-4739-bee5-8cebb2508276
md"""
To fix this we need to initialize `s` to be more generic. That can be done with the `zero` function in Julia.

```julia
function my_sum_better(x)
	s = zero(eltype(x))
	for xi in x
		s += xi
	end
	return s
end
```
"""

# ╔═╡ 55a4d63c-12d2-42de-867c-34879e4d39ec


# ╔═╡ 6bbdd13d-5d46-4bdc-b778-a18748a13552
md"""
Running `@code_warntype` we now get
```julia
@code_warntype my_sum_better(gl)
```
"""

# ╔═╡ e5a22bab-e5ea-4b43-b83e-3bd9bba2c014


# ╔═╡ 94b14c6c-952b-41c6-87e9-27785896d023
md"""
`zero` is a generic function that will create a `0` element that matches the type of the elements of the vector `x`.

One important thing to note is that while Julia uses types to optimize the code, using types in the function arguments does not impact performance at all. 

To see this let's look at an explicit version of `my_sum`
```julia
function my_sum_explicit(x::Vector{Float64})
	s = zero(eltype(x))
	for xi in x
		s += xi
	end
	return s
end
```
"""

# ╔═╡ e0584201-e9ee-49b1-ae55-e5c06efe8d5a


# ╔═╡ bba51c8a-43c0-4d61-985f-167de5a7329e
md"""
We can now benchmark both of our functions

```julia
@benchmark my_sum_better($gl)
```
"""

# ╔═╡ 6d941f25-f84e-4aad-ba2e-ee987155e8df


# ╔═╡ 6e6a2058-a728-4baf-b8dd-e0c59dc8c47b
md"""
```julia
@benchmark my_sum_explicit($gl)
```

"""

# ╔═╡ 9bbf0869-3d17-4f3f-9397-7bf97b31e6b1


# ╔═╡ 3b0c000d-3883-407b-900f-00db5e86c034
md"""
We can even make sure that both functions produce the same code using `@code_llvm` (`@code_native`), which outputs the LLVM IR (native machine code).
"""

# ╔═╡ 135bb62f-cda5-424e-969b-3a9e9389056d
md"""
```julia
@code_llvm my_sum_better(gl)
```
"""

# ╔═╡ 5508e9d9-0212-4e3b-9750-0e6ede4a5456


# ╔═╡ 9f6bbeae-5197-4fd7-8e4d-502020c0f974
md"""
```julia
@code_llvm my_sum_explicit(gl)
```
"""

# ╔═╡ 739cbd52-7c31-40f9-9e27-6e480ed79f83


# ╔═╡ f15013ed-b592-43f6-95ec-820480d804ef
md"""
Being overly specific with types in Julia is considered bad practice since it prevents composability with other libraries in Julia. For example, 

```julia
my_sum_explicit(Float32.(gl))
```
"""

# ╔═╡ 0a91e61c-9db9-4561-a9c6-ed678e8f3cca


# ╔═╡ 2861d873-6860-4d16-86af-3aebc57a9914
md"""
gives a method error because we told the compiler that the function could only accept `Float64`. In Julia, types are mostly used for `dispatch` i.e., selecting which function to use. However, there is one important instance where Julia requires that the types be specific. When defining a composite type or `struct`. 

For example
```julia
begin 
	struct MyType
		a::AbstractArray
	end
	Base.getindex(x, i) = x.a[i]
end
```
"""

# ╔═╡ 9b927077-d96f-482e-abcf-0b6ca7f0d674


# ╔═╡ 9358bba0-d1ca-47df-82a4-cf3102b88600
md"""
In this case, the `getindex` function is type unstable

```julia
@code_warntype MyType(rand(50))[1]
```

"""

# ╔═╡ 9a41649f-ba36-42d0-b85f-7c92b7c7aa7b


# ╔═╡ 7175833a-f7e3-4b83-9d5d-869b5ad2c78b
md"""
This is because Julia is not able to determine the type of `x.a` until runtime and so the compiler is unable to optimize the function.  This is because `AbstractArray` is an abstract type. 

!!! tip
	For maximum performance only use concrete types as `struct` fields/properties.

To fix this we can use *parametric types* 

```julia
begin
	struct MyType2{A<:AbstractArray}
		a::A
	end

	Base.getindex(a::MyType2, i) = a.a[i]
end
```
"""

# ╔═╡ 1840ebca-9856-438d-9daa-3912a43ca3a3


# ╔═╡ 8ff6ad52-b079-4b0c-8a84-56adc8796bbe
md"""
```julia
@code_warntype MyType2(rand(50))[1]
```

"""

# ╔═╡ e9e8ba32-1762-43eb-9b51-8d4bc81d35a9


# ╔═╡ 0898b019-488d-45b3-a8c2-cd72b4491049
md"""
and now because the exact layout `MyType2` is concrete, Julia is able to efficiently compile the code.
"""

# ╔═╡ a8c622c8-2eaf-4792-94fd-e18d622c3b23
md"""

### Additional Tools

In addition to `@code_warntype` Julia also has a number of other tools that can help diagnose type instabilities or performance problems:
  - [`Cthulhu.jl`](https://github.com/JuliaDebug/Cthulhu.jl): Recursively moves through a function and outputs the results of type inference.
  - [`JET.jl`](https://github.com/aviatesk/JET.jl): Employs Julia's type inference system to detect potential performance problems as well as bugs.
  - [`ProfileView.jl`](https://github.com/timholy/ProfileView.jl) Julia profiler and flame graph for evaluating function performance. 
"""

# ╔═╡ 20eff914-5853-4993-85a2-dfb6a8e2c14d
md"""
## Data Layout

Besides ensuring your function is type stable, there are a number of other performance issues to keep in mind with using Julia. 

When using higher-dimensional arrays like matrices, the programmer should remember that Julia uses a `column-major order`. This implies that indexing Julia arrays should be done so that the first index changes the fastest. For example

```julia
function row_major_matrix!(a::AbstractMatrix)
	for i in axes(a, 1)
		for j in axes(a, 2)
			a[i, j] = 2.0
		end
	end
	return a
end
```
!!! note
	We use the bang symbol !. This is stardard Julia convention and signals that the function is mutating.

"""

# ╔═╡ 4f4dde5e-21f3-4042-a91d-cd2c474a2279


# ╔═╡ da99dabc-f9e5-4f5e-8724-45ded36270dc
md"""
!!! tip
	Here we use an function to fill the matrix. This is just for clarity. The more Julian way to do this would be to use the `fill` or `fill!` functions.
"""

# ╔═╡ b3bb4563-e0f6-4edb-bae1-1a91f64b628f
md"""
Benchmarking this function gives
```julia
@benchmark row_major_matrix!($(zeros(1000, 1000)))
```

"""

# ╔═╡ 0d80a856-131d-4811-8d14-828c8c5e49dc


# ╔═╡ 1194df52-bd14-4d6b-9e99-d87c131156d6
md"""
This is very slow! This is because Julia uses column-major ordering. Computers typically store memory sequentially. That means that the most efficient way to access parts of a vector is to do it in order. For 1D arrays there is no ambiguity. However, for higher dimensional arrays a language must make a choice. Julia follows Matlab and Fortrans conventions and uses column-major ordering. This means that matrices are stored column-wise. In a for-loop this means that the inner index should change the fastest.

!!! note
	For a more complete introduction to computere memory and Julia see [https://book.sciml.ai/notes/02-Optimizing_Serial_Code/]()

```julia
function column_major_matrix!(a::AbstractMatrix)
	for i in axes(a, 1)
		for j in axes(a, 2)
			# The j index goes first
			a[j, i] = 2.0
		end
	end
	return a
end
```
"""

# ╔═╡ 5843b2ca-0e98-474d-8a92-7214b05399fd


# ╔═╡ 3270cc6e-3b2d-44b3-a75c-fa50cf15b77b
md"""
```julia
@benchmark column_major_matrix!($(zeros(1000, 1000)))
```
"""

# ╔═╡ 214b7f1b-f90d-4aa8-889f-2a522e80dcf5


# ╔═╡ 50e008a1-a9cc-488e-a1c0-bd21528414c6
md"""
To make iterating more automatic, Julia also provides a generic CartesianIndices tool that ensures that the loop is done in the correct order

```julia
function cartesian_matrix!(a::AbstractMatrix)
	for I in CartesianIndices(a)
		a[I] = 2.0
	end
	return a
end
```
"""

# ╔═╡ e6016b1b-1cb2-4e92-b657-a51a221aa3f2


# ╔═╡ 6ae76360-c446-4ee7-b452-0ac225e9e41b
md"""
```julia
@benchmark cartesian_matrix!($(zeros(1000, 1000)))
```
"""

# ╔═╡ 3534d380-d8ae-498a-84be-c14ba5454e65


# ╔═╡ a52e79b7-3fb0-4ad3-9bf5-f225beff01c3
md"""
## Broadcasting/Vectorization in Julia
"""

# ╔═╡ 16b55184-b515-47c8-bbb3-f899a920e9f8
md"""
One of Julia's greatest strengths over python is surprisingly its ability to vectorize algorithms and **fuse** multiple algorithms together. 

In python to get speed you typically need to use numpy to vectorize operations. For example, to compute the operation `x*y + c^3` you would do 
```python
python> x*y + c**3
```
However, this is not optimal since the algorithm works in two steps:
```python
python> a = x*y
python> b = c**3
python> out = a + b
```
What this means is that python/numpy is not able to fuse multiple operations together. This essentially loops through the data twice and can lead to substantial overhead. 

To demonstrate this, let's first write the `numpy` version of this simple function
"""

# ╔═╡ 4dd74c86-333b-4e7a-944b-619675e9f6ed
@pyimport numpy as np

# ╔═╡ e0a1b20d-366b-4048-80f1-94297697bd4a
x = rand(1_000_000)

# ╔═╡ 82edfb04-3de0-462b-ab4f-77cdad052bef
y = rand(1_000_000)

# ╔═╡ e8febda3-db2c-4f10-84bd-384c9ddd0ff7
c = rand(1_000_000)

# ╔═╡ f33eb06d-f45b-438c-86a9-26d8f94e7809
md"""
First let's use PyCall and numpy to do the computation
"""

# ╔═╡ 60e55645-ab59-4ea7-8009-9db7d0aea2e6
begin
	py"""
	def bench_np(x, y, c):
		return x*y + c**3 
	"""
	bench_np = py"bench_np"
end

# ╔═╡ 35f818c2-acee-4d20-9eb3-0c3ae37f3762
md"""
```julia-repl
julia> @benchmark bench_np($x, $y, $c)
```
"""

# ╔═╡ a0c8660c-3ddb-4795-b3c9-a63cc64c8c00


# ╔═╡ cb3bb128-49d3-4996-84e2-5154e13bbfbd
md"""
Now to get started with Julia we will use a simple for loop.

```julia
function serial_loop(x, y, c)
	out = similar(x)
	for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```
"""

# ╔═╡ 924d11a7-5161-4b13-a1f6-a1a8530736da


# ╔═╡ 40381501-952a-48a5-9a28-ee4bf1c65fd4
md"""
```julia
@benchmark serial_loop($x, $y, $c)
```
"""

# ╔═╡ 0be6a2d0-f470-436c-bbd7-8bab3635a34d


# ╔═╡ 7fad0fc0-1a6a-437a-a1c2-ce2c70d41acf
md"""
And right away, we have almost a factor of 4X speed increase in Julia compared to numpy.

However, we can make this loop faster! Julia automatically checks the bounds of an array every loop iteration. This makes Julia memory safe but adds overhead to the loop.

!!! warning 
	`@inbounds` used incorrectly can give wrong results or even cause Julia to  SEGFAULT

```julia
function serial_loop_inbounds(x, y, c)
	out = similar(x)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```

!!! tip
	If you index with `eachindex` or `CartesianIndices` Julia can often automatically remove the bounds-check for you. The moral - always use Julia's iterator interfaces where possible. This example doesn't because `out` is not included in `eachindex`
"""

# ╔═╡ 946da67e-5aff-4de9-ba15-715a05264c4d
md"""
```julia
@benchmark serial_loop_inbounds($x, $y, $c)
```
"""

# ╔═╡ 4da9796c-5102-44e7-8af3-dadbdabcce73


# ╔═╡ db4ceb7c-4ded-4048-88db-fd15b3231a5c
md"""
That is starting to look better. Now we can do one more thing. Looking at the results we see that we are still allocating in this loop. We can fix this by explicitly passing the output buffer. 
"""

# ╔═╡ 575d1656-0a0d-40ba-a190-74e36c354e8c
md"""
```julia
function serial_loop!(out, x, y, c)
	@inbounds for i in eachindex(x, y, c)
		out[i] = x[i]*y[i] + c[i]^3
	end
	return out
end
```
"""

# ╔═╡ fc2351f5-f808-499d-8251-d12c93a2be0e


# ╔═╡ 2bd7d41e-f2c9-47cd-8d5b-a2cfef84a830
out = similar(x)

# ╔═╡ 42be3a59-b6bb-49b2-a2ca-73adedc35588
md"""
```julia
@benchmark serial_loop!(out, x, y, c)
```
"""

# ╔═╡ f5ecdd06-addb-4913-996b-164e337853c2


# ╔═╡ c14acc67-dbb2-4a86-a811-de857769a472
md"""
With just two changes, we have sped up our original function by almost a factor of 2. However, compared to NumPy, we have had to write a lot more code. 

Fortunately, writing these explicit loops, while fast, is not required to achieve good performance in Julia. Julia provides its own *vectorization* procedure using the 
`.` syntax. This is known as *broadcasting* and results in Julia being able to apply elementwise operations to a collection of objects.

To demonstrate this, we can rewrite our optimized `serial_loop` function just as

```julia
function bcast_loop(x, y, c)
	return x.*y .+ c.^3
	# or @. x*y + c^3
end
```
"""

# ╔═╡ f9a938d8-dce9-4ef0-967e-5b3d5384ca9b


# ╔═╡ 38bafb52-14f0-4a42-8e73-de1ada31c87e
md"""
```julia
@benchmark bcast_loop($x, $y, $c)
```
"""

# ╔═╡ 785a379a-e6aa-4919-9c94-99e277b57844


# ╔═╡ 232cd259-5ff4-42d2-8ae1-cb6823114635
md"""
Unlike Python this syntax can even be used to prevent allocations!

```julia
function bcast_loop!(out, x, y, c)
	out .= x.*y .+ c.^3
	# or @. out = x*y + c^3
end
```
"""

# ╔═╡ 168aee22-6769-4077-a9da-a27689e6bb32


# ╔═╡ 985cd6ec-bd2d-4dd9-bfbe-0bb066036150
md"""
```julia
@benchmark bcast_loop!($out, $x, $y, $c)
```
"""

# ╔═╡ 6acbaed4-6ff3-45be-9b28-595213206218


# ╔═╡ 587d98d8-f805-4c4f-bf2f-1887d86adf05
md"""
Both of our broadcasting functions perform identically to our hand-tuned for loops. How is this possible? The main reason is that Julia's elementwise operations or broadcasting automatically **fuses**. This means that Julia's compiler eventually compiles the broadcast expression to a single loop, preventing intermediate arrays from ever needing to be formed. 
"""

# ╔═╡ ea2e2140-b826-4a05-a84c-6309241da0e7
md"""
Julia's broadcasting interface is also generic and a lot more powerful than the usual NumPy vectorization algorithm. For instance, suppose we wanted to perform an eigen decomposition on many matrices. In Julia, this is given in the `LinearAlgebra` module and the `eigen` function. To apply this to a vector of matrices, we then need to change `eigen` to `eigen.` .
"""

# ╔═╡ e8c1c746-ce30-4bd9-a10f-c68e3823faac
A = [rand(50,50) for _ in 1:50] 

# ╔═╡ e885bbe5-f7ec-4f6a-80fd-d6314179a3cd
md"""
```julia
eigen.(A)
```
"""

# ╔═╡ 90bd7f7b-3cc1-43ab-8f78-c1e8339a79bf


# ╔═╡ 608a3a98-924f-45ef-aeca-bc5899dd8c7b
md"""
Finally as a bonus we note that Julia's broadcasting interface also automatically works on the GPU.
"""

# ╔═╡ cc1e5b9f-c5b4-47c0-b886-369767f6ca4b
md"""
```julia
@benchmark bcast_loop!($(cu(out)), $(cu(x)), $(cu(y)), $(cu(c)))
```

!!! tip
	This will only work if you have CUDA installed and a NVIDIA GPU.
"""

# ╔═╡ 687b18c3-52ae-48fa-81d6-c41b48edd719


# ╔═╡ dcd6c1f3-ecb8-4a3f-ae4f-3c5b6f8494e7
md"""
!!! note
	`cu` is the function that moves the data on the CPU to the GPU. See the parallel computing tutorial for more information about GPU based parallelism in Julia.
"""

# ╔═╡ 20bcc70f-0c9f-40b6-956a-a286cea393f8
md"""
# Conclusion
This is just the start of various performance tips in Julia. There exist many other interesting packages/resources when optimizing Julia code. These resources include:
  - Julia's [`performance tips`](https://docs.julialang.org/en/v1/manual/performance-tips/) section is excellent reading for more information about the various optimization mentioned here and many more.
  - [`StaticArrays.jl`](https://github.com/JuliaArrays/StaticArrays.jl): Provides a fixed size array that enables aggressive SIMD and optimization for small vector operations.
  - [`StructArrays.jl`](https://github.com/JuliaArrays/StructArrays.jl): Provides an interface that acts like an array whose elements are a struct but actually stores each field/property of the struct as an independent array.
  - [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl) specifically the `@turbo` macro that can rewrite loops to make extra use of SIMD.
  - [`Tulio.jl`](https://github.com/mcabbott/Tullio.jl): A package that enables Einstein summation-style summations or tensor operations and automatically uses multi-threading and other array optimization.
"""

# ╔═╡ 97f7a295-5f33-483c-8a63-b74c8f79eef3


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
BenchmarkTools = "~1.3.2"
CUDA = "~3.12.0"
PlutoUI = "~0.7.49"
PyCall = "~1.94.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.4"
manifest_format = "2.0"
project_hash = "0ef5d0582d704353803bf3ec48e942b983cdbeae"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BFloat16s]]
deps = ["LinearAlgebra", "Printf", "Random", "Test"]
git-tree-sha1 = "a598ecb0d717092b5539dbbe890c98bac842b072"
uuid = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
version = "0.2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CUDA]]
deps = ["AbstractFFTs", "Adapt", "BFloat16s", "CEnum", "CompilerSupportLibraries_jll", "ExprTools", "GPUArrays", "GPUCompiler", "LLVM", "LazyArtifacts", "Libdl", "LinearAlgebra", "Logging", "Printf", "Random", "Random123", "RandomNumbers", "Reexport", "Requires", "SparseArrays", "SpecialFunctions", "TimerOutputs"]
git-tree-sha1 = "49549e2c28ffb9cc77b3689dc10e46e6271e9452"
uuid = "052768ef-5323-5732-b1bb-66c8b64840ba"
version = "3.12.0"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "45d7deaf05cbb44116ba785d147c518ab46352d7"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.5.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "30488903139ebf4c88f965e7e396f2d652f988ac"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.16.7"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

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

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "088dd02b2797f0233d92583562ab669de8517fd1"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "4.14.1"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg", "TOML"]
git-tree-sha1 = "771bfe376249626d3ca12bcd58ba243d3f961576"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.16+0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "53b8b07b721b77144a0fbbbc2675222ebf40a02d"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.94.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "7a1a306b72cfa60634f03a911405f4e64d1b718b"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.0"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f2fd3f288dfc6f507b0c3a2eb3bac009251e548b"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.22"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─5d8d2585-5c04-4f33-b547-8f44b3336f96
# ╟─5dbe9644-eb50-4204-b8c6-a1aac5fe3736
# ╟─a2680f00-7c9a-11ed-2dfe-d9cd445f2e57
# ╠═b90d6694-b170-4646-b5a0-e477d4fe6f50
# ╟─5ed407ea-4bba-4eaf-b47a-9ae95b28abba
# ╟─76e3f9c8-4c39-4e7b-835b-2ba67435666a
# ╠═f3d6edf3-f898-4772-80b7-f2aeb0f69216
# ╠═530368ec-ec33-4204-ac44-9dbabaca0dc4
# ╟─2310c578-95d8-4af0-a572-d7596750dfcc
# ╠═50b5500e-5ca8-4432-a5ac-01193a808232
# ╟─36a9656e-d09c-46b0-8dc4-b9a4de0ba3a8
# ╟─8bc401d6-35f0-4722-8ac5-71ca34597b5f
# ╠═db9108c9-642f-4cb0-b1ba-08a76b505d2e
# ╟─29d231cf-131a-4907-aaf3-8ed4d8c1f181
# ╠═d228e0f2-63f1-47aa-a0f2-ec4ede84fb3b
# ╟─934552be-59f8-4af4-86ad-711328035876
# ╠═d5d35977-e8ef-4fd6-9573-5402616407d6
# ╟─1f3bfcc0-25f5-4c42-a989-0f3eb344eca8
# ╟─b89b329e-0dd1-4b0b-82a1-19d104dcf430
# ╠═4f17c95e-8e0f-414d-ab62-413d7a848221
# ╟─946d91d1-7c37-4c35-b967-8b98856fb431
# ╠═b050c5a4-3034-4a14-ae3a-b6eac433f275
# ╟─30e2be6c-f990-467a-85f9-a37f84f145ea
# ╟─32516afd-4d37-4739-bee5-8cebb2508276
# ╠═55a4d63c-12d2-42de-867c-34879e4d39ec
# ╟─6bbdd13d-5d46-4bdc-b778-a18748a13552
# ╠═e5a22bab-e5ea-4b43-b83e-3bd9bba2c014
# ╟─94b14c6c-952b-41c6-87e9-27785896d023
# ╠═e0584201-e9ee-49b1-ae55-e5c06efe8d5a
# ╟─bba51c8a-43c0-4d61-985f-167de5a7329e
# ╠═6d941f25-f84e-4aad-ba2e-ee987155e8df
# ╟─6e6a2058-a728-4baf-b8dd-e0c59dc8c47b
# ╠═9bbf0869-3d17-4f3f-9397-7bf97b31e6b1
# ╟─3b0c000d-3883-407b-900f-00db5e86c034
# ╟─135bb62f-cda5-424e-969b-3a9e9389056d
# ╠═5508e9d9-0212-4e3b-9750-0e6ede4a5456
# ╟─9f6bbeae-5197-4fd7-8e4d-502020c0f974
# ╠═739cbd52-7c31-40f9-9e27-6e480ed79f83
# ╟─f15013ed-b592-43f6-95ec-820480d804ef
# ╠═0a91e61c-9db9-4561-a9c6-ed678e8f3cca
# ╟─2861d873-6860-4d16-86af-3aebc57a9914
# ╠═9b927077-d96f-482e-abcf-0b6ca7f0d674
# ╟─9358bba0-d1ca-47df-82a4-cf3102b88600
# ╠═9a41649f-ba36-42d0-b85f-7c92b7c7aa7b
# ╟─7175833a-f7e3-4b83-9d5d-869b5ad2c78b
# ╠═1840ebca-9856-438d-9daa-3912a43ca3a3
# ╟─8ff6ad52-b079-4b0c-8a84-56adc8796bbe
# ╠═e9e8ba32-1762-43eb-9b51-8d4bc81d35a9
# ╟─0898b019-488d-45b3-a8c2-cd72b4491049
# ╟─a8c622c8-2eaf-4792-94fd-e18d622c3b23
# ╟─20eff914-5853-4993-85a2-dfb6a8e2c14d
# ╠═4f4dde5e-21f3-4042-a91d-cd2c474a2279
# ╟─da99dabc-f9e5-4f5e-8724-45ded36270dc
# ╟─b3bb4563-e0f6-4edb-bae1-1a91f64b628f
# ╠═0d80a856-131d-4811-8d14-828c8c5e49dc
# ╟─1194df52-bd14-4d6b-9e99-d87c131156d6
# ╠═5843b2ca-0e98-474d-8a92-7214b05399fd
# ╟─3270cc6e-3b2d-44b3-a75c-fa50cf15b77b
# ╠═214b7f1b-f90d-4aa8-889f-2a522e80dcf5
# ╟─50e008a1-a9cc-488e-a1c0-bd21528414c6
# ╠═e6016b1b-1cb2-4e92-b657-a51a221aa3f2
# ╟─6ae76360-c446-4ee7-b452-0ac225e9e41b
# ╠═3534d380-d8ae-498a-84be-c14ba5454e65
# ╟─a52e79b7-3fb0-4ad3-9bf5-f225beff01c3
# ╟─16b55184-b515-47c8-bbb3-f899a920e9f8
# ╠═cab50215-8895-4789-997f-589f017b2b84
# ╠═4dd74c86-333b-4e7a-944b-619675e9f6ed
# ╠═e0a1b20d-366b-4048-80f1-94297697bd4a
# ╠═82edfb04-3de0-462b-ab4f-77cdad052bef
# ╠═e8febda3-db2c-4f10-84bd-384c9ddd0ff7
# ╟─f33eb06d-f45b-438c-86a9-26d8f94e7809
# ╠═60e55645-ab59-4ea7-8009-9db7d0aea2e6
# ╟─35f818c2-acee-4d20-9eb3-0c3ae37f3762
# ╠═a0c8660c-3ddb-4795-b3c9-a63cc64c8c00
# ╟─cb3bb128-49d3-4996-84e2-5154e13bbfbd
# ╠═924d11a7-5161-4b13-a1f6-a1a8530736da
# ╟─40381501-952a-48a5-9a28-ee4bf1c65fd4
# ╠═0be6a2d0-f470-436c-bbd7-8bab3635a34d
# ╟─7fad0fc0-1a6a-437a-a1c2-ce2c70d41acf
# ╟─946da67e-5aff-4de9-ba15-715a05264c4d
# ╠═4da9796c-5102-44e7-8af3-dadbdabcce73
# ╟─db4ceb7c-4ded-4048-88db-fd15b3231a5c
# ╟─575d1656-0a0d-40ba-a190-74e36c354e8c
# ╠═fc2351f5-f808-499d-8251-d12c93a2be0e
# ╠═2bd7d41e-f2c9-47cd-8d5b-a2cfef84a830
# ╟─42be3a59-b6bb-49b2-a2ca-73adedc35588
# ╠═f5ecdd06-addb-4913-996b-164e337853c2
# ╟─c14acc67-dbb2-4a86-a811-de857769a472
# ╠═f9a938d8-dce9-4ef0-967e-5b3d5384ca9b
# ╟─38bafb52-14f0-4a42-8e73-de1ada31c87e
# ╠═785a379a-e6aa-4919-9c94-99e277b57844
# ╟─232cd259-5ff4-42d2-8ae1-cb6823114635
# ╠═168aee22-6769-4077-a9da-a27689e6bb32
# ╟─985cd6ec-bd2d-4dd9-bfbe-0bb066036150
# ╠═6acbaed4-6ff3-45be-9b28-595213206218
# ╟─587d98d8-f805-4c4f-bf2f-1887d86adf05
# ╟─ea2e2140-b826-4a05-a84c-6309241da0e7
# ╠═e8c1c746-ce30-4bd9-a10f-c68e3823faac
# ╠═c3bc0c44-b2e9-4e6a-862f-8ab5092459ea
# ╟─e885bbe5-f7ec-4f6a-80fd-d6314179a3cd
# ╠═90bd7f7b-3cc1-43ab-8f78-c1e8339a79bf
# ╟─608a3a98-924f-45ef-aeca-bc5899dd8c7b
# ╠═b83ba8db-b9b3-4921-8a93-cf0733cec7aa
# ╟─cc1e5b9f-c5b4-47c0-b886-369767f6ca4b
# ╠═687b18c3-52ae-48fa-81d6-c41b48edd719
# ╟─dcd6c1f3-ecb8-4a3f-ae4f-3c5b6f8494e7
# ╟─20bcc70f-0c9f-40b6-956a-a286cea393f8
# ╠═97f7a295-5f33-483c-8a63-b74c8f79eef3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
