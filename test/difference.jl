@testset "difference" begin
    a = PartitionalClustering([0 1 1; 1 0 1], [1, 2], [1, 2, 3],
            [0 0 0; 0 0 0; 0 0 0], [0 0 0; 0 0 0; 0 0 0], [1 0 0.5; 0 1 0.5],
            [0 1; 1 0])
    b = PartitionalClustering([0 1 1; 1 0 1], [1, 2], [1, 2, 3],
            [0 0 -1; 0 0 -1; -1 -1 0], [0 0 1; 0 0 1; 1 1 0],
            [1 0 0; 0 1 0; 0 0 1], [0 1 1; 1 0 1])
    E = Vector(undef, 0)
    # a - b
    X = MatrixDifference(sparse([0 0 0; 0 0 0]), E, E)
    i = SetDifference([1, 2], Int[], Int[])
    j = SetDifference([1, 2, 3], Int[], Int[])
    C = MatrixDifference(sparse([0 0 1; 0 0 1; 1 1 0]), E, E)
    W = MatrixDifference(sparse([0 0 -1; 0 0 -1; -1 -1 0]), E, E)
    Y = MatrixDifference(sparse([0 0 0.5; 0 0 0.5]), [0, 0, 1], E)
    M = MatrixDifference(sparse([0 0; 0 0]), [1, 1], E)
    k = -1
    cd = PartitionalClusteringDifference(X, i, j, C, W, Y, M, k)
    cd2 = PartitionalClusteringDifference(X, i, j, C, W, Y, M, k)
    cd3 = PartitionalClusteringDifference(X, i, j, C, W, Y, M, k)
    # b - a
    X2 = MatrixDifference(sparse([0 0 0; 0 0 0]), E, E)
    i2 = SetDifference([1, 2], Int[], Int[])
    j2 = SetDifference([1, 2, 3], Int[], Int[])
    C2 = MatrixDifference(sparse([0 0 -1; 0 0 -1; -1 -1 0]), E, E)
    W2 = MatrixDifference(sparse([0 0 1; 0 0 1; 1 1 0]), E, E)
    Y2 = MatrixDifference(sparse([0 0 -0.5; 0 0 -0.5]), E, [0, 0, 1])
    M2 = MatrixDifference(sparse([0 0; 0 0]), E, [1, 1])
    k2 = 1

    @testset "constructors" begin
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X && cd.i == i && cd.j == j && cd.C == C && cd.W == W
                && cd.Y == Y && cd.M == M && cd.k == k)
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
        @test (cd.X == MatrixDifference(sparse([0 0 0; 0 0 0]), E, E)
                && cd.i == SetDifference([1, 2], Int[], Int[])
                && cd.j == SetDifference([1, 2, 3], Int[], Int[])
                && cd.C == MatrixDifference(sparse([0 0 0; 0 0 0; 0 0 0]), E, E)
                && cd.W == MatrixDifference(sparse([0 0 0; 0 0 0; 0 0 0]), E, E)
                && cd.Y == MatrixDifference(sparse([0 0 0; 0 0 0]), E, E)
                && cd.M == MatrixDifference(sparse([0 0; 0 0]), E, E)
                && cd.k == 0)
        cd = a - b
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X && cd.i == i && cd.j == j && cd.C == C && cd.W == W
                && cd.Y == Y && cd.M == M && cd.k == k)
        cd = b - a
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.i == i2 && cd.j == j2 && cd.C == C2
                && cd.W == W2 && cd.Y == Y2 && cd.M == M2 && cd.k == k2)
    end

    @testset "forward difference" begin
        cd = forwarddiff([a, b], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.i == i2 && cd.j == j2 && cd.C == C2
                && cd.W == W2 && cd.Y == Y2 && cd.M == M2 && cd.k == k2)
    end

    @testset "backward difference" begin
        cd = backwarddiff([a, b], 2)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.i == i2 && cd.j == j2 && cd.C == C2
                && cd.W == W2 && cd.Y == Y2 && cd.M == M2 && cd.k == k2)
    end
end
