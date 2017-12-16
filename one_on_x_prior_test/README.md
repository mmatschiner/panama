# one\_on\_x\_prior\_test

#### Summary

The code in directory `src` was used to compare the performance of two different prior distributions for the Theta parameter of the multi-species coalescent model implemented in SNAPP.

#### Input

The input files used in both analyses (`data/xml/snapp_one_on_x.xml` and `data/xml/snapp_uniform.xml`) are identical with the exception that a different prior on Theta was used, a uniform prior distribution or a one-on-x prior distribution. In addition, different names of output files are specified in both files. These input files are derived from the input file of replicate r0001, with a data set size of 1,000 SNPs and an age constraint on the root, in experiment 1 of the `snapp_validation` analysis.

#### How to run

To conduct this analysis, navigate into the `src` directory and run `bash run_all.sh`. This will replace the result files currently included in directory `res` and conduct all steps of the analysis. This analysis will take a few days to complete.

#### Results

Result files in directory `res/one_on_x` are generated with a modified version of SNAPP that allows one-on-x prior distributions for Theta (`bin/SNAPP_mod`). This modification of SNAPP is limited to changes in file `bin/SnAPPrior.java`, which is part of SNAPP's source code. The original version of this file can be found on [https://github.com/BEAST2-Dev/SNAPP/blob/master/src/snap/likelihood/SnAPPrior.java](https://github.com/BEAST2-Dev/SNAPP/blob/master/src/snap/likelihood/SnAPPrior.java).

The mean ages resulting from both analyses are virtually identical, as a comparison of the MCC trees generated from the posterior tree distributions shows. For comparison, the true species tree is also provided (`data/trees/species_scaled.tre`).

#### Requirements

The following software must be installed in order to run all scripts of directory `src`:

* `java` (Java SE Development Kit 8; [http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html))