"""Renvoie l'arbre de recouvrement minimal d'un graphe connexe en utilisant l'algorithme de Prim"""
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
    compt=1
    while !isempty(file_priorite.items)
        compt += 1
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