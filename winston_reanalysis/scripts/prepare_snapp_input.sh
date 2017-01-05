# m_matschiner Mon Dec 12 00:52:04 CET 2016

# Make the XML data directory if it does not exist yet.
mkdir -p ../data/xml

# Generate XML input files for SNAPP analyses of the ant phylogeny.
ruby resources/snapp_prep.rb -p ../data/alignments/concatenated_data_matrix_filtered.phy -t ../data/tables/species.txt -c ../data/constraints/constraints.txt -s ../data/trees/starting.tre -l 200000 -x ../data/xml/eciton.xml -o eciton
