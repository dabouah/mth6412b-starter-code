### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 01664722-7669-11ee-3c47-c1263203734f
md"""
# Rapport Phase 2
Elodie Campeau et Daphné Boulanger
Notre dossier se trouve à l'adresse : 

#### 1 Structure de données pour les composantes connexes 
Ici nous avons modifié la structure de données Node afin de lui rajouter un attribut parent.

##### 1.1 Type Node
"""

# ╔═╡ 9a08b5c6-0a74-451f-91b4-77d20ac1be6f
md"""
```julia
\"\"\"Type représentant les noeuds d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)], 1, noeud1)
        noeud2 = Node("Kirk", "guitar", 2, noeud1)
        noeud3 = Node("Lars", 2, 3, noeud2)

\"\"\"
mutable struct Node{T} <: AbstractNode{T} 
  name::String
  data::T
  indice::Int
  parent::Union{Node{T}, Nothing}
end
```
"""

# ╔═╡ 40ae9328-c405-4617-a123-8609f0a4aae8
md"""
##### 1.2 Les constructeurs
"""

# ╔═╡ 2edac964-6048-41ee-a55f-1a8027103ea9
md"""
```julia
\"\"\"Crée un  noeud sans coordonnées\"\"\"
function Node(name::String; P::DataType=Int, indice::Int, parent::Node{T}) where T
  Node(name, zero(P), indice, parent)
end

\"\"\"Crée un  noeud sans parent\"\"\"
function Node(name::String, data::T, indice::Int) where T
  node = Node(name, data, indice, nothing)
  node.parent = node
  node
end

\"\"\"Crée un  noeud sans coordonnées ni parent\"\"\" 
function Node(name::String; T::DataType=Int, indice::Int) 
  node = Node(name, zero(T), indice, nothing)
  node.parent = node
  node
end
```
"""

# ╔═╡ f6f675e7-4f1e-4c2f-bd0c-f7618c0353a3
md"""Un noeud qui n'a pas de parent sera considéré comme étant la racine de l'arbre considéré et on va noter qu'il sera son propre parent.

Voici un exemple : """

# ╔═╡ ff0fe22a-0301-44e9-a764-973db00338f8
md"""
```julia 
a = Node("a",0,1)
show(a)
```
"""

# ╔═╡ a4cfb25d-e29e-4cf1-b200-04a437dadcbd
md"""
```julia
Julia> Node a, data: 0, indice: 1, parent: a
```
"""

# ╔═╡ ebd618a3-e933-479f-802a-607346a6f3bd
md"""
##### 1.3 Fonction root
"""

# ╔═╡ 5066f82c-5530-4799-9753-45a7facda25c
md"""
```julia
\"\"\"Renvoie la racine d'un arbre\"\"\"
function root(node::AbstractNode)
  root = node
  while root != parent(root)
    root = parent(root)
  end
  root
end
```
"""

# ╔═╡ 2292b8ff-820f-48cd-89ef-fa8a2d238780
md"""Cette fonction accède à la racine d'un noeud en allant chercher le parent du noeud en cours jusqu'à ce que celui-ci soit lui même.

Ici a est le parent de b qui est le parent de c. La racine de l'arbre est donc a. En appliquant la fonction root à c, nous devrions retrouver a."""

# ╔═╡ efaa6f85-c9ab-4d03-aafb-f9a77f5f5371
md"""
```julia
a = Node("a",0,1)
b = Node("b",0,2,a)
c = Node("c",0,3,b)

show(root(c))
```
"""

# ╔═╡ 394f460d-a37f-479d-8966-a7569c2f8d5d
md"""
```julia
Julia > Node a, data: 0, indice: 1, parent: a
```
"""

# ╔═╡ 7d0fc909-4da6-4bd4-af28-102e19e5d7d2
md"""
#### 2 Implémentation de Kruskal 

Ici nous avons créé un fonction kruskal qui prend en argument un graphe et qui va créer un autre graphe qui sera un arbre de recouvrement minimum du premier en suivant la méthode de Kruskal.

On utilise la fonction sort! qui va trier nos arêtes par ordre croissant de leur poids. Ensuite, on va passer sur toutes les arêtes pour vérifier si elles permettent d'agrandir l'arbre, si les deux noeuds de l'arête n'ont pas les mêmes racines. Si c'est le cas, on va l'ajouter au nouveau graphe et on va définir une des racines comme étant le parent de l'autre racine. Sinon, on passe juste à l'arête suivante.
"""

