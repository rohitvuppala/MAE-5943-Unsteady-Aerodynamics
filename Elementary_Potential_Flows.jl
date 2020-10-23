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
	X = range(-1, 1, length=21)
	Y = range(-1, 1, length=21)
	Z = [x + im*y for y in Y, x in X]
end

# ╔═╡ 7eee64f0-14b9-11eb-2c53-650b51c7db37
begin
	freestream = Freestreams.Freestream(rand(ComplexF64))
	u = induce_velocity(Z, freestream, 0.0);
	quiver(real.(Z)[:], imag.(Z)[:], quiver = (real.(u[:]), imag.(u[:])), ratio = 1)
end

# ╔═╡ ed7e6140-14b9-11eb-0c7b-594e8b4fd1ed
begin
#	z = [x + im*y for y in linspace(-1, 1, 21), x in linspace(-1, 1, 21)][:],
    filter(X->abs(X)>0.25, Z)
	
	source = Source.Point(0.0, 1);
    usource = induce_velocity(Z, source, 0.0);

    quiver(real.(Z)[:], imag.(Z)[:], quiver = 0.2.*(real.(usource[:]), imag.(usource[:])), ratio = 1)
end


# ╔═╡ 911afe2e-14ba-11eb-3c75-a97deaefba0c
begin
	filter(X->abs(X)>0.25, Z)
	
	vortex = Vortex.Point(0.0, 2);
    uvortex = induce_velocity(Z, vortex, 0.0);
    quiver(real.(Z)[:], imag.(Z)[:], quiver = 0.2.*(real.(uvortex[:]), imag.(uvortex[:])), ratio = 1)
end

# ╔═╡ 06a79d20-14bb-11eb-3030-cdd4d53dfac5
begin
	filter(X->abs(X)>0.25, Z)
	f1 = Freestreams.Freestream(1.0)
    s1 = Source.Point(0.0, 2)
	
	u1 = induce_velocity(Z, (f1,s1), 0.0);
    
	quiver(real.(Z)[:], imag.(Z)[:], quiver = 0.2.*(real.(u1[:]), imag.(u1[:])), ratio = 1)
end

# ╔═╡ afbebea2-14bd-11eb-257a-63c212245316
begin
	
	vs = Vortex.Point.([-0.5, 0.5], [1, 1])
    ss = Source.Point.([-0.5, 0.5], [-1, 1])
	
	us = induce_velocity(Z, (vs,ss), 0.0);
    
	quiver(real.(Z)[:], imag.(Z)[:], quiver = 0.2.*(real.(us[:]), imag.(us[:])), ratio = 1)
end

# ╔═╡ 27ebaaf0-14be-11eb-3b42-d3c031377d61
begin
	
	v2 = Vortex.Point(0.0, 2)
    
	ψ = streamfunction(Z,v2)
	
	contour(X, Y, ψ, color = cgrad([:black, :black]), grid = false)
end

# ╔═╡ Cell order:
# ╠═0d696b90-14b9-11eb-19c6-7110e9eded9e
# ╠═40e53300-14b9-11eb-28ca-c39ecf8c05ef
# ╠═59e4bc40-14b9-11eb-3670-cdc8fa8f0ded
# ╠═7eee64f0-14b9-11eb-2c53-650b51c7db37
# ╠═ed7e6140-14b9-11eb-0c7b-594e8b4fd1ed
# ╠═911afe2e-14ba-11eb-3c75-a97deaefba0c
# ╠═06a79d20-14bb-11eb-3030-cdd4d53dfac5
# ╠═afbebea2-14bd-11eb-257a-63c212245316
# ╠═27ebaaf0-14be-11eb-3b42-d3c031377d61
