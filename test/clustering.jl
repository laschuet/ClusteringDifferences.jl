using VAIML
using Test

@testset "Clustering" begin
    c = PartitionalClustering([1 "a"; 0 "a"], [0 1; 1 0], [0 1.0; 1.0 0],
            [1, 1], [0.5, "a"])
    @test data(c) == [1 "a"; 0 "a"]
    @test constraints(c) == [0 1; 1 0]
    @test weights(c) == [0 1.0; 1.0 0]
    @test assignments(c) == [1, 1]
    @test centers(c) == [0.5, "a"]
    @test θ(c) == ([0.5, "a"])

    c = HierarchicalClustering([1 "a"; 0 "a"], [0 1; 1 0], [0 1.0; 1.0 0])
    @test data(c) == [1 "a"; 0 "a"]
    @test constraints(c) == [0 1; 1 0]
    @test weights(c) == [0 1.0; 1.0 0]
end
