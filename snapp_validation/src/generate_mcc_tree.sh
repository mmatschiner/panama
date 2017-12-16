# m_matschiner Tue Oct 25 23:55:30 CEST 2016

# Get the command line arguments.
trees_file_name=$1
tree_file_name=$2

# Use TreeAnnotator to generate a maximum clade credibility tree.
java -jar resources/treeannotator.jar -burnin 10 -heights mean ${trees_file_name} ${tree_file_name} 2> /dev/null