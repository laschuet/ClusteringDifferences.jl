abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Real,Tw<:Real,Tm<:Real} <: ClusteringDifference

Difference between two partitional clustering models.
"""
struct PartitionalClusteringDifference{Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real} <: ClusteringDifference
    X::Matrix{Tx}
    C::Matrix{Int}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}
    k::Int
    Y_MASK::Matrix{Int}
    M_MASK::Matrix{Int}

    function PartitionalClusteringDifference{Tx,Tw,Ty,Tm}(X::Matrix{Tx},
                                                        C::Matrix{Int},
                                                        W::Matrix{Tw},
                                                        Y::Matrix{Ty},
                                                        M::Matrix{Tm},
                                                        k::Int,
                                                        Y_MASK::Matrix{Int},
                                                        M_MASK::Matrix{Int}) where {Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real}
        size(X, 1) == size(Y, 1) ||
            throw(DimensionMismatch("number of data instances and number of data instances assigned must match"))
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        size(Y, 2) == size(M, 1) ||
            throw(DimensionMismatch("number of clusters must match"))
        size(Y) == size(Y_MASK) ||
            throw(DimensionMismatch("dimensions of assignments and mask must match"))
        size(M) == size(M_MASK) ||
            throw(DimensionMismatch("dimensions of centers and mask must match"))
        return new(X, C, W, Y, M, k, Y_MASK, M_MASK)
    end
end
PartitionalClusteringDifference(X::Matrix{Tx}, C::Matrix{Int}, W::Matrix{Tw},
                                Y::Matrix{Ty}, M::Matrix{Tm}, k::Int,
                                Y_MASK::Matrix{Int}, M_MASK::Matrix{Int}) where {Tx,Tw,Ty,Tm} =
    PartitionalClusteringDifference{Tx,Tw,Ty,Tm}(X, C, W, Y, M, k, Y_MASK, M_MASK)

"""
    mask(ΔM::Matrix{<:Real}, Δdims::NTuple{2, Int})

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
function mask(ΔM::Matrix{<:Real}, Δdims::NTuple{2, Int})
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
    k = size(a.M, 1) - size(b.M, 1)
    if k == 0
        Y = a.Y - b.Y
        M = a.M - b.M
    else
        Y = a.Y ⊟ b.Y
        M = a.M ⊟ b.M
    end
    Y_MASK = mask(Y, (0, k))
    M_MASK = mask(M, (k, 0))
    return PartitionalClusteringDifference(X, C, W, Y, M, k, Y_MASK, M_MASK)
end

"""
    forward(clusterings::Vector{PartitionalClustering}, i::Integer)
    Δ(clusterings::Vector{PartitionalClustering}, i::Integer)

Compute the forward difference of the clustering model at the given `i`.
"""
function forward(clusterings::Vector{<:PartitionalClustering}, i::Integer)
    i == length(clusterings) && return nothing
    return clusterings[i + 1] - clusterings[i]
end
const Δ = forward

"""
    backward(clusterings::Vector{PartitionalClustering}, i::Integer)
    ∇(clusterings::Vector{PartitionalClustering}, i::Integer)

Compute the backward difference of the clustering model at the given `i`.
"""
function backward(clusterings::Vector{<:PartitionalClustering}, i::Integer)
    if i == 1
        pc = clusterings[1]
        k = size(pc.M, 1)
        Y_MASK = fill(1, size(pc.Y))
        M_MASK = fill(1, size(pc.M))
        pcd = PartitionalClusteringDifference(pc.X, pc.C, pc.W, pc.Y, pc.M, k,
                Y_MASK, M_MASK)
        i == 1 && return pcd
    end
    return clusterings[i] - clusterings[i - 1]
end
const ∇ = backward
