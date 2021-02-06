@testset "plot wigner" begin
    x_range = -5:1.0:5
    p_range = -5:1.0:5
    wf = WignerFunction(x_range, p_range)

    ρ = ones(ComplexF64, 35, 35)
    w = wf(ρ)

    file_path = "wigner.png"
    
    plot_wigner(wf, w, Heatmap, file_path=file_path)
    @test isfile(file_path)
    isfile(file_path) && rm(file_path)

    plot_wigner(wf, w, Contour, file_path=file_path)
    @test isfile(file_path)
    isfile(file_path) && rm(file_path)

    plot_wigner(wf, w, Surface, file_path=file_path)
    @test isfile(file_path)
    isfile(file_path) && rm(file_path)
end
