# m_matschiner Wed Oct 19 22:59:46 CEST 2016

# Add a sum function to arrays and other enumerables.
module Enumerable
	def sum
		self.inject(0){|accum, i| accum + i }
	end
end

# Define a class for trees.
class Tree
	attr_reader :branch
	def initialize(tree_string)
		@original_tree_string = tree_string
	end
	def parse
		decimals = 6
        # Parse the tree string and store all information temporarily in arrays.
        working_tree_string = @original_tree_string.dup
        tmpBranchEndNodeId = []
        tmpBranchAnnotation = []
        tmpBranchDuration = []
        tmpBranchStartNodeId = []
        numberOfInternalNodes = 0
        while working_tree_string.match(/\(([a-zA-Z0-9_]+?):\{([a-zA-Z0-9_\,\.\-:]+?)\}\,([a-zA-Z0-9_]+?):\{([a-zA-Z0-9_\,\.\-:]+?)\}\)/)
			numberOfInternalNodes += 1
			tmpBranchEndNodeId << $1
			tmpBranchAnnotation << $2
			tmpBranchStartNodeId << "internalNode#{numberOfInternalNodes}X"
			annotation_ary = $2.split(":")
			total_duration = 0
			annotation_ary.each {|i| total_duration += i.split(",")[1].to_f}
			tmpBranchDuration << total_duration
			tmpBranchEndNodeId << $3
			tmpBranchAnnotation << $4
			annotation_ary = $4.split(":")
			total_duration = 0
			annotation_ary.each {|i| total_duration += i.split(",")[1].to_f}
			tmpBranchDuration << total_duration
			tmpBranchStartNodeId << "internalNode#{numberOfInternalNodes}X"
			working_tree_string.sub!("(#{$1}:{#{$2}},#{$3}:{#{$4}})","internalNode#{numberOfInternalNodes}X")
        end

        # Make sure the remainder of the working_tree_string is as expected, and store the root annotation.
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
        rootAge = totalLengthsToRoot.max.round(decimals)

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
        # Test if the first root branch ends in an internal node.
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
        # If it doesn't, discriminate between the following two cases.
        else
        	# For the catfish data set this case is not expected.
        	puts "ERROR: Found root branch that does not end in speciation."
        	exit 1
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
        # Test if the second root branch ends in an internal node.
        if tmpBranchEndNodeId[-2].match(/internalNode\d+X/)
			tmp2BranchID << "b1"
			tmp2BranchOrigin << rootAge
			tmp2BranchTermination << (rootAge-tmpBranchDuration[-2]).round(decimals)
			tmp2BranchParentId << "treeOrigin"
			tmp2BranchDaughterId1 << "unborn"
			tmp2BranchDaughterId2 << "unborn"
			tmp2BranchEndCause << "speciation"
			tmp2BranchEndNodeId << tmpBranchEndNodeId[-2]
			tmp2BranchAnnotation << tmpBranchAnnotation[-2]
        # If it doesn't, discriminate between the following two cases.
        else
        	# For the catfish data set this case is not expected.
        	puts "ERROR: Found root branch that does not end in speciation."
        	exit 1
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
								tmp2BranchTermination << (tmp2BranchTermination[x]-tmpBranchDuration[y]).round(decimals)
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
									tmp2BranchID << "b#{branchIdCounter}"
									tmp2BranchOrigin << tmp2BranchTermination[x]
									tmp2BranchTermination << (tmp2BranchTermination[x]-tmpBranchDuration[y]).round(decimals)
									tmp2BranchParentId << tmp2BranchID[x]
									tmp2BranchDaughterId1 << "none"
									tmp2BranchDaughterId2 << "none"
									tmp2BranchEndCause << "extinction"
									tmp2BranchEndNodeId << tmpBranchEndNodeId[y]
									tmp2BranchAnnotation << tmpBranchAnnotation[y]
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
        @branch = []
        @species = []
        tmp2BranchID.size.times do |x|
			@branch << Branch.new(tmp2BranchID[x], tmp2BranchOrigin[x], tmp2BranchTermination[x], tmp2BranchParentId[x], [tmp2BranchDaughterId1[x],tmp2BranchDaughterId2[x]], tmp2BranchEndCause[x], tmp2BranchAnnotation[x])
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
					if b.progenyId.include?(bb.id)
						if bb.extant or bb.endCause == "extinction"
							terminal_species_id << bb.speciesId
						end
					end
				end
				b.terminalSpeciesId = terminal_species_id
			end
		end
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
				parent = nil
				@branch.each do |b|
					if b.id == sister1.parentId
						parent = b
						break
					end
				end
				if parent == nil
					puts "ERROR: Parent could not be found!"
					exit 1
				end
				# Replace parts of the string, adding the sisters.
				findString = "#{sister1.parentId}:"
				replaceString = "(#{sister1.id}:#{sister1.duration.round(decimals)},#{sister2.id}:#{sister2.duration.round(decimals)})[&geography=\"#{parent.endAnnotation}\"]:"
				newickString.sub!(findString,replaceString)
			end
		end

		# Add the root annotation to the tree.
		if @branch[0].startAnnotation != @branch[1].startAnnotation
			puts "ERROR: The start annotation of the first two branches differs!"
			exit 1
		else
			newickString << "[&geography=\"#{@branch[0].startAnnotation}\"]"
		end

		# Add species ids to newick string.
		exportBranch.size.times do |b|
			if exportBranch[b].extant or exportBranch[b].endCause == "extinction"
				newickString.sub!("#{exportBranch[b].id}:","#{exportBranch[b].speciesId}[&geography=\"#{exportBranch[b].endAnnotation}\"]:")
			end
		end

		# Return the newick string.
		newickString
	end
	def to_s
		@tree_string
	end
