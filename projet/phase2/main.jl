using BenchmarkTools

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal.jl")
include("queue.jl")
include("prim.jl")

file = "brg180.tsp"

chemin = "/Users/daphneboulanger/GIT/mth6412b-starter-code/instances/stsp/"*file

head = read_header(chemin)
noeuds = read_nodes(head, chemin)
graphe, graph_nodes, graph_edges = read_stsp(chemin)
# show(graphe)
# STSP_prim = prim(deepcopy(graphe))
# show(STSP_prim)
# STSP_kruskal = kruskal(deepcopy(graphe))
# show(STSP_kruskal)
# println(cost(graphe))
# println(cost(STSP_prim))
# println(cost(STSP_kruskal))

# a = Node("a",0,1)
# b = Node("b",0,2)
# c = Node("c",0,3)
# d = Node("d",0,4)
# e = Node("e",0,5)
# f = Node("f",0,6)
# g = Node("g",0,7)
# h = Node("h",0,8)
# i = Node("i",0,9)
# nodes_g = [a, b, c, d, e, f, g, h, i]

# ab = Edge(a, b, 4)
# ah = Edge(a, h, 8)
# bc = Edge(b, c, 8)
# bh = Edge(b, h, 11)
# cd = Edge(c, d, 7)
# cf = Edge(c, f, 4)
# ci = Edge(c, i, 2)
# de = Edge(d, e, 9)
# df = Edge(d, f, 14)
# ef = Edge(e, f, 10)
# fg = Edge(f, g, 2)
# gh = Edge(g, h, 1)
# gi = Edge(g, i, 6)
# hi = Edge(h, i, 7)
# edges_g = [ab, ah, bc, bh, cd, cf, ci, de, df, ef, fg, gh, gi, hi]

# exemple_diapo = Graph("exemple_diapo1",nodes_g,edges_g)
# exemple_diapo2 = Graph("exemple_diapo2",deepcopy(nodes_g),deepcopy(edges_g))

# exemple_diapo_prim = prim(exemple_diapo1)
# show(exemple_diapo_prim)
#show(exemple_diapo1)

# exemple_diapo_kruskal = kruskal(exemple_diapo2)
# show(exemple_diapo_kruskal)

# @benchmark prim(deepcopy(graphe))
@benchmark kruskal(deepcopy(graphe))
