# m_matschiner Sun Oct 16 16:15:47 CEST 2016

# Combine log and trees files.
mkdir -p ../res/snapp/combined
ls ../res/snapp/replicates/r??/ariidae_w_theta.log > ../res/snapp/combined/logs.txt
ls ../res/snapp/replicates/r??/ariidae.trees > ../res/snapp/combined/trees.txt
python3 logcombiner.py -n 2000 -b 10 ../res/snapp/combined/logs.txt ../res/snapp/combined/ariidae.log
python3 logcombiner.py -n 2000 -b 10 ../res/snapp/combined/trees.txt ../res/snapp/combined/ariidae.trees
