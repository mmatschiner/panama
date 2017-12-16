# m_matschiner Tue Apr 5 12:34:21 CET 2016

# Make the analysis directory if it doesn't exist yet.
mkdir -p ../res/beast

# Copy the input file and BEAST 1.8.3 to the analysis directory.
cp ../bin/beast.jar ../res/beast
cp ../data/betancur_red.xml ../res/beast

# Move to the analysis directory.
cd ../res/beast

# Start the BEAST analysis.
java -jar beast.jar -seed 1459867942190 -threads 8 betancur_red.xml