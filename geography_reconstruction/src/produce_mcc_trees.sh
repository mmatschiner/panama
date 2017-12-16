# m_matschiner Sun Dec 11 13:58:22 CET 2016

# Use TreeAnnotator to generate a maximum-clade-credibility summary tree for the stochastic mapping analysis.
java -jar ../bin/treeannotator.jar -heights mean ../res/stochastic_mapping/trees/ariidae_w_fossils_annotated_1000.trees ../res/stochastic_mapping/trees/ariidae_w_fossils_annotated_1000.tre

# Use TreeAnnotator to generate a maximum-clade-credibility summary tree for the basta analysis.
java -jar ../bin/treeannotator.jar -heights mean ../res/basta/ariidae_w_fossils.trees ../res/basta/trees/ariidae_w_fossils.tre
