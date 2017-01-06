# m_matschiner Sat Nov 12 19:32:52 CET 2016

# Use the phylsim and the fileutils libraries.
$libPath = "./resources/phylsim/"
require "./resources/phylsim/main.rb"

# Get the command line arguments.
phyilp_file_name = ARGV[0]
info_file_name = ARGV[1]
tree_file_name = ARGV[2]
constraint_type = ARGV[3]

# Read the phylip file.
phylip_file = File.open(phyilp_file_name)
phylip_lines = phylip_file.readlines
ids = []
seqs = []
phylip_lines[1..-1].each do |l|
	line_ary = l.split
	if line_ary[0].include?("_1")
		ids << line_ary[0].chomp("_1")
		seqs << line_ary[1].strip
	end
end
# Randomly phase ambiguous sequences.
seqs.size.times do |x|
	seqs[x].size.times do |pos|
		seqs[x][pos] = ["A","C"].sample if seqs[x][pos] == "M"
		seqs[x][pos] = ["A","G"].sample if seqs[x][pos] == "R"
		seqs[x][pos] = ["A","T"].sample if seqs[x][pos] == "W"
		seqs[x][pos] = ["C","G"].sample if seqs[x][pos] == "S"
		seqs[x][pos] = ["C","T"].sample if seqs[x][pos] == "Y"
		seqs[x][pos] = ["G","T"].sample if seqs[x][pos] == "K"
	end
end

# Read the info file.
info_file = File.open(info_file_name)
info_lines = info_file.readlines
proportion_of_snps = nil
info_lines.each do |l|
	if l.include?("mean")
		proportion_of_snps = (l.split(":")[1].to_f/200.0)
		break
	end
end
raise "ERROR!" if proportion_of_snps == nil

# Parse the tree using phylsim.
tree = Tree.parse(fileName=tree_file_name, fileType="newick", diversityFileName = nil, treeNumber = 0, verbose = false)

# Find the branch for which the termination time is closes to a third of the root age.
if constraint_type == "young"
	selected_branch = tree.branch[0]
	tree.branch[1..-1].each do |b|
		if (b.termination-(tree.treeOrigin/3.0))**2 < (selected_branch.termination-(tree.treeOrigin/3.0))**2
			selected_branch = b
		end
	end

	# Get a list of extant species for the branch selected above.
	species_in_constrained_clade = []
	selected_branch.extantProgenyId.each do |p|
		tree.branch.each do |b|
			if b.id == p
				species_in_constrained_clade << b.speciesId
			end
		end
	end
end

# Prepare the constraint string.
constraint_string = ""
if constraint_type == "root"
	constraint_string << "                <distribution id=\"All.prior\" monophyletic=\"true\" spec=\"beast.math.distributions.MRCAPrior\" tree=\"@tree.t:Species\">\n"
	constraint_string << "                    <taxonset id=\"All\" spec=\"TaxonSet\">\n"
	ids.each do |s|
		constraint_string << "                        <taxon idref=\"#{s}\"/>\n"
	end
	constraint_string << "                    </taxonset>\n"
	constraint_string << "                    <LogNormal meanInRealSpace=\"true\" name=\"distr\" offset=\"#{tree.treeOrigin/2.0}\">\n"
	constraint_string << "                        <parameter estimate=\"false\" name=\"M\">#{tree.treeOrigin/2.0}</parameter>\n"
	constraint_string << "                        <parameter estimate=\"false\" lower=\"0.0\" name=\"S\" upper=\"5.0\">0.1</parameter>\n"
	constraint_string << "                    </LogNormal>\n"
	constraint_string << "                </distribution>\n"
elsif constraint_type == "young"
	constraint_string << "                <distribution id=\"Clade.prior\" monophyletic=\"true\" spec=\"beast.math.distributions.MRCAPrior\" tree=\"@tree.t:Species\">\n"
	constraint_string << "                    <taxonset id=\"Clade\" spec=\"TaxonSet\">\n"
	species_in_constrained_clade.each do |s|
		constraint_string << "                        <taxon idref=\"#{s}\"/>\n"
	end
	constraint_string << "                    </taxonset>\n"
    constraint_string << "                    <LogNormal meanInRealSpace=\"true\" name=\"distr\" offset=\"#{selected_branch.termination/2.0}\">\n"
    constraint_string << "                        <parameter estimate=\"false\" name=\"M\">#{selected_branch.termination/2.0}</parameter>\n"
    constraint_string << "                        <parameter estimate=\"false\" lower=\"0.0\" name=\"S\" upper=\"5.0\">0.1</parameter>\n"
    constraint_string << "                    </LogNormal>\n"
	constraint_string << "                </distribution>\n"
else
	raise "ERROR: Unexpected constraint type #{constraint_type}!"
end

# Write the constraint string to a temporary file.
constraint_file_name = "tmp.xml"
constraint_file = File.open(constraint_file_name,"w")
constraint_file.write(constraint_string)
constraint_file.close

# Add invariant sites so that the proportion of invariant sites in the resulting alignment is the same
# as in the original gene tree alignments.
number_of_invariant_sites_to_add = (seqs[0].size/proportion_of_snps - seqs[0].size).round
number_of_invariant_sites_to_add.times do
	nucleotide = ["A","C","G","T"].sample
	seqs.each {|s| s << nucleotide}
end

# Prepare an alignment in nexus format.
nexus_string = "#nexus\n"
nexus_string << "begin data;\n"
nexus_string << "dimensions  ntax=#{seqs.size} nchar=#{seqs[0].size};\n"
nexus_string << "format datatype=DNA gap=- missing=?;\n"
nexus_string << "matrix\n"
seqs.size.times do |x|
	nexus_string << "#{ids[x].ljust(8)}#{seqs[x]}\n"
end
nexus_string << ";\n"
nexus_string << "end;\n"

# Write the alignment to a temporary file.
nexus_file_name = "tmp.nex"
nexus_file = File.open(nexus_file_name,"w")
nexus_file.write(nexus_string)
nexus_file.close
