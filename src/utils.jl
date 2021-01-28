export
    laguerre,
    laguerre2,
    factorial_ij

factorial_ij(i::Integer, j::Integer) = factorial(big(max(i,j))) / factorial(big(min(i,j)))

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

function laguerre2(n::Integer, α::Integer, x::T) where {T<:Real}
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

laguerre2(n::Integer, α::Integer) = x->laguerre2(n, α, x)

function laguerre2(m::Vector{<:Integer}, n::Vector{<:Integer}, x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    if n ≥ m
        return laguerre2.(m, n' .- m, abs2.(x, p))
    else
        return laguerre2.(n', m .- n', abs2.(x, p))
    end
end

function laguerre2(m::Vector{<:Integer}, n::Vector{<:Integer})
    laguerre_xp(x::Vector{<:Real}, p::Vector{<:Real}) = laguerre2(m, n, x, p)
    return laguerre_xp
end

function laguerre2(x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    function laguerre_mn(m::Vector{<:Integer}, n::Vector{<:Integer})
        if n ≥ m
            return laguerre2.(m, n' .- m, abs2.(x, p))
        else
            return laguerre2.(n', m .- n', abs2.(x, p))
        end
    end
    return laguerre_mn
end
