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

# ╔═╡ ac3cc660-08e1-11eb-3db6-0d5949a89423
begin
	using PlutoUI
	using Plots
	using Printf
end

# ╔═╡ ed659260-08e2-11eb-2951-2be739c080ed
md"_MAE 5943 Falkner-Skan, version 1_"

# ╔═╡ 59909ca0-08e3-11eb-3348-41080f6a2bd8
md"""

## **Falkner-Skan Similarity Solutions** 
`MAE 5943`, `Fall 2020`

#### **Description:**

This notebook computes the Falkner-Skan Similarity Solutions

		falkner_skan(m, ηmax, N, itermax, ϵProfile, ϵBC)

If the arguments are missing, it will use the default values.
    
		falkner_skan(m=0, ηmax=10, N=30, itermax=40, ϵProfile=1e-6, ϵBC=1e-6)
		
		m = 0 : Blasius flow over a flat plate with a sharp leading edge. 
	0 < m < 1 : Flow over a wedge with half angle θ.
		m = 1 : Hiemenz flow toward a plane stagnation point.
	1 < m < 2 : Flow into a corner with θ.
		m > 2 : No corresponding simple flow.


#### **Falkner-Skan Equation**
Stagnation point flow problem towards an infinite flat plate can be represented using the ordinary differential equation (ODE) below:

$$f''' + ½ (m+1) f f'' + m (1-f')² = 0$$

Boundary Conditions:

$$f(0) = 0$$
$$f'(0) = 0$$
$$f'(η→∞) = 1$$

Please see the lecture notes for [more information] on the derivation of the ODE and numerical solution method.

#### **Solution Method:**

Let's assume:

$$p = f(η)$$		
$$h = f'(η)$$ 
		
Then, we obtain two ODEs equations and boundary conditions
ODEs:

$$h'' + ½ (m+1) p h' + m (1- h²) = 0$$
$$p' - h = 0$$

BCs:  

$$p(0) = 0$$
$$h(0) = 0$$
$$h(∞) = 1$$

The equations given above are solved using Thomas algorithm.

Feel free to ask questions!

*MAE 5943 - Unsteady Aerodynamics, Fall 2020* 

*Dr. Kursat Kara*

kursat.kara@okstate.edu

"""

# ╔═╡ d47c93d0-08e1-11eb-0e92-21ca5523e6c6
"""
Computes the Falkner-Skan Similarity Solutions
This notebook computes the Falkner-Skan Similarity Solutions

		fs(m, ηmax, N, itermax, ϵProfile, ϵBC)

If the arguments are missing, it will use the default values.
    
		fs(m=0, ηmax=10, N=30, itermax=40, ϵProfile=1e-6, ϵBC=1e-6)
		
		m = 0 : Blasius flow over a flat plate with a sharp leading edge. 
	0 < m < 1 : Flow over a wedge with half angle θ
		m = 1 : Hiemenz flow toward a plane stagnation point.
	1 < m < 2 : Flow into a corner with θ.
		m > 2 : No corresponding simple flow.

MAE 5943 - Unsteady Aerodynamics,
Dr. Kursat Kara,
kursat.kara@okstate.edu,
Fall 2020. 
    
"""
function falkner_skan(m=0, ηmax=10, N=30, itermax=40, ϵProfile=1e-6, ϵBC=1e-6)
 
	Δη = ηmax/N
    Δη²= Δη^2;

    #itermax = 40
    #ϵProfile = 1e-6
    #ϵBC = 1e-6

    iter = 0
    errorProfile = 1.
    errorBC = 1.;

    # Initialization of the arrays
    A = zeros(N+1)
    B = zeros(N+1)
    C = zeros(N+1)
    D = zeros(N+1)

    G = zeros(N+1)
    H = zeros(N+1)

    p = zeros(N+1)
    h = zeros(N+1)
    η = zeros(N+1)

    η = [(i-1)*Δη for i=1:N+1];

    #BCs
    h[1]   = 0.0   # h(η=0) = 0
    h[N+1] = 1.0   # h(η=∞) = 1
    p[1]   = 0.0   # p(η=0) = 0

    G[1] = 0.0
    H[1] = 0.0;

    #Solution initialization

    # assume a linear profile for h(η)
    h = [(i-1)/N  for i=1:N+1]

    for i = 2:N+1
        p[i] = p[i-1] + (h[i] + h[i-1])*Δη/2
    end

    println("iter     error            convergence of h(η→∞)")
    println("-----------------------------------------------")

    #while ϵProfile<=errorProfile && ϵBC<=errorBC && iter<itermax
    while ϵProfile<=errorProfile && iter<itermax
        A = [ 1/Δη² + (m+1)*p[i]/(4*Δη) for i=1:N+1]
        B = [-2/Δη² - m*h[i] for i=1:N+1]
        C = [ 1/Δη² - (m+1)*p[i]/(4*Δη) for i=1:N+1]
        D = [ m for i=1:N+1]

        for i=2:N
            G[i] = - ( C[i]*G[i-1] + D[i] )/(B[i] + C[i] * H[i-1])
            H[i] = -                 A[i]  /(B[i] + C[i] * H[i-1])
        end

        hold = copy(h)

        for i=N:-1:2
            h[i] = G[i] + H[i] * h[i+1]
        end 

        errorProfile = maximum(abs.(hold-h))

        errorBC = abs(h[N+1]-h[N])

        for i = 2:N
            p[i] = p[i-1] + (h[i] + h[i-1])*Δη/2
        end

        iter += 1

        #println("iter: $iter,  errorProfile: $errorProfile, errorBC: $errorBC")
        @printf("%4.4d %16.6e %16.6e \n", iter, errorProfile, errorBC)
    end

     if errorProfile<=ϵProfile 
        println("")
        println("Solution converged!")
        println("The maximum change between consecutive profiles is less than the error criteria ϵProfile=$ϵProfile.")
     end

     if errorBC<=ϵBC
        println("")
        println("Solution for the boundary condition converged!")
        println("The difference between h(N) and h(N+1) is less than the error criteria ϵBC=$ϵBC.")
     end
    return η,h
