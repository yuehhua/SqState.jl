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
            L_next = ((2k + one(T) + α - x) * L_k - (k+α) * L_prev) / (k+one(T))
            L_prev, L_k = L_k, L_next
        end
        return L_k
    end
end

laguerre(n::Integer, α::Integer) = x->laguerre(n, α, x)

function laguerre(m::Integer, n::Integer, x::Real, p::Real)
    if n ≥ m
        # adjust index bases for number state on `m`
        return laguerre(m-1, n - m, abs2(z(x, p)))
    else
        # adjust index bases for number state on `n`
        return laguerre(n-1, m - n, abs2(z(x, p)))
    end
end

function laguerre(m::Vector{<:Integer}, n::Vector{<:Integer}, x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    return laguerre.(m, n', x, p)
end

function laguerre(m::Vector{<:Integer}, n::Vector{<:Integer})
    laguerre_xp(x::Vector{<:Real}, p::Vector{<:Real}) = laguerre(m, n, x, p)
    return laguerre_xp
end

function laguerre(x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    function laguerre_mn(m::Vector{<:Integer}, n::Vector{<:Integer})
        return laguerre.(m, n', x, p)
    end
    return laguerre_mn
end
