@testset "difference" begin
    a = PartitionalClustering([0 1; 1 0; 1 1]', [0 0 0; 0 0 0; 0 0 0]',
            [0 0 0; 0 0 0; 0 0 0]', [1.0 0.0; 0.0 1.0; 0.5 0.5]', [0 1; 1 0]')
    b = PartitionalClustering([0 1; 1 0; 1 1]', [0 0 -1; 0 0 -1; -1 -1 0]',
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
        pcd = PartitionalClusteringDifference(X, C, W, Y, M, k, Y_MASK, M_MASK)
        @test (pcd.X == X && pcd.C == C && pcd.W == W && pcd.Y == Y
                && pcd.M == M && pcd.k == k && pcd.Y_MASK == Y_MASK
                && pcd.M_MASK == M_MASK)
    end

    @testset "subtraction operator" begin
        pcd = a - a
        @test (pcd.X == [0 0; 0 0; 0 0]' && pcd.C == [0 0 0; 0 0 0; 0 0 0]'
                && pcd.W == [0 0 0; 0 0 0; 0 0 0]'
                && pcd.Y == [0.0 0.0; 0.0 0.0; 0.0 0.0]' && pcd.M == [0 0; 0 0]'
                && pcd.k == 0 && pcd.Y_MASK == [0 0; 0 0; 0 0]'
                && pcd.M_MASK == [0 0; 0 0]')
        pcd = a - b
        @test (pcd.X == X && pcd.C == C && pcd.W == W && pcd.Y == Y
                && pcd.M == M && pcd.k == k && pcd.Y_MASK == Y_MASK
                && pcd.M_MASK == M_MASK)
        pcd = b - a
        @test (pcd.X == X2 && pcd.C == C2 && pcd.W == W2 && pcd.Y == Y2
                && pcd.M == M2 && pcd.k == k2 && pcd.Y_MASK == Y_MASK2
                && pcd.M_MASK == M_MASK2)
    end

    @testset "forward difference" begin
        pcd = forward([a, b], 1)
        @test (pcd.X == X2 && pcd.C == C2 && pcd.W == W2 && pcd.Y == Y2
                && pcd.M == M2 && pcd.k == k2 && pcd.Y_MASK == Y_MASK2
                && pcd.M_MASK == M_MASK2)
        @test isnothing(forward([a, b], 2))
    end

    @testset "backward difference" begin
        pcd = backward([a, b], 1)
        @test (pcd.X == a.X && pcd.C == a.C && pcd.W == a.W && pcd.Y == a.Y
                && pcd.M == a.M && pcd.k == size(a.M, 2)
                && pcd.Y_MASK == ones(Int, size(a.Y))
                && pcd.M_MASK == ones(Int, size(a.M)))
        pcd = backward([a, b], 2)
        @test (pcd.X == X2 && pcd.C == C2 && pcd.W == W2 && pcd.Y == Y2
                && pcd.M == M2 && pcd.k == k2 && pcd.Y_MASK == Y_MASK2
                && pcd.M_MASK == M_MASK2)
    end
end
