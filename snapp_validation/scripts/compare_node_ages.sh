# m_matschiner Sat Oct 1 22:37:56 CEST 2016

# Compare true and estimated node ages for all analyses of experiment 1.
for calibration_type in young root
do
	for sample_size in s m l
	do
		mkdir -p ../analysis/snapp/ex1/${calibration_type}/${sample_size}/summary
		estimates_file="../analysis/snapp/ex1/${calibration_type}/${sample_size}/summary/node_ages.txt"
		rm -f ${estimates_file}
		touch ${estimates_file}
		for i in ../analysis/snapp/ex1/${calibration_type}/${sample_size}/r????
		do
			replicate_id=`basename ${i}`
			echo -n "Analysing replicate ${replicate_id}..."
			rscript translate_trees.r ${i}/snapp.trees ${i}/tmp.trees &> /dev/null
			ruby compare_node_ages.rb ../analysis/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees ${calibration_type} >> ${estimates_file}
			rm ${i}/tmp.trees
			echo " done."
		done
	done
done

# Compare true and estimated node ages for all analyses of experiment 2.
for type in variants_corrected invariants_added variants_uncorrected
do
	mkdir -p ../analysis/snapp/ex2/${type}/summary
	estimates_file="../analysis/snapp/ex2/${type}/summary/node_ages.txt"
	rm -f ${estimates_file}
	touch ${estimates_file}
	for i in ../analysis/snapp/ex2/${type}/r????
	do
		replicate_id=`basename ${i}`
		echo -n "Analysing replicate ${replicate_id}..."
		rscript translate_trees.r ${i}/snapp.trees ${i}/tmp.trees &> /dev/null
		ruby compare_node_ages.rb ../analysis/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
		rm ${i}/tmp.trees
		echo " done."
	done
done

# Compare true and estimated node ages for the concatenated analyses of experiment 3.
mkdir -p ../analysis/beast/ex3/root/summary
estimates_file="../analysis/beast/ex3/root/summary/node_ages.txt"
rm -f ${estimates_file}
touch ${estimates_file}
for i in ../analysis/beast/ex3/root/r????
do
	replicate_id=`basename ${i}`
	echo -n "Analysing replicate ${replicate_id}..."
	rscript translate_trees.r ${i}/beast.trees ${i}/tmp.trees &> /dev/null
	ruby compare_node_ages.rb ../analysis/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees root >> ${estimates_file}
	rm ${i}/tmp.trees
	echo " done."
done
mkdir -p ../analysis/beast/ex3/young/summary
estimates_file="../analysis/beast/ex3/young/summary/node_ages.txt"
rm -f ${estimates_file}
touch ${estimates_file}
for i in ../analysis/beast/ex3/young/r????
do
	replicate_id=`basename ${i}`
	echo -n "Analysing replicate ${replicate_id}..."
	rscript translate_trees.r ${i}/beast.trees ${i}/tmp.trees &> /dev/null
	ruby compare_node_ages.rb ../analysis/simulations/${replicate_id}/species_scaled.tre ${i}/tmp.trees ${i}/snapp_sampled.trees young >> ${estimates_file}
	rm ${i}/tmp.trees
	echo " done."
done
