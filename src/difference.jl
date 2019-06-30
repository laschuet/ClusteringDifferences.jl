abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Real,Tw<:Real,Tm<:Real} <: ClusteringDifference

Difference between two partitional clustering models.
"""
struct PartitionalClusteringDifference{Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real} <: ClusteringDifference
    X::AbstractMatrix{Tx}
    C::AbstractMatrix{Int}
    W::AbstractMatrix{Tw}
    Y::AbstractMatrix{Ty}
    M::AbstractMatrix{Tm}
    k::Int
    Y_MASK::AbstractMatrix{Int}
    M_MASK::AbstractMatrix{Int}

    function PartitionalClusteringDifference{Tx,Tw,Ty,Tm}(X::AbstractMatrix{Tx},
                                                        C::AbstractMatrix{Int},
                                                        W::AbstractMatrix{Tw},
                                                        Y::AbstractMatrix{Ty},
                                                        M::AbstractMatrix{Tm},
                                                        k::Int,
                                                        Y_MASK::AbstractMatrix{Int},
                                                        M_MASK::AbstractMatrix{Int}) where {Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real}
        size(X, 2) == size(Y, 2) ||
            throw(DimensionMismatch("number of data instances and number of data instances assigned must match"))
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        size(Y, 1) == size(M, 2) ||
            throw(DimensionMismatch("number of clusters must match"))
        size(Y) == size(Y_MASK) ||
            throw(DimensionMismatch("dimensions of assignments and mask must match"))
        size(M) == size(M_MASK) ||
            throw(DimensionMismatch("dimensions of centers and mask must match"))
        return new(X, C, W, Y, M, k, Y_MASK, M_MASK)
    end
end
PartitionalClusteringDifference(X::AbstractMatrix{Tx}, C::AbstractMatrix{Int},
                                W::AbstractMatrix{Tw}, Y::AbstractMatrix{Ty},
                                M::AbstractMatrix{Tm}, k::Int,
                                Y_MASK::AbstractMatrix{Int},
                                M_MASK::AbstractMatrix{Int}) where {Tx,Tw,Ty,Tm} =
    PartitionalClusteringDifference{Tx,Tw,Ty,Tm}(X, C, W, Y, M, k, Y_MASK, M_MASK)

"""
    mask(ΔM::AbstractMatrix{<:Real}, Δdims::NTuple{2, Int})

Mask the various types of differences.

Types and code:

    | Type                       | Code |
    | :------------------------- | ---- |
    | no information             |    3 |
    | no difference              |    0 |
    | addition of new value      |    1 |
    | deletion of previous value |   -1 |
    | value difference           |    2 |
"""
function mask(ΔM::AbstractMatrix{<:Real}, Δdims::NTuple{2, Int})
    return map(m -> begin
        idx, val = m

        isnothing(val) && return 3

        szx, szy = size(ΔM)
        Δdimx, Δdimy = Δdims
        y, x = divrem(idx - 1, szx) .+ 1
        x > szx - abs(Δdimx) && return sign(Δdimx)
        y > szy - abs(Δdimy) && return sign(Δdimy)

        iszero(val) && return 0

        return 2
    end, enumerate(ΔM))
end

# Partitional clustering model subtraction
# Assume that data will not change (at least number of instances and features)
# Assume that number of clusters might change
function Base.:-(a::PartitionalClustering, b::PartitionalClustering)
    X = a.X - b.X
    C = a.C - b.C
    W = a.W - b.W
    k = size(a.M, 2) - size(b.M, 2)
    if k == 0
        Y = a.Y - b.Y
        M = a.M - b.M
    else
        Y = a.Y ⊟ b.Y
        M = a.M ⊟ b.M
    end
    Y_MASK = mask(Y, (k, 0))
    M_MASK = mask(M, (0, k))
    return PartitionalClusteringDifference(X, C, W, Y, M, k, Y_MASK, M_MASK)
end

"""
    forward(cs::AbstractVector{PartitionalClustering}, i::Int)
    Δ(cs::AbstractVector{PartitionalClustering}, i::Int)

Compute the forward difference of the clustering model at the given `i`.
"""
function forward(cs::AbstractVector{<:PartitionalClustering}, i::Int)
    i == length(cs) && return nothing
    return cs[i + 1] - cs[i]
end
const Δ = forward

"""
    backward(cs::AbstractVector{PartitionalClustering}, i::Int)
    ∇(cs::AbstractVector{PartitionalClustering}, i::Int)

Compute the backward difference of the clustering model at the given `i`.
"""
function backward(cs::AbstractVector{<:PartitionalClustering}, i::Int)
    if i == 1
        c = cs[1]
        k = size(c.M, 2)
        Y_MASK = fill(1, size(c.Y))
        M_MASK = fill(1, size(c.M))
        cd = PartitionalClusteringDifference(c.X, c.C, c.W, c.Y, c.M, k, Y_MASK,
                M_MASK)
        i == 1 && return cd
    end
    return cs[i] - cs[i - 1]
end
const ∇ = backward

"""
    differences(cs::AbstractVector{<:PartitionalClustering}; <keyword arguments>)

Compute the differences between adjacent clusterings.

# Keyword arguments
- `asc::Bool=true`: Wheter to compute the differences in ascending order (``true``) instead of descending order (``false``).
"""
function differences(cs::AbstractVector{<:PartitionalClustering};
                    asc::Bool=true)
    n = length(cs)

    n > 1 || throw(ArgumentError("number of clusterings must at least be 2"))

    cds = Vector{PartitionalClusteringDifference}(undef, n - 1)
    @inbounds for i = 1:(n - 1)
        cds[i] = asc ? cs[i + 1] - cs[i] : cs[i] - cs[i + 1]
    end
    return cds
end
