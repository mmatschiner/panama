# m_matschiner Wed Sep 21 15:24:08 CEST 2016

# Scale each species tree so that branch lengths are
# in units of millions of years.
for i in ../res/simulations/r????
do
	ruby scale_species_trees.rb ${i}/species.tre 5 ${i}/species_scaled.tre
done