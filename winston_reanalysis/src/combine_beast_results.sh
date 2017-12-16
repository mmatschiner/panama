# m_matschiner Mon Dec 12 12:31:53 CET 2016

# Combine log and trees files for the analyses based on molecular data only.
mkdir -p ../res/beast/combined
ls ../res/beast/replicates/r??/eciton_concatenated.log > ../res/beast/combined/logs.txt
ls ../res/beast/replicates/r??/eciton_concatenated.trees > ../res/beast/combined/trees.txt
python3 logcombiner.py -n 2000 -b 10 ../res/beast/combined/logs.txt ../res/beast/combined/eciton_concatenated.log
python3 logcombiner.py -n 2000 -b 10 ../res/beast/combined/trees.txt ../res/beast/combined/eciton_concatenated.trees
