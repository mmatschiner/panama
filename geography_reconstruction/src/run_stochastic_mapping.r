# m_matschiner Sat Dec 10 14:58:22 CET 2016

# Load the phytools library.
library(phytools)
require(methods)

# Get the command line arguments.
args <- commandArgs(trailingOnly = TRUE)
input_tree_file_name <- args[1]
output_tree_file_name <- args[2]
table_name <- args[3]

# Read the temporary newick string.
tree <- read.tree(input_tree_file_name)

# Read the table with geography information.
x <- read.table(table_name)
geography <- x$V2
names(geography) <- x$V1

# Use phytool's stochastic mapping to infer changes to the geography along the tree.
mtree <- make.simmap(tree, geography, nsim=1, Q="empirical", type="discrete", model="ER", message=FALSE, pi="equal")

# Write the tree with mapped geography in simmap format.
write.simmap(mtree, output_tree_file_name, map.order="right-to-left")
