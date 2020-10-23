### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 0d696b90-14b9-11eb-19c6-7110e9eded9e
using PotentialFlow

# ╔═╡ 40e53300-14b9-11eb-28ca-c39ecf8c05ef
using Plots

# ╔═╡ 59e4bc40-14b9-11eb-3670-cdc8fa8f0ded
begin
	X = range(-1, 1, length=101)
	Y = range(-1, 1, length=101)
	Z = [x + im*y for y in Y, x in X]
end

# ╔═╡ 27ebaaf0-14be-11eb-3b42-d3c031377d61
begin
	
	v2 = Vortex.Point(0.0, 2)
    
	ψ = streamfunction(Z,v2)
	
	contour(X, Y, ψ,
		color = cgrad([:red, :blue]), 
		grid = false, 
		legend = false, 
		ratio = 1,
		xlim = (-1, 1),
		ylim = (-1, 1),)


end

# ╔═╡ 2e843420-1538-11eb-14b2-d9ab38fa091b
begin
	
	vs = Vortex.Point.(rand(ComplexF64, 10), π*rand(10))
    fs = Freestreams.Freestream(rand(ComplexF64))
	
	ψs = streamfunction(Z,(vs,fs))
	
	contour(X, Y, ψs,
		color = cgrad([:red, :blue]), 
		grid = false, 
		legend = false, 
		ratio = 1,
		xlim = (0, 1),
		ylim = (0, 1),)


end

# ╔═╡ e0cf3580-1538-11eb-1ba8-1baff87ba9e1
md""" 
### Flow over a cylinder 
"""

# ╔═╡ Cell order:
# ╠═0d696b90-14b9-11eb-19c6-7110e9eded9e
# ╠═40e53300-14b9-11eb-28ca-c39ecf8c05ef
# ╠═59e4bc40-14b9-11eb-3670-cdc8fa8f0ded
# ╠═27ebaaf0-14be-11eb-3b42-d3c031377d61
# ╠═2e843420-1538-11eb-14b2-d9ab38fa091b
# ╟─e0cf3580-1538-11eb-1ba8-1baff87ba9e1
