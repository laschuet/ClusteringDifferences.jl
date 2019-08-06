@testset "clustering" begin
    @testset "partitional clustering" begin
        X = [0 1 1; 1 0 1]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1.0 0.0 0.5; 0.0 1.0 0.5]
        M = [0 1; 1 0]
        c = PartitionalClustering(X, C, W, Y, M)

        @testset "constructors" begin
            @test(c.X == X && c.C == C && c.W == W && c.Y == Y && c.M == M)
        end

        @testset "equality operator" begin
            @test c == c
            c2 = PartitionalClustering(X, C, W, Y, M)
            @test c == c2 && c2 == c
            c3 = PartitionalClustering(X, C, W, Y, M)
            @test c == c2 && c2 == c3 && c == c3
        end

        @testset "hash" begin
            @test hash(c) == hash(c)
            c2 = PartitionalClustering(X, C, W, Y, M)
            @test c == c2 && hash(c) == hash(c2)
        end

        @testset "accessors" begin
            @test data(c) == X
            @test constraints(c) == C
            @test weights(c) == W
            @test assignments(c) == Y
            @test centers(c) == M
            @test θ(c) == (M)
        end
    end

    @testset "hierarchical clustering" begin
        X = [1 0 0; 2 2 3]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        c = HierarchicalClustering(X, C, W)

        @testset "constructors" begin
            @test (c.X == X && c.C == C && c.W == W)
        end

        @testset "accessors" begin
            @test data(c) == X
            @test constraints(c) == C
            @test weights(c) == W
        end
    end
end
