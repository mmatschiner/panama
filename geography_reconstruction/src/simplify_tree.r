# m_matschiner Mon Dec 12 16:55:56 CET 2016

# Load the phytools library.
library(ape)
require(methods)

# Get the command line arguments.
args <- commandArgs(trailingOnly = TRUE)
input_tree_file_name <- args[1]
output_tree_file_name <- args[2]

# Read the tree from nexus format.
t <- read.nexus(input_tree_file_name)

# Write the tree in simple newick format.
write.tree(t,output_tree_file_name)