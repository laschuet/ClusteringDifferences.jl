abstract type ClusteringDifferenceEncoding end

"""
    PartitionalClusteringDifferenceEncoding <: ClusteringDifferenceEncoding

Explicit encoding of a partitional clustering difference.
"""
struct PartitionalClusteringDifferenceEncoding <: ClusteringDifferenceEncoding
    X::AbstractMatrix{Int}
    C::AbstractMatrix{Int}
    W::AbstractMatrix{Int}
    Y::AbstractMatrix{Int}
    M::AbstractMatrix{Int}

    function PartitionalClusteringDifferenceEncoding(X::AbstractMatrix{Int},
                                                    C::AbstractMatrix{Int},
                                                    W::AbstractMatrix{Int},
                                                    Y::AbstractMatrix{Int},
                                                    M::AbstractMatrix{Int})
        size(X, 2) == size(Y, 2) ||
            throw(DimensionMismatch("number of data instances and number of data instances assigned must match"))
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        size(Y, 1) == size(M, 2) ||
            throw(DimensionMismatch("number of clusters must match"))
        return new(X, C, W, Y, M)
    end
end

"""
    PartitionalClusteringDifferenceEncoding(cd::PartitionalClusteringDifference)

Construct partitional clustering difference encoding from partitional clustering difference.
"""
function PartitionalClusteringDifferenceEncoding(cd::PartitionalClusteringDifference)
    X = mask(cd.X, (0, 0))
    C = mask(cd.C, (0, 0))
    W = mask(cd.W, (0, 0))
    Y = mask(cd.Y, (cd.k, 0))
    M = mask(cd.M, (0, cd.k))
    PartitionalClusteringDifferenceEncoding(X, C, W, Y, M)
end

"""
    mask(ΔM::AbstractMatrix{Union{T, Nothing}}, Δdims::NTuple{2, Int}) where T<:Real
    mask(ΔM::AbstractMatrix{T}, Δdims::NTuple{2, Int}) where T<:Real =

Create mask that encodes the various types of differences.

# Types and code
| Type                       | Code |
| :------------------------- | ---- |
| no information             |    3 |
| no difference              |    0 |
| addition of new value      |    1 |
| deletion of previous value |   -1 |
| value difference           |    2 |
"""
function mask(ΔM::AbstractMatrix{Union{T, Nothing}}, Δdims::NTuple{2, Int}) where T<:Real
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
mask(ΔM::AbstractMatrix{T}, Δdims::NTuple{2, Int}) where T<:Real =
    mask(convert(AbstractMatrix{Union{T, Nothing}}, ΔM), Δdims)
