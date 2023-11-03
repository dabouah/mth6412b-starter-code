import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)], 1)
        noeud2 = Node("Kirk", "guitar", 2)
        noeud3 = Node("Lars", 2, 3)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  indice::Int
end

"""Crée un  noeud sans coordonnées"""
function Node(name::String; P::DataType=Int, indice::Int)
  Node(name, zero(P), indice)
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie l'indice du noeud."""
indice(node::AbstractNode) = node.indice


"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node), ", indice: ", indice(node))
end
