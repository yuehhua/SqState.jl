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
    w *= sqrt(2^(n-m) / factorial_ij(m+1, n))
    w *= (x - p*imag)^(n-m)
    w *= laguerre(m, n-m)(2x^2 + 2p^2)

    return w
end

wigner(m, n) = (x, p)->wigner(m, n, x, p)

mutable struct WignerFunction{M,T<:Integer}
    ρ::M
    m::T
    n::T

    function WignerFunction(ρ::AbstractMatrix)
        m, n = size(ρ)
        new{typeof(ρ),typeof(m)}(ρ, m, n)
    end
end

function (wf::WignerFunction)(x::Real, p::Real)
    α = α_mat(wf)
    M = lower_dim_mat(W)
    N = higher_dim_mat(W)
    z = x^2 + p^2

    W = exp(-z) / π
    W = complex.(W .* (-1).^M .* sqrt.((2).^α ./ factorial_ij.(M.+1, N)))
    W .*= (x .- p*imag_sign(wf)).^α
    W .*= laguerre.(M, α, 2z)
    sum(W .* wf.ρ)
end

function (wf::WignerFunction)(x::Vector{T}, p::Vector{T}) where {T<:Real}
    x_dim = length(x)
    p_dim = length(p)
    Z = reshape(sqrt(2) .* (x .+ p' .* im), 1, 1, x_dim, p_dim)
    Z² = abs2.(Z)
    α = abs.(collect(1:W.n)' .- collect(1:W.m))
    W = ones(Complex{BigFloat}, W.m, W.n, x_dim, p_dim)

    # (-1)^m on upper trianglar
    for i in 1:2:W.m
        W[i, i:W.n, :, :] .*= -1
    end

    # (-1)^n on lower trianglar
    for j in 1:2:W.n
        W[(j+1):W.m, j, :, :] .*= -1
    end

    W .*= exp(- 0.5 * abs2.(Z)) ./ π
    W .*= sqrt.(factorial_ij.(collect(1:W.m), collect(1:W.n)'))

    # W .*= (x .- p*imag_sign(wf)).^α
    # W .*= laguerre.(M, α, 2z)

    reshape(sum(W .* wf.ρ, dims=(1,2)), x_dim, p_dim)
end

function wigner(m::Vector{T}, n::Vector{T}, x::Vector{S}, p::Vector{S}) where {T<:Integer,S<:Real}
    n = n'
    α = n .- m
    imag = sign.(α) .* im
    α .= abs.(α)
    M = min.(m, n)
    N = max.(m, n)
    z = x^2 + p^2

    W = (-1).^M / π * exp(-z)
    W = complex.(W .* sqrt.((2).^α ./ factorial_ij.(M.+1, N)))
    W .*= (x .- p*imag).^α
    W .*= laguerre.(M, α, 2*z)

    return W
end

gen_wigner(ρ) = (x, p) -> sum(ρ .* wigner(collect(1:size(ρ,1)), collect(1:size(ρ,2)), x, p))
