using VAIML
using Test

@testset "VAIML" begin
    include("clustering.jl")
    include("difference.jl")
    include("kmeans.jl")
    include("utils.jl")
end
