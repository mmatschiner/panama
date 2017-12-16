# m_matschiner Sun Oct 16 23:55:07 CEST 2016

# Read the input file.
input_file_name = ARGV[0]
input_file = File.open(input_file_name)
input_lines = input_file.readlines
seqs = []
input_lines.each do |l|
	if l.include?("sequence")
		seqs << l.split("=")[4].strip.chomp("/>")[1..-2]
	end
end

# Count the number of site patterns.
patterns = []
seqs[0].size.times do |pos|
	pattern = ""
	seqs.each {|s| pattern << s[pos]}
	patterns << pattern
end

# Report the number of unique patterns.
puts patterns.uniq.size