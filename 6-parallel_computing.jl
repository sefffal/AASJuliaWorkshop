### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ e17b15bd-337d-4809-8b6c-2ed0f3701a9e
using PlutoUI

# ╔═╡ d8ff3dd3-e1ea-4f20-8937-8f8f995402fa
using BenchmarkTools # bring in @btime and @benchmark macros

# ╔═╡ d774d485-cfef-4373-9fed-77618ea928de
# Load LoopVectorization
using LoopVectorization

# ╔═╡ 463eab77-8c30-4071-bf84-a1aad685c21e
using FLoops

# ╔═╡ 72cd207c-7a63-4e29-a6d8-110bcf65ecdc
using CUDA

# ╔═╡ c989d4b7-c566-49a4-84fe-28b0e8f8c963
PlutoUI.TableOfContents()

# ╔═╡ e6020e3a-77c7-11ed-2be9-e987cee1edf0
md"""
# Parallel Computing in Julia.

Julia is particularly able to exploit various types of parallelism to accelerate the performance of a program.
In this tutorial, we will overview how to enable parallelism in various Julia programs.
"""

# ╔═╡ fb75265d-b154-4913-8714-ee68959682b4
md"""
Julia has a strong parallel computing infrastructure that enable HPC using vectorization,
threading, distributed computing, and even GPU acceleration.

## Single Processor Parallelism (SIMD)

To get started, we will discuss low-level parallelism related to a single core called
*SIMD* or **Single Instruction Multiple Data**. SIMD is when the computer can apply a
single instruction to multiple data sets in a single instruction cycle. For instance,
suppose we have two vectors of number in Julia `a` and `b`. Then the following graph
compares how a serial instruction v.s. a vectorized instruction would be run on the computer.
"""

# ╔═╡ c23fcdf1-4fd8-4859-abb3-8e08b4476046
md"""
!!! note
	**CPU cycle**: Can be thought of the smallest unit of time on which a CPU behaves.
    In a single CPU cycle, the computer usually does a fetch-decode-execute step. Briefly,
    this means that you can think of the CPU doing a single simpler operation, like
    addition, multiplication, etc.
"""

# ╔═╡ 766c47e4-f8ff-4d5b-868a-d13b52a8a1c1
html"""
<img src="https://github.com/sefffal/AASJuliaWorkshop/blob/main/vectorization.jpeg?raw=true"/>
"""

# ╔═╡ b8e1a548-9c4d-40f1-baf3-c833151e7eba
md"""
While the serial computation loops through each element in the list and applies the
addition operation each CPU clock cycle, the vectorized version realizes that it can
group multiple datasets (array elements) together and perform the same operation.
This can lead to 2x, 4x, or greater speedups depending on the specific CPU architecture
(related to AVX, AVX2, AVX512).

So what does Julia do? Let's start with the simple example above:
"""

# ╔═╡ a1f9058a-9c7f-494e-9b73-f5acc4778604
md"""
!!! note
	Vectorization in this setting is usually different from vectorization in Python/R. In python vectorization refers to placing all your variables in some vector container, like a numpy array, so that the resulting operation is run using a C/Fortran library.
"""

# ╔═╡ 441099b3-4103-4cff-9deb-3c2153d657c6
md"""
```julia
function serial_add!(out, x, y)
	for i in eachindex(x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```
"""

# ╔═╡ 8c198d15-4367-44e8-9de0-43a468bfbac2


# ╔═╡ cadf8a67-1c1e-4850-9723-ef92196671dd
md"""
!!! note
	Note that we append the function with `!` this is a Julia convention which signals that we are mutating the arguments.
"""

# ╔═╡ 9fede501-3324-4076-a2ff-3b464063e5c9
md"""
First we will allocate some variables for this tutorial
"""

# ╔═╡ 7f5c5849-feef-4581-9356-8146cba48b9e
N = 2^10

# ╔═╡ 799e73d9-4857-466e-b645-8ee15566b03f
x = rand(N)

# ╔═╡ d490a507-4b9d-4077-9eaf-ae4ac3d149a1
y = rand(N)

# ╔═╡ 7be8c14e-e258-4deb-abdf-a042f873465a
out = zero(y)

# ╔═╡ cc00d185-1b7e-40f5-8036-da4132dc0700
md"""
Now let's benchmark our serial add to get a baseline for our performance.

```julia
@benchmark serial_add!($out, $x,  $y)
```
"""

# ╔═╡ 576491d9-0c0c-4740-b73a-165c61ce3fed


# ╔═╡ 34ad1196-a1d7-4118-b4da-426af6826c7d
md"""
Analyzing this on a Ryzen 7950x, it appears that the summation is 53.512 ns, or each
addition takes only 0.05ns! Inverting this number would naively suggest that the computer I am using has a 19 GHz processor!

SIMD is the reason for this performance. Namely Julia's was able to automatically apply its auto-vectorization routines to use SIMD to accelerate the program.

To confirm that Julia was able to vectorize the loop we can use the introspection tool
```julia
@code_llvm serial_all!(out, x, y)
```
"""

# ╔═╡ 7623b88a-ba60-450e-86fb-8890354f7a94


# ╔═╡ a872cf65-a11e-4371-9d4d-41ea92c55369
md"""
This outputs the LLVM IR and represents the final step of Julia's compilation pipeline
before it is converted into native machine code. While the output of `@code_llvm` is
complicated to check that the compiler effectively used SIMD we can look for something
similar to

```
   %wide.load30 = load <4 x double>, <4 x double>* %55, align 8
; └
; ┌ @ float.jl:383 within `+`
   %56 = fadd <4 x double> %wide.load, %wide.load27
```

This means that for each addition clock, we are simultaneously adding four elements of the array together. As a sanity check, this means that I have a 19/4 = 4.8 GHz processor which is roughly in line with the Ryzen 7950x reported speed.

### Vectorizing Julia Code with Packages

Proving that a program can SIMD however can be difficult, and sometimes the compiler
won't effectively auto-vectorize the code. Julia however provides a number of tools that
can help the user to more effectively use SIMD. The most low-level of these libraries
is [`SIMD.jl`](https://github.com/eschnett/SIMD.jl). However,  most users never need to use SIMD.jl directly (for an introduction
see <http://kristofferc.github.io/post/intrinsics/>. Instead most Julia users will use more-upstream packages, such as [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl).

To see `LoopVectorization` in action let's change our above example to the slightly more complicated function.

```julia
function serial_sinadd(out, x, y)
	for i in eachindex(out, x, y)
		out[i] = x[i] + sin(y[i])
	end
	return out
end
```
"""

# ╔═╡ 547df3f2-b2fe-4f22-a0ac-3ba6bdd3171c


