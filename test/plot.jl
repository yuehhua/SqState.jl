using SqState
using HDF5
using Plots
plotly()

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
    t = time()
    ρ = read_ρ()
    x_range = -5:0.1:5
    p_range = -3:0.1:3
    w = W(x_range, p_range)
    @info "Done, took $(time() - t)(s)"

    t = time()
    wig = wigner(ρ, w)
    p = heatmap(
        wig,
        title="Wigner Function",
        xticks=[],
        yticks=[],
        c=:bluesreds
    )
    @info "Render time: $(time() - t)(s)"

    return p
end

main()
