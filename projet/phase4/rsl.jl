"""Fonction qui donne un cycle hamiltonien du graphe complet donné en entrée, à l'aide de l'algorithme RSL"""
function rsl(graphe::Graph{T,W}, algo::Union{Nothing,String}, indice::Int) where {T,W}
    if algo == "p"
        arbre = prim(graphe)
    else
        arbre = kruskal(graphe)
    end
    sort!(nodes(graphe), by = x -> x.indice)
    noeuds = nodes(graphe)
    edges_g = Edge{W,T}[]
    cycle = Graph("RSL de " * name(graphe), noeuds, edges_g)
    racine = nodes(cycle)[indice]
    ordre_visite = Node{T}[]
    liste_interdite = Node{T}[nodes(graphe)[indice]]
    pre_ordre(arbre, racine, ordre_visite, liste_interdite)
    for ed in ordre_visite
        print(name(ed), ", ")
    end
        for i in range(1,length(ordre_visite)-1,step=1)
        for arete in edges(graphe)
            if ordre_visite[i] in nodes(arete) && ordre_visite[i+1] in nodes(arete)
                add_edge!(cycle,arete)
            end
        end
    end
    for arete in edges(graphe)
        if ordre_visite[length(ordre_visite)] in nodes(arete) && ordre_visite[1] in nodes(arete)
            add_edge!(cycle,arete)
        end
    end 
    # opt2(graphe, cycle, 10,1,1)
    return cycle
end

"""Renvoie une liste de noeuds dans l'ordre à visiter selon l'algorithme RSL"""
function pre_ordre(arbre::Graph{T,W}, racine::Node{T}, ordre_visite::Vector{Node{T}}, liste_interdite::Vector{Node{T}}) where {T,W}
    liste_enfants = enfants(arbre, racine,liste_interdite)
    if isempty(liste_enfants)
        push!(ordre_visite,racine)
    else
        push!(ordre_visite,racine)
        for enf in liste_enfants
            pre_ordre(arbre, enf, ordre_visite, liste_interdite)
        end
    end
end

"""Renvoie la liste des enfants d'un noeud dans l'arbre de recouvrement"""
function enfants(arbre::Graph{T,W}, racine::Node{T}, liste_interdite::Vector{Node{T}}) where {T,W}
    enf = Node{T}[]
    for arete in edges(arbre)
        if racine == nodes(arete)[1]
            noeud = nodes(arete)[2]
            if !(noeud in liste_interdite)
                push!(enf,noeud)
                push!(liste_interdite,noeud)
            end
        elseif racine == nodes(arete)[2]
            noeud = nodes(arete)[1]
            if !(noeud in liste_interdite)
                push!(enf,noeud)
                push!(liste_interdite,noeud)
            end
        end
    end
    enf
end