@testset "factorial_ij" begin
    for i in 0:40, j in i:40
        @test SqState.factorial_ij(i, j) == factorial(big(i)) / factorial(big(j))
        @test SqState.factorial_ij(j, i) == factorial(big(i)) / factorial(big(j))
    end
end

@testset "z" begin
    x = collect(-10:0.01:10)
    p = collect(-6:0.01:6)
    @test SqState.z(x, p) == sqrt(2.).*(x .+ p' .* im)
end
