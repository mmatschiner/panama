# m_matschiner Sat Nov 12 23:42:17 CET 2016

# Define the home directory.
home=`pwd`

# Change directory to the directory above all directories of analyses with root constraints.
cd ../res/beast/ex5/root

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
cd ../res/beast/ex5/young

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

# Change directory to the directory above all directories of analyses with root constraints and a population size of 200000.
cd ../res/beast/ex5/root_200000

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

# Change directory to the directory above all directories of analyses with root constraints and a population size of 800000.
cd ../res/beast/ex5/root_800000

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

