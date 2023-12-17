"""Fonction qui donne un cycle en suivant l'algorithme de HK"""
function hk(graphe::Graph{T,W}, indice::Int, algo::Union{Nothing,String}; tO::Float64 = 1.0) where {T,W}
    
    # Initialisation des variables nécessaires à l'algorithme (k, vi, pi, degre des noeuds)
    k=1
    sort!(nodes(graphe), by = x -> x.indice)
    n = nb_nodes(graphe)
    reference = zeros(n)
    vecteur_pi = zeros(n)
    vi = ones(n)
    degre = zeros(n)

    # noeud que l'on enlève pour faire le one-tree
    pivot = nodes(graphe)[indice]

    # aretes dont on peut modifier les poids
    graphe_aretes_modifiables = Graph("modif",nodes(graphe), W=W)
    
    # creation du graphe avec le pivot en moins et liste des aretes liant le pivot aux autres noeuds
    liste_noeud_moins = Node{T}[]
    for elt in nodes(graphe)
        if elt != pivot
            push!(liste_noeud_moins,elt)
        end
    end
    graphe_noeud_moins = Graph("noeud_moins", liste_noeud_moins,W=W)
    liste_aretes_pivot = Edge{W,T}[]
    for arete in edges(graphe)
        copie_arete = copy(arete)
        add_edge!(graphe_aretes_modifiables,copie_arete)
        if !(pivot in nodes(arete))
            add_edge!(graphe_noeud_moins,copie_arete)
        else
            push!(liste_aretes_pivot,copie_arete)
        end
    end

    # premiere détermination d'un one-tree
    if algo == "p"
        one_tree = prim(graphe_noeud_moins)
    else
        one_tree = kruskal(graphe_noeud_moins)
    end
    
    # boucle de l'algorithme de HK
    while vi != reference # && k<100000
        if algo == "p"
            one_tree = prim(graphe_noeud_moins)
        else
            one_tree = kruskal(graphe_noeud_moins)
        end

        # ajout du pivot
        add_node!(one_tree, pivot)

        # calcul du degré des noeuds du graphe
        for i in range(1, n, step = 1)
            degre[i] = 0
        end
        for arete in edges(one_tree)
            degre[nodes(arete)[1].indice] += 1.0
            degre[nodes(arete)[2].indice] += 1.0
        end
        
        # ajout des 2 meilleurs aretes qui lient pivot à deux noeuds de degré 1
        liste_1_arete = Edge{W,T}[] 
        for elt in liste_aretes_pivot
            if degre[nodes(elt)[1].indice] == 1
                push!(liste_1_arete, elt)
            elseif degre[nodes(elt)[2].indice] == 1
                push!(liste_1_arete, elt)
            end
        end
        sort!(liste_1_arete, by = x -> x.weight)
        add_edge!(one_tree, liste_1_arete[1])
        add_edge!(one_tree, liste_1_arete[2])
        for i in range(1,2, step=1)
            degre[nodes(liste_1_arete[i])[1].indice] += 1.0
            degre[nodes(liste_1_arete[i])[2].indice] += 1.0
        end

        # calcul de vi
        for i in range(1, n, step = 1)
            vi[i] = -2 + degre[i]
        end

        # calcul de tk
        t = tk(tO, k)

        # calcul de pi
        for i in range(1, n, step = 1)
            vecteur_pi[i] += t * vi[i]
        end

        # modification des poids des aretes
        for arete in edges(graphe_aretes_modifiables)
            for arete_ref in edges(graphe)
                if nodes(arete) == nodes(arete_ref)
                    noeud_1 = nodes(arete)[1]
                    noeud_2 = nodes(arete)[2]
                    arete.weight = weight(arete_ref) + vecteur_pi[noeud_1.indice] + vecteur_pi[noeud_2.indice]
                end
            end
        end

        # itération suivante
        k += 1

    end
    return one_tree
end

"""Function qui calcule tk en fonction de k"""
function tk(t0, k::Int)
    t0 * 10 / k 
end