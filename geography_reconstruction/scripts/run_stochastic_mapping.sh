# m_matschiner Sat Dec 10 14:58:19 CET 2016

# Unset the R_HOME variable for tidier R output.
unset R_HOME

# Clean up potential previous results.
rm -f ../analysis/stochastic_mapping/trees/ariidae_w_fossils_mapped_1000.trees

# For each of 1000 posterior trees, use phytool for stochastic mapping of ancestral geography.
for i in `seq 0 999`
do
	echo -n "Analysing tree ${i}..."
	cat ../analysis/stochastic_mapping/trees/ariidae_w_fossils_1000.trees | grep "tree ${i} " | cut -d "=" -f 2 | sed 's/ //g' > tmp.tre
	rscript run_stochastic_mapping.r "tmp.tre" "tmp.simmap.tre" "../data/tables/geography.txt" &> /dev/null
	cat tmp.simmap.tre >> ../analysis/stochastic_mapping/trees/ariidae_w_fossils_mapped_1000.trees
	rm tmp.tre
	rm tmp.simmap.tre
	echo " done."
done
