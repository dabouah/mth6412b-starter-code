import Base.show


"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{W,T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud1 = Node("James", [4, 6], 1, noeud1, 2, inf, nothing)
        noeud2 = Node("Kirk", [8, 2], 2, noeud1, 1, 2, "arete1")
        arête = Edge(noeud_1, noeud_2, 10)

"""
mutable struct Edge{W,T} <: AbstractEdge{W,T}
  node_1::Node{T}
  node_2::Node{T}
  weight::W
  name::String
end

"""Crée une arete sans nom"""
function Edge(node_1::Node{T}, node_2::Node{T}, weight::W) where {W,T}
  Edge(node_1::Node{T}, node_2::Node{T}, weight::W, name(node_1)*name(node_2))
end

"""Crée une arête avec un poids par défaut"""
function Edge(node_1::Node{T}, node_2::Node{T}) where T
    Edge(node_1, node_2, Inf, name(node_1)*name(node_2))
end

# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont des champs `node_1`, `node_2` et `weight`.

"""Renvoie les deux noeuds de l'arête."""
nodes(edge::AbstractEdge) = [edge.node_1, edge.node_2]

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Renvoie le nom de l'arête."""
name(edge::AbstractEdge) = edge.name


"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("This edge links node ", indice(edge.node_1), " to node ", indice(edge.node_2), ", weight: ", weight(edge))
end
