# m_matschiner Mon Sep 19 11:31:51 CEST 2016

# Use the phylsim and the fileutils libraries.
$libPath = "./resources/phylsim/"
require "./resources/phylsim/main.rb"
require 'fileutils'

# Set the output directory.
output_dir = "../analysis/simulations"

# Set the number of replicate species trees.
number_of_replicates = 100

# Simulate species trees with phylsim.
number_of_replicates.times do |x|
	tree = Tree.generate(lambda = 0.0000004, mu = 0, treeOrigin = [0,20000000], present = 0, k = 0, rootSplit = true, np = 20)
	dir_name = "r#{(x+1).to_s.rjust(4).gsub(" ","0")}"
	FileUtils.mkdir_p("#{output_dir}/#{dir_name}")
	tree.to_newick(fileName = "#{output_dir}/#{dir_name}/species.tre", branchLengths = "duration", labels = true, plain = false, includeEmpty = true, overwrite = true, verbose = false)
end