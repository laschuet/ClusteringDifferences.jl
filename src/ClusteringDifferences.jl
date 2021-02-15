module ClusteringDifferences

using DifferencesBase
using Distances

import Clustering: KmeansResult, KmedoidsResult

export
    # clustering.jl
    AbstractClustering,
    HierarchicalClustering,
    PartitionalClustering,
    assignments,
    constraints,
    features,
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
