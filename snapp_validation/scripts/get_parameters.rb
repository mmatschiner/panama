# m_matschiner Fri Nov 11 23:08:59 CET 2016

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
	def hpd_lower(proportion)
		raise "The interval should be between 0 and 1!" if proportion >= 1 or proportion <= 0
		sorted_array = self.sort
		hpd_index = 0
		min_range = sorted_array[-1]
		diff = (proportion*self.size).round
		(self.size-diff).times do |i|
			min_value = sorted_array[i]
			max_value = sorted_array[i+diff-1]
			range = max_value - min_value
			if range < min_range
				min_range = range
				hpd_index = i
			end
		end
		sorted_array[hpd_index]
	end
	def hpd_upper(proportion)
		raise "The interval should be between 0 and 1!" if proportion >= 1 or proportion <= 0
		sorted_array = self.sort
		hpd_index = 0
		min_range = sorted_array[-1]
		diff = (proportion*self.size).round
		(self.size-diff).times do |i|
			min_value = sorted_array[i]
			max_value = sorted_array[i+diff-1]
			range = max_value - min_value
			if range < min_range
				min_range = range
				hpd_index = i
			end
		end
		sorted_array[hpd_index+diff-1]
	end
end


# Get the name of the log file.
log_file_name = ARGV[0]

# Read the log file.
log_file = File.open(log_file_name)
log_lines = log_file.readlines
clock_rates = []
thetas = []
pop_sizes = []
number_of_burnin_lines = (0.1 * log_lines[1..-1].size).to_i
log_lines[(1+number_of_burnin_lines)..-1].each do |l|
	line_ary = l.split
	if line_ary[6..8].include?("NA")
		puts "WARNING: Found NA value"
	else
		clock_rates << line_ary[6].to_f
		thetas << line_ary[7].to_f
		pop_sizes << line_ary[8].to_f
	end
end

# Report mean and lower and upper boundaries of HPD intervals for the three parameters.
print "#{clock_rates.mean}\t#{clock_rates.hpd_lower(0.95)}\t#{clock_rates.hpd_upper(0.95)}\t#{thetas.mean}\t#{thetas.hpd_lower(0.95)}\t#{thetas.hpd_upper(0.95)}\t#{pop_sizes.mean}\t#{pop_sizes.hpd_lower(0.95)}\t#{pop_sizes.hpd_upper(0.95)}"
