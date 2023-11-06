### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 01664722-7669-11ee-3c47-c1263203734f
md"""
# Rapport Phase 2
Elodie Campeau et Daphné Boulanger

Notre dossier se trouve à l'adresse : https://github.com/dabouah/mth6412b-starter-code/tree/phase2

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

Ici nous avons créé une fonction kruskal qui prend en argument un graphe et qui va créer un autre graphe qui sera un arbre de recouvrement minimum du premier en suivant la méthode de Kruskal.

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

# ╔═╡ 51c00502-7181-4eef-87f2-8e77781e256f
md"""L'arbre de recouvrement obtenu est le même que celui représenté dans les notes de cours.
"""

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

# ╔═╡ 35b5706f-62c0-4461-ad4f-5914c7fea999
md"""
Dans le pire des cas, l'arbre de parentalité d'un graphe est une seule longue chaine dans laquelle il n'existe qu'une seule feuille. La racine d'un tel arbre aura un rang de $|S|-1$. Puisqu'il s'agit du pire cas, on peut conclure que le rang d'un noeud sera toujours inférieur à $|S|-1$.

Ensuite, prouvons que ce rang sera toujours inférieur à la partie entière de $log{_2}{|S|}$. D'abord, un noeud de rang $k$ aura au minimum $2^k$ noeuds dans son sous-arbre. En effet, un noeud de rang $k$ liera, dans le pire des cas, deux noeuds de rang $k-1$. De la même façon, un noeud de rang $k-1$ liera, dans le pire des cas, deux noeuds de rang $k-2$ et ainsi de suite. Par induction, on déduit qu'un noeud de rang $k$ aura au minimum $2^k$ noeuds dans son sous-arbre. Cela signifie qu'un graphe avec n noeuds ($n=|S|$) aura au maximum $\frac{n}{2^k}$ noeud dont le rang est k.

Soit P le nombre de noeuds de rang k, on a : 

$P ≤ \frac{n}{2^k}$

Soit le rang maximal ($R$) du graphe, on aura nécessairement un seul noeud de rang $R$, celui-ci sera la racine. On a donc, selon l'équation au dessus:

$1 ≤ \frac{n}{2^R}$

En appliquant le $\log$ de chaque côté de cette équation, on trouve:

$0 ≤ log{_2}{n} - R$

$\iff R ≤ log{_2}{n}$

Puisque $R$ est un nombre entier on ne conserve que la partie entière.
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

# ╔═╡ 698bad60-410b-48c6-bd74-9c9fc3835a4e
md"""
En utilisant la compression des chemins, l'arbre de parentilité obtenu est celui ci-dessous. La hauteur est de 2, ce qui est meilleur que l'arbre sans utiliser d'heuristique d'accélération.
"""

# ╔═╡ c052e645-9d0b-4e3d-bc66-d34848aef77a
Wow("image3.jpg")

# ╔═╡ 8781fb9b-aa65-4132-85f9-6ec100f5ea95
md"""
#### 4 Implémentation de Prim

Ici nous avons créé une fonction prim qui prend en argument un graphe et qui va créer un autre graphe qui sera un arbre de recouvrement minimum du premier en suivant la méthode de Prim.

Dans les sections suivantes, nous allons voir les modifications faites aux structures de données existantes, la création d'une structure de données `Queue` et les fonctions que nous avons créées pour cela.
"""

