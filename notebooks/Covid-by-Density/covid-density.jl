### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 01ebd64a-5ab6-11eb-3639-d5dc975d7d36
using CSV, Plots, Dates

# ╔═╡ 460c59ba-5aca-11eb-14c7-bdd62a42d9e9
md"""
# Covid Cases per capita by state, against population density

I live in Rhode Island, which is one of the worst impacted states for covid per capita. We realized that, to be fair, it's also one of the densist states in the US (it's nearly a city-state around Providence - the metro population of Providence is twice the total population of Rhode Island because it bleeds over into Mass and Connecticut!).

But then, we wondered, **is** it actually fair to explain away our bad case rate by our high population density?

We found several articles arguing that in fact, no, there does not seem to be any correlation between cases per capita and population density. However, most of the articles we found so far were using countries as data points, and we were interested in US states. So this notebook explores the data from states, and indeed draws the same conclusions:

**There does not seem to be any correlation between population density and cases per capita.**

The worst cases per capita are in fact mostly in the lowest-density, most rural states. However, among low-density states, there is no trend: some of the best states per capita are also in the lowest-density states. Rhode Island is an outlier, in that it is one of the worst states per capita, but also the second-most-dense state.

The color indicates how old the measurement is, with the darker colors most recent. You can see most states are getting worse over time (which makes sense because I'm plotting _total_ historical cases per capita, so it can only increase).

The most-dense states are on the right, and the least-dense on the left.

"""

# ╔═╡ 83d112a6-5acd-11eb-3e91-07429893cac3
md"""
I left DC out of the above plot, because it's so much more dense, it made the rest hard to read. Here's the plot that includes DC, in case you're interested:
"""

# ╔═╡ a2021860-5acd-11eb-1755-7f3f47d1e9c2
md"""
## Implementation

The rest of this notebook includes the code to build the above plots.

I load the data from three separate CSVs, to get cases per state over time, area, and population, then combine them for the plots.
"""

# ╔═╡ 8a68cf8e-5ac6-11eb-0560-3b02ff2aabdc
maxdays_ago = 30

# ╔═╡ ebc36164-5abb-11eb-3172-5b881a29fd13
md"""
## Covid Cases and Deaths per State over Time
https://healthdata.gov/dataset/united-states-covid-19-cases-and-deaths-state-over-time
"""

# ╔═╡ d664044e-5ab7-11eb-378d-6bb27a04d782
covid_cases_by_state_over_time_csv = CSV.File(homedir()*"/Downloads/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv")

# ╔═╡ 28ce8f2e-5ac2-11eb-12cc-75944ee3c64a
state_abbreviations_csv = CSV.File("state-abbreviations.csv")

# ╔═╡ f06f5e60-5ac1-11eb-3fda-399c7b26751e
state_cases_over_time = Dict(
	(date, state) => total_cases
	for (date, state_abbr1, total_cases) in covid_cases_by_state_over_time_csv
	    for (state, state_abbr2) in state_abbreviations_csv
	if state !== missing && state_abbr1 !== missing &&
		date !== missing && total_cases !== missing &&
		state_abbr1 == state_abbr2
)

# ╔═╡ e5a9184a-5abc-11eb-1601-f5065f5cf01b
md"""
## US State populations over time
https://www.kaggle.com/lucasvictor/us-state-populations-2018
"""

# ╔═╡ da46db22-5abc-11eb-00c7-7d28b9db046a
state_populations_2018_csv = CSV.File("State-Populations.csv")

# ╔═╡ fcc6972c-5ac2-11eb-0f40-ebddc15dd877
state_cases_per_capita_over_time = Dict(
	(date, state1) => total_cases / pop
	for ((date, state1), total_cases) in state_cases_over_time
	    for (state2, pop) in state_populations_2018_csv
	if state1 !== missing && state2 !== missing && pop !== missing &&
		state1 == state2
)

# ╔═╡ c3fe8dd2-5ac2-11eb-3ebc-0bfbc7f039c4
length(state_cases_per_capita_over_time)

# ╔═╡ 6c4d8088-5abe-11eb-2518-a585b3162507
md"""
## US State area
https://www.census.gov/geographies/reference-files/2010/geo/state-area.html
"""

# ╔═╡ dcc1cfa0-5abd-11eb-3e06-5bd237e88f90
state_land_area_csv = CSV.File("state-land-area.csv")

# ╔═╡ 79e91f8e-5abe-11eb-0738-5d7850820417
state_population_density = Dict(
	state1 => pop / parse(Int, replace(area, ','=>""))
	for (state1, pop) in state_populations_2018_csv
		for (state2, area) in state_land_area_csv
	if state1 !== missing && state2 !== missing &&
		area !== missing && pop !== missing &&
		state1 == state2
)

