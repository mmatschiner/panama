# m_matschiner Sun Nov 13 00:00:28 CET 2016

# Add statistics to Enumerable.
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
end

# Define a class for lines of the SVG graph.
class Line
	def initialize(x_start,x_end,y_start,y_end,color,stroke,opacity)
		@x_start = x_start
		@x_end = x_end
		@y_start = y_start
		@y_end = y_end
		@color = color
		@stroke = stroke
		@opacity = opacity
	end
	def to_svg
		svg = "<line x1=\"#{@x_start.round(3)}\" y1=\"#{@y_start.round(3)}\" x2=\"#{@x_end.round(3)}\" y2=\"#{@y_end.round(3)}\" stroke=\"#{@color}\" stroke-width=\"#{@stroke}\" stroke-opacity=\"#{@opacity}\" />"
		svg
	end
end

# Get the command line arguments.
input_file_name1 = ARGV[0]
input_file_name2 = ARGV[1]
svg_out_file_name = ARGV[2]

# Read the input files.
input_file1 = File.open(input_file_name1)
input_lines1 = input_file1.readlines
input_file2 = File.open(input_file_name2)
input_lines2 = input_file2.readlines

# Get the true ages and the corresponding proportional age errors.
true_ages1 = []
true_ages2 = []
prop_age_errors1 = []
input_lines1.each do |l|
	unless l.strip == ""
		unless l.include?("true")
			line_ary = l.split
			true_age = line_ary[0].to_f
			estimated_age = line_ary[1].to_f
			true_ages1 << true_age
			prop_age_errors1 << (estimated_age/true_age)-1
		end
	end
end
prop_age_errors2 = []
input_lines2.each do |l|
	unless l.strip == ""
		unless l.include?("true")
			line_ary = l.split
			true_age = line_ary[0].to_f
			estimated_age = line_ary[1].to_f
			true_ages2 << true_age
			prop_age_errors2 << (estimated_age/true_age)-1
		end
	end
end

# Some specifications for the SVG output.
dimX = 600
dimY = 400
line_width = 2
frame_stroke_width = 2
line_color1 = "#ed2224"
line_color2 = "#818282"
line_alpha = 1.0
line_width = 3.0
min_error = -1
max_error = 2
max_age = 10

# Prepare the header of the SVG string.
svg_output = ""
svg_output << "<?xml version=\"1.0\" standalone=\"no\"?>\n"
svg_output << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">\n"
svg_output << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{dimX}\" height=\"#{dimY}\" viewBox=\"0 0 #{dimX} #{dimY}\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
svg_output << "\n"

# Write the frame.
svg_output << "  <!--Frame-->\n"
svg_output << "  <rect style=\"stroke:black; stroke-width:#{frame_stroke_width/2.0}px; fill:none\" x=\"0\" y=\"0\" width=\"#{dimX}\" height=\"#{dimY}\" />\n"
svg_output << "\n"

# Add a line to the SVG for each proportional node age error.
lines1 = []
lines2 = []
true_ages1.size.times do |x|
	x_pos = (true_ages1[x]/max_age)*dimX
	y_pos_lower = ((max_error-0)/(max_error-min_error).to_f)*dimY
	y_pos_upper = ((max_error-prop_age_errors1[x])/(max_error-min_error))*dimY
	lines1 << Line.new(x_pos,x_pos,y_pos_lower,y_pos_upper,line_color1,line_width,line_alpha)
end
true_ages2.size.times do |x|
	x_pos = (true_ages2[x]/max_age)*dimX
	y_pos_lower = ((max_error-0)/(max_error-min_error).to_f)*dimY
	y_pos_upper = ((max_error-prop_age_errors2[x])/(max_error-min_error))*dimY
	lines2 << Line.new(x_pos,x_pos,y_pos_lower,y_pos_upper,line_color2,line_width,line_alpha)
end

# Add lines to svg.
lines1.each {|l| svg_output << l.to_svg}
lines2.each {|l| svg_output << l.to_svg}

# Finalize the SVG string
svg_output << "</svg>\n"

# Write the SVG string to file.
svg_out_file = File.new(svg_out_file_name,"w")
svg_out_file.write(svg_output)
svg_out_file.close

# Calculate and report statistics.
abs_prop_age_errors1 = []
abs_prop_age_errors1_bin_00_10 = []
abs_prop_age_errors1_bin_10_20 = []
abs_prop_age_errors1_bin_20_30 = []
abs_prop_age_errors1_bin_30_40 = []
abs_prop_age_errors1_bin_40_50 = []
prop_age_errors1.size.times do |x|
	abs_prop_age_errors1 << prop_age_errors1[x].abs
	if true_ages1[x] < 10
		abs_prop_age_errors1_bin_00_10 << prop_age_errors1[x].abs
	elsif true_ages1[x] < 20
		abs_prop_age_errors1_bin_10_20 << prop_age_errors1[x].abs
	elsif true_ages1[x] < 30
		abs_prop_age_errors1_bin_20_30 << prop_age_errors1[x].abs
	elsif true_ages1[x] < 40
		abs_prop_age_errors1_bin_30_40 << prop_age_errors1[x].abs
	elsif true_ages1[x] < 50
		abs_prop_age_errors1_bin_40_50 << prop_age_errors1[x].abs
	end
end
abs_prop_age_errors2 = []
abs_prop_age_errors2_bin_00_10 = []
abs_prop_age_errors2_bin_10_20 = []
abs_prop_age_errors2_bin_20_30 = []
abs_prop_age_errors2_bin_30_40 = []
abs_prop_age_errors2_bin_40_50 = []
prop_age_errors2.size.times do |x|
	abs_prop_age_errors2 << prop_age_errors2[x].abs
	if true_ages2[x] < 10
		abs_prop_age_errors2_bin_00_10 << prop_age_errors2[x].abs
	elsif true_ages2[x] < 20
		abs_prop_age_errors2_bin_10_20 << prop_age_errors2[x].abs
	elsif true_ages2[x] < 30
		abs_prop_age_errors2_bin_20_30 << prop_age_errors2[x].abs
	elsif true_ages2[x] < 40
		abs_prop_age_errors2_bin_30_40 << prop_age_errors2[x].abs
	elsif true_ages2[x] < 50
		abs_prop_age_errors2_bin_40_50 << prop_age_errors2[x].abs
	end
end

puts "Proportional error in #{input_file_name1}:"
puts "Overall: #{abs_prop_age_errors1.mean}"
puts "00-10 Ma: #{abs_prop_age_errors1_bin_00_10.mean}"
puts "10-20 Ma: #{abs_prop_age_errors1_bin_10_20.mean}"
puts "20-30 Ma: #{abs_prop_age_errors1_bin_20_30.mean}"
puts "30-40 Ma: #{abs_prop_age_errors1_bin_30_40.mean}"
puts "40-50 Ma: #{abs_prop_age_errors1_bin_40_50.mean}"
puts
puts "Proportional error in #{input_file_name2}:"
puts "Overall: #{abs_prop_age_errors2.mean}"
puts "00-10 Ma: #{abs_prop_age_errors2_bin_00_10.mean}"
puts "10-20 Ma: #{abs_prop_age_errors2_bin_10_20.mean}"
puts "20-30 Ma: #{abs_prop_age_errors2_bin_20_30.mean}"
puts "30-40 Ma: #{abs_prop_age_errors2_bin_30_40.mean}"
puts "40-50 Ma: #{abs_prop_age_errors2_bin_40_50.mean}"


