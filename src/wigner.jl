export
    wigner,
    WignerFunction

#=
    Wigner function by Laguerre Polynominal
=#

function wigner(m::Integer, n::Integer, x::Real, p::Real)
    w = gaussian_function(x, p)
    w *= coefficient_of_wave_function(m, n)
    w *= z_to_power(m, n, x, p)
    w *= laguerre(m, n, x, p)

    return w
end

wigner(m::Integer, n::Integer) = (x, p)->wigner(m, n, x, p)

mutable struct WignerFunction{T<:Integer}
    m_dim::T
    n_dim::T
    xs
    ps
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
        new{T}(m_dim, n_dim, xs, ps, W)
    end
end

function WignerFunction(m_dim::T, n_dim::T) where {T<:Integer}
    return WignerFunction(m_dim, n_dim, [], [])
end

function WignerFunction(xs::Vector, ps::Vector)
    return WignerFunction(0, 0, xs, ps)
end

function WignerFunction(xs::StepRangeLen, ps::StepRangeLen; ρ_size=35)
    return WignerFunction(ρ_size, ρ_size, xs, ps)
end

function (wf::WignerFunction)(ρ::AbstractMatrix)
    reshape(real(sum(ρ .* wf.W, dims=(1, 2))), length(wf.xs), length(wf.ps))
end

#=
    Wigner function by Fourier transform
=#

function wigner(x, p)
end
