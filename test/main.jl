using SqState

function main()
    ########################
    # init wigner function #
    ########################
    x_range = -10:0.1:10
    p_range = -10:0.1:10
    @info "Initialising"
    start_time = time()
    wf = WignerFunction(x_range, p_range)
    end_time = time()
    @info "Done, took $(end_time - start_time)(s)"

    ##########
    # render #
    ##########
    data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "sq4"
    ρ = read_ρ(data_path, data_name)
    w = wf(ρ)

    ########
    # plot #
    ########
    file_path = joinpath(SqState.PROJECT_PATH, "../data/render", "wigner_contour.png")
    p = plot_wigner(wf, w, Contour, save=true, file_path=file_path)
    file_path = joinpath(SqState.PROJECT_PATH, "../data/render", "wigner_heatmap.png")
    p = plot_wigner(wf, w, Heatmap, save=true, file_path=file_path)
    file_path = joinpath(SqState.PROJECT_PATH, "../data/render", "wigner_surface.png")
    p = plot_wigner(wf, w, Surface, save=true, file_path=file_path)

    return p
end

main()