# ╔═╡ 57bd871d-06fc-4050-9024-aaaf52297d0a
md"""
Again lets start with a baseline evaluation
```julia
@benchmark serial_sinadd($out, $x, $y)
```
"""

# ╔═╡ f51bd7cb-97fd-4d5e-bcac-a114f19abe7d


# ╔═╡ 566eb7e1-0e2f-4ea7-8770-a6b2c95c1eb4
md"""
Running this example will show that the code is a lot slower than our previous example! Part of this is because `sin` is expensive, however we can also check whether the code was vectorized using the `@code_llvm`.
```julia
@code_llvm serial_sinadd(out, x, y)
```
"""

# ╔═╡ e4e98981-1964-43a3-aa81-4fef27d7f864


# ╔═╡ 7f0ff927-71ea-4ab9-99aa-c4a6655b545c
md"""
Analyzing the output does show that Julia/LLVM was unable to automatically vectorize the expression. The reason for this is complicated and won't be discussed. However, we can fix this with
loop vectorization and its `@turbo` macro

"""

# ╔═╡ ccf102f3-9e85-4f70-b65e-6b4b056cf7e3
md"""
```julia
function serial_sinadd_turbo(out, x, y)
	@turbo for i in eachindex(out, x, y)
		out[i] = x[i] + sin(y[i])
	end
	return out
end
```
"""

# ╔═╡ fb6f9256-e874-418a-b226-83a9173b9ec2


# ╔═╡ 540326cd-5f2c-4b07-8dd6-1c65f63af7d6
md"""
```julia
@benchmark serial_sinadd_turbo($out, $x, $y)
```
"""

# ╔═╡ 1364924b-0cbd-443d-a319-9701708cbd15
md"""
And boom we get large speed increase (factor of 2 on a Ryzen 7950x) by simply adding the `@turbo` macro to our loop.
"""

# ╔═╡ 54d083d4-3bf8-4ed7-95b5-203e13cc3249
md"""
## Threading with Julia

Multi-threading is when a set of processors in Julia share the same Julia runtime and memory.
This means that multiple threads can all write and read from the exact same section of
memory in the computer and can execute code on the memory simultaneously.

To enable threading in julia you need to tell julia the number of threads you want to use.
For instance, start julia with 4 threads do
```bash
> julia -t 4
```
which will start Julia with 4 threads. You can also start Julia with threads on Linux/Mac by
using the environment label `JULIA_NUM_THREADS=4`. If you use `julia -t auto` then Julia will
start with the number of threads available on your machine. Note that `julia -t` required julia version 1.5 or later.

You can check the number of threads julia is using in the repl by typing
```julia
Threads.nthreads()
```
"""

# ╔═╡ c6228b0b-22b8-4e3d-95d2-350987544b85


# ╔═╡ b9e13054-7641-45f1-8cd6-c8565a9f5d1f
md"""
Each Julia thread is tagged with an id that can be found using
```julia
Threads.threadid()
```
which defaults to 1, the master thread.


!!! tip
	This is the number of `Julia` threads not the number of BLAS threads. To set those do
	```julia
	using LinearAlgebra
	BLAS.set_num_threads(8)
	```
	where 8 is the number of threads you want to use.
"""

# ╔═╡ 11f7af26-92d5-4430-bdde-5aad69859f2e


# ╔═╡ d1bae4b3-6455-458b-a00c-f7e8eda201c3
md"""
which defaults to `1` the master thread.
"""

# ╔═╡ 3214e9e9-bcae-43b4-8e07-e8106310cf83
md"""

### Simple threading with `Threads.@threads`

The simplest way to use multi-threading in Julia is to use the `Threads.@threads` macro
which automatically threads loops for you. For instance, we can thread our previous function using:
"""

# ╔═╡ e468d9fd-ead0-4ce4-92b1-cb96132f6921
md"""
```julia
function threaded_add!(out, x, y)
	Threads.@threads for i in eachindex(out, x, y)
		out[i] = x[i] + y[i]
	end
	return out
end
```
"""

# ╔═╡ f9841e19-68ad-411e-88c6-363996b7a95c


# ╔═╡ 478eaa1d-509a-4fba-8b65-cb45561f9157
md"""
And benchmarking:

```julia
@benchmark threaded_add!($out, $x, $y)
```
"""

# ╔═╡ 14b676f0-b3b3-41a0-8f08-80b4fae29ec3


# ╔═╡ c815af66-cb82-4dd0-a4b8-3c9cb4a8d9f2
md"""
This is actually slower than what we previously got without threading! This is because
threading has significant overhead! For simple computations, like adding two small vectors the overhead from threading dominates over any benefit you gain from using multiple threads.

In order to gain a benefit from threading our operation needs to:

1. Be expensive enough that the threading overhead is relatively minor
2. Be applied to a large enough vector to limit the threading overhead.

To see the benefit of threading we can then simply increase the number of operations
"""

# ╔═╡ 5852589e-388c-43bf-9ff5-da46af141680
xlarge = rand(2^20)

# ╔═╡ 69ada451-8806-4398-933a-e02efb28deea
ylarge = rand(2^20)

# ╔═╡ 8ebab57a-d4e5-4d50-8c5b-a95ed51487c9
outlarge = rand(2^20)

# ╔═╡ c06da2eb-ed9f-4986-854c-9b8d830e662b
md"""
Get the baseline again
```julia
@benchmark serial_add!($outlarge, $xlarge,  $ylarge)
```
"""

# ╔═╡ 54b2e366-f409-4603-a57a-b711202c4887


# ╔═╡ 07eddd9c-c53f-49e7-9d61-2f5d54711a1c
md"""
Now test the threading example
```julia
@benchmark threaded_add!($outlarge, $xlarge,  $ylarge)
```
"""

# ╔═╡ b5666e45-dcf6-4ea8-9e83-7609f2091f83


# ╔═╡ 45639208-ec9f-4aef-adb0-7a2c4467353a
md"""
Now, we are starting to see the benefits of threading for large enough vectors.
To determine whether threading is useful, a user should benchmark the code. Additionally, memory bandwidth limitations are often important and so multi-threaded code should also do as few allocations as possible.

### Low-Level Multi-Theading
"""

