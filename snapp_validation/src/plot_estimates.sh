# m_matschiner Sun Oct 2 01:22:20 CEST 2016

# Plot the true and estimated node ages for all analyses of experiment 1.
for calibration_type in root young
do
	for sample_size in s m l
	do
		summary_dir="../res/snapp/ex1/${calibration_type}/${sample_size}/summary"
		ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
	done
done

# Plot the true and estimated node ages for all analyses of experiment 2.
for population_size in large_pop huge_pop
do
	summary_dir="../res/snapp/ex2/${population_size}/summary"
	ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
done

# Plot the true and estimated node ages for all analyses of experiment 3.
for sample_size in large_sample tiny_sample
do
	summary_dir="../res/snapp/ex3/${sample_size}/summary"
	ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
done

# Plot the true and estimated node ages for all analyses of experiment 4.
for type in invariants_added variants_corrected variants_uncorrected
do
	summary_dir="../res/snapp/ex4/${type}/summary"
	ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
done

# Plot the true and estimated node ages for all analyses of experiment 5.
summary_dir="../res/beast/ex5/root/summary"
ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
summary_dir="../res/beast/ex5/young/summary"
ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
summary_dir="../res/beast/ex5/root_200000/summary"
ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt
summary_dir="../res/beast/ex5/root_800000/summary"
ruby plot_estimates.rb ${summary_dir}/node_ages.txt ${summary_dir}/node_ages.svg ${summary_dir}/node_ages.stats.txt

