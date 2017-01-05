# m_matschiner Sun Dec 11 22:50:00 CET 2016

# Uncompress the original alignment file.
tar -xzf ../data/alignments/concatenated_data_matrix.phy.tgz

# Generate a filtered alignment with less individuals and sites.
ruby filter_alignment.rb concatenated_data_matrix.phy ../data/tables/species.txt ../data/alignments/concatenated_data_matrix_filtered.phy

# Clean up.
rm concatenated_data_matrix.phy