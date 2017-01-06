# m_matschiner Tue Sep 20 10:36:05 CEST 2016

# Simulate sequences for each set of gene trees, and record one SNP per alignment (if any).
for i in ../analysis/simulations/r????
do
	# If results of previous simulations are in the directory, remove them.
	rm -f ${i}/genes.txt

	# Uncompress the gene trees file.
	gunzip -c ${i}/gene.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.trees

	# Simulate sequences for all trees in this set of gene trees.
	resources/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.trees > ${i}/genes.txt

	# Report alignment statistics and generate a concatenated dataset with a single SNP per
	# original gene alignment.
	ruby select_snps.rb ${i}/genes.txt ${i}/snps.txt > ${i}/genes.info

	# Remove files to save disk space.
	rm ${i}/genes.txt
	rm ${i}/gene.trees
done