# m_matschiner Sun Oct 2 01:22:20 CEST 2016

# Plot the true and estimated node ages for all analyses of experiment 1.
for calibration_type in root young
do
	for sample_size in s m l
	do
		summary_dir="../analysis/snapp/ex1/${calibration_type}/${sample_size}/summary"
		ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
	done
done

# Plot the true and estimated node ages for all analyses of experiment 2.
for type in invariants_added variants_corrected variants_uncorrected
do
	summary_dir="../analysis/snapp/ex2/${type}/summary"
	ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
done

# Plot the true and estimated node ages for all analyses of experiment 3.
summary_dir="../analysis/beast/ex3/root/summary"
ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
summary_dir="../analysis/beast/ex3/young/summary"
ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
