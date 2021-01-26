export
    laguerre,
    wigner

function laguerre(n, α, x)
    # by Horner's method
    laguerre_l = 1
    bin = 1
    for i in n:-1:1
        bin *= (α + i) / (n + 1 - i)
        laguerre_l = bin - x * laguerre_l / i
    end

    return laguerre_l
end

laguerre(n, α) = x->laguerre(n, α, x)

function factorial_ij(i, j)
    ans = i
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
