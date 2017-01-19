# m_matschiner Sat Jan 14 00:22:56 CET 2017

# Get the command line arguments.
input_alignment_file_name = ARGV[0]
species_list_file_name = ARGV[1]
reduced_alignment_file_name = ARGV[2]

# Read the input alignment.
input_alignment_file = File.open(input_alignment_file_name)
input_alignment_lines = input_alignment_file.readlines

# Read the species list.
species_list_file = File.open(species_list_file_name)
species_list_lines = species_list_file.readlines
list_specimen_ids = []
species_list_lines[1..-1].each do |l|
	unless l[0] == "#"
		list_specimen_ids << l.split[1]
	end
end

# Keep only alignment lines for the specimens included in the species list.
full_alignment_ids = []
reduced_alignment_ids = []
reduced_alignment_seqs = []
number_of_missing_bases_in_full_alignment = 0
number_of_missing_bases_in_reduced_alignment = 0
input_alignment_lines[1..-1].each do |l|
	if l.strip != ""
		line_ary = l.split
		alignment_id = line_ary[0]
		full_alignment_ids << alignment_id
		if list_specimen_ids.include?(alignment_id)
			reduced_alignment_ids << alignment_id
			reduced_alignment_seqs << line_ary[1]
		else
			number_of_missing_bases_in_full_alignment += line_ary[1].count("N") + line_ary[1].count("-") + line_ary[1].count("?")
		end
	end
end

# Exclude sites with much missing data or invariable sites.
reduced_and_filtered_alignment_seqs = []
reduced_alignment_seqs.size.times {reduced_and_filtered_alignment_seqs << ""}
reduced_alignment_seqs[0].size.times do |pos|
	# puts pos if (pos/10000)*10000 == pos
	bases_at_this_site = []
	reduced_alignment_seqs.size.times do |x|
		bases_at_this_site << reduced_alignment_seqs[x][pos]
	end
	number_of_missing_bases_at_this_site = bases_at_this_site.count("N") + bases_at_this_site.count("-") + bases_at_this_site.count("?")
	number_of_missing_bases_in_full_alignment += number_of_missing_bases_at_this_site
	unless number_of_missing_bases_at_this_site > 11
		bases_at_this_site.size.times do |x|
			number_of_missing_bases_in_reduced_alignment += number_of_missing_bases_at_this_site
			reduced_and_filtered_alignment_seqs[x] << bases_at_this_site[x]
		end
	end
end

# Prepare the reduced alignment string.
reduced_alignment_string = "#nexus\n"
reduced_alignment_string << "begin data;\n"
reduced_alignment_string << "  dimensions ntax=#{reduced_alignment_ids.size} nchar=#{reduced_and_filtered_alignment_seqs[0].size}\n"
reduced_alignment_string << "  format datatype=dna missing=? gap=-;\n"
reduced_alignment_string << "  matrix\n"
reduced_alignment_ids.size.times do |x|
	reduced_alignment_string << "#{reduced_alignment_ids[x].ljust(12)}  #{reduced_and_filtered_alignment_seqs[x]}\n"
end
reduced_alignment_string << "  ;\n"
reduced_alignment_string << "end;\n"

# Write the reduced alignment file.
reduced_alignment_file = File.open(reduced_alignment_file_name,"w")
reduced_alignment_file.write(reduced_alignment_string)

# Report the amount of missing data in the reduced and filtered alignment.
puts "Reduced alignment dimensions: #{reduced_alignment_ids.size} taxa, #{reduced_and_filtered_alignment_seqs[0].size} positions."
puts "Missing data in #{reduced_alignment_file_name}: #{number_of_missing_bases_in_reduced_alignment/(reduced_and_filtered_alignment_seqs[0].size*reduced_alignment_ids.size).to_f}"
