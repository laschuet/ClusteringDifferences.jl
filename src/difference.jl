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
    X::MatrixDifference
    i::SetDifference{Int}
    j::SetDifference{Int}
    C::MatrixDifference
    W::MatrixDifference
    Y::MatrixDifference
    M::MatrixDifference
    k::Int

    function PartitionalClusteringDifference(X::MatrixDifference,
                                            i::SetDifference{Int},
                                            j::SetDifference{Int},
                                            C::MatrixDifference,
                                            W::MatrixDifference,
                                            Y::MatrixDifference,
                                            M::MatrixDifference, k::Integer)
        return new(X, i, j, C, W, Y, M, k)
    end
end

# Partitional clustering difference equality operator
==(a::PartitionalClusteringDifference, b::PartitionalClusteringDifference) =
    (a.X == b.X && a.i == b.i && a.j == b.j && a.C == b.C && a.W == b.W
            && a.Y == b.Y && a.M == b.M && a.k == b.k)

# Compute hash code
hash(a::PartitionalClusteringDifference, h::UInt) =
    hash(a.X, hash(a.i, hash(a.j, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(a.k, hash(:PartitionalClusteringDifference, h)))))))))

# Partitional clustering subtraction operator
function -(a::PartitionalClustering, b::PartitionalClustering)
    X = MatrixDifference(diff(a.X, b.X, a.i, a.j, b.i, b.j)...)
    i = SetDifference(diff(a.i, b.i)...)
    j = SetDifference(diff(a.j, b.j)...)
    C = MatrixDifference(diff(a.C, b.C, a.j, a.j, b.j, b.j)...)
    W = MatrixDifference(diff(a.W, b.W, a.j, a.j, b.j, b.j)...)
    ayi = collect(1:size(a.Y, 1))
    byi = collect(1:size(b.Y, 1))
    Y = MatrixDifference(diff(a.Y, b.Y, ayi, a.j, byi, b.j)...)
    amj = collect(1:size(a.M, 2))
    bmj = collect(1:size(b.M, 2))
    M = MatrixDifference(diff(a.M, b.M, a.i, amj, b.i, bmj)...)
    k = size(a.M, 2) - size(b.M, 2)
    return PartitionalClusteringDifference(X, i, j, C, W, Y, M, k)
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
