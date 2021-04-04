"""
    Derivative of the Sigmoid function.
"""
function sigmoid_backwards(∂A, activated_cache)
    s = sigmoid(activated_cache).A
    ∂Z = ∂A .* s .* (1 .- s)

    @assert (size(∂Z) == size(activated_cache))
    return ∂Z
end


"""
    Derivative of the ReLU function.
"""
function relu_backwards(∂A, activated_cache)
    return ∂A .* (activated_cache .> 0)
end
