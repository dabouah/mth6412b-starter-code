import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)], 1, noeud1, 2)
        noeud2 = Node("Kirk", "guitar", 2, noeud1, 1)
        noeud3 = Node("Lars", 2, 3, noeud2, 0)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  indice::Int
  parent::Union{Node{T}, Nothing}
  rang::Int
  min_weight::Number
end

"""Crée un  noeud sans coordonnées"""
function Node(name::String; P::DataType=Int, indice::Int, parent::Node{T}) where T
  Node(name, zero(P), indice, parent, rang(parent)-1, Inf)
end

"""Crée un  noeud sans parent"""
function Node(name::String, data::T, indice::Int) where T
  node = Node(name, data, indice, nothing, 0, Inf)
  node.parent = node
  node
end

"""Crée un  noeud sans coordonnées ni parent""" 
function Node(name::String; T::DataType=Int, indice::Int) 
  node = Node(name, zero(T), indice, nothing, 0, Inf)
  node.parent = node
  node
end

"""Renvoie la racine d'un arbre"""
function root(node::AbstractNode)
  root = node
  remontee = Node[]
  #rang_min = rang(root)
  while root != parent(root)
    push!(remontee,root)
    root = parent(root)
  end
  for noeud in remontee
    noeud.parent = root
    #noeud.rang = rang_min
  end
  root
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

"""Renvoie le rang du noeud."""
rang(node::AbstractNode) = node.rang

"""Renvoie le poids du noeud."""
min_weight(node::AbstractNode) = node.min_weight

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node), ", indice: ", indice(node), ", parent: ", name(parent(node)))
end
