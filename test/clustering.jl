@testset "clustering" begin
    @testset "partitional clustering" begin
        X = [0 1 1; 1 0 1]
        i = [1, 2]
        j = [1, 2, 3]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1.0 0.0 0.5; 0.0 1.0 0.5]
        M = [0 1; 1 0]
        a = PartitionalClustering(X, i, j, C, W, Y, M)
        b = PartitionalClustering(X, i, j, C, W, Y, M)
        c = PartitionalClustering(X, i, j, C, W, Y, M)

        @testset "constructors" begin
            @test (a.X == X && a.i == i && a.j == j && a.C == C && a.W == W
                    && a.Y == Y && a.M == M)
            d = PartitionalClustering(X, C, W, Y, M)
            @test (d.X == X && d.i == i && d.j == j && d.C == C && d.W == W
                    && d.Y == Y && d.M == M)
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
            @test features(a) == i
            @test instances(a) == j
            @test weights(a) == W
            @test assignments(a) == Y
            @test centers(a) == M
            @test θ(a) == (M)
        end
    end

    @testset "hierarchical clustering" begin
        X = [1 0 0; 2 2 3]
        i = [1, 2]
        j = [1, 2, 3]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        a = HierarchicalClustering(X, i, j, C, W)

        @testset "constructors" begin
            @test a.X == X && a.i == i && a.j == j && a.C == C && a.W == W
            b = HierarchicalClustering(X, C, W)
            @test b.X == X && b.i == i && b.j == j && b.C == C && b.W == W
        end

        @testset "accessors" begin
            @test data(a) == X
            @test constraints(a) == C
            @test weights(a) == W
        end
    end
end
