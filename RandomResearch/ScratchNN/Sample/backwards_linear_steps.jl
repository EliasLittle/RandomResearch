"""
    Partial derivatives of the components of linear forward function
    using the linear output (∂Z) and caches of these components (cache).
"""
function linear_backward(∂Z, cache)
    # Unpack cache
    A_prev , W , b = cache
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


"""
    Unpack the linear activated caches (cache) and compute their derivatives
    from the applied activation function.
"""
function linear_activation_backward(∂A, cache, activation_function="relu")
    @assert activation_function ∈ ("sigmoid", "relu")

    linear_cache , cache_activation = cache

    if (activation_function == "relu")

        ∂Z = relu_backwards(∂A , cache_activation)
        ∂W , ∂b , ∂A_prev = linear_backward(∂Z , linear_cache)

    elseif (activation_function == "sigmoid")

        ∂Z = sigmoid_backwards(∂A , cache_activation)
        ∂W , ∂b , ∂A_prev = linear_backward(∂Z , linear_cache)

    end

    return ∂W , ∂b , ∂A_prev
end
