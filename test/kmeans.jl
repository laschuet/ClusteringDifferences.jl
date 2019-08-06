@testset "kmeans" begin
    X = [1 0 -1 0; 0 1 0 -1]
    M = [1 -1; 1 -1]
    mx, nx = size(X)
    mm, km = size(M)

    cs = kmeans(X, M)
    c = cs[end]

    @test isa(cs, Vector{PartitionalClustering})
    @test c.X == X
    @test size(c.C) == (0, 0)
    @test eltype(c.C) == Int
    @test size(c.W) == (0, 0)
    @test eltype(c.W) == Float64
    @test size(c.Y) == (km, nx)
    @test all(y -> 0 <= y <= 1, c.Y)
    @test size(c.M) == (mm, km)
end
