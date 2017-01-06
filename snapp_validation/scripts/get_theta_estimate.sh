# m_matschiner Tue Oct 25 23:57:39 CEST 2016

# Get the command line arguments.
tree_file_name=$1

# Use script generate_mcc_tree to generate a maximum-clade-credibility tree.
bash generate_mcc_tree.sh ${tree_file_name} tmp.tre

# Use the Ruby script get_theta_estimate.rb to extract the theta estimate from the maximum-clade-credibility tree.
ruby get_theta_estimate.rb tmp.tre

# Clean up.
rm tmp.tre