end

# Define a class for branches.
class Branch
	attr_reader :id, :origin, :termination, :parentId, :daughterId, :endCause, :extant, :annotation, :speciesId, :endPosition, :startPosition, :duration, :progeniesComplete, :progenyPassedOn, :progenyId, :terminalSpeciesId
	attr_writer :progeniesComplete, :progenyPassedOn, :progenyId, :terminalSpeciesId
	def initialize(id, origin, termination, parentId, daughterId, endCause, annotation)
		@id = id
		@origin = origin
		@termination = termination
		@duration = @origin - @termination
		@parentId = parentId
		@daughterId = daughterId # an array with two items
		@endCause = endCause
		@extant = false
		@annotation = annotation
		@startAnnotation = nil
		@endAnnotation = nil
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
	def updateAnnotation(annotation)
		@annotation = annotation
	end
	def startAnnotation
		@annotation.split(":").last.split(",")[0]
	end
	def endAnnotation
		@annotation.split(":").first.split(",")[0]
	end
	def addStartPosition(startPosition)
		@startPosition = startPosition
	end
	def addEndPosition(endPosition)
		@endPosition = endPosition
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
		string << "Annotation                        #{@annotation}\n"
		string << "Position at origin:               #{@startPosition}\n"
		string << "Position at termination:          #{@endPosition}\n"		
		string << "\n"
		string
	end
end

# Define a class for lines of the SVG graph.
class Line
	attr_reader :x_start, :x_end, :y_start, :y_end, :color
	def initialize(x_start,x_end,y_start,y_end,color,stroke,opacity)
		@x_start = x_start
		@x_end = x_end
		@y_start = y_start
		@y_end = y_end
		@color = color
		@stroke = stroke
		@opacity = opacity
	end
	def to_s
		string = ""
		string << "Start:  #{@x_start.round(3)},#{@y_start.round(3)}\n"
		string << "End:    #{@x_end.round(3)},#{@y_end.round(3)}\n"
		string << "Color:  #{@color}\n"
		string << "Stroke: #{@stroke}\n"
		string << "\n"
		string
	end
	def to_svg
		svg = "<line x1=\"#{@x_start.round(3)}\" y1=\"#{@y_start.round(3)}\" x2=\"#{@x_end.round(3)}\" y2=\"#{@y_end.round(3)}\" stroke=\"#{@color}\" stroke-width=\"#{@stroke}\" stroke-opacity=\"#{@opacity}\" />"
		svg
	end
	def max_y
		[@y_start,@y_end].max
	end
end

# Define a class for text of the SVG graph.
class Text
	def initialize(x,y,font,font_size,string)
		@x = x
		@y = y
		@font = font
		@font_size = font_size
		@string = string
	end
	def to_svg
		svg = "<text font-family=\"#{@font}\" font-size=\"#{@font_size}\" x=\"#{@x}\" y=\"#{@y}\">#{@string}</text>"
		svg
	end
end

# Define class for rectangles of the SVG graph.
class Rectangle
	def initialize(x,y,width,height,fill,color,stroke,opacity)
		@x = x
		@y = y
		@width = width
		@height = height
		@fill = fill
		@color = color
		@stroke = stroke
		@opacity = opacity
	end
	def to_svg
		svg = "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\" fill=\"#{@fill}\" stroke=\"#{@color}\" stroke-width=\"#{@stroke}\" fill-opacity=\"#{@opacity}\" stroke-opacity=\"#{@opacity}\" />"
		svg
	end
