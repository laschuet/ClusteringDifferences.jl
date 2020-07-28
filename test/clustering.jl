@testset "clustering" begin
    @testset "partitional clustering" begin
        r = [10, 20]
        c = [2, 3, 5]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1 0 0.5; 0 1 0.5]
        p = (μ=[0 1; 1 0],)
        pc = PartitionalClustering(r, c, C, W, Y, p)
        pc2 = PartitionalClustering(r, c, C, W, Y, p)
        pc3 = PartitionalClustering(r, c, C, W, Y, p)

        @testset "constructors" begin
            @test isa(pc, PartitionalClustering)
            @test (pc.r == r && pc.c == c && pc.C == C && pc.W == W && pc.Y == Y
                    && pc.p == p)
        end

        @testset "equality operator" begin
            @test pc == pc
            @test pc == pc2 && pc2 == pc
            @test pc == pc2 && pc2 == pc3 && pc == pc3
        end

        @testset "hash" begin
            @test hash(pc) == hash(pc)
            @test pc == pc2 && hash(pc) == hash(pc2)
        end

        @testset "accessors" begin
            @test features(pc) == r
            @test instances(pc) == c
            @test constraints(pc) == C
            @test weights(pc) == W
            @test assignments(pc) == Y
            @test parameters(pc) == θ(pc) == p
        end
    end

    @testset "hierarchical clustering" begin
        r = [10, 20]
        c = [2, 3, 5]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        p = NamedTuple()
        hc = HierarchicalClustering(r, c, C, W, p)

        @testset "constructors" begin
            @test isa(hc, HierarchicalClustering)
            @test hc.r == r && hc.c == c && hc.C == C && hc.W == W && hc.p == p
        end

        @testset "accessors" begin
            @test features(hc) == r
            @test instances(hc) == c
            @test constraints(hc) == C
            @test weights(hc) == W
            @test parameters(hc) == θ(hc) == p
        end
    end
end
