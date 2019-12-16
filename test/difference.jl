@testset "difference" begin
    a = PartitionalClustering([0 1 1; 1 0 1], IdDict(1 => 1, 2 => 2),
            IdDict(1 => 1, 2 => 2, 3 => 3), [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0], [1.0 0.0 0.5; 0.0 1.0 0.5], [0 1; 1 0])
    b = PartitionalClustering([0 1 1; 1 0 1], IdDict(1 => 1, 2 => 2),
            IdDict(1 => 1, 2 => 2, 3 => 3), [0 0 -1; 0 0 -1; -1 -1 0],
            [0 0 1.0; 0 0 1.0; 1.0 1.0 0],
            [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0], [0 1 1; 1 0 1])
    # a - b
    X = MatrixDifference(sparse([0 0 0; 0 0 0]), view([], :), view([], :), view([], :), view([], :))
    i = Int[], Int[], Int[]
    j = Int[], Int[], Int[]
    C = MatrixDifference(sparse([0 0 1; 0 0 1; 1 1 0]), view([], :), view([], :), view([], :), view([], :))
    W = MatrixDifference(sparse([0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]), view([], :), view([], :), view([], :), view([], :))
    Y = MatrixDifference(sparse([0.0 0.0 0.5; 0.0 0.0 0.5; 0.0 0.0 1.0]), view([], :), view([], :), view([], :), view([], :))
    M = MatrixDifference(sparse([0 0 1; 0 0 1]), view([], :), view([], :), view([], :), view([], :))
    m = 0
    n = 0
    k = -1
    cd = PartitionalClusteringDifference(X, i, j, C, W, Y, M, m, n, k)
    cd2 = PartitionalClusteringDifference(X, i, j, C, W, Y, M, m, n, k)
    cd3 = PartitionalClusteringDifference(X, i, j, C, W, Y, M, m, n, k)
    # b - a
    X2 = [0 0 0; 0 0 0]
    i2 = Int[], Int[], Int[]
    j2 = [Int], Int[], Int[]
    C2 = [0 0 -1; 0 0 -1; -1 -1 0]
    W2 = [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
    Y2 = [0.0 0.0 -0.5; 0.0 0.0 -0.5; 0.0 0.0 1.0]
    M2 = [0 0 1; 0 0 1]
    m2 = 0
    n2 = 0
    k2 = 1

    @testset "constructors" begin
        @test (cd.X == X && cd.i == i && cd.j == j && cd.C == C && cd.W == W
                && cd.Y == Y && cd.M == M && cd.m == m && cd.n == n
                && cd.k == k)
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
        @test (cd.X == sparse([0 0 0; 0 0 0]) && cd.i == [] && cd.j == []
                && cd.C == sparse([0 0 0; 0 0 0; 0 0 0])
                && cd.W == sparse([0 0 0; 0 0 0; 0 0 0])
                && cd.Y == sparse([0.0 0.0 0.0; 0.0 0.0 0.0])
                && cd.M == sparse([0 0; 0 0])
                && cd.m == 0 && cd.n == 0 && cd.k == 0)
        cd = a - b
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X && cd.i == i && cd.j == j && cd.C == C && cd.W == W
                && cd.Y == Y && cd.M == M && cd.m == m && cd.n == n
                && cd.k == k)
        cd = b - a
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.i == i2 && cd.j == j2 && cd.C == C2
                && cd.W == W2 && cd.Y == Y2 && cd.M == M2 && cd.m == m2
                && cd.n == n2 && cd.k == k2)
    end

    @testset "forward difference" begin
        cd = forwarddiff([a, b], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.i == i2 && cd.j == j2 && cd.C == C2
                && cd.W == W2 && cd.Y == Y2 && cd.M == M2 && cd.m == m2
                && cd.n == n2 && cd.k == k2)
    end

    @testset "backward difference" begin
        cd = backwarddiff([a, b], 2)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.i == i2 && cd.j == j2 && cd.C == C2
                && cd.W == W2 && cd.Y == Y2 && cd.M == M2 && cd.m == m2
                && cd.n == n2 && cd.k == k2)
    end
end
