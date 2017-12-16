# m_matschiner Sat Jan 14 12:28:25 CET 2017

# Make five replicate directories if they don't exist yet.
for i in {1..5}
do
	mkdir -p ../res/beast/replicates/r0${i}
done

# Prepare slurm scripts in all analysis directories.
for i in ../res/beast/replicates/r??
do
	replicate_id=`basename ${i}`
	echo "#!/bin/bash" > ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "# Job name:" >> ${i}/start.slurm
	echo "#SBATCH --job-name=${replicate_id}" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Project:" >> ${i}/start.slurm
	echo "#SBATCH --account=nn9244k" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Wall clock limit:" >> ${i}/start.slurm
	echo "#SBATCH --time=160:00:00" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Processor and memory usage:" >> ${i}/start.slurm
	# echo "#SBATCH --ntasks-per-node=8" >> ${i}/start.slurm
	# echo "#SBATCH --nodes=1" >> ${i}/start.slurm
	# echo "#SBATCH --partition=accel" >> ${i}/start.slurm
	# echo "#SBATCH --gres=gpu:2" >> ${i}/start.slurm
	# echo "#SBATCH --mem-per-cpu=5G" >> ${i}/start.slurm
	echo "#SBATCH --mem-per-cpu=10G" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Outfile:" >> ${i}/start.slurm
	echo "#SBATCH --output=eciton_concatenated_out.txt" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Set up job environment:" >> ${i}/start.slurm
	echo "source /cluster/bin/jobsetup" >> ${i}/start.slurm
	# echo "module load beagle" >> ${i}/start.slurm
	# echo "module load beagle_gpu" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Copy input files to the work directory:" >> ${i}/start.slurm
	echo "cp eciton_concatenated.xml \$SCRATCH" >> ${i}/start.slurm
	echo "if [ -f \"eciton_concatenated.log\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp eciton_concatenated.log \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "if [ -f \"eciton_concatenated.trees\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp eciton_concatenated.trees \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "if [ -f \"eciton_concatenated.xml.state\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp eciton_concatenated.xml.state \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "cp beast.jar \$SCRATCH" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Run BEAST:" >> ${i}/start.slurm
	echo "cd \$SCRATCH" >> ${i}/start.slurm
	# echo "java -jar -Xmx4g beast.jar -threads 5 -seed ${RANDOM} -beagle -beagle_GPU eciton_concatenated.xml" >> ${i}/start.slurm
	echo "java -jar -Xmx10g beast.jar -threads 1 -seed ${RANDOM} eciton_concatenated.xml" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "# Copy files back to the submission directory:" >> ${i}/start.slurm
	echo "cp eciton_concatenated.* \$SUBMITDIR" >> ${i}/start.slurm
	cat ${i}/start.slurm | sed 's/threads 1/threads 1 -resume/g' > ${i}/resume.slurm
done

# Copy the BEAST jar file and the input files to the analysis directories.
for i in ../res/beast/replicates/r??
do
	cp ../bin/beast.jar ${i}
	cp ../data/xml/eciton_concatenated.xml ${i}
done
