using VAIML
using Test

@testset "VAIML" begin
    include("clustering.jl")
    include("difference.jl")
    include("utils.jl")
end
