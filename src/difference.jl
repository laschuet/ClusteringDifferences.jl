abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Union{Nothing,Real},Tc<:Union{Nothing,Integer},Tw<:Union{Nothing,Real},
                                    Ty<:Union{Nothing,Real},Tm<:Union{Nothing,Real}} <: ClusteringDifference

Difference between two partitional clustering models.
"""
struct PartitionalClusteringDifference{Tx<:Union{Nothing,Real},Tc<:Union{Nothing,Integer},Tw<:Union{Nothing,Real},
                                    Ty<:Union{Nothing,Real},Tm<:Union{Nothing,Real}} <: ClusteringDifference
    X::Matrix{Tx}
    I::Vector{Int}
    J::Vector{Int}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}
    m::Int
    n::Int
    k::Int

    function PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X::Matrix{Tx},
                                                            I::Vector{<:Integer},
                                                            J::Vector{<:Integer},
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
        return new(X, I, J, C, W, Y, M, m, n, k)
    end
end
PartitionalClusteringDifference(X::Matrix{Tx}, I::Vector{Ti}, J::Vector{Tj},
                                C::Matrix{Tc}, W::Matrix{Tw}, Y::Matrix{Ty},
                                M::Matrix{Tm}, m::Integer, n::Integer,
                                k::Integer) where {Tx,Ti,Tj,Tc,Tw,Ty,Tm} =
    PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X, I, J, C, W, Y, M, m, n, k)

function PartitionalClusteringDifference(X::Matrix{Tx}, C::Matrix{Tc},
                                        W::Matrix{Tw}, Y::Matrix{Ty},
                                        M::Matrix{Tm}, m::Integer, n::Integer,
                                        k::Integer) where {Tx,Tc,Tw,Ty,Tm}
    I = Int[]
    J = Int[]
    return PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X, I, J, C, W, Y, M, m, n, k)
end

# Partitional clustering model difference equality operator
Base.:(==)(a::PartitionalClusteringDifference,
        b:: PartitionalClusteringDifference) =
    (a.X == b.X && a.I == b.I && a.J == b.J && a.C == b.C && a.W == b.W
            && a.Y == b.Y && a.M == b.M && a.m == b.m && a.n == b.n
            && a.k == b.k)

# Compute hash code
Base.hash(a::PartitionalClusteringDifference, h::UInt) =
    hash(a.X, hash(a.I, hash(a.J, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(a.m, hash(a.n, hash(a.k,
            hash(:PartitionalClusteringDifference, h)))))))))))

# Partitional clustering model subtraction operator
function Base.:-(a::PartitionalClustering, b::PartitionalClustering)
    X = diff(a.X, b.X, a.I, a.J, b.I, b.J)
    I = diff(a.I, b.I)
    J = diff(a.J, b.J)
    C = diff(a.C, b.C, a.J, a.J, b.J, b.J)
    W = diff(a.W, b.W, a.J, a.J, b.J, b.J)
    Y = diff(a.Y, b.Y, 1:size(a.Y, 1), a.J, 1:size(b.Y, 1), b.J)
    M = diff(a.M, b.M, a.I, 1:size(a.M, 2), b.I, 1:size(b.M, 2))
    m, n = size(a.X) .- size(b.X)
    k = size(a.M, 2) - size(b.M, 2)
    return PartitionalClusteringDifference(X, I, J, C, W, Y, M, m, n, k)
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
        return PartitionalClusteringDifference(c.X, c.I, c.J, c.C, c.W, c.Y,
                c.M, m, n, k)
    end
    return a[i] - a[i - h]
end
