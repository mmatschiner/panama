# m_matschiner Sat Jan 14 11:57:28 CET 2017

# Get the command line arguments.
input_alignment_file_name = ARGV[0]
species_table_file_name = ARGV[1]
output_alignment_file_name = ARGV[2]

# Read the input alignment.
ids = []
seqs = []
in_matrix = false
input_alignment_file = File.open(input_alignment_file_name)
input_alignment_lines = input_alignment_file.readlines
input_alignment_lines.each do |l|
	if l.strip.downcase == "matrix"
		in_matrix = true
	elsif l.strip == ";"
		in_matrix = false
	elsif in_matrix
		unless l.strip == ""
			line_ary = l.split
			ids << line_ary[0]
			seqs << line_ary[1]
		end
	end
end

# Read the table with species and specimen ids.
species_table_file = File.open(species_table_file_name)
species_table_lines = species_table_file.readlines
species_ids = []
specimen_ids = []
species_table_lines[1..-1].each do |l|
	species_ids << l.split[0]
	specimen_ids << l.split[1]
end

# Prepare the output nexus string.
translated_alignment_string = "#nexus\n"
translated_alignment_string << "begin data;\n"
translated_alignment_string << "  dimensions ntax=#{ids.size} nchar=#{seqs[0].size}\n"
translated_alignment_string << "  format datatype=dna missing=? gap=-;\n"
translated_alignment_string << "  matrix\n"
ids.size.times do |x|
	translated_alignment_string << "#{species_ids[specimen_ids.index(ids[x])].ljust(12)}  #{seqs[x]}\n"
end
translated_alignment_string << "  ;\n"
translated_alignment_string << "end;\n"

# Write the output file.
output_alignment_file = File.open(output_alignment_file_name,"w")
output_alignment_file.write(translated_alignment_string)