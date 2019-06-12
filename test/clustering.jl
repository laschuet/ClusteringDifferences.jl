@testset "clustering" begin
    @testset "partitional clustering" begin
        pc = PartitionalClustering([0 1; 1 0; 1 1], [0 0 0; 0 0 0; 0 0 0],
                [0 0 0; 0 0 0; 0 0 0], [1.0 0.0; 0.0 1.0; 0.5 0.5], [0 1; 1 0])

        @testset "constructors" begin
            @test(pc.X == [0 1; 1 0; 1 1]
                && pc.C == [0 0 0; 0 0 0; 0 0 0]
                && pc.W == [0 0 0; 0 0 0; 0 0 0]
                && pc.Y == [1.0 0.0; 0.0 1.0; 0.5 0.5]
                && pc.M == [0 1; 1 0])
        end

        @testset "==" begin
            @test pc == pc
            pc2 = PartitionalClustering([0 1; 1 0; 1 1], [0 0 0; 0 0 0; 0 0 0],
                    [0 0 0; 0 0 0; 0 0 0], [1.0 0.0; 0.0 1.0; 0.5 0.5],
                    [0 1; 1 0])
            @test pc == pc2 && pc2 == pc
            pc3 = PartitionalClustering([0 1; 1 0; 1 1], [0 0 0; 0 0 0; 0 0 0],
                    [0 0 0; 0 0 0; 0 0 0], [1.0 0.0; 0.0 1.0; 0.5 0.5],
                    [0 1; 1 0])
            @test pc == pc2 && pc2 == pc3 && pc == pc3
        end

        @testset "hash" begin
            @test hash(pc) == hash(pc)
            pc2 = PartitionalClustering([0 1; 1 0; 1 1], [0 0 0; 0 0 0; 0 0 0],
                    [0 0 0; 0 0 0; 0 0 0], [1.0 0.0; 0.0 1.0; 0.5 0.5],
                    [0 1; 1 0])
            @test pc == pc2 && hash(pc) == hash(pc2)
        end

        @testset "accessors" begin
            @test data(pc) == [0 1; 1 0; 1 1]
            @test constraints(pc) == [0 0 0; 0 0 0; 0 0 0]
            @test weights(pc) == [0 0 0; 0 0 0; 0 0 0]
            @test assignments(pc) == [1.0 0.0; 0.0 1.0; 0.5 0.5]
            @test centers(pc) == [0 1; 1 0]
            @test θ(pc) == ([0 1; 1 0])
        end
    end

    @testset "hierarchical clustering" begin
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        hc = HierarchicalClustering([1 2; 0 2; 0 3], C, W)

        @testset "constructors" begin
            @test hc.X == [1 2; 0 2; 0 3]
            @test hc.C == C
            @test hc.W == W
        end

        @testset "accessors" begin
            @test data(hc) == [1 2; 0 2; 0 3]
            @test constraints(hc) == C
            @test weights(hc) == W
        end
    end
end
