# m_matschiner Sat Nov 12 23:38:42 CET 2016

# Add a start script and the BEAST jar file to each analysis directory.
for i in ../res/beast/ex5/*/r????
do
	echo "java -jar -Xmx1g beast.jar -threads 4 -seed ${RANDOM} beast.xml" > ${i}/start.sh
	cp ../bin/beast.jar $i
done
