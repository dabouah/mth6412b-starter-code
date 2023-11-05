"""Renvoie l'arbre de recouvrement minimal d'un graphe connexe en utilisant l'algorithme de Kruskal"""
function prim(graphe::Graph{T,W}) where {T,W}
    noeuds = nodes(graphe)
    for noeud in noeuds
        noeud.parent = nothing
    end
    noeuds[1].min_weight = 0
    noeuds[1].parent = noeuds[1]
    file_priorite = Queue(noeuds)
    prem_noeud = popmin!(file_priorite)
    noeuds_couvrant = Node{T}[]
    push!(noeuds_couvrant,prem_noeud)
    edges_g = Edge{W,T}[]
    copie_noeuds = deepcopy(noeuds)
    graphe_prim = Graph("Prim de " * name(graphe), copie_noeuds, edges_g)
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

"""Met à jour les poids minimum de tous les noeuds"""
function update_min_weight!(graph::Graph{T,W}, file_priorite::Queue{T}, noeuds_couvrant::Vector{Node{T}}) where {T,W}
    for arete in edges(graph)
        noeud_un = nodes(arete)[1]
        noeud_deux = nodes(arete)[2]
        for prio in file_priorite.items
            for couvr in noeuds_couvrant
                if name(noeud_un) == name(prio) && name(noeud_deux) == name(couvr) && min_weight(noeud_un) > weight(arete)
                    prio.min_weight = weight(arete)
                    prio.parent = noeud_deux
                    prio.arete_min = name(arete)
                elseif name(noeud_deux) == name(prio) && name(noeud_un) == name(couvr) && min_weight(noeud_deux) > weight(arete)
                    prio.min_weight = weight(arete)
                    prio.parent = noeud_un
                    prio.arete_min = name(arete)
                end
            end
        end
    end
end