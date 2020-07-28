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

#=
function PartitionalClustering(C::Matrix{Tc}, W::Matrix{Tw}, Y::Matrix{Ty},
                            p::NamedTuple) where {Tc,Tw,Ty}
    r = collect(1:size(X, 1))
    c = collect(1:size(X, 2))
    return PartitionalClustering(r, c, C, W, Y, p)
end
=#

# Partitional clustering equality operator
==(a::PartitionalClustering, b::PartitionalClustering) =
    (a.r == b.r && a.c == b.c && a.C == b.C && a.W == b.W && a.Y == b.Y
            && a.p == b.p)

# Compute hash code
hash(a::PartitionalClustering, h::UInt) =
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

    function HierarchicalClustering{Tc,Tw}(r::Vector{Int}, c::Vector{Int},
                                        C::Array{Tc,3}, W::Array{Tw,3}) where {Tc<:Integer,Tw<:Real}
        size(C, 2) == size(W, 2) || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(r, c, C, W)
    end
end
HierarchicalClustering(r::Vector{Int}, c::Vector{Int}, C::Array{Tc,3},
                    W::Array{Tw,3}) where {Tc,Tw} =
    HierarchicalClustering{Tc,Tw}(r, c, C, W)

#=
function HierarchicalClustering(C::Array{Tc,3}, W::Array{Tw,3}) where {Tc,Tw}
    r = collect(1:size(X, 1))
    c = collect(1:size(X, 2))
    return HierarchicalClustering(r, c, C, W)
end
=#

"""
    instances(a::AbstractClustering)

Access the instance indices.
"""
instances(a::AbstractClustering) = a.c

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
    assignments(a::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(a::PartitionalClustering) = a.Y

"""
    parameters(c::PartitionalClustering)
    θ(c::PartitionalClustering)

Access the parameters.
"""
parameters(a::PartitionalClustering) = a.p
const θ = parameters
