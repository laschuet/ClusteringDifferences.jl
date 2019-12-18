"""
    SetDifference{T<:Real}

Set difference.
"""
struct SetDifference{T<:Real}
    comval::Vector{T}
    addval::Vector{T}
    remval::Vector{T}
end

"""
    common(a::SetDifference)

Access the common elements.
"""
common(a::SetDifference) = a.comval

"""
    added(a::SetDifference)

Access the added elements.
"""
added(a::SetDifference) = a.addval

"""
    removed(a::SetDifference)

Access the removed elements.
"""
removed(a::SetDifference) = a.remval

# Set difference equality operator
==(a::SetDifference, b::SetDifference) =
    a.comval == b.comval && a.addval == b.addval && a.remval == b.remval

# Set difference hash code
hash(a::SetDifference, h::UInt) =
    hash(a.comval, hash(a.addval, hash(a.remval, hash(:SetDifference, h))))

"""
    MatrixDifference{T<:Real}

Matrix difference.
"""
struct MatrixDifference{Tm<:Real,Tai<:AbstractMatrix,Taj<:AbstractMatrix,Tri<:AbstractMatrix,Trj<:AbstractMatrix}
    MODVAL::SparseMatrixCSC{Tm,Int}
    ADDIVAL::Tai
    ADDJVAL::Taj
    REMIVAL::Tri
    REMJVAL::Trj
end

# Matrix difference equality operator
==(a::MatrixDifference, b::MatrixDifference) =
    (a.MODVAL == b.MODVAL && a.ADDIVAL == b.ADDIVAL && a.ADDJVAL == b.ADDJVAL
            && a.REMIVAL == b.REMIVAL && a.REMJVAL == b.REMJVAL)

# Matrix difference hash code
hash(a::MatrixDifference, h::UInt) =
    hash(a.MODVAL, hash(a.ADDIVAL, hash(a.ADDJVAL, hash(a.REMIVAL,
        hash(a.REMJVAL, hash(:MatrixDifference, h))))))

"""
    modified(a::MatrixDifference)

Access the modified elements.
"""
modified(a::MatrixDifference) = a.MODVAL

"""
    added(a::MatrixDifference)

Access the tuple containing the added elements per dimension.
"""
added(a::MatrixDifference) = a.ADDIVAL, a.ADDJVAL

"""
    added(a::MatrixDifference, dim::Integer)

Access the added elements of dimension `d`.
"""
function added(a::MatrixDifference, dim::Integer)
    1 <= dim <= 2 || throw(ArgumentError("dimension $dim out of range (1:2)"))
    return added(a)[dim]
end

"""
    removed(a::MatrixDifference)

Access the tuple containing the removed elements per dimension.
"""
removed(a::MatrixDifference) = a.REMIVAL, a.REMJVAL

"""
    removed(a::MatrixDifference, dim::Integer)

Access the removed elements of dimension `d`.
"""
function removed(a::MatrixDifference, dim::Integer)
    1 <= dim <= 2 || throw(ArgumentError("dimension $dim out of range (1:2)"))
    return removed(a)[dim]
end

"""
    replace(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}

TODO.
"""
function replace(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}
    t = similar(a)
    @inbounds for i = 1:length(a)
        t[i] = get(d, a[i], a[i])
    end
    return t
end

"""
    replace!(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}

TODO.
"""
function replace!(a::AbstractVector{T}, d::AbstractDict{T,T}) where {T<:Integer}
    @inbounds for i = 1:length(a)
        a[i] = get(d, a[i], a[i])
    end
    return a
end

"""
    diff(a::AbstractVector, b::AbstractVector)

Compute the difference between vector `a` and vector `b`, and return a tuple
containing the unique elements that have been shared, added and removed.

# Examples
```jldoctest
julia> diff([1, 2, 3, 3], [4, 2, 1])
([1, 2], [4], [3])
```
"""
diff(a::AbstractVector, b::AbstractVector) =
    intersect(a, b), setdiff(b, a), setdiff(a, b)

"""
    diff(A::AbstractMatrix, B::AbstractMatrix)

Compute the difference between matrix `A` and matrix `B`, and return a tuple
containing the elements that have been modified, added (per row and column),
removed (per row and column).
"""
#diff(A::AbstractMatrix, B::AbstractMatrix) = _diff(A, B)
function diff(A::AbstractMatrix, B::AbstractMatrix)
    iadict = OrderedDict{Int,Int}(i => i for i = 1:size(A, 1))
    jadict = OrderedDict{Int,Int}(j => j for j = 1:size(A, 2))
    ibdict = OrderedDict{Int,Int}(i => i for i = 1:size(B, 1))
    jbdict = OrderedDict{Int,Int}(j => j for j = 1:size(B, 2))
    return _diff(A, B, iadict, jadict, ibdict, jbdict)
end

"""
    diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector, ja::AbstractVector, ib::AbstractVector, jb::AbstractVector)

Like [`diff`](@ref), but provide integer vectors that number the rows and
columns of the matrices `A` and `B`. The vector `ia` represents the row numbers
of `A`, and the vector `jb` represents the column numbers of `B` etc. The
position of each vector element refers to the row index (or column index
respectively) of `A` or `B`.
"""
function diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector,
            ja::AbstractVector, ib::AbstractVector, jb::AbstractVector)
    iadict = OrderedDict(zip(ia, 1:length(ia)))
    jadict = OrderedDict(zip(ja, 1:length(ja)))
    ibdict = OrderedDict(zip(ib, 1:length(ib)))
    jbdict = OrderedDict(zip(jb, 1:length(jb)))
    return _diff(A, B, iadict, jadict, ibdict, jbdict)
end

# TODO Implement a more efficient alternative that needs no mapping
function _diff(A::AbstractMatrix, B::AbstractMatrix)
end

# TODO
function _diff(A::AbstractMatrix, B::AbstractMatrix, ia::OrderedDict,
            ja::OrderedDict, ib::OrderedDict, jb::OrderedDict)
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
    addival = view(Matrix{T}(undef, 0, 0), :, :)
    addjval = view(Matrix{T}(undef, 0, 0), :, :)
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
    remival = view(Matrix{T}(undef, 0, 0), :, :)
    remjval = view(Matrix{T}(undef, 0, 0), :, :)
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
