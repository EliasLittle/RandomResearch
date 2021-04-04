import LightGraphs.SimpleGraphs: SimpleEdge

mutable struct Axon{T<:Integer, U<:Number} #<: SimpleEdge
    src::T
    dst::T
    weight::U
    weight_cache::Array{U,1}
end

Axon(src, dst, weight) = Axon(src, dst, weight, Array{eltype(weight),1}())

Axon(e::SimpleEdge{<:Integer}) = Axon(e.src, e.dst, 1, Vector{<:Number})

mutable struct Soma{T<:Integer, U<:Number, V<:Number}
    id::T
    type::Symbol
    func::Function
    value::U
    bias::V
    lin_cache::Vector
    act_cache::Vector
end

Soma(id::Integer, type::Symbol) = Soma(id, type, :relu, 0.0)
Soma(id::Integer, type::Symbol, func::Function, bias)= Soma(id, type, func, rand(), bias, Vector(), Vector())

function label(s::Soma)
    "Node: "*string(s.id)*"\n \n Value: "*string(round(s.value, digits=3))
end


# #TODO: Determine if this is still needed
# function synapse(prev::Neuron, current::Neuron, func) #DEV: similar to linear_forward_activation
#     ids = getfield.(prev, :id)
#     get_weights(x) = get(current.weights, x, 0)
#     W = get_weights.(ids) # Gets the weight corresponding to the incoming neurons
#     b = current.bias
#     A = getfield.(prev, :activation)
#
#     Z = (W .* A) .+ b
#     cache = (A, W, b)
#
#     push!(current.cache, cache)
#     current.activation = func(Z).A
# end


#
# if abspath(PROGRAM_FILE) == @__File__
#     a = neuron(1,1,0,0,[])
#     b = neuron(2,1,0,0,[])
#     c = neuron(3,0,Dict(:1=>0.7,:2=>0.3), 0, [])
#     println(c.activation)
#     synapse([a,b], c, relu)
#     println(c.activation)
# end


# macro activate(func, Z)
#     :($func($Z))
# end

# Can use @activate(relu, synapse())
#
