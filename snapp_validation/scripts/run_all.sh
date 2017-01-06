# m_matschiner Mon Sep 19 11:31:13 CEST 2016

# Simulate species trees with the phylsim library.
ruby simulate_species_trees.rb

# Translate species trees so that branch lengths are in millions of years.
bash scale_species_trees.sh

# Simulate gene trees using the DendroPy library.
bash simulate_gene_trees.sh

# Simulate sequences along each gene tree using the phylsim library.
bash simulate_sequences.sh

# Reduce the data set by subsampling SNPs
bash subsample_snps.sh

# Prepare SNAPP input files.
bash prepare_snapp_input.sh

# Prepare directories for SNAPP analyses.
bash prepare_snapp_analyses.sh

# Prepare BEAST input for the concatenated analyses.
bash prepare_beast_input.sh

# Prepare directories for the concatenated BEAST analyses.
bash prepare_beast_analyses.sh

# Run SNAPP analyses.
echo "SNAPP analyses must be run outside of this script. Once they have finished, use the remaining commands in this script to complete the analysis."
exit

# Run BEAST analyses for concatenated datasets locally.
bash run_beast.sh

# Get run statistics, including the number of patterns in each subsampled SNP set, the time required per iteration, and the iterations required for convergence.
bash get_run_statistics.sh

# Plot the run statistics.
bash plot_run_statistics.sh

# Extract theta estimates from .trees files and generate new .log files that also include these and the resulting population size estimates.
bash add_theta_to_logs.sh

# Compare node age estimates.
bash compare_node_ages.sh

# Plot true node ages and node age estimates.
bash plot_estimates.sh

# Get true values and estimates of the clock rates and theta as well as mean node age errors.
bash get_parameters.sh

# Produce plots for the parameters estimated in analyses of experiment 2.
bash plot_parameters.sh

# Produce a plot of proportional node age error for the analyses of experiment 3.
bash plot_proportional_node_age_errors.sh
