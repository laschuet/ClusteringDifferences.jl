@testset "difference" begin
    a = PartitionalClustering([0 1 1; 1 0 1], [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0], [1.0 0.0 0.5; 0.0 1.0 0.5], [0 1; 1 0])
    b = PartitionalClustering([0 1 1; 1 0 1], [0 0 -1; 0 0 -1; -1 -1 0],
            [0 0 1.0; 0 0 1.0; 1.0 1.0 0],
            [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0], [0 1 1; 1 0 1])
    # a - b
    X = [0 0 0; 0 0 0]
    C = [0 0 1; 0 0 1; 1 1 0]
    W = [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]
    Y = [0.0 0.0 0.5; 0.0 0.0 0.5; 0.0 0.0 1.0]
    M = [0 0 1; 0 0 1]
    m = 0
    n = 0
    k = -1
    cd = PartitionalClusteringDifference(X, C, W, Y, M, m, n, k)
    cd2 = PartitionalClusteringDifference(X, C, W, Y, M, m, n, k)
    cd3 = PartitionalClusteringDifference(X, C, W, Y, M, m, n, k)
    # b - a
    X2 = [0 0 0; 0 0 0]
    C2 = [0 0 -1; 0 0 -1; -1 -1 0]
    W2 = [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
    Y2 = [0.0 0.0 -0.5; 0.0 0.0 -0.5; 0.0 0.0 1.0]
    M2 = [0 0 1; 0 0 1]
    m2 = 0
    n2 = 0
    k2 = 1

    @testset "constructors" begin
        @test (cd.X == X && cd.C == C && cd.W == W && cd.Y == Y && cd.M == M
                && cd.m == m && cd.n == n && cd.k == k)
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
        @test (cd.X == [0 0 0; 0 0 0] && cd.C == [0 0 0; 0 0 0; 0 0 0]
                && cd.W == [0 0 0; 0 0 0; 0 0 0]
                && cd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0] && cd.M == [0 0; 0 0]
                && cd.m == 0 && cd.n == 0 && cd.k == 0)
        cd = a - b
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X && cd.C == C && cd.W == W && cd.Y == Y && cd.M == M
                && cd.m == m && cd.n == n && cd.k == k)
        cd = b - a
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.m == m2 && cd.n == n2 && cd.k == k2)
    end

    @testset "forward difference" begin
        cd = forwarddiff([a, b], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.m == m2 && cd.n == n2 && cd.k == k2)
        @test isnothing(forwarddiff([a, b], 2))
    end

    @testset "backward difference" begin
        cd = backwarddiff([a, b], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == a.X && cd.C == a.C && cd.W == a.W && cd.Y == a.Y
                && cd.M == a.M && cd.m == size(a.X, 1) && cd.n == size(a.X, 2)
                && cd.k == size(a.M, 2))
        cd = backwarddiff([a, b], 2)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.m == m2 && cd.n == n2 && cd.k == k2)
    end
end
