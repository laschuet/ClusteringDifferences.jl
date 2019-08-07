@testset "clustering" begin
    @testset "partitional clustering" begin
        X = [0 1 1; 1 0 1]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1.0 0.0 0.5; 0.0 1.0 0.5]
        M = [0 1; 1 0]
        a = PartitionalClustering(X, C, W, Y, M)
        b = PartitionalClustering(X, C, W, Y, M)
        c = PartitionalClustering(X, C, W, Y, M)

        @testset "constructors" begin
            @test a.X == X && a.C == C && a.W == W && a.Y == Y && a.M == M
        end

        @testset "equality operator" begin
            @test a == a
            @test a == b && b == a
            @test a == b && b == c && a == c
        end

        @testset "hash" begin
            @test hash(a) == hash(a)
            @test a == b && hash(a) == hash(b)
        end

        @testset "accessors" begin
            @test data(a) == X
            @test constraints(a) == C
            @test weights(a) == W
            @test assignments(a) == Y
            @test centers(a) == M
            @test θ(a) == (M)
        end
    end

    @testset "hierarchical clustering" begin
        X = [1 0 0; 2 2 3]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        a = HierarchicalClustering(X, C, W)

        @testset "constructors" begin
            @test a.X == X && a.C == C && a.W == W
        end

        @testset "accessors" begin
            @test data(a) == X
            @test constraints(a) == C
            @test weights(a) == W
        end
    end
end
