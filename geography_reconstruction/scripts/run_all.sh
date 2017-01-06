# m_matschiner Fri Dec 9 11:31:26 CET 2016

# Add fossil taxa to all phylogenies of the posterior tree set.
bash add_fossils.sh

# Perform ancestral reconstruction of the geography.
bash run_reconstruction.sh

# Plot trees with mapped ancestral reconstruction.
bash plot_trees_with_geography.sh

# Generate a MCC summary tree with annotation.
bash produce_mcc_tree.sh

# Get the distributions of selected migration times.
bash get_divergence_times.sh