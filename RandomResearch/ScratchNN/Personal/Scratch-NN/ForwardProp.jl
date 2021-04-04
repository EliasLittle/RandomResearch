
function synapse!(nn::NeuralGraph, cell::Soma)
    in_nodes = inneighbors(nn, cell.id)

    b = cell.bias
    A = Dict(map(x->(nn.somas[x].id => nn.somas[x].value), in_nodes))
    W = Dict(map(x->(SimpleEdge(x, cell.id) => nn.axons[SimpleEdge(x, cell.id)].weight), in_nodes))
    push!(cell.lin_cache, (A, W, b))

    Z = sum(values(A) .* values(W)) + b
    val = cell.func(Z)
    push!(cell.act_cache, Z)
    println(cell.value)
    println(val)
    cell.value = val
end

function synapsis!(nn::NeuralGraph)
    inputs = get_cells(nn, :Input)
    layer = next_layer(nn, [keys(inputs)...])
    while length(layer) > 0
        for item in layer
            synapse!(nn, nn.somas[item])
        end
        layer = next_layer(nn, collect(layer))
    end
end
