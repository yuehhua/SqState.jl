using SqState
using HDF5
using Plots

const SCRIPT_PATH = @__DIR__

function main()
    data_path = joinpath(SCRIPT_PATH, "../data", "dm.h5")
    ρ = read_ρ(data_path)

    x = collect(-5:0.1:5)
    p = collect(-5:0.1:5)
    wf = SqState.WignerFunction(ρ)

    W = wf(x, p)
end

main()
