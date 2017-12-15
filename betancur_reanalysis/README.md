<!-- m_matschiner Fri Jan 6 11:06:14 CET 2017 -->

# betancur\_reanalysis

#### Summary

The code in directory `scripts` repeats the BEAST analysis of Betancur-R. et al. (2012) without the use of age constraints based on the closure of the Panamanian Isthmus.

#### Input

The XML input file for BEAST, `betancur_red.xml` (in directory `data`) is identical to the XML file provided by Betancur-R. et al. (2012) on Dryad ([BEAST\_file\_Ariidae.xml](http://datadryad.org/bitstream/handle/10255/dryad.36189/BEAST_file_Ariidae.xml)), except that three constraint based on the closure of the Panamanian Isthmus have been removed ("Panama\_Cathorops", "Panama\_Notarius", and "Panama\_Ariopsis").

#### How to run

To conduct this analysis, navigate into the `scripts` directory and run `bash run_all.sh`. This will conduct all steps of the analysis, including the BEAST analysis itself. It can be completed on a desktop computer, however, the analysis will require at least several days to complete.

#### Results

Final results can then be found in directory `analysis/beast`. The MCC tree will be in file `Ariidae_mcc.tre` and a posterior sample of 2000 trees will be in file `Ariidae_red.trees`. The same number of sampled parameter estimates will be in file `Ariidae_red.log`, which can be opened for a visual assessment of convergence in the software Tracer ([http://tree.bio.ed.ac.uk/software/tracer/](http://tree.bio.ed.ac.uk/software/tracer/)).

#### Requirements

The following software must be installed in order to run all scripts of directory `scripts`:

* `python3` (version 3.0 or later; [https://www.python.org/downloads/](https://www.python.org/downloads/))
* `java` (Java SE Development Kit 8; [http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html))

#### References

Betancur-R R, Ortí G, Stein AM, Marceniuk AP, Pyron RA (2012) Apparent signal of competition limiting diversification after ecological transitions from marine to freshwater habitats. Ecology Letters, 15, 822–830.