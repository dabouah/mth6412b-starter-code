"""Type abstrait dont d'autres types de piles dériveront."""
abstract type AbstractQueue{T} end

"""Type représentant une file avec des éléments de type T."""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{Node{T}}
end

Queue{T}() where T = Queue(Node{T}[])

"""Retire et renvoie l'élément ayant la plus haute priorité."""
function popmin!(q::Queue{T}) where T
    lowest = q.items[1]
    for item in q.items
        if min_weight(item) < min_weight(lowest)
            lowest = item
        end
    end
    deleteat!(q.items, findfirst(x->x==lowest,q.items))
    lowest
end

