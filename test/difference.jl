@testset "difference" begin
    a = PartitionalClustering([1 1; 0 1], [0 1; 1 0], [0 1.0; 1.0 0], [1, 1],
            [0.5, 1])
    b = PartitionalClustering([2 2; 2 2], [0 -1; -1 0], [0 1.0; 1.0 0], [0, 1],
            [2.0, 2])

    @testset "constructors" begin
    end

    @testset "operator" begin
    end

    @testset "show" begin
        @test sprint(show, a - a) == ""
    end
end
