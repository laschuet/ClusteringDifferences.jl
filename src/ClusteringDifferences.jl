module ClusteringDifferences

using DifferencesBase
using Distances

import Base: -, ==
import Base: diff, hash, instances, show

export
    # clustering.jl
    AbstractClustering,
    HierarchicalClustering,
    PartitionalClustering,
    assignments,
    constraints,
    features,
    instances,
    parameters,
    weights,
    # difference.jl
    AbstractClusteringDifference,
    PartitionalClusteringDifference,
    backwarddiff,
    forwarddiff,
    # kmeans.jl
    kmeans
    # pckmeans.jl
    #pckmeans

include("clustering.jl")
include("difference.jl")
include("kmeans.jl")
#include("pckmeans.jl")

end # module
