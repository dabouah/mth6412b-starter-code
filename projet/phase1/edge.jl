import Base.show


"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{W,T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud_1 = Node("James", [π, exp(1)])
        noeud_2 = Node("Kirk", "guitar")
        arête = Edge(noeud_1, noeud_2, 10)

"""
mutable struct Edge{W,T} <: AbstractEdge{W,T}
  node_1::Node{T}
  node_2::Node{T}
  weight::W
end

# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont des champs `node_1`, `node_2` et `weight`.

"""Renvoie les deux noeuds de l'arête."""
nodes(edge::AbstractEdge) = [edge.node_1, edge.node_2]

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Crée une arête avec un poids par défaut"""
function Edge(node_1::Node{T}, node_2::Node{T}) where T
    Edge(node_1, node_2, 9999999)
end

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("This edge links node ", show(edge.node_1), "to node", show(edge.node_2), ", weight: ", weight(edge))
end
