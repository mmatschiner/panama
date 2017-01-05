# m_matschiner Mon Dec 19 18:40:26 CET 2016

for i in ../analysis/snapp/replicates/r??
do
	ruby resources/add_theta_to_log.rb -l ${i}/eciton.log -t ${i}/eciton.trees -g 3 -o ${i}/eciton_w_theta.log
done