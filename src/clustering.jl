abstract type Clustering end

"""
    PartitionalClustering{Tx<:Real,Tw<:Real,Tm<:Real} <: Clustering

Partitional clustering model.
"""
struct PartitionalClustering{Tx<:Real,Tw<:Real,Tm<:Real} <: Clustering
    X::Matrix{Tx}
    C::Matrix{Int}
    W::Matrix{Tw}
    Y::Vector{Int}
    μ::Vector{Tm}

    function PartitionalClustering{Tx,Tw,Tm}(X::Matrix{Tx}, C::Matrix{Int},
                                            W::Matrix{Tw}, Y::Vector{Int},
                                            μ::Vector{Tm}) where {Tx<:Real,Tw<:Real,Tm<:Real}
        size(X, 1) == length(Y) ||
            throw(DimensionMismatch("number of data instances and number of assignments must match"))
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        return new(X, C, W, Y, μ)
    end
end
PartitionalClustering(X::Matrix{Tx}, C::Matrix{Int}, W::Matrix{Tw},
                    Y::Vector{Int}, μ::Vector{Tm}) where {Tx,Tw,Tm} =
    PartitionalClustering{Tx,Tw,Tm}(X, C, W, Y, μ)

"""
    HierarchicalClustering

Hierarchical clustering model.
"""
struct HierarchicalClustering <: Clustering
    X::Matrix{Any}
    C::Array{Int, 3}
    W::Matrix{Float64}
end

"""
    data(c::Clustering)

Access the data.
"""
data(c::Clustering) = c.X

"""
    constraints(c::Clustering)

Access the contraints.
"""
constraints(c::Clustering) = c.C

"""
    weights(c::Clustering)

Access the weights.
"""
weights(c::Clustering) = c.W

"""
    assignments(c::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(c::PartitionalClustering) = c.Y

"""
    centers(c::PartitionalClustering)

Access the centers.
.
"""
centers(c::PartitionalClustering) = c.μ

"""
    θ(c::PartitionalClustering)

Access the parameters.
"""
θ(c::PartitionalClustering) = (c.μ)
