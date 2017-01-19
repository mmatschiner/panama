# m_matschiner Sat Jan 14 13:01:20 CET 2017

# Get the command line arguments.
input_alignment_file_name = ARGV[0]
species_table_file_name = ARGV[1]
output_alignment_file_name = ARGV[2]

# Read the input alignment.
input_alignment_file = File.open(input_alignment_file_name)
input_alignment_lines = input_alignment_file.readlines
alignment_ids = []
alignment_seqs = []
input_alignment_lines[1..-1].each do |l|
	alignment_ids << l.split[0]
	alignment_seqs << l.split[1].upcase
end

# Read the species table file.
species_table_file = File.open(species_table_file_name)
species_table_lines = species_table_file.readlines
table_species_ids = []
table_specimen_ids = []
species_table_lines[1..-1].each do |l|
	table_species_ids << l.split[0]
	table_specimen_ids << l.split[1]
end
unique_species_ids = table_species_ids.uniq

# Generate arrays with only suitable sites.
alignment_snapp_sites = []
alignment_seqs.size.times {alignment_snapp_sites << ""}
alignment_seqs[0].size.times do |pos|
	use_site = true
	unique_species_ids.each do |spec|
		specimens_for_this_species = []
		table_species_ids.size.times do |x|
			if table_species_ids[x] == spec
				specimens_for_this_species << table_specimen_ids[x]
			end
		end
		alleles_for_this_site_and_species = []
		alignment_ids.size.times do |x|
			if specimens_for_this_species.include?(alignment_ids[x])
				alleles_for_this_site_and_species << alignment_seqs[x][pos] unless ["N","?","-"].include?(alignment_seqs[x][pos])
			end
		end
		if alleles_for_this_site_and_species == []
			use_site = false
			break
		end
	end
	if use_site
		alignment_seqs.size.times do |x|
			alignment_snapp_sites[x] << alignment_seqs[x][pos]
		end
	end
end

# Prepare the output alignment.
output_alignment_string = "#{alignment_ids.size} #{alignment_snapp_sites[0].size}\n"
alignment_ids.size.times do |x|
	output_alignment_string << "#{alignment_ids[x].ljust(12)}  #{alignment_snapp_sites[x]}\n"
end

# Write the output alignment.
output_alignment_file = File.open(output_alignment_file_name,"w")
output_alignment_file.write(output_alignment_string)
