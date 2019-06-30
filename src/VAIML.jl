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
    backward, ∇,
    differences,
    forward, Δ,
    # encoding.jl
    PartitionalClusteringDifferenceEncoding,
    # kmeans.jl
    kmeans,
    # pckmeans.jl
    pckmeans

include("clustering.jl")
include("difference.jl")
include("encoding.jl")
include("kmeans.jl")
include("pckmeans.jl")
include("utils.jl")

end # module VAIML
