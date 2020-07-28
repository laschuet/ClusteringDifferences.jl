@testset "pckmeans" begin
    X = [1 0 -1 0 0; 0 1 0 -1 0]
    C = [0 1 0 0 0; 1 0 1 0 0; 0 1 0 1 0; 0 0 1 0 -1; 0 0 0 -1 0]
    W = abs.(C)
    M = [1 0; -1 0]
    mx, nx = size(X)
    mm, km = size(M)

    pcs = pckmeans(X, C, W, M)
    pc = pcs[end]

    @test isa(pcs, Vector{PartitionalClustering})
    @test pc.X == X
    @test size(pc.C) == (nx, nx)
    @test eltype(pc.C) == Int
    @test size(pc.W) == (nx, nx)
    @test eltype(pc.W) == Float64
    @test size(pc.Y) == (km, nx)
    @test all(y -> 0 <= y <= 1, pc.Y)
    @test size(pc.M) == (mm, km)
end
