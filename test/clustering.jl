@testset "clustering" begin
    @testset "partitional clustering" begin
        X = [0 1; 1 0; 1 1]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1.0 0.0; 0.0 1.0; 0.5 0.5]
        M = [0 1; 1 0]
        pc = PartitionalClustering(X, C, W, Y, M)

        @testset "constructors" begin
            @test(pc.X == X && pc.C == C && pc.W == W && pc.Y == Y && pc.M == M)
        end

        @testset "==" begin
            @test pc == pc
            pc2 = PartitionalClustering(X, C, W, Y, M)
            @test pc == pc2 && pc2 == pc
            pc3 = PartitionalClustering(X, C, W, Y, M)
            @test pc == pc2 && pc2 == pc3 && pc == pc3
        end

        @testset "hash" begin
            @test hash(pc) == hash(pc)
            pc2 = PartitionalClustering(X, C, W, Y, M)
            @test pc == pc2 && hash(pc) == hash(pc2)
        end

        @testset "accessors" begin
            @test data(pc) == X
            @test constraints(pc) == C
            @test weights(pc) == W
            @test assignments(pc) == Y
            @test centers(pc) == M
            @test θ(pc) == (M)
        end
    end

    @testset "hierarchical clustering" begin
        X = [1 2; 0 2; 0 3]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        hc = HierarchicalClustering(X, C, W)

        @testset "constructors" begin
            @test hc.X == X
            @test hc.C == C
            @test hc.W == W
        end

        @testset "accessors" begin
            @test data(hc) == X
            @test constraints(hc) == C
            @test weights(hc) == W
        end
    end
end