# ╔═╡ 6df98be7-a2a3-4587-a100-20cf3366fda7
md"""
```julia
\"\"\"Renvoie l'arbre de recouvrement minimal d'un graphe connexe en utilisant l'algorithme de Kruskal\"\"\"
function kruskal(graphe::Graph{T,W}) where {T,W}
    noeuds = nodes(graphe)
    edges_g = Edge{W,T}[]
    graphe_kruskal = Graph(\"Kruskal de \" * name(graphe), noeuds, edges_g)
    liste_edges = edges(graphe)
    liste_edges = sort!(liste_edges, by = x -> x.weight)
    for arete in liste_edges
        if weight(arete) > 0
            racine1 = root(nodes(arete)[1])
            racine2 = root(nodes(arete)[2])
            if racine1 != racine2
                add_edge!(graphe_kruskal,arete)
                racine1.parent = racine2
            end
        end
    end
    graphe_kruskal
end
```
"""

# ╔═╡ c6ba0074-4bfd-417c-8b2f-d6a2c2cd23f8
md"""Nous l'avons testé sur l'exemple du cours :"""

# ╔═╡ 4d76d7ee-2ab8-4bc5-a66b-1fc673a5b3d2
md"""
```julia
a = Node("a",0,1)
b = Node("b",0,2)
c = Node("c",0,3)
d = Node("d",0,4)
e = Node("e",0,5)
f = Node("f",0,6)
g = Node("g",0,7)
h = Node("h",0,8)
i = Node("i",0,9)
nodes_g = [a, b, c, d, e, f, g, h, i]

ab = Edge(a, b, 4)
ah = Edge(a, h, 8)
bc = Edge(b, c, 8)
bh = Edge(b, h, 11)
cd = Edge(c, d, 7)
cf = Edge(c, f, 4)
ci = Edge(c, i, 2)
de = Edge(d, e, 9)
df = Edge(d, f, 14)
ef = Edge(e, f, 10)
fg = Edge(f, g, 2)
gh = Edge(g, h, 1)
gi = Edge(g, i, 6)
hi = Edge(h, i, 7)
edges_g = [ab, ah, bc, bh, cd, cf, ci, de, df, ef, fg, gh, gi, hi]

exemple_diapo = Graph("nom",nodes_g,edges_g)

exemple_diapo_kruskal = kruskal(exemple_diapo)
show(exemple_diapo_kruskal)
```
"""

# ╔═╡ 2b783399-939f-4e01-baee-52fcb2272aba
md"""
```julia
Julia> Graph Kruskal de nom has 9 nodes and 8 edges.
the nodes in the graph are : 
Node a, data: 0, indice: 1, parent: b
Node b, data: 0, indice: 2, parent: d
Node c, data: 0, indice: 3, parent: i
Node d, data: 0, indice: 4, parent: e
Node e, data: 0, indice: 5, parent: e
Node f, data: 0, indice: 6, parent: h
Node g, data: 0, indice: 7, parent: h
Node h, data: 0, indice: 8, parent: d
Node i, data: 0, indice: 9, parent: h
the edges in the graph are : 
This edge links node 7 to node 8, weight: 1
This edge links node 3 to node 9, weight: 2
This edge links node 6 to node 7, weight: 2
This edge links node 1 to node 2, weight: 4
This edge links node 3 to node 6, weight: 4
This edge links node 3 to node 4, weight: 7
This edge links node 1 to node 8, weight: 8
This edge links node 4 to node 5, weight: 9
```
"""

# ╔═╡ 3677a130-e7f1-4180-8438-9b0dd24fb3a9
begin
struct Wow
filename
end

function Base.show(io::IO, ::MIME"image/png", w::Wow)
write(io, read(w.filename))
end
end

# ╔═╡ 55127c9f-de77-4692-86e7-03b882391e9b
md"""Voici l'arbre de parentalité des sommets du graphe. Il a une hauteur de 4."""

