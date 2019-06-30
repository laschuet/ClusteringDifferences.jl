module VAIML

using Distances

export
    # clustering.jl
    HierarchicalClustering,
    PartitionalClustering,
    assignments,
    centers,
    constraints,
    data,
    θ,
    weights,
    # difference.jl
    PartitionalClusteringDifference,
    backward, ∇, backwards,
    forward, Δ, forwards,
    # kmeans.jl
    kmeans,
    # pckmeans.jl
    pckmeans

include("clustering.jl")
include("difference.jl")
include("kmeans.jl")
include("pckmeans.jl")
include("utils.jl")

end # module VAIML
