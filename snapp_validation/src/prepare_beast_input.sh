# m_matschiner Sat Nov 12 19:32:40 CET 2016

# Use script prepare_beast_input.rb to modify the SNAPP XML files with invariant sites.
for i in ../res/simulations/r????
do
	replicate_id=`basename $i`

	# Prepare XML files for analyses with root constraints.
	mkdir -p ../res/beast/ex5/root/${replicate_id}
	ruby prepare_beast_input.rb ${i}/snps_sample_1000.phy ${i}/genes.info ${i}/species_scaled.tre root
	mkdir tmp
	mv tmp.nex tmp/t.nex
	mv tmp.xml tmp
	ruby resources/beauti.rb -id beast -n tmp -o tmp -l 500000 -c tmp/tmp.xml -t ${i}/species_scaled.tre
	cat tmp/beast.xml | sed 's/value=\"2.0\"/value=\"1.0\"/g' | head -n 152 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +158 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | head -n 181 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +188 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | head -n 200 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +204 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	mv tmp/beast.xml ../res/beast/ex5/root/${replicate_id}
	rm -r tmp

	# Prepare XML files for analyses with younger constraints.
	mkdir -p ../res/beast/ex5/young/${replicate_id}
	ruby prepare_beast_input.rb ${i}/snps_sample_1000.phy ${i}/genes.info ${i}/species_scaled.tre young
	mkdir tmp
	mv tmp.nex tmp/t.nex
	mv tmp.xml tmp
	ruby resources/beauti.rb -id beast -n tmp -o tmp -l 1000000 -c tmp/tmp.xml -t ${i}/species_scaled.tre
	cat tmp/beast.xml | sed 's/value=\"2.0\"/value=\"1.0\"/g' > tmp/beast1.xml
	mv tmp/beast1.xml tmp/beast.xml
	cat tmp/beast.xml | ghead -n -95 > tmp/part1.xml
	cat tmp/beast.xml | tail -n 89 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	cat tmp/beast.xml | ghead -n -60 > tmp/part1.xml
	cat tmp/beast.xml | tail -n 54 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | ghead -n -35 > tmp/part1.xml
	cat tmp/beast.xml | tail -n 32 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	mv tmp/beast.xml ../res/beast/ex5/young/${replicate_id}
	rm -r tmp

	# Prepare XML files for analyses with root constraints.
	mkdir -p ../res/beast/ex5/root_200000/${replicate_id}
	ruby prepare_beast_input.rb ${i}/snps_sample_1000.200000.4.phy ${i}/genes.200000.4.info ${i}/species_scaled.tre root
	mkdir tmp
	mv tmp.nex tmp/t.nex
	mv tmp.xml tmp
	ruby resources/beauti.rb -id beast -n tmp -o tmp -l 500000 -c tmp/tmp.xml -t ${i}/species_scaled.tre
	cat tmp/beast.xml | sed 's/value=\"2.0\"/value=\"1.0\"/g' | head -n 152 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +158 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | head -n 181 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +188 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | head -n 200 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +204 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	mv tmp/beast.xml ../res/beast/ex5/root_200000/${replicate_id}
	rm -r tmp

	# Prepare XML files for analyses with root constraints.
	mkdir -p ../res/beast/ex5/root_800000/${replicate_id}
	ruby prepare_beast_input.rb ${i}/snps_sample_1000.800000.4.phy ${i}/genes.800000.4.info ${i}/species_scaled.tre root
	mkdir tmp
	mv tmp.nex tmp/t.nex
	mv tmp.xml tmp
	ruby resources/beauti.rb -id beast -n tmp -o tmp -l 500000 -c tmp/tmp.xml -t ${i}/species_scaled.tre
	cat tmp/beast.xml | sed 's/value=\"2.0\"/value=\"1.0\"/g' | head -n 152 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +158 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | head -n 181 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +188 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	cat tmp/beast.xml | head -n 200 > tmp/part1.xml
	cat tmp/beast.xml | tail -n +204 > tmp/part2.xml
	cat tmp/part1.xml tmp/part2.xml > tmp/beast.xml
	rm tmp/part?.xml
	mv tmp/beast.xml ../res/beast/ex5/root_800000/${replicate_id}
	rm -r tmp

done