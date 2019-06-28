@testset "kmeans!" begin
    X = [1 0; 0 1; -1 0; 0 -1]
    M = [1 1; -1 -1]
    n, m = size(X)
    k, = size(M)

    clusterings = kmeans!(X, M)
    c = clusterings[end]

    @test isa(clusterings, Vector{PartitionalClustering})
    @test c.X == X
    @test size(c.Y) == (n, k)
    @test all(y -> 0 <= y <= 1, c.Y)
    @test size(c.M) == (k, m)
end
