### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 0d696b90-14b9-11eb-19c6-7110e9eded9e
begin
	using PotentialFlow
	using Plots
	using PlutoUI
end

# ╔═╡ 97a34c00-153a-11eb-0b35-e92e0aafac5e
md""" 
### Flow over a cylinder 
"""

# ╔═╡ 59e4bc40-14b9-11eb-3670-cdc8fa8f0ded
begin
	X = range(-3.5, 3.5, length=101)
	Y = range(-3.5, 3.5, length=101)
	Z = [x + im*y for y in Y, x in X]
end

# ╔═╡ ede98510-153b-11eb-1e6d-b1e9ad472350
md"""
Doublet strength: $(@bind doublet_strength Slider(0:π/10:2π, default = π))
"""

# ╔═╡ 3d84d310-153f-11eb-1520-17b8af3cf1d0
md"""
X location: $(@bind Δx Slider(-5.0:0.1:5.0,default = 0.0))
"""

# ╔═╡ 7a6a3060-153d-11eb-0208-a9fc8710ab9a
md"""
Y location: $(@bind Δy Slider(-5.0:0.1:5.0,default = 0.0))
"""

# ╔═╡ 2e843420-1538-11eb-14b2-d9ab38fa091b
begin
	
    fs = Freestreams.Freestream(1.0)
	Δx1 = convert(Float64,Δx)
	Δy1 = convert(Float64,Δy)
	location = (Δx1 + Δy1*im) 
	
	db = Doublets.Doublet(location, doublet_strength)
	
	ψ_levels = collect(range(-5,5,length=31))
	
	streamlines(X, Y, (fs,db), 
		levels = ψ_levels, 
		color = cgrad([:black, :black]), 
		ratio = 1, 
		legend = false, 
		markerstrokealpha = 0, 
		grid = false,
		xlim = (-3.5, 3.5),
		ylim = (-3.5, 3.5))
	
	#circular cylinder
	plot!(cos.(0:0.1:2π), sin.(0:0.1:2π), linestyle = :dash )


end

# ╔═╡ Cell order:
# ╟─97a34c00-153a-11eb-0b35-e92e0aafac5e
# ╠═0d696b90-14b9-11eb-19c6-7110e9eded9e
# ╠═59e4bc40-14b9-11eb-3670-cdc8fa8f0ded
# ╠═ede98510-153b-11eb-1e6d-b1e9ad472350
# ╠═3d84d310-153f-11eb-1520-17b8af3cf1d0
# ╠═7a6a3060-153d-11eb-0208-a9fc8710ab9a
# ╠═2e843420-1538-11eb-14b2-d9ab38fa091b
