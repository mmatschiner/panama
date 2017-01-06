# m_matschiner Tue Sep 20 00:08:33 CEST 2016

# Simulate a number of gene trees for each species tree.
for i in ../analysis/simulations/r0019
do
	rm -f ${i}/gene.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 50000 4 | head -n 1 >> ${i}/gene.trees
	done
	gzip ${i}/gene.trees
done