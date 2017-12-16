# m_matschiner Sat Nov 12 00:21:14 CET 2016

for type in variants_corrected invariants_added variants_uncorrected
do
	ruby plot_parameters.rb ../res/snapp/ex4/${type}/summary/parameter_estimates.txt 0.000005 0.01 clock_rate true ../res/snapp/ex4/${type}/summary/clock_rates.svg
	ruby plot_parameters.rb ../res/snapp/ex4/${type}/summary/parameter_estimates.txt 0.000005 0.01 theta true ../res/snapp/ex4/${type}/summary/thetas.svg
	ruby plot_parameters.rb ../res/snapp/ex4/${type}/summary/parameter_estimates.txt 0 50000 pop_size false ../res/snapp/ex4/${type}/summary/pop_sizes.svg
done