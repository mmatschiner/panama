# m_matschiner Sun Dec 11 22:50:00 CET 2016

# Uncompress the original alignment file.
tar -xzf ../data/alignments/concatenated_data_matrix.phy.tgz

# Make a separate directory for the output nexus file if it doesn't exist yet.
mkdir -p ../data/alignments/nexus

# Generate a reduced version of the original alignment, with only one individual per species.
ruby reduce_alignment.rb concatenated_data_matrix.phy ../data/tables/species1.txt ../data/alignments/nexus/concatenated_data_matrix_reduced.nex

# Translate alignment ids (specimens for species) in the reduced version of the original alignment.
ruby translate_alignment_ids.rb ../data/alignments/nexus/concatenated_data_matrix_reduced.nex ../data/tables/species1.txt ../data/alignments/nexus/concatenated_data_matrix_reduced_translated.nex

# Clean up.
rm concatenated_data_matrix.phy
rm ../data/alignments/nexus/concatenated_data_matrix_reduced.nex