# ╔═╡ 5e54acd9-28d9-4b52-a482-c29a9bced6d7
md"""
##### 4.1 Modification de la structure de données Node

Nous avons, tout d'abord, deux attributs à la structure `Node` qui sont `min_weight`, qui stocke le poids de l'arête de poids minimum qui permet de lier le noeud à l'arbre de recouvrement, et `arete_min` qui stocke le nom de cette arête.

```julia
\"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)], 1, noeud1, 2, inf, nothing)
        noeud2 = Node("Kirk", "guitar", 2, noeud1, 1, 2, "arete1")
        noeud3 = Node("Lars", 2, 3, noeud2, 0, 8, "arete2")

\"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  indice::Int
  parent::Union{Node{T}, Nothing}
  rang::Int
  min_weight::Number
  arete_min::Union{String, Nothing}
end
```

Nous avons modifié les constructeurs afin qu'ils créent des noeuds sans `arete_min` et avec un `min_weight` de valeur infini.

```julia
\"""Crée un  noeud sans coordonnées\"""
function Node(name::String; P::DataType=Int, indice::Int, parent::Node{T}) where T
  Node(name, zero(P), indice, parent, rang(parent)-1, Inf, nothing)
end

\"""Crée un  noeud sans parent\"""
function Node(name::String, data::T, indice::Int) where T
  node = Node(name, data, indice, nothing, 0, Inf, nothing)
  node.parent = node
  node
end

\"""Crée un  noeud sans coordonnées ni parent\""" 
function Node(name::String; T::DataType=Int, indice::Int) 
  node = Node(name, zero(T), indice, nothing, 0, Inf, nothing)
  node.parent = node
  node
end
```
"""

# ╔═╡ 92ca9f5e-6988-4861-bbea-dbde7ea369e8
md"""
#### 4.2 Modification de la structure Edge
"""

# ╔═╡ 91e133ad-841d-4b27-86dc-0710643a5098
md"""
Nous avons ajouté un attribut à la structure Edge qui est name.
"""

# ╔═╡ 06abd10c-c2d2-47ae-a2e8-d6638bc2353b
md"""
```julia
\"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud1 = Node("James", [4, 6], 1, noeud1, 2, inf, nothing)
        noeud2 = Node("Kirk", [8, 2], 2, noeud1, 1, 2, "arete1")
        arête = Edge(noeud_1, noeud_2, 10, "noeud_1-noeud_2")

\"""
mutable struct Edge{W,T} <: AbstractEdge{W,T}
  node_1::Node{T}
  node_2::Node{T}
  weight::W
  name::String
end
```
"""

# ╔═╡ 575788b3-24dd-478e-8c6f-556917903f89
md"""
Nous avons modifié les constructeurs afin qu'ils créent automatiquement le `name` de l'arête.
"""

# ╔═╡ 1fd84da1-d5b6-4168-975c-1eb79e7a8e7e
md"""
```julia
\"""Crée une arete sans nom\"""
function Edge(node_1::Node{T}, node_2::Node{T}, weight::W) where {W,T}
  Edge(node_1::Node{T}, node_2::Node{T}, weight::W, name(node_1)*"-"*name(node_2))
end


\"""Crée une arête avec un poids par défaut\"""
function Edge(node_1::Node{T}, node_2::Node{T}) where T
    Edge(node_1, node_2, Inf, name(node_1)*"-"*name(node_2))
end
```
"""

# ╔═╡ 1b6f2c69-296a-407c-b431-0f6424fa1e5b
md"""
##### 4.3 Structure de données `Queue`

Nous avons créé une structure de données `Queue` qui fonctionne comme une file de priorité qui stocke une liste de `Node` dont la priorité est l'argument `min_weight` du noeud. Le noeud qui sera priorisé est celiui qui aura le plus petit `min_weight`.

La fonction `popmin!()` retire de notre file l'élément à prioriser et nous le renvoie.

```julia
\"""Type abstrait dont d'autres types de piles dériveront.\"""
abstract type AbstractQueue{T} end

\"""Type représentant une file avec des éléments de type T.\"""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{Node{T}}
end

Queue{T}() where T = Queue(Node{T}[])

\"""Retire et renvoie l'élément ayant la plus haute priorité.\"""
function popmin!(q::Queue{T}) where T
    lowest = q.items[1]
    for item in q.items
        if min_weight(item) < min_weight(lowest)
            lowest = item
        end
    end
    deleteat!(q.items, findfirst(x->x==lowest,q.items))
    lowest
end
```
"""

