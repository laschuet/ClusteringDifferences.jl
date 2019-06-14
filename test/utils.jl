@testset "utils" begin
    @testset "elementwise subtraction operator" begin
        @test VAIML.sub(1, 1) == 0
        @test VAIML.sub(nothing, 1) == 1
        @test VAIML.sub(2, nothing) == 2
        @test VAIML.sub(nothing, 1) == VAIML.sub(1, nothing)
    end

    @testset "matrix subtraction operator" begin
        A = [1 1 1; 2 2 2]
        B = [1 1; 2 2; 3 3]
        @test VAIML.sub(A, A) == [0 0 0; 0 0 0]
        @test VAIML.sub(A, B) == [0 0 1; 0 0 2; 3 3 nothing]
        @test VAIML.sub(B, A) == [0 0 1; 0 0 2; 3 3 nothing]
    end
end
