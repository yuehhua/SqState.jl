using SqState
using HDF5
using Plots

const SCRIPT_PATH = @__DIR__

function read_ρ()
    data_path = joinpath(SCRIPT_PATH, "../data", "dm.hdf5")

    ρ_real = h5open(data_path, "r") do file
        read(file, "sq4/real")
    end
    ρ_imag = h5open(data_path, "r") do file
        read(file, "sq4/imag")
    end

    return complex.(ρ_real, -ρ_imag)
end

function main()
    @info "Initialising"
    ρ = read_ρ()
    w = W(-5:0.1:5, -3:0.1:3)
    @info "Done"

    wig = wigner(ρ, w)
end

main()
