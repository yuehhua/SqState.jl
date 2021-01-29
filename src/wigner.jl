export
    wigner,
    WignerFunction

#=
    Wigner function by Laguerre Polynominal
=#

function wigner(m::Integer, n::Integer, x::Real, p::Real)
    w = gaussian_function(x, p)
    w *= combination_number(m, n)
    w *= z_to_power(m, n, x, p)
    w *= laguerre(m, n, x, p)

    return w
end

wigner(m::Integer, n::Integer) = (x, p)->wigner(m, n, x, p)

mutable struct WignerFunction{T<:Integer}
    m_dim::T
    n_dim::T
    x
    p
    W::Array{ComplexF64,4}

    function WignerFunction(m_dim::T, n_dim::T, xs, ps) where {T<:Integer}
        if m_dim != 0 && n_dim != 0 && !isempty(xs) && !isempty(ps)
            W = Array{ComplexF64,4}(undef, m_dim, n_dim, length(xs), length(ps))
            for m = 1:m_dim, n = 1:n_dim, (x_i, x) = enumerate(xs), (p_j, p) = enumerate(ps)
                W[m, n, x_i, p_j] = wigner(m ,n, x, p)
            end
        else
            W = Array{ComplexF64,4}(undef, 0, 0, 0, 0)
        end
        new{T}(m_dim, n_dim, x, p, W)
    end
end

function WignerFunction(m_dim::T, n_dim::T) where {T<:Integer}
    return WignerFunction(m_dim, n_dim, [], [])
end

function WignerFunction(x::Vector, p::Vector)
    return WignerFunction(0, 0, x, p)
end

function WignerFunction(x_range::StepRangeLen, p_range::StepRangeLen; ρ_size=35)
    return WignerFunction(ρ_size, ρ_size, x_range, p_range)
end

function (wf::WignerFunction)(ρ::AbstractMatrix)
    reshape(real(sum(ρ .* wf.W, dims=(1, 2))), length(wf.x), length(wf.p))
end

#=
    Wigner function by Fourier transform
=#

function wigner(x, p)
end
