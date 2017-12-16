# m_matschiner Mon Oct 17 16:24:18 CEST 2016

# Convert the time string from hours per million iterations to seconds per iteration.
time_string = ARGV[0]
time_string.match(/([0-9]+)h([0-9]+)m([0-9]+)s/)
puts (($1.to_f*3600.0 + $2.to_f*60.0 + $3.to_f)/1000000.0).round(5)
