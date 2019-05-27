@testset "difference" begin
    a = PartitionalClustering([1 1; 0 1], [0 1; 1 0], [0 1.0; 1.0 0],
            [1.0 0.0; 0.5 0.5], [0.5 1])
    b = PartitionalClustering([2 2; 2 2], [0 -1; -1 0], [0 1.0; 1.0 0],
            [0.0 1.0; 0.5 0.5], [2.0 2])

    @testset "constructors" begin
    end

    @testset "operator" begin
        c = b - a
        @test (c.X == [1 1; 2 1] && c.C == [0 -2; -2 0] && c.W == [0 0; 0 0]
                && c.Y == [-1.0 1.0; 0.0 0.0] && c.M == [1.5 1])
    end

    @testset "forward difference" begin
        @test forward([a, b], 2) == nothing
        c = forward([a, b], 1)
        @test (c.X == [1 1; 2 1] && c.C == [0 -2; -2 0] && c.W == [0 0; 0 0]
                && c.Y == [-1.0 1.0; 0.0 0.0] && c.M == [1.5 1])
    end

    @testset "backward difference" begin
        c = backward([a, b], 1)
        @test c.X == a.X && c.C == a.C && c.W == a.W && c.Y == a.Y && c.M == a.M
        c = backward([a, b], 2)
        @test (c.X == [1 1; 2 1] && c.C == [0 -2; -2 0] && c.W == [0 0; 0 0]
                && c.Y == [-1.0 1.0; 0.0 0.0] && c.M == [1.5 1])
    end
end
