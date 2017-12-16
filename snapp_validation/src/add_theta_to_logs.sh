# m_matschiner Fri Nov 11 17:58:18 CET 2016

# Add thetas to all log files of experiment 4.
for type in invariants_added variants_corrected variants_uncorrected
do
	for i in ../res/snapp/ex4/${type}/r????
	do
		ruby add_theta_to_log.rb -l ${i}/snapp.log -t ${i}/snapp.trees -g 5 -o ${i}/snapp_w_theta.log
	done
done
