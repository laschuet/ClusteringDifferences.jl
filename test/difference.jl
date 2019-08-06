@testset "difference" begin
    c = PartitionalClustering([0 1 1; 1 0 1], [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0], [1.0 0.0 0.5; 0.0 1.0 0.5], [0 1; 1 0])
    c2 = PartitionalClustering([0 1 1; 1 0 1], [0 0 -1; 0 0 -1; -1 -1 0],
            [0 0 1.0; 0 0 1.0; 1.0 1.0 0],
            [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0], [0 1 1; 1 0 1])
    # c - c2
    X = [0 0 0; 0 0 0]
    C = [0 0 1; 0 0 1; 1 1 0]
    W = [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]
    Y = [0.0 0.0 0.5; 0.0 0.0 0.5; 0.0 0.0 1.0]
    M = [0 0 1; 0 0 1]
    m = 0
    n = 0
    k = -1
    # c2 - c
    X2 = [0 0 0; 0 0 0]
    C2 = [0 0 -1; 0 0 -1; -1 -1 0]
    W2 = [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
    Y2 = [0.0 0.0 -0.5; 0.0 0.0 -0.5; 0.0 0.0 1.0]
    M2 = [0 0 1; 0 0 1]
    m2 = 0
    n2 = 0
    k2 = 1

    @testset "constructors" begin
        cd = PartitionalClusteringDifference(X, C, W, Y, M, m, n, k)
        @test (cd.X == X && cd.C == C && cd.W == W && cd.Y == Y && cd.M == M
                && cd.m == m && cd.n == n && cd.k == k)
    end

    @testset "subtraction operator" begin
        cd = c - c
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == [0 0 0; 0 0 0] && cd.C == [0 0 0; 0 0 0; 0 0 0]
                && cd.W == [0 0 0; 0 0 0; 0 0 0]
                && cd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0] && cd.M == [0 0; 0 0]
                && cd.m == 0 && cd.n == 0 && cd.k == 0)
        cd = c - c2
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X && cd.C == C && cd.W == W && cd.Y == Y && cd.M == M
                && cd.m == m && cd.n == n && cd.k == k)
        cd = c2 - c
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.m == m2 && cd.n == n2 && cd.k == k2)
    end

    @testset "forward difference" begin
        cd = forwarddiff([c, c2], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.m == m2 && cd.n == n2 && cd.k == k2)
        cd = forwarddiff([c, c2], 2)
        @test isnothing(cd)
    end

    @testset "backward difference" begin
        cd = backwarddiff([c, c2], 1)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == c.X && cd.C == c.C && cd.W == c.W && cd.Y == c.Y
                && cd.M == c.M && cd.m == size(c.X, 1) && cd.n == size(c.X, 2)
                && cd.k == size(c.M, 2))
        cd = backwarddiff([c, c2], 2)
        @test isa(cd, PartitionalClusteringDifference)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.m == m2 && cd.n == n2 && cd.k == k2)
    end
end
