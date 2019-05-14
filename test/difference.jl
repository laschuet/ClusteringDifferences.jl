@testset "difference" begin
    a = PartitionalClustering([1 1; 0 1], [0 1; 1 0], [0 1.0; 1.0 0], [1, 1],
            [0.5, 1])
    b = PartitionalClustering([2 2; 2 2], [0 -1; -1 0], [0 1.0; 1.0 0], [0, 1],
            [2.0, 2])

    @testset "constructors" begin
    end

    @testset "operator" begin
    end

    @testset "forward difference" begin
        @test forward([a, b], 2) == nothing
        @test forward([a, b], 1) == b - a
    end

    @testset "backward difference" begin
        @test backward([a, b], 1) == a
        @test backward([a, b], 2) == b - a
    end
end
