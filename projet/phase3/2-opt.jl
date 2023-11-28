"""Fonction qui a partir d'un cycle donne un meilleur cycle en échangeant p fois 2 aretes"""
function opt2(graphe_initial::Graph{T,W}, cycle::Graph{T,W}, p::Int64) where {T,W}
    # i sert de compteur d'échanges
    i = 1

    # k sert de compteur d'itération 
    k = 1

    # on va comparer deux aretes d'un cycle (arete_1 et arete_2) avec leur echange 2-opt pourr voir si la modification est intéressante
    for arete_1 in edges(cycle)
        global noeud_1_opt = nodes(arete_1)[1]
        global noeud_2_opt = nodes(arete_1)[2] 

        # on n'effectue le reste de la fonction que si on pas dépassé le nombre d'échange et/ou d'itérations autorisé
        while i <= p && k <= 100

            for arete_2 in edges(cycle)

                # on ne s'intéresse à deux aretes que si celles-ci ne sont pas adjacentes (ni identiques)
                if !(nodes(arete_1)[1] in nodes(arete_2)) && !(nodes(arete_1)[2] in nodes(arete_2))

                    # cette boucle sert à trouver les noeuds des aretes 1 et 2 qui sont reliés par un chemin pour savoir quel échange effectuer
                    while !(noeud_2_opt in nodes(arete_2))
                        for arete_3 in edges(cycle)
                            if noeud_2_opt in nodes(arete_3) && !(noeud_1_opt in nodes(arete_3))
                                global noeud_2_opt
                                global noeud_1_opt
                                if nodes(arete_3)[1] == noeud_2_opt
                                    noeud_1_opt = noeud_2_opt
                                    noeud_2_opt = nodes(arete_3)[2]
                                else
                                    noeud_1_opt = noeud_2_opt
                                    noeud_2_opt = nodes(arete_3)[1]
                                end
                            end
                        end
                    end

                    # ce if sert à déterminer l'indice du noeud de l'arete_2 à lier au noeud 1 de l'arete_1
                    if noeud_2_opt == nodes(arete_2)[1]
                        noeud_3 = nodes(arete_2)[2]
                    else
                        noeud_3 = nodes(arete_2)[1]
                    end

                    # definition des aretes après l'echange
                    nouv_arete_1 = graphe_initial.edges[1]
                    nouv_arete_2 = graphe_initial.edges[1]
                    for arete in edges(graphe_initial)
                        if nodes(arete_1)[1] in nodes(arete) && noeud_2_opt in nodes(arete)
                            nouv_arete_1 = arete
                        elseif nodes(arete_1)[2] in nodes(arete) && noeud_3 in nodes(arete)
                            nouv_arete_2 = arete
                        end
                    end

                    # l'échange est réellement effectué que si le coût total serait diminué après celui-ci
                    if weight(arete_1) + weight(arete_2) > weight(nouv_arete_1) + weight(nouv_arete_2)
                        remove_edge!(cycle, arete_1)
                        remove_edge!(cycle, arete_2)
                        add_edge!(cycle,nouv_arete_1)
                        add_edge!(cycle,nouv_arete_2)
                        i += 1
                    end
                end
            end
            k += 1
        end
    end
    cycle
end

