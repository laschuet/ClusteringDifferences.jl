@testset "clustering" begin
    @testset "partitional clustering" begin
        X = [0 1 1; 1 0 1]
        I = [1, 2]
        J = [1, 2, 3]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1.0 0.0 0.5; 0.0 1.0 0.5]
        M = [0 1; 1 0]
        a = PartitionalClustering(X, I, J, C, W, Y, M)
        b = PartitionalClustering(X, I, J, C, W, Y, M)
        c = PartitionalClustering(X, I, J, C, W, Y, M)

        @testset "constructors" begin
            @test (a.X == X && a.I == I && a.J == J && a.C == C && a.W == W
                    && a.Y == Y && a.M == M)
            d = PartitionalClustering(X, C, W, Y, M)
            @test (d.X == X && d.I == I && d.J == J && d.C == C && d.W == W
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
            @test features(a) == I
            @test VAIML.instances(a) == J
            @test weights(a) == W
            @test assignments(a) == Y
            @test centers(a) == M
            @test θ(a) == (M)
        end
    end

    @testset "hierarchical clustering" begin
        X = [1 0 0; 2 2 3]
        I = [1, 2]
        J = [1, 2, 3]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        a = HierarchicalClustering(X, I, J, C, W)

        @testset "constructors" begin
            @test a.X == X && a.I == I && a.J == J && a.C == C && a.W == W
            b = HierarchicalClustering(X, C, W)
            @test b.X == X && b.I == I && b.J == J && b.C == C && b.W == W
        end

        @testset "accessors" begin
            @test data(a) == X
            @test constraints(a) == C
            @test weights(a) == W
        end
    end
end
