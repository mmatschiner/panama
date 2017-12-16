# m_matschiner Mon Dec 19 18:40:26 CET 2016

for i in ../res/snapp/replicates/r??
do
	ruby add_theta_to_log.rb -l ${i}/ariidae.log -t ${i}/ariidae.trees -g 2 -o ${i}/ariidae_w_theta.log
done