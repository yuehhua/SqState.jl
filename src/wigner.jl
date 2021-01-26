using Plots

export
    laguerre,
    wigner

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
    ans = i
    while i < j
        i += 1
        ans *= i
    end

    return ans
end

function wigner(m::Integer, n::Integer, x::Real, p::Real)
    α = n - m
    imag = sign(α) * im
    α = abs(α)

    w = 1 / π
    w *= exp(-(x^2 + p^2))
    w *= (-1)^m
    w *= sqrt(2^α / factorial_ij(m+1, n))
    w *= (x - imag*p)^α
    w *= laguerre(m, α)(2x^2 + 2p^2)

    return w
end

wigner(m::Integer, n::Integer) = (x, p)->wigner(m, n, x, p)

function wigner(m::Vector{<:Integer}, n::Vector{<:Integer}, x::Real, p::Real)
    n = n'
    α = n .- m
    imag = sign.(α) .* im
    α .= abs.(α)

    W = (-1).^m / π * exp(-(x^2 + p^2))
    W = W .* sqrt.((2).^α ./ factorial_ij.(m.+1, n))
    W .*= (x .- p*imag).^α
    W .*= laguerre.(m, α, 2*x^2 + 2*p^2)

    return W
end

gen_wigner(ρ) = (x, p) -> sum(ρ .* wigner(collect(1:size(ρ,1)), collect(1:size(ρ,2)), x, p))
