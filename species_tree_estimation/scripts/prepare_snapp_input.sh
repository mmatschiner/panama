# m_matschiner Fri Oct 14 11:59:13 CEST 2016

# Make the XML directory if it doesn't exist yet.
mkdir -p ../data/xml

# Generate XML input files for the molecular-only SNAPP analyses of the Ariidae phylogeny.
ruby resources/snapp_prep.rb -p ../data/alignments/ariidae.phy -t ../data/tables/species.txt -c ../data/constraints/constraints.txt -s ../data/trees/starting.tre -x ../data/xml/ariidae.xml -o ariidae
