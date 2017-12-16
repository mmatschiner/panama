# m_matschiner Wed Sep 21 15:26:03 CEST 2016

# Get the command line arguments.
input_file_name = ARGV[0]
generation_time = ARGV[1].to_f
output_file_name = ARGV[2]

# Read the input file.
input_file = File.open(input_file_name)
input_lines = input_file.readlines

# Get the tree from the input string.
tree_string = ""
input_lines.each do |l|
	if l[0..3].downcase == "tree"
		tree_string = l[l.index("(")..-1].strip.chomp(";").gsub(/\[.+?\]/,"")
		break
	end
end

# Make sure the number of opening and closing parentheses are equal.
unless tree_string.count("(") == tree_string.count(")")
	raise "ERROR: The number of opening and closing parentheses are not equal"
end

# Turn the string into an array so that all branch lengths are individual array elements.
tmp_string = tree_string + " "
tmp_ary1 = tmp_string.split(":")
tmp_ary2 = []
tmp_ary1.size.times do |x|
	tmp_ary2 << "#{tmp_ary1[x]} "
	tmp_ary2 << ": " unless x == tmp_ary1.size-1
end
tmp_ary3 = []
tmp_ary2.size.times do |x|
	if tmp_ary2[x].include?(",")
		tmp_ary2_ary = tmp_ary2[x].split(",")
		tmp_ary2_ary.size.times do |y|
			tmp_ary3 << "#{tmp_ary2_ary[y]} "
			tmp_ary3 << ", " unless y == tmp_ary2_ary.size-1
		end
	else
		tmp_ary3 << "#{tmp_ary2[x]} "
	end
end
tmp_ary4 = []
tmp_ary3.size.times do |x|
	if tmp_ary3[x].include?(")")
		tmp_ary3_ary = tmp_ary3[x].split(")")
		tmp_ary3_ary.size.times do |y|
			tmp_ary4 << "#{tmp_ary3_ary[y]} "
			tmp_ary4 << ") " unless y == tmp_ary3_ary.size-1
		end
	else
		tmp_ary4 << "#{tmp_ary3[x]} "
	end
end
tree_ary = []
tmp_ary4.each{|i| tree_ary << i.gsub(" ","") unless i.gsub(" ","") == ""}

# Merge the array into a test string to make sure it is still equivalent to the original tree string.
test_string = ""
tree_ary.each{|i| test_string << i}
raise "ERROR: The tree string could not be read correctly!" unless tree_string == test_string

# Scale all elements of the tree array if the previous element is a ":".
tree_ary.size.times do |x|
	if tree_ary[x] == ":"
		tree_ary[x+1] = (((tree_ary[x+1].to_f)*generation_time)/1000000.0).to_s
	end
end

# Prepare the scaled tree string.
scaled_tree_string = ""
tree_ary.each{|i| scaled_tree_string << i}

# Write the scaled tree string to file.
output_file = File.open(output_file_name,"w")
output_file.write(scaled_tree_string)
