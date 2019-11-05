@testset "pckmeans" begin
    X = [1 0 -1 0 0; 0 1 0 -1 0]
    C = [0 1 0 0 0; 1 0 1 0 0; 0 1 0 1 0; 0 0 1 0 -1; 0 0 0 -1 0]
    W = abs.(C)
    M = [1 0; -1 0]
    mx, nx = size(X)
    mm, km = size(M)

    cs = pckmeans(X, C, W, M)
    c = cs[end]

    @test isa(cs, Vector{PartitionalClustering})
    @test c.X == X
    @test size(c.C) == (nx, nx)
    @test eltype(c.C) == Int
    @test size(c.W) == (nx, nx)
    @test eltype(c.W) == Float64
    @test size(c.Y) == (km, nx)
    @test all(y -> 0 <= y <= 1, c.Y)
    @test size(c.M) == (mm, km)
end
