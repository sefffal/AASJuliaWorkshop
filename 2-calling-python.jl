### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 3ba5672b-18ff-4320-a4d2-954e0b873d47
using PlutoUI; TableOfContents()

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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "502a5e5263da26fcd619b7b7033f402a42a81ffc"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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
# ╟─3ba5672b-18ff-4320-a4d2-954e0b873d47
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
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
