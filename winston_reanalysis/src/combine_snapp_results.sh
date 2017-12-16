# m_matschiner Mon Dec 12 12:31:53 CET 2016

# Combine log and trees files for the analyses based on molecular data only.
mkdir -p ../res/snapp/combined
ls ../res/snapp/replicates/r??/eciton_w_theta.log > ../res/snapp/combined/logs.txt
ls ../res/snapp/replicates/r??/eciton.trees > ../res/snapp/combined/trees.txt
python3 logcombiner.py -n 2000 -b 10 ../res/snapp/combined/logs.txt ../res/snapp/combined/eciton.log
python3 logcombiner.py -n 2000 -b 10 ../res/snapp/combined/trees.txt ../res/snapp/combined/eciton.trees
