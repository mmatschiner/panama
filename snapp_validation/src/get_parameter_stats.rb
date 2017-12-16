# m_matschiner Mon Nov 27 12:01:37 CET 2017

# Define a function for the mean.
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
end

# Get the command-line arguments.
parameter_file_name = ARGV[0]

# Read the parameter file.
parameter_file = File.open(parameter_file_name)
parameter_lines = parameter_file.readlines[1..-1]

# Analyse the parameter estimates.
rate_means = []
rate_hpd_widths = []
rate_correct = 0
theta_means = []
theta_hpd_widths = []
theta_correct = 0
pop_size_means = []
pop_size_hpd_widths = []
pop_size_correct = 0
parameter_lines.each do |l|
	line_ary = l.split
	rate_means << line_ary[1].to_f
	rate_hpd_widths << line_ary[3].to_f - line_ary[2].to_f
	theta_means << line_ary[4].to_f
	theta_hpd_widths << line_ary[6].to_f - line_ary[5].to_f
	pop_size_means << line_ary[7].to_f
	pop_size_hpd_widths << line_ary[9].to_f - line_ary[8].to_f
	rate_correct += 1 if line_ary[3].to_f > 0.0002 and line_ary[2].to_f < 0.0002
	theta_correct += 1 if line_ary[6].to_f > 0.0001 and line_ary[5].to_f < 0.0001
	pop_size_correct += 1 if line_ary[9].to_f > 25000 and line_ary[8].to_f < 25000
end
puts "#{parameter_file_name}:"
puts "Clock rate: mean = #{rate_means.mean}, precision = #{rate_hpd_widths.mean}, accuracy = #{rate_correct}"
puts "Theta: mean = #{theta_means.mean}, precision = #{theta_hpd_widths.mean}, accuracy = #{theta_correct}"
puts "Population size: mean = #{pop_size_means.mean}, precision = #{pop_size_hpd_widths.mean}, accuracy = #{pop_size_correct}"
puts