end

# ╔═╡ 3ec1b8f0-0fe6-11eb-0885-a589ccc1c3fd
md"""

	
		m = 0 : Blasius flow over a flat plate with a sharp leading edge. 
	0 < m < 1 : Flow over a wedge with half angle θ.
		m = 1 : Hiemenz flow toward a plane stagnation point.
	1 < m < 2 : Flow into a corner with θ.
		m > 2 : No corresponding simple flow.

Select the flow parameters

m:
$(@bind m Slider(0:0.1:3; default=1, show_value=true))

"""

# ╔═╡ 0d600270-0fe7-11eb-2e9d-1d2629b64deb
md"""
ηmax (Boundary-Layer thickness):
$(@bind ηmax Slider(2:20; default=10, show_value=true))
	
"""

# ╔═╡ 0d6113e0-0fe7-11eb-19d3-cff66cf055f5
md"""
N (The number of grid points):
$(@bind N Slider(5:50; default=30, show_value=true))

"""

# ╔═╡ 07798e4e-08e2-11eb-3066-0120057d15b2
ηtest, htest = falkner_skan(m,ηmax,N);

# ╔═╡ 2fe46a60-0fe8-11eb-0818-15d61d18bd39
plot(htest,ηtest,
        title = "Falkner-Skan Similarity Solution 
m=$m",
        label = "f'",
        legend = :topleft,
        xlabel = "h = f'",
        ylabel = "η",
        linewidth = 2,
        linecolor = :black,
        markershape = :circle,
        markercolor = :red,
	)

# ╔═╡ Cell order:
# ╟─ed659260-08e2-11eb-2951-2be739c080ed
# ╟─59909ca0-08e3-11eb-3348-41080f6a2bd8
# ╟─ac3cc660-08e1-11eb-3db6-0d5949a89423
# ╟─d47c93d0-08e1-11eb-0e92-21ca5523e6c6
# ╟─3ec1b8f0-0fe6-11eb-0885-a589ccc1c3fd
# ╟─0d600270-0fe7-11eb-2e9d-1d2629b64deb
# ╟─0d6113e0-0fe7-11eb-19d3-cff66cf055f5
# ╟─07798e4e-08e2-11eb-3066-0120057d15b2
# ╟─2fe46a60-0fe8-11eb-0818-15d61d18bd39
