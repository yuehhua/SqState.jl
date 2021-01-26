export
    laguerre,
    wigner,
    gen_wigner

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

function factorial_ij(i::Integer, j::Integer)
    ans = BigInt(i)
    while i < j
        i += 1
        ans *= i
    end

    return ans
end

function wigner(m, n, x, p)
    imag = 1im
    if n < m
        m, n = n, m
        imag = -1im
    end

    w = 1 / pi
    w *= exp(-(x^2 + p^2))
    w *= (-1)^m
    w *= sqrt(2^(n-m) / factorial_ij(m+1, n))
    w *= (x - p*imag)^(n-m)
    w *= laguerre(m, n-m)(2x^2 + 2p^2)

    return w
end

wigner(m, n) = (x, p)->wigner(m, n, x, p)

function wigner(m::Vector{<:Integer}, n::Vector{<:Integer}, x::Real, p::Real)
    n = n'
    α = n .- m
    imag = sign.(α) .* im
    α .= abs.(α)
    M = min.(m, n)
    N = max.(m, n)

    W = (-1).^M / π * exp(-(x^2 + p^2))
    W = complex.(W .* sqrt.((2).^α ./ factorial_ij.(M.+1, N)))
    W .*= (x .- p*imag).^α
    W .*= laguerre.(M, α, 2*x^2 + 2*p^2)

    return W
end

gen_wigner(ρ) = (x, p) -> sum(ρ .* wigner(collect(1:size(ρ,1)), collect(1:size(ρ,2)), x, p))
