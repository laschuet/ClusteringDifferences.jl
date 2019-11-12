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

        A = [1 0 0; 0 1 0; 0 0 1]
        B = [1 1 1 1; 1 1 1 1]
        ia = [1, 3, 4]
        ja = [2, 3, 4]
        ib = [1, 2]
        jb = [1, 2, 4, 5]
        @test isequal(diff(A, A, ia, ja, ia, ja), [
            missing 0 0 0;
            missing missing missing missing;
            missing 0 0 0;
            missing 0 0 0
        ])
        R = Matrix{Union{Missing, Int}}(missing, 4, 5)
        R[1, 2] = 0
        R[1, 4] = -1
        @test isequal(diff(A, B, ia, ja, ib, jb), R)
        #@test diff(B, A, ia, ja, ib, jb) == []
        #@test diff(A, A) == []
        #@test diff(A, B) == []
        #@test diff(B, A) == []
    end
end
