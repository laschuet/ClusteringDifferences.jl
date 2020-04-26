"""
    AbstractClustering

Supertype for clusterings.
"""
abstract type AbstractClustering end

"""
    PartitionalClustering{Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClustering

Partitional clustering.
"""
struct PartitionalClustering{Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClustering
    i::Vector{Int}
    j::Vector{Int}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}

    function PartitionalClustering{Tc,Tw,Ty,Tm}(i::Vector{Int}, j::Vector{Int},
                                                C::Matrix{Tc}, W::Matrix{Tw},
                                                Y::Matrix{Ty}, M::Matrix{Tm}) where {Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real}
        nc = size(C, 2)
        nw = size(W, 2)
        ky, ny = size(Y)
        mm, km = size(M)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        ky == km || throw(DimensionMismatch("number of clusters must match"))
        return new(i, j, C, W, Y, M)
    end
end
PartitionalClustering(i::Vector{Int}, j::Vector{Int}, C::Matrix{Tc},
                    W::Matrix{Tw}, Y::Matrix{Ty}, M::Matrix{Tm}) where {Tc,Tw,Ty,Tm} =
    PartitionalClustering{Tc,Tw,Ty,Tm}(i, j, C, W, Y, M)

#=
function PartitionalClustering(C::Matrix{Tc}, W::Matrix{Tw}, Y::Matrix{Ty},
                            M::Matrix{Tm}) where {Tc,Tw,Ty,Tm}
    i = collect(1:size(X, 1))
    j = collect(1:size(X, 2))
    return PartitionalClustering(i, j, C, W, Y, M)
end
=#

# Partitional clustering equality operator
==(a::PartitionalClustering, b::PartitionalClustering) =
    (a.i == b.i && a.j == b.j && a.C == b.C && a.W == b.W && a.Y == b.Y
            && a.M == b.M)

# Compute hash code
hash(a::PartitionalClustering, h::UInt) =
    hash(a.i, hash(a.j, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(:PartitionalClustering, h)))))))

"""
    HierarchicalClustering{Tc<:Integer,Tw<:Real} <: AbstractClustering

Hierarchical clustering.
"""
struct HierarchicalClustering{Tc<:Integer,Tw<:Real} <: AbstractClustering
    i::Vector{Int}
    j::Vector{Int}
    C::Array{Tc,3}
    W::Array{Tw,3}

    function HierarchicalClustering{Tc,Tw}(i::Vector{Int}, j::Vector{Int},
                                        C::Array{Tc,3}, W::Array{Tw,3}) where {Tc<:Integer,Tw<:Real}
        nc = size(C, 2)
        nw = size(W, 2)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(i, j, C, W)
    end
end
HierarchicalClustering(i::Vector{Int}, j::Vector{Int}, C::Array{Tc,3},
                    W::Array{Tw,3}) where {Tc,Tw} =
    HierarchicalClustering{Tc,Tw}(i, j, C, W)

#=
function HierarchicalClustering(C::Array{Tc,3}, W::Array{Tw,3}) where {Tc,Tw}
    i = collect(1:size(X, 1))
    j = collect(1:size(X, 2))
    return HierarchicalClustering(i, j, C, W)
end
=#

"""
    instances(a::AbstractClustering)

Access the instance indices.
"""
instances(a::AbstractClustering) = a.j

"""
    features(a::AbstractClustering)

Access the feature indices.
"""
features(a::AbstractClustering) = a.i

"""
    constraints(a::AbstractClustering)

Access the contraints.
"""
constraints(a::AbstractClustering) = a.C

"""
    weights(a::AbstractClustering)

Access the weights.
"""
weights(a::AbstractClustering) = a.W

"""
    assignments(a::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(a::PartitionalClustering) = a.Y

"""
    centers(a::PartitionalClustering)

Access the centers.
"""
centers(a::PartitionalClustering) = a.M

"""
    θ(c::PartitionalClustering)

Access the parameters.
"""
θ(a::PartitionalClustering) = (a.M)
