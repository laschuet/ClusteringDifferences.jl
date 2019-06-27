@testset "kmeans!" begin
    clusterings = kmeans!([1 0; 0 1; -1 0; 0 -1], [1 1; -1 -1])
    println(clusterings)
end
