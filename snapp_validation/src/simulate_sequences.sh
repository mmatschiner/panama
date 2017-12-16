# m_matschiner Tue Sep 20 10:36:05 CEST 2016

# Simulate sequences for each set of gene trees, and record one SNP per alignment (if any).
for i in ../res/simulations/r????
do
	# If results of previous simulations are in the directory, remove them.
	rm -f ${i}/genes.txt
	rm -f ${i}/genes.50000.2.txt
	rm -f ${i}/genes.50000.8.txt
	rm -f ${i}/genes.50000.16.txt
	rm -f ${i}/genes.200000.4.txt
	rm -f ${i}/genes.800000.4.txt

	# Uncompress the gene trees file.
	gunzip -c ${i}/gene.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.trees
	gunzip -c ${i}/gene.50000.2.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.50000.2.trees
	gunzip -c ${i}/gene.50000.8.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.50000.8.trees
	gunzip -c ${i}/gene.50000.16.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.50000.16.trees
	gunzip -c ${i}/gene.200000.4.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.200000.4.trees
	gunzip -c ${i}/gene.800000.4.trees.gz | sed 's/\[\&R\] //g' > ${i}/gene.800000.4.trees

	# Simulate sequences for all trees in this set of gene trees.
	../bin/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.trees > ${i}/genes.txt
	../bin/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.50000.2.trees > ${i}/genes.50000.2.txt
	../bin/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.50000.8.trees > ${i}/genes.50000.8.txt
	../bin/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.50000.16.trees > ${i}/genes.50000.16.txt
	../bin/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.200000.4.trees > ${i}/genes.200000.4.txt
	../bin/seq-gen -mHKY -l200 -t0.5 -s0.000000001 < ${i}/gene.800000.4.trees > ${i}/genes.800000.4.txt

	# Report alignment statistics and generate a concatenated dataset with a single SNP per
	# original gene alignment.
	ruby select_snps.rb ${i}/genes.txt ${i}/snps.txt > ${i}/genes.info
	ruby select_snps.rb ${i}/genes.50000.2.txt ${i}/snps.50000.2.txt > ${i}/genes.50000.2.info
	ruby select_snps.rb ${i}/genes.50000.8.txt ${i}/snps.50000.8.txt > ${i}/genes.50000.8.info
	ruby select_snps.rb ${i}/genes.50000.16.txt ${i}/snps.50000.16.txt > ${i}/genes.50000.16.info
	ruby select_snps.rb ${i}/genes.200000.4.txt ${i}/snps.200000.4.txt > ${i}/genes.200000.4.info
	ruby select_snps.rb ${i}/genes.800000.4.txt ${i}/snps.800000.4.txt > ${i}/genes.800000.4.info

	# Remove files to save disk space.
	rm ${i}/genes.txt
	rm ${i}/genes.50000.2.txt
	rm ${i}/genes.50000.8.txt
	rm ${i}/genes.50000.16.txt
	rm ${i}/genes.200000.4.txt
	rm ${i}/genes.800000.4.txt
	rm ${i}/gene.trees
	rm ${i}/gene.50000.2.trees
	rm ${i}/gene.50000.8.trees
	rm ${i}/gene.50000.16.trees
	rm ${i}/gene.200000.4.trees
	rm ${i}/gene.800000.4.trees
done