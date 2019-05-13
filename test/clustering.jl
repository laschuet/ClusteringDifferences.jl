@testset "clustering" begin
    @testset "partitional clustering" begin
        pc = PartitionalClustering([1 1; 0 1], [0 1; 1 0], [0 1.0; 1.0 0],
            [1, 1], [0.5, 1])

        @testset "constructors" begin
            @test(pc.X == [1 1; 0 1]
                && pc.C == [0 1; 1 0]
                && pc.W == [0 1.0; 1.0 0]
                && pc.Y == [1, 1]
                && pc.μ == [0.5, 1])
        end

        @testset "accessors" begin
            @test data(pc) == [1 1; 0 1]
            @test constraints(pc) == [0 1; 1 0]
            @test weights(pc) == [0 1.0; 1.0 0]
            @test assignments(pc) == [1, 1]
            @test centers(pc) == [0.5, 1]
            @test θ(pc) == ([0.5, 1])
        end
    end

    @testset "hierarchical clustering" begin
        hc = HierarchicalClustering([1 2; 0 2], [0 1; 1 0], [0 1.0; 1.0 0])

        @testset "constructors" begin
            @test hc.X == [1 2; 0 2]
            @test hc.C == [0 1; 1 0]
            @test hc.W == [0 1.0; 1.0 0]
        end

        @testset "accessors" begin
            @test data(hc) == [1 2; 0 2]
            @test constraints(hc) == [0 1; 1 0]
            @test weights(hc) == [0 1.0; 1.0 0]
        end
    end
end
