"""
    Compute the gradients (∇) of the parameters (master_cache) of the constructed model
    with respect to the cost of predictions (Ŷ) in comparison with actual output (Y).
"""
function back_propagate_model_weights(Ŷ, Y, master_cache)
    # Initiate the dictionary to store the gradients for all the components in each layer
    ∇ = Dict()

    L = length(master_cache)
    Y = reshape(Y , size(Ŷ))

    # Partial derivative of the output layer
    ∂Ŷ = (-(Y ./ Ŷ) .+ ((1 .- Y) ./ ( 1 .- Ŷ)))
    current_cache = master_cache[L]
    println(current_cache)

    # Backpropagate on the layer preceeding the output layer
    ∇[string("∂W_", (L))], ∇[string("∂b_", (L))], ∇[string("∂A_", (L-1))] = linear_activation_backward(∂Ŷ, current_cache, "sigmoid")

    # Go backwards in the layers and compute the partial derivates of each component.
    for l=reverse(0:L-2)
        current_cache = master_cache[l+1]
        ∇[string("∂W_", (l+1))], ∇[string("∂b_", (l+1))], ∇[string("∂A_", (l))] = linear_activation_backward(∇[string("∂A_", (l+1))], current_cache, "relu")
    end

    # Return the gradients of the network
    return ∇
end