# ╔═╡ 43f88801-47d2-4af2-a894-0d2c7b272fd6
md"""

##### 4.4 Fonction `prim()` et complément

Nous nous sommes rendues compte qu'il serait nécessaire de mettre à jour les `min_weight` de nos noeuds à chaque itération (ajout d'une arête au graphe), alors nous avons créé une fonction `update_min_weight()` qui met à jour les attributs `parent`, `min_weight` et `arete_min`.

Pour ce faire, on boucle sur les arêtes, et on va mettre à jour les arguments des noeuds appartenant à la liste des noeuds non présents dans l'arbre de recouvrement, si l'autre noeud de l'arête en fait partie. 

```julia
\"""Met à jour les poids minimum de tous les noeuds\"""
function update_min_weight!(graph::Graph{T,W}, file_priorite::Queue{T}, noeuds_couvrant::Vector{Node{T}}) where {T,W}
    for arete in edges(graph)
        noeud_un = nodes(arete)[1]
        noeud_deux = nodes(arete)[2]
        if noeud_un in file_priorite.items && noeud_deux in noeuds_couvrant
            if min_weight(noeud_un) > weight(arete)
                noeud_un.min_weight = weight(arete)
                noeud_un.parent = noeud_deux
                noeud_un.arete_min = name(arete)
            end
        elseif noeud_deux in file_priorite.items && noeud_un in noeuds_couvrant
            if min_weight(noeud_deux) > weight(arete)
                noeud_deux.min_weight = weight(arete)
                noeud_deux.parent = noeud_un
                noeud_deux.arete_min = name(arete)
            end
        end
    end
end
```

Cette fonction est utilisée par la fonction `prim()`, où nous définissons un nouveau graphe avec tous les noeuds du graphe initiale mais sans arêtes, une file de priorité contenant tous les noeuds du graphe, une liste des noeuds qui font déjà partie de l'arbre de recouvrement (vide à l'initialisation).

Nous définissons ensuite une source (premier noeud de la file), que nous ajoutons à l'arbre de recouvrement. Nous allons alors faire des itérations pour ajouter les arêtes pertinentes selon l'algorithme de Prim (mise à jour des poids, recherche du noeud de poids minimum, ajout de l'arête au graphe à renvoyer, ajout du noeud aux noeuds couverts par l'arbre de recouvrement).

```julia
\"""Renvoie l'arbre de recouvrement minimal d'un graphe connexe en utilisant l'algorithme de Prim\"""
function prim(graphe::Graph{T,W}) where {T,W}
    noeuds = nodes(graphe)
    for noeud in noeuds
        noeud.parent = nothing
    end
    noeuds[1].min_weight = 0
    noeuds[1].parent = noeuds[1]
    autre_noeuds = Node{T}[]
    noeuds_prim = Node{T}[]
    for noeud in noeuds
        push!(autre_noeuds,noeud)
        push!(noeuds_prim,noeud)
    end
    file_priorite = Queue(autre_noeuds)
    prem_noeud = popmin!(file_priorite)
    noeuds_couvrant = Node{T}[]
    push!(noeuds_couvrant,prem_noeud)
    edges_g = Edge{W,T}[]
    graphe_prim = Graph("Prim de " * name(graphe), noeuds_prim, edges_g)
    update_min_weight!(graphe, file_priorite, noeuds_couvrant)
    while !isempty(file_priorite.items)
        noeud_a_ajouter = popmin!(file_priorite)
        push!(noeuds_couvrant,noeud_a_ajouter)
        for arete in edges(graphe)
            if name(arete) == arete_min(noeud_a_ajouter)
                push!(graphe_prim.edges, arete)
            end
        end
        update_min_weight!(graphe, file_priorite, noeuds_couvrant)
    end
    graphe_prim
end
```
"""

# ╔═╡ 78e28996-5e3a-48ce-8dfb-4a40898c36cf
md"""
Nous l'avons testé sur l'exemple du cours :
"""

