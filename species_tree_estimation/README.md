<!-- m_matschiner Fri Jan 6 14:09:09 CET 2017 -->

# species\_tree\_estimation

#### Summary

The code in directory `scripts` performs a species tree analysis of SNP data for Neotropical sea catfishes.

#### Input

The SNP data generated for Neotropical sea catfishes can be found in file `ariidae.phy` in directory `data/alignments`. This data set contains 15308 SNPs genotyped for 26 specimens of 23 species. It was generated from sequence reads with the software STACK. Only a subset of the 15308 SNPs is used in SNAPP analyses, automatically selected with the script `snapp\_prep.rb` (in `scripts/resources`). In addition, three files are provided in the `data` directory that specify the assignment of specimens to species (file `species.txt` in `data/tables`), the constraints used for divergence-time estimation (file `constraints.txt` in `data/constraints`), and a starting tree that does not violate these constraints (file `starting.tre` in `data/trees`). The root constraint specified in `data/constraints` is based on the result of the reanalysis of the Betancur-R. et al. (2012) data set (see betancur\_reanalysis).

#### How to run

To conduct this reanalysis, navigate into the `scripts` directory and run `bash run_all.sh`. Note however, that this script will quit after generating XML format input files and preparing five replicate analysis directories for SNAPP (in `analysis/snapp/replicates`). SNAPP analyses will need to be conducted separately using the generated XML input files. How to run these analyses most efficiently will depend on the available computer resources, but the `start.slurm` and `resume.slurm` scripts in the three replicate analysis directories may be helpful as templates to execute SNAPP. A single analysis will sample 500000 MCMC iterations, but at least 1000000 iterations per replicate will be required for convergence, thus each analysis will need to be resumed at least once. For each replicate, around 1-2 weeks of run time will be required. Once the SNAPP analyses have finished, the remaining steps listed in file `run_all.sh` can be executed by copy-pasting the commands one by one to the command line. These steps should require only a few seconds.

#### Results

Final results can then be found in directory `analysis/snapp/combined`. The MCC species tree will be in file `ariidae.tre` and a posterior samples of 100 and 1000 trees will be in files `ariidae_100.trees` and `ariidae_1000.trees`. 10000 sampled parameter estimates will be in file `ariidae.log`, which can be opened for a visual assessment of convergence in the software Tracer ([http://tree.bio.ed.ac.uk/software/tracer/](http://tree.bio.ed.ac.uk/software/tracer/)).

#### Requirements

The following software must be installed in order to run all scripts of directory `scripts`:

* `python3` (version 3.0 or later; [https://www.python.org/downloads/](https://www.python.org/downloads/))
* `ruby` (version 2.0 or later; [https://www.ruby-lang.org/en/](https://www.ruby-lang.org/en/))
* `java` (Java SE Development Kit 8 or later; [http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html))

#### References

Betancur-R R, Ortí G, Stein AM, Marceniuk AP, Pyron RA (2012) Apparent signal of competition limiting diversification after ecological transitions from marine to freshwater habitats. Ecology Letters, 15, 822–830.