### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 6199232e-823c-11ee-012c-d1c40fffc7dd
md"""
# Rapport Phase 3
Elodie Campeau et Daphné Boulanger

Notre dossier se trouve à l'adresse : https://github.com/dabouah/mth6412b-starter-code/tree/phase3

#### 1 Algorithme RSL 

"""

# ╔═╡ 4adcbb24-4725-4162-877c-752cfd14f86c
md"""
Dans un premier temps, nous avons créé une fonction `enfants()` qui va donner la liste des enfants d'un noeud dans un arbre de recouvrement. Cela va nous permettre d'effectuer la recherche en pré-ordre facilement. Cette fonction va prendre en compte la choix de la racine déterminée par l'utilisateur, et non pas le parent indiqué dans les attributs du noeud.

Dans les paramètres de la fonction, vous pouvez remarquer une liste interdite ce qui va empécher de remonter sur les noeuds "ancêtres" du noeud dont on cherche les enfants ici.
"""

# ╔═╡ 67766430-4d55-4237-b486-7244e1761d2a
md"""
```julia
\"""Renvoie la liste des enfants d'un noeud dans l'arbre de recouvrement\"""
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
```
"""

# ╔═╡ cf65a2cc-4c3f-4f0f-b920-f2537712cc18
md"""
Ensuite, nous avons créé une fonction `pre_ordre()` qui va renvoyer une liste de noeuds visité en pré\_ordre en fonction de la racine choisie par l'utilisateur. Cette fonction est une fonction récursive.

On lui donne une liste vide `ordre_visite` à la première itération à laquelle elle va ajouter les noeuds visités en utilisant la fonction `enfants()` ci-dessus. 
"""

# ╔═╡ 3bbcef08-dce0-42c2-8e91-8c41c20457e7
md"""
```julia
\"""Renvoie une liste de noeuds dans l'ordre à visiter selon l'algorithme RSL\"""
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
```
"""

# ╔═╡ 0126882b-5390-496e-8963-59f13a7b0a95
md"""
Enfin, nous avons créé une fonction `rsl()`, qui va créer un nouveau graphe qui aura les mêmes sommets que le graphe donné en paramètres mais dont les arêtes seront issues du résultat de l'algorithme rsl, en ajoutant les arêtes en fonction de la liste `ordre_visite` obtenue avec la fonction `pre_ordre()` ci-dessus. 

Il faudra, dans un premier temps, créer un arbre de recouvrement, à partir de Prim ou de Kruskal selon ce que veut l'utilisateur (paramètre `algo`)

Le paramètre `indice` permet de choisir le sommet qui sera considéré comme étant la racine de l'arbre de recouvrement. Il est nécessaire de noter que les sommets peuvent être considérés comme racine.
"""

# ╔═╡ 38c352f8-ea74-460d-a2af-3583b4aac80b
md"""
```julia
\"""Fonction qui donne un cycle hamiltonien du graphe complet donné en entrée, à l'aide de l'algorithme RSL\"""
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
    # for ed in ordre_visite
    #     print(name(ed), ", ")
    # end
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
    return cycle
end
```
"""

# ╔═╡ 43fca7a9-7529-4261-b869-f83370aed05a
md"""
#### 2 Algorithme HK 

"""

# ╔═╡ 928f4ceb-1102-4a6d-83d9-0248b1108c07
md"""
Dans un premier temps nous avons créé une fonction `tk()` qui calcule tk en fonction de k et de t0.
```julia
\"""Function qui calcule tk en fonction de k\"""
function tk(t0, k::Int)
    t0 / k 
end
```
"""

# ╔═╡ 67b4b723-bfa5-421f-894f-e6f5da797baf
md"""
Nous avons ensuite implémenté l'algorithme HK dans la fonction `hk()`. Cette fonction prend en entrée un `graphe` dont on veut déterminer un cycle de coût minimum, un `indice` qui représente l'indice du noeud à enlever avant de déterminer le one-tree, un t0 qui apparait dans le calcul de tk. On obtient en sortie un graphe qui est un cycle de coût qui se rapproche du coût optimal.

Les différentes parties du code sont commentées pour plus de clarté.

Nous sortons de la boucle que lorsque nous avons effectivement un cycle : tous les noeuds ont un degré de 2.
"""

# ╔═╡ 60daa87d-1929-4665-8482-c2285158626d
md"""
```julia
\"""Fonction qui donne un cycle en suivant l'algorithme de HK\"""
function hk(graphe::Graph{T,W}, indice::Int; tO::Float64 = 1.0) where {T,W}
    
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
    one_tree = kruskal(graphe_noeud_moins)
    
    # boucle de l'algorithme de HK
    while vi != reference && k<100000
        one_tree = kruskal(graphe_noeud_moins)

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
```
"""

# ╔═╡ d6b34bf7-2eae-4f06-8401-830c7b6809fa
md"""
Cet algorithme fonctionne mais sa grande complexité nous empêche d'obtenir des résultats pour toutes les instances sauf les très petites (21 sommets max).
"""

