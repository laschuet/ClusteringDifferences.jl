abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Union{Nothing,Real},Tc<:Union{Nothing,Integer},Tw<:Union{Nothing,Real},
                                    Ty<:Union{Nothing,Real},Tm<:Union{Nothing,Real}} <: ClusteringDifference

Difference between two partitional clustering models.
"""
struct PartitionalClusteringDifference{Tx<:Union{Nothing,Real},Tc<:Union{Nothing,Integer},Tw<:Union{Nothing,Real},
                                    Ty<:Union{Nothing,Real},Tm<:Union{Nothing,Real}} <: ClusteringDifference
    X::Matrix{Tx}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}
    m::Int
    n::Int
    k::Int

    function PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X::Matrix{Tx},
                                                            C::Matrix{Tc},
                                                            W::Matrix{Tw},
                                                            Y::Matrix{Ty},
                                                            M::Matrix{Tm},
                                                            m::Integer,
                                                            n::Integer,
                                                            k::Integer) where {Tx<:Union{Nothing,Real},
                                                                            Tc<:Union{Nothing,Integer},
                                                                            Tw<:Union{Nothing,Real},
                                                                            Ty<:Union{Nothing,Real},
                                                                            Tm<:Union{Nothing,Real}}
        nc = size(C, 2)
        nw = size(W, 2)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(X, C, W, Y, M, m, n, k)
    end
end
PartitionalClusteringDifference(X::Matrix{Tx}, C::Matrix{Tc}, W::Matrix{Tw},
                                Y::Matrix{Ty}, M::Matrix{Tm}, m::Integer,
                                n::Integer, k::Integer) where {Tx,Tc,Tw,Ty,Tm} =
    PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X, C, W, Y, M, m, n, k)

# Partitional clustering model difference equality operator
Base.:(==)(a::PartitionalClusteringDifference,
        b:: PartitionalClusteringDifference) =
    (a.X == b.X && a.C == b.C && a.W == b.W && a.Y == b.Y && a.M == b.M
            && a.m == b.m && a.n == b.n && a.k == b.k)

# Compute hash code
Base.hash(a::PartitionalClusteringDifference, h::UInt) =
    hash(a.X, hash(a.C, hash(a.W, hash(a.Y, hash(a.M, hash(a.m, hash(a.n,
        hash(a.k, hash(:PartitionalClusteringDifference, h)))))))))

# Partitional clustering model subtraction operator
function Base.:-(a::PartitionalClustering, b::PartitionalClustering)
    X = a.X ⊟ b.X
    C = a.C ⊟ b.C
    W = a.W ⊟ b.W
    Y = a.Y ⊟ b.Y
    M = a.M ⊟ b.M
    m, n = size(a.X) .- size(b.X)
    k = size(a.M, 2) - size(b.M, 2)
    return PartitionalClusteringDifference(X, C, W, Y, M, m, n, k)
end

"""
    forwarddiff(a::AbstractVector{<:Clustering}, i::Int[, h::Int=1])

Compute the forward difference of the clustering model at index `i` with step
size `h`.
"""
function forwarddiff(a::AbstractVector{<:Clustering}, i::Int, h::Int=1)
    i > length(a) - h && return nothing
    return a[i + h] - a[i]
end

"""
    backwarddiff(a::AbstractVector{<:Clustering}, i::Int[, h::Int=1])

Compute the backward difference of the clustering model at index `i` with step
size `h`.
"""
function backwarddiff(a::AbstractVector{<:Clustering}, i::Int, h::Int=1)
    if i - h < 1
        c = a[i]
        m, n = size(c.X)
        k = size(c.M, 2)
        return PartitionalClusteringDifference(c.X, c.C, c.W, c.Y, c.M, m, n, k)
    end
    return a[i] - a[i - h]
end
