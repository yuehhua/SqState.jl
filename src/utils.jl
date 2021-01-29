factorial_ij(i::Integer, j::Integer) = factorial(big(min(i,j))) / factorial(big(max(i,j)))

z(x::Real, p::Real) = sqrt(2.)*(x + p*im)
z(x::Vector{<:Real}, p::Vector{<:Real}) = z.(x, p')

α(m::Integer, n::Integer) = n - m
α(m::Vector{<:Integer}, n::Vector{<:Integer}) = α.(max.(m, n'), min.(m, n'))

gaussian_function(x::Real, p::Real) = exp(-0.5 * abs2(z(x,p))) / π
gaussian_function(x::Vector{<:Real}, p::Vector{<:Real}) = gaussian_function.(x,p')

neg_one_to_power_of(i::Integer) = (i % 2 == 0) ? 1 : -1

function coefficient_of_wave_function(m::Integer, n::Integer)
    if n ≥ m
        return neg_one_to_power_of(m) * sqrt(factorial_ij(m, n))
    else
        return neg_one_to_power_of(n) * sqrt(factorial_ij(m, n))
    end
end

coefficient_of_wave_function(m::Vector{<:Integer}, n::Vector{<:Integer}) = coefficient_of_wave_function.(m, n')

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
