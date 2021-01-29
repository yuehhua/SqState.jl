@testset "factorial_ij" begin
    for i in 0:40, j in i:40
        @test SqState.factorial_ij(i, j) == factorial(big(i)) / factorial(big(j))
        @test SqState.factorial_ij(j, i) == factorial(big(i)) / factorial(big(j))
    end
end

@testset "z" begin
    x_range = -10:0.01:10
    p_range = -6:0.01:6

    for x in x_range, p in p_range
        @test SqState.z(x, p) == sqrt(2.)*(x + p*im)
    end

    xs = collect(x_range)
    ps = collect(p_range)
    @test SqState.z(xs, ps) == sqrt(2.).*(xs .+ ps' .* im)
end

@testset "α" begin

end
