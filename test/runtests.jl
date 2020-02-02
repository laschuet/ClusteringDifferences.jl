using ClusteringDifference
using DifferenceBase
using SparseArrays
using Test

@testset "ClusteringDifference" begin
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    #include("pckmeans.jl")
end
