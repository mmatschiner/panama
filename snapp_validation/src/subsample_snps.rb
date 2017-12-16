# m_matschiner Wed Sep 21 14:14:35 CEST 2016

# Get the command line arguments.
input_file_name = ARGV[0]
number_of_snps_to_sample = ARGV[1].to_i
output_file_name = ARGV[2]

# Read the input file.
input_file = File.open(input_file_name)
input_lines = input_file.readlines
ids = []
seqs = []
biallelic_seqs = []
input_lines.each do |l|
	ids << l.split[0]
	seqs << l.split[1]
	biallelic_seqs << ""
end

# Exclude any sites that are not bi-allelic.
seqs[0].size.times do |pos|
	bases_at_this_pos = []
	seqs.each{|s| bases_at_this_pos << s[pos]}
	if bases_at_this_pos.uniq.size == 2
		seqs.size.times do |x|
			biallelic_seqs[x] << seqs[x][pos]
		end
	elsif bases_at_this_pos.uniq.size == 1
		raise "ERROR: Detected monomorphic site!"
	end
end

# Shorten all biallelic sequences to the number of SNPs to sample.
raise "ERROR: Not enough biallelic SNPs were found!" if biallelic_seqs[0].size < number_of_snps_to_sample
positions_to_sample = (0..(biallelic_seqs[0].size-1)).to_a.sample(number_of_snps_to_sample)
biallelic_seqs.size.times do |x|
	sampled_biallelic_seq = ""
	positions_to_sample.each {|p| sampled_biallelic_seq << biallelic_seqs[x][p]}
	biallelic_seqs[x] = sampled_biallelic_seq
end

# Define and merge pairs of sequences using IUPAC code.
new_ids = []
new_seqs = []
20.times do |spc_counter|
	seqs_for_this_species = []
	ids.size.times do |z|
		if ids[z].split("_")[0] == "s#{spc_counter}"
			seqs_for_this_species << biallelic_seqs[z]
		end
	end
	seqs_for_this_species.shuffle!
	(seqs_for_this_species.size/2).times do |z|
		new_id = "s#{spc_counter}_#{z+1}"
		new_seq = ""
		seqs_for_this_species[0].size.times do |pos|
			two_bases_at_this_pos = [seqs_for_this_species[2*z][pos],seqs_for_this_species[(2*z)+1][pos]]
			if two_bases_at_this_pos[0] == two_bases_at_this_pos[1]
				new_seq << two_bases_at_this_pos[0]
			else
				two_bases_at_this_pos.sort!
				new_base = "M" if two_bases_at_this_pos == ["A","C"]
				new_base = "R" if two_bases_at_this_pos == ["A","G"]
				new_base = "W" if two_bases_at_this_pos == ["A","T"]
				new_base = "S" if two_bases_at_this_pos == ["C","G"]
				new_base = "Y" if two_bases_at_this_pos == ["C","T"]
				new_base = "K" if two_bases_at_this_pos == ["G","T"]
				raise "ERROR: Unexpected base!" if new_base == nil
				new_seq << new_base
			end
		end
		new_ids << new_id
		new_seqs << new_seq
	end
end

# Write a phylip output file for the subsampled alignment.
phylip_string = "#{new_ids.size} #{new_seqs[0].size}\n"
new_ids.size.times{|x| phylip_string << "#{new_ids[x].ljust(12)}#{new_seqs[x]}\n"}
output_file = File.open(output_file_name,"w")
output_file.write(phylip_string)
