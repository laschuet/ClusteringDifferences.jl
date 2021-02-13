"""
    AbstractClustering

Supertype for clusterings.
"""
abstract type AbstractClustering end

"""
    PartitionalClustering{Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClustering

Partitional clustering.
"""
struct PartitionalClustering{Tc<:Integer,Tw<:Real,Ty<:Real} <: AbstractClustering
    r::Vector{Int}
    c::Vector{Int}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    p::NamedTuple

    function PartitionalClustering{Tc,Tw,Ty}(r::Vector{Int}, c::Vector{Int},
                                            C::Matrix{Tc}, W::Matrix{Tw},
                                            Y::Matrix{Ty}, p::NamedTuple) where {Tc<:Integer,Tw<:Real,Ty<:Real}
        size(C, 2) == size(W, 2) || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(r, c, C, W, Y, p)
    end
end
PartitionalClustering(r::Vector{Int}, c::Vector{Int}, C::Matrix{Tc},
                    W::Matrix{Tw}, Y::Matrix{Ty}, p::NamedTuple) where {Tc,Tw,Ty} =
    PartitionalClustering{Tc,Tw,Ty}(r, c, C, W, Y, p)

# Partitional clustering equality operator
Base.:(==)(a::PartitionalClustering, b::PartitionalClustering) =
    (a.r == b.r && a.c == b.c && a.C == b.C && a.W == b.W && a.Y == b.Y
            && a.p == b.p)

# Compute hash code
Base.hash(a::PartitionalClustering, h::UInt) =
    hash(a.r, hash(a.c, hash(a.C, hash(a.W, hash(a.Y, hash(a.p,
        hash(:PartitionalClustering, h)))))))

"""
    HierarchicalClustering{Tc<:Integer,Tw<:Real} <: AbstractClustering

Hierarchical clustering.
"""
struct HierarchicalClustering{Tc<:Integer,Tw<:Real} <: AbstractClustering
    r::Vector{Int}
    c::Vector{Int}
    C::Array{Tc,3}
    W::Array{Tw,3}
    p::NamedTuple

    function HierarchicalClustering{Tc,Tw}(r::Vector{Int}, c::Vector{Int},
                                        C::Array{Tc,3}, W::Array{Tw,3},
                                        p::NamedTuple) where {Tc<:Integer,Tw<:Real}
        size(C, 2) == size(W, 2) || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(r, c, C, W, p)
    end
end
HierarchicalClustering(r::Vector{Int}, c::Vector{Int}, C::Array{Tc,3},
                    W::Array{Tw,3}, p::NamedTuple) where {Tc,Tw} =
    HierarchicalClustering{Tc,Tw}(r, c, C, W, p)

"""
    instances(a::AbstractClustering)

Access the instance indices.
"""
Base.instances(a::AbstractClustering) = a.c

"""
    features(a::AbstractClustering)

Access the feature indices.
"""
features(a::AbstractClustering) = a.r

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
    parameters(c::PartitionalClustering)

Access the parameters.
"""
parameters(a::AbstractClustering) = a.p

"""
    assignments(a::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(a::PartitionalClustering) = a.Y
