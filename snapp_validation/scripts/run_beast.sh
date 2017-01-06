# m_matschiner Sat Nov 12 23:42:17 CET 2016

# Define the home directory.
home=`pwd`

# Change directory to the directory above all directories of analyses with root constraints.
cd ../analysis/beast/ex3/root

# Run BEAST with each of the 100 datasets.
for i in r????
do
	cd $i
	bash start.sh
	rm beast.jar
	cd ..
done

# Go back to the home directory.
cd $home

# Change directory to the directory above all directories of analyses with root constraints.
cd ../analysis/beast/ex3/young

# Run BEAST with each of the 100 datasets.
for i in r????
do
	cd $i
	bash start.sh
	rm beast.jar
	cd ..
done

# Go back to the home directory.
cd $home