"""
    Train the network using the desired architecture that best possible
    matches the training inputs (DMatrix) and their corresponding ouptuts(Y)
    over some number of iterations (epochs) and a learning rate (η).
"""
function train_network(layer_dims , DMatrix, Y;  η=0.001, epochs=1000, seed=2020, verbose=true)
    # Initiate an empty container for cost, iterations, and accuracy at each iteration
    costs = []
    iters = []
    accuracy = []

    # Initialise random weights for the network
    params = initialise_model_weights(layer_dims, seed)

    # Train the network
    for i = 1:epochs

        Ŷ , caches  = forward_propagate_model_weights(DMatrix, params)
        cost = calculate_cost(Ŷ, Y)
        acc = assess_accuracy(Ŷ, Y)
        ∇  = back_propagate_model_weights(Ŷ, Y, caches)
        params = update_model_weights(params, ∇, η)

        if verbose
            println("Iteration -> $i, Cost -> $cost, Accuracy -> $acc")
        end

        # Update containers for cost, iterations, and accuracy at the current iteration (epoch)
        push!(iters , i)
        push!(costs , cost)
        push!(accuracy , acc)
    end
        return (cost = costs, iterations = iters, accuracy = accuracy, parameters = params)
end
