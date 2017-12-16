# m_matschiner Tue Sep 20 00:08:33 CEST 2016

# Simulate 10000 gene trees for each species tree, with the standard setting: 50000 (haploid) individuals, of which 4 are sampled.
for i in ../res/simulations/r????
do
	rm -f ${i}/gene.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 50000 4 | head -n 1 >> ${i}/gene.trees
	done
	gzip ${i}/gene.trees
done

# Simulate 10000 gene trees for each species tree, with an alternative setting: 200000 (haploid) individuals, of which 4 are sampled.
for i in ../res/simulations/r????
do
	rm -f ${i}/gene.200000.4.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 200000 4 | head -n 1 >> ${i}/gene.200000.4.trees
	done
	gzip ${i}/gene.200000.4.trees
done

# Simulate 10000 gene trees for each species tree, with an alternative setting: 800000 (haploid) individuals, of which 4 are sampled.
for i in ../res/simulations/r????
do
	rm -f ${i}/gene.800000.4.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 800000 4 | head -n 1 >> ${i}/gene.800000.4.trees
	done
	gzip ${i}/gene.800000.4.trees
done

# Simulate 10000 gene trees for each species tree, with an alternative setting: 50000 (haploid) individuals, of which 2 are sampled.
for i in ../res/simulations/r????
do
	rm -f ${i}/gene.50000.2.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 50000 2 | head -n 1 >> ${i}/gene.50000.2.trees
	done
	gzip ${i}/gene.50000.2.trees
done

# Simulate 10000 gene trees for each species tree, with an alternative setting: 50000 (haploid) individuals, of which 8 are sampled.
for i in ../res/simulations/r????
do
	rm -f ${i}/gene.50000.8.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 50000 8 | head -n 1 >> ${i}/gene.50000.8.trees
	done
	gzip ${i}/gene.50000.8.trees
done

# Simulate 10000 gene trees for each species tree, with an alternative setting: 50000 (haploid) individuals, of which 16 are sampled.
for i in ../res/simulations/r????
do
	rm -f ${i}/gene.50000.16.trees
	for x in {1..10000}
	do
		python simulate_gene_trees.py ${i}/species.tre 50000 16 | head -n 1 >> ${i}/gene.50000.16.trees
	done
	gzip ${i}/gene.50000.16.trees
done

