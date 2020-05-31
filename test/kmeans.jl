@testset "kmeans" begin
    X = [1 0 -1 0; 0 1 0 -1]
    μ = [1 -1; 1 -1]
    mx, n = size(X)
    mμ, k = size(μ)
    r = collect(1:n)
    c = collect(1:mx)

    pcs1 = kmeans(X, r, c, μ)
    pc1 = pcs1[end]
    pcs2 = kmeans(X, μ)
    pc2 = pcs2[end]

    @test isa(pcs1, Vector{PartitionalClustering})
    @test size(pc1.C) == size(pc2.C) == (0, 0)
    @test eltype(pc1.C) == eltype(pc2.C) == Int
    @test size(pc1.W) == size(pc2.W) == (0, 0)
    @test eltype(pc1.W) == eltype(pc2.W) == Float64
    @test size(pc1.Y) == size(pc2.Y) == (k, n)
    @test all(y -> 0 <= y <= 1, pc1.Y) && all(y -> 0 <= y <= 1, pc2.Y)
    @test size(pc1.p.μ) == size(pc2.p.μ) == (mμ, k)
end