# ╔═╡ 981ca644-fbc0-489f-b3d9-dd8304caafd1
md"""

```julia
include("node.jl")
include("edge.jl")
include("graph.jl")
include("prim.jl")
include("queue.jl")

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

exemple_diapo_prim = prim(exemple_diapo)
show(exemple_diapo_prim)

```

```julia
Julia> Graph Prim de exemple_diapo1 has 9 nodes and 8 edges.
the nodes in the graph are : 
Node a, data: 0, indice: 1, parent: a, poids min: 0, arete: nothing
Node b, data: 0, indice: 2, parent: a, poids min: 4, arete: ab
Node c, data: 0, indice: 3, parent: b, poids min: 8, arete: bc
Node d, data: 0, indice: 4, parent: f, poids min: 14, arete: df
Node e, data: 0, indice: 5, parent: f, poids min: 10, arete: ef
Node f, data: 0, indice: 6, parent: c, poids min: 4, arete: cf
Node g, data: 0, indice: 7, parent: i, poids min: 6, arete: gi
Node h, data: 0, indice: 8, parent: i, poids min: 7, arete: hi
Node i, data: 0, indice: 9, parent: c, poids min: 2, arete: ci
the edges in the graph are : 
This edge links node 1 to node 2, weight: 4
This edge links node 2 to node 3, weight: 8
This edge links node 3 to node 9, weight: 2
This edge links node 3 to node 6, weight: 4
This edge links node 7 to node 9, weight: 6
This edge links node 8 to node 9, weight: 7
This edge links node 5 to node 6, weight: 10
This edge links node 4 to node 6, weight: 14
```

"""

# ╔═╡ 626cb357-f10c-458a-8b30-a79018a30b9e
md"""
L'arbre de recouvrement obtenu est le même que celui représenté dans les notes de cours.
"""

# ╔═╡ 7eb87ca2-3a16-4048-9376-07022c7043a3
md"""
#### 5 Tests unitaires
"""

# ╔═╡ 9818bd60-1e44-4f49-82d4-3cbd9d8d7367
md"""Nous avons créé un fichier qui permet de faire des tests unitaires pour vérifier le bon fonctionnement de toutes les structures et fonctions créées. Les voici ci-dessous accompagné du résultat.
"""

# ╔═╡ b32e6495-fe69-468a-b762-52e078503ea9
md"""
```julia
using Test

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal.jl")
include("queue.jl")
include("prim.jl")

\"""Tests unitaires de la structure Node\"""

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

\"""Tests unitaires de la structure Edge\"""

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

\"""Tests unitaires de la structure Graph\"""

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

\"""Tests unitaires de la structure Queue\"""

a.min_weight = 2
b.min_weight = 3
q = Queue([a,b,c])

@test popmin!(q) == a
@test q.items == [b,c]
@test popmin!(q) == b
@test q.items == [c]

\"""Tests unitaires du fichier kruskal\"""

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

\"""Tests unitaires du fichier prim\"""

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
```
"""

# ╔═╡ f14501a4-f8bc-43ba-9b58-1e722dff68d9
md"""
```julia
Julia> Test Passed
```
"""

# ╔═╡ 6dc44de6-e728-4105-a18b-2e183346ad8e
md"""
#### 6 Solution de plusieurs instances de TSP symétrique
"""

# ╔═╡ c612a580-36ad-4ad1-bf94-5d0a94e12c58
md"""
Nous avons fait tourné les algorithmes pour 3 exemples et nous avons étudié les temps d'exécution ainsi que la mémoire utilisée par chaque algortihme. 

Dans les tableaux ci-dessous, nous avons mis en italique les meilleures valeurs par exemple.
"""

# ╔═╡ c2e0b0a7-ac88-49e5-bf16-161b60a8f33f
md"""
##### 6.1 Intervalle de temps d'exécution
"""