end

# Define class for paths of the SVG graph.
class Path
	def initialize(x,y,fill,color,stroke,opacity)
		@x = [x]
		@y = [y]
		@fill = fill
		@color = color
		@stroke = stroke
		@opacity = opacity
	end
	def add_point(x,y)
		@x << x
		@y << y
	end
	def to_svg
		svg = "<path d=\"M #{@x[0]} #{@y[0]} "
		if @x.size > 1
			1.upto(@x.size-1) do |z|
				svg << "L #{@x[z]} #{@y[z]} "
			end
		end
		svg << "z\" fill=\"#{@fill}\" stroke=\"#{@color}\" stroke-width=\"#{@stroke}\" fill-opacity=\"#{@opacity}\" />"
		svg
	end
end

# Read the input file.
trees_file_name = ARGV[0]
trees_file = File.open(trees_file_name)
trees_file_lines = trees_file.readlines

# Create a Tree object for each tree line.
trees = []
trees_file_lines.each do |l|
	tree_string = l[l.index("(")..-1].strip.chomp(";")
	trees << Tree.new(tree_string)
end

# Parse all trees.
trees.each {|t| t.parse}
trees.each {|t| t.updateProgenyId}

# Get the age of the overall oldest tree.
oldest_tree_age = 0
trees.each do |t|
	t.branch.each do |b|
		if b.origin > oldest_tree_age
			oldest_tree_age = b.origin
		end
	end
end

# Prepare a nexus output string.
nexus_string = "#nexus\n"
nexus_string << "begin trees\n"
trees.size.times do |x|
	nexus_string << "    tree #{x.to_s.ljust(4)} = #{trees[x].to_newick}:0.0;\n"
end
nexus_string << "end;\n"

# Write the nexus output string.
nexus_output_file_name = ARGV[1]
nexus_output_file = File.open(nexus_output_file_name,"w")
nexus_output_file.write(nexus_string)
nexus_output_file.close

# Run the external script produce_mcc_tree.sh to generate a maximum-clade-credibility tree with TreeAnnotator.
`bash produce_mcc_tree.sh #{nexus_output_file_name} #{nexus_output_file_name.chomp(".trees")}.tre`

# Use R to convert the MCC tree from nexus to newick file format.
`rscript simplify_tree.r #{nexus_output_file_name.chomp(".trees")}.tre #{nexus_output_file_name.chomp(".trees")}_simple.tre`

# Read the file with the maximum-clade-credibility tree.
mcc_tree_file = File.open("#{nexus_output_file_name.chomp(".trees")}_simple.tre")
mcc_tree_lines = mcc_tree_file.readlines
mcc_tree_string = mcc_tree_lines[0].chomp(";")

# Convert the tree string to simmap format.
while mcc_tree_string.match(/:(\d+\.\d+)([,\)])/)
	mcc_tree_string.sub!(":#{$1}#{$2}",":{Unknown,#{$1}}#{$2}")
end

# Add the MCC tree to the array of tree objects.
trees << Tree.new(mcc_tree_string)
trees.last.parse
trees.last.updateProgenyId

# Store all migration times in an array.
migration_times = []
trees[1..-2].each do |t|
	t.branch.each do |b|
		if b.annotation.include?(":")
			annotation_ary = b.annotation.split(":")
			partial_branch_lengths = []
			annotation_ary[0..-2].each do |i|
				partial_branch_lengths << i.split(",")[1].to_f
			end
			migration_time = b.termination
			partial_branch_lengths.each do |i|
				migration_time += i
				migration_times << migration_time
			end
		end
	end
end
migration_times_string = ""
migration_times.each do |i|
	migration_times_string << "#{i.round(6)}\n"
end

# Write a file with all migration times.
migration_times_file_name = ARGV[2]
migration_times_file = File.open(migration_times_file_name,"w")
migration_times_file.write(migration_times_string)

# Read the file in which the order of species in the output plot is specified.
species_order_file_name = ARGV[3]
species_order_file = File.open(species_order_file_name)
species_order_file_lines = species_order_file.readlines
species_order = []
species_order_file_lines.each {|l| species_order << l.strip}

