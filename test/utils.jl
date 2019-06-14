@testset "utils" begin
    @testset "subtraction operator" begin
        @test VAIML.sub(1, 1) == 0
        @test VAIML.sub(nothing, 1) == 1
        @test VAIML.sub(2, nothing) == 2
        @test VAIML.sub(nothing, 1) == VAIML.sub(1, nothing)

        A = [1 1; 2 2]
        B = [3 3 3; 4 4 4]
        @test VAIML.sub(A, A) == [0 0; 0 0]
        @test VAIML.sub(A, B) == [-2 -2 3; -2 -2 4]
        @test VAIML.sub(B, A) == [2 2 3; 2 2 4]
    end
end
