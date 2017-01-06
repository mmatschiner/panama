# m_matschiner Tue Sep 20 13:15:12 CEST 2016

# This script is specifically written to calculate heterozygosity
# and number of variable sites from alignments generated with seq-gen.

# Add methods to the class Enumberable to calculate basic statistics.
module Enumerable
	def sum
		self.inject(0){|accum, i| accum + i }
	end
	def mean
		if self.length == 0
			nil
		else
			self.sum/self.length.to_f
		end
	end
	def median
		if self.length == 0
			nil
		else
			sorted_array = self.sort
			if self.size.modulo(2) == 1 
				sorted_array[self.size/2]
			else
				(sorted_array[(self.size/2)-1]+sorted_array[self.size/2])/2.0
			end
		end
	end
	def sample_variance
		if self.length == 0
			nil
		else
			m = self.mean
			sum = self.inject(0){|accum, i| accum +(i-m)**2 }
			sum/(self.length - 1).to_f
		end
	end
	def standard_deviation
		if self.length == 0
			nil
		else
			return Math.sqrt(self.sample_variance)
		end
	end
end

# Get the command line arguments.
alignment_file_name = ARGV[0]
snp_file_name = ARGV[1]

# Read the alignment file.
alignment_file = File.open(alignment_file_name)
alignment_file_lines = alignment_file.readlines

# Prepare variables for the analysis of the alignment file.
ids = []
seqs = []
snps = []
numbers_of_snps_in_alignments = []
snp_heterozygosities = []
number_of_alignments_with_snps = 0
ids_for_export = []
snps_for_export = []

# Analyse the alignment file.
alignment_file_lines.size.times do |x|
	# Collect ids and sequences while reading lines of an alignment.
	unless alignment_file_lines[x][0] == " "
		ids << alignment_file_lines[x].split[0]
		seqs << alignment_file_lines[x].split[1]
	end
	# Identify breaks between alignments.
	unless x == 0
		if alignment_file_lines[x][0] == " " or x == alignment_file_lines.size-1
			# At the end of an alignment, analyse the collected sequences.
			# Prepare an array for SNPs.
			snps = []
			ids.size.times{snps << ""}
			# Sort the IDs and sequences according to IDs.
			sorted = false
			until sorted
				sorted = true
				0.upto(ids.size-2) do |a|
					(a+1).upto(ids.size-1) do |b|
						if ids[a] > ids[b]
							sorted = false
							ids[a], ids[b] = ids[b], ids[a]
							seqs[a], seqs[b] = seqs[b], seqs[a]
						end
					end
				end
			end
			# If this was the first alignment, initiate the export arrays.
			if ids_for_export == []
				ids.size.times do |z|
					ids_for_export << ids[z]
					snps_for_export << ""
				end
			else
				# If this was not the first alignment, make sure the order of ids is
				# the same as for the first alignment.
				raise "ERROR: IDs differ between loci!" unless ids == ids_for_export
			end
			# Go through all sequences base by base and extract variable sites.
			seqs[0].size.times do |pos|
				snp_at_this_pos = false
				ref_base = seqs[0][pos]
				seqs.each do |s|
					if s[pos] != ref_base
						snp_at_this_pos = true
						break
					end
				end
				if snp_at_this_pos
					ids.size.times do |z|
						snps[z] << seqs[z][pos]
					end
				end
			end
			# Store the number of SNPs in this alignment.
			numbers_of_snps_in_alignments << snps[0].size
			# If at least one SNP is present, select one SNP at random.
			if snps[0].size > 0
				number_of_alignments_with_snps += 1
				random_snp_position = rand(snps[0].size)
				# Analyse the heterozygosity of the randomly selected SNP.
				number_of_heterozygous_sites = 0
				number_of_homozygous_sites = 0
				20.times do |spc_counter|
					bases_at_snp_for_this_species = []
					ids.size.times do |z|
						if ids[z].split("_")[0] == "s#{spc_counter}"
							bases_at_snp_for_this_species << snps[z][random_snp_position]
						end
					end
					bases_at_snp_for_this_species.shuffle!
					(bases_at_snp_for_this_species.size/2).times do |z|
						if bases_at_snp_for_this_species[2*z] == bases_at_snp_for_this_species[(2*z)+1]
							number_of_homozygous_sites += 1
						else
							number_of_heterozygous_sites += 1
						end
					end
				end
				snp_heterozygosities << number_of_heterozygous_sites/(number_of_heterozygous_sites+number_of_homozygous_sites).to_f
				# Store the randomly selected SNP for later export.
				ids.size.times do |z|
					snps_for_export[z] << snps[z][random_snp_position]
				end
			end

			# Reset arrays for the analysis of the next locus.
			ids = []
			seqs = []
		end
	end
end

# Prepare the string for the file with an alignment reduced to the one randomly selected SNPs per locus.
snps_file_string = ""
ids_for_export.size.times do |z|
	snps_file_string << "#{ids_for_export[z].ljust(12)}#{snps_for_export[z]}\n"
end

# Write the file with an alignment reduced to the one randomly selected SNPs per locus.
snps_file = File.open(snp_file_name,"w")
snps_file.write(snps_file_string)
snps_file.close

# Report statistics for the numbers of SNPs and the mean heterozygosity at a SNP.
puts "Number of alignments with at least one SNP: #{number_of_alignments_with_snps}"
puts
puts "Numbers of SNPs per alignment:"
puts "  mean: #{numbers_of_snps_in_alignments.mean}"
puts "  median: #{numbers_of_snps_in_alignments.median}"
puts "  min: #{numbers_of_snps_in_alignments.min}"
puts "  max: #{numbers_of_snps_in_alignments.max}"
puts
puts "Heterozygosities of SNPs:"
puts "  mean: #{snp_heterozygosities.mean}"
puts "  median: #{snp_heterozygosities.median}"
puts "  min: #{snp_heterozygosities.min}"
puts "  max: #{snp_heterozygosities.max}"
puts