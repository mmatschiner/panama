# m_matschiner Sun Dec 11 22:49:20 CET 2016

# Download the original alignment from DRYAD.
bash get_alignment.sh

# Reduce the size of the original alignment.
bash filter_alignment.sh

# Prepare an XML input file for SNAPP using snapp_prep.rb.
bash prepare_snapp_input.sh

# Prepare the SNAPP analyses.
bash prepare_snapp_analyses.sh

# Run SNAPP analyses.
echo "SNAPP analyses must be run outside of this script. Once they have finished, use the remaining commands in this script to complete the analysis."
exit

# Add the theta parameter from the .trees files to the .log files and calculate the population size.
bash add_theta_to_log.sh

# Combine the log and trees files of the five run replicates.
bash combine_results.sh

# Produce a maximum-clade-credibility summary tree.
bash produce_mcc_tree.sh