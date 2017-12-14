# m_matschiner Sun Dec 11 13:58:22 CET 2016

# Use TreeAnnotator to generate a maximum-clade-credibility summary tree for the stochastic mapping analysis.
java -jar ../bin/treeannotator.jar -heights mean ../analysis/stochastic_mapping/trees/ariidae_w_fossils_annotated_1000.trees ../analysis/stochastic_mapping/trees/ariidae_w_fossils_annotated_1000.tre

# Use TreeAnnotator to generate a maximum-clade-credibility summary tree for the basta analysis.
java -jar ../bin/treeannotator.jar -heights mean ../analysis/basta/ariidae_w_fossils.trees ../analysis/basta/trees/ariidae_w_fossils.tre
