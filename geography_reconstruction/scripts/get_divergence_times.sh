# m_matschiner Tue Dec 13 12:14:23 CET 2016

# Extract the divergence time between C. tuyra and C. nuchalis/C. wayuu.
ruby get_species_age.rb ../data/trees/ariidae_1000.trees "Ctu" ../analysis/stochastic_mapping/tables/divergence_times_ctu.txt

# Extract the divergence time between N. biffi and N. grandicassis.
ruby get_species_age.rb ../data/trees/ariidae_1000.trees "Nbi" ../analysis/stochastic_mapping/tables/divergence_times_nbi.txt

# Extract the divergence time between B. panamensis and B. bagre/B. marinus.
ruby get_species_age.rb ../data/trees/ariidae_1000.trees "Bpa" ../analysis/stochastic_mapping/tables/divergence_times_bpa.txt

# Extract the divergence time between N. quadriscutis and other species within Notarius.
ruby get_species_age.rb ../data/trees/ariidae_1000.trees "Nqu" ../analysis/stochastic_mapping/tables/divergence_times_nqu.txt