# m_matschiner Fri Nov 11 23:35:27 CET 2016

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

# Define class for circles of the SVG graph.
class Circle
	def initialize(x,y,radius,fill_color,stroke_color,stroke_width,opacity)
		@x = x
		@y = y
		@radius = radius
		@fill_color = fill_color
		@stroke_color = stroke_color
		@stroke_width = stroke_width
		@opacity = opacity
	end
	def to_svg
		svg = "<circle cx=\"#{@x}\" cy=\"#{@y}\" r=\"#{@radius}\" fill=\"#{@fill_color}\" stroke=\"#{@stroke_color}\" stroke-width=\"#{@stroke_width}\" fill-opacity=\"#{@opacity}\" />"
		svg
	end
end

# Get the command line arguments.
parameter_file_name = ARGV[0]
lower_end = ARGV[1].to_f
upper_end = ARGV[2].to_f
parameter = ARGV[3]
if ARGV[4].downcase == "true"
	log_scale = true
else
	log_scale = false
end
svg_out_file_name = ARGV[5]

# Read the parameter file and store the mean, lower, and upper of the parameter of choice.
parameter_file = File.open(parameter_file_name)
parameter_lines = parameter_file.readlines
header_line = parameter_lines[0]
header_ary = header_line.split
mean_index = header_ary.index("#{parameter}_mean")
lower_index = header_ary.index("#{parameter}_lower")
upper_index = header_ary.index("#{parameter}_upper")
raise "mean_index is nil!" if mean_index == nil
raise "lower_index is nil!" if lower_index == nil
raise "upper_index is nil!" if upper_index == nil
means = []
lowers = []
uppers = []
parameter_lines[1..-1].each do |l|
	line_ary = l.split
	means << line_ary[mean_index].to_f
	lowers << line_ary[lower_index].to_f
	uppers << line_ary[upper_index].to_f
end

# Some specifications for the SVG output.
dimX = 600
dimY = 400
cr = 6
line_width = 2
frame_stroke_width = 2
dot_color = "grey"
dot_alpha = 1.0
hpd_color = "grey"
hpd_alpha = 0.5
hpd_width = 4.0
side_margin = 20

# Prepare the header of the SVG string.
svg_output = ""
svg_output << "<?xml version=\"1.0\" standalone=\"no\"?>\n"
svg_output << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\">\n"
svg_output << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"#{dimX}\" height=\"#{dimY}\" viewBox=\"0 0 #{dimX} #{dimY}\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
svg_output << "\n"

# Calculate the positions on the x axis for the 100 replicates.
x_positions = []
means.size.times do |x|
	x_positions << side_margin + (dimX-2*side_margin) * x/(means.size-1)
end

# Write the frame.
svg_output << "  <!--Frame-->\n"
svg_output << "  <rect style=\"stroke:black; stroke-width:#{frame_stroke_width/2.0}px; fill:none\" x=\"0\" y=\"0\" width=\"#{dimX}\" height=\"#{dimY}\" />\n"
svg_output << "\n"

# Add SVG elements for each mean value.
circles = []
means.size.times do |x|
	if log_scale
		y_position = ((Math.log(upper_end)-Math.log(means[x]))/(Math.log(upper_end) - Math.log(lower_end))) * dimY
	else
		y_position = ((upper_end-means[x])/(upper_end - lower_end)) * dimY
	end
	circles << Circle.new(x_positions[x],y_position,cr,dot_color,"none",0,dot_alpha)
end

# Add SVG elements for each hpd interval.
lines = []
means.size.times do |x|
	if log_scale
		y_position_lower = ((Math.log(upper_end)-Math.log(lowers[x]))/(Math.log(upper_end) - Math.log(lower_end))) * dimY
		y_position_upper = ((Math.log(upper_end)-Math.log(uppers[x]))/(Math.log(upper_end) - Math.log(lower_end))) * dimY
	else
		y_position_lower = ((upper_end-lowers[x])/(upper_end - lower_end)) * dimY
		y_position_upper = ((upper_end-uppers[x])/(upper_end - lower_end)) * dimY
	end
	lines << Line.new(x_positions[x],x_positions[x],y_position_lower,y_position_upper,hpd_color,hpd_width,hpd_alpha)
end

# Add circles and lines to svg.
lines.each {|l| svg_output << l.to_svg}
circles.each {|c| svg_output << c.to_svg}

# Finalize the SVG string
svg_output << "</svg>\n"

# Write the SVG string to file.
svg_out_file = File.new(svg_out_file_name,"w")
svg_out_file.write(svg_output)
svg_out_file.close
