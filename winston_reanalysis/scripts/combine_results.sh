# m_matschiner Mon Dec 12 12:31:53 CET 2016

# Combine log and trees files for the analyses based on molecular data only.
mkdir -p ../analysis/snapp/combined
ls ../analysis/snapp/replicates/r??/eciton_w_theta.log > ../analysis/snapp/combined/logs.txt
ls ../analysis/snapp/replicates/r??/eciton.trees > ../analysis/snapp/combined/trees.txt
python3 ~/Software/Python/logcombiner.py -n 2000 -b 10 ../analysis/snapp/combined/logs.txt ../analysis/snapp/combined/eciton.log
python3 ~/Software/Python/logcombiner.py -n 2000 -b 10 ../analysis/snapp/combined/trees.txt ../analysis/snapp/combined/eciton.trees
