@testset "utils" begin
    @testset "subtraction operator" begin
        A = [1 1 1; 2 2 2]
        B = [1 1; 2 2; 3 3]
        @test VAIML.sub(A, A) == [0 0 0; 0 0 0]
        @test VAIML.sub(A, B) == [0 0 1; 0 0 2; 3 3 nothing]
        @test VAIML.sub(B, A) == [0 0 1; 0 0 2; 3 3 nothing]
    end

    @testset "difference operator" begin
        a = [1, 2, 3, 4]
        b = [1, 2, 3, 5]
        @test diff(a, a) == []
        @test diff(a, b) == [4, -5]
        @test diff(b, a) == [-4, 5]
    end
end
