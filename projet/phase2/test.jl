using Test

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal.jl")
include("queue.jl")
include("prim.jl")

"""Tests unitaires de la structure Node"""

a = Node("a", 0, 1)
@test name(a) == "a"
@test data(a) == 0
@test indice(a) == 1
@test parent(a) == a
@test rang(a) == 0
@test min_weight(a) == Inf
@test isnothing(arete_min(a))

b = Node("b", 2, a; P = Int64)
@test name(b) == "b"
@test data(b) == zero(Int64)
@test indice(b) == 2
@test parent(b) == a
@test rang(b) == 0
@test min_weight(b) == Inf
@test isnothing(arete_min(b))

c = Node("c", 3; P = Int64)
@test name(c) == "c"
@test data(c) == zero(Int64)
@test indice(c) == 3
@test parent(c) == c
@test rang(c) == 0
@test min_weight(c) == Inf
@test isnothing(arete_min(c))

@test root(a) == a
@test root(b) == a 
@test root(c) == c

c.parent = b

@test root!(c) == a
@test parent(c) == a

"""Tests unitaires de la structure Edge"""

ab = Edge(a, b, 100.0)
@test name(ab) == "ab"
@test weight(ab) == 100.0
@test nodes(ab)[1] == a
@test nodes(ab)[2] == b

ac = Edge(a, c)
@test name(ac) == "ac"
@test weight(ac) == Inf
@test nodes(ac)[1] == a
@test nodes(ac)[2] == c

"""Tests unitaires de la structure Graph"""

graphe1 = Graph("graphe1", [a,b]; W = Float64)
@test name(graphe1) == "graphe1"
@test nodes(graphe1) == [a,b]
@test nb_nodes(graphe1) == 2
@test edges(graphe1) == Edge{Float64, Int64}[]
@test nb_edges(graphe1) == 0

@test add_edge!(graphe1, ac) == "Attention : un noeud de l'arête n'existe pas dans le graphe"

add_node!(graphe1, c)

@test name(graphe1) == "graphe1"
@test nodes(graphe1) == [a,b,c]
@test nb_nodes(graphe1) == 3

add_edge!(graphe1, ab)
add_edge!(graphe1, ac)

@test edges(graphe1) == [ab, ac]
@test nb_edges(graphe1) == 2

graphe2 = Graph("graphe2"; T = Int64, W = Float64)

@test name(graphe2) == "graphe2"
@test nodes(graphe2) == Node{Int64}[]
@test nb_nodes(graphe2) == 0
@test edges(graphe2) == Edge{Float64, Int64}[]
@test nb_edges(graphe2) == 0

add_node!(graphe2, c)
add_node!(graphe2, b)
add_node!(graphe2, a)
add_edge!(graphe2, ac)
add_edge!(graphe2, ab)

@test name(graphe2) == "graphe2"
@test nodes(graphe2) == [c, b, a]
@test nb_nodes(graphe2) == 3
@test edges(graphe2) == [ac, ab]
@test nb_edges(graphe2) == 2

@test get_node_from_indice(graphe1, 1) == a
@test get_node_from_indice(graphe1, 2) == b
@test get_node_from_indice(graphe1, 3) == c

"""Tests unitaires de la structure Queue"""

a.min_weight = 2
b.min_weight = 3
q = Queue([a,b,c])

@test popmin!(q) == a
@test q.items == [b,c]
@test popmin!(q) == b
@test q.items == [c]

"""Tests unitaires du fichier kruskal"""

a.parent = a
a.rang = 0
b.parent = b
b.rang = 0
c.parent = c
c.rang = 0
union_via_rang(root(a),root(b))

@test parent(a) == b
@test rang(a) == 0
@test rang(b) == 1

union_via_rang(root(a),root(c))

@test parent(c) == b
@test rang(c) == 0
@test rang(b) == 1

a = Node("a",0,1)
b = Node("b",0,2)
h = Node("h",0,8)
nodes_g = [a, b, h]

ab = Edge(a, b, 4)
ah = Edge(a, h, 8)
bh = Edge(b, h, 11)
edges_g = [ab, ah, bh]

g = Graph("test", nodes_g, edges_g)
k = kruskal(g)

@test name(k) == "Kruskal de test"
@test nodes(k) == [a, b, h]
@test edges(k) == [ab, ah]
@test parent(h) == b
@test parent(a) == b
@test parent(b) == b
@test rang(a) == 0
@test rang(b) == 1
@test rang(h) == 0

"""Tests unitaires du fichier prim"""

a = Node("a",0,1)
b = Node("b",0,2)
h = Node("h",0,8)
nodes_g = [a, b, h]

ab = Edge(a, b, 4)
ah = Edge(a, h, 8)
bh = Edge(b, h, 11)
edges_g = [ab, ah, bh]

@test min_weight(b) == Inf
@test min_weight(h) == Inf

g = Graph("test", nodes_g, edges_g)
file_prio = Queue([b,h])
noeud_couvr = [a]
update_min_weight!(g, file_prio, noeud_couvr)

@test min_weight(b) == 4
@test min_weight(h) == 8

a = Node("a",0,1)
b = Node("b",0,2)
h = Node("h",0,8)
nodes_g = [a, b, h]

ab = Edge(a, b, 4)
ah = Edge(a, h, 8)
bh = Edge(b, h, 11)
edges_g = [ab, ah, bh]

g = Graph("test", nodes_g, edges_g)
p = prim(g)

@test name(p) == "Prim de test"
@test name(nodes(p)[1]) == "a"
@test name(nodes(p)[2]) == "b"
@test name(nodes(p)[3]) == "h"
@test name(edges(p)[1]) == "ab"
@test name(edges(p)[2]) == "ah"