function read_ρ(data_path::String)
    ρ_real = h5open(data_path, "r") do file
        read(file, "sq4/real")
    end
    ρ_imag = h5open(data_path, "r") do file
        read(file, "sq4/imag")
    end

    return complex.(ρ_real', ρ_imag')
end
