include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

file = "/Users/daphneboulanger/GIT/mth6412b-starter-code/instances/stsp/gr17.tsp"

head = read_header(file)
noeuds = read_nodes(head, file)
graphe, graph_nodes, graph_edges = read_stsp(file)
println(typeof(noeuds))
show(graphe)
