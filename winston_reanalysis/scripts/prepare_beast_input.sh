# m_matschiner Sat Jan 14 12:17:53 CET 2017

# Use beauti.rb to generate an XML input file for BEAST based on the reduced version of the original alignment.
ruby resources/beauti.rb -id eciton_concatenated -n ../data/alignments/nexus -o ../data/xml -c ../data/constraints/constraints.xml -m GTR -g -t ../data/trees/starting.tre -l 200000

# Modify the scale and the weight of the operators on substitution rates.
cat ../data/xml/eciton_concatenated.xml | sed 's/scaleFactor=\"0.5\"/scaleFactor=\"0.9\"/g' | sed 's/weight=\"0.1\"/weight=\"1.0\"/g' > ../data/xml/tmp.xml
rm ../data/xml/eciton_concatenated.xml
mv ../data/xml/tmp.xml ../data/xml/eciton_concatenated.xml