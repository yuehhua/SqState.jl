using SqState
using Plots

export
    Heatmap,
    Contour,
    plot_wigner

abstract type PlotMethod end

struct Heatmap <: PlotMethod end

struct Contour <: PlotMethod end

const C_GRAD = cgrad([
    RGBA(53/255, 157/255, 219/255, 1),
    RGBA(240/255, 240/255, 240/255, 1),
    RGBA(219/255, 64/255, 68/255, 1)
])

function plot_wigner(
    wf::WignerFunction, w::AbstractMatrix, ::Type{Heatmap};
    save=false, file_path="wigner.png"
)
    gr(size=(900, 825))
    lim = maximum(abs.(w))
    p = heatmap(
        wf.xs, wf.ps, w,
        title="Wigner Function",
        xlabel="X",
        ylabel="P",
        clim=(-lim, lim),
        c=C_GRAD,
    )

    save && savefig(p, file_path)

    return p
end

function plot_wigner(
    wf::WignerFunction, w::AbstractMatrix, ::Type{Contour};
    save=false, file_path="wigner.png"
)
    gr(size=(900, 825))
    lim = maximum(abs.(w))
    p = contour(
        wf.xs, wf.ps, w,
        title="Wigner Function",
        xlabel="X",
        ylabel="P",
        clim=(-lim, lim),
        fill=true,
        c=C_GRAD,
    )

    save && savefig(p, file_path)

    return p
end