# ╔═╡ 4deebe2d-5e7a-4460-bcef-84ce632776d3
Wow("image1.jpg")

# ╔═╡ c93c005d-4e3a-4fd0-9057-3d37af7d7b0f
md"""
#### 3 Heuristiques d'accélération """

# ╔═╡ 93749c4b-f78a-48f3-a92a-50e317c56dd8
md"""
##### 3.1 Heuristique 1 : Union via le rang
Cette heuristique permet de joindre 2 arbres de façon à minimiser la hauteur de l'arbre final.

Pour l'implémenter nous avons d'abord ajouté un attribut rang à la structure de données Node. """

# ╔═╡ 5a39f6e1-b3ad-4496-b652-3789772785ea
md"""
```julia
\"\"\"Type représentant les noeuds d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)], 1, noeud1, 2)
        noeud2 = Node("Kirk", "guitar", 2, noeud1, 1)
        noeud3 = Node("Lars", 2, 3, noeud2, 0)

\"\"\"
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  indice::Int
  parent::Union{Node{T}, Nothing}
  rang::Int
end
```
"""

# ╔═╡ af3f28e6-73fa-4e73-a82f-b077413a7053
md"""Ensuite nous avons créé une fonction union\_via\_rang qui va comparer les rangs des racines de nos deux arbres pour déterminer qui sera le parent de l'autre et nous avons utilisé cette fonction dans la fonction kruskal.
"""

# ╔═╡ 73e1d855-2f41-4dc8-b6c9-e47b3a1b8cda
md"""
```julia
\"\"\"Joint deux arbres selon le rang des racines\"\"\"
function union_via_rang(node1::Node, node2::Node)
    rang1 = rang(node1)
    rang2 = rang(node2)
    if rang1 == rang2
        node1.parent = node2
        node2.rang = rang(node2)+1
    elseif rang1 > rang2
        node2.parent = node1
    else
        node1.parent = node2
    end
end
```
"""

# ╔═╡ f7b15d92-cdef-428f-ab2d-f4ab0510ede7
md"""
```julia
\"\"\"Renvoie l'arbre de recouvrement minimal d'un graphe connexe en utilisant l'algorithme de Kruskal\"\"\"
function kruskal(graphe::Graph{T,W}) where {T,W}
    noeuds = nodes(graphe)
    edges_g = Edge{W,T}[]
    graphe_kruskal = Graph("Kruskal de " * name(graphe), noeuds, edges_g)
    liste_edges = edges(graphe)
    liste_edges = sort!(liste_edges, by = x -> x.weight)
    for arete in liste_edges
        if weight(arete) > 0
            racine1 = root(nodes(arete)[1])
            racine2 = root(nodes(arete)[2])
            if racine1 != racine2
                add_edge!(graphe_kruskal,arete)
                union_via_rang(racine1, racine2)
            end
        end
    end
    graphe_kruskal
end
```
"""

# ╔═╡ da2aeddb-2ae1-4b29-8269-56b1dbc28658
md"""En le testant sur l'exemple du cours, on obtient le même arbre de recouvrement minimum mais les parents des noeuds sont différents.
"""

# ╔═╡ 77d9be73-92f5-4fcc-b03d-6a764d088230
md"""
```julia
Julia> Graph Kruskal de nom has 9 nodes and 8 edges.
the nodes in the graph are : 
Node a, data: 0, indice: 1, parent: b
Node b, data: 0, indice: 2, parent: h
Node c, data: 0, indice: 3, parent: i
Node d, data: 0, indice: 4, parent: h
Node e, data: 0, indice: 5, parent: h
Node f, data: 0, indice: 6, parent: h
Node g, data: 0, indice: 7, parent: h
Node h, data: 0, indice: 8, parent: h
Node i, data: 0, indice: 9, parent: h
the edges in the graph are : 
This edge links node 7 to node 8, weight: 1
This edge links node 3 to node 9, weight: 2
This edge links node 6 to node 7, weight: 2
This edge links node 1 to node 2, weight: 4
This edge links node 3 to node 6, weight: 4
This edge links node 3 to node 4, weight: 7
This edge links node 1 to node 8, weight: 8
This edge links node 4 to node 5, weight: 9
```
"""