# ╔═╡ 9ff1e314-527a-4202-a601-bf4a7fe16b28
md"""
#### 3 Optimisation des paramètres

##### 3.1 Kruskal vs Prim (RSL)
"""

# ╔═╡ 842ee756-7af4-473c-aed5-e1d735d3583b
md"""Dans le précedent rapport nous avions déjà établi que kruskal est plus performant que prim. Nous avons testé l'algorithme RSL avec les deux et nous sommes retombés sur le même résultat. 

Nous avons donné les moyennes de temps de compilation dans le tableau suivant.
"""

# ╔═╡ 27059e18-965d-4a5a-ae50-b24680306c85
md"""
|  	| Prim 	| Kruskal	|
|---	|---	|---	|
| gr17 	| 1.257ms	| **_227μs_**	|
| brazil58 	| 53.25ms	| **_6.22ms_**	|
"""

# ╔═╡ 378065ca-a631-48af-a3ba-83de25af8071
md"""
Nous avons obtenu les mêmes résultats de coût de cycle que ce soit avec Prim ou avec Kruskal.
"""

# ╔═╡ be28e4ee-61ce-4b3a-9fbd-6fc78da9e32f
md"""
Nous ne l'avons pas testé sur HK car HK prend déjà beaucoup de temps avec kruskal, ainsi nous sommes sures des mauvaises performances de prim dans cet algorithme dans lequel il y a de nombreuses utilisations d'un algorithme créant un arbre (plus de 100).
"""

# ╔═╡ 68cdb12a-db8f-4326-8486-ff0de3711b9a
md"""
##### 3.2 Choix du sommet privilégié / racine

Nous avons essayé toutes les racines possibles pour le graphe `gr17` avec les deux algorithmes. Les valeurs des poids des cycles sont répertoriées dans le tableau ci-dessous.

|  	| RSL 	| HK	|
|---	|---	|---	|
| 1 	| 2352	| 2243	|
| 2 	| 2273	| 2309	|
| 3 	| 2273	| 2306	|
| 4 	| 2318	| 2257	|
| 5 	| 2273	| 2216	|
| 6 	| 2274	| 2286	|
| 7 	| **_2210_**	| 2488	|
| 8 	| 2274	| 2418	|
| 9 	| 2318	| **_2149_**	|
| 10 	| 2418	| 2280	|
| 11	| 2418	| 2255	|
| 12 	| 2243	| 2280	|
| 13 	| 2352	| 2317	|
| 14 	| 2273	| 2328	|
| 15 	| 2315	| 2241	|
| 16 	| 2243	| 2280	|
| 17 	| 2273	| 2392	|

Nous n'avons pas observé de tendance qui pourrait expliquer un meilleur coût avec une racine en particulier. Par contre, on remarque que les coût peut diminuer de 9% selon le sommet choisi avec `RSL` et de 16% avec `HK`.
"""

# ╔═╡ 17efaab9-81b1-4add-9f2f-80d28b0deaac
md"""
##### 3.3 Choix de la longueur de pas tk
"""

# ╔═╡ 3793f3de-f0e7-47b2-a9d0-7d6463627f9e
md"""
Nous avons commencé avec $t_k = \frac{t_0}{k}$

Nous avons essayé de nombreuses autres fonctions pour essayer de résoudre des plus grosses instances :

$t_k = \frac{t_0 \cdot 10}{k}$

$t_k = \frac{t_0 \cdot 100}{k}$

$t_k = \frac{t_0 \cdot 1000}{k}$

$t_k = l \cdot k \cdot e^{- m \cdot k}$ 

en faisant varier `l` et `m`.

La dernière est très mauvaise : nous n'obtenons pas de résultats même sur de petites instances.
"""

# ╔═╡ 0069f8c1-06b5-4427-818a-4a247c6bf3a1
md"""
##### 3.4 Choix du critère d'arrêt
"""

# ╔═╡ a6e2ce16-d32c-4db0-b7fa-372fdc99880a
md"""
Pour l'instant notre algorithme HK utilise comme critère d'arrêt, le degré des noeuds. Il s'arête quand tous les degrés des noeuds sont de 2, et que nous avons alors un cycle.

Il est possible d'utiliser comme critère d'arrêt de limiter le nombre d'itérations depuis lequel le vecteur vi n'a pas changé (par exemple 100). Ce critère d'arrêt ne permet pas d'obtenir un cycle. Il faudra alors faire des modifications sur les aretes pour que le degré de chaque sommet soit de 2, avec un 1-opt par exemple.
"""

# ╔═╡ fe2a8eaa-88de-4539-8308-237ce7dbd5ef
md"""
##### 4 Identifier les meilleures tournées possibles 
"""

