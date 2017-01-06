# m_matschiner Wed Oct 19 23:00:44 CEST 2016

# Make one of the output directories that may not exist yet.
mkdir -p ../analysis/tables

# Plot a subset of trees.
ruby plot_trees_with_geography.rb ../analysis/trees/ariidae_w_fossils_mapped_1000.trees ../analysis/trees/ariidae_w_fossils_annotated_1000.trees ../analysis/tables/migration_times.txt ../data/tables/species_order.txt ../analysis/trees/ariidae_w_fossils_mapped_1000.svg