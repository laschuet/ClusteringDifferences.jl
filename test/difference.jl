@testset "difference" begin
    pc = PartitionalClustering([0 1; 1 0; 1 1], [0 0 0; 0 0 0; 0 0 0],
            [0 0 0; 0 0 0; 0 0 0], [1.0 0.0; 0.0 1.0; 0.5 0.5], [0 1; 1 0])
    pc2 = PartitionalClustering([0 1; 1 0; 1 1], [0 0 -1; 0 0 -1; -1 -1 0],
            [0 0 1.0; 0 0 1.0; 1.0 1.0 0],
            [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0], [0 1; 1 0; 1 1])

    @testset "constructors" begin
        pcd = PartitionalClusteringDifference([0 0; 0 0; 0 0],
                [0 0 1; 0 0 1; 1 1 0], [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0],
                [0.0 0.0 0.0; 0.0 0.0 0.0; 0.5 0.5 1.0], [0 0; 0 0; 1 1], -1,
                [0 0 -1; 0 0 -1; 2 2 -1], [0 0; 0 0; -1 -1])
        @test (pcd.X == [0 0; 0 0; 0 0]
                && pcd.C == [0 0 1; 0 0 1; 1 1 0]
                && pcd.W == [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]
                && pcd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; 0.5 0.5 1.0]
                && pcd.M == [0 0; 0 0; 1 1]
                && pcd.k == -1
                && pcd.Y_MASK == [0 0 -1; 0 0 -1; 2 2 -1]
                && pcd.M_MASK == [0 0; 0 0; -1 -1])
    end

    @testset "subtraction operator" begin
        pcd = pc - pc
        @test (pcd.X == [0 0; 0 0; 0 0]
                && pcd.C == [0 0 0; 0 0 0; 0 0 0]
                && pcd.W == [0 0 0; 0 0 0; 0 0 0]
                && pcd.Y == [0.0 0.0; 0.0 0.0; 0.0 0.0]
                && pcd.M == [0 0; 0 0]
                && pcd.k == 0
                && pcd.Y_MASK == [0 0; 0 0; 0 0]
                && pcd.M_MASK == [0 0; 0 0])
        pcd = pc - pc2
        @test (pcd.X == [0 0; 0 0; 0 0]
                && pcd.C == [0 0 1; 0 0 1; 1 1 0]
                && pcd.W == [0 0 -1.0; 0 0 -1.0; -1.0 -1.0 0]
                && pcd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; 0.5 0.5 1.0]
                && pcd.M == [0 0; 0 0; 1 1]
                && pcd.k == -1
                && pcd.Y_MASK == [0 0 -1; 0 0 -1; 2 2 -1]
                && pcd.M_MASK == [0 0; 0 0; -1 -1])
        pcd = pc2 - pc
        @test (pcd.X == [0 0; 0 0; 0 0]
                && pcd.C == [0 0 -1; 0 0 -1; -1 -1 0]
                && pcd.W == [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
                && pcd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]
                && pcd.M == [0 0; 0 0; 1 1]
                && pcd.k == 1
                && pcd.Y_MASK == [0 0 1; 0 0 1; 2 2 1]
                && pcd.M_MASK == [0 0; 0 0; 1 1])
    end

    @testset "forward difference" begin
        pcd = forward([pc, pc2], 1)
        @test (pcd.X == [0 0; 0 0; 0 0]
                && pcd.C == [0 0 -1; 0 0 -1; -1 -1 0]
                && pcd.W == [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
                && pcd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]
                && pcd.M == [0 0; 0 0; 1 1]
                && pcd.k == 1
                && pcd.Y_MASK == [0 0 1; 0 0 1; 2 2 1]
                && pcd.M_MASK == [0 0; 0 0; 1 1])
        @test isnothing(forward([pc, pc2], 2))
    end

    @testset "backward difference" begin
        pcd = backward([pc, pc2], 1)
        @test (pcd.X == pc.X
                && pcd.C == pc.C
                && pcd.W == pc.W
                && pcd.Y == pc.Y
                && pcd.M == pc.M
                && pcd.k == 2
                && pcd.Y_MASK == [1 1; 1 1; 1 1]
                && pcd.M_MASK == [1 1; 1 1])
        pcd = backward([pc, pc2], 2)
        @test (pcd.X == [0 0; 0 0; 0 0]
                && pcd.C == [0 0 -1; 0 0 -1; -1 -1 0]
                && pcd.W == [0 0 1.0; 0 0 1.0; 1.0 1.0 0]
                && pcd.Y == [0.0 0.0 0.0; 0.0 0.0 0.0; -0.5 -0.5 1.0]
                && pcd.M == [0 0; 0 0; 1 1]
                && pcd.k == 1
                && pcd.Y_MASK == [0 0 1; 0 0 1; 2 2 1]
                && pcd.M_MASK == [0 0; 0 0; 1 1])
    end
end
