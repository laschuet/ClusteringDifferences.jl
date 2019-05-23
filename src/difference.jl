abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Real,Tw<:Real,Tm<:Real} <: ClusteringDifference

Difference between two partitional clustering models.
"""
struct PartitionalClusteringDifference{Tx<:Real,Tw<:Real,Tm<:Real} <: ClusteringDifference
    X::Matrix{Tx}
    C::Matrix{Int}
    W::Matrix{Tw}
    Y::Vector{Int}
    M::Matrix{Tm}
end

# Partitional clustering model subtraction
function Base.:-(a::PartitionalClustering, b::PartitionalClustering)
    # TODO: Avoid assumption that sizes are equal
    X = a.X - b.X
    C = a.C - b.C
    W = a.W - b.W
    Y = a.Y - b.Y
    M = a.M - b.M
    return PartitionalClusteringDifference(X, C, W, Y, M)
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
    i == 1 && return clusterings[1]
    return clusterings[i] - clusterings[i - 1]
end
const ∇ = backward
