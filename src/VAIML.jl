module VAIML

using Distances
using SparseArrays

import Base: -, ==
import Base: diff, hash, instances, show

export
    # clustering.jl
    AbstractClustering,
    HierarchicalClustering,
    PartitionalClustering,
    assignments,
    centers,
    constraints,
    data,
    features,
    θ,
    weights,
    # difference.jl
    AbstractClusteringDifference,
    PartitionalClusteringDifference,
    backwarddiff,
    forwarddiff,
    # encoding.jl
    AbstractClusteringDifferenceEncoding,
    PartitionalClusteringDifferenceEncoding,
    # kmeans.jl
    kmeans
    # pckmeans.jl
    #pckmeans

include("clustering.jl")
include("difference.jl")
include("encoding.jl")
include("kmeans.jl")
#include("pckmeans.jl")
include("utils.jl")

end # module VAIML
