# m_matschiner Fri Sep 23 00:43:50 CEST 2016

# Copy resources to analysis directories.
for i in ../res/snapp/ex?/*/*/r????
do
	cp ../bin/beast.jar ${i}
	cp -r ../bin/SNAPP ${i}
done

# Prepare slurm scripts in all analysis directories.
for i in ../res/snapp/ex?/*/r????
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
	echo "#SBATCH --ntasks-per-node=5" >> ${i}/start.slurm
	echo "#SBATCH --nodes=1" >> ${i}/start.slurm
	echo "#SBATCH --mem-per-cpu=5G" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Outfile:" >> ${i}/start.slurm
	echo "#SBATCH --output=snapp_out.txt" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Set up job environment:" >> ${i}/start.slurm
	echo "source /cluster/bin/jobsetup" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Copy input files to the work directory:" >> ${i}/start.slurm
	echo "cp snapp.xml \$SCRATCH" >> ${i}/start.slurm
	echo "if [ -f \"snapp.log\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp snapp.log \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "if [ -f \"snapp.trees\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp snapp.trees \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "if [ -f \"snapp.xml.state\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp snapp.xml.state \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "cp beast.jar \$SCRATCH" >> ${i}/start.slurm
	echo "cp -r SNAPP \$SCRATCH" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Run BEAST:" >> ${i}/start.slurm
	echo "cd \$SCRATCH" >> ${i}/start.slurm
	echo "java -jar -Xmx4g beast.jar -threads 4 -seed ${RANDOM} snapp.xml" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "# Copy files back to the submission directory:" >> ${i}/start.slurm
	echo "cp snapp.* \$SUBMITDIR" >> ${i}/start.slurm
	cat ${i}/start.slurm | sed 's/threads 4/threads 4 -resume/g' > ${i}/resume.slurm
done
