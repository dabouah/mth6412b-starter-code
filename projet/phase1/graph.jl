import Base.show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T,W} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    edge1 = Edge(node2, node3, 10)
    edge2 = Edge(node1, node2, 25)
    G = Graph("Family tree", [node1, node2, node3], [edge1,edge2])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T,W} <: AbstractGraph{T,W}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{W,T}}
end

"""Crée un graphe sans noeuds et sans arêtes"""
function Graph(name::String; T::DataType = Int, W::DataType = Int) 
  # x = Node("noeud1")
  # X = [x]
  # y = Edge(x,x,30)
  # Y = [y]
  # Graph(name, empty(X::Vector{Node{T}} where T), empty(Y::Vector{Edge{W,T}} where T where W))

  nodes = Node{T}[]
  edges = Edge{W,T}[]
  Graph(name, nodes, edges)
end

"""Crée un graphe sans arêtes"""
function Graph(name::String, nodes::Vector{Node{T}}) where T 
  Graph(name, nodes, [])
end

"""Crée un graphe à partir d'un dictionnaire de coordonnées qui représente les noeuds et d'un vecteur de tuples où chaque tuple représente une arête 
(tuple[1] : nom du noeud 1, tuple[2] : nom du noeud 2, tuple[3] : poids de l'arete)"""
function Graph(name::String, nodes::Dict{Int}{T}, edges::Vector{Tuple{Int, Int, W}}) where {T, W}
  graphe = Graph(name; T, W)
  #println(typeof(graphe))
  
  for name_n in keys(nodes)
    noeud = Node(string(name_n),nodes[name_n], name_n)
    #show(noeud)
    add_node!(graphe, noeud)
  end


  for edge in edges
    indice_node_1 = edge[1]
    indice_node_2 = edge[2]
    node_1 = get_node_from_indice(graphe, indice_node_1)
    node_2 = get_node_from_indice(graphe, indice_node_2)
    arete = Edge(node_1, node_2, edge[3])
    #show(arete)
    add_edge!(graphe, arete)
  end
  return graphe
end 

function get_node_from_indice(graph::Graph{T,W},indice::Int) where {T,W}
  for node in graph.nodes
    if node.indice == indice
      return node
    end
  end
  @warn "Le noeud n'existe pas dans le graphe."
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T,W}, node::Node{T}) where T where W
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe si les noeuds existent déjà dans le graphe"""
function add_edge!(graph::Graph{T,W}, edge::Edge{W,T}) where T where W
  if edge.node_1 in graph.nodes
    if edge.node_2 in graph.nodes
      push!(graph.edges, edge)
    else
      "Attention : un noeud de l'arête n'existe pas dans le graphe"
    end
  else 
    "Attention : un noeud de l'arête n'existe pas dans le graphe"
  end
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name`, `nodes` et `edges`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("the nodes in the graph are : ")
  for node in nodes(graph)
    show(node)
  end
  println("the edges in the graph are : ")
  for edge in edges(graph)
    show(edge)
  end
end
