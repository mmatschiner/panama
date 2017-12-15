# m_matschiner Thu Dec 14 15:43:14 CET 2017

# Remove output of previous runs of this script.
rm -rf ../res/*

# Prepare snapp analyses.
bash prepare_snapp_analyses.sh

# Run snapp analyses.
bash run_snapp_analyses.sh

# Generate MCC trees summarizing the posterior tree distributions of both analyses.
bash generate_mcc_trees.sh