# ╔═╡ 9101e17e-2a03-4a59-816f-3a8341c2cafd
md"""
Notre fonction `HK` ne fonctionnant qu'avec de petites instances, nous nous sommes concentrées sur l'algorithme `RSL`, pour identifier des meilleures tournées.

Nous avons testé 4 instances pour lesquelles nous avons fait tourné `RSL` sur tous les noeuds comme racine afin d'identifier le meilleur choix.

| Instance 	| Racine	| Coût calculé	| Coût optimal 	| Erreur relative 	|
|---	|---	|---	|---	|---	|
| gr17  	| 7 	| 2210  	| 2085	| +6%	|
| bayg29 	| 17	| 2014  	| 1610	| +25%	|
| gr48  	| 4 	| 6702  	| 5046	| +33%	|
| brg180 	| 71	| 240340	| 1950	| +12225%	|

On semble pouvoir dire que plus l'instance grandit, plus l'erreur relative augmente.
Ces résultats nous montrent l'importance d'améliorer notre cycle avec une heuristique comme le 2-opt, car ici seuls les arbres de recouvrement des graphes sont optimisés et les arètes supplémentaires ne le sont pas (du tout comme pour brg180).

"""

# ╔═╡ 7d228040-3fa5-45fc-9f00-62c2a19d5ea0
md"""
Les tournées obtenues sont les suivantes.

gr17 : 7, 8, 6, 17, 14, 15, 3, 11, 5, 2, 10, 13, 4, 9, 12, 16, 1, 7

bayg29 : 17, 22, 14, 18, 15, 4, 10, 20, 2, 21, 5, 9, 6, 12, 28, 1, 24, 27, 8, 16, 23, 26, 29, 3, 13, 19, 25, 7, 11, 17

gr48 : 4, 19, 3, 25, 23, 34, 18, 46, 28, 7, 29, 13, 16, 11, 36, 6, 22, 8, 33, 31, 10, 12, 5, 9, 21, 32, 27, 17, 14, 26, 48, 1, 47, 37, 40, 39, 24, 15, 41, 44, 43, 45, 2, 35, 20, 38, 42, 30, 4

brg180 : 71, 70, 69, 68, 67, 66, 65, 64, 63, 62, 61, 72, 1, 12, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 24, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 36, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 37, 48, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 49, 60, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 73, 84, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 85, 96, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 97, 108, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 109, 120, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 121, 132, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 133, 144, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 145, 156, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 157, 168, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 169, 180, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 71
"""

# ╔═╡ 1a1e9000-5541-4f4a-80d8-15c84bf798ee
md"""
##### 5 Début d'implémentation du 2-opt
"""

# ╔═╡ 7e5e0492-36d3-4fd7-80ec-8d7c048f6491
md"""
Comme nous l'avons vu avec l'analyse des meilleures tournées, une heuristique 2-opt pourrait être très bénéfique.

Voici le code de notre implémentation qui ne fonctionne pas pour le moment à cause du scope des boucles.

Les différentes parties de la fonction sont détaillées dans le code à l'aide de commentaires.

```julia
\"""Fonction qui a partir d'un cycle donne un meilleur cycle en échangeant p fois 2 aretes\"""
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
```

"""

# ╔═╡ Cell order:
# ╠═6199232e-823c-11ee-012c-d1c40fffc7dd
# ╟─4adcbb24-4725-4162-877c-752cfd14f86c
# ╟─67766430-4d55-4237-b486-7244e1761d2a
# ╟─cf65a2cc-4c3f-4f0f-b920-f2537712cc18
# ╟─3bbcef08-dce0-42c2-8e91-8c41c20457e7
# ╟─0126882b-5390-496e-8963-59f13a7b0a95
# ╟─38c352f8-ea74-460d-a2af-3583b4aac80b
# ╟─43fca7a9-7529-4261-b869-f83370aed05a
# ╟─928f4ceb-1102-4a6d-83d9-0248b1108c07
# ╟─67b4b723-bfa5-421f-894f-e6f5da797baf
# ╟─60daa87d-1929-4665-8482-c2285158626d
# ╟─d6b34bf7-2eae-4f06-8401-830c7b6809fa
# ╟─9ff1e314-527a-4202-a601-bf4a7fe16b28
# ╟─842ee756-7af4-473c-aed5-e1d735d3583b
# ╟─27059e18-965d-4a5a-ae50-b24680306c85
# ╟─378065ca-a631-48af-a3ba-83de25af8071
# ╟─be28e4ee-61ce-4b3a-9fbd-6fc78da9e32f
# ╠═68cdb12a-db8f-4326-8486-ff0de3711b9a
# ╟─17efaab9-81b1-4add-9f2f-80d28b0deaac
# ╟─3793f3de-f0e7-47b2-a9d0-7d6463627f9e
# ╟─0069f8c1-06b5-4427-818a-4a247c6bf3a1
# ╟─a6e2ce16-d32c-4db0-b7fa-372fdc99880a
# ╟─fe2a8eaa-88de-4539-8308-237ce7dbd5ef
# ╟─9101e17e-2a03-4a59-816f-3a8341c2cafd
# ╟─7d228040-3fa5-45fc-9f00-62c2a19d5ea0
# ╟─1a1e9000-5541-4f4a-80d8-15c84bf798ee
# ╟─7e5e0492-36d3-4fd7-80ec-8d7c048f6491
