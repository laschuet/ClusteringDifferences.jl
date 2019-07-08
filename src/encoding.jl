abstract type ClusteringDifferenceEncoding end

"""
    PartitionalClusteringDifferenceEncoding <: ClusteringDifferenceEncoding

Explicit encoding of a partitional clustering difference.
"""
struct PartitionalClusteringDifferenceEncoding <: ClusteringDifferenceEncoding
    X::Matrix{Int}
    C::Matrix{Int}
    W::Matrix{Int}
    Y::Matrix{Int}
    M::Matrix{Int}

    function PartitionalClusteringDifferenceEncoding(X::Matrix{<:Integer},
                                                    C::Matrix{<:Integer},
                                                    W::Matrix{<:Integer},
                                                    Y::Matrix{<:Integer},
                                                    M::Matrix{<:Integer})
        nc = size(C, 2)
        nw = size(W, 2)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(X, C, W, Y, M)
    end
end

"""
    PartitionalClusteringDifferenceEncoding(cd::PartitionalClusteringDifference)

Construct partitional clustering difference encoding from partitional clustering difference.
"""
function PartitionalClusteringDifferenceEncoding(cd::PartitionalClusteringDifference)
    X = mask(cd.X, (cd.m, cd.n))
    C = mask(cd.C, (cd.n, cd.n))
    W = mask(cd.W, (cd.n, cd.n))
    Y = mask(cd.Y, (cd.k, cd.n))
    M = mask(cd.M, (cd.m, cd.k))
    PartitionalClusteringDifferenceEncoding(X, C, W, Y, M)
end

"""
    mask(ΔM::AbstractMatrix{Union{Nothing,T}}, Δdims::NTuple{2,Int}) where T<:Real
    mask(ΔM::AbstractMatrix{T}, Δdims::NTuple{2,Int}) where T<:Real

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
function mask(ΔM::AbstractMatrix{Union{Nothing,T}}, Δdims::NTuple{2,Int}) where T<:Real
    szx, szy = size(ΔM)
    Δdimx, Δdimy = Δdims
    return map(m -> begin
        idx, val = m
        isnothing(val) && return 3
        y, x = divrem(idx - 1, szx) .+ 1
        x > szx - abs(Δdimx) && return sign(Δdimx)
        y > szy - abs(Δdimy) && return sign(Δdimy)
        iszero(val) && return 0
        return 2
    end, enumerate(ΔM))
end
mask(ΔM::AbstractMatrix{T}, Δdims::NTuple{2,Int}) where T<:Real =
    mask(convert(AbstractMatrix{Union{T,Nothing}}, ΔM), Δdims)
