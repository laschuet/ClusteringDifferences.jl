abstract type Clustering end

"""
    PartitionalClustering

Partitional clustering model.
"""
struct PartitionalClustering <: Clustering
    X::Matrix{Any}
    C::Matrix{Int}
    W::Matrix{Float64}
    Y::Vector{Int}
    μ::Vector{Any}
end

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
