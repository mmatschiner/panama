# m_matschiner Fri Oct 14 12:50:30 CEST 2016

# Generate XML input files for the molecular-only SNAPP analyses of Ariidae phylogeny.
bash prepare_snapp_input.sh

# Prepare directories for the molecular-only analyses of the Ariidae phylogeny.
bash prepare_snapp_analyses.sh

# Run SNAPP analyses.
echo "SNAPP analyses must be run outside of this script. Once they have finished, use the remaining commands in this script to complete the analysis."
exit

# Add the theta parameter from the .trees files to the .log files and calculate the population size.
bash add_theta_to_log.sh

# Combine results of replicate SNAPP analyses.
bash combine_results.sh

# Produce subsets of 100 and 1000 trees sampled from the posterior distribution.
bash produce_tree_subsets.sh

# Produce MCC trees.
bash produce_mcc_tree.sh
