# Sigmoid activation function
function sigmoid(Z)
    return 1 ./ (1 .+ exp.(.-Z))
end


# ReLU activation function
function relu(Z)
    return max.(0, Z)
end
