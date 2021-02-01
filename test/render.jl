@testset "init wigner function" begin
    x_range = -5:1.0:5
    p_range = -5:1.0:5
    wf = init_wf(x_range, p_range)

    @test wf isa WignerFunction
    @test wf.m_dim == wf.n_dim == 35
    @test wf.xs == x_range
    @test wf.ps == p_range
    m_dim = n_dim = 35
    for m in 1:m_dim, n in 1:n_dim,
        (x_i, x) in enumerate(x_range), (p_j, p) in enumerate(p_range)

        @test wf.W[m, n, x_i, p_j] == ComplexF64(wigner(m ,n, x, p))
    end
end

@testset "render" begin
    x_range = -5:1.0:5
    p_range = -5:1.0:5
    wf = init_wf(x_range, p_range)

    ρ = ones(ComplexF64, 35, 35)
    p, w = render(ρ, wf)

    ans = real(sum(ρ .* wf.W, dims=(1, 2)))
    for (i, e) in enumerate(w)
        @test e == ans[i]
    end
end
