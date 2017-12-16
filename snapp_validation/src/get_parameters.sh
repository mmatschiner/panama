# m_matschiner Tue Oct 25 23:59:02 CEST 2016

# Get parameter estimates and true values for all analyses of experiment 2.
for type in "variants_corrected" "invariants_added" "variants_corrected" "variants_uncorrected"
do
	echo "Analysing replicates of analysis type ${type}..."
	let count=0
	echo -e "replicate_id\tclock_rate_mean\tclock_rate_lower\tclock_rate_upper\ttheta_mean\ttheta_lower\ttheta_upper\tpop_size_mean\tpop_size_upper\tpop_size_lower" > ../analysis/snapp/ex2/${type}/summary/parameter_estimates.txt
	for i in ../analysis/snapp/ex2/${type}/r????
	do
		let count+=1
		replicate_id=`basename ${i}`
		echo "Analysing replicate ${replicate_id}..."
		echo -ne "${replicate_id}\t" >> ../analysis/snapp/ex2/${type}/summary/parameter_estimates.txt
		
		# Get the clock rate, theta, and population size estimates.
		ruby get_parameters.rb ../analysis/snapp/ex2/${type}/${replicate_id}/snapp_w_theta.log >> ../analysis/snapp/ex2/${type}/summary/parameter_estimates.txt
		echo >> ../analysis/snapp/ex2/${type}/summary/parameter_estimates.txt
	done
done

# Get parameter estimates and true values for all analyses of experiment 5.
for sample_size in "tiny_sample" "large_sample"
do
	echo "Analysing replicates of analyses with sample size ${sample_size}..."
	let count=0
	echo -e "replicate_id\tclock_rate_mean\tclock_rate_lower\tclock_rate_upper\ttheta_mean\ttheta_lower\ttheta_upper\tpop_size_mean\tpop_size_upper\tpop_size_lower" > ../analysis/snapp/ex5/${sample_size}/summary/parameter_estimates.txt
	for i in ../analysis/snapp/ex5/${sample_size}/r????
	do
		let count+=1
		replicate_id=`basename ${i}`
		echo "Analysing replicate ${replicate_id}..."
		echo -ne "${replicate_id}\t" >> ../analysis/snapp/ex5/${sample_size}/summary/parameter_estimates.txt
		
		# Get the clock rate, theta, and population size estimates.
		ruby get_parameters.rb ../analysis/snapp/ex5/${sample_size}/${replicate_id}/snapp_w_theta.log >> ../analysis/snapp/ex5/${sample_size}/summary/parameter_estimates.txt
		echo >> ../analysis/snapp/ex5/${sample_size}/summary/parameter_estimates.txt
	done
done
