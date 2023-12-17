### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ cdfa81bc-9c26-11ee-0a74-01649a61f871
md"""
# Rapport Phase 4
Elodie Campeau et Daphné Boulanger

Notre dossier se trouve à l'adresse : https://github.com/dabouah/mth6412b-starter-code/tree/phase4

#### 1 Methode de `Graph` : `create_tour()`

Pour utiliser la fonction `write_tour()`, il était nécessaire de lui donner en entrée l'ordre des noeuds visités par le cycle en une liste d'indices. Nous avons donc du créer une méthode qui crée cette liste à partir des arêtes de notre cycle, dans la structure `Graph`.

"""

# ╔═╡ f6567373-46a9-426c-96b6-c266d436b5b0
md"""
```julia
\"""Transforme un cycle en une liste d'indices\"""
function create_tour_zero(graph::AbstractGraph)
  tour = [indice(nodes(edges(graph)[1])[1])-1]
  liste_aretes = Edge[]
  for arete in graph.edges
      push!(liste_aretes,arete)
  end
  noeud = indice(nodes(edges(graph)[1])[2])
  deleteat!(liste_aretes, findfirst(x->x==edges(graph)[1],liste_aretes))
  while liste_aretes != []
    for arete in liste_aretes
      if noeud == indice(nodes(arete)[1])
        push!(tour,noeud-1)
        noeud = indice(nodes(arete)[2])
        deleteat!(liste_aretes, findfirst(x->x==arete,liste_aretes))
      elseif noeud == indice(nodes(arete)[2])
        push!(tour,noeud-1)
        noeud = indice(nodes(arete)[1])
        deleteat!(liste_aretes, findfirst(x->x==arete,liste_aretes))
      end
    end
  end
  deleteat!(tour, findfirst(x->x==0,tour))
  return tour
end
```
"""

# ╔═╡ e4ab50d2-0509-4ada-8773-34a8dc6c05bb
md"""

Cette fonction part d'une arête pour noter le noeud dans une liste. Ensuite, elle va itérativement aller chercher l'arête qui partage le deuxième noeud de l'arête en mémoire pour passer sur tous les noeuds du cycle et ainsi créer une liste qui contient les noeuds en ordre de visite.

Le graphe, contenant un noeud 0 qui n'existe pas dans l'image, il a fallu modifié les indices des noeuds en leur retirant 1, pour que les indices des noeuds correspondent au numéro de la languette d'image. il a ensuite fallu retirer l'indice 0 de la liste d'indices.

"""

# ╔═╡ 9e721ddf-b917-4165-9fc5-ee54ebedb844
md"""
#### 2 Premiers tests sur des images

Nous avons testé nos fonctions sur les fichiers d'images déchiquetées comme elles nous avait été données. Voici dans un tableau les résultats obtenus.

|  	| Coût obtenu 	| Coût attendu	| Erreur relative	|
|---	|---	|---	|---	|
| abstract-light-painting 	| 44 007 944	| 12 314 767	| +257%	|
| alaska-railroad 	| 37 704 788	| 7 667 914	| +392%	|
| blue-hour-paris 	| 31 759 028	| 3 946 200	| +705%	|
| lower-kananaskis-lake 	| 21 804 896	| 4 226 754	| +416%	|
| marlet2-radio-board 	| 55 867 548	| 8 863 246	| +530%	|
| nikos-cat 	| 42 721 460	| 3 036 676	| +1307%	|
| pizza-food-wallpaper 	| 45 332 170	| 5 041 336	| +799%	|
| the-enchanted-garden 	| 60 141 360	| 19 914 400	| +202%	|
| tokyo-skytree-aerial 	| 35 635 652	| 13 610 038	| +162%	|

Ces résultats sont assez mauvais, et les images retournées sont tout aussi déchiquetées.

Les images reconstruites avec cette méthode se trouvent dans le dossier mth6412b-starter-code/images/reconstructed.

Ceci est dû à une construction d'un arbre qui n'est pas optimal pour le calcul d'un cycle : le sommet 0 ayant des couts nuls vers tous les autres sommets, l'arbre créé a comme racine 0 et est de hauteur 1. RSL n'a donc aucun impact sur la solution obtenue.

"""

# ╔═╡ c9560c09-c365-4b3d-8bf9-34ca5af037b9
md"""

#### 3 Idée d'amélioration : retrait du sommet 0

Afin d'améliorer la solution obtenue, nous avons retiré le sommet zéro des fichiers d'images déchiquetées. Nous avons modifié la fonction `create_tour()` pour que les indices ajoutés à la liste ne soient plus modifiés. Nous avons renommé la fonction originale `create_tout_zero()`.

"""

# ╔═╡ e9bcf716-2140-49fd-98de-c57edc8b4f94
md"""
```julia
\"""Transforme un cycle en une liste d'indices\"""
function create_tour(graph::AbstractGraph)
  tour = [0, indice(nodes(edges(graph)[1])[1])]
  liste_aretes = Edge[]
  for arete in graph.edges
      push!(liste_aretes,arete)
  end
  noeud = indice(nodes(edges(graph)[1])[2])
  deleteat!(liste_aretes, findfirst(x->x==edges(graph)[1],liste_aretes))
  while liste_aretes != []
    for arete in liste_aretes
      if noeud == indice(nodes(arete)[1])
        push!(tour,noeud)
        noeud = indice(nodes(arete)[2])
        deleteat!(liste_aretes, findfirst(x->x==arete,liste_aretes))
      elseif noeud == indice(nodes(arete)[2])
        push!(tour,noeud)
        noeud = indice(nodes(arete)[1])
        deleteat!(liste_aretes, findfirst(x->x==arete,liste_aretes))
      end
    end
  end
  return tour
end
```
"""

