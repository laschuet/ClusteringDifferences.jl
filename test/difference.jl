@testset "difference" begin
    c = PartitionalClustering([0 1; 1 0; 1 1]', [0 0 0; 0 0 0; 0 0 0]',
            [0 0 0; 0 0 0; 0 0 0]', [1.0 0.0; 0.0 1.0; 0.5 0.5]', [0 1; 1 0]')
    c2 = PartitionalClustering([0 1; 1 0; 1 1]', [0 0 -1; 0 0 -1; -1 -1 0]',
            [0 0 1.0; 0 0 1.0; 1.0 1.0 0]',
            [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]', [0 1; 1 0; 1 1]')
    # a - b
    X = [0 0; 0 0; 0 0]'
    C = [0 0 1; 0 0 1; 1 1 0]'
    W = [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]'
    Y = [0.0 0.0 0.0; 0.0 0.0 0.0; 0.5 0.5 1.0]'
    M = [0 0; 0 0; 1 1]'
    k = -1
    Y_MASK = [0 0 -1; 0 0 -1; 2 2 -1]'
    M_MASK = [0 0; 0 0; -1 -1]'
    # b - a
    X2 = [0 0; 0 0; 0 0]'
    C2 = [0 0 -1; 0 0 -1; -1 -1 0]'
    W2 = [0 0 1.0; 0 0 1.0; 1.0 1.0 0]'
    Y2 = [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]'
    M2 = [0 0; 0 0; 1 1]'
    k2 = 1
    Y_MASK2 = [0 0 1; 0 0 1; 2 2 1]'
    M_MASK2 = [0 0; 0 0; 1 1]'

    @testset "constructors" begin
        cd = PartitionalClusteringDifference(X, C, W, Y, M, k, Y_MASK, M_MASK)
        @test (cd.X == X && cd.C == C && cd.W == W && cd.Y == Y && cd.M == M
                && cd.k == k && cd.Y_MASK == Y_MASK && cd.M_MASK == M_MASK)
    end

    @testset "subtraction operator" begin
        cd = c - c
        @test (cd.X == [0 0; 0 0; 0 0]' && cd.C == [0 0 0; 0 0 0; 0 0 0]'
                && cd.W == [0 0 0; 0 0 0; 0 0 0]'
                && cd.Y == [0.0 0.0; 0.0 0.0; 0.0 0.0]' && cd.M == [0 0; 0 0]'
                && cd.k == 0 && cd.Y_MASK == [0 0; 0 0; 0 0]'
                && cd.M_MASK == [0 0; 0 0]')
        cd = c - c2
        @test (cd.X == X && cd.C == C && cd.W == W && cd.Y == Y && cd.M == M
                && cd.k == k && cd.Y_MASK == Y_MASK && cd.M_MASK == M_MASK)
        cd = c2 - c
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.k == k2 && cd.Y_MASK == Y_MASK2
                && cd.M_MASK == M_MASK2)
    end

    @testset "forward difference" begin
        cd = forward([c, c2], 1)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.k == k2 && cd.Y_MASK == Y_MASK2
                && cd.M_MASK == M_MASK2)
        @test isnothing(forward([c, c2], 2))
    end

    @testset "backward difference" begin
        cd = backward([c, c2], 1)
        @test (cd.X == c.X && cd.C == c.C && cd.W == c.W && cd.Y == c.Y
                && cd.M == c.M && cd.k == size(c.M, 2)
                && cd.Y_MASK == ones(Int, size(c.Y))
                && cd.M_MASK == ones(Int, size(c.M)))
        cd = backward([c, c2], 2)
        @test (cd.X == X2 && cd.C == C2 && cd.W == W2 && cd.Y == Y2
                && cd.M == M2 && cd.k == k2 && cd.Y_MASK == Y_MASK2
                && cd.M_MASK == M_MASK2)
    end
end
