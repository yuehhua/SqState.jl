using SqState
using Plots
plotly()

export
    init_wf,
    render

function init_wf(x_range, p_range)
    # @info "Initialising"
    # start_time = time()
    wf = WignerFunction(x_range, p_range)
    # end_time = time()
    # @info "Done, took $(end_time - start_time)(s)"

    return wf
end

function render(ρ::AbstractMatrix, wf::WignerFunction; save=false, file_name="wigner.png")
    # start_time = time()
    w = wf(ρ)
    lim = maximum(abs.(w))
    p = heatmap(
        wf.xs,
        wf.ps,
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
    # end_time = time()
    # @info "Render time: $(end_time - start_time)(s)"

    if save
        savefig(p, joinpath(SqState.PROJECT_PATH, "../data/render", file_name))
    end

    return p, w
end
