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

# ╔═╡ 160309dc-949d-11eb-0492-01c9b1790954
using Images, FileIO, ImageMagick, Colors, FixedPointNumbers, PlutoUI

# ╔═╡ 6479ef68-949d-11eb-1414-7de2db37157a
Gray.([0.5 0; 0 0.5])

# ╔═╡ 7df35c84-949f-11eb-3d40-47c2eff055f9
function bitfield(func, xlim, ylim, color=false)
	if !color
		Gray.([func(x,y) for x in 1:xlim, y in 1:ylim])
	else
		[RGB(func(x,y)...) for x in 1:xlim, y in 1:ylim]
	end
end

# ╔═╡ 1a2e184c-949f-11eb-207f-4b7fa5dd65e0
f(x,y,m) = (x ⊻ y) % m == 1

# ╔═╡ 5d97726a-94b6-11eb-0375-b16ddaf84bdb
f′(x,y) = 1==mod((abs(x+y-2) ⊻ (abs(y-x)+1))^37, 7)

# ╔═╡ 35bc9b0a-94e1-11eb-23fb-877541634122
f′′(x,y) = 1== powermod.((abs(x+y-2) ⊻ (abs(y-x)+1)), 37, 7)

# ╔═╡ 5b9d0114-94e1-11eb-39c4-a300768028e6
[f′′(x,y)-f′(x,y) for x in 1:16, y in 1:16]

# ╔═╡ b7f5e8e0-94e1-11eb-0e13-f7733369fa0f
begin
	x,y = 1,4
	mod(((abs(x+y-2) ⊻ (abs(y-x)+1))^37), 8) 
end

# ╔═╡ 8f2e9480-94e2-11eb-2569-d3bd60d7b195
val = (abs(x+y-2) ⊻ (abs(y-x)+1))

# ╔═╡ 6c8a6646-94e4-11eb-04cd-efeb0f1a1fd0
mod(BigInt(val)^37, 7)

# ╔═╡ 28a26390-94e2-11eb-30c0-0f2a2daa23df
begin
	rem(powermod((abs(x+y-2) ⊻ (abs(y-x)+1)), 37, 7), 7)
end

# ╔═╡ ccebb562-949e-11eb-1e5d-7155ce0eabb8
bitfield((x,y) -> f(x, y, 9), 256, 256)

# ╔═╡ 6895a2a6-94b9-11eb-09c0-915070c89217
bitfield(f′, 512, 512)

# ╔═╡ 7ab005f8-94af-11eb-2ea0-15f9c94459b9
g(x,y) = (x-1,y-1,x+y/2)./256

# ╔═╡ 7bc4e9b8-94b4-11eb-1230-cdfae4008fd7
function g′(x,y)
	val = ((x-64)^2+96^2,(y-64)^2+96^2, x*y+96^2)./(256^2)
	min.(val .+ 0.5, (1,1,1))
end

# ╔═╡ 4346d3a0-94b4-11eb-3d91-81df5ea36e04
h(x,y,m) = Int(f(x,y,m)) .* g′(x,y)

# ╔═╡ 31068ffe-949f-11eb-0ed1-b58409a83ef8
bitfield(g, 256, 256, true)

# ╔═╡ bad6ee08-94b4-11eb-1f1d-2d84e73ad24b
bitfield(g′, 256, 256, true)

# ╔═╡ 3a8f32e4-94b4-11eb-3151-aff8ad395198
bitfield((x,y)->h(x,y,9), 256, 256, true)

# ╔═╡ 3907841a-94c2-11eb-2f6d-b55d0452f9a4
bitfield((x,y)->(f′(x,y) .* g′(x/2,y/4)), 512,1028, true)

# ╔═╡ 84028b88-94ca-11eb-05dd-774d17e0a97f
k(x,y) = floor(512^π/(x*y)) % 2

# ╔═╡ 9da9dc08-94ca-11eb-34d1-5900eafab1eb
bitfield((x,y)->k(x,y).*g′(x/2,y/2), 512,512, true)

# ╔═╡ a7d323ea-94d1-11eb-3620-89954239ac23
begin
	ims = [bitfield((x,y)->h(x,y,m),16,16,true) for m in 1:16]
	frames = Array{RGB{Float64}}(undef, 16, 16, 16)
	for i in 1:16
		frames[:,:,i] .= bitfield((x,y)->h(x,y,i), 16, 16, true)
	end
	typeof(frames)
