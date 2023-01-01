# AAS Julia Workshop

[**Jump to setup instructions**](#setup)

[**Jump to workshop contents**](#workshop-contents)

This repository contains material for the AAS 241 workshop "An Introduction to the Julia Programming Language"

Date: **Saturday, 7 January, 9:00 am - 5:00 pm (In-person)**

Note: Registration for this in-person event has already closed.


The Julia programming language can be considered the successor to Scientific Python (SciPy). The language is designed for scientific computing by having built-in multidimensional arrays and parallel processing features. Yet, it can also be used as a general-purpose programming language like Python. Unlike Python, Julia solves the two-language problem by using just-in-time (JIT) compilation to generate machine code from high level expressions. In most cases, Julia is as fast as C, and in some cases faster. Julia is also a composable language, so independent libraries or packages usually work well together without any modification. These important features make Julia a very productive language for scientific software development by reducing the number of lines of code.

The objectives of this tutorial are: (1) to introduce astronomers and software developers to the basic language syntax, features, and power of the Julia programming language, (2) to compare and contrast Julia’s design features to those of C/C++ and Python, and (3) to show that Julia provides an easy migration path from languages such as C/C++, FORTRAN, and Python. In other words, it is not necessary to rewrite all of your code all at once.

The tutorial will begin with simple interactive command-line (REPL) examples that emphasize important concepts and features of the language; namely, unicode characters, multidimensional arrays, data types or structures, functions, multiple dispatch, and namespaces. It will then combine these basic concepts to demonstrate some important features of the language; namely, composability, the two-language problem and benchmarking, the standard library, plotting, interfacing to other languages, symbolic manipulation, package management, and parallel processing and GPUs. 


## Setup

We will be using Julia and Pluto notebooks. Please follow these installation instructions before the start of the workshop. If you run into to difficulties, please feel free to contact the organizers or let us know at the start of the workshop.

Note: Pluto notebooks are not compatible with Jupyter.

### Installing Julia
Please [install the latest stable version of Julia](https://julialang.org/downloads/) (1.8.4 as of December, 2022) on you computer. Make sure to use the links on the official Julia website linked above, rather than any 3rd party package manager (e.g. homebrew, apt, nuget, etc.).

For more advanced users, [JuliaUp](https://github.com/JuliaLang/juliaup) can be used to install, update, and switch between versions of Julia. 

<details>
<summary>MacOS Instructions</summary>
If you have a new mac with an M1 processor, make sure to select the "M-series Processor" link for improved performance.
</details>

<details>
<summary>Windows Instructions</summary>
This <a href="https://www.microsoft.com/store/apps/9NJNWW8PVKMN">Microsoft Store</a> link can also be used to install JuliaUp.

We strongly recomend you use the Windows Terminal included in Windows 11 or downloadable from this <a href="https://aka.ms/terminal">Microsoft Store link</a>. Windows Terminal has improved font and math symbol rendering compared to the antiquated `cmd.exe`.
</details>

<details>
<summary>Linux Instructions</summary>
After downloading the correct version of Julia for your operating system, expand the archive (e.g. <code>tar -xvf julia-xyz.tar.gz</code>) and place the binary <code>julia-xyz/bin/julia</code> in your <code>PATH</code>.

The versions of Julia included in OS package managers (yum, apt, pacman, etc) frequently have bugs not seen in the offical binaries and should be avoided. For more information, <a href="https://julialang.org/downloads/platform/#a_brief_note_about_unofficial_binaries">see here</a>.
</details>

<details>
<summary>Docker</summary>
Julia runs in lightweight, self-contained environments. It is therefore not usually necessary to install Julia within Docker for the sake of reproducibility.
</details>

Once you have installed Julia, run the following command in your terminal to install Pluto:
```bash
julia -e 'using Pkg; Pkg.add("Pluto")'
```

Set the desired number of threads Julia should run with using an environment variable:
**Windows:**
```cmd
SET JULIA_NUM_THREADS=auto
```
**Mac & Linux:**
```bash
export JULIA_NUM_THREADS=auto
```


Then, in the same terminal, start Julia by running:
```bash
julia
```

To start Pluto, run the following from inside Julia:
```julia-repl
julia> using Pluto
julia> Pluto.run()
```

### Note on Python
In one section, we will demonstrate how you can use Python libraries inside Julia. You do not have to have a Python installed in advance.

## Workshop Contents

The material for each section is stored as a [Pluto notebook](https://plutojl.org/). 

Copy the link for a given section below and paste it into the "Open a Notebook" box in Pluto.

The morning content is a single notebook, while the afternoon is split into multiple topics.

| Topic | Link | 
|-------|------|
| 1. Intro to Julia | https://github.com/sefffal/AASJuliaWorkshop/raw/main/1-intro-to-julia.jl |
| 2. Using Python Libraries | |
| 3. Using Macros | |
| 4. Astronomy Packages | https://github.com/sefffal/AASJuliaWorkshop/raw/main/4-astro-packages.jl|
| 5. Code Optimization | |
| 6. Parallel Computing | |
| 7. Creating Packages | https://github.com/sefffal/AASJuliaWorkshop/raw/main/7-creating-packages.jl | 
| 8. Questions and Special Topics | |


<!--
my sections:
Getting started (add a little about making sure eveyrone is installed)
elementary functions
mathematical operations
multi dimensional arrays
parallel computing

paul does the rest. Feel free to make changes to my subsections.

Afternoon:
pycall (PB)
macros (PB)
astronomy packages (WT)
optimization (PB)
parallel computing (WT)
creating packages (WT)
questions special topics


put creating packages second to last

I will volunteer to put this all in the readme in a nice format

Also put multiple dispatch into making your own package section
And overloading base functions example.
Warning about type piracy


1. ...
2. ...
3. Astronomy packages in Julia `https://github.com/sefffal/AASJuliaWorkshop/raw/main/3-astro-packages.jl`



-----
This repository contains material prepared for the AAS 241 meeting workshop titled "introduction to Julia".


* Basic Concepts
    * Plotting
    * Multiple dispatch (Julia) vs single dispatch (Python)
* Advanced topics
  * PyCall & PythonCall - PB
  * Using Macros - PB
  * Optimization: types, dot notation - PT
  * Creating a package w/function generation - WT
  * Parallel Computing: vectorization, threads, distributed, GPU - PT
  * Astronomy packages - WT
  * Questions/special topics
-->
