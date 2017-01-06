# m_matschiner Sun Nov 13 00:00:41 CET 2016

# Make the output directory if it doesn't exist yet.
mkdir -p ../analysis/combined

# Use the script get_proportional_node_age_errors.rb to get the proportional age errors from SNAPP and concatenated BEAST analyses.
# With age constraints on the root node.
ruby plot_proportional_node_age_errors.rb ../analysis/beast/ex3/root/summary/node_ages.txt ../analysis/snapp/ex2/variants_corrected/summary/node_ages.txt ../analysis/combined/experiment3a.svg
# With age constraints on younger nodes.
ruby plot_proportional_node_age_errors.rb ../analysis/beast/ex3/young/summary/node_ages.txt ../analysis/snapp/ex1/young/m/summary/node_ages.txt ../analysis/combined/experiment3b.svg