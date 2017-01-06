# m_matschiner Tue Oct 25 23:53:52 CEST 2016

input_file_name = ARGV[0]
input_file = File.open(input_file_name)
input_lines = input_file.readlines

input_lines.each do |l|
	if l[0..3].downcase == "tree"
		theta_annotation = l.match(/null=[\d\.E\-]+/)
		puts theta_annotation.to_s.split("=")[1]
	end
end