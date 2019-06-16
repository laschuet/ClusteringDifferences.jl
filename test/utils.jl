@testset "utils" begin
    @testset "subtraction operator" begin
        A = [1 1 1; 2 2 2]
        B = [1 1; 2 2; 3 3]
        @test VAIML.sub(A, A) == [0 0 0; 0 0 0]
        @test VAIML.sub(A, B) == [0 0 1; 0 0 2; 3 3 nothing]
        @test VAIML.sub(B, A) == [0 0 1; 0 0 2; 3 3 nothing]
    end
end
