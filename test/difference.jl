@testset "difference" begin
    a = PartitionalClustering([1, 2], [1, 2, 3], [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0], [1 0 0.5; 0 1 0.5], (μ=[0 1; 1 0],))
    b = PartitionalClustering([1, 2], [1, 2, 3], [0 0 -1; 0 0 -1; -1 -1 0],
            [0 0 1; 0 0 1; 1 1 0], [1 0 0; 0 1 0; 0 0 1], (μ=[0 1 1; 1 0 1],))
    E = Vector(undef, 0)
    # a - b
    i = SetDifference([1, 2], Int[], Int[])
    j = SetDifference([1, 2, 3], Int[], Int[])
    C = MatrixDifference(sparse([0 0 1; 0 0 1; 1 1 0]), E, E)
    W = MatrixDifference(sparse([0 0 -1; 0 0 -1; -1 -1 0]), E, E)
    Y = MatrixDifference(sparse([0 0 0.5; 0 0 0.5]), [0, 0, 1], E)
    p = NamedTupleDifference((μ=MatrixDifference(sparse([0 0; 0 0]), [1, 1], E),), NamedTuple(), NamedTuple())
    cd = PartitionalClusteringDifference(i, j, C, W, Y, p)
    cd2 = PartitionalClusteringDifference(i, j, C, W, Y, p)
    cd3 = PartitionalClusteringDifference(i, j, C, W, Y, p)
    # b - a
    i2 = SetDifference([1, 2], Int[], Int[])
    j2 = SetDifference([1, 2, 3], Int[], Int[])
    C2 = MatrixDifference(sparse([0 0 -1; 0 0 -1; -1 -1 0]), E, E)
    W2 = MatrixDifference(sparse([0 0 1; 0 0 1; 1 1 0]), E, E)
    Y2 = MatrixDifference(sparse([0 0 -0.5; 0 0 -0.5]), E, [0, 0, 1])
    p2 = NamedTupleDifference((μ=MatrixDifference(sparse([0 0; 0 0]), E, [1, 1]),), NamedTuple(), NamedTuple())

    @testset "constructors" begin
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.i == i && cd.j == j && cd.C == C && cd.W == W && cd.Y == Y
                && cd.p == p)
    end

    @testset "equality operator" begin
        @test cd == cd
        @test cd == cd2 && cd2 == cd
        @test cd == cd2 && cd2 == cd3 && cd == cd3
    end

    @testset "hash" begin
        @test hash(cd) == hash(cd)
        @test cd == cd2 && hash(cd) == hash(cd2)
    end

    @testset "subtraction operator" begin
        cd = a - a
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.i == SetDifference([1, 2], Int[], Int[])
                && cd.j == SetDifference([1, 2, 3], Int[], Int[])
                && cd.C == MatrixDifference(sparse([0 0 0; 0 0 0; 0 0 0]), E, E)
                && cd.W == MatrixDifference(sparse([0 0 0; 0 0 0; 0 0 0]), E, E)
                && cd.Y == MatrixDifference(sparse([0 0 0; 0 0 0]), E, E)
                && cd.p == NamedTupleDifference((μ=MatrixDifference(sparse([0 0; 0 0]), E, E),), NamedTuple(), NamedTuple()))
        cd = a - b
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.i == i && cd.j == j && cd.C == C && cd.W == W && cd.Y == Y
                && cd.p == p)
        cd = b - a
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.i == i2 && cd.j == j2 && cd.C == C2 && cd.W == W2
                && cd.Y == Y2 && cd.p == p2)
    end

    @testset "forward difference" begin
        cd = forwarddiff([a, b], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.i == i2 && cd.j == j2 && cd.C == C2  && cd.W == W2
                && cd.Y == Y2 && cd.p == p2)
    end

    @testset "backward difference" begin
        cd = backwarddiff([a, b], 2)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.i == i2 && cd.j == j2 && cd.C == C2 && cd.W == W2
                && cd.Y == Y2 && cd.p == p2)
    end
end
