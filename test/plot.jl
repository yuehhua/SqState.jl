using SqState
using Plots
plotly()

function main()
    @info "Initialising"

    data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "sq4"
    ρ = read_ρ(data_path, data_name)

    x_range = -5:0.1:5
    p_range = -5:0.1:5
    start_time = time()
    w = WignerFunction(x_range, p_range)
    end_time = time()

    @info "Done, took $(end_time - start_time)(s)"

    start_time = time()
    wig = w(ρ)
    p = heatmap(
        wig,
        title="Wigner Function",
        xticks=[],
        yticks=[],
        c=:bluesreds,
        size=(1200, 1100)
    )
    end_time = time()
    @info "Render time: $(end_time - start_time)(s)"

    return p
end

main()
