# one\_on\_x\_prior\_test

#### Summary

The code in directory `scripts` was used to compare the performance of two different prior distributions for the Theta parameter of the multi-species coalescent model implemented in SNAPP.

#### Input
Result files in directory 'res/uniform' are identical to those of replicate r0001 in experiment 1, with root constraints and a data set size of 1,000 SNPs.

Result files in directory 'res/one_on_x' are generated with a modified version of SNAPP that allows one-on-x prior distributions for Theta ('res/one_on_x/SNAPP_mod'). This modification of SNAPP is limited to changes in file 'bin/SnAPPrior.java', which is part of SNAPP's source code. The original version of this file can be found on https://github.com/BEAST2-Dev/SNAPP/blob/master/src/snap/likelihood/SnAPPrior.java.

The same input file is used in both analyses with the exception that a different prior on Theta was used, a uniform prior distribution or a one-on-x prior distribution.

The mean ages resulting from both analyses are virtually identical, as a comparison of the MCC trees generated from the posterior tree distributions shows. For comparison, the true species tree is also provided ('data/trees/species_scaled.tre').