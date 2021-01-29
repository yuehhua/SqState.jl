export
    laguerre,
    laguerre2,
    factorial_ij

factorial_ij(i::Integer, j::Integer) = factorial(big(max(i,j))) / factorial(big(min(i,j)))

z(x::Real, p::Real) = sqrt(2.)*(x + p*im)
z(x::Vector{<:Real}, p::Vector{<:Real}) = z.(x, p')

α(m::Integer, n::Integer) = n - m
α(m::Vector{<:Integer}, n::Vector{<:Integer}) = α.(max.(m, n'), min.(m, n'))

gaussian_function(x::Real, p::Real) = exp(-0.5 * abs2(z(x,p))) / π
gaussian_function(x::Vector{<:Real}, p::Vector{<:Real}) = gaussian_function.(x,p')

neg_one_to_power_of(i::Integer) = (i % 2 == 0) ? 1 : -1

function combination_number(m::Integer, n::Integer)
    if n ≥ m
        return neg_one_to_power_of(m) / sqrt(factorial_ij(m, n))
    else
        return neg_one_to_power_of(n) / sqrt(factorial_ij(m, n))
    end
end

combination_number(m::Vector{<:Integer}, n::Vector{<:Integer}) = combination_number.(m, n')

function z_to_power(m::Integer, n::Integer, x::Real, p::Real)
    if n ≥ m
        return conj(z(x, p'))^(n - m)
    else
        return z(x, p')^(m - n)
    end
end

function z_to_power(m::Vector{<:Integer}, n::Vector{<:Integer}, x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    z_to_power.(m, n', x, p)
end

function z_to_power(m::Vector{<:Integer}, n::Vector{<:Integer})
    function z_to_power_xp(x::Vector{<:Real}, p::Vector{<:Real})
        x = reshape(x, 1, 1, length(x))
        p = reshape(p, 1, 1, 1, length(p))
        z_to_power.(m, n', x, p)
    end
    return z_to_power_xp
end

function z_to_power(x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    function z_to_power_mn(m::Vector{<:Integer}, n::Vector{<:Integer})
        z_to_power.(m, n', x, p)
    end
    return z_to_power_mn
end

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

function laguerre2(m::Integer, n::Integer, x::Real, p::Real)
    if n ≥ m
        return laguerre2(m, n - m, abs2([x, p]))
    else
        return laguerre2(n, m - n, abs2([x, p]))
    end
end

function laguerre2(m::Vector{<:Integer}, n::Vector{<:Integer}, x::Vector{<:Real}, p::Vector{<:Real})
    x = reshape(x, 1, 1, length(x))
    p = reshape(p, 1, 1, 1, length(p))
    if n ≥ m
        return laguerre2.(m, n' .- m, x, p)
    else
        return laguerre2.(n', m .- n', x, p)
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
            return laguerre2.(m, n' .- m, x, p)
        else
            return laguerre2.(n', m .- n', x, p)
        end
    end
    return laguerre_mn
end