# ╔═╡ bd78505c-904c-4e65-9160-6b3ebf02c21e
md"""
There are additional considerations to keep in mind when multi-threading. An important one is that Julia's Base threading utilities are rather low-level and do not guarantee threading safety, e.g., to be free of **race-conditions**. To see this, let's consider a simple map and sum function.

```julia
function apply_sum(f, x)
	s = zero(eltype(x))
	for i in eachindex(x)
		@inbounds s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ 1ee1af8c-191c-4677-84fc-2cdeac39607c


# ╔═╡ 32068e63-5ad5-4d0d-bee6-205597db610b
md"""
Now apply this to our large vector
```julia
apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ d7ad4f01-2f7e-4dcc-8e32-88ebbf807a06


# ╔═╡ 5c5ce94e-1411-4b26-af48-2cd836b0857c
md"""
A naive threaded implementation of this would be to just prepend the for-loop with the @threads macro

```julia
function naive_threaded_apply_sum(f, x)
	s = zero(eltype(x))
	Threads.@threads for i in eachindex(x)
		@inbounds s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ df637f5c-d702-4e7d-81f5-cbefac75c13b


# ╔═╡ f4602617-c87b-4ce9-bbd0-7d3715b5c7e1
md"""
```julia
naive_threaded_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ bd6bd1e9-66bf-421d-bb7b-4be4528a2701


# ╔═╡ 2a9f6170-b3d6-4fbb-ba48-2f82098b3849
md"""
We see that the naive threaded version gives the incorrect answer. This is because we have multiple threads writing to the same location in memory resulting in a race condition. If we run this block multiple times (**try this**) you will get different answers depending on the essentially random order that each thread writes to `s`.

To fix this issue there are two solutions. The first is to create a separate variable that holds the sum for each thread
"""

# ╔═╡ 0fbce4a6-0a0c-4251-be50-c13add4c4768
md"""
```julia
function threaded_sol1_apply_sum(f, x)
	partial = zeros(eltype(x), Threads.nthreads())
	# Do a partial reduction on each thread
	Threads.@threads for i in eachindex(x)
		id = Threads.threadid()
		@inbounds partial[id] += f(x[i])
	end
	# Now group everything together
	return sum(partial)
end
```
"""

# ╔═╡ 1f3b66c5-2845-4f3f-befd-e7e94243368c


# ╔═╡ 74ff761d-b1e4-4468-8f24-77fb84bda8ac
md"""
```julia
threaded_sol1_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ 73097493-1abe-4c6e-9965-9dde6c97611e
md"""
Which now gives the correct answer.
"""

# ╔═╡ aad7b000-7f4b-4901-8513-078eae85ca67
md"""
The other solution is to use Atomics. Atomics are special types that do the tracking in `threaded_sol1_apply_sum` for you. The benefit of this approach is that functionally the program looks very similar
"""

# ╔═╡ 2969c283-4105-4c25-ae39-9e169c195f00
md"""
```julia
function threaded_atomic_apply_sum(f, x)
	s = Threads.Atomic{eltype(x)}(zero(eltype(x)))
	Threads.@threads for i in eachindex(x)
		Threads.atomic_add!(s, f(x[i]))
	end
	# Access the atomic element and return it
	return s[]
end
```
"""

# ╔═╡ c037381a-8b6e-4bfa-b39a-e8c6ed264f71


# ╔═╡ 21de2f77-b5ed-4b62-94e3-ca6e22a80e43
md"""
```julia
threaded_atomic_apply_sum(x->exp(-x), xlarge)
```
"""

# ╔═╡ cc4990eb-74f3-4b57-9b1d-0689fb2f6604


# ╔═╡ 79222f00-3d55-4914-9d9d-b3c7b1ed6c69
md"""
Both approaches gives the same answer, however let's benchmark both solutions:

```julia
@benchmark threaded_sol1_atomic_apply_sum($(x->exp(-x)), $xlarge)
```
"""

# ╔═╡ 6b496229-98bf-4312-9faf-f22aae633843


# ╔═╡ 4768f5c4-b37b-4667-9b42-d0352c8b5dde
md"""
```julia
@benchmark threaded_atomic_apply_sum($(x->exp(-x)), $xlarge)
```
"""

# ╔═╡ f82d29b5-4d18-4c66-9703-9445b205d1ff


# ╔═╡ dfa50bc7-2250-4326-b7a6-724a975c4928
md"""
The atomic solution is substantially slower than the manual solution. In fact, atomics should only be used if absolutely necessary. Otherwise the programmer should try to find a more manual solution.

### Using Higher-Level Threading Packages

In general multi-threading programming can be quite difficult and error prone. Luckily there are a number of packages in Julia that can make this much simpler. The [`JuliaFolds`](https://github.com/JuliaFolds) ecosystem has a large number of packages, for instance, the [`FLoops.jl`](https://github.com/JuliaFolds/FLoops.jl). FLoops.jl provides two macros that enable a simple for-loop to be used for a variety of different execution mechanisms. For instance, every previous version of apply_sum can be written as
"""

# ╔═╡ c8b7983f-295d-4ca4-9810-e0f130c5e92c
md"""
```julia
function floops_apply_sum(f, x; executor=ThreadedEx())
	s = zero(eltype(x))
	@floop for i in eachindex(x)
		@reduce s += f(x[i])
	end
	return s
