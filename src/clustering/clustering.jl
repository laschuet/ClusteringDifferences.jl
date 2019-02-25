abstract type Clustering end

data(c::Clustering) = c.X
constraints(c::Clustering) = c.C
weights(c::Clustering) = c.W

struct PartitionalClustering <: Clustering
    X::Array{Any, 2}
    C::Array{Int, 2}
    W::Array{Float64, 2}
    Y::Array{Int, 1}
    μ::Array{Any, 1}
end

assignments(c::PartitionalClustering) = c.Y
centers(c::PartitionalClustering) = c.μ
θ(c::PartitionalClustering) = (c.μ)

struct HierarchicalClustering <: Clustering
    X::Array{Any, 2}
    C::Array{Int, 3}
    W::Array{Float64, 2}
end
