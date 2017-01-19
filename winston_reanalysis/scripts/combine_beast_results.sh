# m_matschiner Mon Dec 12 12:31:53 CET 2016

# Combine log and trees files for the analyses based on molecular data only.
mkdir -p ../analysis/beast/combined
ls ../analysis/beast/replicates/r??/eciton_concatenated.log > ../analysis/beast/combined/logs.txt
ls ../analysis/beast/replicates/r??/eciton_concatenated.trees > ../analysis/beast/combined/trees.txt
python3 ~/Software/Python/logcombiner.py -n 2000 -b 10 ../analysis/beast/combined/logs.txt ../analysis/beast/combined/eciton_concatenated.log
python3 ~/Software/Python/logcombiner.py -n 2000 -b 10 ../analysis/beast/combined/trees.txt ../analysis/beast/combined/eciton_concatenated.trees
