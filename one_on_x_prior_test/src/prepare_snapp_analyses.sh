# m_matschiner Thu Dec 14 15:52:06 CET 2017

# Make the result directories if these don't exist yet.
mkdir -p ../res/one_on_x
mkdir -p ../res/uniform

# Copy beast, the unmodified SNAPP package, and the modified SNAPP package to the analysis directories.
cp ../bin/beast.jar ../res/one_on_x
cp ../bin/beast.jar ../res/uniform
cp -r ../bin/SNAPP_mod ../res/one_on_x
cp -r ../bin/SNAPP ../res/uniform

# Copy input files to the analysis directories.
cp ../data/xml/snapp_one_on_x.xml ../res/one_on_x
cp ../data/xml/snapp_uniform ../res/uniform