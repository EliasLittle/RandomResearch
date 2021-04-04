### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 648928bc-9172-11eb-2ec7-f5436f9408e8
using Plots, PlutoUI

# ╔═╡ aaff649e-916f-11eb-3ce0-bb2225799e9a
md"Exclusive range function between two bounds. Hardcode length 11 for ease of use. 

Ex. 1→2 ▶ Float64[1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9]
"

# ╔═╡ a5068a56-916d-11eb-20c1-6f9f760c3fc8
a→b = [fill(a,8)...,range(a,b,length=11)[1:end-1]...]

# ╔═╡ 03fbe4d8-916f-11eb-007f-e5f71ac02547
k = [2, 4, 3]

# ╔═╡ 191707e4-916f-11eb-36d9-e5f2af580836
κ = vcat(map(→, (@view k[1:end-1]), (@view k[2:end]))...)

# ╔═╡ 148a10c2-916f-11eb-0fe6-b7c95bd8fff8
#Defined for t ∈ [0, ∞]
function γ(κ,t)
	sin(κ*t)/κ, -cos(κ*t)/κ
end

# ╔═╡ 0f2645de-9187-11eb-1308-05f9d88e320c
function γ1(κ,t)
	sin(κ*t)/κ, -cos(κ*t)/κ, t
end

# ╔═╡ 264f8d34-9172-11eb-00b2-258be5b43cd0
dt = 0:length(κ)-1

# ╔═╡ 97804470-9173-11eb-211d-75dd8006278b
@bind S Slider(0:0.1:40)

# ╔═╡ c2e04950-9176-11eb-2ef4-3385db484664
S

# ╔═╡ d885f582-9173-11eb-3b40-bf1b5617fac2
t = range(0, S, length=length(κ))

# ╔═╡ 46b8abe6-9172-11eb-2ced-a309def3bd92
begin
	plot(γ.(κ,t), xlims=(-1.5,1.5),ylims=(-1,1))
end

# ╔═╡ 9489770a-9178-11eb-20ab-cb55544fef60
begin
	plotly()
	plot(γ1.(κ,t))
end

# ╔═╡ 75d96340-917a-11eb-0f15-89b23799dc4c
md"---"

# ╔═╡ 83182a58-9181-11eb-1bcc-5534a1b13dc3
@bind T1 Slider(0:0.01:2π)

# ╔═╡ c7d1ba44-917a-11eb-36d5-9b0bb41397c1
@bind T2 Slider(0:0.01:10)

# ╔═╡ 81ac95f2-917a-11eb-2341-4bef2fc91a5e
begin
	L = [T1:0.01:T2...]
	plot(γ.(2,L), xlims=(-1.5,1.5), ylims=(-1,1))
	l = [2, 2.3, 1.7]
	Λ = vcat(map(→, (@view l[1:end-1]), (@view l[2:end]))...)
	λ = [range(2.0, 2.3, length=800); range(2.3, 1.7, length=301)]
	low, high = round(Int, 100*T1+1), round(Int, 100*T2+1)
	plot!(γ.(λ[low:high],L))
end

# ╔═╡ fc650acc-9193-11eb-2f4d-29181dd2d179
function seg(κ₁, κ₂, s)
	range(κ₁, κ₂, length=s)
end

# ╔═╡ 18fb7094-9195-11eb-2055-196b795d3936
""" 
Concatenate two ranges
"""
A∪B = [A; B]

# ╔═╡ d196f5c2-9197-11eb-3a25-1ddc17ede80c
@bind t1 Slider(0:0.01:10, show_value=true)

# ╔═╡ eb75e05c-9197-11eb-1143-7b8f956265f3
@bind t2 Slider(0:0.01:10, show_value=true)

# ╔═╡ 06b593ae-919c-11eb-16fe-8bf07d35fb6d
vals = rand(4)

# ╔═╡ 594524e2-9195-11eb-0f38-97b65ec4517b
begin
	Times = [t1:0.01:t2...]

	lens = [333,334,334]
	
	lo, h = round(Int, 100*t1+1), round(Int, 100*t2+1)
	@assert sum(lens) >= h-lo
	
	list = map(seg, (@view vals[1:end-1]), (@views vals[2:end]), lens)
	dκ = reduce(∪, list)
	
	plot(γ.(dκ[lo:h],Times), xlims=(-5,5),ylims=(-5,5),zlims=(0,10))
end

# ╔═╡ e808681e-919b-11eb-2716-43681f284b7e
dκ[310:350]

# ╔═╡ a53c3860-9189-11eb-1196-739ea28f4753
gr()

# ╔═╡ 92c35cb2-9180-11eb-3cba-1ff2409d7093
γ.(2,T2)

# ╔═╡ Cell order:
# ╠═648928bc-9172-11eb-2ec7-f5436f9408e8
# ╟─aaff649e-916f-11eb-3ce0-bb2225799e9a
# ╠═a5068a56-916d-11eb-20c1-6f9f760c3fc8
# ╠═03fbe4d8-916f-11eb-007f-e5f71ac02547
# ╠═191707e4-916f-11eb-36d9-e5f2af580836
# ╠═148a10c2-916f-11eb-0fe6-b7c95bd8fff8
# ╠═0f2645de-9187-11eb-1308-05f9d88e320c
# ╠═264f8d34-9172-11eb-00b2-258be5b43cd0
# ╠═97804470-9173-11eb-211d-75dd8006278b
# ╟─c2e04950-9176-11eb-2ef4-3385db484664
# ╠═d885f582-9173-11eb-3b40-bf1b5617fac2
# ╠═46b8abe6-9172-11eb-2ced-a309def3bd92
# ╠═9489770a-9178-11eb-20ab-cb55544fef60
# ╟─75d96340-917a-11eb-0f15-89b23799dc4c
# ╠═83182a58-9181-11eb-1bcc-5534a1b13dc3
# ╠═c7d1ba44-917a-11eb-36d5-9b0bb41397c1
# ╠═81ac95f2-917a-11eb-2341-4bef2fc91a5e
# ╠═fc650acc-9193-11eb-2f4d-29181dd2d179
# ╠═18fb7094-9195-11eb-2055-196b795d3936
# ╠═d196f5c2-9197-11eb-3a25-1ddc17ede80c
# ╠═eb75e05c-9197-11eb-1143-7b8f956265f3
# ╠═06b593ae-919c-11eb-16fe-8bf07d35fb6d
# ╠═594524e2-9195-11eb-0f38-97b65ec4517b
# ╠═e808681e-919b-11eb-2716-43681f284b7e
# ╠═a53c3860-9189-11eb-1196-739ea28f4753
# ╠═92c35cb2-9180-11eb-3cba-1ff2409d7093