# Assign position values to each branch that reflect this order.
trees.each do |t|
	t.branch.each do |b|
		unless b.speciesId == "unknown"
			unless species_order.include?(b.speciesId)
				puts "ERROR: Species ID #{b.speciesId} could not be found in file #{species_order_file_name}!"
			end
			b.addEndPosition(species_order.index(b.speciesId))
		end
	end
	all_end_positions_assigned = false
	until all_end_positions_assigned
		all_end_positions_assigned = true
		t.branch.each do |b|
			if b.endPosition == nil
				all_end_positions_assigned = false
				daughter0 = nil
				daughter1 = nil
				t.branch.each do |bb|
					if b.daughterId[0] == bb.id
						daughter0 = bb
					elsif b.daughterId[1] == bb.id
						daughter1 = bb
					end
				end
				if daughter0.endPosition and daughter1.endPosition
					b.addEndPosition((daughter0.endPosition+daughter1.endPosition)/2.0)
				end
			end
		end
	end
	t.branch.each do |b|
		if b.parentId == "treeOrigin"
			b.addStartPosition((t.branch[0].endPosition+t.branch[1].endPosition)/2.0)
		else
			t.branch.each do |bb|
				if b.parentId == bb.id
					b.addStartPosition(bb.endPosition)
					break
				end
			end
		end
	end
end

# Get a list of unique annotations.
start_annotations = []
trees.each do |t|
	t.branch.each do |b|
		start_annotations << b.startAnnotation
	end
end
unique_annotations = start_annotations.uniq

# Define constants for the SVG generation.
#colors = ["#ef2746","#616eb1"]
mcc_color = "#000000"
colors = ["#99c6b3","#6161af",mcc_color]
svg_width = 180
svg_height = 160
window_width = 130
window_height = 90
window_top_margin = 2
window_left_margin = 20
window_right_margin = svg_width-(window_width+window_left_margin)
window_internal_spacer = 2
window_spacer = 2
time_scale_maximum = oldest_tree_age.ceil
number_of_species = species_order.size
branch_stroke = 0.05
branch_opacity = 0.08
text_correction_y = 0.7
max_vertical_shift = 0.8
mcc_branch_stroke = 0.3

# Make sure the number of colors is sufficient to display all annotation.
if colors.size < unique_annotations.size
	puts "ERROR: Not enough colours have been defined to display annotations!"
	exit(1)
end

# Initialize arrays for elements of the SVG image.
lines = []
texts = []
rectangles = []
paths = []

# Create a Line object for each branch of each tree.
trees.each do |t|
	if t == trees.last
		random_vertical_shift = 0
	else
		random_vertical_shift = -max_vertical_shift+rand*2*max_vertical_shift
	end
	t.branch.each do |b|
		time_start = b.origin
		time_end = b.termination
		# # Temporarily set the age of extinct taxa to 0 (will be corrected later).
		# time_end = 0.0 if b.endCause == "extinction"
		position_start = b.startPosition
		position_end = b.endPosition
		# Correct the positions of two clades.
		if b.terminalSpeciesId.sort == ["Nbi","Nco","Ngr","Nke","Npl","Nqu","Nquf","Nsp"]
			position_end = 16.98525
		elsif b.terminalSpeciesId.sort == ["Nbi","Nco","Ngr","Nke","Npl","Nqu","Nquf"]
			position_start = 16.98525
		elsif b.terminalSpeciesId == ["Nsp"]
			position_start = 16.98525
		end
		if b.terminalSpeciesId.sort == ["Ans","Ase","Sdo","Sdof","SheCLA","SheGOV","Shef","Spa","Spr"]
			position_end = 2.446578125
		elsif b.terminalSpeciesId.sort == ["Ans","Ase"]
			position_start = 2.446578125
		elsif b.terminalSpeciesId.sort == ["Sdo","Sdof","SheCLA","SheGOV","Shef","Spa","Spr"]
			position_start = 2.446578125
		end
		x_start_in_window = window_internal_spacer+((time_scale_maximum-time_start)/time_scale_maximum)*(window_width-2*window_internal_spacer)
		x_end_in_window = window_internal_spacer+((time_scale_maximum-time_end)/time_scale_maximum)*(window_width-2*window_internal_spacer)
		y_start_in_window = window_internal_spacer+(position_start/(number_of_species-1).to_f)*(window_height-2*window_internal_spacer)
		y_end_in_window = window_internal_spacer+(position_end/(number_of_species-1).to_f)*(window_height-2*window_internal_spacer)
		x_start = window_left_margin+x_start_in_window
		x_end = window_left_margin+x_end_in_window
		y_start = window_top_margin+y_start_in_window+random_vertical_shift
		y_end = window_top_margin+y_end_in_window+random_vertical_shift
		# # Correct for the age of extinct taxa, which was set to 0 above.
		# if b.endCause == "extinction"
		# 	y_end = y_start + (y_end-y_start) * (b.duration/b.origin)
		# 	x_end = x_start + (x_end-x_start) * (b.duration/b.origin)
		# end
		if b.annotation.include?(":")
			# Analyse the annotation of this branch for migration times.
			annotation_ary = b.annotation.split(":")
			partial_colors = []
			partial_lengths = []
			annotation_ary.each do |i|
				partial_colors << colors[unique_annotations.index(i.split(",")[0])]
				partial_lengths << i.split(",")[1].to_f
			end
			# Reverse the two arrays since the original annotation is sorted from present to past, but here we sort from past to present.
			partial_colors.reverse!
			partial_lengths.reverse!
			# Make sure the sum of the partial lengths is very close to the total branch duration.
			unless (partial_lengths.sum - b.duration).round(4) == 0
				puts "ERROR: The sum of the partial lengths of a branch is different from the total branch length!"
				exit 1
			end
			# Calculate the relative start and end points of the individual fragments.
			partial_starts_relative = []
			partial_ends_relative = []
			partial_starts_relative << 0.0
			(partial_lengths.size-1).times do |x|
				partial_sum_relative = (partial_lengths[0..x].sum/b.duration)
				partial_starts_relative << partial_sum_relative
				partial_ends_relative << partial_sum_relative
			end
			partial_ends_relative << 1.0
			partial_starts_relative.size.times do |x|
				x_start_partial = x_start + (x_end-x_start)*partial_starts_relative[x]
				x_end_partial = x_start + (x_end-x_start)*partial_ends_relative[x]
				y_start_partial = y_start + (y_end-y_start)*partial_starts_relative[x]
				y_end_partial = y_start + (y_end-y_start)*partial_ends_relative[x]
				color = partial_colors[x]
				lines << Line.new(x_start_partial,x_end_partial,y_start_partial,y_end_partial,color,branch_stroke,branch_opacity)
			end
		else
			color = colors[unique_annotations.index(b.startAnnotation)]
			if color == mcc_color
				lines << Line.new(x_start,x_end,y_start,y_end,color,mcc_branch_stroke,1.0)
			else
				lines << Line.new(x_start,x_end,y_start,y_end,color,branch_stroke,branch_opacity)
			end
		end
	end
