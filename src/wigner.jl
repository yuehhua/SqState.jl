export
    W,
    laguerre,
    wigner,
    gen_wigner

#=
    Wigner function by Laguerre Polynominal
=#

function laguerre(n::Integer, α::Integer, x::Real)
    # by Horner's method
    laguerre_l = 1
    bin = 1
    for i in n:-1:1
        bin *= (α + i) / (n + 1 - i)
        laguerre_l = bin - x * laguerre_l / i
    end

    return laguerre_l
end

laguerre(n::Integer, α::Integer) = x->laguerre(n, α, x)

factorial_ij(i::Integer, j::Integer) = factorial(big(min(i,j))) / factorial(big(max(i,j)))

function wigner(m, n, x, p)
    imag = 1im
    if n < m
        m, n = n, m
        imag = -1im
    end

    w = 1 / pi
    w *= exp(-(x^2 + p^2))
    w *= (-1)^m
    w *= sqrt(2^(n-m) * factorial_ij(m, n))
    w *= (x - p*imag)^(n-m)
    w *= laguerre(m, n-m)(2x^2 + 2p^2)

    return w
end

wigner(w_argv::Tuple) = ComplexF64(wigner(w_argv...))

#=
    Wigner function by Fourier transform
=#

function wigner(x, p)
end

struct W
    ρ_size::Int64
    mn::Array{ComplexF64, 4}
end

function W(x_range::StepRangeLen, p_range::StepRangeLen; ρ_size=35)
    meshgrid = Tuple[]
    for n in 1:ρ_size
        for m in 1:ρ_size
            for x in x_range
                for p in p_range
                    push!(meshgrid, (m, n, x, p))
                end
            end
        end
    end
    mn = reshape(wigner.(meshgrid), ρ_size, ρ_size, length(x_range), length(p_range))

    return W(ρ_size, mn)
end

function wigner(ρ, w::W)
    reshape(real(sum(ρ .* w.mn, dims=(1, 2))), size(w.mn)[3], size(w.mn)[4])
end