# ╔═╡ 5284285f-8794-45ec-a0bb-210c95d7c54f
md"""
Les résultats sont donnés donnés dans le tableau ci-dessous.

|  	| Coût obtenu 	| Coût attendu	| Erreur relative	|
|---	|---	|---	|---	|
| abstract-light-painting 	| 12 444 006	| 12 314 767	| +1%	|
| alaska-railroad 	| 7 877 560	| 7 667 914	| +3%	|
| blue-hour-paris 	| 4 073 742	| 3 946 200	| +3%	|
| lower-kananaskis-lake 	| 4 316 516	| 4 226 754	| +2%	|
| marlet2-radio-board 	| 9 069 526	| 8 863 246	| +2%	|
| nikos-cat 	| 3 155 704	| 3 036 676	| +4%	|
| pizza-food-wallpaper 	| 5 226 350	| 5 041 336	| +4%	|
| the-enchanted-garden 	| 20 092 148	| 19 914 400	| +1%	|
| tokyo-skytree-aerial 	| 13 718 250	| 13 610 038	| +1%	|

Nous remarquons que les résultats sont **_BIEN_** meilleurs. 

Les images reconstruites avec cette méthode se trouvent dans le dossier mth6412b-starter-code/images/reconstructed et ont _modif en fin de nom.

Ci-dessous, une des images reconstruites.

"""

# ╔═╡ 3301ac03-8359-4f2d-9cee-37cc56d94e23
begin
struct Wow
filename
end

function Base.show(io::IO, ::MIME"image/png", w::Wow)
write(io, read(w.filename))
end
end

# ╔═╡ 3d62a742-9339-4127-a4cc-fe8c16de95a2
Wow("/Users/daphneboulanger/GIT/mth6412b-starter-code/images/reconstructed/lower-kananaskis-lake_modif.png")

# ╔═╡ 3b9d4e3f-339b-4d40-bea5-0119973e216f
md"""

Cependant, les images présentent encore quelques défauts. Après observation des images, cela s'explique par le fonctionnement de RSL. Cela doit être améliorable en déterminant le noeud de départ pour l'algorithme de RSL. En effet, si on choisit une feuille dans l'arbre créé par Kruskal, on devrait avoir moins de coupures dans l'image.

"""

# ╔═╡ 338ff475-8945-43c9-aa1e-e8ac32b149c6
md"""

#### 4 Idée d'amélioration : choix de la pire arête du cycle

Afin de remédier à la coupure des images, nous avons implémenté une fonction qui identifie l'arête qui a le coût le plus élevée dans le cycle.

"""

# ╔═╡ 48e6fcca-aa86-4aa8-a48b-ce535e50ca3e
md"""
```julia
\"""Fonction qui renvoit l'arete de plus gros poids\"""
function arete_max(graph::AbstractGraph)
  arete_maxi = edges(graph)[1]
  for edge in edges(graph)
    if weight(edge) > weight(arete_maxi)
      arete_maxi = edge
    end
  end
  return arete_maxi
end
```
"""

# ╔═╡ 6e7ffd17-71ad-49ed-8f0b-40c4a0de19bf
md"""
C'est un des sommets de cette arête qui sera utilisé dans l'algorithme RLS. Il faut utiliser RSL une première fois pour trouver un cycle, ensuite, il est possible de déterminer l'arête de coût max et alors déterminer un de ses sommets qui servira de pivot dans RSL. Nous avons essayé les deux sommets de cette arête pour déterminer celui qui est le plus performant en tant que pivot. 

Les images reconstruites avec cette méthode se trouvent dans le dossier mth6412b-starter-code/images/reconstructed et ont _modif_amélioré en fin de nom.

Ci-dessous l'image reconstruite `lower-kananaskis-lake` lorsque cette amélioration est utilisée.
"""

# ╔═╡ 70a2b2b1-a3eb-49b5-90f3-dacfcf02de46
Wow("/Users/daphneboulanger/GIT/mth6412b-starter-code/images/reconstructed/lower-kananaskis-lake_modif_amélioré.png")

# ╔═╡ Cell order:
# ╟─cdfa81bc-9c26-11ee-0a74-01649a61f871
# ╟─f6567373-46a9-426c-96b6-c266d436b5b0
# ╟─e4ab50d2-0509-4ada-8773-34a8dc6c05bb
# ╟─9e721ddf-b917-4165-9fc5-ee54ebedb844
# ╟─c9560c09-c365-4b3d-8bf9-34ca5af037b9
# ╟─e9bcf716-2140-49fd-98de-c57edc8b4f94
# ╟─5284285f-8794-45ec-a0bb-210c95d7c54f
# ╟─3301ac03-8359-4f2d-9cee-37cc56d94e23
# ╟─3d62a742-9339-4127-a4cc-fe8c16de95a2
# ╟─3b9d4e3f-339b-4d40-bea5-0119973e216f
# ╟─338ff475-8945-43c9-aa1e-e8ac32b149c6
# ╟─48e6fcca-aa86-4aa8-a48b-ce535e50ca3e
# ╟─6e7ffd17-71ad-49ed-8f0b-40c4a0de19bf
# ╟─70a2b2b1-a3eb-49b5-90f3-dacfcf02de46
