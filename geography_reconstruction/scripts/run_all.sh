# m_matschiner Fri Dec 9 11:31:26 CET 2016

# Add fossil taxa to all phylogenies of the posterior tree set.
bash add_fossils.sh

# Perform ancestral reconstruction of the geography with stochastic mapping.
bash run_stochastic_mapping.sh

# Plot trees with mapped ancestral reconstruction.
bash plot_trees_with_geography.sh

# Perform ancestral reconstruction with the structured coalescent implemented in basta.
bash run_basta.sh

# Generate MCC summary trees with annotation.
bash produce_mcc_trees.sh

# Get the distributions of selected migration times from the results of the stochastic mapping analysis.
bash get_divergence_times.sh
