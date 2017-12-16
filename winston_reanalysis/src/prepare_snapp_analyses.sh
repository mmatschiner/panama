# m_matschiner Mon Dec 12 00:52:04 CET 2016

# Generate input directories.
mkdir -p ../res/snapp/replicates
n_replicates=5
for ((i=1;i<=${n_replicates};i++));
do
	mkdir -p ../res/snapp/replicates/r0${i}
done

# Copy the XML file to analysis directories.
for i in ../res/snapp/replicates/r??
do
	cp ../data/xml/eciton.xml $i
done

# Copy resources to analysis directories.
for i in ../res/snapp/replicates/r??
do
	cp ../bin/beast.jar ${i}
	cp -r ../bin/SNAPP ${i}
done

# Prepare slurm scripts.
for i in ../res/snapp/replicates/r??
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
	echo "#SBATCH --time=168:00:00" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Processor and memory usage:" >> ${i}/start.slurm
	echo "#SBATCH --ntasks-per-node=12" >> ${i}/start.slurm
	echo "#SBATCH --nodes=1" >> ${i}/start.slurm
	echo "#SBATCH --mem-per-cpu=5G" >> ${i}/start.slurm
	echo "#" >> ${i}/start.slurm
	echo "# Outfile:" >> ${i}/start.slurm
	echo "#SBATCH --output=eciton_out.txt" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Set up job environment:" >> ${i}/start.slurm
	echo "source /cluster/bin/jobsetup" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Copy input files to the work directory:" >> ${i}/start.slurm
	echo "cp eciton.xml \$SCRATCH" >> ${i}/start.slurm
	echo "if [ -f \"eciton.log\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp eciton.log \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "if [ -f \"eciton.trees\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp eciton.trees \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "if [ -f \"eciton.xml.state\" ];" >> ${i}/start.slurm
	echo "then" >> ${i}/start.slurm
	echo "  cp eciton.xml.state \$SCRATCH" >> ${i}/start.slurm
	echo "fi" >> ${i}/start.slurm
	echo "cp beast.jar \$SCRATCH" >> ${i}/start.slurm
	echo "cp -r SNAPP \$SCRATCH" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "## Run BEAST:" >> ${i}/start.slurm
	echo "cd \$SCRATCH" >> ${i}/start.slurm
	echo "java -jar -Xmx4g beast.jar -threads 12 -seed ${RANDOM} eciton.xml" >> ${i}/start.slurm
	echo "" >> ${i}/start.slurm
	echo "# Copy files back to the submission directory:" >> ${i}/start.slurm
	echo "cp eciton* \$SUBMITDIR" >> ${i}/start.slurm
	cat ${i}/start.slurm | sed 's/threads 12/threads 12 -resume/g' > ${i}/resume.slurm
done
