### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 07a2d728-5627-11eb-3daa-317a0e176005
using LightGraphs, MetaGraphs, GraphPlot

# ╔═╡ dcbabfaa-5886-11eb-02d4-47c9eeb74f9c
include("Neuron.jl"); include("NeuralGraph.jl")

# ╔═╡ c8bbb106-5a8d-11eb-0df8-3ba7b4aa5296
include("activation.jl")

# ╔═╡ 99505ee0-5a8f-11eb-02ae-6dc0182852de
nn = feed_forward()

# ╔═╡ aab809ee-5a8f-11eb-2ff5-0d0cefb4ead8
gplot(nn, [1.0,1,2,2,3], [1,2,1,2,1.5])

# ╔═╡ 4b1bc96e-5a92-11eb-01d7-4d35bce1388a
synapsis!(nn)

# ╔═╡ 4806c34c-5a9b-11eb-1d1d-bb110325e9ad
gplot(nn, [1.0,1,2,2,3], [1,2,1,2,1.5])

# ╔═╡ 1531467c-5627-11eb-3d09-5f466e9fc954
#nn = NeuralGraph()

# ╔═╡ e4e6e098-5889-11eb-09d0-0ff58d8b4793
# begin
# 	add_neuron!(nn, :Input, relu, 1, Dict{Integer, Number}())
# 	add_neuron!(nn, :Input, relu, 0, Dict{Integer, Number}())
# 	add_neuron!(nn, :Hidden, relu, 0, Dict(1=>rand(), 2=>rand())) 
# end

# ╔═╡ 56c1e62a-588c-11eb-240f-413c99df7af1
# gplot(nn)

# ╔═╡ 732b63e8-588e-11eb-0c86-1db88743fab6
# add_neuron!(nn, :Output, sigmoid, 0.5, Dict(3=>rand()))

# ╔═╡ a4cce494-588e-11eb-1446-7d625e1bebfa
# gplot(nn)

# ╔═╡ Cell order:
# ╠═07a2d728-5627-11eb-3daa-317a0e176005
# ╠═dcbabfaa-5886-11eb-02d4-47c9eeb74f9c
# ╠═c8bbb106-5a8d-11eb-0df8-3ba7b4aa5296
# ╠═99505ee0-5a8f-11eb-02ae-6dc0182852de
# ╠═aab809ee-5a8f-11eb-2ff5-0d0cefb4ead8
# ╠═4b1bc96e-5a92-11eb-01d7-4d35bce1388a
# ╠═4806c34c-5a9b-11eb-1d1d-bb110325e9ad
# ╠═1531467c-5627-11eb-3d09-5f466e9fc954
# ╠═e4e6e098-5889-11eb-09d0-0ff58d8b4793
# ╠═56c1e62a-588c-11eb-240f-413c99df7af1
# ╠═732b63e8-588e-11eb-0c86-1db88743fab6
# ╠═a4cce494-588e-11eb-1446-7d625e1bebfa
