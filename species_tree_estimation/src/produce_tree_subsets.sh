# Michael Matschiner, 2016-05-15

# Produce subsets of 100 and 1000 trees from the combined posterior distribution of SNAPP analyses.
python3 logcombiner.py -n 100 -b 0 ../res/snapp/combined/ariidae.trees ../res/snapp/combined/ariidae_100.trees
python3 logcombiner.py -n 1000 -b 0 ../res/snapp/combined/ariidae.trees ../res/snapp/combined/ariidae_1000.trees