end
```
"""

# ╔═╡ 7912e780-59cd-46d6-8a3a-a1eb47b6f9cf


# ╔═╡ a14e0cb2-42b5-41ea-a2f3-83a725baf38c
md"""
Pay special attention to the additional `executor` keyword argument. FLoops.jl provides a number of executors:
 - `SequentialEx` runs the for-loop serially (similar to `apply_sum`)
 - `ThreadedEx` runs the for-loop using threading, while avoiding data-races (similar to `threaded_sol1_apply_sum`)
 - `CUDAEx` runs the for-loop vectorized on the GPU using CUDA.jl. (this is experimental)
 - `DistributedEx` runs the for-loop using Julia's distributed computing infrastruture (see below).

We can then easily run both threaded and serial versions of the algorithm by just changing the `executor`
"""

# ╔═╡ 44ddfdd9-7898-4561-b46a-045bcc1ae467
md"""
```julia
floops_apply_sum(x->exp(-x), xlarge; executor=SerialEx())
```
"""

# ╔═╡ 256ca1f5-403f-4eb3-8422-19724fa95526


# ╔═╡ 872a2066-8c51-4597-89e8-5a902f40c2cc
md"""
```julia
floops_apply_sum(x->exp(-x), xlarge; executor=ThreadedEx())
```
"""

# ╔═╡ 23cf56d9-b53e-4be6-8dae-a6ebb8e0f6a4


# ╔═╡ df842625-04af-43d0-b802-3e4a9841c172
md"""
Benchmarking the `Floops` version

```julia
@benchmark floops_apply_sum($(x->exp(-x)), $xlarge; executor=ThreadedEx())
```
"""

# ╔═╡ 4f23d7c3-6d85-4d03-8d05-dd0719ebcbe3


# ╔═╡ 529f73c3-b8ba-4b4b-bab1-7aa84c2a3a29
md"""
is almost as fast as our hand-written example, but requires less understanding of race-conditions in threading.
"""

# ╔═╡ e7163af8-3534-44fc-8e8f-ef1c692c972e
md"""
## GPU Acceleration

### Introduction

GPUs are in some sense, opposite to CPUs. The typical CPU is characterized by a small
number of very fast processors. On the other hand, a GPU has thousands of very slow processors.
This dichotomy directly relates to the types of problems that are fast on a GPU compared to a CPU.

To get started with GPUs in Julia you need to load the correct package one of

1. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl): NVIDIA GPUs, and the most stable GPU package
2. [AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl): AMD GPUs, actively developed but not as mature as CUDA; only works on linux due to ROCm support
3. [oneAPI.jl](https://github.com/JuliaGPU/oneAPI.jl): Intel GPUs, currently under active development so it may have bugs; only works on linux currently.
4. [Metal.jl](https://github.com/JuliaGPU/Metal.jl): Mac GPUs. Work in progress. Expect bugs and it is open to pull-requests.

For this tutorial I will be using mostly be using the CUDA library. However, we will try to include code for other GPUs as well.


### Getting Started with GPU computing

CUDA.jl provides a complete suite of GPU tools in Julia from low-level kernel writing to
high-level array operations. Most of the time a user just needs to use the high-level array
interface which uses Julia's built-in broadcasting. For instance we can port our simple
addition example above to the GPU by first moving the data to the GPU and using Julia's CUDA.jl broadcast interface.
"""

# ╔═╡ 9d9d3fff-37d8-4773-816f-411fb79679f5
md"""
```julia
# For AMD
using AMDGPU
# For intel (linux only)
using oneAPI
# For M1 Mac
using Metal
```
"""

# ╔═╡ 799de936-6c6d-402f-93db-771e7ec1ef51
md"""
Now let's load our array onto the GPU

For CUDA:
```julia
begin
	xlarge_gpu   = cu(xlarge)
	ylarge_gpu   = cu(ylarge)
	outlarge_gpu = cu(outlarge)
end
```

For other GPU providers replace `cu` with 
```julia
# AMD
ROCArray(xlarge)
# Intel
oneArray(xlarge)
# M1 Mac
MtlArray(xlarge)
```
"""

# ╔═╡ 5215d6a5-5823-4d3b-9086-ebd975d4393b


# ╔═╡ 0116005e-c436-4dad-89bd-47260cfa706f
md"""
For CUDA.jl the `cu` function take an array and creates a `CuArray` which is a copy of the
array that lives in the GPU memory. For the other GPUs the story is very similar and just the array type changes. Below we will mention some potential performance
pitfalls that can occur due to this memory movement.

`cu` will tend to work on many Array types in Julia. However, if you have a
more complicated variable such as a `struct` then you will need to tell Julia how to move
the data to the GPU. To see how to do this see <https://cuda.juliagpu.org/stable/tutorials/custom_structs/>

Given these GPU array objects, our `serial_add!` function could be written as
"""

# ╔═╡ 0218d82e-35b4-4109-bbc8-b1d51c97ab6f
md"""
```julia
function bcast_add!(out, x, y)
	out .= x .+ y
	return out
end
```
"""

# ╔═╡ d7fdf09a-3c59-4dba-b089-ae6033b57809


# ╔═╡ 891a9803-7fd0-4a83-95ab-58b9bd44f8f2
md"""
!!! note
	Pay special attention to the `.=`. This ensures that not intermediate array is created on the GPU.
"""

# ╔═╡ 7ce8025e-16be-47e0-988d-85947cc4e359
md"""
Running this on the gpu is then as simple as
```julia
@benchmark bcast_add!($outlarge_gpu, $xlarge_gpu, $ylarge_gpu)
```

!!! note 
	This will work with any of the GPU packages mentioned above!
"""

# ╔═╡ 6b34f668-25d1-4c9b-8c1a-d08fcdc5dea0


# ╔═╡ 2020675b-859b-4939-9f8d-138995ce1d18
md"""
However, at this point you may notice something. Nowhere in our algorithm did we specify
that this kernel is actually running on the GPU. In fact we could use the exact same function
using our CPU verions of the arrays
"""

# ╔═╡ 147bbd17-abf6-465f-abd0-895cb742f896
md"""
```julia
@benchmark bcast_add!($outlarge, $xlarge, $ylarge)
```
"""

# ╔═╡ 1e88e7c1-f239-4da1-8af8-4f629ef86cb7


# ╔═╡ ccf924ae-fada-4635-af68-ab1fb612a5bc
md"""
This reflects more general advice in Julia. Programs should be written generically. Julia's
dot syntax `.` has been written to be highly generic, so functions should more generally be
written using it than with generic loops, unless speed due to SIMD as with LoopVectorization,
or multi-threading is required. This programming style has been codified in
the [`SciMLStyle coding guide`](https://github.com/SciML/SciMLStyle).
"""

# ╔═╡ 144bb14e-861a-4665-8b50-513b0f463546
md"""
Similarly our more complicated function `serial_sinadd!` could also be written as:
"""

# ╔═╡ 13085fcb-75db-41ec-b8ad-b509798037d7
md"""
```julia
outlarge_gpu .= xlarge_gpu .+ sin.(ylarge_gpu)
```
"""

# ╔═╡ 751950c0-ccae-4316-91cf-089ddaae95ad


# ╔═╡ 4c7383d8-c7ac-48c0-814d-abc7cfc7c447
md"""
### Writing Custom Kernels

While Julia's array base GPU programming is extremely powerful, sometimes we have to use
something more low-level. For instance, suppose our function accesses specific elements of
a GPU array (e.g., CuArray) that isn't handled through the usual linear algebra of broadcast interface.

In this case when we try to index into a `CuArray` we get a `Scalar Indexing` error
"""

# ╔═╡ 175e02af-6762-474f-a728-e77a2f6fa771
md"""
```julia
xlarge_gpu[1]
```
"""

# ╔═╡ d3e64cea-3b29-4d8b-8ee1-1353674c1d89


# ╔═╡ e4ca8a18-1bc9-4730-95ae-d2a1edc30114
md"""
Analyzing the error message tells us what is happening. When accessing a single element,
the CuArray will first copy the entire array to the CPU and then access the element.
This is incredibly slow! So how to we deal with this?

The first approach is to see if you can rewrite the function so that you can make use of
the GPU broadcasting interface. If this is impossible, you will need to write a custom kernel.

To do this, let's adapt our simple example to demonstrate the general approach to writing CUDA kernels
"""

# ╔═╡ bebb0e97-cfb3-46ac-80aa-2ada3159e4f5
md"""

For CUDA and AMD
```julia
function gpu_kernel_all!(out, x, y)
    index = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    stride = gridDim().x * blockDim().x
	for i in index:stride:length(out)
		out[i] = x[i] + y[i]
	end
	return nothing
