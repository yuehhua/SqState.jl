using HDF5

@testset "read" begin
    file_name = "test_hdf5.h5"
    data_name = "test_dm"
    n = 35

    arr_real = rand(n, n)
    arr_imag = rand(n, n)
    h5write(file_name, "$data_name/real", arr_real)
    h5write(file_name, "$data_name/imag", arr_imag)

    # the transpose is due to the col-majer and row-majer difference between python and julia
    @test read_ρ(file_name, data_name) == complex.(arr_real', arr_imag')

    rm(file_name)
end
