module ClusteringDifferences

using DifferencesBase
using Distances

import Clustering: FuzzyCMeansResult, KmeansResult, KmedoidsResult

export
    # clustering.jl
    AbstractClustering,
    Clustering,
    assignments,
    constraints,
    features,
    parameters,
    weights,
    # difference.jl
    AbstractClusteringDifference,
    ClusteringDifference,
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
