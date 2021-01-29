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
        isapprox(thm_val, 0) && continue
        @test abs(test_val - thm_val)/abs(thm_val) < 1e-11
    end
end
