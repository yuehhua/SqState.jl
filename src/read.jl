using HDF5

export read_ρ

function read_ρ(data_path::String, data_name::String)
    ρ_real = h5open(data_path, "r") do file
        read(file, "$data_name/real")
    end
    ρ_imag = h5open(data_path, "r") do file
        read(file, "$data_name/imag")
    end

    return complex.(ρ_real', ρ_imag')
end
