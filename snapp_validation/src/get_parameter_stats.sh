# m_matschiner Mon Nov 27 12:02:53 CET 2017

# Get statistics for accuracy and precision from files with results of experiment 4.
ruby get_parameter_stats.rb ../analysis/snapp/ex4/variants_corrected/summary/parameter_estimates.txt
ruby get_parameter_stats.rb ../analysis/snapp/ex4/variants_uncorrected/summary/parameter_estimates.txt
ruby get_parameter_stats.rb ../analysis/snapp/ex4/invariants_added/summary/parameter_estimates.txt
