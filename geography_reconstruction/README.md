<!-- m_matschiner Fri Jan 6 14:31:38 CET 2017 -->

# geography\_reconstruction

#### Summary

The code in directory `scripts` uses stochastic character mapping and the structured coalescent model to reconstruct the ancestral geography of Neotropical sea catfishes.

#### Input

The posterior set of 1000 trees resulting from species-tree estimation (see species\_tree\_estimation) is used as input for the stochastic-mapping analysis (`ariidae_1000.trees` in `data/trees`). The same analysis also requires a file specifying the order of taxa in the generated plot (`species_order.txt`) and a table assigning geography to terminal taxa (`geography.txt`), which are included in directory `data/tables`. For comparison, geographic reconstruction is also conducted with the structured coalescent model implement in the BASTA package for BEAST, the XML input file for this analysis (`ariidae_w_fossils.xml`) is included in `data/xml`.

#### How to run

To conduct this reanalysis, navigate into the `scripts` directory and run `bash run_all.sh`.

#### Results

The stochastic-mapping part of the analysis will generate a plot showing the posterior species-tree distribution in form of a cloudogram, with branch color according to character mapping, which will be written to `ariidae_w_fossils_mapped_1000.svg` in directory `analysis/trees`. The same directory will also contain a file in Nexus format for the posterior tree distribution with mapped characters (`ariidae_w_fossils_annotated_1000.trees`) and an MCC tree generated from this distribution (`ariidae_w_fossils_annotated_1000.tre`). Lists with migration times will be written to directory `analysis/stochastic_mapping/tables`.

The analysis with the structured coalescent model, implemented in BASTA, will generate two file in Nexus format, for the posterior tree distribution (`ariidae_w_fossils.trees`) and the annotated MCC tree summarizing this distribution (`ariidae_w_fossils.tre`). Both of these files will be written to directory `analysis/basta`.

#### Requirements

The following software must be installed in order to run all scripts of directory `scripts`:

* `ruby` (version 2.0 or later; [https://www.ruby-lang.org/en/](https://www.ruby-lang.org/en/))
* `java` (Java SE Development Kit 8; [http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html))
* `rscript` (R environment version 3.1 or later including the "ape", "phytools", and "methods" libraries; [https://www.r-project.org](https://www.r-project.org))