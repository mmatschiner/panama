# m_matschiner Sun Oct 16 16:15:47 CEST 2016

# Combine log and trees files.
mkdir -p ../analysis/snapp/combined
ls ../analysis/snapp/replicates/r??/ariidae_w_theta.log > ../analysis/snapp/combined/logs.txt
ls ../analysis/snapp/replicates/r??/ariidae.trees > ../analysis/snapp/combined/trees.txt
python3 resources/logcombiner.py -n 2000 -b 10 ../analysis/snapp/combined/logs.txt ../analysis/snapp/combined/ariidae.log
python3 resources/logcombiner.py -n 2000 -b 10 ../analysis/snapp/combined/trees.txt ../analysis/snapp/combined/ariidae.trees
