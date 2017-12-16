# m_matschiner Sun Oct 16 23:51:30 CEST 2016

# Get run statistics for all analyses of experiment 1.
for calibration_type in young root
do
	for sample_size in s m l
	do
		mkdir -p ../res/snapp/ex1/${calibration_type}/${sample_size}/summary
		echo "calibration_type sample_size replicate_id number_of_site_patterns time_per_iteration iterations_required" > ../res/snapp/ex1/${calibration_type}/${sample_size}/summary/run_statistics.txt
		for i in ../res/snapp/ex1/${calibration_type}/${sample_size}/r????
		do
			# Get the replicate ID.
			replicate_id=`basename ${i}`
			# Get the number of site patterns from the respective XML file.
			number_of_site_patterns=`ruby get_number_of_site_patterns.rb ${i}/snapp.xml`
			# Get the time per iterations from the respective snapp_out.txt file.
			time_string=`cat ${i}/snapp_out.txt | grep Msamples | tail -n 1 | tr -s " " | cut -d " " -f 9 | sed 's/\/Msamples//g'`
			time_per_iteration=`ruby convert_time_string.rb ${time_string}`
			# Get the number of iterations required for run convergence.
			unset R_HOME
			iterations_required=`rscript get_number_of_iterations_to_convergence.r ${i}/snapp.log`
			# Print statistics.
			echo "${calibration_type} ${sample_size} ${replicate_id} ${number_of_site_patterns} ${time_per_iteration} ${iterations_required}"
		done >> ../res/snapp/ex1/${calibration_type}/${sample_size}/summary/run_statistics.txt
	done
done

# Get run statistics for all analyses of experiment 2.
for pop_size in large_pop huge_pop
do
	mkdir -p ../res/snapp/ex2/${pop_size}/summary
	echo "pop_size replicate_id number_of_site_patterns time_per_iteration iterations_required" > ../res/snapp/ex2/${pop_size}/summary/run_statistics.txt
	for i in ../res/snapp/ex2/${pop_size}/r????
	do
		# Get the replicate ID.
		replicate_id=`basename ${i}`
		# Get the number of site patterns from the respective XML file.
		number_of_site_patterns=`ruby get_number_of_site_patterns.rb ${i}/snapp.xml`
		# Get the time per iterations from the respective snapp_out.txt file.
		time_string=`cat ${i}/snapp_out.txt | grep Msamples | tail -n 1 | tr -s " " | cut -d " " -f 9 | sed 's/\/Msamples//g'`
		time_per_iteration=`ruby convert_time_string.rb ${time_string}`
		# Get the number of iterations required for run convergence.
		unset R_HOME
		iterations_required=`rscript get_number_of_iterations_to_convergence.r ${i}/snapp.log`
		# Print statistics.
		echo "${pop_size} ${replicate_id} ${number_of_site_patterns} ${time_per_iteration} ${iterations_required}"
	done >> ../res/snapp/ex2/${pop_size}/summary/run_statistics.txt
done

# Get run statistics for all analyses of experiment 3.
for specimen_sample_size in large_sample tiny_sample
do
	mkdir -p ../res/snapp/ex3/${specimen_sample_size}/summary
	echo "specimen_sample_size replicate_id number_of_site_patterns time_per_iteration iterations_required" > ../res/snapp/ex3/${specimen_sample_size}/summary/run_statistics.txt
	for i in ../res/snapp/ex3/${specimen_sample_size}/r????
	do
		# Get the replicate ID.
		replicate_id=`basename ${i}`
		# Get the number of site patterns from the respective XML file.
		number_of_site_patterns=`ruby get_number_of_site_patterns.rb ${i}/snapp.xml`
		# Get the time per iterations from the respective snapp_out.txt file.
		time_string=`cat ${i}/snapp_out.txt | grep Msamples | tail -n 1 | tr -s " " | cut -d " " -f 9 | sed 's/\/Msamples//g'`
		time_per_iteration=`ruby convert_time_string.rb ${time_string}`
		# Get the number of iterations required for run convergence.
		unset R_HOME
		iterations_required=`rscript get_number_of_iterations_to_convergence.r ${i}/snapp.log`
		# Print statistics.
		echo "${specimen_sample_size} ${replicate_id} ${number_of_site_patterns} ${time_per_iteration} ${iterations_required}"
	done >> ../res/snapp/ex3/${specimen_sample_size}/summary/run_statistics.txt
done

# Get run statistics for all analyses of experiment 4.
for type in variants_corrected invariants_added  variants_uncorrected
do
	mkdir -p ../res/snapp/ex4/${type}/summary
	echo "type replicate_id number_of_site_patterns time_per_iteration iterations_required" > ../res/snapp/ex4/${type}/summary/run_statistics.txt
	for i in ../res/snapp/ex4/${type}/r????
	do
		# Get the replicate ID.
		replicate_id=`basename ${i}`
		# Get the number of site patterns from the respective XML file.
		number_of_site_patterns=`ruby get_number_of_site_patterns.rb ${i}/snapp.xml`
		# Get the time per iterations from the respective snapp_out.txt file.
		time_string=`cat ${i}/snapp_out.txt | grep Msamples | tail -n 1 | tr -s " " | cut -d " " -f 9 | sed 's/\/Msamples//g'`
		time_per_iteration=`ruby convert_time_string.rb ${time_string}`
		# Get the number of iterations required for run convergence.
		unset R_HOME
		iterations_required=`rscript get_number_of_iterations_to_convergence.r ${i}/snapp.log`
		# Print statistics.
		echo "${type} ${replicate_id} ${number_of_site_patterns} ${time_per_iteration} ${iterations_required}"
	done >> ../res/snapp/ex4/${type}/summary/run_statistics.txt
done
