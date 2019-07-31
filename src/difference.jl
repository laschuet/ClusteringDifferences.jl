abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Real,Tc<:Integer,Tw<:Real,Tm<:Real} <: ClusteringDifference

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

# Partitional clustering model subtraction
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
        m, n = size(c.X)
        k = size(c.M, 2)
        cd = PartitionalClusteringDifference(c.X, c.C, c.W, c.Y, c.M, m, n, k)
        return cd
    end
    return cs[i] - cs[i - 1]
end
const ∇ = backward

"""
    differences(cs::AbstractVector{<:PartitionalClustering}; <keyword arguments>)

Compute the differences between adjacent clustering models.

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
