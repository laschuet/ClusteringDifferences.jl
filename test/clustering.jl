@testset "clustering" begin
    @testset "partitional clustering" begin
        r = [10, 20]
        c = [2, 3, 5]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1 0 0.5; 0 1 0.5]
        p = (μ=[0 1.0; 1.0 0],)
        pc = PartitionalClustering(r, c, C, W, Y, p)
        pc2 = PartitionalClustering(r, c, C, W, Y, p)
        pc3 = PartitionalClustering(r, c, C, W, Y, p)

        @testset "constructors" begin
            @test isa(pc, PartitionalClustering)
            @test (pc.r == r && pc.c == c && pc.C == C && pc.W == W && pc.Y == Y
                    && pc.p == p)
        end

        @testset "interface constructors" begin
            pc4 = PartitionalClustering(KmeansResult(p.μ, [1, 2, 1],
                    [0.5, 0.25, 0.125], [2, 1], [2, 1], 0.875, 100, true))
            @test isa(pc4, PartitionalClustering)
            @test (pc4.r == Int[] && pc4.c == Int[]
                    && pc4.C == Matrix{Int}(undef, 0, 0)
                    && pc4.W == Matrix{Float64}(undef, 0, 0)
                    && pc4.Y == [1 0 1; 0 1 0]
                    && pc4.p == (centers=p.μ, costs=[0.5, 0.25, 0.125],
                            counts=[2, 1], wcounts=[2, 1], totalcost=0.875,
                            iterations=100, converged=true))
            pc4 = PartitionalClustering(KmedoidsResult([11, 23], [1, 2, 1],
                    [0.5, 0.25, 0.125], [2, 1], 0.875, 100, true))
            @test isa(pc4, PartitionalClustering)
            @test (pc4.r == Int[] && pc4.c == Int[]
                    && pc4.C == Matrix{Int}(undef, 0, 0)
                    && pc4.W == Matrix{Float64}(undef, 0, 0)
                    && pc4.Y == [1 0 1; 0 1 0]
                    && pc4.p == (medoids=[11, 23], costs=[0.5, 0.25, 0.125],
                            counts=[2, 1], totalcost=0.875, iterations=100,
                            converged=true))
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
            @test axes(pc) == (r, c)
            @test features(pc) == axes(pc, 1) == r
            @test instances(pc) == axes(pc, 2) == c
            @test constraints(pc) == C
            @test weights(pc) == W
            @test parameters(pc) == p
            @test assignments(pc) == Y
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
            @test axes(hc) == (r, c)
            @test features(hc) == axes(hc, 1) == r
            @test instances(hc) == axes(hc, 2) == c
            @test constraints(hc) == C
            @test weights(hc) == W
            @test parameters(hc) == p
        end
    end
end
