# m_matschiner Thu Dec 14 13:46:08 CET 2017

# Make the analysis directory if it doesn't exist yet.
mkdir -p ../res/basta

# Copy beast and basta to the analysis directory.
cp ../bin/beast.jar ../res/basta
cp -r ../bin/BASTA ../res/basta

# Copy the input file to the analysis directory.
cp ../data/xml/ariidae_w_fossils.xml ../res/basta

# Navigate to the analysis directory.
cd ../res/basta

# Start the basta analysis.
java -jar -Dbeast.user.package.dir="." -Xmx4g beast.jar -threads 4 -seed 26435 ariidae_w_fossils.xml
