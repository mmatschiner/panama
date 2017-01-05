# m_matschiner Tue Nov 29 17:54:10 CET 2016

# Make the alignments directory if it doesn't exist yet.
mkdir -p ../data/alignments

# Download the original alignment file.
wget http://datadryad.org/bitstream/handle/10255/dryad.121160/concatenated_data_matrix.phy

# Compress the original alignment file.
tar -czf concatenated_data_matrix.phy.tgz concatenated_data_matrix.phy

# Remove the uncompressed alignment file.
rm concatenated_data_matrix.phy

# Move the original alignment to the alignments directory.
mv concatenated_data_matrix.phy.tgz ../data/alignments