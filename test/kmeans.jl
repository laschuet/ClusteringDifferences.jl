@testset "kmeans" begin
    X = [1 0 -1 0; 0 1 0 -1]
    M = [1 -1; 1 -1]
    m, n = size(X)
    m2, k = size(M)

    cs = kmeans(X, M)
    c = cs[end]

    @test isa(cs, Vector{PartitionalClustering})
    @test c.X == X
    @test size(c.Y) == (k, n)
    @test all(y -> 0 <= y <= 1, c.Y)
    @test size(c.M) == (m, k)
end
