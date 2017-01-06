# m_matschiner Tue Dec 13 12:36:31 CET 2016

# Read the input tree.
input_tree_file_name = ARGV[0]
input_tree_file = File.open(input_tree_file_name)
input_tree_lines = input_tree_file.readlines

# Get the species name.
species_name = ARGV[1]

# Find the right translation for the species name.
in_translate_part = false
translate_ids = []
translate_numbers = []
input_tree_lines.each do |l|
	if l.downcase.strip == "translate"
		in_translate_part = true
	elsif l.strip == ";"
		in_translate_part = false
	elsif in_translate_part
		line_ary =  l.strip.chomp(",").split
		translate_numbers << line_ary[0]
		translate_ids << line_ary[1]
	end
end
species_number = translate_numbers[translate_ids.index(species_name)]

# Find the age of the species in each tree of the input tree file.
ages_string = ""
input_tree_lines.each do |l|
	if l.downcase.match(/tree\s+\d+/)
		l.match(/[\(,)]#{species_number}\[\&[a-zA-Z0-9\_=\.\-]+\]:([0-9\.]+)/)
		ages_string << "#{$1.to_f}\n"
	end
end

# Write the ages to the output file.
output_file_name = ARGV[2]
output_file = File.open(output_file_name,"w")
output_file.write(ages_string)