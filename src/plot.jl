using SqState
using Plots
using Gaston

export
    Heatmap,
    Contour,
    plot_wigner,
    Surface

abstract type PlotMethod end

struct Heatmap <: PlotMethod end

struct Contour <: PlotMethod end

struct Surface <: PlotMethod end

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
    p = Plots.heatmap(
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
    p = Plots.contour(
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

function plot_wigner(
    wf::WignerFunction, w::AbstractMatrix, ::Type{Surface};
    save=false, file_path="wigner.png"
)
    p = surf(
        wf.xs, wf.ps, w,
        with = "pm3d",
        Axes(
            title=:Wigner_Function,
            view=(45, 45),
            cbrange=(-3, 3),
        )
    )

    # save && save(
    #     term="png", output =file_path,
    #     saveopts="font 'Consolas,10' size 900,825"
    # )

    return p
end
