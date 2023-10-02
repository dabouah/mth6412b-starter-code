import Base.show


"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{W} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud_1 = Node("James", [π, exp(1)])
        noeud_2 = Node("Kirk", "guitar")
        arête = Edge("Larry", noeud_1, noeud_2, 10)

"""
mutable struct Edge{W,T} <: AbstractEdge{W}
  name::String
  node_1::Node{T}
  node_2::Node{T}
  weight::W
end

# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont des champs `name`, `nodes` et `weight`.

"""Renvoie le nom de l'arête."""
name(edge::AbstractEdge) = edge.name

"""Renvoie les deux noeuds de l'arête."""
nodes(edge::AbstractEdge) = [edge.node_1, edge.node_2]

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Assigne un poids très grand à une arête quand on ne le connait pas encore"""
function Edge(name::String, node_1::Node{T}, node_2::Node{T})
    Edge(name, node_1, node_2, 9999999)
end

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("Edge ", name(edge), ", nodes: ", nodes(edge), ", weight: ", weight(edge))
end
