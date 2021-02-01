using SqState

function main()
    x_range = -5:0.1:5
    p_range = -5:0.1:5
    wf = init_wf(x_range, p_range)

    data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "SQ4"
    ρ = read_ρ(data_path, data_name)
    p, w = render(ρ, wf, save=true)

    # println(w)

    return p
end

main()
