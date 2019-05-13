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

include("clustering.jl")
include("difference.jl")

end # module VAIML
