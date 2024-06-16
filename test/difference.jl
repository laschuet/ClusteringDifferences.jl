@testset "difference" begin
    c1 = Clustering(
        [1, 2], [1, 2, 3], [0 0 0; 0 0 0; 0 0 0], [0 0 0; 0 0 0; 0 0 0], [1 0 0.5; 0 1 0.5], (μ=[0 1; 1 0],)
    )
    c2 = Clustering(
        [1, 2],
        [1, 2, 3],
        [0 0 -1; 0 0 -1; -1 -1 0],
        [0 0 1; 0 0 1; 1 1 0],
        [1 0 0; 0 1 0; 0 0 1],
        (μ=[0 1 1; 1 0 1],),
    )
    # c1 - c2
    r1 = SetDifference(Set([1, 2]), Set(), Set())
    c1 = SetDifference(Set([1, 2, 3]), Set(), Set())
    C1 = MatrixDifference(sparse([0, 0, 1, 0, 0, 1, 1, 1, 0]), [], [])
    W1 = MatrixDifference(sparse([0, 0, -1, 0, 0, -1, -1, -1, 0]), [], [])
    Y1 = MatrixDifference(sparse([0, 0, 0, 0, 0.5, 0.5]), [0, 0, 1], [])
    p1 = NamedTupleDifference(
        (μ=MatrixDifference(sparse([0, 0, 0, 0]), [1, 1], []),), NamedTuple(), NamedTuple()
    )
    d1 = ClusteringDifference(r, c, C, W, Y, p)
    d2 = ClusteringDifference(r, c, C, W, Y, p)
    d3 = ClusteringDifference(r, c, C, W, Y, p)
    # c2 - c1
    r2 = SetDifference(Set([1, 2]), Set(), Set())
    c2 = SetDifference(Set([1, 2, 3]), Set(), Set())
    C2 = MatrixDifference(sparse([0, 0, -1, 0, 0, -1, -1, -1, 0]), [], [])
    W2 = MatrixDifference(sparse([0, 0, 1, 0, 0, 1, 1, 1, 0]), [], [])
    Y2 = MatrixDifference(sparse([0, 0, 0, 0, -0.5, -0.5]), [], [0, 0, 1])
    p2 = NamedTupleDifference(
        (μ=MatrixDifference(sparse([0, 0, 0, 0]), [], [1, 1]),), NamedTuple(), NamedTuple()
    )

    @testset "constructors" begin
        @test isa(d1, ClusteringDifference)
        @test (d1.r == r && d1.c == c && d1.C == C && d1.W == W && d1.Y == Y && d1.p == p)
    end

    @testset "equality operator" begin
        @test d1 == d1
        @test d1 == d2 && d2 == d1
        @test d1 == d2 && d2 == d3 && d1 == d3
    end

    @testset "hash" begin
        @test hash(d1) == hash(d1)
        @test d1 == d2 && hash(d1) == hash(d2)
    end

    @testset "accessors" begin
        @test axes(d1) == (r, c)
        @test features(d1) == axes(cd, 1) == r
        @test instances(d1) == axes(cd, 2) == c
        @test constraints(d1) == C
        @test weights(d1) == W
        @test assignments(d1) == Y
        @test parameters(d1) == p
    end

    @testset "subtraction operator" begin
        c = Clustering(
            [1, 2],
            [1, 2, 3],
            [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0],
            [1 0 0.5; 0 1 0.5],
            (μ=[0 1; 1 0],),
        )

        d = c - c
        @test isa(d, ClusteringDifference)
        @test (
            d.r == SetDifference(Set([1, 2]), Set(), Set()) &&
            d.c == SetDifference(Set([1, 2, 3]), Set(), Set()) &&
            d.C == MatrixDifference(sparse([0, 0, 0, 0, 0, 0, 0, 0, 0]), [], []) &&
            d.W == MatrixDifference(sparse([0, 0, 0, 0, 0, 0, 0, 0, 0]), [], []) &&
            d.Y == MatrixDifference(sparse([0, 0, 0, 0, 0, 0]), [], []) &&
            d.p == NamedTupleDifference(
                (μ=MatrixDifference(sparse([0, 0, 0, 0]), [], []),), NamedTuple(), NamedTuple()
            )
        )
        d = c - c2
        @test isa(d, ClusteringDifference)
        @test (d.r == r && d.c == c && d.C == C && d.W == W && d.Y == Y && d.p == p)
        d = c2 - c
        @test isa(d, ClusteringDifference)
        @test (d.r == r2 && d.c == c2 && d.C == C2 && d.W == W2 && d.Y == Y2 && d.p == p2)
    end

    @testset "forward difference" begin
        d = forwarddiff([c1, c2], 1)
        @test isa(d, ClusteringDifference)
        @test (d.r == r2 && d.c == c2 && d.C == C2 && d.W == W2 && d.Y == Y2 && d.p == p2)
    end

    @testset "backward difference" begin
        d = backwarddiff([c1, c2], 2)
        @test isa(d, ClusteringDifference)
        @test (d.r == r2 && d.c == c2 && d.C == C2 && d.W == W2 && d.Y == Y2 && d.p == p2)
    end
end
