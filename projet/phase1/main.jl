include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

file = "/Users/daphneboulanger/GIT/mth6412b-starter-code/instances/stsp/bayg29.tsp"

#head = read_header(file)
#noeuds = read_nodes(head, file)
tuple = read_stsp(file)
#println(typeof(noeuds))
println(tuple[1])