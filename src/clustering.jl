abstract type Clustering end

data(c::Clustering) = c.X
constraints(c::Clustering) = c.C
weights(c::Clustering) = c.W

"""
    PartitionalClustering

Partitional clustering model.
"""
struct PartitionalClustering <: Clustering
    X::Matrix{Any}
    C::Vector{Int}
    W::Matrix{Float64}
    Y::Vector{Int}
    μ::Vector{Any}
end

assignments(c::PartitionalClustering) = c.Y
centers(c::PartitionalClustering) = c.μ
θ(c::PartitionalClustering) = (c.μ)

"""
    HierarchicalClustering

Hierarchical clustering model.
"""
struct HierarchicalClustering <: Clustering
    X::Matrix{Any}
    C::Array{Int, 3}
    W::Matrix{Float64}
end
