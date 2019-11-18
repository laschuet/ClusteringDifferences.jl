"""
    AbstractClusteringDifferenceEncoding

Supertype for clustering difference encodings.
"""
abstract type AbstractClusteringDifferenceEncoding end

"""
    PartitionalClusteringDifferenceEncoding <: AbstractClusteringDifferenceEncoding

Explicit encoding of a partitional clustering difference.
"""
struct PartitionalClusteringDifferenceEncoding <: AbstractClusteringDifferenceEncoding
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
    PartitionalClusteringDifferenceEncoding(a::PartitionalClusteringDifference)

Construct partitional clustering difference encoding from partitional clustering difference.
"""
function PartitionalClusteringDifferenceEncoding(a::PartitionalClusteringDifference)
    X = mask(a.X, a.m, a.n)
    C = mask(a.C, a.n, a.n)
    W = mask(a.W, a.n, a.n)
    Y = mask(a.Y, a.k, a.n)
    M = mask(a.M, a.m, a.k)
    return PartitionalClusteringDifferenceEncoding(X, C, W, Y, M)
end

"""
    mask(A::AbstractMatrix{Union{Nothing,T}}, Δdimx::Int, Δdimy::Int) where T<:Real
    mask(A::AbstractMatrix{T}, Δdimx::Int, Δdimy::Int) where T<:Real

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
function mask(A::AbstractMatrix{Union{Nothing,T}}, Δdimx::Int, Δdimy::Int) where T<:Real
    szx, szy = size(A)
    return map(m -> begin
        idx, val = m
        isnothing(val) && return 3
        y, x = divrem(idx - 1, szx) .+ 1
        x > szx - abs(Δdimx) && return sign(Δdimx)
        y > szy - abs(Δdimy) && return sign(Δdimy)
        iszero(val) && return 0
        return 2
    end, enumerate(A))
end
mask(A::AbstractMatrix{T}, Δdimx::Int, Δdimy::Int) where T<:Real =
    mask(convert(AbstractMatrix{Union{Nothing,T}}, A), Δdimx, Δdimy)
