module VAIML

export
    # clustering.jl
    PartitionalClustering,
    HierarchicalClustering,
    assignments,
    data,
    centers,
    constraints,
    θ,
    weights,
    # difference.jl
    PartitionalClusteringDifference

include("clustering/clustering.jl")
include("difference/difference.jl")

end # module VAIML
