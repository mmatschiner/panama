# m_matschiner Sat Oct 1 22:37:56 CEST 2016

# Compare true and estimated node ages for all analyses of experiment 1.
for calibration_type in young root
do
	for sample_size in s m l
	do
		mkdir -p ../res/snapp/ex1/${calibration_type}/${sample_size}/summary
		estimates_file="../res/snapp/ex1/${calibration_type}/${sample_size}/summary/node_ages.txt"
		rm -f ${estimates_file}
		touch ${estimates_file}
		for i in ../res/snapp/ex1/${calibration_type}/${sample_size}/r????
		do
			replicate_id=`basename ${i}`
			echo -n "Analysing replicate ${replicate_id}..."
			rscript translate_trees.r ${i}/snapp.trees ${i}/tmp.trees &> /dev/null
			ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees ${calibration_type} >> ${estimates_file}
			rm ${i}/tmp.trees
			echo " done."
		done
	done
done

# Compare true and estimated node ages for all analyses of experiment 2.
for population_size in huge_pop large_pop
do
	mkdir -p ../res/snapp/ex2/${population_size}/summary
	estimates_file="../res/snapp/ex2/${population_size}/summary/node_ages.txt"
	rm -f ${estimates_file}
	touch ${estimates_file}
	for i in ../res/snapp/ex2/${population_size}/r????
	do
		replicate_id=`basename ${i}`
		echo -n "Analysing replicate ${replicate_id}..."
		rscript translate_trees.r ${i}/snapp.trees ${i}/tmp.trees &> /dev/null
		ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
		rm ${i}/tmp.trees
		echo " done."
	done
done

# Compare true and estimated node ages for all analyses of experiment 3.
for sample_size in tiny_sample large_sample
do
	mkdir -p ../res/snapp/ex3/${sample_size}/summary
	estimates_file="../res/snapp/ex3/${sample_size}/summary/node_ages.txt"
	rm -f ${estimates_file}
	touch ${estimates_file}
	for i in ../res/snapp/ex3/${sample_size}/r????
	do
		replicate_id=`basename ${i}`
		echo -n "Analysing replicate ${replicate_id}..."
		rscript translate_trees.r ${i}/snapp.trees ${i}/tmp.trees &> /dev/null
		ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
		rm ${i}/tmp.trees
		echo " done."
	done
done

# Compare true and estimated node ages for all analyses of experiment 4.
for type in variants_corrected invariants_added variants_uncorrected
do
	mkdir -p ../res/snapp/ex4/${type}/summary
	estimates_file="../res/snapp/ex4/${type}/summary/node_ages.txt"
	rm -f ${estimates_file}
	touch ${estimates_file}
	for i in ../res/snapp/ex4/${type}/r????
	do
		replicate_id=`basename ${i}`
		echo -n "Analysing replicate ${replicate_id}..."
		rscript translate_trees.r ${i}/snapp.trees ${i}/tmp.trees &> /dev/null
		ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
		rm ${i}/tmp.trees
		echo " done."
	done
done

# Compare true and estimated node ages for the concatenated analyses of experiment 5.
mkdir -p ../res/beast/ex5/root/summary
estimates_file="../res/beast/ex5/root/summary/node_ages.txt"
rm -f ${estimates_file}
touch ${estimates_file}
for i in ../res/beast/ex5/root/r????
do
	replicate_id=`basename ${i}`
	echo -n "Analysing replicate ${replicate_id}..."
	rscript translate_trees.r ${i}/beast.trees ${i}/tmp.trees &> /dev/null
	ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
	rm ${i}/tmp.trees
	echo " done."
done
mkdir -p ../res/beast/ex5/young/summary
estimates_file="../res/beast/ex5/young/summary/node_ages.txt"
rm -f ${estimates_file}
touch ${estimates_file}
for i in ../res/beast/ex5/young/r????
do
	replicate_id=`basename ${i}`
	echo -n "Analysing replicate ${replicate_id}..."
	rscript translate_trees.r ${i}/beast.trees ${i}/tmp.trees &> /dev/null
	ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees young >> ${estimates_file}
	rm ${i}/tmp.trees
	echo " done."
done
mkdir -p ../res/beast/ex5/root_200000/summary
estimates_file="../res/beast/ex5/root_200000/summary/node_ages.txt"
rm -f ${estimates_file}
touch ${estimates_file}
for i in ../res/beast/ex5/root_200000/r????
do
	replicate_id=`basename ${i}`
	echo -n "Analysing replicate ${replicate_id}..."
	rscript translate_trees.r ${i}/beast.trees ${i}/tmp.trees &> /dev/null
	ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
	rm ${i}/tmp.trees
	echo " done."
done
mkdir -p ../res/beast/ex5/root_800000/summary
estimates_file="../res/beast/ex5/root_800000/summary/node_ages.txt"
rm -f ${estimates_file}
touch ${estimates_file}
for i in ../res/beast/ex5/root_800000/r????
do
	replicate_id=`basename ${i}`
	echo -n "Analysing replicate ${replicate_id}..."
	rscript translate_trees.r ${i}/beast.trees ${i}/tmp.trees &> /dev/null
	ruby compare_node_ages.rb ../res/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
	rm ${i}/tmp.trees
	echo " done."
done
