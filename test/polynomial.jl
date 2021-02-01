@testset "laguerre_horner" begin
    tol = 1e-10

    for α in 0:50, x in 0:0.1:10
        @test isapprox(laguerre_horner(0, α)(x), 1, atol=tol)
        @test isapprox(
            laguerre_horner(1, α)(x), -x + α + 1, atol=tol)
        @test isapprox(
            laguerre_horner(2, α)(x),
            x^2 / 2 -
            ((α + 2) * x) +
            ((α + 2) * (α + 1)) / 2,
            atol=tol
        )
        @test isapprox(
            laguerre_horner(3, α)(x),
            -x^3 / 6 +
            ((α + 3) * x^2) / 2 -
            ((α + 2) * (α + 3) * x) / 2 +
            ((α + 1) * (α + 2) * (α + 3)) / 6,
            atol=tol
        )
    end
end

@testset "laguerre" begin
    for n in 0:5, α in 0:5, x in 0:0.1:10
        # the precision of Horner's method is pretty bad when n is large
        thm_val = laguerre(n, α)(x)
        test_val = laguerre_horner(n, α)(x)
        @test abs(test_val - thm_val) < 1e-11
    end

    m_range = n_range = 1:35
    x_range = -1:0.1:1
    p_range = -0.6:0.1:0.6

    # n >= m
    for m in m_range, n in m:n_range.stop, x in x_range, p in p_range
        @test abs(laguerre(m, n, x, p) - laguerre(m-1, n-m, 2(x^2 + p^2))) < 1e-5
    end
    # n < m
    for n in n_range, m in n:m_range.stop, x in x_range, p in p_range
        @test abs(laguerre(m, n, x, p) - laguerre(n-1, m-n, 2(x^2 + p^2))) < 1e-5
    end

    ms = collect(m_range)
    ns = collect(n_range)
    xs = collect(x_range)
    ps = collect(p_range)
    @test laguerre(ms, ns)(xs, ps) == laguerre(ms, ns, xs, ps)
    @test laguerre(xs, ps)(ms, ns) == laguerre(ms, ns, xs, ps)
end
