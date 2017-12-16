# m_matschiner Fri Dec 9 12:42:19 CET 2016

# Define a class for trees.
class Tree
	attr_reader :branch, :species
	def initialize(tree_string)
		@original_tree_string = tree_string
		@branch = []
	end
	def parse
        # Parse the tree string and store all information temporarily in arrays.
        working_tree_string = @original_tree_string.dup
        tmpBranchEndNodeId = []
        tmpBranchAnnotation = []
        tmpBranchDuration = []
        tmpBranchStartNodeId = []
        numberOfInternalNodes = 0
        while working_tree_string.match(/\(([a-zA-Z0-9_]+?)(\[\&.[a-zA-Z0-9_]+?=[\"a-zA-Z0-9_\.E-]+?\]):([\d\.E-]+?)\,([a-zA-Z0-9_]+?)(\[\&.[a-zA-Z0-9_]+?=[\"a-zA-Z0-9_\.E-]+?\]):([\d\.E-]+?)\)/)
			numberOfInternalNodes += 1
			tmpBranchEndNodeId << $1
			tmpBranchAnnotation << $2
			tmpBranchStartNodeId << "internalNode#{numberOfInternalNodes}X"
			tmpBranchDuration << $3.to_f
			tmpBranchEndNodeId << $4
			tmpBranchAnnotation << $5
			tmpBranchDuration << $6.to_f
			tmpBranchStartNodeId << "internalNode#{numberOfInternalNodes}X"
			working_tree_string.sub!("(#{$1}#{$2}:#{$3},#{$4}#{$5}:#{$6})","internalNode#{numberOfInternalNodes}X")
        end
        
        # Make sure the remainder of the working_tree_string is as expected, and store the root annotation.
        if working_tree_string.match(/[a-zA-Z0-9_]+?(\[\&.[a-zA-Z0-9_]+?=[\"a-zA-Z0-9_\.E-]+?\])/)
        	root_annotation = $1[2..-2]
        else
	        puts "ERROR: The tree string could not be parsed correctly! The remaining unparsed tree string is:"
	        puts "    #{working_tree_string}"
	        exit(1)
        end

        if working_tree_string.include?(",")
        	puts "ERROR: The tree string could not be parsed correctly! The remaining unparsed tree string is:"
        	puts "    #{working_tree_string}"
        	exit(1)
        end

        # Find the maximum duration between tip and root.
        rootId = tmpBranchStartNodeId[-1]
        totalLengthsToRoot = []
        tmpBranchEndNodeId.size.times do |x|
			unless tmpBranchEndNodeId[x].match(/internalNode\d+X/)
				totalLengthToRoot = tmpBranchDuration[x]
				rootReached = false
				currentIndex = 0
				currentStartNodeId = tmpBranchStartNodeId[x]
				unless currentStartNodeId == rootId
					while rootReached == false
						tmpBranchEndNodeId.size.times do |y|
							if tmpBranchEndNodeId[y] == currentStartNodeId
								currentIndex = y
								currentStartNodeId = tmpBranchStartNodeId[y]
								totalLengthToRoot += tmpBranchDuration[y]
								rootReached = true if currentStartNodeId == rootId
								break
							end
						end
					end
				end
				totalLengthsToRoot << totalLengthToRoot
			end
        end
        rootAge = totalLengthsToRoot.max.round(5)

        # Prepare arrays for temporary branch format.
        tmp2BranchID = []
        tmp2BranchOrigin = []
        tmp2BranchTermination = []
        tmp2BranchParentId = []
        tmp2BranchDaughterId1 = []
        tmp2BranchDaughterId2 = []
        tmp2BranchEndCause = []
        tmp2BranchEndNodeId = []
        tmp2BranchAnnotation = []

        # Prepare the first two branches in temporary format (tmpBranchEndNodeId[-1] and tmpBranchEndNodeId[-2] are the two oldest branches).
        # If the first root branch ends in an internal node...
        if tmpBranchEndNodeId[-1].match(/internalNode\d+X/)
			tmp2BranchID << "b0"
			tmp2BranchOrigin << rootAge
			tmp2BranchTermination << rootAge-tmpBranchDuration[-1]
			tmp2BranchParentId << "treeOrigin"
			tmp2BranchDaughterId1 << "unborn"
			tmp2BranchDaughterId2 << "unborn"
			tmp2BranchEndCause << "speciation"
			tmp2BranchEndNodeId << tmpBranchEndNodeId[-1]
			tmp2BranchAnnotation << tmpBranchAnnotation[-1]
        # If it doesn't discriminate between two cases...
        else
			# If it's duration is the same as the root age, it extends all the way to the present.
			if rootAge - tmpBranchDuration[-1] <= 0.001
				tmp2BranchID << "b0"
				tmp2BranchOrigin << rootAge
				tmp2BranchTermination << 0.0
				tmp2BranchParentId << "treeOrigin"
				tmp2BranchDaughterId1 << "none"
				tmp2BranchDaughterId2 << "none"
				tmp2BranchEndCause << "present"
				tmp2BranchEndNodeId << tmpBranchEndNodeId[-1]
				tmp2BranchAnnotation << tmpBranchAnnotation[-1]
			# If it doesn't, it went extinct.
			else
				puts "ERROR: No extinction expected!"
				exit(1)
			end
        end
        # Repeat the above for the second branch.
        # If the second root branch ends in an internal node...
        if tmpBranchEndNodeId[-2].match(/internalNode\d+X/)
			tmp2BranchID << "b1"
			tmp2BranchOrigin << rootAge
			tmp2BranchTermination << (rootAge-tmpBranchDuration[-2]).round(5)
			tmp2BranchParentId << "treeOrigin"
			tmp2BranchDaughterId1 << "unborn"
			tmp2BranchDaughterId2 << "unborn"
			tmp2BranchEndCause << "speciation"
			tmp2BranchEndNodeId << tmpBranchEndNodeId[-2]
			tmp2BranchAnnotation << tmpBranchAnnotation[-2]
        # If it doesn't discriminate between two cases...
        else
			# If it's duration is the same as the root age, it extends all the way to the present.
			if rootAge - tmpBranchDuration[-2] <= 0.001
				tmp2BranchID << "b1"
				tmp2BranchOrigin << rootAge
				tmp2BranchTermination << 0.0
				tmp2BranchParentId << "treeOrigin"
				tmp2BranchDaughterId1 << "none"
				tmp2BranchDaughterId2 << "none"
				tmp2BranchEndCause << "present"
				tmp2BranchEndNodeId << tmpBranchEndNodeId[-2]
				tmp2BranchAnnotation << tmpBranchAnnotation[-2]
			# If it doesn't, it went extinct.
			else
				puts "ERROR: No extinction expected!"
				exit(1)
			end
        end

        # Find out about all remaining branches until either all branches end with extinctions, or all branches have reached the present.
        branchIdCounter = 2
        treeComplete = false
        until treeComplete
			change = false
			tmp2BranchID.size.times do |x| # go through all branches
				if tmp2BranchDaughterId1[x] == "unborn" and tmp2BranchDaughterId2[x] == "unborn" # if a branch terminated with a speciation event in the past, then add the two daughter branches
					# Find the two branches that have the same start node as this branch's end node.
					tmpBranchStartNodeId.size.times do |y|
						if tmpBranchStartNodeId[y] == tmp2BranchEndNodeId[x]
							if tmpBranchEndNodeId[y].match(/internalNode\d+X/)
								tmp2BranchID << "b#{branchIdCounter}"
								tmp2BranchOrigin << tmp2BranchTermination[x]
								tmp2BranchTermination << (tmp2BranchTermination[x]-tmpBranchDuration[y]).round(5)
								tmp2BranchParentId << tmp2BranchID[x]
								tmp2BranchDaughterId1 << "unborn"
								tmp2BranchDaughterId2 << "unborn"
								tmp2BranchEndCause << "speciation"
								tmp2BranchEndNodeId << tmpBranchEndNodeId[y]
								tmp2BranchAnnotation << tmpBranchAnnotation[y]
							else
								if tmp2BranchTermination[x] - tmpBranchDuration[y] <= 0.001
									tmp2BranchID << "b#{branchIdCounter}"
									tmp2BranchOrigin << tmp2BranchTermination[x]
									tmp2BranchTermination << 0.0
									tmp2BranchParentId << tmp2BranchID[x]
									tmp2BranchDaughterId1 << "none"
									tmp2BranchDaughterId2 << "none"
									tmp2BranchEndCause << "present"
									tmp2BranchEndNodeId << tmpBranchEndNodeId[y]
									tmp2BranchAnnotation << tmpBranchAnnotation[y]
								else
									puts "ERROR: No extinction expected!"
									exit(1)
								end
							end
							# Update daughter ids of temporary parent.
							if tmp2BranchDaughterId1[x] == "unborn"
								tmp2BranchDaughterId1[x] = "b#{branchIdCounter}"
							else
								tmp2BranchDaughterId2[x] = "b#{branchIdCounter}"
							end

							# Increase the branchIdCounter
							branchIdCounter += 1
							change = true
						end
					end

				end # if tmp2BranchDaughterId1[x] == "unborn"

			end # tmp2BranchID.size.times do |x|
			treeComplete = true if change == false
        end # until treeComplete

        # Fill array @branch, and at the same time, add species for terminal branches.
        tmp2BranchID.size.times do |x|
			@branch << Branch.new(tmp2BranchID[x], tmp2BranchOrigin[x], tmp2BranchTermination[x], tmp2BranchParentId[x], [tmp2BranchDaughterId1[x],tmp2BranchDaughterId2[x]], tmp2BranchEndCause[x])
			if tmp2BranchEndNodeId[x].match(/internalNode\d+X/)
				newSpeciesId = "unknown"
				@branch.last.addSpeciesId(newSpeciesId)
			else
				newSpeciesId = tmp2BranchEndNodeId[x]
				@branch.last.addSpeciesId(newSpeciesId)
			end
        end
        @branch.each do |b|
			if b.endCause == "present"
				b.updateExtant(true)
			else
				b.updateExtant(false)
			end
		end
	end

	def updateProgenyId
		# Determine the progeny of each branch (needed to know whether conditions are met, and for fossil constraints).
		# First of all, set progeniesComplete to 2 for all extinct and present branches.
		@branch.each {|b| b.progeniesComplete = 2 if b.endCause != "speciation"}
		allProgeniesComplete = false
		until allProgeniesComplete == true do
			# Set progenyPassedOn to true for the two root branches.
			@branch.each {|b| b.progenyPassedOn = true if b.parentId == "treeOrigin"}
			newlyCompleted = []
			@branch.each do |b|
				# Determine if the progeny of this branch is clear but has not been passed on to the parent yet.
				if b.progeniesComplete == 2
					newlyCompleted << b if b.progenyPassedOn == false
				end
			end
			allProgeniesComplete = true if newlyCompleted == []
			newlyCompleted.each do |b|
				# Find parent, pass progeny+self on to parents progeny, add parent.progeniesComplete += 1, and change own progenyPassedOn to true.
				@branch.each do |bb|
					if bb.id == b.parentId
						ary = b.progenyId.dup
						ary << b.id
						aryFlat = ary.flatten
						aryFlat.each {|i| bb.progenyId << i}
						bb.progeniesComplete += 1
						b.progenyPassedOn = true
						break
					end
				end
			end
		end

		# Determine the IDs of terminal species of each branch.
		@branch.each do |b|
			if b.extant or b.endCause == "extinction"
				b.terminalSpeciesId = [b.speciesId]
			else
				terminal_species_id = []
				@branch.each do |bb|
					if b.progenyId.include?(bb.id) and bb.extant
						terminal_species_id << bb.speciesId
					end
				end
				b.terminalSpeciesId = terminal_species_id
			end
		end
	end
	def get_number_of_species
		number_of_species = 0
		@branch.each do |b|
			if b.extant or b.endCause == "extinction"
				number_of_species += 1
			end
		end
		number_of_species
	end
	def get_species_ids
		species_ids = []
		@branch.each do |b|
			if b.extant or b.endCause == "extinction"
				species_ids << b.speciesId
			end
		end
		species_ids
	end
	def add_tip(id,clade,age)
		# Find the branch that corresponds to the stem of the clade.
		target_branch = nil
		@branch.each do |b|
			if b.terminalSpeciesId.sort == clade.sort
				target_branch = b
			end
		end
		if target_branch == nil
			string = "ERROR: No branch combining all species of clade ["
			clade.each do |c|
				string << "#{c},"
			end
			string.chomp!(",")
			string << "] could be found!"
			puts string
			exit 1
		end
		# Make sure the branch is old enough to connect to the fossil.
		if target_branch.origin < age
			puts "ERROR: The connection branch for tip #{id} is too young to connect to it!"
		end
		target_branch_original_origin = target_branch.origin
		target_branch_original_termination = target_branch.termination
		target_branch_original_parentId = target_branch.parentId
		minimum_connection_age = [target_branch.termination,age].max
		connection_age = minimum_connection_age + rand * (target_branch.origin-minimum_connection_age)
		# Define the ids of the tip connection branch and the joint parental branch.
		max_branch_id = 0
		@branch.each {|b| max_branch_id = b.id[1..-1].to_i if b.id[1..-1].to_i > max_branch_id}
		joint_parental_branch_id = "b#{max_branch_id+1}"
		fossil_connection_branch_id = "b#{max_branch_id+2}"
		# Shorten the target branch.
		target_branch.updateOrigin(connection_age)
		# Update the parent id of the target branch.
		target_branch.updateParentId(joint_parental_branch_id)
		# Update the daughter id of the parent of the target branch.
		@branch.each do |b|
			if b.daughterId[0] == target_branch.id
				b.updateDaughterId([joint_parental_branch_id,b.daughterId[1]])
				break
			elsif b.daughterId[1] == target_branch.id
				b.updateDaughterId([b.daughterId[0],joint_parental_branch_id])
				break
			end
		end
		# Add the two new branches to the branch array.
		#          Branch.new(tmp2BranchID[x], tmp2BranchOrigin[x], tmp2BranchTermination[x], tmp2BranchParentId[x], [tmp2BranchDaughterId1[x],tmp2BranchDaughterId2[x]], tmp2BranchEndCause[x])
		@branch << Branch.new(joint_parental_branch_id, target_branch_original_origin, connection_age, target_branch_original_parentId, [target_branch.id,fossil_connection_branch_id], "speciation")
		@branch << Branch.new(fossil_connection_branch_id, connection_age, age, joint_parental_branch_id, ["none","none"], "extinction")
		@branch.last.addSpeciesId(id)
	end
	def to_newick
		decimals = 6
		exportBranch = Marshal.load(Marshal.dump(@branch))

		# Make sure branches have unique origins.
		branch_origins = []
		exportBranch.each {|b| branch_origins << b.origin}
		branch_origins.each do |b|
			if branch_origins.count(b) != 2
				raise "ERROR: Each branch origin is expected to occur twice, but this is not the case for #{b}!"
			end
		end

		# Sort all branches according to origin.
		sortedBranch = exportBranch.sort { |a,b| b.origin <=> a.origin }
		
		# Initiate a newick string.
		newickString = "(#{sortedBranch[0].id}:#{sortedBranch[0].duration.round(decimals)},#{sortedBranch[1].id}:#{sortedBranch[1].duration.round(decimals)})"
		newickString = newickString.dup
		# Evolve the newick string. For each new pair of branches (i.e. at each speciation event) do the following.
		2.upto(sortedBranch.size-1) do |s|
			if s.even? == true
				# Find sisters.
				sister1 = sortedBranch[s]
				sister2 = sortedBranch[s+1]
				if sister1.parentId != sister2.parentId # this should not be called at all. sister1.parentId should always equal sister2.parentId.
					raise "The parent Id (#{sister1.parentId}) of sister 1 (#{sister1.id}) is different from the parent Id (#{sister2.parentId}) of sister 2 (#{sister2.id})!"
				end
				# Replace parts of the string, adding the sisters.
				findString = "#{sister1.parentId}:"
				replaceString = "(#{sister1.id}:#{sister1.duration.round(decimals)},#{sister2.id}:#{sister2.duration.round(decimals)}):"
				newickString.sub!(findString,replaceString)
			end
		end

		# Add species ids to tree string.
		exportBranch.size.times do |b|
			if exportBranch[b].extant or exportBranch[b].endCause == "extinction"
				newickString.sub!("#{exportBranch[b].id}:","#{exportBranch[b].speciesId}:")
			end
		end

		# Return the newick string.
		newickString
	end
end

# Define a class for branches.
class Branch
	attr_reader :id, :origin, :termination, :parentId, :daughterId, :endCause, :extant, :speciesId, :endPosition, :startPosition, :duration, :progeniesComplete, :progenyPassedOn, :progenyId, :terminalSpeciesId
	attr_writer :progeniesComplete, :progenyPassedOn, :progenyId, :terminalSpeciesId
	def initialize(id, origin, termination, parentId, daughterId, endCause)
		@id = id
		@origin = origin
		@termination = termination
		@duration = @origin - @termination
		@parentId = parentId
		@daughterId = daughterId # an array with two items
		@endCause = endCause
		@extant = false
		@progenyId = []
		@terminalSpeciesId = []
		@progeniesComplete = 0
		@progenyPassedOn = false
		@speciesId = "none"
	end
	def addSpeciesId(speciesId)
		@speciesId = speciesId
	end
	def updateExtant(extant)
		@extant = extant
	end
	def updateOrigin(origin)
		@origin = origin
		@duration = @origin - @termination
	end
	def updateParentId(parentId)
		@parentId = parentId
	end
	def updateDaughterId(daughterId)
		@updateDaughterId = daughterId
	end
	def to_s
		string = ""
		string << "ID:                               #{@id}\n"
		string << "Origin:                           #{@origin}\n"
		string << "Termination:                      #{@termination}\n"
		string << "End cause:                        #{@endCause}\n"
		string << "Parent ID:                        #{@parentId}\n"
		string << "Daughter ID 1:                    #{@daughterId[0]}\n"
		string << "Daughter ID 2:                    #{@daughterId[1]}\n"
		string << "Species ID:                       #{@speciesId}\n"
		string << "Clade:                            ["
		@terminalSpeciesId.each {|s| string << "#{s},"}
		string.chomp!(",")
		string << "]\n"
		string << "\n"
		string
	end
end

# Get the command line arguments.
input_trees_file_name = ARGV[0]
output_tree_file_name = ARGV[1]

# Read the input file.
input_trees_file = File.open(input_trees_file_name)
input_trees_file_lines = input_trees_file.readlines

# Identify and read the translate block.
in_translate_block = false
translate_lines = []
input_trees_file_lines.each do |l|
	if l.downcase.strip == "translate"
		in_translate_block = true
	elsif l.include?(";")
		in_translate_block = false
	elsif in_translate_block
		translate_lines << l
	end
end
translation = Hash.new
translate_lines.each do |l|
	line_ary = l.strip.split
	species_number = line_ary[0]
	species_name = line_ary[1].chomp(",")
	translation[species_number] = species_name
end

# Identify and read the trees block.
input_tree_lines = []
input_trees_file_lines.each do |l|
	if l[0..3].downcase == "tree"
		input_tree_lines << l
	end
end

# Create a Tree object for each tree line.
trees = []
input_tree_lines.each do |l|
	tree_string = l[l.index("(")..-1].strip.chomp(";").chomp(":0.0")
	translation.each {|species_number, species_name| tree_string.sub!(",#{species_number}[",",#{species_name}[")}
	translation.each {|species_number, species_name| tree_string.sub!("(#{species_number}[","(#{species_name}[")}
	trees << Tree.new(tree_string)
end

# Parse all trees.
trees.each {|t| t.parse}
trees.each {|t| t.updateProgenyId}

# Add fossils as tips to all trees.
trees.each do |t|
	t.add_tip("Bpr1",["Bpa","Bma","Bba","Bp1","Bp2"],20.4)
	t.add_tip("Cgo",["Ctu","Cwa","Cnu","Chy","Cfu"],20.4)
	t.add_tip("Nsp",["Nqu","Npl","Nco","Nke","Ngr","Nbi"],20.4)
	t.add_tip("Sdof",["Sdo"],5.3)
	t.add_tip("Shef",["SheGOV","SheCLA"],5.3)
	t.add_tip("Nquf",["Nqu"],5.3)
	t.add_tip("Bmaf",["Bma"],5.3)
	t.updateProgenyId
end
trees.each do |t|
	t.add_tip("Bpr2",["Bpr1"],16.0)
	t.updateProgenyId
end

# Prepare an output tree string.
output_tree_string = "#nexus\n"
output_tree_string << "begin taxa;\n"
output_tree_string << "    dimensions ntax=#{trees[0].get_number_of_species};\n"
output_tree_string << "    taxlabels\n"
species_ids = trees[0].get_species_ids
species_ids.each do |n|
	output_tree_string << "        #{n}\n"
end
output_tree_string << "    ;\n"
output_tree_string << "end;\n"
output_tree_string << "begin trees;\n"
trees.size.times do |x|
	output_tree_string << "    tree #{x.to_s.ljust(4)} = #{trees[x].to_newick}:0.0;\n"
end
output_tree_string << "end;\n"

# Write the output tree file.
output_tree_file = File.open(output_tree_file_name,"w")
output_tree_file.write(output_tree_string)
output_tree_file.close
