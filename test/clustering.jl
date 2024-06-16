@testset "clustering" begin
    r = [10, 20]
    c = [2, 3, 5]
    C = [0 0 0; 0 0 0; 0 0 0]
    W = [0 0 0; 0 0 0; 0 0 0]
    Y = [1 0 0.5; 0 1 0.5]
    p = (μ=[0 1.0; 1.0 0],)
    c1 = Clustering(r, c, C, W, Y, p)
    c2 = Clustering(r, c, C, W, Y, p)
    c3 = Clustering(r, c, C, W, Y, p)

    @testset "constructors" begin
        @test isa(c1, Clustering)
        @test (c1.r == r && c1.c == c && c1.C == C && c1.W == W && c1.Y == Y && c1.p == p)
    end

    @testset "interface constructors" begin
        c4 = Clustering(
            KmeansResult(p.μ, [1, 2, 1], [0.5, 0.25, 0.125], [2, 1], [2, 1], 0.875, 100, true)
        )
        @test isa(c4, Clustering)
        @test (
            c4.r == Int[] &&
            c4.c == Int[] &&
            c4.C == Matrix{Int}(undef, 0, 0) &&
            c4.W == Matrix{Float64}(undef, 0, 0) &&
            c4.Y == [1 0 1; 0 1 0] &&
            c4.p == (
                centers=p.μ,
                costs=[0.5, 0.25, 0.125],
                counts=[2, 1],
                wcounts=[2, 1],
                totalcost=0.875,
                iterations=100,
                converged=true,
            )
        )
        c4 = Clustering(
            KmedoidsResult([11, 23], [1, 2, 1], [0.5, 0.25, 0.125], [2, 1], 0.875, 100, true)
        )
        @test isa(c4, Clustering)
        @test (
            c4.r == Int[] &&
            c4.c == Int[] &&
            c4.C == Matrix{Int}(undef, 0, 0) &&
            c4.W == Matrix{Float64}(undef, 0, 0) &&
            c4.Y == [1 0 1; 0 1 0] &&
            c4.p == (
                medoids=[11, 23],
                costs=[0.5, 0.25, 0.125],
                counts=[2, 1],
                totalcost=0.875,
                iterations=100,
                converged=true,
            )
        )
        c4 = Clustering(FuzzyCMeansResult(p.μ, [1 0; 0.5 0.5; 1 0], 100, true))
        @test isa(c4, Clustering)
        @test (
            c4.r == Int[] &&
            c4.c == Int[] &&
            c4.C == Matrix{Int}(undef, 0, 0) &&
            c4.W == Matrix{Float64}(undef, 0, 0) &&
            c4.Y == [1 0.5 1; 0 0.5 0] &&
            c4.p == (centers=p.μ, iterations=100, converged=true)
        )
    end

    @testset "equality operator" begin
        @test c1 == c1
        @test c1 == c2 && c2 == c1
        @test c1 == c2 && c2 == c3 && c1 == c3
    end

    @testset "hash" begin
        @test hash(c1) == hash(c1)
        @test c1 == c2 && hash(c1) == hash(c2)
    end

    @testset "accessors" begin
        @test axes(c1) == (r, c)
        @test features(c1) == axes(c1, 1) == r
        @test instances(c1) == axes(c1, 2) == c
        @test constraints(c1) == C
        @test weights(c1) == W
        @test parameters(c1) == p
        @test assignments(c1) == Y
    end
end
