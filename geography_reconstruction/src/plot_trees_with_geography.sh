# m_matschiner Wed Oct 19 23:00:44 CEST 2016

# Make one of the output directories that may not exist yet.
mkdir -p ../res/stochastic_mapping/tables

# Plot a subset of trees.
ruby plot_trees_with_geography.rb ../res/stochastic_mapping/trees/ariidae_w_fossils_mapped_1000.trees ../res/stochastic_mapping/trees/ariidae_w_fossils_annotated_1000.trees ../res/stochastic_mapping/tables/migration_times.txt ../data/tables/species_order.txt ../res/stochastic_mapping/trees/ariidae_w_fossils_mapped_1000.svg