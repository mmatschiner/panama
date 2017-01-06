# m_matschiner Wed Sep 21 16:31:45 CEST 2016

# Prepare SNAPP input files for experiment 1.
for i in ../analysis/simulations/r????
do
	replicate_id=`basename $i`
	mkdir -p ../analysis/snapp/ex1/root/s/${replicate_id}
	mkdir -p ../analysis/snapp/ex1/root/m/${replicate_id}
	mkdir -p ../analysis/snapp/ex1/root/l/${replicate_id}
	mkdir -p ../analysis/snapp/ex1/young/s/${replicate_id}
	mkdir -p ../analysis/snapp/ex1/young/m/${replicate_id}
	mkdir -p ../analysis/snapp/ex1/young/l/${replicate_id}
	ruby prepare_snapp_input.rb ${i}/snps_sample_300.phy ${i}/species_scaled.tre root ../analysis/snapp/ex1/root/s/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.phy ${i}/species_scaled.tre root ../analysis/snapp/ex1/root/m/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_3000.phy ${i}/species_scaled.tre root ../analysis/snapp/ex1/root/l/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_300.phy ${i}/species_scaled.tre young ../analysis/snapp/ex1/young/s/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_1000.phy ${i}/species_scaled.tre young ../analysis/snapp/ex1/young/m/${replicate_id}/snapp.xml
	ruby prepare_snapp_input.rb ${i}/snps_sample_3000.phy ${i}/species_scaled.tre young ../analysis/snapp/ex1/young/l/${replicate_id}/snapp.xml
done

# Prepare SNAPP input files for experiment 2.
# 1) Just copy the directory for medium-sized datasets with root calibration, this is identical to the set of analyses with variants only and ascertainment correction.
cp -r ../analysis/snapp/ex1/root/m ../analysis/snapp/ex2/variants_corrected
# 2a) Copy the above directory as the set of analyses with invariant sites (not yet added).
cp -r ../analysis/snapp/ex1/root/m ../analysis/snapp/ex2/invariants_added
for i in ../analysis/snapp/ex2/invariants_added/r????
do
	# 2b) Add invariant sites to each XML of the set of analyses with invariant sites.
	replicate_id=`basename ${i}`
	snps_per_alignment=`cat ../analysis/simulations/${replicate_id}/genes.info | grep mean | head -n 1 | cut -d ":" -f 2 | sed 's/ //g'`
	proportion_of_snps=`echo "${snps_per_alignment}/200" | bc -l`
	ruby add_invariant_sites_to_xml.rb ${i}/snapp.xml ${proportion_of_snps}
	# 3) Prepare input files for the set of analyses with variants only but without ascertainment correction.
	mkdir ../analysis/snapp/ex2/variants_uncorrected/${replicate_id}
	cat ../analysis/snapp/ex2/variants_corrected/${replicate_id}/snapp.xml | sed 's/non-polymorphic=\"false\"/non-polymorphic=\"true\"/g' > ../analysis/snapp/ex2/variants_uncorrected/${replicate_id}/snapp.xml
done