end
```

For Mac
```julia
function gpu_kernel_all!(out, x, y)
	i = thread_position_in_grid_1d()
	out[i] = x[i] + y[i]
	return nothing
end
```
"""

# ╔═╡ 759be8ef-7136-4330-abfe-0ffd212883d3


# ╔═╡ 6b40113f-5017-4530-9d76-fadeab58973c
md"""
This creates the kernel function. This looks almost identical to our `serial_add` function except for the `threadIDx` and `blockDim` calls. These arguments relate to how the GPU vectorizes the operation across all of its threads. For an introduction to these see the `CUDA.jl` [introduction](https://cuda.juliagpu.org/stable/tutorials/introduction/). Now to run the CUDA kernel we can compile our function to a native CUDA kernel using the `@cuda` macro.
"""

# ╔═╡ a5688604-240e-4d5d-8252-672fc789cd05
md"""
```julia
# Compile the CUDA kernel and run it
CUDA.@sync @cuda threads=256 gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu)
```
"""

# ╔═╡ e1964067-d3e7-4903-a17d-0606a6bc281e
md"""
For AMD we use the `@roc` macro
```julia
wait(@roc groupsize=256 gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu))
```

For M1 Mac we use the `@metal` macro
```julia
@metal threads=length(outlarge) gpu_kernel_all!(outlarge_gpu, xlarge_gpu, ylarge_gpu)
```
"""

# ╔═╡ d895744d-888d-45ff-a7e5-8865be535194


# ╔═╡ 8ff25eb9-a32f-410f-a430-d123c2f3c884
md"""
!!! note
	Due to the nature of GPU programming we need to specify the number of threads to run the kernel on. Here we use 256 as a default value. However, this is not optimal and the `CUDA.jl` documentation provides additional advice on how to optimize these parameters
"""

# ╔═╡ c6436555-0cb9-4738-af64-8d3fbd1c07c0
md"""
Finally, to get our result from the GPU we then just use the `Array` constructor
```julia
Array(outlarge_gpu)
```
"""

# ╔═╡ 3f4daf38-704e-41b0-94f1-d10043d8fb5b


# ╔═╡ 32d560e6-c5de-4740-81ba-dccc717d9677
md"""
And there you go, you just wrote your first native CUDA kernel within Julia! Unlike other programming languages, we can use native Julia code to write our own CUDA kernels and do not have to go to a lower-level language like C.
"""

# ╔═╡ 6be7f9a4-7c80-4c2b-8dfb-080609f716e8
md"""
### GPU caveats

#### Dynamic Control Flow
GPUs, in general, are more similar to SIMD than any other style of parallelism mentioned in
this tutorial. That is, GPUs follow the **Single Program Multiple Data** paradigm. What this
means is that GPUs will experience the fastest programming when the exact same program will
be run across all the processors on the system. In practice it means that a program with control flow such as

```julia
if a > 1
	# Do something
else
	# Do something else
