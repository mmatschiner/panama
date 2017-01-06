# m_matschiner Wed Oct 26 23:25:07 CEST 2016

# Get the command line arguments.
xml_file_name = ARGV[0]
proportion_of_snps = ARGV[1].to_f

# Read the xml file.
xml_file = File.open(xml_file_name)
xml_lines = xml_file.readlines
xml_file.close

# Add invariant sites to all sequences.
xml_lines.size.times do |x|
	if xml_lines[x].include?("<sequence")
		xml_lines[x].match(/value=\"([012]+)\"/)
		seq_snps_only = $1
		number_of_invariant_site_pairs_to_add = ((seq_snps_only.size/proportion_of_snps - seq_snps_only.size)/2.0).round
		seq_with_invariant_sites = seq_snps_only.dup
		number_of_invariant_site_pairs_to_add.times {seq_with_invariant_sites << "02"}
		xml_lines[x].sub!(seq_snps_only,seq_with_invariant_sites)
	end
end

# Write the modified XML file.
xml_string = ""
xml_lines.each {|l| xml_string << l}
xml_file = File.open(xml_file_name,"w")
xml_file.write(xml_string)
