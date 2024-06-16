@testset "kmeans" begin
    X = [1 0 -1 0; 0 1 0 -1]
    μ = [1 -1; 1 -1]
    mx, n = size(X)
    mμ, k = size(μ)
    r = collect(1:n)
    c = collect(1:mx)

    cs1 = kmeans(X, r, c, μ)
    c1 = cs1[end]
    cs2 = kmeans(X, μ)
    c2 = cs2[end]

    @test isa(cs1, Vector{Clustering})
    @test size(c1.C) == size(c2.C) == (0, 0)
    @test eltype(c1.C) == eltype(c2.C) == Int
    @test size(c1.W) == size(c2.W) == (0, 0)
    @test eltype(c1.W) == eltype(c2.W) == Float64
    @test size(c1.Y) == size(c2.Y) == (k, n)
    @test all(y -> 0 <= y <= 1, c1.Y) && all(y -> 0 <= y <= 1, c2.Y)
    @test size(c1.p.μ) == size(c2.p.μ) == (mμ, k)
end
