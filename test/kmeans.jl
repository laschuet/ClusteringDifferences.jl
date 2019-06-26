@testset "kmeans!" begin
    clusterings = kmeans!(permutedims([1 0; 0 1; -1 0; 0 -1]), permutedims([1 1; -1 -1]))
    println(clusterings)
end
