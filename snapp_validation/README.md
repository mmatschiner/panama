<!-- m_matschiner Fri Jan 6 12:29:40 CET 2017 -->

# snapp\_validation

#### Summary

The code in directory `scripts` simulates SNP data sets based on the multi-species coalescent process, and uses these data sets for divergence-time estimation with SNAPP and BEAST.

#### Input

No input is required for these analyses, as all data sets are simulated.

#### How to run

To conduct this reanalysis, navigate into the 'scripts' directory and run `bash run_all.sh`. Note however, that this script will quit after simulating SNP data sets and generating XML format input files for the analysis of these data sets with SNAPP (in directories `analysis/snapp/ex1` and `analysis/snapp/ex2`) and BEAST (in directory `analysis/beast/ex3`). SNAPP analyses will need to be conducted separately using the generated XML input files. How to run these analyses most efficiently will depend on the available computer resources, but the `start.slurm` and `resume.slurm` scripts in the analysis directories may be helpful as templates to execute SNAPP. The time required for convergence will vary substantially among SNAPP runs. Thus, runs will need to be resumed more or less often depending on how rapidly they converge. Once the SNAPP analyses have finished (which will require several weeks even if most can be parallelized), the remaining steps listed in file `run_all.sh` can be executed by copy-pasting the commands one by one to the command line. These steps should require several hours to few days on a desktop computer.

#### Results

Each of the directories `analysis/snapp/ex1`, `analysis/snapp/ex2`, and `analysis/beast/ex3` will hold the results for a large number of run replicates. For each set of 100 run replicates, these will be summarized in a directory called `summary` (e.g. `analysis/snapp/ex2/variants_corrected/summary`), including tables and SVG plots. In addition, plots comparing run statistics will be placed in directory `../analysis/snapp/ex1/combined` and a plot comparing BEAST and SNAPP results will be in `../analysis/combined`. Note that the total amount of data generated in this analysis will be around 13 GB.

#### Requirements

The following software must be installed in order to run all scripts of directory `scripts`:

* `python3` (version 3.0 or later including the "dendropy" library; [https://www.python.org/downloads/](https://www.python.org/downloads/))
* `ruby` (version 2.0 or later including the "fileutils" library; [https://www.ruby-lang.org/en/](https://www.ruby-lang.org/en/))
* `java` (Java SE Development Kit 8 or later; [http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html))
* `rscript` (version 3.1 or later including the "coda" and "phytools" libraries)