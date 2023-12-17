"""Fonction qui a partir d'un cycle donne un meilleur cycle en échangeant p fois 2 aretes"""
function opt2(graphe_initial::Graph{T,W}, cycle::Graph{T,W}, p::Int64, i::Int64, k::Int64) where {T,W}

    # on va comparer deux aretes d'un cycle (arete_1 et arete_2) avec leur echange 2-opt pourr voir si la modification est intéressante
    while i <= p && k <= 100
        for arete_1 in edges(cycle)

        # on n'effectue le reste de la fonction que si on pas dépassé le nombre d'échange et/ou d'itérations autorisé

            for arete_2 in edges(cycle)
                noeud_1_opt = nodes(arete_1)[1]
                local noeud_2_opt = nodes(arete_1)[2] 
                noeud_3_opt = nodes(arete_1)[2] 
                # print("noeud 1 : ")
                # show(noeud_1_opt)
                # print("noeud 2 : ")
                # show(noeud_2_opt)
                # print("noeud 3 : ")
                # show(noeud_3_opt)
                # on ne s'intéresse à deux aretes que si celles-ci ne sont pas adjacentes (ni identiques)
                if !(nodes(arete_1)[1] in nodes(arete_2)) && !(nodes(arete_1)[2] in nodes(arete_2))

                    # cette boucle sert à trouver les noeuds des aretes 1 et 2 qui sont reliés par un chemin pour savoir quel échange effectuer
                    noeud_1_opt, noeud_2_opt = glissement!(cycle,noeud_1_opt, noeud_2_opt, arete_2)
                    println("ok-for,i=",i,"k=",k)

                    # ce if sert à déterminer l'indice du noeud de l'arete_2 à lier au noeud 1 de l'arete_1
                    if noeud_2_opt == nodes(arete_2)[1]
                        noeud_3_opt = nodes(arete_2)[2]
                    else
                        noeud_3_opt = nodes(arete_2)[1]
                    end

                    # definition des aretes après l'echange
                    nouv_arete_1 = graphe_initial.edges[1]
                    nouv_arete_2 = graphe_initial.edges[1]
                    for arete in edges(graphe_initial)
                        if nodes(arete_1)[1] in nodes(arete) && noeud_2_opt in nodes(arete)
                            nouv_arete_1 = arete
                        elseif nodes(arete_1)[2] in nodes(arete) && noeud_3_opt in nodes(arete)
                            nouv_arete_2 = arete
                        end
                    end
                    print("arete 1 : ")
                    show(nouv_arete_1)
                    print("arete 2 : ")
                    show(nouv_arete_2)

                    # l'échange est réellement effectué que si le coût total serait diminué après celui-ci
                    if weight(arete_1) + weight(arete_2) > weight(nouv_arete_1) + weight(nouv_arete_2) && arete_1 in cycle.edges && arete_2 in cycle.edges
                        println("AREEEEEETE 1")
                        show(arete_1)
                        println("Aaaaaaaaaaah")
                        remove_edge!(cycle, arete_1)
                        println("AREEEEEETE 2")
                        show(arete_2)
                        remove_edge!(cycle, arete_2)
                        show(nouv_arete_1)
                        add_edge!(cycle,nouv_arete_1)
                        show(nouv_arete_2)
                        add_edge!(cycle,nouv_arete_2)
                        i += 1 
                    end
                end
            end
            
        end
        k += 1
    end
    cycle
end

function deplacement_lateral!(cycle::Graph{T,W},noeud_1_opt::Node{T}, noeud_2_opt::Node{T}, arete_2::Edge{W,T}) where {T,W}
    while !(noeud_2_opt in nodes(arete_2))
        println("ok-while, i=",i,"k=",k)
        noeud_1_opt, noeud_2_opt = glissement!(cycle,noeud_1_opt, noeud_2_opt)
        print("noeud 2 : ")
        show(noeud_2_opt)
    end
    return noeud_1_opt, noeud_2_opt
end

function glissement!(cycle::Graph{T,W},noeud_1_opt::Node{T}, noeud_2_opt::Node{T}, arete_2::Edge{W,T}) where {T,W}
    for i in 1:nb_edges(cycle)
        for arete_3 in edges(cycle)
            if noeud_2_opt in nodes(arete_3) && !(noeud_1_opt in nodes(arete_3))

                if nodes(arete_3)[1] == noeud_2_opt
                    noeud_1_opt = noeud_2_opt
                    noeud_2_opt = nodes(arete_3)[2]
                
                else
                    noeud_1_opt = noeud_2_opt
                    noeud_2_opt = nodes(arete_3)[1]
                end
            end
        end
        if noeud_2_opt in nodes(arete_2)
            break
        end
    end
    print("noeud 2 : ")
    show(noeud_2_opt)
    return noeud_1_opt, noeud_2_opt
end