using ClusteringDifferences
using DifferenceBase
using SparseArrays
using Test

@testset "ClusteringDifferences" begin
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    #include("pckmeans.jl")
end
