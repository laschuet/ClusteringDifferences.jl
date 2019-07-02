@testset "encoding" begin
    X = [0 0 0; 0 0 0]
    C = [0 0 -1; 0 0 -1; -1 -1 0]
    W = [0 0 0; 0 0 0; 0 0 0]
    Y = [0.0 0.0 -0.5; 0.0 0.0 -0.5; 0.0 0.0 1.0]
    M = [0 0 1; 0 0 1]
    k = 1
    cd = PartitionalClusteringDifference(X, C, W, Y, M, k)
    XM = [0 0 0; 0 0 0]
    CM = [0 0 2; 0 0 2; 2 2 0]
    WM = [0 0 0; 0 0 0; 0 0 0]
    YM = [0 0 2; 0 0 2; 1 1 1]
    MM = [0 0 1; 0 0 1]
    cde = PartitionalClusteringDifferenceEncoding(XM, CM, WM, YM, MM)

    @testset "constructors" begin
        @test(cde.X == XM && cde.C == CM && cde.W == WM && cde.Y == YM
                && cde.M == MM)

        cde = PartitionalClusteringDifferenceEncoding(cd)
        @test(cde.X == XM && cde.C == CM && cde.W == WM && cde.Y == YM
                && cde.M == MM)
    end

    @testset "mask" begin
        ΔM = [1 0 1; -1 0 1; 2 0 nothing; 0 2 nothing]
        M = VAIML.mask(ΔM, (0, 0))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 2; 2 0 2; 2 0 3; 0 2 3])
        M = VAIML.mask(ΔM, (1, 0))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 2; 2 0 2; 2 0 3; 1 1 3])
        M = VAIML.mask(ΔM, (-1, 0))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 2; 2 0 2; 2 0 3; -1 -1 3])
        M = VAIML.mask(ΔM, (0, 1))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 1; 2 0 1; 2 0 3; 0 2 3])
        M = VAIML.mask(ΔM, (0, -1))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 -1; 2 0 -1; 2 0 3; 0 2 3])
        M = VAIML.mask(ΔM, (1, 1))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 1; 2 0 1; 2 0 3; 1 1 3])
        M = VAIML.mask(ΔM, (-1, -1))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 -1; 2 0 -1; 2 0 3; -1 -1 3])
        M = VAIML.mask(ΔM, (1, -1))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 -1; 2 0 -1; 2 0 3; 1 1 3])
        M = VAIML.mask(ΔM, (-1, 1))
        @test isa(M, AbstractMatrix{Int})
        @test(M == [2 0 1; 2 0 1; 2 0 3; -1 -1 3])
    end
end
