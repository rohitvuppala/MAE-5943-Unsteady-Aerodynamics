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
	X = range(-3.5, 3.5, length=100)
	Y = range(-3.5, 3.5, length=100)
	Z = [x + im*y for y in Y, x in X]
end

# ╔═╡ 682ca32e-1568-11eb-35b2-15925e38f564
md"""
### Wall on the x-axis
"""

# ╔═╡ 7acb2d90-1568-11eb-2e53-f5b7e59f6c3d
md"""
Y location of vortexes: $(@bind Δy Slider(0.0:0.1:5.0,default = 1.0))
"""

# ╔═╡ b0349b90-1565-11eb-03e8-cf9127144400
begin
	points = Vortex.Point.([Δy*im, -Δy*im], [1, -1])
	streamlines(X, Y, points, 
		color = cgrad([:black, :black]), 
		ratio = 1, 
		legend = false, 
		markerstrokealpha = 0, 
		grid = false,
		xlim = (-3.5, 3.5),
		ylim = (-3.5, 3.5))
end

# ╔═╡ 492f49b0-1568-11eb-28e1-0117b5154488
md"""
### Translate and Rotate the wall
"""

# ╔═╡ ba5a0330-156a-11eb-39db-85c8b88ad474
md"""
X location of vortexes: $(@bind Δx Slider(-2.0:0.1:2.0,default = 0.0))
"""

# ╔═╡ 748be780-1568-11eb-378b-75977d19d825
begin
	
	fs = Freestreams.Freestream(1.0)
	db = Doublets.Doublet(0.0im, π)
	
	point_vortex = Vortex.Point(Δx + 1.2im, 2π)
	image_vortex = Vortex.Point(conj(1/point_vortex.z), -2π)
	
	ψ_levels = collect(range(-5, 5, length=31))
	
	images = streamlines(X, Y, (fs,db,point_vortex,image_vortex), 
		color = cgrad([:black, :black]), 
		ratio = 1,
		levels = ψ_levels,
		legend = false, 
		grid = false,
		xlim = (-3.5, 3.5),
		ylim = (-3.5, 3.5))
	
	plot!(cos.(0:0.1:2π), sin.(0:0.1:2π), linestyle = :dash, linewidth = 3, color = :red)
	
end

# ╔═╡ 27299cc0-1569-11eb-1e3d-f7188084f732
point_vortex.z

# ╔═╡ 24496030-1569-11eb-27d6-3d2fa7417c1a
conj(point_vortex.z)

# ╔═╡ bf594c00-1566-11eb-1acd-31fb57d91e48
md"""
### System of vortexes
"""

# ╔═╡ d4d166c0-1567-11eb-07d6-23315632cff4
md"""
Γ1: $(@bind Γ₁ Slider(-2π:π/10:2π,default = 1.0))
Γ2: $(@bind Γ₂ Slider(-2π:π/10:2π,default = 1.0))
Γ3: $(@bind Γ₃ Slider(-2π:π/10:2π,default = -1.0))
Γ4: $(@bind Γ₄ Slider(-2π:π/10:2π,default = -1.0))
"""

# ╔═╡ 2e843420-1538-11eb-14b2-d9ab38fa091b
begin
	
	zs = [1 + im, -1 + im, -1 - im, 1 - im]
	
	vs = Vortex.Point.(zs, [Γ₁, Γ₂, Γ₃, Γ₄])
	
	streamlines(X, Y, vs, 
		color = cgrad([:black, :black]), 
		ratio = 1, 
		legend = false, 
		grid = false,
		xlim = (-3.5, 3.5),
		ylim = (-3.5, 3.5))
	
	plot!(vs, markersize = 10, color = :RdBu)
	
end

# ╔═╡ be75d460-1567-11eb-39d5-0f62c8c97fd8


# ╔═╡ Cell order:
# ╟─97a34c00-153a-11eb-0b35-e92e0aafac5e
# ╠═0d696b90-14b9-11eb-19c6-7110e9eded9e
# ╠═59e4bc40-14b9-11eb-3670-cdc8fa8f0ded
# ╟─682ca32e-1568-11eb-35b2-15925e38f564
# ╟─7acb2d90-1568-11eb-2e53-f5b7e59f6c3d
# ╠═b0349b90-1565-11eb-03e8-cf9127144400
# ╠═492f49b0-1568-11eb-28e1-0117b5154488
# ╟─ba5a0330-156a-11eb-39db-85c8b88ad474
# ╠═748be780-1568-11eb-378b-75977d19d825
# ╠═27299cc0-1569-11eb-1e3d-f7188084f732
# ╠═24496030-1569-11eb-27d6-3d2fa7417c1a
# ╟─bf594c00-1566-11eb-1acd-31fb57d91e48
# ╠═d4d166c0-1567-11eb-07d6-23315632cff4
# ╠═2e843420-1538-11eb-14b2-d9ab38fa091b
# ╠═be75d460-1567-11eb-39d5-0f62c8c97fd8
