"""Renvoie l'arbre de recouvrement minimal d'un graphe connexe en utilisant l'algorithme de Kruskal"""
function kruskal(graphe::Graph{T,W}) where {T,W}
    noeuds = nodes(graphe)
    edges_g = Edge{W,T}[]
    graphe_kruskal = Graph("Kruskal de " * name(graphe), noeuds, edges_g)
    liste_edges = edges(graphe)
    liste_edges = sort!(liste_edges, by = x -> x.weight)
    for arete in liste_edges
        if weight(arete) > 0
            racine1 = root!(nodes(arete)[1])
            racine2 = root!(nodes(arete)[2])
            if racine1 != racine2
                add_edge!(graphe_kruskal,arete)
                racine1.parent=racine2
                # union_via_rang(racine1, racine2)
            end
        end
    end
    graphe_kruskal
end

"""Joint deux arbres selon le rang des racines"""
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