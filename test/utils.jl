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
    m_range = n_range = 1:35

    for m in m_range, n in m:n_range.stop
        @test SqState.α(m, n) == max(m, n) - min(m, n)
    end

    ms = collect(m_range)
    ns = collect(n_range)
    @test SqState.α(ms, ns) == max.(ms, ns') .- min.(ms, ns')
end

@testset "gaussian_function" begin
    tol = 1e-14

    x_range = -10:0.01:10
    p_range = -6:0.01:6

    for x in x_range, p in p_range
        @test isapprox(SqState.gaussian_function(x, p), exp(-(x^2 + p^2)) / π, atol=tol)
    end

    xs = collect(x_range)
    ps = collect(p_range)
    @test isapprox(
        SqState.gaussian_function(xs, ps),
        exp.(-(xs.^2 .+ (ps').^2)) ./ π,
        atol=tol
    )
end

@testset "(-1)^i" begin
    for i in 1:50
        @test SqState.neg_one_to_power_of(i) == (-1)^i
    end
end

@testset "coefficient_of_wave_function" begin
    tol = 1e-14

    m_range = n_range = 1:35

    for m in m_range, n in n_range
        m1 = (n ≥ m) ? (-1)^(m-1) : (-1)^(n-1)
        @test isapprox(
            SqState.coefficient_of_wave_function(m, n),
            m1 * sqrt(factorial(big(min(m, n))) / factorial(big(max(m, n)))),
            atol=tol
        )
    end

    ms = collect(m_range)
    ns = collect(n_range)
    @test SqState.coefficient_of_wave_function(ms, ns) == SqState.coefficient_of_wave_function.(ms, ns')
end

@testset "z_to_power" begin
    tol = 1e-14

    m_range = n_range = 1:35
    x_range = -1:0.1:1
    p_range = -0.6:0.1:0.6

    for m in m_range, n in n_range, x in x_range, p in p_range
        z = (n >= m) ? sqrt(2.)*(x - p*im) : sqrt(2.)*(x + p*im)
        @test SqState.z_to_power(m, n, x, p) == z^(max(m, n) - min(m, n))
    end

    ms = collect(m_range)
    ns = collect(n_range)
    xs = collect(x_range)
    ps = collect(p_range)
    xs_ = reshape(collect(x_range), 1, 1, length(x_range))
    ps_ = reshape(collect(p_range), 1, 1, 1, length(p_range))
    @test SqState.z_to_power(ms, ns, xs, ps) == SqState.z_to_power.(ms, ns', xs_, ps_)
    @test SqState.z_to_power(ms, ns)(xs, ps) == SqState.z_to_power.(ms, ns', xs_, ps_)
    @test SqState.z_to_power(xs, ps)(ms, ns) == SqState.z_to_power.(ms, ns', xs_, ps_)
end
