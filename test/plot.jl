using SqState
using Plots
plotly()

function main()
    @info "Initialising"

    data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "SQ4"
    ρ = read_ρ(data_path, data_name)

    x_range = -5:0.1:5
    p_range = -5:0.1:5
    start_time = time()
    wf = WignerFunction(x_range, p_range)
    end_time = time()

    @info "Done, took $(end_time - start_time)(s)"

    start_time = time()
    w = wf(ρ)
    lim = maximum(abs.(w))
    p = heatmap(
        x_range,
        p_range,
        w,
        title="Wigner Function",
        xlabel="X",
        ylabel="P",
        # xticks=x_range,
        # yticks=p_range,
        clim=(-lim, lim),
        c=cgrad([
            RGBA(53/255, 157/255, 219/255, 1),
            RGBA(240/255, 240/255, 240/255, 1),
            RGBA(219/255, 64/255, 68/255, 1)
        ]),
        size=(900, 825)
    )
    end_time = time()
    @info "Render time: $(end_time - start_time)(s)"

    return p
end

main()
