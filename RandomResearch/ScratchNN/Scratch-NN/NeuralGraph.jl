# module NeuralGraphs

using LightGraphs, MetaGraphs, GraphPlot, Colors
import Base.show

include("Neuron.jl")
include("Activation.jl")


# export
#     NeuralGraph,
#     Soma,
#     Axon,
#     is_directed,
#     add_soma!,
#     add_axon!,
#     add_neuron!,
#     synapse!,
#     synapsis!,
#     get_cells,
#     next_layer,
#     gplot,
#     feed_forward


#Main Structure
mutable struct NeuralGraph{T<:Integer,U<:Number} <: AbstractMetaGraph{T}
    graph::SimpleDiGraph{T}
    somas::Dict{T,Soma}
    axons::Dict{SimpleEdge{T},Axon}
    props::Dict{Symbol,Any}
    weightfield::Symbol
    defaultweight::U
    metaindex::Dict{Symbol,Dict{Any,Integer}}
    indices::Set{Symbol}
end

#Constructors
function NeuralGraph(x)
    T = eltype(x)
    g = SimpleDiGraph(x)
    somas = Dict{T, Soma{}}()
    axons = Dict{SimpleEdge{T},Axon}()
    props = Dict{Symbol,Any}()
    weightfield = :weight
    defaultweight = 1.0
    metaindex = Dict{Symbol,Dict{Any,Integer}}()
    idxs = Set{Symbol}()

    NeuralGraph(g, somas, axons, props,
        weightfield, defaultweight,
        metaindex, idxs)
end

NeuralGraph() = NeuralGraph(0)

function show(io::IO, g::NeuralGraph{T,U}) where T where U
    print(io, "NeuralGraph with $(nv(g)) neurons, and $(ne(g)) connections.")
end

include("ForwardProp.jl")
include("Cost.jl")
include("Backprop.jl")

#Helper Constructors
SimpleDiGraph(g::NeuralGraph) = g.graph

# is_directed(::Type{NeuralGraph}) = true
# is_directed(::Type{NeuralGraph{T,U}}) where T where U = true
is_directed(g::NeuralGraph{T,U}) where T where U = true

weighttype(g::NeuralGraph{T,U}) where T where U = U



#Main Graph Construction Functions
function add_soma!(g::NeuralGraph, type::Symbol, func::Function, bias)
    add_vertex!(g.graph) || return false
    g.somas[nv(g)] = Soma(nv(g), type, func, bias)
    return true
end

function add_axon!(g::NeuralGraph, from::Integer, to::Integer, weight::Number)
    add_edge!(g.graph, from, to) || return false
    g.axons[SimpleEdge(from, to)] = Axon(from, to, weight)
    return true
end

add_axon!(g::NeuralGraph, from::Integer, to::Integer) = add_axon!(g, from, to, rand())

const SourceWeights = Dict{<:Integer, <:Number}

function add_neuron!(g::NeuralGraph, type::Symbol, func::Function, bias, inputs::SourceWeights)
    add_soma!(g, type, func, bias) || return false
    dest = nv(g)
    for (source, weight) in inputs
        add_axon!(g, source, dest, weight) || return false
    end
    return true
end

function add_neuron!(g::NeuralGraph, type::Symbol, func::Function, bias, sources::Array)
    add_soma!(g, type, func, bias) || return false
    dest = nv(g)
    for src in sources
        add_axon!(g, src, dest) || return false
    end
    return true
end

function add_neuron!(g::NeuralGraph, type::Symbol)
    function f(x)
        return x
    end
    if type == :Input
        add_neuron!(g, type, f, 0, [])
    else
        add_neuron!(g, type, relu, 0, [])
    end
end

#General Helper Functions
function get_cells(g::NeuralGraph, type::Symbol)
    filter(x->x.second.type == type, g.somas)
end

function next_layer(nn::NeuralGraph, layer::Array)
    Set(vcat(map(x->outneighbors(nn, x), layer)...))
end

function prev_layer(nn::NeuralGraph, layer::Array)
    Set(vcat(map(x->inneighbors(nn, x), layer)...))
end


function gplot(g::NeuralGraph, locs_x, locs_y)
    typec = Dict(
        :Input=>colorant"#FFCC00",
        :Hidden=>colorant"#66CC01",
        :Output=>colorant"#FF6701"
    )
    NL = map(x->label(g.somas[x]), vertices(g))
    EL = map(x->round(g.axons[x].weight, digits=3), edges(g))
    fill = map(x->get(typec, g.somas[x].type,colorant"black"), vertices(g))

    GraphPlot.gplot(g.graph, locs_x, locs_y, nodelabel=NL, edgelabel=EL, nodefillc=fill)
end

function gplot(g::NeuralGraph)
    typec = Dict(
        :Input=>colorant"#FFCC00",
        :Hidden=>colorant"#66CC01",
        :Output=>colorant"#FF6701"
    )
    NL = map(x->label(g.somas[x]), vertices(g))
    EL = map(x->round(g.axons[x].weight, digits=3), edges(g))
    fill = map(x->get(typec, g.somas[x].type,colorant"black"), vertices(g))

    GraphPlot.gplot(g.graph, nodelabel=NL, edgelabel=EL, nodefillc=fill)
end


#Common Structures
function feed_forward()
    nn = NeuralGraph()
    add_neuron!(nn, :Input)
    add_neuron!(nn, :Input)

    add_neuron!(nn, :Hidden, relu, 0, [1,2])
    add_neuron!(nn, :Hidden, relu, 0, [1,2])

    add_neuron!(nn, :Output, relu, 0, [3,4])
    return nn
end
# end
