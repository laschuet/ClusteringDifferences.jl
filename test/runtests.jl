using VAIML
using SparseArrays
using Test

@testset "VAIML" begin
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    #include("pckmeans.jl")
    include("utils.jl")
end
