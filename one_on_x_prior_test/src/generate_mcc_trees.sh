# m_matschiner Wed Dec 13 12:41:57 CET 2017

# Use TreeAnnotator to generate a maximum clade credibility tree.
java -jar ../bin/treeannotator.jar -burnin 10 -heights mean ../res/one_on_x/snapp_one_on_x.trees ../res/one_on_x/snapp_one_on_x.tre 2> /dev/null
java -jar ../bin/treeannotator.jar -burnin 10 -heights mean ../res/uniform/snapp_uniform.trees ../res/uniform/snapp_uniform.tre 2> /dev/null