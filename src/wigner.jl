export
    W,
    wigner,
    gen_wigner

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

struct W
    ρ_size::Int64
    mn::Array{ComplexF64, 4}
end

function W(x_range::StepRangeLen, p_range::StepRangeLen; ρ_size=35)
    mn = Array{ComplexF64,4}(undef, ρ_size, ρ_size, length(x_range), length(p_range))
    for m in 1:ρ_size, n in 1:ρ_size, (x_i, x) in enumerate(x_range), (p_i, p) = enumerate(p_range)
        mn[m, n, x_i, p_i] = wigner(m, n, x, p)
    end

    return W(ρ_size, mn)
end

function wigner(ρ, w::W)
    reshape(real(sum(ρ .* w.mn, dims=(1, 2))), size(w.mn)[3], size(w.mn)[4])
end

#=
    Wigner function by Fourier transform
=#

function wigner(x, p)
end
