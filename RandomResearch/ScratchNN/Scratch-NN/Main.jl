using .NeuralGraph

nn = feed_forward()
synapsis!(nn)
Ŷ = get_cells(nn, :Output)
