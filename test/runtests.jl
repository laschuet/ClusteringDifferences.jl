using VAIML
using SparseArrays
using Test

@testset "VAIML" begin
    include("utils.jl")
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    #include("pckmeans.jl")
end
