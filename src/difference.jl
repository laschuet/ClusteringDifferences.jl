"""
    AbstractClusteringDifference

Supertype for clustering differences.
"""
abstract type AbstractClusteringDifference end

"""
    PartitionalClusteringDifference <: AbstractClusteringDifference

Difference between two partitional clusterings.
"""
struct PartitionalClusteringDifference <: AbstractClusteringDifference
    i::SetDifference{Int}
    j::SetDifference{Int}
    C::MatrixDifference
    W::MatrixDifference
    Y::MatrixDifference
    p::NamedTupleDifference

    function PartitionalClusteringDifference(i::SetDifference{Int},
                                            j::SetDifference{Int},
                                            C::MatrixDifference,
                                            W::MatrixDifference,
                                            Y::MatrixDifference,
                                            p::NamedTupleDifference)
        return new(i, j, C, W, Y, p)
    end
end

# Partitional clustering difference equality operator
==(a::PartitionalClusteringDifference, b::PartitionalClusteringDifference) =
    (a.i == b.i && a.j == b.j && a.C == b.C && a.W == b.W && a.Y == b.Y
            && a.p == b.p)

# Compute hash code
hash(a::PartitionalClusteringDifference, h::UInt) =
    hash(a.i, hash(a.j, hash(a.C, hash(a.W, hash(a.Y, hash(a.p,
        hash(:PartitionalClusteringDifference, h)))))))

# Partitional clustering subtraction operator
function -(a::PartitionalClustering, b::PartitionalClustering)
    i = diff(Set(a.i), Set(b.i))
    j = diff(Set(a.j), Set(b.j))
    C = diff(a.C, b.C, a.j, a.j, b.j, b.j)
    W = diff(a.W, b.W, a.j, a.j, b.j, b.j)
    ayi = collect(1:size(a.Y, 1))
    byi = collect(1:size(b.Y, 1))
    Y = diff(a.Y, b.Y, ayi, a.j, byi, b.j)
    p = diff(a.p, b.p)
    return PartitionalClusteringDifference(i, j, C, W, Y, p)
end

"""
    forwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int[, h::Int=1])

Compute the forward difference of the clustering at index `i` with step
size `h`.
"""
forwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int, h::Int=1) =
    a[i + h] - a[i]

"""
    backwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int[, h::Int=1])

Compute the backward difference of the clustering at index `i` with step
size `h`.
"""
backwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int, h::Int=1) =
    a[i] - a[i - h]
