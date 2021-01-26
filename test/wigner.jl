@testset "Wigner" begin
    tol = 1e-14

    x = 5
    α = 0.5
    @test isapprox(laguerre(0, α)(x), 1, atol=tol)
    @test isapprox(
        laguerre(1, α)(x), -x + α + 1, atol=tol)
    @test isapprox(
        laguerre(2, α)(x),
        x^2 / 2 -
        ((α + 2) * x) +
        ((α + 2) * (α + 1)) / 2,
        atol=tol
    )
    @test isapprox(
        laguerre(3, α)(x),
        -x^3 / 6 +
        ((α + 3) * x^2) / 2 -
        ((α + 2) * (α + 3) * x) / 2 +
        ((α + 1) * (α + 2) * (α + 3)) / 6,
        atol=tol
    )

end