end

# Add a rectangle to demarcate the window.
rectangles << Rectangle.new(window_left_margin,window_top_margin,window_width,window_height,"none","black",0.1,1.0)

# Add species labels to the window.
font = "Helvetica-Oblique"
font_size = 6/2.8346444444
species_order.size.times do |x|
	x_in_window = window_width
	x_in_fig = window_left_margin+x_in_window
	y_in_window = text_correction_y+window_internal_spacer+(x/(number_of_species-1).to_f)*(window_height-2*window_internal_spacer)
	y_in_fig = window_top_margin+y_in_window
	string = species_order[x]
	texts << Text.new(x_in_fig, y_in_fig, font, font_size, string)
end

# Add a time scale below the window.
x_start_in_window = window_internal_spacer
x_end_in_window = window_width-window_internal_spacer
x_start_in_fig = window_left_margin+x_start_in_window
x_end_in_fig = window_left_margin+x_end_in_window
y_in_fig = window_top_margin+window_height+window_spacer
lines << Line.new(x_start_in_fig,x_end_in_fig,y_in_fig,y_in_fig,"black",0.25,1.0)
font = "Helvetica"
font_size = 6/2.8346444444
texts << Text.new(x_start_in_fig, y_in_fig+3*text_correction_y, font, font_size, "#{time_scale_maximum}")
texts << Text.new(x_end_in_fig, y_in_fig+3*text_correction_y, font, font_size, "0")

# Prepare the svg string.
svg_string = ""
svg_string << "<?xml version=\"1.0\" standalone=\"no\"?>\n"
svg_string << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n"
svg_string << "<svg width=\"#{svg_width}mm\" height=\"#{svg_height}mm\" viewBox=\"0 0 #{svg_width} #{svg_height}\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"
texts.each {|t| svg_string << "    #{t.to_svg}\n"}
paths.each {|p| svg_string << "    #{p.to_svg}\n"}
rectangles.each {|r| svg_string << "    #{r.to_svg}\n"}
lines.each {|l| svg_string << "    #{l.to_svg}\n"}
svg_string << "</svg>\n"

# Write the svg string to file.
svg_file_name = ARGV[4]
svg_file = File.new(svg_file_name,"w")
svg_file.write(svg_string)