```

will potentially be slow. The reason is that, in this case, the GPU will actually compute
both branches at run-time and then select the correct value. Therefore, GPU programs should
generally try to limit this kind of dynamic control flow. You may have noticed this when
using JAX. JAX tries to restrict the user to static computation graphs
(no dynamic control flow) as much as possible for this exact reason. GPUs are not good with
dynamical control flow.

#### GPU memory
Another important consideration is the time it takes to move memory on and off of the GPU.
To see how long this takes let's benchmark the cu function which move memory from the CPU to the GPU.
"""

# ╔═╡ 56a8891c-8993-43f9-bfff-81b520b10b88
md"""
```julia
@benchmark cu($xlarge)
```

!!! tip
	Replace `cu` with the correct GPU array call for your specific provider
"""

# ╔═╡ 3522798d-7e38-4db6-91b6-474e5d8d9119


# ╔═╡ 619ff9da-9562-4bd9-be89-69482091cdba
md"""
Similarly we can benchmark the time it takes to transform from the GPU to the CPU.

```julia
@benchmark Array($outlarge_gpu)
```
"""

# ╔═╡ d9a844e5-de7b-4266-85ea-01f27f2932c2


# ╔═╡ 8d6d2117-3513-470f-87e1-8f00dd340172
md"""
In both cases, we see that the just data transfer takes substantially longer than the computation
on the GPU! This is a general "feature" of GPU programming. Managing the data transfer
between the CPU and GPU is critical for performance. In general, when using the GPU you should aim
for as much of the computation to be performed on the GPU as possible. A good rule of thumb is
that if the computation on the CPU takes more than 1 ms, then moving it to the GPU will probably have some benefit.
"""

# ╔═╡ b2eb604f-9180-4e48-9ae5-04162583fb33
md"""

## Distributed Computing (Switch to the REPL here)

Distributed computing differs from all other parallelization strategies we have used.
Distributed computing is when multiple independent processes are used together for computation.
That is, unlike multi-threading, where each process lives in the Julia session, distributed
computing links multiple **separate** Julia sessions together.

As a result, each processor needs to communicate with the other processors
through message passing, i.e., sending data (usually through a network connection) from
one process to the other. The downside of this approach is that this communication
entails additional overhead compared to the other parallelization strategies we mentioned
previously. The upside is that you can link arbitrarily large numbers of processors and
processor memory together to parallelize the computation.

Julia has a number of different distributed computing facilities, but we will focus on Distributed.jl
the one supported in the standard library [`Distributed.jl`](https://tdocs.julialang.org/en/v1/manual/distributed-computing/).

### Distributed.jl (Manager-Worker parallelism)

Distributed's multiprocessing uses the **manager-worker** paradigm. This is where the programmer
controls the manager directly and then it assigns tasks to the rest of the workers.
To start multiprocessing with Julia, there are two options

1. `julia -p 3` will start julia with 3 workers (4 processes in total). This will also automatically bring the Distributed library into scope
2. Is to manually add Julia processors in the repl. To do this in a fresh Julia session,

we do

````julia
using Distributed
addprocs(3)
````

!!! note
    On HPC systems, you can also use [`ClusterManagers.jl`] (https://github.com/JuliaParallel/ClusterManagers.jl)
    to setup a distributed environment using different job queue systems, such as Slurm and SGE.

This add 3 worker processors to the Julia process. To check the id's of the workers we
can use the `workers` function

````julia
workers()
````

We see that there are three workers with id's 2, 3, 4. The manager worker is always given the first id `1` and corresponds to the current Julia session. To see this we can use the `myid()` function

````julia
myid()
````

To start a process on a separate worker process, we can use the `remotecall` function

````julia
f = remotecall(rand, 2, 4, 4)
````

The first argument is the function we wish to call on the worker, the second argument is the id of the worker, and the rest of the arguments are passed to the function.
One thing to notice is that `remotecall` doesn't return the actual result of the computation. Instead `remotecall` returns a `Future`. This is because we don't necessarily need to return the result of the computation to the manager processor, which would induce additional communication costs. However, to get the value of the computation you can use the `fetch` function

````julia
fetch(f)
````

`remotecall` is typically considered a low-level function. Typically a user will use the
`@spawnat` macro

````julia
f2 = @spawnat :any rand(4, 4)
````

This call does the same thing as the `remotecall` function above but the first argument is the worker id which we
set to any to let Julia itself decide which processor to run it on.

### Loading modules on a Distributed system
Since Julia uses a manager-worker workflow, we need to manually ensure that every process has access to all the required data. For instance, suppose we wanted to compute the mean of a vector. Typically, we would do

````julia
using Statistics
mean(rand(1000))
````

Now if we try to run this on processor 2 we get

````julia
fetch(@spawnat 2 mean(rand(1000)))
````

I.E., the function `mean` is not defined on worker 2. This is because
`using Statistics` only brought Statistics into the scope of the manager process. If we
want to load this package on worker 2 we then need to run

````julia
fetch(@spawnat 2 eval(:(using Statistics)))
````

Rerunning the above example gives the expected result

````julia
fetch(@spawnat 2 mean(rand(1000)))
````

Now calling this in every process could potentially be annoying. To simplify this Julia
provides the `@everywhere` macro

````julia
@everywhere using Statistics
````
which loads the module Statistics on every Julia worker and manager processor.

### Distributed computation
While remotecall and `spawnat` provide granular control of multi-processor parallelism often
we are interested in loop or map-reduce based parallelism. For instance, suppose we consider
our previous map or `apply_sum` function. We can easily turn this into a distributed program
using the `@distributed` macro

````julia
function distributed_apply_sum(f, x)
    @distributed (+) for i in eachindex(x)
        f(x[i])
    end
end
d = randn(1_000_000)
using BenchmarkTools
@benchmark distributed_apply_sum($(x->exp(-x)), $d)
````

!!! note
    We did not have to define

One important thing to note is that the distributed macro uses Julia's static scheduler. This means that the for loop is automatically split evenly among all workers. For the above calculation this make sense since `f` is a cheap variable. However, suppose that `f` is extremely expensive and its run time varies greatly depending on its argument. A trivial example of this would be

````julia
@everywhere function dynamic_f(x)
    if abs(x) < 1
        return x
    else
        sleep(5)
        return 2*x
    end
end
````

In this case, rather than equally splitting the run-time across all processes, it makes sense to assign work to processors as they finish their current task. This is known as a **dynamic scheduler** and is provided in julia by `pmap`

````julia
x = randn(10)
@time out = pmap(dynamic_f, x)
````

which is 2x faster than using the usual distributed function

````julia
@time out = distributed_apply_sum(dynamic_f, x)
````

However, for cheaper operations

````julia
@btime out = sum(pmap(exp, x))
@btime out = distributed_apply_sum(exp, d)
````

we find that `@distributed` is faster since it has less communication overhead. Therefore, the general recommendation is to use `@distributed` when reducing over cheap and consistent function, and to use `pmap` when the function is expensive.

## Conclusion

In this tutorial we have shown how Julia provides an extensive library of parallel computing facilities. From single-core SIMD, to multi-threading, GPU computing, and distributed computation. Each of these can be used independently or together.

In addition to the packages used in this tutorial, there are several other
potential parallel processing packages in the Julia ecosystem. Some of these are:

- [`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl): Similar to the python dask package that represents parallel computation using a directed acylic graph or DAG. This is built on Distributed and is useful for a more functional approach to parallel programming. It is more common in data science applications
- [`MPI.jl`](https://github.com/JuliaParallel/MPI.jl): The Julia bindings to the MPI standard. The standard parallel workhorse in HPC.
- [`Elemental.jl`](https://github.com/JuliaParallel/Elemental.jl) links to the C++ distributed linear algebra and optimization package.
- [`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl)

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
FLoops = "cc61a311-1640-44b5-9fba-1b764f453329"
LoopVectorization = "bdcacae8-1622-11e9-2a5c-532679323890"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.2"
CUDA = "~3.12.0"
FLoops = "~0.2.1"
LoopVectorization = "~0.12.142"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.4"
manifest_format = "2.0"
project_hash = "d7b42c1a752400bf43102508b531987b90cca1eb"

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

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["ArrayInterfaceCore", "Compat", "IfElse", "LinearAlgebra", "Static"]
git-tree-sha1 = "6d0918cb9c0d3db7fe56bea2bc8638fc4014ac35"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "6.0.24"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "badccc4459ffffb6bce5628461119b7057dec32c"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.27"

[[deps.ArrayInterfaceOffsetArrays]]
deps = ["ArrayInterface", "OffsetArrays", "Static"]
git-tree-sha1 = "3d1a9a01976971063b3930d1aed1d9c4af0817f8"
uuid = "015c0d05-e682-4f19-8f0a-679ce4c54826"
version = "0.1.7"

[[deps.ArrayInterfaceStaticArrays]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceStaticArraysCore", "LinearAlgebra", "Static", "StaticArrays"]
git-tree-sha1 = "f12dc65aef03d0a49650b20b2fdaf184928fd886"
uuid = "b0d46f97-bff5-4637-a19a-dd75974142cd"
version = "0.1.5"

[[deps.ArrayInterfaceStaticArraysCore]]
deps = ["Adapt", "ArrayInterfaceCore", "LinearAlgebra", "StaticArraysCore"]
git-tree-sha1 = "93c8ba53d8d26e124a5a8d4ec914c3a16e6a0970"
uuid = "dd5226c6-a4d4-4bc7-8575-46859f9c95b9"
version = "0.1.3"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BFloat16s]]
deps = ["LinearAlgebra", "Printf", "Random", "Test"]
git-tree-sha1 = "a598ecb0d717092b5539dbbe890c98bac842b072"
uuid = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
version = "0.2.0"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "7fe6d92c4f281cf4ca6f2fba0ce7b299742da7ca"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.37"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "a7157ab6bcda173f533db4c93fc8a27a48843757"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.30"

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

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "d61300b9895f129f4bd684b2aff97cf319b6c493"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.11"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.ContextVariablesX]]
deps = ["Compat", "Logging", "UUIDs"]
git-tree-sha1 = "25cc3803f1030ab855e383129dcd3dc294e322cc"
uuid = "6add18c4-b38d-439d-96f6-d6bc489c04c5"
version = "0.1.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "c5b6685d53f933c11404a3ae9822afe30d522494"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.12.2"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.FLoops]]
deps = ["BangBang", "Compat", "FLoopsBase", "InitialValues", "JuliaVariables", "MLStyle", "Serialization", "Setfield", "Transducers"]
git-tree-sha1 = "ffb97765602e3cbe59a0589d237bf07f245a8576"
uuid = "cc61a311-1640-44b5-9fba-1b764f453329"
version = "0.2.1"

[[deps.FLoopsBase]]
deps = ["ContextVariablesX"]
git-tree-sha1 = "656f7a6859be8673bf1f35da5670246b923964f7"
uuid = "b9860ae5-e623-471e-878b-f6a53c775ea6"
version = "0.1.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "a69dd6db8a809f78846ff259298678f0d6212180"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.34"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "f64b890b2efa4de81520d2b0fbdc9aadb65bdf53"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.13"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

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

[[deps.JuliaVariables]]
deps = ["MLStyle", "NameResolution"]
git-tree-sha1 = "49fb3cb53362ddadb4415e9b73926d6b40709e70"
uuid = "b14d175d-62b4-44ba-8fb7-3064adc8c3ec"
version = "0.2.4"

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

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "7e34177793212f6d64d045ee47d2883f09fffacc"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.12"

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

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SIMDTypes", "SLEEFPirates", "SnoopPrecompile", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "f63e9022be00102b6d135b3363680e5befa8e227"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.142"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MLStyle]]
git-tree-sha1 = "060ef7956fef2dc06b0e63b294f7dbfbcbdc7ea2"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.16"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "4d5917a26ca33c66c8e5ca3247bd163624d35493"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.3"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NameResolution]]
deps = ["PrettyPrint"]
git-tree-sha1 = "1a0fa0e9613f46c9b8c11eee38ebb4f590013c5e"
uuid = "71a1bf82-56d0-4bbc-8a3c-48b961074391"
version = "0.1.5"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "f71d8950b724e9ff6110fc948dff5a329f901d64"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.8"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "050ca4aa2ca31484b51b849d8180caf8e4449c49"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.11"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyPrint]]
git-tree-sha1 = "632eb4abab3449ab30c5e1afaa874f0b98b586e4"
uuid = "8162dcfd-2161-5ef2-ae6c-7681170c5f98"
version = "0.2.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

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

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "dd4195d308df24f33fb10dde7c22103ba88887fa"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.1"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "c8679919df2d3c71f74451321f1efea6433536cc"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.37"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

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

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "c35b107b61e7f34fa3f124026f2a9be97dea9e1c"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.3"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "ffc098086f35909741f71ce21d03dadf0d2bfa76"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.11"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f2fd3f288dfc6f507b0c3a2eb3bac009251e548b"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.22"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "c42fa452a60f022e9e087823b47e5a5f8adc53d5"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.75"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "fc79d0f926592ecaeaee164f6a4ca81b51115c3b"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.56"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

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
# ╟─e17b15bd-337d-4809-8b6c-2ed0f3701a9e
# ╟─c989d4b7-c566-49a4-84fe-28b0e8f8c963
# ╟─e6020e3a-77c7-11ed-2be9-e987cee1edf0
# ╟─fb75265d-b154-4913-8714-ee68959682b4
# ╟─c23fcdf1-4fd8-4859-abb3-8e08b4476046
# ╟─766c47e4-f8ff-4d5b-868a-d13b52a8a1c1
# ╟─b8e1a548-9c4d-40f1-baf3-c833151e7eba
# ╟─a1f9058a-9c7f-494e-9b73-f5acc4778604
# ╟─441099b3-4103-4cff-9deb-3c2153d657c6
# ╠═8c198d15-4367-44e8-9de0-43a468bfbac2
# ╟─cadf8a67-1c1e-4850-9723-ef92196671dd
# ╟─9fede501-3324-4076-a2ff-3b464063e5c9
# ╠═7f5c5849-feef-4581-9356-8146cba48b9e
# ╠═799e73d9-4857-466e-b645-8ee15566b03f
# ╠═d490a507-4b9d-4077-9eaf-ae4ac3d149a1
# ╠═7be8c14e-e258-4deb-abdf-a042f873465a
# ╠═d8ff3dd3-e1ea-4f20-8937-8f8f995402fa
# ╟─cc00d185-1b7e-40f5-8036-da4132dc0700
# ╠═576491d9-0c0c-4740-b73a-165c61ce3fed
# ╟─34ad1196-a1d7-4118-b4da-426af6826c7d
# ╠═7623b88a-ba60-450e-86fb-8890354f7a94
# ╟─a872cf65-a11e-4371-9d4d-41ea92c55369
# ╠═547df3f2-b2fe-4f22-a0ac-3ba6bdd3171c
# ╟─57bd871d-06fc-4050-9024-aaaf52297d0a
# ╠═f51bd7cb-97fd-4d5e-bcac-a114f19abe7d
# ╟─566eb7e1-0e2f-4ea7-8770-a6b2c95c1eb4
# ╠═e4e98981-1964-43a3-aa81-4fef27d7f864
# ╟─7f0ff927-71ea-4ab9-99aa-c4a6655b545c
# ╠═d774d485-cfef-4373-9fed-77618ea928de
# ╟─ccf102f3-9e85-4f70-b65e-6b4b056cf7e3
# ╠═fb6f9256-e874-418a-b226-83a9173b9ec2
# ╟─540326cd-5f2c-4b07-8dd6-1c65f63af7d6
# ╟─1364924b-0cbd-443d-a319-9701708cbd15
# ╟─54d083d4-3bf8-4ed7-95b5-203e13cc3249
# ╠═c6228b0b-22b8-4e3d-95d2-350987544b85
# ╟─b9e13054-7641-45f1-8cd6-c8565a9f5d1f
# ╠═11f7af26-92d5-4430-bdde-5aad69859f2e
# ╟─d1bae4b3-6455-458b-a00c-f7e8eda201c3
# ╟─3214e9e9-bcae-43b4-8e07-e8106310cf83
# ╟─e468d9fd-ead0-4ce4-92b1-cb96132f6921
# ╠═f9841e19-68ad-411e-88c6-363996b7a95c
# ╟─478eaa1d-509a-4fba-8b65-cb45561f9157
# ╠═14b676f0-b3b3-41a0-8f08-80b4fae29ec3
# ╟─c815af66-cb82-4dd0-a4b8-3c9cb4a8d9f2
# ╠═5852589e-388c-43bf-9ff5-da46af141680
# ╠═69ada451-8806-4398-933a-e02efb28deea
# ╠═8ebab57a-d4e5-4d50-8c5b-a95ed51487c9
# ╟─c06da2eb-ed9f-4986-854c-9b8d830e662b
# ╠═54b2e366-f409-4603-a57a-b711202c4887
# ╟─07eddd9c-c53f-49e7-9d61-2f5d54711a1c
# ╠═b5666e45-dcf6-4ea8-9e83-7609f2091f83
# ╟─45639208-ec9f-4aef-adb0-7a2c4467353a
# ╟─bd78505c-904c-4e65-9160-6b3ebf02c21e
# ╠═1ee1af8c-191c-4677-84fc-2cdeac39607c
# ╟─32068e63-5ad5-4d0d-bee6-205597db610b
# ╠═d7ad4f01-2f7e-4dcc-8e32-88ebbf807a06
# ╟─5c5ce94e-1411-4b26-af48-2cd836b0857c
# ╠═df637f5c-d702-4e7d-81f5-cbefac75c13b
# ╟─f4602617-c87b-4ce9-bbd0-7d3715b5c7e1
# ╠═bd6bd1e9-66bf-421d-bb7b-4be4528a2701
# ╟─2a9f6170-b3d6-4fbb-ba48-2f82098b3849
# ╟─0fbce4a6-0a0c-4251-be50-c13add4c4768
# ╠═1f3b66c5-2845-4f3f-befd-e7e94243368c
# ╠═74ff761d-b1e4-4468-8f24-77fb84bda8ac
# ╟─73097493-1abe-4c6e-9965-9dde6c97611e
# ╟─aad7b000-7f4b-4901-8513-078eae85ca67
# ╟─2969c283-4105-4c25-ae39-9e169c195f00
# ╠═c037381a-8b6e-4bfa-b39a-e8c6ed264f71
# ╟─21de2f77-b5ed-4b62-94e3-ca6e22a80e43
# ╠═cc4990eb-74f3-4b57-9b1d-0689fb2f6604
# ╟─79222f00-3d55-4914-9d9d-b3c7b1ed6c69
# ╠═6b496229-98bf-4312-9faf-f22aae633843
# ╟─4768f5c4-b37b-4667-9b42-d0352c8b5dde
# ╠═f82d29b5-4d18-4c66-9703-9445b205d1ff
# ╟─dfa50bc7-2250-4326-b7a6-724a975c4928
# ╠═463eab77-8c30-4071-bf84-a1aad685c21e
# ╟─c8b7983f-295d-4ca4-9810-e0f130c5e92c
# ╠═7912e780-59cd-46d6-8a3a-a1eb47b6f9cf
# ╟─a14e0cb2-42b5-41ea-a2f3-83a725baf38c
# ╟─44ddfdd9-7898-4561-b46a-045bcc1ae467
# ╠═256ca1f5-403f-4eb3-8422-19724fa95526
# ╟─872a2066-8c51-4597-89e8-5a902f40c2cc
# ╠═23cf56d9-b53e-4be6-8dae-a6ebb8e0f6a4
# ╟─df842625-04af-43d0-b802-3e4a9841c172
# ╠═4f23d7c3-6d85-4d03-8d05-dd0719ebcbe3
# ╟─529f73c3-b8ba-4b4b-bab1-7aa84c2a3a29
# ╟─e7163af8-3534-44fc-8e8f-ef1c692c972e
# ╟─9d9d3fff-37d8-4773-816f-411fb79679f5
# ╠═72cd207c-7a63-4e29-a6d8-110bcf65ecdc
# ╟─799de936-6c6d-402f-93db-771e7ec1ef51
# ╠═5215d6a5-5823-4d3b-9086-ebd975d4393b
# ╟─0116005e-c436-4dad-89bd-47260cfa706f
# ╟─0218d82e-35b4-4109-bbc8-b1d51c97ab6f
# ╠═d7fdf09a-3c59-4dba-b089-ae6033b57809
# ╟─891a9803-7fd0-4a83-95ab-58b9bd44f8f2
# ╟─7ce8025e-16be-47e0-988d-85947cc4e359
# ╠═6b34f668-25d1-4c9b-8c1a-d08fcdc5dea0
# ╟─2020675b-859b-4939-9f8d-138995ce1d18
# ╟─147bbd17-abf6-465f-abd0-895cb742f896
# ╠═1e88e7c1-f239-4da1-8af8-4f629ef86cb7
# ╟─ccf924ae-fada-4635-af68-ab1fb612a5bc
# ╟─144bb14e-861a-4665-8b50-513b0f463546
# ╟─13085fcb-75db-41ec-b8ad-b509798037d7
# ╠═751950c0-ccae-4316-91cf-089ddaae95ad
# ╟─4c7383d8-c7ac-48c0-814d-abc7cfc7c447
# ╟─175e02af-6762-474f-a728-e77a2f6fa771
# ╠═d3e64cea-3b29-4d8b-8ee1-1353674c1d89
# ╟─e4ca8a18-1bc9-4730-95ae-d2a1edc30114
# ╟─bebb0e97-cfb3-46ac-80aa-2ada3159e4f5
# ╠═759be8ef-7136-4330-abfe-0ffd212883d3
# ╟─6b40113f-5017-4530-9d76-fadeab58973c
# ╟─a5688604-240e-4d5d-8252-672fc789cd05
# ╟─e1964067-d3e7-4903-a17d-0606a6bc281e
# ╠═d895744d-888d-45ff-a7e5-8865be535194
# ╟─8ff25eb9-a32f-410f-a430-d123c2f3c884
# ╟─c6436555-0cb9-4738-af64-8d3fbd1c07c0
# ╠═3f4daf38-704e-41b0-94f1-d10043d8fb5b
# ╟─32d560e6-c5de-4740-81ba-dccc717d9677
# ╟─6be7f9a4-7c80-4c2b-8dfb-080609f716e8
# ╟─56a8891c-8993-43f9-bfff-81b520b10b88
# ╠═3522798d-7e38-4db6-91b6-474e5d8d9119
# ╟─619ff9da-9562-4bd9-be89-69482091cdba
# ╠═d9a844e5-de7b-4266-85ea-01f27f2932c2
# ╟─8d6d2117-3513-470f-87e1-8f00dd340172
# ╟─b2eb604f-9180-4e48-9ae5-04162583fb33
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
