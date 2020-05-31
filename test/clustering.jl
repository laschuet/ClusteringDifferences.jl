@testset "clustering" begin
    @testset "partitional clustering" begin
        i = [10, 20]
        j = [2, 3, 5]
        C = [0 0 0; 0 0 0; 0 0 0]
        W = [0 0 0; 0 0 0; 0 0 0]
        Y = [1 0 0.5; 0 1 0.5]
        p = (μ=[0 1; 1 0],)
        a = PartitionalClustering(i, j, C, W, Y, p)
        b = PartitionalClustering(i, j, C, W, Y, p)
        c = PartitionalClustering(i, j, C, W, Y, p)

        @testset "constructors" begin
            @test isa(a, PartitionalClustering)
            @test (a.i == i && a.j == j && a.C == C && a.W == W && a.Y == Y
                    && a.p == p)
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
            @test constraints(a) == C
            @test features(a) == i
            @test instances(a) == j
            @test weights(a) == W
            @test assignments(a) == Y
            @test parameters(a) == θ(a) == p
        end
    end

    @testset "hierarchical clustering" begin
        i = [10, 20]
        j = [2, 3, 5]
        C = rand([-1, 0, 1], 3, 3, 3)
        W = rand(3, 3, 3) .+ 1
        a = HierarchicalClustering(i, j, C, W)

        @testset "constructors" begin
            @test isa(a, HierarchicalClustering)
            @test a.i == i && a.j == j && a.C == C && a.W == W
        end

        @testset "accessors" begin
            @test constraints(a) == C
            @test weights(a) == W
        end
    end
end
