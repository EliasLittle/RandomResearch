import ForwardDiff.derivative
const Δ = derivative

function linear_backward(∂Z, lin_cache)
    # Unpack cache
    A_prev , W , b = lin_cache
    m = size(A_prev, 2)

    # Partial derivates of each of the components
    ∂W = ∂Z * (A_prev') / m
    ∂b = sum(∂Z, dims = 2) / m
    ∂A_prev = (W') * ∂Z

    @assert (size(∂A_prev) == size(A_prev))
    @assert (size(∂W) == size(W))
    @assert (size(∂b) == size(b))

    return ∂W , ∂b , ∂A_prev
end

function lin_act_back(∂A, item)
    ∂Z = ∂A*Δ(item.func, item.act_cache)
    linear_backward(∂Z, item.lin_cache)
end

function backpropagation(nn, Ŷ, Y, η)
    # Gradient
    ∇ = Dict{Any, Float64}()

    Y = reshape(Y, size(Ŷ))

    # Partial derivative of the output layer
    ∂Ŷ = (-(Y ./ Ŷ) .+ ((1 .- Y) ./ ( 1 .- Ŷ)))
    output = get_cells(nn, :Output)
    layer = Set([keys(output)...])
    for id in layer
        item = nn.somas[id]
        A_prev, W, b = last(item.lin_cache)
        ∂W, ∂b, ∂A_prev = lin_act_back(∂Ŷ, item)
        merge!(∇, ∂W, ∂b)
        
    end

    # Calculate elements of the gradient
    while length(layer) > 0
        # current_cache = [(cell.act_cache, cell.lin_cache) for cell in values(layer)]
        for item in layer
            ∇[item.id], ∇[item.id], ∇[item.id] = lin_act_back(∂A, item)
        end
        layer = prev_layer(nn, collect(layer))
    end

    # Update model biases
    for soma in nn.somas

    end

    #update model weights
    for axon in nn.axons

    end


end

function update_weights(nn, ∇, η)

end
