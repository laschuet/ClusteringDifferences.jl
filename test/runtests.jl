using ClusteringDifferences
using DifferencesBase
using SparseArrays
using Test

import Clustering: KmeansResult, KmedoidsResult

@testset "ClusteringDifferences" begin
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    #include("pckmeans.jl")
end