# ╔═╡ 9959c744-5ee8-4a03-a17c-5237c2db92d6
md"""
| 	| Prim	| Kruskal + 2 heuristiques	| Kruskal + compression des chemins	| Kruskal + union via rang	| Kruskal seul	|
|---------------	|------	|--------------------------	|------------------------	|--------------------------	|--------------	|
| exemple diapo 	| 146,504μs - 4,948ms	| 98,916μs - 5,469ms	| 106,333μs - 6,344ms	| **_87,831μs - 4,191ms_**	| 88,760μs - 4,540ms	|
| bayg29	| 6,026ms - 48,701ms	| 1,756ms - 35,995ms	| 1,767ms - 9,554ms	| **_1,379ms - 7,900ms_**	| 1,377ms - 48,545ms	|
| brg180	| 1,527s - 1,568s	| 70,100ms - 122,184ms	| 70,003ms - 96,767ms	| 54,706ms - 137,543ms	| **_58,563ms - 87,371ms_**	|
"""

# ╔═╡ 79c8454e-1f63-40e8-be82-b0ef85fb93e7
md"""
Au niveau des intervalles de temps d'exécution, l'algorithme de Kruskal est toujours meilleur que celui de Prim. Il est encore plus performant lorsqu'il est utilisé sans heuristique où avec l'heuristique d'union via le rang.
"""

# ╔═╡ ec245051-e065-44d2-9f1d-70d354140221
md"""
##### 6.2 Médiane des temps d'exécution
"""

# ╔═╡ 09c00bd1-1533-4b76-b5ef-6aa267ccc415
md"""
|  	| Prim 	| Kruskal + 2 heuristiques 	| Kruskal + compression  	| Kruskal + union via rang 	| Kruskal seul 	|
|---	|---	|---	|---	|---	|---	|
| exemple diapo 	| 149,174μs	| 100,601μs	| 108,429μs	| **_88,748μs_** 	| 90,133μs	|
| bayg29 	| 6,857ms	| 1,939ms	| 1,865ms	| **_1,467ms_**	| 1,498ms	|
| brg180 	| 1,534s	| 72,268ms	| 72,376ms	| **_57,820ms_**	| 60,718ms	|
"""

# ╔═╡ fe52fa28-1f67-480f-98ae-269bcecefde1
md"""
L'algorithme de Kruskal accompagné de l'union via le rang semble être l'algorithme qui a la meilleure médiane de temps d'exécution.
"""

# ╔═╡ 2641f649-0ce0-4f59-a393-8fedbeef1762
md"""
##### 6.3 Moyenne et écart-type des temps d'exécution
"""

# ╔═╡ 22557f38-acc5-476d-9447-1cbe1cad2955
md"""
|  	| Prim 	| Kruskal + 2 heuristiques 	| Kruskal + compression  	| Kruskal + union via rang 	| Kruskal seul 	|
|---	|---	|---	|---	|---	|---	|
| exemple diapo 	| 169,180μs ± 108,338μs	| 109,263μs ± 77,961μs	| 135,017μs ± 120,347μs	| **_93,638μs ± 43,904μs_**	| 98,964μs ± 49,739μs	|
| bayg29 	| 7,642ms ± 2,648ms	| 2,137ms ± 967,380μs	| 1,998ms ± 562,446μs	| **_1,585ms ± 476,566μs_**	| 1,657ms ± 1,048ms	|
| brg180 	| 1,541s ± 18,589ms	| 76,211ms ± 9,913ms	| 75,025ms ± 5,886ms	| **_60,608ms ± 10,885ms_**	| 62,675ms ± 5,467ms	|
"""

# ╔═╡ a83e6b35-ed05-46af-97e0-1344ae23ba42
md"""
L'algorithme de Kruskal accompagné de l'union via le rang semble être l'algorithme qui a la meilleure moyenne de temps d'exécution.
"""

# ╔═╡ abc059d6-414e-47e4-b1a5-13455099f9fc
md"""
##### 6.4 Mémoire nécessaire
"""

# ╔═╡ 0234b297-c9d1-4730-8aeb-9208d88e5482
md"""
|  	| Prim 	| Kruskal + 2 heuristiques 	| Kruskal + compression  	| Kruskal + union via rang 	| Kruskal seul 	|
|---	|---	|---	|---	|---	|---	|
| exemple diapo 	| 23,64KiB	| 10,85KiB	| 8,8KiB	| **_6,16KiB_**	| **_6,16KiB_** 	|
| bayg29 	| 1,63MiB	| 283,23MiB	| 283,23MiB	| **_186,26KiB_**	| **_186,26KiB_**	|
| brg180 	| 371,690MiB	| 8,810MiB	| 8,800MiB 	| **_4,92MiB_**	| **_4,92MiB_**	|
"""

