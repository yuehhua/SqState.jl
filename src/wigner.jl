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

function wigner(m::Integer, n::Integer, imag::Complex, x::Real, p::Real)
    w = 1 / pi
    w *= exp(-(x^2 + p^2))
    w *= (-1)^m
    w *= sqrt(2^(n-m) / factorial_ij(m+1, n))
    w *= (x - imag*p)^(n-m)
    w *= laguerre(m, n-m)(2x^2 + 2p^2)

    return w
end

function wigner(m::Integer, n::Integer)
    if n < m
        return (x, p)->wigner(n, m, -1im, x, p)
    else
        return (x, p)->wigner(m, n, 1im, x, p)
    end
end
