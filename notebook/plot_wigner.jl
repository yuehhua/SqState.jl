### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ d393a05a-6532-11eb-04b2-35f9af4bdbc2
begin
	using SqState
	using Plots
	gr(fmt=:png)
end;

# ╔═╡ 2279cfae-6534-11eb-04bd-e7ce1910fc83
md"
# Plot Wigner Function

JingYu Ning"

# ╔═╡ e46bc790-6532-11eb-2c16-3b43640c7653
md"## Initial Wigner function"

# ╔═╡ f7af8256-6532-11eb-066b-d55e91cddc92
begin
	x_range = -10:0.1:10
	p_range = -10:0.1:10
	wf = WignerFunction(x_range, p_range)
end;

# ╔═╡ 2fe499fe-6533-11eb-0bcd-9d00d9b4e1d0
md"## Render Wigner function"

# ╔═╡ 125c6e66-6533-11eb-03b4-7122cc3e5806
begin
	data_path = joinpath(SqState.PROJECT_PATH, "../data", "dm.hdf5")
    data_name = "sq4"
    ρ = read_ρ(data_path, data_name)
    w = wf(ρ)
end;

# ╔═╡ 6cb3a712-6533-11eb-34f3-6339e020be33
md"## Plot"

# ╔═╡ a24789e8-6533-11eb-2bb9-db79fb1c365c
md"**Heatmap**"

# ╔═╡ 7f9264d6-6533-11eb-1c6c-434909802cb5
plot_wigner(wf, w, Heatmap)

# ╔═╡ 903502b0-6533-11eb-2ed0-0d1bcfe1fe99
md"**Contour**"

# ╔═╡ 0da7f0fc-6538-11eb-0aa7-e1635323a04d
plot_wigner(wf, w, Contour)

# ╔═╡ Cell order:
# ╟─2279cfae-6534-11eb-04bd-e7ce1910fc83
# ╠═d393a05a-6532-11eb-04b2-35f9af4bdbc2
# ╟─e46bc790-6532-11eb-2c16-3b43640c7653
# ╠═f7af8256-6532-11eb-066b-d55e91cddc92
# ╟─2fe499fe-6533-11eb-0bcd-9d00d9b4e1d0
# ╠═125c6e66-6533-11eb-03b4-7122cc3e5806
# ╟─6cb3a712-6533-11eb-34f3-6339e020be33
# ╟─a24789e8-6533-11eb-2bb9-db79fb1c365c
# ╠═7f9264d6-6533-11eb-1c6c-434909802cb5
# ╟─903502b0-6533-11eb-2ed0-0d1bcfe1fe99
# ╠═0da7f0fc-6538-11eb-0aa7-e1635323a04d
