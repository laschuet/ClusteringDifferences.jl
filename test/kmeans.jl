@testset "kmeans" begin
    X = [1 0 -1 0; 0 1 0 -1]
    M = [1 -1; 1 -1]
    mx, nx = size(X)
    mm, km = size(M)
    r = collect(1:nx)
    c = collect(1:mx)

    pcs1 = kmeans(X, r, c, M)
    pc1 = pcs1[end]
    pcs2 = kmeans(X, M)
    pc2 = pcs2[end]

    @test isa(pcs1, Vector{PartitionalClustering})
    @test size(pc1.C) == size(pc2.C) == (0, 0)
    @test eltype(pc1.C) == eltype(pc2.C) == Int
    @test size(pc1.W) == size(pc2.W) == (0, 0)
    @test eltype(pc1.W) == eltype(pc2.W) == Float64
    @test size(pc1.Y) == size(pc2.Y) == (km, nx)
    @test all(y -> 0 <= y <= 1, pc1.Y) && all(y -> 0 <= y <= 1, pc2.Y)
    @test size(pc1.M) == size(pc2.M) == (mm, km)
end
