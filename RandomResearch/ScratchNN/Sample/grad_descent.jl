"""
    Update the paramaters of the model using the gradients (∇)
    and the learning rate (η).
"""
function update_model_weights(parameters, ∇, η)

    L = Int(length(parameters) / 2)

    # Update the parameters (weights and biases) for all the layers
    for l = 0: (L-1)
        parameters[string("W_", (l + 1))] -= η .* ∇[string("∂W_", (l + 1))]
        parameters[string("b_", (l + 1))] -= η .* ∇[string("∂b_", (l + 1))]
    end

    return parameters
end
