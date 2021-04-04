# Computes the log loss (binary cross entropy) of the current predictions.
function cost(Ŷ, Y)
    m = size(Y, 2)
    ϵ = eps(1.0)

    # Deal with log(0) scenarios
    Ŷ_new = [max(i, ϵ) for i in Ŷ]
    Ŷ_new = [min(i, 1-ϵ) for i in Ŷ_new]

    cost = -sum(Y .* log.(Ŷ_new) + (1 .- Y) .* log.(1 .- Ŷ_new)) / m
    return cost
end