# ╔═╡ 6349d888-5ac8-11eb-0fcd-d1bc5acc0083
state_densities = sort([
	(abbr, density)
		for (state1, density) in state_population_density
	    for (state2, abbr) in state_abbreviations_csv
			if state1==state2
], by=first)

# ╔═╡ 3f1865ec-5ac8-11eb-25be-dd710515f1ae
xticks_states = (last.(state_densities), first.(state_densities))

# ╔═╡ f4260f7a-5ac3-11eb-2fc5-6b7449db7df2
points_no_dc = [
	(density, cases_per_capita)
	for (state1, density) in state_population_density
		for ((date, state2), cases_per_capita) in state_cases_per_capita_over_time
	if state1 == state2
				&& (today()-Date(date, "mm/dd/yyyy")).value < maxdays_ago &&
			state1 !== "District of Columbia"
]

# ╔═╡ 0dc35ba6-5ac9-11eb-1d8a-87dbf4963e67
points = [
	(density, cases_per_capita)
	for (state1, density) in state_population_density
		for ((date, state2), cases_per_capita) in state_cases_per_capita_over_time
	if state1 == state2
				&& (today()-Date(date, "mm/dd/yyyy")).value < maxdays_ago
]

# ╔═╡ daf6f3e2-5ac4-11eb-255b-850acbd2ca3d
color = Dict(
	(density, cases_per_capita) => (today()-Date(date, "mm/dd/yyyy")).value
	for (state1, density) in state_population_density
		for ((date, state2), cases_per_capita) in state_cases_per_capita_over_time
	if state1 == state2
				&& (today()-Date(date, "mm/dd/yyyy")).value < maxdays_ago
)

# ╔═╡ 058d8c62-5ac8-11eb-3787-91df3e1e554b
scatter(
	points_no_dc,
	marker_z = (a,b)->color[(a,b)],
	seriescolor = cgrad([:blue, :white]),
	markersize = 2,
	markerstrokewidth = 0,
	ylabel = "total cases per capita",
	xlabel = "population density",
	colorbar_title = "days ago",
	xticks = xticks_states,
	)

# ╔═╡ d9117626-5ac2-11eb-1b30-bd0444bd53d1
scatter(
	points,
	marker_z = (a,b)->color[(a,b)],
	seriescolor = cgrad([:blue, :white]),
	markersize = 2,
	markerstrokewidth = 0,
	ylabel = "total cases per capita",
	xlabel = "population density",
	label = "days ago",
	xticks = xticks_states,
	)

# ╔═╡ e1453c6e-5ac8-11eb-36be-135eb1e51dba
length(state_population_density)

# ╔═╡ 28bf62c6-5ab8-11eb-204c-f72ee14869f5


# ╔═╡ Cell order:
# ╠═01ebd64a-5ab6-11eb-3639-d5dc975d7d36
# ╟─460c59ba-5aca-11eb-14c7-bdd62a42d9e9
# ╠═058d8c62-5ac8-11eb-3787-91df3e1e554b
# ╟─83d112a6-5acd-11eb-3e91-07429893cac3
# ╠═d9117626-5ac2-11eb-1b30-bd0444bd53d1
# ╟─a2021860-5acd-11eb-1755-7f3f47d1e9c2
# ╠═3f1865ec-5ac8-11eb-25be-dd710515f1ae
# ╠═6349d888-5ac8-11eb-0fcd-d1bc5acc0083
# ╠═8a68cf8e-5ac6-11eb-0560-3b02ff2aabdc
# ╠═f4260f7a-5ac3-11eb-2fc5-6b7449db7df2
# ╠═0dc35ba6-5ac9-11eb-1d8a-87dbf4963e67
# ╠═daf6f3e2-5ac4-11eb-255b-850acbd2ca3d
# ╠═e1453c6e-5ac8-11eb-36be-135eb1e51dba
# ╠═79e91f8e-5abe-11eb-0738-5d7850820417
# ╠═c3fe8dd2-5ac2-11eb-3ebc-0bfbc7f039c4
# ╠═fcc6972c-5ac2-11eb-0f40-ebddc15dd877
# ╠═f06f5e60-5ac1-11eb-3fda-399c7b26751e
# ╠═ebc36164-5abb-11eb-3172-5b881a29fd13
# ╠═d664044e-5ab7-11eb-378d-6bb27a04d782
# ╠═28ce8f2e-5ac2-11eb-12cc-75944ee3c64a
# ╠═e5a9184a-5abc-11eb-1601-f5065f5cf01b
# ╠═da46db22-5abc-11eb-00c7-7d28b9db046a
# ╠═6c4d8088-5abe-11eb-2518-a585b3162507
# ╠═dcc1cfa0-5abd-11eb-3e06-5bd237e88f90
# ╠═28bf62c6-5ab8-11eb-204c-f72ee14869f5
