using SqState
using Test

@testset "SqState.jl" begin

    include("read.jl")
    include("utils.jl")
    include("polynomial.jl")
    include("wigner.jl")
    include("render.jl")

end
