"""
    MatrixDifference{T<:Real}

Matrix difference.
"""
struct MatrixDifference{T<:Real}
    M::SparseMatrixCSC{T}
    AI::SubArray{T}
    AJ::SubArray{T}
    RI::SubArray{T}
    RJ::SubArray{T}
end

"""
    modified(a::MatrixDifference)

Access the modified elements.
"""
modified(a::MatrixDifference) = a.M

"""
    added(a::MatrixDifference)

Access the tuple containing the elements added in each dimension.
"""
added(a::MatrixDifference) = a.AI, a.AJ

"""
    added(a::MatrixDifference, dim::Integer)

Access the elements added in dimension `d`.
"""
function added(a::MatrixDifference, dim::Integer)
    1 <= dim <= 2 || throw(ArgumentError("dimension $dim out of range (1:2)")
    added(a)[dim]
end

"""
    removed(a::MatrixDifference)

Access the tuple containing the elements removed from each dimension.
"""
removed(a::MatrixDifference) = a.RI, a.RJ

"""
    removed(a::MatrixDifference, dim::Integer)

Access the elements removed from dimension `d`.
"""
function removed(a::MatrixDifference, dim::Integer) =
    1 <= dim <= 2 || throw(ArgumentError("dimension $dim out of range (1:2)")
    removed(a)[dim]
end

"""
"""
function replace(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}
    t = similar(a)
    @inbounds for i = 1:length(a)
        t[i] = get(d, a[i], a[i])
    end
    return t
end

"""
"""
function replace!(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}
    @inbounds for i = 1:length(a)
        a[i] = get(d, a[i], a[i])
    end
    return a
end

"""
    diff(a::AbstractVector, b::AbstractVector)

Compute the change from vector `a` to vector `b`, and return a tuple containing
the unique elements that have been shared, added and removed.

# Examples
```jldoctest
julia> diff([1, 2, 3, 3], [4, 2, 1])
([4], [3])
```
"""
diff(a::AbstractVector, b::AbstractVector) =
    intersect(a, b), setdiff(b, a), setdiff(a, b)

"""
    diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractDict, ja::AbstractDict, ib::AbstractDict, jb::AbstractDict)

Compute the change from matrix `A` to matrix `B`, and return a tuple containing
the elements that have been modified, added (per row and column), removed (per
row and column).
"""
function diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractDict,
            ja::AbstractDict, ib::AbstractDict, jb::AbstractDict)
    T = promote_type(eltype(A), eltype(B))
    iakeys = collect(keys(ia))
    jakeys = collect(keys(ja))
    ibkeys = collect(keys(ib))
    jbkeys = collect(keys(jb))

    # Compute modified values
    modval = sparse([], [], T[])
    i = intersect(iakeys, ibkeys)
    j = intersect(jakeys, jbkeys)
    if length(i) > 0 && length(j) > 0
        ia2 = replace(i, ia)
        ja2 = replace(j, ja)
        ib2 = replace(i, ib)
        jb2 = replace(j, jb)
        modval = sparse(view(A, ia2, ja2) - view(B, ib2, jb2))
    end

    # Compute added values
    addival = T[]
    addjval = T[]
    i = setdiff(ibkeys, iakeys)
    j = setdiff(jbkeys, jakeys)
    if length(i) > 0 && length(j) <= 0
        # Only rows have been added
        replace!(i, ib)
        addival = view(B, i, :)
    end
    if length(i) <= 0 && length(j) > 0
        # Only columns have been added
        replace!(j, jb)
        addjval = view(B, :, j)
    end
    if length(i) > 0 && length(j) > 0
        # Rows and columns have been added
        replace!(i, ib)
        replace!(j, jb)
        addival = view(B, i, :)
        addjval = view(B, :, j)
    end

    # Compute removed values
    remival = T[]
    remjval = T[]
    i = setdiff(iakeys, ibkeys)
    j = setdiff(jakeys, jbkeys)
    if length(i) > 0 && length(j) <= 0
        # Only rows have been removed
        replace!(i, ia)
        remival = view(A, i, :)
    end
    if length(i) <= 0 && length(j) > 0
        # Only columns have been removed
        replace!(j, ja)
        remjval = view(A, :, j)
    end
    if length(i) > 0 && length(j) > 0
        # Rows and columns have been removed
        replace!(i, ia)
        replace!(j, ja)
        remival = view(A, i, :)
        remjval = view(A, :, j)
    end

    return modval, addival, addjval, remival, remjval
end
function diff(A::AbstractMatrix, B::AbstractMatrix)
    ia = Dict(i => i for i = 1:size(A, 1)
    ja = Dict(i => i for i = 1:size(A, 2)
    ib = Dict(i => i for i = 1:size(B, 1)
    jb = Dict(i => i for i = 1:size(B, 2)
    return diff(A, B, ia, ja, ib, jb)
end
