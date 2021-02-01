@testset "init wigner function" begin
    x_range = -5:1.0:5
    p_range = -5:1.0:5
    wf = init_wf(x_range, p_range)
end

@testset "render" begin
    x_range = -5:1.0:5
    p_range = -5:1.0:5
    wf = init_wf(x_range, p_range)

    data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "SQ4"
    p, w = render(data_path, data_name, wf, save=true)
end
