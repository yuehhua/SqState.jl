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
    size=(700, 630),
    file_path=nothing
)
    gr(size=size)
    lim = maximum(abs.(w))
    p = Plots.heatmap(
        wf.xs, wf.ps, w,
        title="Wigner Function",
        xlabel="X",
        ylabel="P",
        clim=(-lim, lim),
        c=C_GRAD,
    )

    isnothing(file_path) || savefig(p, file_path)

    return p
end

function plot_wigner(
    wf::WignerFunction, w::AbstractMatrix, ::Type{Contour};
    size=(700, 630),
    file_path=nothing
)
    gr(size=size)
    lim = maximum(abs.(w))
    p = Plots.contour(
        wf.xs, wf.ps, w,
        title="Wigner Function",
        xlabel="X",
        ylabel="P",
        clim=(-lim, lim),
        fill=true,
        levels=20,
        c=C_GRAD,
    )

    isnothing(file_path) || savefig(p, file_path)

    return p
end

function plot_wigner(
    wf::WignerFunction, w::AbstractMatrix, ::Type{Surface};
    size=(700, 630),
    file_path=nothing
)
    lim = maximum(abs.(w))
    gp = "set contour base; unset key"
    p = surf(
        wf.xs, wf.ps, w,
        plotstyle="pm3d",
        Axes(
            title=:Wigner_Function,
            xlabel=:X,
            ylabel=:P,
            cbrange=(-lim, lim),
            grid=:on,
            view=(60, 315),
            palette="defined (-$lim '#239DDB', 0 '#F0F0F0', $lim '#DB4044')"
        ),
    )

    isnothing(file_path) || save(
        term="png",
        output=file_path,
        saveopts="font 'Consolas,10' size $(size[1]),$(size[2])"
    )

    return p
end
