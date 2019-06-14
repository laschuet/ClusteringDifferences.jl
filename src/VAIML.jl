module VAIML

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
    forward, Δ

include("clustering.jl")
include("difference.jl")
include("utils.jl")

end # module VAIML
