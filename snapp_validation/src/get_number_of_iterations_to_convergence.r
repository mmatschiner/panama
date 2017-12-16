# m_matschiner Mon Oct 17 16:40:19 CEST 2016

# Suppress warnings.
options(warn=-1)

# Load the coda library.
library(coda)

# Read the log file specified as the first command line argument.
args <- commandArgs(trailingOnly = TRUE)
input_table_file_name <- args[1]
mcmc <- read.table(input_table_file_name,header=T)

# Set constants.
burnin_proportion <- 0.1
convergence_ess <- 200

# Get the sample at which for the first time all sample sizes are greater than the convergence_ess value.
convergence_sample_size <- 0
for (last_sample in mcmc$Sample[(0.1*length(mcmc$Sample)):length(mcmc$Sample)]){
	burnin <- burnin_proportion * last_sample
	lowest_effective_sample_size <- min(effectiveSize(subset(mcmc, Sample > burnin & Sample <= last_sample, select = posterior:clockRate)))
	if (lowest_effective_sample_size > convergence_ess){
		convergence_sample_size <- last_sample
		break
	}
}

# Report the result, or "NA" if no convergence could be found.
if (convergence_sample_size > 0){
	cat(convergence_sample_size, sep="\n")
} else {
	cat("NA", sep="\n")
}