export
    laguerre_horner,
    laguerre

function laguerre_horner(n::Integer, α::Integer, x::Real)
    # by Horner's method
    laguerre_l = 1
    bin = 1
    for i in n:-1:1
        bin *= (α + i) / (n + 1 - i)
        laguerre_l = bin - x * laguerre_l / i
    end

    return laguerre_l
end

laguerre_horner(n::Integer, α::Integer) = x->laguerre_horner(n, α, x)

function laguerre(n::Integer, α::Integer, x::T) where {T<:Real}
    if n == 0
        return one(T)
    elseif n == 1
        return one(T) + α - x
    else
        L_prev = one(T)
        L_k = one(T) + α - x
        for k = 1:(n-1)
            L_next = ((2k + 1 + α - x) * L_k - (k+α) * L_prev) / (k+1)
            L_prev, L_k = L_k, L_next
        end
        return L_k
    end
end

laguerre(n::Integer, α::Integer) = x->laguerre(n, α, x)

factorial_ij(i::Integer, j::Integer) = factorial(big(min(i,j))) / factorial(big(max(i,j)))
