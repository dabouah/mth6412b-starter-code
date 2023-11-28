function Base.copy(edge::Edge{W,T}) where {W,T}
    Edge(nodes(edge)[1], nodes(edge)[2], weight(edge), "copy de "*name(edge))
end