# ╔═╡ 131a203e-453c-47c0-b390-c56c0b778f4b
md"""
L'algorithme de Kruskal seul ou accompagné de l'union via le rang sont les algorithmes qui nécessitent le moins de mémoire.
"""

# ╔═╡ 5c0db688-c6bd-46c4-bb5f-71e3b58cdf42
md"""
##### 6.5 Conclusion
"""

# ╔═╡ 44466043-ce5f-42d2-8d3e-2961cf517847
md"""
L'algorithme de Kruskal accompagné de l'union via le rang (comme nous l'avons implémenté) est le meilleur algorithme toutes catégories confondues. 
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
# ╟─51c00502-7181-4eef-87f2-8e77781e256f
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
# ╟─35b5706f-62c0-4461-ad4f-5914c7fea999
# ╟─3d471cd5-f7d1-4c3c-835f-2a003b995ff4
# ╟─72ab8012-8928-4e0d-b024-8ba2b807d532
# ╟─d4424abd-33dc-478a-ba82-f26e620172d2
# ╟─698bad60-410b-48c6-bd74-9c9fc3835a4e
# ╟─c052e645-9d0b-4e3d-bc66-d34848aef77a
# ╟─8781fb9b-aa65-4132-85f9-6ec100f5ea95
# ╟─5e54acd9-28d9-4b52-a482-c29a9bced6d7
# ╟─92ca9f5e-6988-4861-bbea-dbde7ea369e8
# ╟─91e133ad-841d-4b27-86dc-0710643a5098
# ╟─06abd10c-c2d2-47ae-a2e8-d6638bc2353b
# ╟─575788b3-24dd-478e-8c6f-556917903f89
# ╟─1fd84da1-d5b6-4168-975c-1eb79e7a8e7e
# ╟─1b6f2c69-296a-407c-b431-0f6424fa1e5b
# ╟─43f88801-47d2-4af2-a894-0d2c7b272fd6
# ╟─78e28996-5e3a-48ce-8dfb-4a40898c36cf
# ╟─981ca644-fbc0-489f-b3d9-dd8304caafd1
# ╟─626cb357-f10c-458a-8b30-a79018a30b9e
# ╟─7eb87ca2-3a16-4048-9376-07022c7043a3
# ╟─9818bd60-1e44-4f49-82d4-3cbd9d8d7367
# ╟─b32e6495-fe69-468a-b762-52e078503ea9
# ╟─f14501a4-f8bc-43ba-9b58-1e722dff68d9
# ╟─6dc44de6-e728-4105-a18b-2e183346ad8e
# ╟─c612a580-36ad-4ad1-bf94-5d0a94e12c58
# ╟─c2e0b0a7-ac88-49e5-bf16-161b60a8f33f
# ╟─9959c744-5ee8-4a03-a17c-5237c2db92d6
# ╟─79c8454e-1f63-40e8-be82-b0ef85fb93e7
# ╟─ec245051-e065-44d2-9f1d-70d354140221
# ╟─09c00bd1-1533-4b76-b5ef-6aa267ccc415
# ╟─fe52fa28-1f67-480f-98ae-269bcecefde1
# ╟─2641f649-0ce0-4f59-a393-8fedbeef1762
# ╟─22557f38-acc5-476d-9447-1cbe1cad2955
# ╟─a83e6b35-ed05-46af-97e0-1344ae23ba42
# ╟─abc059d6-414e-47e4-b1a5-13455099f9fc
# ╟─0234b297-c9d1-4730-8aeb-9208d88e5482
# ╟─131a203e-453c-47c0-b390-c56c0b778f4b
# ╟─5c0db688-c6bd-46c4-bb5f-71e3b58cdf42
# ╟─44466043-ce5f-42d2-8d3e-2961cf517847
