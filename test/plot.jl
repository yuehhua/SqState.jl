using SqState
using Plots
plotly()

function main()
    @info "Initialising"
    t = time()

    data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "sq4"
    ρ = read_ρ(data_path, data_name)

    x_range = -5:1.0:5
    p_range = -5:1.0:5
    w = W(x_range, p_range)

    @info "Done, took $(time() - t)(s)"

    t = time()
    wig = wigner(ρ, w)
    p = heatmap(
        wig,
        title="Wigner Function",
        xticks=[],
        yticks=[],
        c=:bluesreds,
        size=(1200, 1100)
    )
    @info "Render time: $(time() - t)(s)"

    return p
end

main()
