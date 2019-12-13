@testset "utils" begin
    @testset "difference operator" begin
        a = [1, 2, 3, 3]
        b = [4, 2, 1]
        @test diff(a, a) == ([1, 2, 3], [], [])
        @test diff(a, b) == ([1, 2], [4], [3])
        @test diff(b, a) == ([2, 1], [3], [4])

        A = [1 0 1; 0 1 0; 0 0 1]
        B = [1 1 1 1; 1 1 1 1]
        ia = [1, 2, 5]
        ja = [2, 8, 11]
        ib = [1, 8]
        jb = [2, 3, 4, 11]
        @test diff(A, A, ia, ja, ia, ja) == (
            sparse([0 0 0; 0 0 0; 0 0 0]),
            [], [],
            [], []
        )
        @test diff(A, B, ia, ja, ib, jb) == (
            sparse([0 0]),
            [1 1 1 1], [1 1; 1 1],
            [0 1 0; 0 0 1], reshape([0, 1, 0], :, 1)
        )
        @test diff(B, A, ib, jb, ia, ja) == (
            sparse([0 0]),
            [0 1 0; 0 0 1], reshape([0, 1, 0], :, 1),
            [1 1 1 1], [1 1; 1 1]
        )
        @test diff(A, A) == (
            sparse([0 0 0; 0 0 0; 0 0 0]),
            [], [],
            [], []
        )
        @test diff(A, B) == (
            sparse([0 -1 0; -1 0 -1]),
            [], reshape([1, 1], :, 1),
            [0 0 1], []
        )
        @test diff(B, A) == (
            sparse([0 -1 0; -1 0 -1]),
            [0 0 1], [],
            [], reshape([1, 1], :, 1)
        )
    end
end
