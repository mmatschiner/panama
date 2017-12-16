# m_matschiner Wed Sep 21 16:31:45 CEST 2016

# Prepare SNAPP input files for experiment 1, 2, and 3.
for i in ../res/simulations/r????
do
	replicate_id=`basename $i`
	mkdir -p ../res/snapp/ex1/root/s/${replicate_id}
	mkdir -p ../res/snapp/ex1/root/m/${replicate_id}
	mkdir -p ../res/snapp/ex1/root/l/${replicate_id}
	mkdir -p ../res/snapp/ex1/young/s/${replicate_id}
	mkdir -p ../res/snapp/ex1/young/m/${replicate_id}
	mkdir -p ../res/snapp/ex1/young/l/${replicate_id}
	mkdir -p ../res/snapp/ex2/large_pop/${replicate_id}
	mkdir -p ../res/snapp/ex2/huge_pop/${replicate_id}
	mkdir -p ../res/snapp/ex3/tiny_sample/${replicate_id}
	mkdir -p ../res/snapp/ex3/large_sample/${replicate_id}
	ruby prepare_snapp_input.rb ${i}/snps_sample_300.phy ${i}/species_scaled.tre root ../res/snapp/ex1/root/s/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.phy ${i}/species_scaled.tre root ../res/snapp/ex1/root/m/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_3000.phy ${i}/species_scaled.tre root ../res/snapp/ex1/root/l/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_300.phy ${i}/species_scaled.tre young ../res/snapp/ex1/young/s/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.phy ${i}/species_scaled.tre young ../res/snapp/ex1/young/m/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_3000.phy ${i}/species_scaled.tre young ../res/snapp/ex1/young/l/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.200000.4.phy ${i}/species_scaled.tre root ../res/snapp/ex2/large_pop/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.800000.4.phy ${i}/species_scaled.tre root ../res/snapp/ex2/huge_pop/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.50000.2.phy ${i}/species_scaled.tre root ../res/snapp/ex3/tiny_sample/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.50000.8.phy ${i}/species_scaled.tre root ../res/snapp/ex3/large_sample/${replicate_id}/snapp.xml
	cat ../res/snapp/ex3/large_sample/${replicate_id}/snapp.xml | sed 's/chainLength=\"500000/chainLength=\"200000/g' > tmp_large_sample.xml
	mv -f tmp_large_sample.xml ../res/snapp/ex3/large_sample/${replicate_id}/snapp.xml
done

# Prepare SNAPP input files for experiment 4.
# 1) Just copy the directory for medium-sized datasets with root calibration, this is identical to the set of analyses with variants only and ascertainment correction.
cp -r ../res/snapp/ex1/root/m ../res/snapp/ex4/variants_corrected
# 2a) Copy the above directory as the set of analyses with invariant sites (not yet added).
cp -r ../res/snapp/ex1/root/m ../res/snapp/ex4/invariants_added
for i in ../res/snapp/ex4/invariants_added/r????
do
	# 2b) Add invariant sites to each XML of the set of analyses with invariant sites.
	replicate_id=`basename ${i}`
	snps_per_alignment=`cat ../res/simulations/${replicate_id}/genes.info | grep mean | head -n 1 | cut -d ":" -f 2 | sed 's/ //g'`
	proportion_of_snps=`echo "${snps_per_alignment}/200" | bc -l`
	ruby add_invariant_sites_to_xml.rb ${i}/snapp.xml ${proportion_of_snps}
	# 3) Prepare input files for the set of analyses with variants only but without ascertainment correction.
	mkdir ../res/snapp/ex4/variants_uncorrected/${replicate_id}
	cat ../res/snapp/ex4/variants_corrected/${replicate_id}/snapp.xml | sed 's/non-polymorphic=\"false\"/non-polymorphic=\"true\"/g' > ../res/snapp/ex4/variants_uncorrected/${replicate_id}/snapp.xml
done
