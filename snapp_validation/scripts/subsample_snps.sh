# m_matschiner Wed Sep 21 14:09:40 CEST 2016

# For each simulation replicate, prepare a subsampled SNP data set.
for i in ../analysis/simulations/r????
do
	ruby subsample_snps.rb ${i}/snps.txt 300 ${i}/snps_sample_300.phy
	ruby subsample_snps.rb ${i}/snps.txt 1000 ${i}/snps_sample_1000.phy
	ruby subsample_snps.rb ${i}/snps.txt 3000 ${i}/snps_sample_3000.phy
done