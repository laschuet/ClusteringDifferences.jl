@testset "difference" begin
    a = PartitionalClustering([0 1; 1 0; 1 1], [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0], [1.0 0.0; 0.0 1.0; 0.5 0.5], [0 1; 1 0])
    b = PartitionalClustering([0 1; 1 0; 1 1], [0 0 -1; 0 0 -1; -1 -1 0],
            [0 0 1.0; 0 0 1.0; 1.0 1.0 0],
            [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0], [0 1; 1 0; 1 1])

    @testset "constructors" begin
    end

    @testset "subtraction operator" begin
        c = a - b
        @test (c.X == [0 0; 0 0; 0 0]
                && c.C == [0 0 1; 0 0 1; 1 1 0]
                && c.W == [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]
                && c.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; 0.5 0.5 1.0]
                && c.M == [0 0; 0 0; 1 1]
                && c.k == -1
                && c.Y_MASK == [0 0 -1; 0 0 -1; 2 2 -1]
                && c.M_MASK == [0 0; 0 0; -1 -1])
        c = b - a
        @test (c.X == [0 0; 0 0; 0 0]
                && c.C == [0 0 -1; 0 0 -1; -1 -1 0]
                && c.W == [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
                && c.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]
                && c.M == [0 0; 0 0; 1 1]
                && c.k == 1
                && c.Y_MASK == [0 0 1; 0 0 1; 2 2 1]
                && c.M_MASK == [0 0; 0 0; 1 1])
    end

    @testset "forward difference" begin
        c = forward([a, b], 1)
        @test (c.X == [0 0; 0 0; 0 0]
                && c.C == [0 0 -1; 0 0 -1; -1 -1 0]
                && c.W == [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
                && c.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]
                && c.M == [0 0; 0 0; 1 1]
                && c.k == 1
                && c.Y_MASK == [0 0 1; 0 0 1; 2 2 1]
                && c.M_MASK == [0 0; 0 0; 1 1])
        @test forward([a, b], 2) == nothing
    end

    @testset "backward difference" begin
        c = backward([a, b], 1)
        @test (c.X == a.X
                && c.C == a.C
                && c.W == a.W
                && c.Y == a.Y
                && c.M == a.M
                && c.k == 2
                && c.Y_MASK == [1 1; 1 1; 1 1]
                && c.M_MASK == [1 1; 1 1])
        c = backward([a, b], 2)
        @test (c.X == [0 0; 0 0; 0 0]
                && c.C == [0 0 -1; 0 0 -1; -1 -1 0]
                && c.W == [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
                && c.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]
                && c.M == [0 0; 0 0; 1 1]
                && c.k == 1
                && c.Y_MASK == [0 0 1; 0 0 1; 2 2 1]
                && c.M_MASK == [0 0; 0 0; 1 1])
    end
end