# ╔═╡ 09a49dd1-fe3d-42ef-a715-68551157ee89
md"""Voici l'arbre de parentalité des sommets du graphe. Il a une hauteur de 2."""

# ╔═╡ 932fdd3d-2817-4581-9b7f-ad14bd2aea42
Wow("image2.jpg")

# ╔═╡ c017c5b2-e01c-4ab0-9850-37241e3f3b55
md"""
##### 3.2 Question concernant le rang
"""

# ╔═╡ 3d471cd5-f7d1-4c3c-835f-2a003b995ff4
md"""
##### 3.3 Heuristique 2 : Compression des chemins
"""

# ╔═╡ 72ab8012-8928-4e0d-b024-8ba2b807d532
md"""Nous avons modifié la méthode root de la structure de données Node afin qu'il modifie l'arbre de parentalité lors de la recherche de la racine.
"""

# ╔═╡ d4424abd-33dc-478a-ba82-f26e620172d2
md"""
```julia
\"\"\"Renvoie la racine d'un arbre\"\"\"
function root(node::AbstractNode)
  root = node
  remontee = Node[]
  while root != parent(root)
    push!(remontee,root)
    root = parent(root)
  end
  for noeud in remontee
    noeud.parent = root
  end
  root
end
```
"""

# ╔═╡ Cell order:
# ╟─01664722-7669-11ee-3c47-c1263203734f
# ╟─9a08b5c6-0a74-451f-91b4-77d20ac1be6f
# ╟─40ae9328-c405-4617-a123-8609f0a4aae8
# ╟─2edac964-6048-41ee-a55f-1a8027103ea9
# ╟─f6f675e7-4f1e-4c2f-bd0c-f7618c0353a3
# ╟─ff0fe22a-0301-44e9-a764-973db00338f8
# ╟─a4cfb25d-e29e-4cf1-b200-04a437dadcbd
# ╟─ebd618a3-e933-479f-802a-607346a6f3bd
# ╟─5066f82c-5530-4799-9753-45a7facda25c
# ╟─2292b8ff-820f-48cd-89ef-fa8a2d238780
# ╟─efaa6f85-c9ab-4d03-aafb-f9a77f5f5371
# ╟─394f460d-a37f-479d-8966-a7569c2f8d5d
# ╟─7d0fc909-4da6-4bd4-af28-102e19e5d7d2
# ╟─6df98be7-a2a3-4587-a100-20cf3366fda7
# ╟─c6ba0074-4bfd-417c-8b2f-d6a2c2cd23f8
# ╟─4d76d7ee-2ab8-4bc5-a66b-1fc673a5b3d2
# ╟─2b783399-939f-4e01-baee-52fcb2272aba
# ╟─3677a130-e7f1-4180-8438-9b0dd24fb3a9
# ╟─55127c9f-de77-4692-86e7-03b882391e9b
# ╟─4deebe2d-5e7a-4460-bcef-84ce632776d3
# ╟─c93c005d-4e3a-4fd0-9057-3d37af7d7b0f
# ╟─93749c4b-f78a-48f3-a92a-50e317c56dd8
# ╟─5a39f6e1-b3ad-4496-b652-3789772785ea
# ╟─af3f28e6-73fa-4e73-a82f-b077413a7053
# ╟─73e1d855-2f41-4dc8-b6c9-e47b3a1b8cda
# ╟─f7b15d92-cdef-428f-ab2d-f4ab0510ede7
# ╟─da2aeddb-2ae1-4b29-8269-56b1dbc28658
# ╟─77d9be73-92f5-4fcc-b03d-6a764d088230
# ╟─09a49dd1-fe3d-42ef-a715-68551157ee89
# ╟─932fdd3d-2817-4581-9b7f-ad14bd2aea42
# ╟─c017c5b2-e01c-4ab0-9850-37241e3f3b55
# ╟─3d471cd5-f7d1-4c3c-835f-2a003b995ff4
# ╟─72ab8012-8928-4e0d-b024-8ba2b807d532
# ╟─d4424abd-33dc-478a-ba82-f26e620172d2
