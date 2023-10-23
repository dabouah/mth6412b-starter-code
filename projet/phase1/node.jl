import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  indice::Int
  parent::Union{Node{T}, Nothing}
end

"""Crée un  noeud sans coordonnées"""
function Node(name::String; P::DataType=Int, indice::Int, parent::Node{T}) where T
  Node(name, zero(P), indice, parent)
end

"""Crée un  noeud sans parent"""
function Node(name::String, data::T, indice::Int) where T
  node = Node(name, data, indice, nothing)
  node.parent = node
  node
end

"""Crée un  noeud sans coordonnées ni parent""" 
function Node(name::String; T::DataType=Int, indice::Int) 
  node = Node(name, zero(T), indice, nothing)
  node.parent = node
  node
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie l'indice du noeud."""
indice(node::AbstractNode) = node.indice

"""Renvoie le parent du noeud."""
parent(node::AbstractNode) = node.parent

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node), ", indice: ", indice(node), ", parent: ", name(parent(node)))
end
