using ClusteringDifference
using SparseArrays
using Test

@testset "ClusteringDifference" begin
    include("utils.jl")
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    #include("pckmeans.jl")
end