end

# ╔═╡ e28d0f8c-997c-11eb-3f16-3f9a5b7593ca
@bind frame Slider(1:16)

# ╔═╡ c4dba7a8-997c-11eb-0ddd-0feeadb08cf2
frames[:,:,frame]

# ╔═╡ 4efabee4-94d4-11eb-2efd-51e8e1c326fe
save("plswork.gif", frames)

# ╔═╡ 9964f73a-94d5-11eb-0b38-3bcea7c2db05
md"It works!"

# ╔═╡ a804409a-94dd-11eb-3921-2f7a18fd3b7f
function animate_bitfield(name, func, dims, range, color)
	frames = Array{RGB{Float64}}(undef, dims..., length(range))
	for t in 1:length(range)
		frames[:,:,t] .= bitfield((x,y)->func(x,y,range[t]), dims[1], dims[2], color)
	end
	save(name, frames)
end

# ╔═╡ 03238426-94df-11eb-3e21-9ba51c2aacf8
begin
	γ(x,y,m) = 1 == mod.((abs(x+y-2) ⊻ (abs(y-x)+1))^37, m)
	function Γ(x,y,t) 
		γ(x,y,t) .* g′(x/4,y/4) 
	end
	animate_bitfield("Test2.gif", Γ, (1024,1024), collect(1:2:55), true)
end

# ╔═╡ c08d1d6e-94ea-11eb-0f4c-e90d60075ddc
begin
	λ(x,y,m) = 1 == ((256*cos(x*y*m)|>floor|>Int) & (256*sin(x*y*m)|>floor|>Int))
	animate_bitfield("Num3.gif", (x,y,m)->λ(x,y,m) .* g′(x,y), (256, 256), collect(1:30), true)
end

# ╔═╡ Cell order:
# ╠═160309dc-949d-11eb-0492-01c9b1790954
# ╠═6479ef68-949d-11eb-1414-7de2db37157a
# ╠═7df35c84-949f-11eb-3d40-47c2eff055f9
# ╠═1a2e184c-949f-11eb-207f-4b7fa5dd65e0
# ╠═5d97726a-94b6-11eb-0375-b16ddaf84bdb
# ╠═35bc9b0a-94e1-11eb-23fb-877541634122
# ╠═5b9d0114-94e1-11eb-39c4-a300768028e6
# ╠═b7f5e8e0-94e1-11eb-0e13-f7733369fa0f
# ╠═8f2e9480-94e2-11eb-2569-d3bd60d7b195
# ╠═6c8a6646-94e4-11eb-04cd-efeb0f1a1fd0
# ╠═28a26390-94e2-11eb-30c0-0f2a2daa23df
# ╠═ccebb562-949e-11eb-1e5d-7155ce0eabb8
# ╠═6895a2a6-94b9-11eb-09c0-915070c89217
# ╠═7ab005f8-94af-11eb-2ea0-15f9c94459b9
# ╠═7bc4e9b8-94b4-11eb-1230-cdfae4008fd7
# ╠═4346d3a0-94b4-11eb-3d91-81df5ea36e04
# ╠═31068ffe-949f-11eb-0ed1-b58409a83ef8
# ╠═bad6ee08-94b4-11eb-1f1d-2d84e73ad24b
# ╠═3a8f32e4-94b4-11eb-3151-aff8ad395198
# ╠═3907841a-94c2-11eb-2f6d-b55d0452f9a4
# ╠═84028b88-94ca-11eb-05dd-774d17e0a97f
# ╠═9da9dc08-94ca-11eb-34d1-5900eafab1eb
# ╠═a7d323ea-94d1-11eb-3620-89954239ac23
# ╠═e28d0f8c-997c-11eb-3f16-3f9a5b7593ca
# ╠═c4dba7a8-997c-11eb-0ddd-0feeadb08cf2
# ╠═4efabee4-94d4-11eb-2efd-51e8e1c326fe
# ╟─9964f73a-94d5-11eb-0b38-3bcea7c2db05
# ╠═a804409a-94dd-11eb-3921-2f7a18fd3b7f
# ╠═03238426-94df-11eb-3e21-9ba51c2aacf8
# ╠═c08d1d6e-94ea-11eb-0f4c-e90d60075ddc
