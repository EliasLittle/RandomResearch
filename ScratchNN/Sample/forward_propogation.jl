"""
    Forward the design matrix through the network layers using the parameters.
"""
function forward_propagate_model_weights(DMatrix, parameters)
    master_cache = []
    A = DMatrix
    L = Int(length(parameters) / 2)

    # Forward propagate until the last (output) layer
    for l = 1 : (L-1)
        A_prev = A
        A, cache = linear_forward_activation(A_prev, parameters[string("W_", (l))], parameters[string("b_", (l))], "relu")

        push!(master_cache , cache)
    end

    # Make predictions in the output layer
    Ŷ, cache = linear_forward_activation(A, parameters[string("W_", (L))], parameters[string("b_", (L))], "relu")

    push!(master_cache, cache)

    return Ŷ, master_cache
end
